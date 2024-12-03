defmodule PlutoWeb.RevenueLive.FormComponent do
  use PlutoWeb, :live_component

  alias Pluto.Timeline
  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use este formulário para gerenciar os registros de receita em seu banco de dados.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="revenue-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.input field={@form[:price]} type="number" label="Price" />
        <.input field={@form[:date_added]} type="date" label="Date Added" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Revenue</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end


  @impl true
  def update(%{revenue: revenue} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Timeline.change_revenue(revenue))
     end)}
  end

  @impl true
  def handle_event("validate", %{"revenue" => revenue_params}, socket) do
    changeset = Timeline.change_revenue(socket.assigns.revenue, revenue_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"revenue" => revenue_params}, socket) do
    save_revenue(socket, socket.assigns.action, revenue_params)
  end

  defp save_revenue(socket, :edit, revenue_params) do
    case Timeline.update_revenue(socket.assigns.revenue, revenue_params) do
      {:ok, revenue} ->
        notify_parent({:saved, revenue})

        {:noreply,
         socket
         |> put_flash(:info, "Revenue updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_revenue(socket, :new, revenue_params) do
    case Timeline.create_revenue(revenue_params) do
      {:ok, revenue} ->
        notify_parent({:saved, revenue})

        {:noreply,
         socket
         |> put_flash(:info, "Revenue created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end

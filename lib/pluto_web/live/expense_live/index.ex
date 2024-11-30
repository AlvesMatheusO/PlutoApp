defmodule PlutoWeb.ExpenseLive.Index do
  use PlutoWeb, :live_view

  alias Pluto.Timeline
  alias Pluto.Timeline.Expense

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :expenses, Timeline.list_expenses())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Expense")
    |> assign(:expense, Timeline.get_expense!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Expense")
    |> assign(:expense, %Expense{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Expenses")
    |> assign(:expense, nil)
  end

  @impl true
  def handle_info({PlutoWeb.ExpenseLive.FormComponent, {:saved, expense}}, socket) do
    {:noreply, stream_insert(socket, :expenses, expense)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    expense = Timeline.get_expense!(id)
    {:ok, _} = Timeline.delete_expense(expense)

    {:noreply, stream_delete(socket, :expenses, expense)}
  end
end

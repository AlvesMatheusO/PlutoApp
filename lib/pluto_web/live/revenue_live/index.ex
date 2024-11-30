defmodule PlutoWeb.RevenueLive.Index do
  use PlutoWeb, :live_view

  alias Pluto.Timeline
  alias Pluto.Timeline.Revenue

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :revenues, Timeline.list_revenues())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Revenue")
    |> assign(:revenue, Timeline.get_revenue!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Revenue")
    |> assign(:revenue, %Revenue{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Revenues")
    |> assign(:revenue, nil)
  end

  @impl true
  def handle_info({PlutoWeb.RevenueLive.FormComponent, {:saved, revenue}}, socket) do
    {:noreply, stream_insert(socket, :revenues, revenue)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    revenue = Timeline.get_revenue!(id)
    {:ok, _} = Timeline.delete_revenue(revenue)

    {:noreply, stream_delete(socket, :revenues, revenue)}
  end
end

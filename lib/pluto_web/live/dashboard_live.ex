defmodule PlutoWeb.DashboardLive do
  use PlutoWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="dashboard-container flex justify-center items-center h-screen">
      <div class="grid grid-cols-1 gap-16 sm:grid-cols-2 w-full max-w-4xl">
        <div class="card cursor-pointer p-16 bg-blue-500 text-white rounded-lg shadow-lg hover:bg-blue-600 transition-transform transform hover:scale-105" phx-click="navigate_to_revenues">
          <h2 class="text-3xl font-bold mb-6">Receitas</h2>
          <p class="text-xl">Gerencie suas receitas</p>
        </div>
        <div class="card cursor-pointer p-16 bg-green-500 text-white rounded-lg shadow-lg hover:bg-green-600 transition-transform transform hover:scale-105" phx-click="navigate_to_expenses">
          <h2 class="text-3xl font-bold mb-6">Despesas</h2>
          <p class="text-xl">Gerencie suas despesas</p>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("navigate_to_revenues", _, socket) do
    {:noreply, redirect(socket, to: "/revenues")}
  end

  def handle_event("navigate_to_expenses", _, socket) do
    {:noreply, redirect(socket, to: "/expenses")}
  end
end

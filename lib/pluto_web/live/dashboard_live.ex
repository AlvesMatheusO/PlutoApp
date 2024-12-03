defmodule PlutoWeb.DashboardLive do
  use PlutoWeb, :live_view

  alias Pluto.Timeline

  @impl true
  def mount(_params, _session, socket) do
    # Obtendo as receitas e despesas totais
    total_revenues = Timeline.get_total_revenues()
    total_expenses = Timeline.get_total_expenses()

    # Obtendo receitas e despesas agrupadas por mês
    revenues_by_month = Timeline.get_revenues_by_month()
    expenses_by_month = Timeline.get_expenses_by_month()

    {:ok,
     assign(socket,
       total_revenues: total_revenues,
       total_expenses: total_expenses,
       revenues_by_month: revenues_by_month,
       expenses_by_month: expenses_by_month
     )}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="dashboard-container flex flex-col items-center min-h-screen p-8">
      <!-- Cartões para navegar entre receitas e despesas -->
      <div class="grid grid-cols-1 gap-16 sm:grid-cols-2 w-full max-w-4xl mb-8">
        <div
          class="card cursor-pointer p-16 bg-blue-500 text-white rounded-lg shadow-lg hover:bg-blue-600 transition-transform transform hover:scale-105"
          phx-click="navigate_to_revenues"
        >
          <h2 class="text-3xl font-bold mb-6">Receitas</h2>
          <p class="text-xl">Gerencie suas receitas</p>
        </div>
        <div
          class="card cursor-pointer p-16 bg-green-500 text-white rounded-lg shadow-lg hover:bg-green-600 transition-transform transform hover:scale-105"
          phx-click="navigate_to_expenses"
        >
          <h2 class="text-3xl font-bold mb-6">Despesas</h2>
          <p class="text-xl">Gerencie suas despesas</p>
        </div>
      </div>

      <!-- Gráfico de linha de receitas e despesas por mês -->
      <div id="line-chart-container" class="chart-container w-full max-w-4xl mx-auto mb-8" phx-hook="ExpenseChartHook" data-revenues-by-month={Jason.encode!(@revenues_by_month)} data-expenses-by-month={Jason.encode!(@expenses_by_month)}>
        <h2 class="text-2xl font-bold mb-4 text-center">Receitas e Despesas por Mês</h2>
        <canvas id="monthlyRevenueExpenseChart"></canvas>
      </div>

      <!-- Gráfico de pizza de distribuição de receitas e despesas -->
      <div id="pie-chart-container" class="chart-container w-full max-w-3xl mx-auto" phx-hook="RevenueExpensePieChartHook" data-total-revenues={@total_revenues} data-total-expenses={@total_expenses}>
        <h2 class="text-2xl font-bold mb-4 text-center">Distribuição de Receitas e Despesas</h2>
        <canvas id="revenueExpensePieChart"></canvas>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("navigate_to_revenues", _, socket) do
    {:noreply, redirect(socket, to: "/revenues")}
  end

  @impl true
  def handle_event("navigate_to_expenses", _, socket) do
    {:noreply, redirect(socket, to: "/expenses")}
  end
end

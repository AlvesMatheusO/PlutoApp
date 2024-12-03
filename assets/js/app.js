// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import topbar from "../vendor/topbar"
import Chart from "chart.js/auto"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")

// Definindo os hooks
let Hooks = {};

// Hook para o gráfico de receitas e despesas por mês (gráfico de linha)
Hooks.ExpenseChartHook = {
  mounted() {
    // Obtendo o valor do número de receitas e despesas por mês
    const revenuesByMonth = JSON.parse(this.el.dataset.revenuesByMonth);
    const expensesByMonth = JSON.parse(this.el.dataset.expensesByMonth);

    const monthNames = [
      "Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho",
      "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"
    ];

    const labels = Object.keys(revenuesByMonth).map(month => monthNames[month - 1]);
    const revenuesData = Object.values(revenuesByMonth);
    const expensesData = Object.values(expensesByMonth);

    // Criando o gráfico de receitas e despesas por mês
    var ctx = document.getElementById('monthlyRevenueExpenseChart').getContext('2d');
    new Chart(ctx, {
      type: 'line',
      data: {
        labels: labels,
        datasets: [
          {
            label: 'Total de Receitas por Mês',
            data: revenuesData,
            fill: false,
            borderColor: 'rgba(54, 162, 235, 1)',
            tension: 0.1
          },
          {
            label: 'Total de Despesas por Mês',
            data: expensesData,
            fill: false,
            borderColor: 'rgba(255, 99, 132, 1)',
            tension: 0.1
          }
        ]
      },
      options: {
        responsive: true,
        maintainAspectRatio: true,
        scales: {
          x: {
            title: {
              display: true,
              text: 'Meses'
            }
          },
          y: {
            title: {
              display: true,
              text: 'Valor Total'
            },
            beginAtZero: true
          }
        }
      }
    });
  }
};

// Hook para o gráfico de pizza de receitas e despesas
Hooks.RevenueExpensePieChartHook = {
  mounted() {
    // Obtendo os valores de receitas e despesas do elemento HTML
    const totalRevenues = parseFloat(this.el.dataset.totalRevenues);
    const totalExpenses = parseFloat(this.el.dataset.totalExpenses);

    // Criando o gráfico de pizza
    var ctx = document.getElementById('revenueExpensePieChart').getContext('2d');
    new Chart(ctx, {
      type: 'pie',
      data: {
        labels: ['Receitas', 'Despesas'],
        datasets: [{
          label: 'Distribuição de Receitas e Despesas',
          data: [totalRevenues, totalExpenses],
          backgroundColor: [
            'rgba(54, 162, 235, 0.6)',  // Cor para Receitas
            'rgba(255, 99, 132, 0.6)'    // Cor para Despesas
          ],
          borderColor: [
            'rgba(54, 162, 235, 1)',
            'rgba(255, 99, 132, 1)'
          ],
          borderWidth: 1
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: true,
        plugins: {
          legend: {
            position: 'top'
          },
          tooltip: {
            callbacks: {
              label: function(context) {
                let value = context.raw;
                return `${context.label}: ${value.toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' })}`;
              }
            }
          }
        }
      }
    });
  }
};

// Criando a instância do LiveSocket e adicionando os hooks
let liveSocket = new LiveSocket("/live", Socket, {
  hooks: Hooks,
  longPollFallbackMs: 2500,
  params: { _csrf_token: csrfToken }
})

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" })
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

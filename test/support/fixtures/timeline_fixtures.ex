defmodule Pluto.TimelineFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pluto.Timeline` context.
  """

  @doc """
  Generate a revenue.
  """
  def revenue_fixture(attrs \\ %{}) do
    {:ok, revenue} =
      attrs
      |> Enum.into(%{
        description: "some description",
        price: 42,
        title: "some title"
      })
      |> Pluto.Timeline.create_revenue()

    revenue
  end

  @doc """
  Generate a expense.
  """
  def expense_fixture(attrs \\ %{}) do
    {:ok, expense} =
      attrs
      |> Enum.into(%{
        description: "some description",
        price: 42,
        title: "some title"
      })
      |> Pluto.Timeline.create_expense()

    expense
  end
end

defmodule Pluto.TimelineTest do
  use Pluto.DataCase

  alias Pluto.Timeline

  describe "revenues" do
    alias Pluto.Timeline.Revenue

    import Pluto.TimelineFixtures

    @invalid_attrs %{description: nil, title: nil, price: nil}

    test "list_revenues/0 returns all revenues" do
      revenue = revenue_fixture()
      assert Timeline.list_revenues() == [revenue]
    end

    test "get_revenue!/1 returns the revenue with given id" do
      revenue = revenue_fixture()
      assert Timeline.get_revenue!(revenue.id) == revenue
    end

    test "create_revenue/1 with valid data creates a revenue" do
      valid_attrs = %{description: "some description", title: "some title", price: 42}

      assert {:ok, %Revenue{} = revenue} = Timeline.create_revenue(valid_attrs)
      assert revenue.description == "some description"
      assert revenue.title == "some title"
      assert revenue.price == 42
    end

    test "create_revenue/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Timeline.create_revenue(@invalid_attrs)
    end

    test "update_revenue/2 with valid data updates the revenue" do
      revenue = revenue_fixture()
      update_attrs = %{description: "some updated description", title: "some updated title", price: 43}

      assert {:ok, %Revenue{} = revenue} = Timeline.update_revenue(revenue, update_attrs)
      assert revenue.description == "some updated description"
      assert revenue.title == "some updated title"
      assert revenue.price == 43
    end

    test "update_revenue/2 with invalid data returns error changeset" do
      revenue = revenue_fixture()
      assert {:error, %Ecto.Changeset{}} = Timeline.update_revenue(revenue, @invalid_attrs)
      assert revenue == Timeline.get_revenue!(revenue.id)
    end

    test "delete_revenue/1 deletes the revenue" do
      revenue = revenue_fixture()
      assert {:ok, %Revenue{}} = Timeline.delete_revenue(revenue)
      assert_raise Ecto.NoResultsError, fn -> Timeline.get_revenue!(revenue.id) end
    end

    test "change_revenue/1 returns a revenue changeset" do
      revenue = revenue_fixture()
      assert %Ecto.Changeset{} = Timeline.change_revenue(revenue)
    end
  end
end

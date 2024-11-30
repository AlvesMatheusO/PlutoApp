defmodule PlutoWeb.RevenueLiveTest do
  use PlutoWeb.ConnCase

  import Phoenix.LiveViewTest
  import Pluto.TimelineFixtures

  @create_attrs %{description: "some description", title: "some title", price: 42}
  @update_attrs %{description: "some updated description", title: "some updated title", price: 43}
  @invalid_attrs %{description: nil, title: nil, price: nil}

  defp create_revenue(_) do
    revenue = revenue_fixture()
    %{revenue: revenue}
  end

  describe "Index" do
    setup [:create_revenue]

    test "lists all revenues", %{conn: conn, revenue: revenue} do
      {:ok, _index_live, html} = live(conn, ~p"/revenues")

      assert html =~ "Listing Revenues"
      assert html =~ revenue.description
    end

    test "saves new revenue", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/revenues")

      assert index_live |> element("a", "New Revenue") |> render_click() =~
               "New Revenue"

      assert_patch(index_live, ~p"/revenues/new")

      assert index_live
             |> form("#revenue-form", revenue: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#revenue-form", revenue: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/revenues")

      html = render(index_live)
      assert html =~ "Revenue created successfully"
      assert html =~ "some description"
    end

    test "updates revenue in listing", %{conn: conn, revenue: revenue} do
      {:ok, index_live, _html} = live(conn, ~p"/revenues")

      assert index_live |> element("#revenues-#{revenue.id} a", "Edit") |> render_click() =~
               "Edit Revenue"

      assert_patch(index_live, ~p"/revenues/#{revenue}/edit")

      assert index_live
             |> form("#revenue-form", revenue: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#revenue-form", revenue: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/revenues")

      html = render(index_live)
      assert html =~ "Revenue updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes revenue in listing", %{conn: conn, revenue: revenue} do
      {:ok, index_live, _html} = live(conn, ~p"/revenues")

      assert index_live |> element("#revenues-#{revenue.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#revenues-#{revenue.id}")
    end
  end

  describe "Show" do
    setup [:create_revenue]

    test "displays revenue", %{conn: conn, revenue: revenue} do
      {:ok, _show_live, html} = live(conn, ~p"/revenues/#{revenue}")

      assert html =~ "Show Revenue"
      assert html =~ revenue.description
    end

    test "updates revenue within modal", %{conn: conn, revenue: revenue} do
      {:ok, show_live, _html} = live(conn, ~p"/revenues/#{revenue}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Revenue"

      assert_patch(show_live, ~p"/revenues/#{revenue}/show/edit")

      assert show_live
             |> form("#revenue-form", revenue: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#revenue-form", revenue: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/revenues/#{revenue}")

      html = render(show_live)
      assert html =~ "Revenue updated successfully"
      assert html =~ "some updated description"
    end
  end
end

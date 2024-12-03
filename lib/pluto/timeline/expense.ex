defmodule Pluto.Timeline.Expense do
  use Ecto.Schema
  import Ecto.Changeset

  schema "expenses" do
    field :title, :string
    field :description, :string
    field :price, :integer
    field :date_added, :date

    timestamps()
  end

  def changeset(expense, attrs) do
    expense
    |> cast(attrs, [:title, :description, :price, :date_added])
    |> validate_required([:title, :description, :price, :date_added])
  end
end

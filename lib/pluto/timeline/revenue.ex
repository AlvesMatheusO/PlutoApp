defmodule Pluto.Timeline.Revenue do
  use Ecto.Schema
  import Ecto.Changeset

  schema "revenues" do
    field :title, :string
    field :description, :string
    field :price, :integer
    field :date_added, :date

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(revenue, attrs) do
    revenue
    |> cast(attrs, [:title, :description, :price, :date_added])
    |> validate_required([:title, :price, :date_added])
  end
end

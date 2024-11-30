defmodule Pluto.Timeline.Revenue do
  use Ecto.Schema
  import Ecto.Changeset

  schema "revenues" do
    field :description, :string
    field :title, :string
    field :price, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(revenue, attrs) do
    revenue
    |> cast(attrs, [:title, :description, :price])
    |> validate_required([:title, :description, :price])
  end
end

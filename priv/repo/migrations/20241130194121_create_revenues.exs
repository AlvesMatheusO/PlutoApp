defmodule Pluto.Repo.Migrations.CreateRevenues do
  use Ecto.Migration

  def change do
    create table(:revenues) do
      add :title, :string
      add :description, :string
      add :price, :integer

      timestamps(type: :utc_datetime)
    end
  end
end

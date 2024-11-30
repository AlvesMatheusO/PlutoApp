defmodule Pluto.Repo.Migrations.CreateExpenses do
  use Ecto.Migration

  def change do
    create table(:expenses) do
      add :title, :string
      add :description, :string
      add :price, :integer

      timestamps(type: :utc_datetime)
    end
  end
end

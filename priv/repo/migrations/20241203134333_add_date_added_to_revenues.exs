defmodule Pluto.Repo.Migrations.AddDateAddedToRevenues do
  use Ecto.Migration

  def change do
    alter table(:revenues) do
      add :date_added, :date
    end
  end
end

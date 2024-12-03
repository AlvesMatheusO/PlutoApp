defmodule Pluto.Repo.Migrations.AddDateAddedToExpenses do
  use Ecto.Migration

  def change do
    alter table(:expenses) do
      add :date_added, :date
    end
  end
end

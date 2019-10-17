defmodule Division.Repo.Migrations.CreateNodes do
  use Ecto.Migration

  def change do
    create table(:nodes) do
      add :name, :string
      add :type, :string

      timestamps()
    end

    create unique_index(:nodes, [:name])
    create index(:nodes, [:type])
  end
end

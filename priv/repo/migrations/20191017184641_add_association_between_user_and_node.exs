defmodule Division.Repo.Migrations.AddAssociationBetweenUserAndNode do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :node_id, references(:nodes, on_delete: :nothing)
    end

    create index(:user, [:node_id])
  end
end

defmodule Division.Repo.Migrations.AddProducerAndConsumerAssociationsToMessage do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      add :producer_id, references(:nodes, on_delete: :nothing)
      add :consumer_id, references(:nodes, on_delete: :nothing)
    end

    create index(:messages, [:producer_id])
    create index(:messages, [:consumer_id])
  end
end

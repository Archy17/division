defmodule Division.Repo.Migrations.AddPgIndex do
  use Ecto.Migration

  def change do
    create index("messages", [:inserted_at, :id])
  end
end

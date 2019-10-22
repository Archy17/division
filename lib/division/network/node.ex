defmodule Division.Network.Node do
  use Ecto.Schema
  import Ecto.Changeset

  schema "nodes" do
    field :name, :string
    field :type, :string

    timestamps()
  end

  @doc false
  def changeset(node, attrs) do
    node
    |> cast(attrs, [:name, :type])
    |> validate_required([:name, :type])
    # |> validate_length(:name, min: 9)
  end
end

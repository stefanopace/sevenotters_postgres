defmodule SevenottersPostgres.Schema.Snapshot do
  @moduledoc """
  Sanpshot schema persistence.
  """

  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @type t :: __MODULE__

  schema "snapshots" do
    field(:correlation_id, :string)
    field(:snapshot, :map)
  end

  @fields [:correlation_id, :snapshot]
  @required [:correlation_id, :snapshot]

  @spec changeset(map, map) :: Ecto.Changeset.t()
  def changeset(snapshot, attributes \\ %{}) do
    snapshot
    |> cast(attributes, @fields)
    |> validate_required(@required)
  end

  #
  # Privates
  #
end

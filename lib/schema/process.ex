defmodule SevenottersPostgres.Schema.Process do
  @moduledoc """
  Process schema persistence.
  """

  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @type t :: __MODULE__

  schema "processes" do
    field(:process_id, :string)
    field(:status, :string)
    field(:state, :map)
  end

  @fields [:process_id, :status, :state]
  @required [:process_id, :status, :state]

  @spec changeset(map, map) :: Ecto.Changeset.t()
  def changeset(process, attributes \\ %{}) do
    process
    |> cast(attributes, @fields)
    |> validate_required(@required)
  end

  #
  # Privates
  #
end

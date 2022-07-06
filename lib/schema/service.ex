defmodule SevenottersPostgres.Schema.Service do
  @moduledoc """
  Service schema persistence.
  """

  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @type t :: __MODULE__

  schema "services" do
    field(:server_name, :string)
    field(:state, :map)

    timestamps(type: :naive_datetime_usec, updated_at: false)
  end

  @fields [:server_name, :state]
  @required [:server_name, :state]

  @spec changeset(map, map) :: Ecto.Changeset.t()
  def changeset(service, attributes \\ %{}) do
    service
    |> cast(attributes, @fields)
    |> validate_required(@required)
  end

  #
  # Privates
  #
end

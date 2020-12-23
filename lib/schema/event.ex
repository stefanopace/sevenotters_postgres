defmodule SevenottersPostgres.Schema.Event do
  @moduledoc """
  Event schema persistence.
  """

  use Ecto.Schema

  import Ecto.Changeset

  @type t :: __MODULE__

  @primary_key false
  schema "events" do
    field(:counter, :integer, primary_key: true)
    field(:type, :string)
    field(:request_id, :string)
    field(:process_id, :string)
    field(:correlation_id, :string)
    field(:correlation_module, SevenottersPostgres.Schema.Atom)
    field(:date, :naive_datetime)
    field(:payload, :map)
  end

  @fields [
    :counter,
    :type,
    :request_id,
    :process_id,
    :correlation_id,
    :correlation_module,
    :date,
    :payload
  ]
  @required [:counter, :type, :request_id, :correlation_module, :date, :payload]

  @spec changeset(map, map) :: Ecto.Changeset.t()
  def changeset(event, attributes \\ %{}) do
    event
    |> cast(attributes, @fields)
    |> validate_required(@required)
    |> validate_length(:type, max: 255)
    |> validate_length(:request_id, max: 255)
    |> validate_length(:process_id, max: 255)
    |> validate_length(:correlation_id, max: 255)
  end

  #
  # Privates
  #
end

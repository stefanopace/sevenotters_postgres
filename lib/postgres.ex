defmodule SevenottersPostgres.Storage do
  @moduledoc false

  require Logger
  #  @behaviour Seven.Data.PersistenceBehaviour

  alias SevenottersPostgres.Repo
  alias SevenottersPostgres.Schema.{Event, Process}
  import Ecto.Query

  @id_regex ~r/^[A-Fa-f0-9\-]{24}$/

  def start_link(opts \\ []) do
    Logger.info("Persistence is PostgreSQL")
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_opts), do: {:ok, nil}

  @spec initialize() :: any
  def initialize(), do: nil

  @spec insert_event(map) :: any
  def insert_event(event) do
    {:ok, e} = %Event{} |> Event.changeset(event) |> Repo.insert()
    e
  end

  @spec upsert_process(bitstring, map) :: any
  def upsert_process(process_id, state) do
    value = %{process_id: process_id, status: state.status, state: state}

    %Process{}
    |> Process.changeset(value)
    |> Repo.insert(
      on_conflict: {:replace, [:status, :state]},
      conflict_target: :process_id,
      returning: true
    )
  end

  @spec get_process(bitstring) :: map | nil
  def get_process(process_id) do
    case Repo.get_by(Process, process_id: process_id) do
      nil -> nil
      %{state: state} -> state |> atomize()
    end
  end

  @spec new_id :: any
  def new_id, do: UUID.uuid4()

  @spec new_printable_id :: bitstring
  def new_printable_id, do: new_id()

  @spec printable_id(any) :: bitstring
  def printable_id(id) when is_bitstring(id), do: id

  @spec object_id(bitstring) :: any
  def object_id(id), do: id

  @spec is_valid_id?(any) :: boolean
  def is_valid_id?(id) when is_bitstring(id), do: Regex.match?(@id_regex, id)

  @spec max_counter_in_events() :: integer
  def max_counter_in_events() do
    Event |> Repo.aggregate(:max, :counter) |> calculate_max()
  end

  @spec events() :: [map]
  def events(), do: Repo.all(Event)

  @spec processes() :: [map]
  def processes(), do: Repo.all(Process)

  @spec events_by_correlation_id(bitstring, integer) :: any
  def events_by_correlation_id(correlation_id, after_counter) do
    from(e in Event,
      where: e.correlation_id == ^correlation_id and e.counter > ^after_counter,
      order_by: [asc: :counter]
    )
  end

  @spec event_by_id(bitstring) :: map
  def event_by_id(id), do: Repo.get(Event, id) |> atomize()

  @spec events_by_types([bitstring], integer) :: any
  def events_by_types(types, after_counter) do
    from(e in Event,
      where: e.type in ^types and e.counter > ^after_counter,
      order_by: [asc: :counter]
    )
  end

  @spec drop_events() :: any
  def drop_events() do
    unless Mix.env() == :prod do
      Repo.delete_all(Event)
    end
  end

  @spec drop_processes() :: any
  def drop_processes() do
    unless Mix.env() == :prod do
      Repo.delete_all(Process)
    end
  end

  @callback processes_id_by_status(bitstring) :: any
  def processes_id_by_status(status) do
    q =
      from(p in Process,
        where: p.status == ^status,
        select: p.process_id
      )

    Repo.all(q)
  end

  @callback stream_to_list(any) :: [map]
  def stream_to_list(stream) do
    Repo.all(stream) |> atomize()
  end

  #
  # Privates
  #

  defp to_map(entity) when is_struct(entity),
    do: entity |> Map.from_struct() |> Map.delete(:__meta__)

  defp to_map(entity) when is_map(entity), do: entity

  defp atomize(nil), do: nil
  defp atomize(entities) when is_list(entities), do: entities |> Enum.map(fn s -> atomize(s) end)
  defp atomize(entity), do: entity |> to_map() |> AtomicMap.convert(safe: false)

  @spec calculate_max(integer | nil) :: integer
  defp calculate_max(nil), do: 0
  defp calculate_max(v), do: v
end

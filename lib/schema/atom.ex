defmodule SevenottersPostgres.Schema.Atom do
  @moduledoc """

  Custom Type to support `:atom`

  defmodule Post do
    use Ecto.Schema
    schema "posts" do
      field :atom_field, Ecto.Atom
    end
  end
  """

  @behaviour Ecto.Type

  @spec type :: :string
  def type, do: :string

  @spec cast(any) :: :error | {:ok, atom}
  def cast(value) when is_atom(value), do: {:ok, value}
  def cast(_), do: :error

  @spec load(any) :: {:ok, any}
  def load(value), do: {:ok, String.to_atom(value)}

  @spec dump(any) :: :error | {:ok, any}
  def dump(value) when is_atom(value), do: {:ok, Atom.to_string(value)}
  def dump(_), do: :error

  @spec embed_as(any) :: :self
  def embed_as(_), do: :self

  @spec equal?(any, any) :: boolean
  def equal?(l, r), do: l == r
end

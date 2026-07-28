defmodule Korangar.CharacterServerInformation do
  @moduledoc """
  The Character Server information struct.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          server_ip: [non_neg_integer()],
          server_port: non_neg_integer(),
          server_name: String.t(),
          server_type: non_neg_integer(),
          user_count: non_neg_integer(),
          display_new: non_neg_integer(),
          unknown: [non_neg_integer()]
        }

  @primary_key false
  embedded_schema do
    field :server_ip, {:array, :integer}
    field :server_port, :integer
    field :server_name, :string
    field :server_type, :integer
    field :user_count, :integer
    field :display_new, :integer
    field :unknown, {:array, :integer}
  end

  @doc """
  Generates a new struct from given map of attributes.
  """
  @spec new(map()) :: t()
  def new(attrs) do
    attrs
    |> changeset()
    |> apply_action!(:packet)
  end

  @doc """
  Generates a new changeset from given map of attributes.
  """
  @spec changeset(map()) :: Ecto.Changeset.t()
  def changeset(attrs \\ %{}) do
    %__MODULE__{}
    |> cast(attrs, [
      :server_ip,
      :server_port,
      :server_name,
      :server_type,
      :user_count,
      :display_new,
      :unknown
    ])
    |> validate_required([
      :server_ip,
      :server_port,
      :server_name,
      :server_type,
      :user_count,
      :display_new,
      :unknown
    ])
    |> validate_length(:server_ip, is: 4)
    |> validate_length(:unknown, is: 128)
  end
end

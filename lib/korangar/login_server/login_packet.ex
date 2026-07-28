defmodule Korangar.LoginServerLoginPacket do
  @moduledoc """
  The login request packet.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          name: String.t(),
          password: String.t(),
          version: [non_neg_integer()],
          client_type: non_neg_integer()
        }

  @primary_key false
  embedded_schema do
    field :name, :string
    field :password, :string
    field :version, {:array, :integer}
    field :client_type, :integer
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
    |> cast(attrs, [:name, :password, :version, :client_type])
    |> validate_required([:name, :password, :version, :client_type])
    |> validate_length(:name, max: 24)
    |> validate_length(:password, max: 24)
    |> validate_length(:version, is: 4)
  end
end

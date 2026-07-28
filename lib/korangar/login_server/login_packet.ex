defmodule Korangar.LoginServerLoginPacket do
  @moduledoc """
  The login request packet sent by the client to the login server.

  The very first packet sent when logging in, it is sent after the user has
  entered email and password.

  ## Packet notation

  0064 <client version>.L <user name>.24B <user password>.24B <client type>.B (PACKET_CA_LOGIN)

      # 0x64 [1, 2, 3, 4] "aledsz" "123456" 22

      <<100, 0, 1, 2, 3, 4, 97, 108, 101, 100, 115, 122, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 49, 50, 51, 52, 53, 54, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 22>>
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

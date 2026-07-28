defmodule Korangar.LoginServerLoginSuccessPacket do
  @moduledoc """
  The logged successfully packet sent by the login server as a response to [Korangar.LoginServerLoginPacket]
  succeeding.

  After receiving this packet, the client will connect to one of
  the character servers provided by this packet.
  """
  use Ecto.Schema
  import Ecto.Changeset

  defimpl Korangar.Packet do
    def server_packet(packet) do
      {:login_server, packet}
    end
  end

  @typedoc """
  The possible sex values.
  """
  @type sex :: :female | :male | :both | :server

  @type t :: %__MODULE__{
          login_id1: non_neg_integer(),
          account_id: non_neg_integer(),
          login_id2: non_neg_integer(),
          sex: sex(),
          auth_token: binary(),
          character_server_information: [Korangar.CharacterServerInformation.t()]
        }

  @primary_key false
  embedded_schema do
    field :login_id1, :integer
    field :account_id, :integer
    field :login_id2, :integer
    field :sex, Ecto.Enum, values: ~w[
      female
      male
      both
      server
    ]a
    field :auth_token, :binary

    embeds_many :character_server_information, Korangar.CharacterServerInformation
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
    |> cast(attrs, [:login_id1, :account_id, :login_id2, :sex, :auth_token])
    |> cast_embed(:character_server_information)
    |> validate_required([:login_id1, :account_id, :login_id2, :sex, :auth_token])
  end
end

defmodule Korangar.LoginServerKeepalivePacket do
  @moduledoc """
  The logged user ping packet sent by the client to the login server every 60 seconds to keep the
  connection alive.
  """
  use Ecto.Schema
  import Ecto.Changeset

  defimpl Korangar.Packet do
    def server_packet(packet) do
      {:login_server, packet}
    end
  end

  @type t :: %__MODULE__{user_id: [pos_integer()]}

  @primary_key false
  embedded_schema do
    field :user_id, {:array, :integer}
  end

  @doc """
  Generates a new struct from given user id.
  """
  @spec new(pos_integer()) :: t()
  def new(user_id) do
    %{user_id: user_id}
    |> changeset()
    |> apply_action!(:packet)
  end

  @doc """
  Generates a new changeset from given map of attributes.
  """
  @spec changeset(map()) :: Ecto.Changeset.t()
  def changeset(attrs \\ %{}) do
    %__MODULE__{}
    |> cast(attrs, [:user_id])
    |> validate_required([:user_id])
    |> validate_length(:user_id, is: 24)
  end
end

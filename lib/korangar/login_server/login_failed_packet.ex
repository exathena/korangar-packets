defmodule Korangar.LoginFailedPacket do
  @moduledoc """
  The login failed packet.
  """
  use Ecto.Schema
  import Ecto.Changeset

  defimpl Korangar.Packet do
    def server_packet(packet) do
      {:login_server, packet}
    end
  end

  @typedoc """
  The possible reasons of a failed login.
  """
  @type reason ::
          :unregistered_id
          | :incorrect_password
          | :id_expired
          | :rejected_from_server
          | :blocked_by_gm_team
          | :game_outdated
          | :login_prohibited_until
          | :server_full
          | :company_account_limit_reached

  @type t :: %__MODULE__{reason: reason()}

  @primary_key false
  embedded_schema do
    field :reason, Ecto.Enum, values: ~w[
      unregistered_id
      incorrect_password
      id_expired
      rejected_from_server
      blocked_by_gm_team
      game_outdated
      login_prohibited_until
      server_full
      company_account_limit_reached
    ]a
  end

  @doc """
  Generates a new struct from given reason.
  """
  @spec new(reason()) :: t()
  def new(reason) do
    %{reason: reason}
    |> changeset()
    |> apply_action!(:packet)
  end

  @doc """
  Generates a new changeset from given map of attributes.
  """
  @spec changeset(map()) :: Ecto.Changeset.t()
  def changeset(attrs \\ %{}) do
    %__MODULE__{}
    |> cast(attrs, [:reason])
    |> validate_required([:reason])
  end
end

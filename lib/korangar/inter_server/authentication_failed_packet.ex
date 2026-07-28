defmodule Korangar.AuthenticationFailedPacket do
  @moduledoc """
  The authentication failed packet.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @typedoc """
  The possible reasons of a failed authentication.
  """
  @type reason :: :server_closed | :already_logged_in | :already_online

  @type t :: %__MODULE__{reason: reason()}

  @primary_key false
  embedded_schema do
    field :reason, Ecto.Enum, values: ~w[
      server_closed
      already_logged_in
      already_online
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

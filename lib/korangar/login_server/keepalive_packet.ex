defmodule Korangar.LoginServerKeepalivePacket do
  @moduledoc """
  The logged user ping packet.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{user_id: pos_integer()}

  @primary_key false
  embedded_schema do
    field :user_id, :integer
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
  end
end

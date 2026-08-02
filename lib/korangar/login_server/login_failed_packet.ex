defmodule Korangar.LoginFailedPacket do
  @moduledoc """
  The login failed packet.
  """
  use Ecto.Schema
  import Ecto.Changeset

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
          | :banned_by_dba_team
          | :unconfirmed_email
          | :banned_by_gm_team
          | :temporary_ban_for_database_work
          | :self_locked
          | :not_permitted_group
          | :account_id_erased
          | :login_information_remains
          | :locked_for_hacking_investigation
          | :temporary_locked_for_bug_investigation
          | :deleting_character
          | :deleting_spouse_character
          | :unknown_error

  @type t :: %__MODULE__{reason: reason(), date: String.t()}

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
      unconfirmed_email
      banned_by_dba_team
      banned_by_gm_team
      temporary_ban_for_database_work
      self_locked
      not_permitted_group
      account_id_erased
      login_information_remains
      locked_for_hacking_investigation
      temporary_locked_for_bug_investigation
      deleting_character
      deleting_spouse_character
      unknown_error
    ]a
    field :date, :string, default: ""
  end

  @doc """
  Generates a new struct from given reason.
  """
  @spec new(reason()) :: t()
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
    |> cast(attrs, [:reason, :date])
    |> validate_required([:reason])
    |> validate_reason()
  end

  defp validate_reason(changeset) do
    if get_field(changeset, :reason) in ~w[login_prohibited_until login_information_remains]a do
      changeset
      |> validate_required([:date])
      |> validate_length(:date, is: 20)
    else
      changeset
    end
  end
end

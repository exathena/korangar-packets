defmodule Korangar.LoginServerLoginSuccessPacket do
  defstruct [
    :login_id1,
    :account_id,
    :login_id2,
    :ip_address,
    :name,
    :unknown,
    :sex,
    :auth_token,
    :character_server_information
  ]
end

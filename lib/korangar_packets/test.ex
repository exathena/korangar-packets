defmodule KorangarPackets.Test do
  defp build(:login_server_login) do
    %Korangar.LoginServerLoginPacket{
      name: "foo",
      password: "bar",
      client_type: 22,
      version: [0, 0, 0, 0]
    }
  end

  defp build(:login_server_login_success) do
    %Korangar.LoginServerLoginSuccessPacket{
      login_id1: 100,
      account_id: 100,
      login_id2: 100,
      auth_token: for(_ <- 1..17, do: 1),
      sex: :both,
      character_server_information: [
        %Korangar.CharacterServerInformation{
          server_ip: [127, 0, 0, 1],
          server_port: 6121,
          server_name: "exAthena",
          server_type: 1,
          user_count: 0,
          display_new: 0,
          unknown: for(_ <- 1..128, do: 1)
        }
      ]
    }
  end

  defp build(:login_server_keepalive) do
    %Korangar.LoginServerKeepalivePacket{user_id: for(_ <- 1..24, do: 1)}
  end

  defp build(:login_failed) do
    %Korangar.LoginFailedPacket{reason: :unregistered_id}
  end

  defp build(:authentication_failed) do
    %Korangar.AuthenticationFailedPacket{reason: :server_closed}
  end

  # Convenience-only API

  def packet_for(name, attrs \\ %{}) when is_list(attrs) or is_map(attrs) do
    attrs = Enum.into(attrs, %{})
    data = build(name)

    map_from_struct(data)
    |> Map.merge(attrs)
    |> data.__struct__.new()
  end

  def bytes_for(name, attrs \\ %{}) when is_list(attrs) or is_map(attrs) do
    name
    |> packet_for(attrs)
    |> KorangarPackets.encode_packet()
  end

  # Helpers

  defp map_from_struct(data) when is_struct(data) do
    data |> Map.from_struct() |> map_from_struct()
  end

  defp map_from_struct(data) when is_map(data) do
    Map.new(data, fn {k, v} -> {k, map_from_struct(v)} end)
  end

  defp map_from_struct(data) when is_list(data) do
    Enum.map(data, &map_from_struct/1)
  end

  defp map_from_struct(data), do: data
end

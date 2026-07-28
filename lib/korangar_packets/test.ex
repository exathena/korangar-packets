defmodule KorangarPackets.Test do
  @doc false
  def packet_for(name)

  def packet_for(:login_server_login) do
    %Korangar.LoginServerLoginPacket{
      name: "foo",
      password: "bar",
      client_type: 22,
      version: [0, 0, 0, 0]
    }
  end

  def packet_for(:login_server_login_success) do
    %Korangar.LoginServerLoginSuccessPacket{
      character_server_information: [packet_for(:character_server_information)]
    }
  end

  def packet_for(:character_server_information) do
    %Korangar.CharacterServerInformation{}
  end

  # Convenience-only API

  def packet_for(name, attrs) when is_list(attrs) or is_map(attrs) do
    name
    |> packet_for()
    |> struct!(attrs)
  end

  def bytes_for(name, attrs) when is_list(attrs) or is_map(attrs) do
    name
    |> packet_for(attrs)
    |> KorangarPackets.encode_packet()
  end
end

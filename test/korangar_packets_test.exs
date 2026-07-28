defmodule KorangarPacketsTest do
  use ExUnit.Case, async: true
  import KorangarPackets.Test

  test "encodes and decodes the login packet" do
    packet =
      packet_for(:login_server_login,
        client_type: 22,
        name: "aledsz",
        password: "123456",
        version: [1, 2, 3, 4]
      )

    assert {:ok, bytes} = KorangarPackets.encode_packet(packet)
    assert KorangarPackets.decode_packet(bytes) == {:ok, packet}
  end

  test "returns error with invalid packet header" do
    bytes = <<0, 0, 1, 2, 3, 4>>
    assert KorangarPackets.decode_packet(bytes) == {:error, "Unknown packet header: 0x00"}
  end
end

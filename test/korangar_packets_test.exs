defmodule KorangarPacketsTest do
  use ExUnit.Case, async: true
  import KorangarPackets.Test

  test "encodes and decodes the packet" do
    packet = packet_for(:login_server_login)
    assert {:ok, bytes} = KorangarPackets.encode_packet(packet)
    assert KorangarPackets.decode_packet(bytes) == {:ok, packet}
  end

  test "returns error with invalid packet header" do
    assert KorangarPackets.decode_packet(<<0, 0>>) == {:error, "Unknown packet header: 0x00"}
  end
end

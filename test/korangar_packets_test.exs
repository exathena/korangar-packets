defmodule KorangarPacketsTest do
  use ExUnit.Case, async: true

  @bytes <<100, 0, 1, 2, 3, 4, 97, 108, 101, 100, 115, 122, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
           0, 0, 0, 0, 0, 49, 50, 51, 52, 53, 54, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
           0, 0, 22>>

  @packet {:login_server,
           %Korangar.LoginServerLoginPacket{
             client_type: 22,
             name: "aledsz",
             password: "123456",
             version: [1, 2, 3, 4]
           }}

  describe "decode_packet/1" do
    test "decodes the login packet" do
      assert KorangarPackets.decode_packet(@bytes) == {:ok, @packet}
    end

    test "returns error with invalid packet header" do
      bytes = <<100, 2, 1, 2, 3, 4>>
      assert KorangarPackets.decode_packet(bytes) == {:error, "Unknown packet header: 0x264"}
    end
  end

  test "encode_packet/1 encodes the login packet" do
    assert KorangarPackets.encode_packet(@packet) == {:ok, @bytes}
  end
end

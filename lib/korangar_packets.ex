defmodule KorangarPackets do
  use Rustler,
    otp_app: :korangar_packets,
    crate: :korangar_packets,
    skip_compilation?: false

  @typedoc """
  The server-packet type.
  """
  @type server_packet :: {:login_server, struct()}

  @doc """
  Decodes the given binary into a "server-packet" tuple.
  """
  @spec decode_packet(binary()) :: {:ok, server_packet()} | {:error, String.t()}
  def decode_packet(_packet_bytes), do: :erlang.nif_error(:nif_not_loaded)

  @doc """
  Encodes the given "server-packet" tuple into a binary.
  """
  @spec encode_packet(server_packet()) :: {:ok, binary()} | {:error, String.t()}
  def encode_packet(_server_packet_tuple), do: :erlang.nif_error(:nif_not_loaded)
end

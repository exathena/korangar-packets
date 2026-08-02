defmodule KorangarPackets do
  use Rustler,
    otp_app: :korangar_packets,
    crate: :korangar_packets,
    skip_compilation?: false

  @typedoc """
  The Korangar Packet type.
  """
  @type packet ::
          Korangar.LoginServerLoginPacket.t()
          | Korangar.LoginServerLoginSuccessPacket.t()
          | Korangar.LoginServerKeepalivePacket.t()
          | Korangar.LoginFailedPacket.t()
          | Korangar.AuthenticationFailedPacket.t()

  @doc """
  Gets the header from given raw bytes.
  """
  @spec fetch_header(binary()) :: {:ok, pos_integer()} | {:error, String.t()}
  def fetch_header(_bytes), do: :erlang.nif_error(:nif_not_loaded)

  @doc """
  Decodes the given binary into a packet struct.
  """
  @spec decode_packet(binary()) :: {:ok, packet()} | {:error, String.t()}
  def decode_packet(_bytes), do: :erlang.nif_error(:nif_not_loaded)

  @doc """
  Encodes the given packet struct into a binary.
  """
  @spec encode_packet(packet()) :: {:ok, binary()} | {:error, String.t()}
  def encode_packet(_packet), do: :erlang.nif_error(:nif_not_loaded)
end

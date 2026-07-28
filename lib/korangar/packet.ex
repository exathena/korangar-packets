defprotocol Korangar.Packet do
  @typedoc """
  The server-packet type.
  """
  @type server_packet :: {:login_server | :inter_server, t()}

  @doc """
  Returns the `server-packet` tuple format from given packet.
  """
  @spec server_packet(t()) :: server_packet()
  def server_packet(packet)
end

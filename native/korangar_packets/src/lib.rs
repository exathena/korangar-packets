mod inter;
mod login;
mod packet;

use ragnarok_bytes::FromBytes;
use ragnarok_packets::PacketHeader;
use rustler::{Binary, Env, NewBinary};

use self::packet::RagnarokPacket;

/// Decode given raw bytes to `Packet`.
///
/// Returns `{:ok, {atom(), Packet.t()}}` or `{:error, term()}`.
#[rustler::nif]
fn decode_packet<'a>(bytes: Binary<'a>) -> Result<RagnarokPacket, String> {
    let mut reader = ragnarok_bytes::ByteReader::without_metadata(&bytes);

    let header = match PacketHeader::from_bytes(&mut reader) {
        Ok(header) => header,
        Err(error) => return Err(format!("Failed to parse packet header: {:?}", error)),
    };

    if packet::LOGIN_PACKETS.contains(&header) {
        let packet = login::nif_from_bytes(&header, &mut reader)?;
        return Ok(RagnarokPacket::LoginServer(packet));
    }

    if packet::INTER_PACKETS.contains(&header) {
        let packet = inter::nif_from_bytes(&header, &mut reader)?;
        return Ok(RagnarokPacket::InterServer(packet));
    }

    Err(format!("Unknown packet header: {:#04x}", header.0))
}

/// Encode the given `Packet` to raw bytes.
///
/// Returns `{:ok, binary()}` or `{:error, term()}`.
#[rustler::nif]
fn encode_packet<'a>(env: Env<'a>, packet: RagnarokPacket) -> Result<Binary<'a>, String> {
    let mut writer = ragnarok_bytes::ByteWriter::new();

    let size = match packet {
        RagnarokPacket::LoginServer(login) => login::nif_to_bytes(&login, &mut writer)?,
        RagnarokPacket::InterServer(inter) => inter::nif_to_bytes(&inter, &mut writer)?,
    };

    let bytes = writer.into_inner();
    let mut new_binary = NewBinary::new(env, size);
    new_binary.copy_from_slice(bytes.as_slice());

    let binary = Binary::from(new_binary);
    Ok(binary)
}

rustler::init!("Elixir.KorangarPackets");

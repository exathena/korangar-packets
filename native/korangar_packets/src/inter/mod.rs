mod enums;
mod packet;

use ragnarok_bytes::{ByteReader, ByteWriter};
use ragnarok_packets::*;
use std::any::Any;

use super::packet::{from_bytes, to_bytes};

#[derive(Debug, Clone, rustler::NifUntaggedEnum)]
pub enum RagnarokInterPacket {
    AuthenticationFailed(packet::NifAuthenticationFailedPacket),
}

pub fn nif_from_bytes(
    header: &PacketHeader,
    reader: &mut ByteReader,
) -> Result<RagnarokInterPacket, String> {
    let boxed = packet_from_bytes(header, reader)?;

    match header {
        &LoginFailedPacket::HEADER => {
            let packet = boxed.downcast_ref::<LoginFailedPacket>().unwrap();
            let nif = packet::NifAuthenticationFailedPacket::from(packet);

            Ok(RagnarokInterPacket::AuthenticationFailed(nif))
        }
        _ => Err(format!("Invalid packet: {:#04x}", header.0)),
    }
}

pub fn nif_to_bytes(
    packet: &RagnarokInterPacket,
    writer: &mut ByteWriter,
) -> Result<usize, String> {
    match packet {
        RagnarokInterPacket::AuthenticationFailed(nif) => {
            let packet = LoginFailedPacket::from(nif);
            let size = to_bytes::<LoginFailedPacket>(Box::new(packet), writer)?;

            Ok(size)
        }
    }
}

fn packet_from_bytes(
    header: &PacketHeader,
    reader: &mut ByteReader,
) -> Result<Box<dyn Any>, String> {
    match header {
        &LoginFailedPacket::HEADER => from_bytes::<LoginFailedPacket>(reader),
        _ => Err(format!("Invalid packet: {:#04x}", header.0)),
    }
}

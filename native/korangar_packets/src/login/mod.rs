mod enums;
mod packet;

use ragnarok_bytes::{ByteReader, ByteWriter};
use ragnarok_packets::*;
use std::any::Any;

use super::packet::{from_bytes, to_bytes};

#[derive(Debug, Clone, rustler::NifUntaggedEnum)]
pub enum RagnarokLoginPacket {
    Login(packet::NifLoginServerLoginPacket),
    Keepalive(packet::NifLoginServerKeepalivePacket),
    Success(packet::NifLoginServerLoginSuccessPacket),
    Failed(packet::NifLoginFailedPacket),
}

pub fn nif_from_bytes(
    header: &PacketHeader,
    reader: &mut ByteReader,
) -> Result<RagnarokLoginPacket, String> {
    let boxed = packet_from_bytes(header, reader)?;

    match header {
        &LoginServerLoginPacket::HEADER => {
            let packet = boxed.downcast_ref::<LoginServerLoginPacket>().unwrap();
            let nif = packet::NifLoginServerLoginPacket::from(packet);

            Ok(RagnarokLoginPacket::Login(nif))
        }
        &LoginServerKeepalivePacket::HEADER => {
            let packet = boxed.downcast_ref::<LoginServerKeepalivePacket>().unwrap();
            let nif = packet::NifLoginServerKeepalivePacket::from(packet);

            Ok(RagnarokLoginPacket::Keepalive(nif))
        }
        &LoginServerLoginSuccessPacket::HEADER => {
            let packet = boxed
                .downcast_ref::<LoginServerLoginSuccessPacket>()
                .unwrap();
            let nif = packet::NifLoginServerLoginSuccessPacket::from(packet);

            Ok(RagnarokLoginPacket::Success(nif))
        }
        &LoginFailedPacket2::HEADER => {
            let packet = boxed.downcast_ref::<LoginFailedPacket2>().unwrap();
            let nif = packet::NifLoginFailedPacket::from(packet);

            Ok(RagnarokLoginPacket::Failed(nif))
        }
        _ => Err(format!("Invalid packet: {:#04x}", header.0)),
    }
}

pub fn nif_to_bytes(
    packet: &RagnarokLoginPacket,
    writer: &mut ByteWriter,
) -> Result<usize, String> {
    match packet {
        RagnarokLoginPacket::Login(nif) => {
            let packet = LoginServerLoginPacket::from(nif);
            let size = to_bytes::<LoginServerLoginPacket>(Box::new(packet), writer)?;

            Ok(size)
        }
        RagnarokLoginPacket::Keepalive(nif) => {
            let packet = LoginServerKeepalivePacket::from(nif);
            let size = to_bytes::<LoginServerKeepalivePacket>(Box::new(packet), writer)?;

            Ok(size)
        }
        RagnarokLoginPacket::Success(nif) => {
            let packet = LoginServerLoginSuccessPacket::from(nif);
            let size = to_bytes::<LoginServerLoginSuccessPacket>(Box::new(packet), writer)?;

            Ok(size)
        }
        RagnarokLoginPacket::Failed(nif) => {
            let packet = LoginFailedPacket2::from(nif);
            let size = to_bytes::<LoginFailedPacket2>(Box::new(packet), writer)?;

            Ok(size)
        }
    }
}

fn packet_from_bytes(
    header: &PacketHeader,
    reader: &mut ByteReader,
) -> Result<Box<dyn Any>, String> {
    match header {
        &LoginServerLoginPacket::HEADER => from_bytes::<LoginServerLoginPacket>(reader),
        &LoginServerKeepalivePacket::HEADER => from_bytes::<LoginServerKeepalivePacket>(reader),
        &LoginServerLoginSuccessPacket::HEADER => {
            from_bytes::<LoginServerLoginSuccessPacket>(reader)
        }
        &LoginFailedPacket2::HEADER => from_bytes::<LoginFailedPacket2>(reader),
        _ => Err(format!("Invalid packet: {:#04x}", header.0)),
    }
}

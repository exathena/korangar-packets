use ragnarok_bytes::{ByteReader, ByteWriter};
use ragnarok_packets::*;
use std::any::Any;

pub const LOGIN_PACKETS: [PacketHeader; 5] = [
    LoginServerLoginPacket::HEADER,
    LoginServerKeepalivePacket::HEADER,
    LoginServerLoginSuccessPacket::HEADER,
    LoginFailedPacket::HEADER,
    LoginFailedPacket2::HEADER,
];

pub const INTER_PACKETS: [PacketHeader; 1] = [LoginFailedPacket::HEADER];

#[derive(Debug, Clone, rustler::NifTaggedEnum)]
pub enum RagnarokPacket {
    LoginServer(super::login::RagnarokLoginPacket),
    InterServer(super::inter::RagnarokInterPacket),
}

pub(crate) fn to_bytes<T: Packet + 'static>(
    boxed: Box<dyn Any + 'static>,
    writer: &mut ByteWriter,
) -> Result<usize, String> {
    let packet = match boxed.downcast_ref::<T>() {
        Some(packet) => packet,
        None => return Err(format!("Failed to parse packet: {:?}", boxed)),
    };

    match packet.packet_to_bytes(writer) {
        Ok(usize) => Ok(usize),
        Err(error) => Err(format!("Failed to parse packet: {:?}", error)),
    }
}

pub(crate) fn from_bytes<T: Packet + 'static>(
    reader: &mut ByteReader,
) -> Result<Box<dyn Any>, String> {
    match T::payload_from_bytes(reader) {
        Ok(packet) => Ok(Box::new(packet)),
        Err(error) => Err(format!("Failed to parse packet: {:?}", error)),
    }
}

use ragnarok_packets::*;

#[derive(Debug, Clone, rustler::NifStruct)]
#[module = "Korangar.AuthenticationFailedPacket"]
pub struct NifAuthenticationFailedPacket {
    pub reason: super::enums::NifAuthenticationFailedReason,
}

impl From<&LoginFailedPacket> for NifAuthenticationFailedPacket {
    fn from(value: &LoginFailedPacket) -> Self {
        Self {
            reason: super::enums::NifAuthenticationFailedReason::from(&value.reason),
        }
    }
}

impl From<&NifAuthenticationFailedPacket> for LoginFailedPacket {
    fn from(value: &NifAuthenticationFailedPacket) -> Self {
        Self {
            reason: LoginFailedReason::from(&value.reason),
        }
    }
}

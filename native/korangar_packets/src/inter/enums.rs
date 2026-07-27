use ragnarok_packets::*;

#[derive(Debug, Clone, rustler::NifUnitEnum)]
pub enum NifAuthenticationFailedReason {
    ServerClosed,
    AlreadyLoggedIn,
    AlreadyOnline,
}

impl From<&LoginFailedReason> for NifAuthenticationFailedReason {
    fn from(value: &LoginFailedReason) -> Self {
        match value {
            LoginFailedReason::ServerClosed => Self::ServerClosed,
            LoginFailedReason::AlreadyLoggedIn => Self::AlreadyLoggedIn,
            LoginFailedReason::AlreadyOnline => Self::AlreadyOnline,
        }
    }
}

impl From<&NifAuthenticationFailedReason> for LoginFailedReason {
    fn from(value: &NifAuthenticationFailedReason) -> Self {
        match value {
            NifAuthenticationFailedReason::ServerClosed => Self::ServerClosed,
            NifAuthenticationFailedReason::AlreadyLoggedIn => Self::AlreadyLoggedIn,
            NifAuthenticationFailedReason::AlreadyOnline => Self::AlreadyOnline,
        }
    }
}

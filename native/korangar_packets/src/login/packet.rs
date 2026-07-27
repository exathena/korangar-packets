use ragnarok_packets::*;

/// Sent by the client to the login server.
/// The very first packet sent when logging in, it is sent after the user has
/// entered email and password.
#[derive(Debug, Clone, rustler::NifStruct)]
#[module = "Korangar.LoginServerLoginPacket"]
pub struct NifLoginServerLoginPacket {
    pub version: Vec<u8>,
    pub name: String,
    pub password: String,
    pub client_type: u8,
}

impl From<&LoginServerLoginPacket> for NifLoginServerLoginPacket {
    fn from(value: &LoginServerLoginPacket) -> Self {
        Self {
            version: value.version.to_vec(),
            name: value.name.clone(),
            password: value.password.clone(),
            client_type: value.client_type,
        }
    }
}

impl From<&NifLoginServerLoginPacket> for LoginServerLoginPacket {
    fn from(value: &NifLoginServerLoginPacket) -> Self {
        let mut version = [0u8; 4];
        version.copy_from_slice(&value.version[0..4]);

        Self {
            version,
            name: value.name.clone(),
            password: value.password.clone(),
            client_type: value.client_type,
        }
    }
}

/// Sent by the client to the login server every 60 seconds to keep the
/// connection alive.
#[derive(Debug, Clone, rustler::NifStruct)]
#[module = "Korangar.LoginServerKeepalivePacket"]
pub struct NifLoginServerKeepalivePacket {
    pub user_id: Vec<u8>,
}

impl From<&LoginServerKeepalivePacket> for NifLoginServerKeepalivePacket {
    fn from(value: &LoginServerKeepalivePacket) -> Self {
        Self {
            user_id: value.user_id.0.to_vec(),
        }
    }
}

impl From<&NifLoginServerKeepalivePacket> for LoginServerKeepalivePacket {
    fn from(value: &NifLoginServerKeepalivePacket) -> Self {
        let mut user_id = [0u8; 24];
        user_id.copy_from_slice(&value.user_id[0..24]);

        Self {
            user_id: UserId(user_id),
        }
    }
}

/// Sent by the login server as a response to [LoginServerLoginPacket]
/// succeeding. After receiving this packet, the client will connect to one of
/// the character servers provided by this packet.
#[derive(Debug, Clone, rustler::NifStruct)]
#[module = "Korangar.LoginServerLoginSuccessPacket"]
pub struct NifLoginServerLoginSuccessPacket {
    pub login_id1: u32,
    pub account_id: u32,
    pub login_id2: u32,
    pub ip_address: u32,
    pub name: Vec<u8>,
    pub unknown: u16,
    pub sex: super::enums::NifSex,
    pub auth_token: Vec<u8>,
    pub character_server_information: Vec<NifCharacterServerInformation>,
}

impl From<&LoginServerLoginSuccessPacket> for NifLoginServerLoginSuccessPacket {
    fn from(value: &LoginServerLoginSuccessPacket) -> Self {
        let character_server_information = value
            .character_server_information
            .iter()
            .map(|csi| NifCharacterServerInformation::from(csi))
            .collect();

        Self {
            login_id1: value.login_id1,
            account_id: value.account_id.0,
            login_id2: value.login_id2,
            ip_address: value.ip_address,
            name: value.name.to_vec(),
            unknown: value.unknown,
            sex: super::enums::NifSex::from(&value.sex),
            auth_token: value.auth_token.0.to_vec(),
            character_server_information,
        }
    }
}

impl From<&NifLoginServerLoginSuccessPacket> for LoginServerLoginSuccessPacket {
    fn from(value: &NifLoginServerLoginSuccessPacket) -> Self {
        let mut name = [0u8; 24];
        name.copy_from_slice(&value.name[0..24]);

        let mut auth_token = [0u8; 17];
        auth_token.copy_from_slice(&value.auth_token[0..17]);

        let character_server_information = value
            .character_server_information
            .iter()
            .map(|csi| CharacterServerInformation::from(csi))
            .collect();

        Self {
            login_id1: value.login_id1,
            account_id: AccountId(value.account_id),
            login_id2: value.login_id2,
            ip_address: value.ip_address,
            name,
            unknown: value.unknown,
            sex: Sex::from(&value.sex),
            auth_token: AuthToken(auth_token),
            character_server_information,
        }
    }
}

#[derive(Debug, Clone, rustler::NifStruct)]
#[module = "Korangar.CharacterServerInformation"]
pub struct NifCharacterServerInformation {
    pub server_ip: Vec<u8>,
    pub server_port: u16,
    pub server_name: String,
    pub user_count: u16,
    pub server_type: u16,
    pub display_new: u16,
    pub unknown: Vec<u8>,
}

impl From<&CharacterServerInformation> for NifCharacterServerInformation {
    fn from(value: &CharacterServerInformation) -> Self {
        Self {
            server_ip: value.server_ip.0.to_vec(),
            server_port: value.server_port,
            server_name: value.server_name.clone(),
            user_count: value.user_count,
            server_type: value.server_type,
            display_new: value.display_new,
            unknown: value.unknown.to_vec(),
        }
    }
}

impl From<&NifCharacterServerInformation> for CharacterServerInformation {
    fn from(value: &NifCharacterServerInformation) -> Self {
        let mut server_ip = [0u8; 4];
        server_ip.copy_from_slice(&value.server_ip[0..4]);

        let mut unknown = [0u8; 128];
        unknown.copy_from_slice(&value.unknown[0..128]);

        Self {
            server_ip: ServerAddress(server_ip),
            server_port: value.server_port,
            server_name: value.server_name.clone(),
            user_count: value.user_count,
            server_type: value.server_type,
            display_new: value.display_new,
            unknown,
        }
    }
}

#[derive(Debug, Clone, rustler::NifStruct)]
#[module = "Korangar.LoginFailedPacket"]
pub struct NifLoginFailedPacket {
    pub reason: super::enums::NifLoginFailedReason,
}

impl From<&LoginFailedPacket2> for NifLoginFailedPacket {
    fn from(value: &LoginFailedPacket2) -> Self {
        Self {
            reason: super::enums::NifLoginFailedReason::from(&value.reason),
        }
    }
}

impl From<&NifLoginFailedPacket> for LoginFailedPacket2 {
    fn from(value: &NifLoginFailedPacket) -> Self {
        Self {
            reason: LoginFailedReason2::from(&value.reason),
        }
    }
}

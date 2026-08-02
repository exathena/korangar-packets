use ragnarok_packets::*;

#[derive(Debug, Clone, rustler::NifUnitEnum)]
pub enum NifSex {
    Female,
    Male,
    Both,
    Server,
}

impl From<&Sex> for NifSex {
    fn from(value: &Sex) -> Self {
        match value {
            Sex::Female => Self::Female,
            Sex::Male => Self::Male,
            Sex::Both => Self::Both,
            Sex::Server => Self::Server,
        }
    }
}

impl From<&NifSex> for Sex {
    fn from(value: &NifSex) -> Self {
        match value {
            NifSex::Female => Self::Female,
            NifSex::Male => Self::Male,
            NifSex::Both => Self::Both,
            NifSex::Server => Self::Server,
        }
    }
}

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

#[derive(Debug, Clone, rustler::NifUnitEnum)]
pub enum NifLoginFailedReason {
    UnregisteredId,
    IncorrectPassword,
    IdExpired,
    RejectedFromServer,
    BlockedByGMTeam,
    GameOutdated,
    LoginProhibitedUntil,
    ServerFull,
    CompanyAccountLimitReached,
    BannedByDBATeam,
    UnconfirmedEmail,
    BannedByGMTeam,
    TemporaryBanForDatabaseWork,
    SelfLocked,
    NotPermittedGroup,
    AccountIdErased,
    LoginInformationRemains,
    LockedForHackingInvestigation,
    TemporaryLockedForBugInvestigation,
    DeletingCharacter,
    DeletingSpouseCharacter,
    UnknownError,
}

impl From<&LoginFailedReason2> for NifLoginFailedReason {
    fn from(value: &LoginFailedReason2) -> Self {
        match value {
            LoginFailedReason2::UnregisteredId => Self::UnregisteredId,
            LoginFailedReason2::IncorrectPassword => Self::IncorrectPassword,
            LoginFailedReason2::IdExpired => Self::IdExpired,
            LoginFailedReason2::RejectedFromServer => Self::RejectedFromServer,
            LoginFailedReason2::BlockedByGMTeam => Self::BlockedByGMTeam,
            LoginFailedReason2::GameOutdated => Self::GameOutdated,
            LoginFailedReason2::LoginProhibitedUntil => Self::LoginProhibitedUntil,
            LoginFailedReason2::ServerFull => Self::ServerFull,
            LoginFailedReason2::CompanyAccountLimitReached => Self::CompanyAccountLimitReached,
            LoginFailedReason2::BannedByDBATeam => Self::BannedByDBATeam,
            LoginFailedReason2::UnconfirmedEmail => Self::UnconfirmedEmail,
            LoginFailedReason2::BannedByGMTeam => Self::BannedByGMTeam,
            LoginFailedReason2::TemporaryBanForDatabaseWork => Self::TemporaryBanForDatabaseWork,
            LoginFailedReason2::SelfLocked => Self::SelfLocked,
            LoginFailedReason2::NotPermittedGroup => Self::NotPermittedGroup,
            LoginFailedReason2::AccountIdErased => Self::AccountIdErased,
            LoginFailedReason2::LoginInformationRemains => Self::LoginInformationRemains,
            LoginFailedReason2::LockedForHackingInvestigation => {
                Self::LockedForHackingInvestigation
            }
            LoginFailedReason2::TemporaryLockedForBugInvestigation => {
                Self::TemporaryLockedForBugInvestigation
            }
            LoginFailedReason2::DeletingCharacter => Self::DeletingCharacter,
            LoginFailedReason2::DeletingSpouseCharacter => Self::DeletingSpouseCharacter,
            LoginFailedReason2::UnknownError => Self::UnknownError,
        }
    }
}

impl From<&NifLoginFailedReason> for LoginFailedReason2 {
    fn from(value: &NifLoginFailedReason) -> Self {
        match value {
            NifLoginFailedReason::UnregisteredId => Self::UnregisteredId,
            NifLoginFailedReason::IncorrectPassword => Self::IncorrectPassword,
            NifLoginFailedReason::IdExpired => Self::IdExpired,
            NifLoginFailedReason::RejectedFromServer => Self::RejectedFromServer,
            NifLoginFailedReason::BlockedByGMTeam => Self::BlockedByGMTeam,
            NifLoginFailedReason::GameOutdated => Self::GameOutdated,
            NifLoginFailedReason::LoginProhibitedUntil => Self::LoginProhibitedUntil,
            NifLoginFailedReason::ServerFull => Self::ServerFull,
            NifLoginFailedReason::CompanyAccountLimitReached => Self::CompanyAccountLimitReached,
            NifLoginFailedReason::BannedByDBATeam => Self::BannedByDBATeam,
            NifLoginFailedReason::UnconfirmedEmail => Self::UnconfirmedEmail,
            NifLoginFailedReason::BannedByGMTeam => Self::BannedByGMTeam,
            NifLoginFailedReason::TemporaryBanForDatabaseWork => Self::TemporaryBanForDatabaseWork,
            NifLoginFailedReason::SelfLocked => Self::SelfLocked,
            NifLoginFailedReason::NotPermittedGroup => Self::NotPermittedGroup,
            NifLoginFailedReason::AccountIdErased => Self::AccountIdErased,
            NifLoginFailedReason::LoginInformationRemains => Self::LoginInformationRemains,
            NifLoginFailedReason::LockedForHackingInvestigation => {
                Self::LockedForHackingInvestigation
            }
            NifLoginFailedReason::TemporaryLockedForBugInvestigation => {
                Self::TemporaryLockedForBugInvestigation
            }
            NifLoginFailedReason::DeletingCharacter => Self::DeletingCharacter,
            NifLoginFailedReason::DeletingSpouseCharacter => Self::DeletingSpouseCharacter,
            NifLoginFailedReason::UnknownError => Self::UnknownError,
        }
    }
}

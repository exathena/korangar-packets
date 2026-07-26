use rustler::{Binary, Env, Term};

/// Decode given raw bytes to `Packet`.
///
/// Returns `{:ok, {atom(), Packet.t()}}` or `{:error, term()}`.
#[rustler::nif]
fn decode_packet<'a>(env: Env<'a>, data: Binary<'a>) -> Result<Term<'a>, String> {
    unimplemented!()
}

/// Encode the given `Packet` to raw bytes.
///
/// Returns `{:ok, binary()}` or `{:error, term()}`.
#[rustler::nif]
fn encode_packet<'a>(env: Env<'a>, packet: Term<'a>) -> Result<Term<'a>, String> {
    unimplemented!()
}

rustler::init!("Elixir.Korangar.Packet.Native");

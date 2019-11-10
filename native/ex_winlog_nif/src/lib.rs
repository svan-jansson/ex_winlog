#[macro_use] extern crate rustler;
#[macro_use] extern crate log;

use rustler::{Encoder, Env, Error, Term};

mod atoms {
    rustler_atoms! {
        atom ok;
        atom error;
        atom event_source_registered;
        atom event_source_deregistered;
        atom insufficient_permissions;
        atom io_error;
        atom exe_path_not_found;
    }
}

rustler::rustler_export_nifs! {
    "Elixir.ExWinlog.Nif",
    [
        ("register", 1, register),
        ("deregister", 1, deregister),
        ("info", 2, info)
    ],
    None
}

fn register<'a>(env: Env<'a>, args: &[Term<'a>]) -> Result<Term<'a>, Error> {
    let source: &str = args[0].decode()?;
    match winlog::try_register(&source) {
        Ok(_result) => Ok((atoms::ok(), atoms::event_source_registered()).encode(env)),
        Err(winlog::Error::RegisterSourceFailed) => Ok((atoms::error(), atoms::insufficient_permissions()).encode(env)),
        Err(winlog::Error::Io(reason)) => Ok((atoms::error(), atoms::io_error(), reason.to_string()).encode(env)),
        Err(winlog::Error::ExePathNotFound) => Ok((atoms::error(), atoms::exe_path_not_found()).encode(env))
    }
}

fn deregister<'a>(env: Env<'a>, args: &[Term<'a>]) -> Result<Term<'a>, Error> {
    let source: &str = args[0].decode()?;
    match winlog::try_deregister(&source) {
        Ok(_result) => Ok((atoms::ok(), atoms::event_source_deregistered()).encode(env)),
        Err(winlog::Error::RegisterSourceFailed) => Ok((atoms::error(), atoms::insufficient_permissions()).encode(env)),
        Err(winlog::Error::Io(reason)) => Ok((atoms::error(), atoms::io_error(), reason.to_string()).encode(env)),
        Err(winlog::Error::ExePathNotFound) => Ok((atoms::error(), atoms::exe_path_not_found()).encode(env))
    }
}
 fn info<'a>(env: Env<'a>, args: &[Term<'a>]) -> Result<Term<'a>, Error> {
    let source: &str = args[0].decode()?;
    let log_string: &str = args[1].decode()?;

    if let Ok(_result) = winlog::init(source) {
        info!("{}", log_string);
        Ok((atoms::ok()).encode(env))
    }
    else {
        Ok((atoms::error()).encode(env))
    }

 }
use rustler::{Encoder, Env, Term};

mod atoms {
    rustler::atoms! {
        ok,
        error,
        event_source_registered,
        event_source_deregistered,
        insufficient_permissions,
        io_error,
        exe_path_not_found,
        not_supported
    }
}

rustler::init!("Elixir.ExWinlog.Nif");

#[cfg(windows)]
use log::{debug as log_debug, error as log_error, info as log_info, warn as log_warn};

#[rustler::nif]
fn register<'a>(env: Env<'a>, source: &str) -> Term<'a> {
    #[cfg(windows)]
    {
        match winlog::try_register(source) {
            Ok(_) => (atoms::ok(), atoms::event_source_registered()).encode(env),
            Err(winlog::Error::RegisterSourceFailed) => (atoms::error(), atoms::insufficient_permissions()).encode(env),
            Err(winlog::Error::Io(reason)) => (atoms::error(), atoms::io_error(), reason.to_string()).encode(env),
            Err(winlog::Error::ExePathNotFound) => (atoms::error(), atoms::exe_path_not_found()).encode(env),
        }
    }
    #[cfg(not(windows))]
    {
        let _ = source;
        (atoms::error(), atoms::not_supported()).encode(env)
    }
}

#[rustler::nif]
fn deregister<'a>(env: Env<'a>, source: &str) -> Term<'a> {
    #[cfg(windows)]
    {
        match winlog::try_deregister(source) {
            Ok(_) => (atoms::ok(), atoms::event_source_deregistered()).encode(env),
            Err(winlog::Error::RegisterSourceFailed) => (atoms::error(), atoms::insufficient_permissions()).encode(env),
            Err(winlog::Error::Io(reason)) => (atoms::error(), atoms::io_error(), reason.to_string()).encode(env),
            Err(winlog::Error::ExePathNotFound) => (atoms::error(), atoms::exe_path_not_found()).encode(env),
        }
    }
    #[cfg(not(windows))]
    {
        let _ = source;
        (atoms::error(), atoms::not_supported()).encode(env)
    }
}

#[rustler::nif]
fn info<'a>(env: Env<'a>, source: &str, log_string: &str) -> Term<'a> {
    #[cfg(windows)]
    {
        let _ = winlog::init(source);
        log_info!("{}", log_string);
    }
    #[cfg(not(windows))]
    {
        let _ = (source, log_string);
    }
    atoms::ok().encode(env)
}

#[rustler::nif]
fn error<'a>(env: Env<'a>, source: &str, log_string: &str) -> Term<'a> {
    #[cfg(windows)]
    {
        let _ = winlog::init(source);
        log_error!("{}", log_string);
    }
    #[cfg(not(windows))]
    {
        let _ = (source, log_string);
    }
    atoms::ok().encode(env)
}

#[rustler::nif]
fn warn<'a>(env: Env<'a>, source: &str, log_string: &str) -> Term<'a> {
    #[cfg(windows)]
    {
        let _ = winlog::init(source);
        log_warn!("{}", log_string);
    }
    #[cfg(not(windows))]
    {
        let _ = (source, log_string);
    }
    atoms::ok().encode(env)
}

#[rustler::nif]
fn debug<'a>(env: Env<'a>, source: &str, log_string: &str) -> Term<'a> {
    #[cfg(windows)]
    {
        let _ = winlog::init(source);
        log_debug!("{}", log_string);
    }
    #[cfg(not(windows))]
    {
        let _ = (source, log_string);
    }
    atoms::ok().encode(env)
}

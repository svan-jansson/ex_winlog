# AGENTS.md

Guidelines for AI agents and automated tools contributing to **ex_winlog**.

---

## What this project is

`ex_winlog` is an Elixir Logger backend that writes log events to the Windows
Event Log. It is a thin Elixir wrapper over a Rust NIF (compiled via
[Rustler](https://github.com/rusterlium/rustler)) that in turn delegates to the
[winlog](https://crates.io/crates/winlog) crate.

The library is Windows-only. Every feature, bug fix, and test must work on
Windows. Do not introduce POSIX-only assumptions.

---

## Repository layout

```
lib/
  ex_winlog.ex            # GenEvent Logger backend – the public entry point
  ex_winlog/
    logger.ex             # Elixir helpers that call the NIF
    nif.ex                # Rustler NIF stub declarations
native/ex_winlog_nif/
  src/lib.rs              # Rust NIF implementation (winlog calls live here)
  Cargo.toml
test/
  ex_winlog_test.exs
mix.exs                   # Build config; Rustler compiler is added here
.formatter.exs
.travis.yml               # CI (Windows runners only)
```

---

## Building

Prerequisites: Elixir ≥ 1.9, Erlang/OTP, Rust toolchain (stable), Windows.

```powershell
mix deps.get
mix compile --force --warnings-as-errors
```

The `--warnings-as-errors` flag is enforced in CI; treat compiler warnings as
bugs.

---

## Testing

```powershell
mix test
```

Tests currently rely on doctest coverage. When adding new behaviour, add a
corresponding test in `test/ex_winlog_test.exs`. Tests that require a live
Windows Event Log (i.e. registration) must be tagged and skipped in CI if they
need administrator privileges, or documented clearly.

---

## Code conventions

### Elixir

- Format every file with `mix format` before committing.  The formatter config
  lives in `.formatter.exs`.
- Follow standard Elixir naming: `snake_case` functions, `CamelCase` modules.
- Public functions should have `@doc` and `@spec` annotations.
- Return values use tagged tuples (`{:ok, value}` / `{:error, reason}`) or
  atoms (`:ok`).  Do not raise exceptions across module boundaries.
- The NIF stubs in `ExWinlog.Nif` must match the exported names and arities in
  `lib.rs` exactly.

### Rust

- Format with `cargo fmt` before committing.
- NIF functions return `rustler::Atom` for simple outcomes and
  `rustler::error::Error` for failures – match the existing pattern.
- Error atoms are defined in `lib.rs`; keep the set minimal and consistent with
  what the Elixir layer pattern-matches on.
- Do not add Rust dependencies without a clear justification; the Cargo.lock is
  committed and changes are reviewed.

---

## Architecture notes

The call chain for a log event is:

```
Logger (Elixir) → ExWinlog.handle_event/2
  → ExWinlog.Logger.{info,warn,error,debug}/2
    → ExWinlog.Nif.<level>/2   (Rustler stub)
      → Rust NIF in lib.rs
        → winlog crate
          → Windows Event Log API
```

Key invariants:
- `handle_event/2` wraps the NIF call in a `try/rescue` so a failing NIF never
  crashes the Logger process.
- Both `binary` and `iodata` message formats are supported; convert with
  `IO.iodata_to_binary/1` before passing to the NIF.
- `ExWinlog` state only uses `event_source_name` and `level`; other GenEvent
  state fields are carried for interface compatibility but are not acted upon.

---

## What to work on

Good first contributions:
- Expanding test coverage (currently minimal).
- Adding `@spec` / `@type` to `ExWinlog.Logger`.
- Improving error messages returned from the NIF layer.
- Updating dependencies (`rustler`, `winlog`, `ex_doc`).

Areas requiring extra care:
- Anything touching the Rust NIF or Cargo dependencies – changes must compile
  and link correctly on Windows.
- Registry key manipulation in `ExWinlog.Logger.register/1` – test manually
  with and without administrator privileges.
- GenEvent callbacks – Elixir's GenEvent is deprecated in newer OTP versions;
  do not expand its surface; a future migration to a GenServer-based backend may
  be needed.

---

## Pull request checklist

- [ ] `mix compile --force --warnings-as-errors` passes.
- [ ] `mix test` passes.
- [ ] `mix format --check-formatted` passes.
- [ ] Rust code formatted with `cargo fmt --check`.
- [ ] New public functions have `@doc` and `@spec`.
- [ ] Commit messages are concise and in the imperative mood.
- [ ] No new Windows-incompatible assumptions are introduced.

---

## Out of scope

- Linux / macOS support – the underlying `winlog` crate and Windows Event Log
  are Windows-only.
- Structured / JSON logging – Windows Event Log has its own structured format;
  complex transformations belong in a separate library.
- Changing the Logger backend protocol – maintain compatibility with Elixir's
  standard `Logger` configuration conventions.

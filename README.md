# ExWinlog

This is a port of Rust's [winlog]([https://crates.io/crates/winlog) crate. It enables Elixir applications to log to the [Windows Event Log](https://docs.microsoft.com/windows/win32/wes/windows-event-log), using the `Logger` interface.

## Installation

Since this library uses `Rustler`, you must have Rust installed on the machine when compiling.

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ex_winlog` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_winlog, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/ex_winlog](https://hexdocs.pm/ex_winlog).


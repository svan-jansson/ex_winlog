<img src="logo/ex_winlog.svg" alt="ex_winlog" height="96px">

[![Build Status](https://travis-ci.com/svan-jansson/ex_winlog.svg?branch=master)](https://travis-ci.com/svan-jansson/ex_winlog)
[![Hex pm](https://img.shields.io/hexpm/v/ex_winlog.svg?style=flat)](https://hex.pm/packages/ex_winlog)

# ex_winlog - Log to Windows Event Log with Elixir

This library enables Elixir applications to log to the [Windows Event Log](https://docs.microsoft.com/windows/win32/wes/windows-event-log), using the `Logger` interface. It makes use of Rust's [winlog]([https://crates.io/crates/winlog) crate. Docs can be found at [https://hexdocs.pm/ex_winlog](https://hexdocs.pm/ex_winlog).

## Installation

Since this library uses `Rustler`, you must have Rust installed on the machine when compiling.

```elixir
def deps do
  [
    {:ex_winlog, "~> 0.1.5"}
  ]
end
```

## Usage

Since `ExWinlog` is a `Logger` backend, you can add it to your list of backends in your `config.exs` file like this:

```elixir
config :logger,
  backends: [:console, {ExWinlog, "My Event Source Name"}]
```

### Registering Event Sources

The `ExWinlog` backend requires that the event source, `"My Event Source Name"` in the example, is registered with Windows Event Viewer. Use `ExWinlog.register/1` and `ExWinlog.deregister/1`, while running the application as an administrator, to manage the sources. This should typically be done once when installing or uninstalling the application.

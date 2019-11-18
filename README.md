# ExWinlog

This is a port of Rust's [winlog]([https://crates.io/crates/winlog) crate. It enables Elixir applications to log to the [Windows Event Log](https://docs.microsoft.com/windows/win32/wes/windows-event-log), using the `Logger` interface. Docs can be found at [https://hexdocs.pm/ex_winlog](https://hexdocs.pm/ex_winlog).

## Installation

Since this library uses `Rustler`, you must have Rust installed on the machine when compiling.

```elixir
def deps do
  [
    {:ex_winlog, "~> 0.1.0"}
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
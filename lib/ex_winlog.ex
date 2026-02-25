defmodule ExWinlog do
  @moduledoc """
  `Logger` backend for the [Windows Event Log](https://docs.microsoft.com/windows/win32/wes/windows-event-log)

  ## Usage

  Add it to your list of `Logger` backends in your `config.exs` file like this:

  ```elixir
  config :logger,
      backends: [:console, {ExWinlog, "My Event Source Name"}]
  ```

  ### Registering Event Sources

  The `ExWinlog` backend requires that the event source, `"My Event Source Name"` in the example, is registered with Windows Event Viewer.
  Use `ExWinlog.register/1` and `ExWinlog.deregister/1`, while running the application as an administrator, to manage the sources.
  This should typically be done once when installing or uninstalling the application.
  """

  @behaviour GenEvent

  @default_state %{
    name: nil,
    path: nil,
    io_device: nil,
    inode: nil,
    format: nil,
    level: nil,
    metadata: nil,
    metadata_filter: nil,
    rotate: nil
  }

  @doc """
  Registers a new event source with Windows Event Viewer. Must be run as an administrator.
  """
  def register(event_source_name), do: ExWinlog.Logger.register(event_source_name)

  @doc """
  De-registers an existing event source with Windows Event Viewer. Must be run as an administrator.
  """
  def deregister(event_source_name), do: ExWinlog.Logger.deregister(event_source_name)

  @impl true
  def init({__MODULE__, event_source_name}) do
    state = Map.put(@default_state, :event_source_name, event_source_name)
    {:ok, state}
  end

  @impl true
  def handle_event(
        {level, _gl, {Logger, msg, _ts, _md}},
        %{level: min_level, event_source_name: event_source_name} = state
      ) do
    if is_nil(min_level) or Logger.compare_levels(level, min_level) != :lt do
      try do
          case msg do
              msg_iodata when is_list(msg_iodata) -> 
                  :ok = apply(ExWinlog.Logger, level, [event_source_name, IO.iodata_to_binary(msg_iodata)])
              msg_binary when is_binary(msg_binary) ->
                  :ok = apply(ExWinlog.Logger, level, [event_source_name, msg_binary]) 
          end
      catch _,_ -> 
           :ok
      end
    end

    {:ok, state}
  end

  @impl true
  def handle_call(_, state) do
    {:ok, :ok, state}
  end

  @impl true
  def handle_info(_, state) do
    {:ok, state}
  end

  @impl true
  def code_change(_old_vsn, state, _extra) do
    {:ok, state}
  end

  @impl true
  def terminate(_reason, _state) do
    :ok
  end
end

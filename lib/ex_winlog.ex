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

  @spec register(String.t()) :: {:ok, :event_source_registered} | {:error, atom()}
  def register(event_source_name), do: ExWinlog.Logger.register(event_source_name)

  @spec deregister(String.t()) :: {:ok, :event_source_deregistered} | {:error, atom()}
  def deregister(event_source_name), do: ExWinlog.Logger.deregister(event_source_name)

  @impl true
  def init({__MODULE__, event_source_name})
      when is_binary(event_source_name) and byte_size(event_source_name) > 0 do
    {:ok, %{event_source_name: event_source_name, level: nil}}
  end

  def init({__MODULE__, _invalid}) do
    {:error, :invalid_event_source_name}
  end

  @known_levels [:debug, :info, :warn, :warning, :error]

  @impl true
  def handle_event(
        {level, _gl, {Logger, msg, _ts, _md}},
        %{level: min_level, event_source_name: source} = state
      ) do
    if is_nil(min_level) or Logger.compare_levels(level, min_level) != :lt do
      log(level, source, msg)
    end

    {:ok, state}
  end

  def handle_event(:flush, state), do: {:ok, state}

  def handle_event(_, state), do: {:ok, state}

  @impl true
  def handle_call({:configure, opts}, state) do
    level = Keyword.get(opts, :level, state.level)
    {:ok, :ok, %{state | level: level}}
  end

  def handle_call(_, state), do: {:ok, :ok, state}

  @impl true
  def handle_info(_, state), do: {:ok, state}

  @impl true
  def code_change(_old_vsn, state, _extra), do: {:ok, state}

  @impl true
  def terminate(_reason, _state), do: :ok

  defp log(level, source, msg) when level in @known_levels do
    log_string =
      case msg do
        iodata when is_list(iodata) -> IO.iodata_to_binary(iodata)
        binary when is_binary(binary) -> binary
      end

    try do
      :ok = apply(ExWinlog.Logger, level, [source, log_string])
    catch
      _, _ -> :ok
    end
  end

  defp log(_level, _source, _msg), do: :ok
end

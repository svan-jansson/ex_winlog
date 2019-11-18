defmodule ExWinlog do
    @moduledoc """
    `Logger` backend for the [Windows Event Log](https://docs.microsoft.com/windows/win32/wes/windows-event-log)
    """

    @behaviour GenEvent
    
    @default_state %{name: nil, path: nil, io_device: nil, inode: nil, format: nil, level: nil, metadata: nil, metadata_filter: nil, rotate: nil}

    def init({__MODULE__, event_source_name}) do
        state = Map.put(@default_state, :event_source_name, event_source_name)
        {:ok, state}
    end

    def handle_event({level, _gl, {Logger, msg, _ts, _md}}, %{level: min_level, event_source_name: event_source_name} = state) do
        if (is_nil(min_level) or Logger.compare_levels(level, min_level) != :lt) do
            :ok = apply(ExWinlog.Logger, level, [event_source_name, msg])
        end
        {:ok, state}
    end

    def handle_call(_, state) do
        {:ok, :ok, state}
    end

    def handle_info(_, state) do
        {:ok, state}
    end

    def code_change(_old_vsn, state, _extra) do
        {:ok, state}
    end

    def terminate(_reason, _state) do
        :ok
    end

end

defmodule ExWinlog.WindowsTest do
  use ExUnit.Case

  @source "ExWinlogTest"

  setup do
    on_exit(fn -> ExWinlog.Nif.deregister(@source) end)
    :ok
  end

  @tag :windows
  test "registers an event source" do
    assert {:ok, :event_source_registered} = ExWinlog.Nif.register(@source)
  end

  @tag :windows
  test "deregisters an event source" do
    ExWinlog.Nif.register(@source)
    assert {:ok, :event_source_deregistered} = ExWinlog.Nif.deregister(@source)
  end

  @tag :windows
  test "logs at all levels" do
    ExWinlog.Nif.register(@source)
    assert :ok = ExWinlog.Nif.debug(@source, "debug message")
    assert :ok = ExWinlog.Nif.info(@source, "info message")
    assert :ok = ExWinlog.Nif.warn(@source, "warn message")
    assert :ok = ExWinlog.Nif.warning(@source, "warning message")
    assert :ok = ExWinlog.Nif.error(@source, "error message")
  end
end

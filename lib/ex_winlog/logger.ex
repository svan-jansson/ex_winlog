defmodule ExWinlog.Logger do
  @moduledoc false

  alias ExWinlog.Nif

  @reg_key "\\hkey_local_machine\\system\\CurrentControlSet\\Services\\EventLog\\Application\\"

  def register(event_source_name) do
    reg_key = (@reg_key <> event_source_name <> "\\") |> String.to_charlist()

    event_message_file =
      (Application.app_dir(:ex_winlog, "priv/native") <> "/libex_winlog_nif.dll")
      |> String.replace("/", "\\")
      |> String.to_charlist()

    with {:ok, :event_source_registered} <- Nif.register(event_source_name),
         {:ok, reg_handle} <- :win32reg.open([:read, :write]),
         :ok <- :win32reg.change_key(reg_handle, reg_key),
         :ok <- :win32reg.set_value(reg_handle, "EventMessageFile", event_message_file),
         :ok <- :win32reg.close(reg_handle) do
      {:ok, :event_source_registered}
    end
  end

  def deregister(event_source_name), do: Nif.deregister(event_source_name)
  def info(event_source_name, log_string), do: Nif.info(event_source_name, log_string)
  def error(event_source_name, log_string), do: Nif.error(event_source_name, log_string)
  def warn(event_source_name, log_string), do: Nif.warn(event_source_name, log_string)
  def debug(event_source_name, log_string), do: Nif.debug(event_source_name, log_string)
end

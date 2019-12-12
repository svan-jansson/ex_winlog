# credo:disable-for-this-file
defmodule ExWinlog.Nif do
  @moduledoc false
  use Rustler, otp_app: :ex_winlog, crate: "ex_winlog_nif"

  def register(_event_source_name), do: :erlang.nif_error(:nif_not_loaded)
  def deregister(_event_source_name), do: :erlang.nif_error(:nif_not_loaded)
  def info(_event_source_name, _log_string), do: :erlang.nif_error(:nif_not_loaded)
  def error(_event_source_name, _log_string), do: :erlang.nif_error(:nif_not_loaded)
  def warn(_event_source_name, _log_string), do: :erlang.nif_error(:nif_not_loaded)
  def debug(_event_source_name, _log_string), do: :erlang.nif_error(:nif_not_loaded)
end

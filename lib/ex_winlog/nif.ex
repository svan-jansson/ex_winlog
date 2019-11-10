defmodule ExWinlog.Nif do
    @moduledoc false
    use Rustler, otp_app: :ex_winlog, crate: "ex_winlog_nif"

    def register(_event_source_name), do: :erlang.nif_error(:nif_not_loaded)
end
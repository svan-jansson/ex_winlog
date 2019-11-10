defmodule ExWinlog.Nif do
    use Rustler, otp_app: :ex_winlog, crate: "ex_winlog_nif"

    def add(_a, _b), do: :erlang.nif_error(:nif_not_loaded)
end
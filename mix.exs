defmodule ExWinlog.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_winlog,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      compilers: [:rustler] ++ Mix.compilers(),
      rustler_crates: [ex_winlog_nif: [mode: if(Mix.env() == :prod, do: :release, else: :debug)]]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:rustler, "~> 0.21.0"}
    ]
  end
end

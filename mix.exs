defmodule ExWinlog.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_winlog,
      version: "0.1.8",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      compilers: [:rustler] ++ Mix.compilers(),
      rustler_crates: [ex_winlog_nif: [mode: if(Mix.env() == :prod, do: :release, else: :debug)]],
      description: description(),
      package: package(),
      docs: [
        logo: "logo/ex_winlog.svg.png"
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:credo, "~> 1.1.0", only: [:dev, :test], runtime: false},
      {:rustler, "~> 0.21.0"}
    ]
  end

  defp description do
    """
    Elixir Logger Backend that enables applications to log to the Windows Event Log
    """
  end

  defp package do
    [
      maintainers: ["Svan Jansson"],
      licenses: ["MIT"],
      links: %{Github: "https://github.com/svan-jansson/ex_winlog"},
      files: ~w(lib .formatter.exs mix.exs README* LICENSE* native)
    ]
  end
end

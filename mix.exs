defmodule ExWinlog.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_winlog,
      version: "0.0.0-dev",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
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
      {:ex_doc, "~> 0.34", only: :dev, runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:rustler, "~> 0.37"}
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

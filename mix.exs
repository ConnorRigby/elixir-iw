defmodule Iw.MixProject do
  use Mix.Project

  def project do
    [
      app: :iw,
      version: "0.2.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      compilers: [:elixir_make | Mix.compilers()],
      make_targets: ["all"],
      make_clean: ["clean"],
      package: package(),
      deps: deps()
    ]
  end

  def package do
    [
      licenses: ["ISC"],
      links: %{
        github: "https://github.com/ConnorRigby/elixir-iw",
        iw: "https://wireless.wiki.kernel.org/en/users/documentation/iw"
      },
      files: ~w(lib .formatter.exs mix.exs README* LICENSE* Makefile),
      description: description()
    ]
  end

  def description do
    "A cross crompilation mix wrapper around iw"
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:elixir_make, "~> 0.5", runtime: false},
      {:vintage_net, "~> 0.3.1", optional: true},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false}
    ]
  end
end

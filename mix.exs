defmodule Clex.MixProject do
  use Mix.Project

  def project do
    [
      app: :clex,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      description: description(),
      package: package(),
      deps: deps(),

      # Docs.
      name: "Clex",
      source_url: "https://github.com/arpieb/clex",
      homepage_url: "https://github.com/arpieb/clex",
      docs: [
        logo: "assets/clex-logo.png",
        main: "readme",
        extras: [
          "README.md",
          "LICENSE.md"
        ]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :cl]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:ex_doc, "~> 0.19.3", only: :dev},
      {:cl, git: "https://github.com/arpieb/cl.git", branch: "master"},
    ]
  end

  defp description do
    """
    This package provides an Elixir wrapper for the excellent OpenCL 1.x NIF developed by @tonyrog.
    """
  end

  defp package do
    [
      files: [
        "lib",
        "c_src",
        "mix.exs",
        "README*",
        "LICENSE*",
        "Makefile",
      ],
      maintainers: ["Robert Bates"],
      licenses: ["Apache 2.0"],
      links: %{
        "GitHub" => "https://github.com/arpieb/clex",
        "Khronos OpenCL Registry" => "https://www.khronos.org/registry/OpenCL/",
        "tonyrog/cl" => "https://github.com/tonyrog/cl",
      },
    ]
  end

end

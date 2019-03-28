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
        logo: "pages/assets/clex-logo.png",
        main: "readme",
        extras: [
          "README.md",
          "LICENSE.md"
        ],
        groups_for_modules: [
          "Versioned APIs": [Clex.CL10, Clex.CL11, Clex.CL12],
          "Records": [Clex.CL.ImageDesc, Clex.CL.ImageFormat],
        ],
        groups_for_functions: [
          "Platform": & &1[:group] == :platform,
          "Devices": & &1[:group] == :devices,
          "Context": & &1[:group] == :context,
          "Command Queues": & &1[:group] == :command_queues,
          "Memory Objects": & &1[:group] == :memory_objects,
          "Sampler Objects": & &1[:group] == :sampler_objects,
          "Program Objects": & &1[:group] == :program_objects,
          "Kernel Objects": & &1[:group] == :kernel_objects,
          "Execution of Kernels": & &1[:group] == :exec_kernels,
          "Event Objects": & &1[:group] == :event_objects,
          "Synchronization": & &1[:group] == :synchronization,
          "Flush and Finish": & &1[:group] == :flush_and_finish,
        ],
      ],
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
      {:ex_doc, "~> 0.19.3", only: :dev},
      {:cl, git: "https://github.com/tonyrog/cl.git", ref: "0e49a47e78a1eb207c9968a2453447c55adbc3f9"},
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
        "mix.exs",
        "README*",
        "LICENSE*",
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

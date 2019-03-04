defmodule Clex.VersionedApi do
  @moduledoc ~S"""
  Defines the `versioned_api` macro to pull the function-level docs and map calls to Clex.CL module.
  """

  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__)
    end
  end

  @doc ~S"""
  Macro to create a reference to a function defined in Clex.CL + docs so we don't have a lot of copy-pasta to provide
  OpenCL version-specific subsets of all OpenCL API calls available.

  - `name` is an atom for the function name in Clex.CL
  - `args` is the list of argument names for the function, taken from the Clex.CL function declaration being mapped

  Example:

  ```elixir
  add_cl_func :get_device_ids, [platform, device_type]
  ```
  """
  defmacro add_cl_func(name, args) do
    arity = Kernel.length(args)
    # {:docs_v1, _annotation, :elixir, _format, _module_doc, _metadata, docs} = Code.fetch_docs(Clex.CL)
    # {_key, _annotation, _sig, %{"en" => _fn_doc}, _meta} = List.keyfind(docs, {:function, name, arity}, 0)

    quote do
      @doc """
      See `Clex.CL.#{unquote(name)}/#{unquote(arity)}` for implementation details.
      """
      def unquote(name)(unquote_splicing(args)) do
        apply(Clex.CL, unquote(name), [unquote_splicing(args)])
      end
    end
  end

end

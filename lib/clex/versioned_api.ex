defmodule Clex.VersionedApi do
  @moduledoc false
  # Defines the `versioned_api` macro to pull the function-level docs and map calls to Clex.CL module.

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
    # Make sure the module(s) we need to be compiled for our macros, are.
    Code.ensure_compiled(Clex.CL)

    arity = Kernel.length(args)
    fn_doc =
      case Code.fetch_docs(Clex.CL) do
        {:docs_v1, _annotation, :elixir, _format, _module_doc, _metadata, docs} ->
          case List.keyfind(docs, {:function, name, arity}, 0) do
            {_key, _annotation, _sig, %{"en" => fn_doc}, _meta} -> fn_doc
            _ -> ""
          end
        _ -> ""
      end

    quote do
      @doc """
      #{unquote(fn_doc)}

      See `Clex.CL.#{unquote(name)}/#{unquote(arity)}` for full function parameter specification.
      """
      def unquote(name)(unquote_splicing(args)) do
        apply(Clex.CL, unquote(name), [unquote_splicing(args)])
      end
    end
  end

end

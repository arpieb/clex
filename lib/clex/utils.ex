defmodule Clex.Utils do
  @moduledoc ~S"""
  This module contains a collection of utility functions that work across all OpenCL versions, but do not exist in the
  formal OpenCL specifications.
  """

  alias Clex.CL

  @doc ~S"""
  Used to set multiple argument values for a kernel, starting at offset 0.
  Passing too many items will result in an `:invalid_arg_index` error.

  ### Parameters

  `kernel` \
  A valid kernel object.

  `index` \
  The argument index. Arguments to the kernel are referred by indices that go from 0 for the leftmost argument to n - 1, where n is the total number of arguments declared by a kernel.

  `args` \
  List of argument values to set, each one of the following types: `cl_mem`, `integer`, `float`, or `binary`.
  """
  @doc group: :kernel_objects
  @spec set_kernel_args(kernel::CL.cl_kernel, args::list(CL.cl_kernel_arg)) :: :ok | {:error, non_neg_integer, CL.cl_error}
  def set_kernel_args(kernel, args), do: set_kernel_args(kernel, args, 0)

  # Terminate recursion
  defp set_kernel_args(_kernel, [], _index), do: :ok

  # Start recursion on args list, setting each one
  defp set_kernel_args(kernel, args, index) do
    case :cl.set_kernel_arg(kernel, index, hd(args)) do
      :ok -> set_kernel_args(kernel, tl(args), index + 1)
      {:error, cl_err} -> {:error, index, cl_err}
    end
  end

end

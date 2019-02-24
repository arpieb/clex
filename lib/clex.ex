defmodule Clex do
  @moduledoc """
  Wrapper for `:clu` module
  """

  def apply_kernel_args(kernel, args) do #/2
    :clu.apply_kernel_args(kernel, args)
  end

  def build_binary(clu_state, {device_list, binary_list}) do #/2
    :clu.build_binary(clu_state, {device_list, binary_list})
  end

  def build_binary(clu_state, {device_list, binary_list}, options) do #/3
    :clu.build_binary(clu_state, {device_list, binary_list}, options)
  end

  def build_source(clu_state, source) do #/2
    :clu.build_source(clu_state, source)
  end

  def build_source(clu_state, source, options) do #/3
    :clu.build_source(clu_state, source, options)
  end

  def build_source_file(clu_state, file) do #/2
    :clu.build_source_file(clu_state, file)
  end

  def build_source_file(clu_state, file, options) do #/3
    :clu.build_source_file(clu_state, file, options)
  end

  def compile_file(file) do #/1
    :clu.compile_file(file)
  end

  def compile_file(file, options) do #/2
    :clu.compile_file(file, options)
  end

  def context(clu_state) do #/1
    :clu.context(clu_state)
  end

  def device(clu_state) do  #/1
    :clu.device(clu_state)
  end

  def device_has_extension(device, extension) do #/2
    :clu.device_has_extension(device, extension)
  end

  def devices_have_extension(clu_state, extension) do #/2
    :clu.devices_has_extension(clu_state, extension)
  end

  def device_list(clu_state) do #/1
    :clu.device_list(clu_state)
  end

  def get_program_binaries(program) do #/1
    :clu.get_program_binaries(program)
  end

  def setup() do #/0
    :clu.setup()
  end

  def setup(dev_type) do #/1
    :clu.setup(dev_type)
  end

  def teardown(clu_state) do #/1
    :clu.teardown(clu_state)
  end

  def wait_complete(event) do #/1
    :clu.wait_complete(event)
  end
end

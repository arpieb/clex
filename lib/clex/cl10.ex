defmodule Clex.CL10 do
  @moduledoc ~S"""
  This module provides a wrapper for OpenCL 1.0 API calls
  """

  @opaque cl_platform      :: {:platform_t, any, reference}
  @opaque cl_device        :: {:device_t, any, reference}
  @opaque cl_context       :: {:context_t, any, reference}
  @opaque cl_command_queue :: {:command_queue_t, any, reference}
  @opaque cl_mem           :: {:mem_t, any, reference}
  @opaque cl_sampler       :: {:sampler_t, any, reference}
  @opaque cl_program       :: {:program_t, any, reference}
  @opaque cl_kernel        :: {:kernel_t, any, reference}
  @opaque cl_event         :: {:event_t, any, reference}

  @type cl_error :: any

  ########################################
  # Platform
  ########################################

  @doc ~S"""
  Query the OpenCL driver for all available compute platforms
  """
  @spec get_platform_ids() :: {:ok, list(cl_platform)} | {:error, cl_error}
  def get_platform_ids() do
    :cl.get_platform_ids()
  end

  @doc ~S"""
  Query a platform for all properties
  """
  @spec get_platform_info(platform::cl_platform) :: {:ok, keyword()} | {:error, cl_error}
  def get_platform_info(platform) do
    :cl.get_platform_info(platform)
  end

  @doc ~S"""
  Query a platform for a specific property.

  See `Clex.CL10.platform_info/0` for list of available properties.
  """
  @spec get_platform_info(platform::cl_platform, property::atom) :: {:ok, any} | {:error, cl_error}
  def get_platform_info(platform, property) do
    :cl.get_platform_info(platform, property)
  end

  @doc ~S"""
  Returns the list of property keys for OpenCL platform information
  """
  @spec platform_info() :: {:ok, list(atom)}
  def platform_info() do
    :cl.platform_info()
  end

  ########################################
  # Devices
  ########################################

  @doc ~S"""
  Query a platform for all devices of a certain type.

  Type can be one of `:gpu`, `:cpu`, `:accelerator`, `:custom`, `:all`, or `:default`.
  """
  @spec get_device_ids(platform::cl_platform, device_type::atom) :: {:ok, list(cl_device)} | {:error, cl_error}
  def get_device_ids(platform, device_type) do
    :cl.get_device_ids(platform, device_type)
  end

  @doc ~S"""
  Query a device for all properties
  """
  @spec get_device_info(device::cl_device) :: {:ok, keyword()} | {:error, cl_error}
  def get_device_info(device) do
    :cl.get_device_info(device)
  end

  @doc ~S"""
  Query a device for a specific property.

  See `Clex.CL10.device_info/0` for list of available properties.
  """
  @spec get_device_info(device::cl_device, property::atom) :: {:ok, any} | {:error, cl_error}
  def get_device_info(device, property) do
    :cl.get_device_info(device, property)
  end

  @doc ~S"""
  Returns the list of property keys for OpenCL device information
  """
  @spec device_info() :: {:ok, list(atom)}
  def device_info() do
    :cl.device_info()
  end

  ########################################
  # Context
  ########################################

  @doc ~S"""
  Create an OpenCL context from one or more devices.
  """
  @spec create_context(devices::list(cl_device)) :: {:ok, cl_context} | {:error, cl_error}
  def create_context(devices) do
    :cl.create_context(devices)
  end

  @doc ~S"""
  Create an OpenCL context from all devices of the given type.

  Type can be one of `:gpu`, `:cpu`, `:accelerator`, `:custom`, `:all`, or `:default`.
  """
  @spec create_context_from_type(device_type::atom) :: {:ok, cl_context} | {:error, cl_error}
  def create_context_from_type(device_type) do
    :cl.create_context_from_type(device_type)
  end

  @doc ~S"""
  Decrement the reference count on a context.

  Once the reference count goes to zero and all attached resources are released, the context is deleted.
  To increment the reference count, see `Clex.CL10.retain_context/1`.
  """
  @spec release_context(context::cl_context) :: :ok | {:error, cl_error}
  def release_context(context) do
    :cl.release_context(context)
  end

  @doc ~S"""
  Increment the reference count on a context.

  To decrement the reference count, see `Clex.CL10.release_context/1`.
  """
  @spec retain_context(context::cl_context) :: :ok | {:error, cl_error}
  def retain_context(context) do
    :cl.retain_context(context)
  end

  @doc ~S"""
  Returns the list of property keys for OpenCL context information
  """
  @spec context_info() :: {:ok, list(atom)}
  def context_info() do
    :cl.context_info()
  end

  @doc ~S"""
  Query a context for all properties
  """
  @spec get_context_info(context::cl_context) :: {:ok, keyword()} | {:error, cl_error}
  def get_context_info(context) do
    :cl.get_context_info(context)
  end

  @doc ~S"""
  Query a context for a specific property.

  See `Clex.CL10.context_info/0` for list of available properties.
  """
  @spec get_context_info(context::cl_context, property::atom) :: {:ok, any} | {:error, cl_error}
  def get_context_info(context, property) do
    :cl.get_context_info(context, property)
  end

  ########################################
  # Command Queue
  ########################################

#  def create_queue() do #/3
#  end
#
#  def set_queue_property() do #/3
#  end
#
#  def release_queue() do #/1
#  end
#
#  def retain_queue() do #/1
#  end
#
#  def queue_info() do #/0
#  end
#
#  def get_queue_info() do #/1
#  end
#
#  def get_queue_info() do #/2
#  end

  ########################################
  # Memory Object
  ########################################

#  def create_buffer() do #/3
#  end
#
#  def create_buffer() do #/4
#  end
#
#  def release_mem_object() do #/1
#  end
#
#  def retain_mem_object() do #/1
#  end
#
#  def mem_object_info() do #/0
#  end
#
#  def get_mem_object_info() do #/1
#  end
#
#  def get_mem_object_info() do #/2
#  end
#
#  def image_info() do #/0
#  end
#
#  def get_image_info() do #/1
#  end
#
#  def get_image_info() do #/2
#  end
#
#  def get_supported_image_formats() do #/3
#  end
#
#  def create_image2d() do #/7
#  end
#
#  def create_image3d() do #/9
#  end

  ########################################
  # Sampler
  ########################################

#  def create_sampler() do #/4
#  end
#
#  def release_sampler() do #/1
#  end
#
#  def retain_sampler() do #/1
#  end
#
#  def sampler_info() do #/0
#  end
#
#  def get_sampler_info()do #/1
#  end
#
#  def get_sampler_info() do #/2
#  end

  ########################################
  # Program
  ########################################

#  def create_program_with_binary() do #/3
#  end
#
#  def create_program_with_source() do #/2
#  end
#
#  def release_program() do #/1
#  end
#
#  def retain_program() do #/1
#  end
#
#  def build_program() do #/3
#  end
#
#  def async_build_program() do #/3
#  end
#
#  def unload_compiler() do #/0
#  end
#
#  def program_info() do #/0
#  end
#
#  def get_program_info() do #/1
#  end
#
#  def get_program_info() do #/2
#  end
#
#  def program_build_info() do #/0
#  end
#
#  def get_program_build_info() do #/2
#  end
#
#  def get_program_build_info() do #/3
#  end

  ########################################
  # Kernel
  ########################################

#  def create_kernel() do #/2
#  end
#
#  def create_kernels_in_program() do #/1
#  end
#
#  def set_kernel_arg() do #/3
#  end
#
#  def set_kernel_arg_size() do #/3
#  end
#
#  def release_kernel() do #/1
#  end
#
#  def retain_kernel() do #/1
#  end
#
#  def kernel_info() do #/0
#  end
#
#  def get_kernel_info() do #/1
#  end
#
#  def get_kernel_info() do #/2
#  end
#
#  def kernel_workgroup_info() do #/0
#  end
#
#  def get_kernel_workgroup_info() do #/2
#  end
#
#  def get_kernel_workgroup_info() do #/3
#  end

  ########################################
  # Events
  ########################################

#  def enqueue_task() do #/3
#  end
#
#  def enqueue_task() do #/4
#  end
#
#  def nowait_enqueue_task() do #/3
#  end
#
#  def enqueue_nd_range_kernel() do #/5
#  end
#
#  def enqueue_nd_range_kernel() do #/6
#  end
#
#  def nowait_enqueue_nd_range_kernel() do #/5
#  end
#
#  def enqueue_marker() do #/1
#  end
#
#  def enqueue_barrier() do #/1
#  end
#
#  def enqueue_wait_for_events() do #/2
#  end
#
#  def enqueue_read_buffer() do #/5
#  end
#
#  def enqueue_write_buffer() do #/6
#  end
#
#  def enqueue_write_buffer() do #/7
#  end
#
#  def nowait_enqueue_write_buffer() do #/6
#  end
#
#  def enqueue_read_image() do #/7
#  end
#
#  def enqueue_write_image() do #/8
#  end
#
#  def enqueue_write_image() do #/9
#  end
#
#  def nowait_enqueue_write_image() do #/8
#  end
#
#  def enqueue_copy_image() do #/6
#  end
#
#  def enqueue_copy_image_to_buffer() do #/7
#  end
#
#  def enqueue_copy_buffer_to_image() do #/7
#  end
#
#  def enqueue_map_buffer() do #/6
#  end
#
#  def enqueue_map_image() do #/6
#  end
#
#  def enqueue_unmap_mem_object() do #/3
#  end
#
#  def release_event() do #/1
#  end
#
#  def retain_event() do #/1
#  end
#
#  def event_info() do #/0
#  end
#
#  def get_event_info() do #/1
#  end
#
#  def get_event_info() do #/2
#  end
#
#  def wait() do #/1
#  end
#
#  def wait() do #/2
#  end
#
#  def wait_for_event() do #/1
#  end
#
#  def async_wait_for_event() do #/1
#  end

  ########################################
  # Misc
  ########################################

#  def start() do #/0
#  end
#
#  def start() do #/1
#  end
#
#  def flush() do #/1
#  end
#
#  def async_flush() do #/1
#  end
#
#  def finish() do #/1
#  end
#
#  def async_finish() do #/1
#  end
#
#  def stop() do #/0
#  end

end

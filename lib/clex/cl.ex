defmodule Clex.CL do
  @moduledoc ~S"""
  This module provides a wrapper for OpenCL API functions and types exported by the [`:cl`](https://github.com/tonyrog/cl) Erlang module in addition to some convenience revisions to make the functions more idiomatic Elixir where possible.
  """

  require Clex.CL.ImageFormat
  require Clex.CL.ImageDesc

  @opaque cl_platform               :: {:platform_t, any, reference}
  @opaque cl_device                 :: {:device_t, any, reference}
  @opaque cl_context                :: {:context_t, any, reference}
  @opaque cl_command_queue          :: {:command_queue_t, any, reference}
  @opaque cl_mem                    :: {:mem_t, any, reference}
  @opaque cl_sampler                :: {:sampler_t, any, reference}
  @opaque cl_program                :: {:program_t, any, reference}
  @opaque cl_kernel                 :: {:kernel_t, any, reference}
  @opaque cl_event                  :: {:event_t, any, reference}
  @type   cl_error                  :: any

  @type   cl_device_type            :: :gpu | :cpu | :accelerator | :custom | :all | :default
  @type   cl_sub_devices_property   :: {:equally, non_neg_integer} |
                                       {:by_counts, [non_neg_integer]} |
                                       {:by_affinity_domain, :numa | :l4_cache | :l3_cache | :l2_cache | :l1_cache | :next_partitionable}
  @type   cl_command_queue_property :: :out_of_order_exec_mode_enable | :profiling_enabled
  @type   cl_mem_flag               :: :read_write | :write_only | :read_only | :use_host_ptr | :alloc_host_ptr | :copy_host_ptr
  @type   cl_buffer_create_type     :: :region
  @type   cl_kernel_arg             :: cl_mem | integer | float | binary
  @type   cl_map_flag               :: :read | :write
  @type   cl_start_arg              :: {:debug, boolean}
  @type   cl_mem_object_type        :: :buffer | :image2d | :image3d |
                                       :image2d_array | :image1d | :image1d_array | :image1d_buffer
  @type   cl_addressing_mode        :: :none | :clamp_to_edge | :clamp | :repeat
  @type   cl_filter_mode            :: :nearest | :linear
  @type   cl_cache_type             :: :none | :read_only | :read_write
  @type   cl_channel_order          :: :r | :a | :rg | :ra | :rgb | :rgba | :bgra | :argb | :intensity | :luminance | :rx | :rgx | :rgbx | :depth | :depth_stencil
  @type   cl_channel_type           :: :snorm_int8 | :snorm_int16 |
                                       :unorm_int8 | :unorm_int16  | :unorm_int24 | :unorm_short_565 | :unorm_short_555 | :unorm_int_101010 |
                                       :signed_int8 | :signed_int16 | :signed_int32 |
                                       :unsigned_int8 | :unsigned_int16 | :unsigned_int32 |
                                       :half_float | :float

  # Records
  @type   cl_image_format           :: Clex.CL.ImageFormat.t
  @type   cl_image_desc             :: Clex.CL.ImageDesc.t

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

  ########################################
  # Devices
  ########################################

  @doc ~S"""
  Query a platform for all devices of a certain type.

  Type can be one of `:gpu`, `:cpu`, `:accelerator`, `:custom`, `:all`, or `:default`.
  """
  @spec get_device_ids(platform::cl_platform, device_type::cl_device_type) :: {:ok, list(cl_device)} | {:error, cl_error}
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
  Partition the given device into one or more logical subdevices by the criteria given by `property`.
  """
  @spec create_sub_devices(device::cl_device, property::cl_sub_devices_property) :: {:ok, list(cl_device)} | {:error, cl_error}
  def create_sub_devices(device, property) do
    :cl.create_sub_devices(device, property)
  end

  @doc ~S"""
  Decrement the reference count on a device.

  Once the reference count goes to zero and all attached resources are released, the device is deleted.
  To increment the reference count, see `Clex.CL.retain_device/1`.
  """
  @spec release_device(device::cl_device) :: :ok | {:error, cl_error}
  def release_device(device) do
    :cl.release_device(device)
  end

  @doc ~S"""
  Increment the reference count on a device.

  To decrement the reference count, see `Clex.CL.release_device/1`.
  """
  @spec retain_device(device::cl_device) :: :ok | {:error, cl_error}
  def retain_device(device) do
    :cl.retain_device(device)
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
  @spec create_context_from_type(platform::cl_platform, device_type::cl_device_type) :: {:ok, cl_context} | {:error, cl_error}
  def create_context_from_type(platform, device_type) do
    case get_device_ids(platform, device_type) do
      {:ok, devices} ->
        create_context(devices)
      err ->
        err
    end
  end

  @doc ~S"""
  Decrement the reference count on a context.

  Once the reference count goes to zero and all attached resources are released, the context is deleted.
  To increment the reference count, see `Clex.CL.retain_context/1`.
  """
  @spec release_context(context::cl_context) :: :ok | {:error, cl_error}
  def release_context(context) do
    :cl.release_context(context)
  end

  @doc ~S"""
  Increment the reference count on a context.

  To decrement the reference count, see `Clex.CL.release_context/1`.
  """
  @spec retain_context(context::cl_context) :: :ok | {:error, cl_error}
  def retain_context(context) do
    :cl.retain_context(context)
  end

  @doc ~S"""
  Query a context for all properties
  """
  @spec get_context_info(context::cl_context) :: {:ok, keyword()} | {:error, cl_error}
  def get_context_info(context) do
    :cl.get_context_info(context)
  end

  ########################################
  # Command Queue
  ########################################

  @doc ~S"""
  Create a command queue for processing OpenCL commands, with properties.
  """
  @spec create_queue(context::cl_context, device::cl_device, properties::list(cl_command_queue_property)) :: {:ok, cl_command_queue} | {:error, cl_error}
  def create_queue(context, device, properties) do
    :cl.create_queue(context, device, properties)
  end

  @doc ~S"""
  Create a command queue for processing OpenCL commands.
  """
  @spec create_queue(context::cl_context, device::cl_device) :: {:ok, cl_command_queue} | {:error, cl_error}
  def create_queue(context, device) do
    :cl.create_queue(context, device, [])
  end

  @doc ~S"""
  Decrement the reference count on a command queue.

  Once the reference count goes to zero and all attached resources are released, the queue is deleted.
  To increment the reference count, see `Clex.CL.retain_queue/1`.
  """
  @spec release_queue(queue::cl_command_queue) :: :ok | {:error, cl_error}
  def release_queue(queue) do
    :cl.release_queue(queue)
  end

  @doc ~S"""
  Increment the reference count on a command queue.

  To decrement the reference count, see `Clex.CL.release_queue/1`.
  """
  @spec retain_queue(queue::cl_command_queue) :: :ok | {:error, cl_error}
  def retain_queue(queue) do
    :cl.retain_queue(queue)
  end

  @doc ~S"""
  Query a command queue for all properties
  """
  @spec get_queue_info(queue::cl_command_queue) :: {:ok, keyword()} | {:error, cl_error}
  def get_queue_info(queue) do
    :cl.get_queue_info(queue)
  end

  ########################################
  # Memory Object
  ########################################

  @doc ~S"""
  Create a memory buffer in the given context, of the requested size, configured by the given flags.
  """
  @spec create_buffer(context::cl_context, flags::list(cl_mem_flag), size::non_neg_integer) :: {:ok, cl_mem} | {:error, cl_error}
  def create_buffer(context, flags, size) do
    :cl.create_buffer(context, flags, size)
  end

  @doc ~S"""
  Create a memory buffer in the given context, of the requested size, configured by the given flags, and initializes the buffer with the provided data.
  """
  @spec create_buffer(context::cl_context, flags::list(cl_mem_flag), size::non_neg_integer, data::iolist) :: {:ok, cl_mem} | {:error, cl_error}
  def create_buffer(context, flags, size, data) do
    :cl.create_buffer(context, flags, size, data)
  end

  @doc ~S"""
  Create a memory buffer from a region in an existing memory buffer for the given flags, origin, and size.
  """
  @spec create_sub_buffer(buffer::cl_mem, flags::list(cl_mem_flag), type::cl_buffer_create_type, origin::non_neg_integer, size::non_neg_integer) :: {:ok, cl_mem} | {:error, cl_error}
  def create_sub_buffer(buffer, flags, type, origin, size) do
    :cl.create_sub_buffer(buffer, flags, type, [origin, size])
  end

  @doc ~S"""
  Decrement the reference count on a memory buffer.

  Once the reference count goes to zero and all attached resources are released, the memory buffer is deleted.
  To increment the reference count, see `Clex.CL.retain_mem_object/1`.
  """
  @spec release_mem_object(buffer::cl_mem) :: :ok | {:error, cl_error}
  def release_mem_object(buffer) do
    :cl.release_mem_object(buffer)
  end

  @doc ~S"""
  Increment the reference count on a memory buffer.

  To decrement the reference count, see `Clex.CL.release_mem_object/1`.
  """
  @spec retain_mem_object(buffer::cl_mem) :: :ok | {:error, cl_error}
  def retain_mem_object(buffer) do
    :cl.retain_mem_object(buffer)
  end

  @doc ~S"""
  Query a memory buffer for all properties
  """
  @spec get_mem_object_info(buffer::cl_mem) :: {:ok, keyword()} | {:error, cl_error}
  def get_mem_object_info(buffer) do
    :cl.get_mem_object_info(buffer)
  end

  @doc ~S"""
  Creates a 2D image object.
  """
  @spec create_image2d(context::cl_context, flags::list(cl_mem_flag), image_format::cl_image_format, width::non_neg_integer, height::non_neg_integer, row_pitch::non_neg_integer, data::binary) :: {:ok, cl_mem} | {:error, cl_error}
  def create_image2d(context, flags, image_format, width, height, row_pitch, data) do
    :cl.create_image2d(context, flags, image_format, width, height, row_pitch, data)
  end

  @doc ~S"""
  Creates a 3D image object.
  """
  @spec create_image3d(context::cl_context, flags::list(cl_mem_flag), image_format::cl_image_format, width::non_neg_integer, height::non_neg_integer, depth::non_neg_integer, row_pitch::non_neg_integer, slice_pitch::non_neg_integer, data::binary) :: {:ok, cl_mem} | {:error, cl_error}
  def create_image3d(context, flags, image_format, width, height, depth, row_pitch, slice_pitch, data) do
    :cl.create_image3d(context, flags, image_format, width, height, depth, row_pitch, slice_pitch, data)
  end

  @doc ~S"""
  Get the list of image formats supported by an OpenCL implementation.
  """
  @spec get_supported_image_formats(context::cl_context, flags::list(cl_mem_flag), image_type::cl_mem_object_type) :: {:ok, list(tuple)} | {:error, cl_error}
  def get_supported_image_formats(context, flags, image_type) do
    :cl.get_supported_image_formats(context, flags, image_type)
  end

  @doc ~S"""
  Enqueues a command to read from a 2D or 3D image object to host memory.
  """
  @spec enqueue_read_image(queue::cl_command_queue, image::cl_mem, origin::list(non_neg_integer), region::list(non_neg_integer), row_pitch::non_neg_integer, slice_pitch::non_neg_integer, waitlist::list(cl_event)) :: {:ok, cl_event} | {:error, cl_error}
  def enqueue_read_image(queue, image, origin, region, row_pitch, slice_pitch, waitlist) do
    :cl.enqueue_read_image(queue, image, origin, region, row_pitch, slice_pitch, waitlist)
  end

  @doc ~S"""
  Enqueues a command to write from a 2D or 3D image object to host memory, with event to synchornize on.
  """
  @spec enqueue_write_image(queue::cl_command_queue, image::cl_mem, origin::list(non_neg_integer), region::list(non_neg_integer), row_pitch::non_neg_integer, slice_pitch::non_neg_integer, data::binary, waitlist::list(cl_event)) :: {:ok, cl_event} | {:error, cl_error}
  def enqueue_write_image(queue, image, origin, region, row_pitch, slice_pitch, data, waitlist) do
    :cl.enqueue_write_image(queue, image, origin, region, row_pitch, slice_pitch, data, waitlist)
  end

  @doc ~S"""
  Enqueues a command to copy image objects.
  """
  @spec enqueue_copy_image(queue::cl_command_queue, src_image::cl_mem, dest_image::cl_mem, src_origin::list(non_neg_integer), dest_origin::list(non_neg_integer), region::list(non_neg_integer), waitlist::list(cl_event)) :: {:ok, cl_event} | {:error, cl_error}
  def enqueue_copy_image(queue, src_image, dest_image, src_origin, dest_origin, region, waitlist) do
    :cl.enqueue_copy_image(queue, src_image, dest_image, src_origin, dest_origin, region, waitlist)
  end

  @doc ~S"""
  Enqueues a command to copy an image object to a buffer object.
  """
  @spec enqueue_copy_image_to_buffer(queue::cl_command_queue, src_image::cl_mem, dest_buffer::cl_mem, src_origin::list(non_neg_integer), region::list(non_neg_integer), dest_offset::non_neg_integer, waitlist::list(cl_event)) :: {:ok, cl_event} | {:error, cl_error}
  def enqueue_copy_image_to_buffer(queue, src_image, dest_buffer, src_origin, region, dest_offset, waitlist) do
    :cl.enqueue_copy_image_to_buffer(queue, src_image, dest_buffer, src_origin, region, dest_offset, waitlist)
  end

  @doc ~S"""
  Enqueues a command to copy a buffer object to another buffer object.
  """
  @spec enqueue_copy_buffer(queue::cl_command_queue, src_buffer::cl_mem, dest_buffer::cl_mem, src_offset::non_neg_integer, dest_offset::non_neg_integer, cb::non_neg_integer, waitlist::list(cl_event)) :: {:ok, cl_event} | {:error, cl_error}
  def enqueue_copy_buffer(queue, src_buffer, dest_buffer, src_offset, dest_offset, cb, waitlist) do
    :cl.enqueue_copy_buffer(queue, src_buffer, dest_buffer, src_offset, dest_offset, cb, waitlist)
  end

  @doc ~S"""
  Enqueues a command to copy a buffer object to an image object.
  """
  @spec enqueue_copy_buffer_to_image(queue::cl_command_queue, src_buffer::cl_mem, dest_image::cl_mem, src_offset::non_neg_integer, dest_origin::list(non_neg_integer), region::list(non_neg_integer), waitlist::list(cl_event)) :: {:ok, cl_event} | {:error, cl_error}
  def enqueue_copy_buffer_to_image(queue, src_buffer, dest_image, src_offset, dest_origin, region, waitlist) do
    :cl.enqueue_copy_buffer_to_image(queue, src_buffer, dest_image, src_offset, dest_origin, region, waitlist)
  end

  @doc ~S"""
  Retrieves information pertaining to this image object.
  """
  @spec get_image_info(image::cl_mem) :: {:ok, keyword()} | {:error, cl_error}
  def get_image_info(image) do
    :cl.get_image_info(image)
  end

  @doc ~S"""
  Enqueue commands to read from a rectangular region from a buffer object to host memory.
  """
  @spec enqueue_read_buffer_rect(queue::cl_command_queue, buffer::cl_mem, buffer_origin::list(non_neg_integer), host_origin::list(non_neg_integer), region::list(non_neg_integer), buffer_row_pitch::non_neg_integer, buffer_slice_pitch::non_neg_integer, host_row_pitch::non_neg_integer, host_slice_pitch::non_neg_integer, waitlist::list(cl_event)) :: {:ok, cl_event} | {:error, cl_error}
  def enqueue_read_buffer_rect(queue, buffer, buffer_origin, host_origin, region, buffer_row_pitch, buffer_slice_pitch, host_row_pitch, host_slice_pitch, waitlist) do
    :cl.enqueue_read_buffer_rect(queue, buffer, buffer_origin, host_origin, region, buffer_row_pitch, buffer_slice_pitch, host_row_pitch, host_slice_pitch, waitlist)
  end

  @doc ~S"""
  Enqueue commands to write a rectangular region to a buffer object from host memory.
  """
  @spec enqueue_write_buffer_rect(queue::cl_command_queue, buffer::cl_mem, buffer_origin::list(non_neg_integer), host_origin::list(non_neg_integer), region::list(non_neg_integer), buffer_row_pitch::non_neg_integer, buffer_slice_pitch::non_neg_integer, host_row_pitch::non_neg_integer, host_slice_pitch::non_neg_integer, data::binary, waitlist::list(cl_event)) :: {:ok, cl_event} | {:error, cl_error}
  def enqueue_write_buffer_rect(queue, buffer, buffer_origin, host_origin, region, buffer_row_pitch, buffer_slice_pitch, host_row_pitch, host_slice_pitch, data, waitlist) do
    :cl.enqueue_write_buffer_rect(queue, buffer, buffer_origin, host_origin, region, buffer_row_pitch, buffer_slice_pitch, host_row_pitch, host_slice_pitch, data, waitlist)
  end

  @doc ~S"""
  Enqueues a command to copy a rectangular region from the buffer object to another buffer object.
  """
  @spec enqueue_copy_buffer_rect(queue::cl_command_queue, src_buffer::cl_mem, dest_buffer::cl_mem, src_origin::list(non_neg_integer), dest_origin::list(non_neg_integer), region::list(non_neg_integer), src_row_pitch::non_neg_integer, src_slice_pitch::non_neg_integer, dest_row_pitch::non_neg_integer, dest_slice_pitch::non_neg_integer, waitlist::list(cl_event)) :: {:ok, cl_event} | {:error, cl_error}
  def enqueue_copy_buffer_rect(queue, src_buffer, dest_buffer, src_origin, dest_origin, region, src_row_pitch, src_slice_pitch, dest_row_pitch, dest_slice_pitch, waitlist) do
    # TODO something in the event handler for this function has an issue; tends to segfault when calling wait_for_events/1. :(
    :cl.enqueue_copy_buffer_rect(queue, src_buffer, dest_buffer, src_origin, dest_origin, region, src_row_pitch, src_slice_pitch, dest_row_pitch, dest_slice_pitch, waitlist)
  end

  @doc ~S"""
  Enqueues a command to fill a buffer object with a pattern of a given pattern size.
  """
  @spec enqueue_fill_buffer(queue::cl_command_queue, buffer::cl_mem, pattern::binary, offset::non_neg_integer, size::non_neg_integer, waitlist::list(cl_event)) :: {:ok, cl_event} | {:error, cl_error}
  def enqueue_fill_buffer(queue, buffer, pattern, offset, size, waitlist) do
    :cl.enqueue_fill_buffer(queue, buffer, pattern, offset, size, waitlist)
  end

  @doc ~S"""
  Creates a 1D image, 1D image buffer, 1D image array, 2D image, 2D image array or 3D image object.
  """
  @spec create_image(context::cl_context, flags::list(cl_mem_flag), image_format::cl_image_format, image_desc::cl_image_desc, data::binary) :: {:ok, cl_mem} | {:error, cl_error}
  def create_image(context, flags, image_format, image_desc, data) do
    :cl.create_image(context, flags, image_format, image_desc, data)
  end

  @doc ~S"""
  Enqueues a command to fill an image object with a specified color.
  """
  @spec enqueue_fill_image(queue::cl_command_queue, image::cl_mem, fill_color::binary, origin::list(non_neg_integer), region::list(non_neg_integer), waitlist::list(cl_event)) :: {:ok, cl_event} | {:error, cl_error}
  def enqueue_fill_image(queue, image, fill_color, origin, region, waitlist) do
    :cl.enqueue_fill_image(queue, image, fill_color, origin, region, waitlist)
  end

  @doc ~S"""
  Enqueues a command to indicate which device a set of memory objects should be associated with.
  """
  @spec enqueue_migrate_mem_objects(queue::cl_command_queue, mem_objects::list(cl_mem), flags::[:host | :content_undefined], waitlist::list(cl_event)) :: {:ok, cl_event} | {:error, cl_error}
  def enqueue_migrate_mem_objects(queue, mem_objects, flags, waitlist) do
    :cl.enqueue_migrate_mem_objects(queue, mem_objects, flags, waitlist)
  end

  ########################################
  # Sampler
  ########################################

  @doc ~S"""
  Creates a sampler object.
  """
  @spec create_sampler(context::cl_context, normalized::boolean, addressing_mode::cl_addressing_mode, filter_mode::cl_filter_mode) :: {:ok, cl_sampler} | {:error, cl_error}
  def create_sampler(context, normalized, addressing_mode, filter_mode) do
    :cl.create_sampler(context, normalized, addressing_mode, filter_mode)
  end

  @doc ~S"""
  Increment the reference count on a sampler.

  To decrement the reference count, see `Clex.CL.release_sampler/1`.
  """
  @spec retain_sampler(sampler::cl_sampler) :: :ok | {:error, cl_error}
  def retain_sampler(sampler) do
    :cl.retain_sampler(sampler)
  end

  @doc ~S"""
  Decrement the reference count on a sampler.

  Once the reference count goes to zero and all attached resources are released, the sampler is deleted.
  To increment the reference count, see `Clex.CL.retain_sampler/1`.
  """
  @spec release_sampler(sampler::cl_sampler) :: :ok | {:error, cl_error}
  def release_sampler(sampler) do
    :cl.release_sampler(sampler)
  end

  @doc ~S"""
  Returns information about the sampler object.
  """
  @spec get_sampler_info(sampler::cl_sampler) :: {:ok, keyword()} | {:error, cl_error}
  def get_sampler_info(sampler) do
    :cl.get_sampler_info(sampler)
  end

  ########################################
  # Program
  ########################################

  @doc ~S"""
  Create a program in the given context from the provided source.
  """
  @spec create_program_with_source(context::cl_context, source::iodata) :: {:ok, cl_program} | {:error, cl_error}
  def create_program_with_source(context, source) do
    :cl.create_program_with_source(context, source)
  end

  @doc ~S"""
  Create a program in the given context + devices from the provided list of one or more precompiled binaries.
  """
  @spec create_program_with_binary(context::cl_context, devices::list(cl_device), binaries::list(binary)) :: {:ok, cl_program} | {:error, cl_error}
  def create_program_with_binary(context, devices, binaries) do
    :cl.create_program_with_binary(context, devices, binaries)
  end

  @doc ~S"""
  Create a program in the given context + devices from the provided list of one or more builtin kernels.
  """
  @spec create_program_with_builtin_kernels(context::cl_context, devices::list(cl_device), kernel_names::binary) :: {:ok, cl_program} | {:error, cl_error}
  def create_program_with_builtin_kernels(context, devices, kernel_names) do
    :cl.create_program_with_builtin_kernels(context, devices, kernel_names)
  end

  @doc ~S"""
  Decrement the reference count on a program.

  Once the reference count goes to zero and all attached resources are released, the program is deleted.
  To increment the reference count, see `Clex.CL.retain_program/1`.
  """
  @spec release_program(program::cl_program) :: :ok | {:error, cl_error}
  def release_program(program) do
    :cl.release_program(program)
  end

  @doc ~S"""
  Increment the reference count on a program.

  To decrement the reference count, see `Clex.CL.release_program/1`.
  """
  @spec retain_program(program::cl_program) :: :ok | {:error, cl_error}
  def retain_program(program) do
    :cl.retain_program(program)
  end

  @doc ~S"""
  Build a program for the given devices using the options.
  """
  @spec build_program(program::cl_program, devices::list(cl_device), options::binary) :: :ok | {:error, cl_error}
  def build_program(program, devices, options) do
    :cl.build_program(program, devices, options)
  end

  @doc ~S"""
  Build a program for the given devices using the options.
  """
  @spec build_program(program::cl_program, devices::list(cl_device)) :: :ok | {:error, cl_error}
  def build_program(program, devices) do
    :cl.build_program(program, devices, '')
  end

  @doc ~S"""
  Allows the implementation to release the resources allocated by the OpenCL compiler.
  """
  @spec unload_compiler() :: :ok | {:error, cl_error}
  def unload_compiler() do
    :cl.unload_compiler()
  end

  @doc ~S"""
  Allows the implementation to release the resources allocated by the OpenCL compiler for a specific platform.
  """
  @spec unload_platform_compiler(platform::cl_platform) :: :ok | {:error, cl_error}
  def unload_platform_compiler(platform) do
    :cl.unload_platform_compiler(platform)
  end

  @doc ~S"""
  Compile a program for the given devices using the options.
  """
  @spec compile_program(program::cl_program, devices::list(cl_device), options::binary, headers::list(cl_program), names::list(binary)) :: :ok | {:error, cl_error}
  def compile_program(program, devices, options, headers, names) do
    :cl.compile_program(program, devices, options, headers, names)
  end

  @doc ~S"""
  Asynchronously compile a program for the given devices using the options.
  """
  @spec async_compile_program(program::cl_program, devices::list(cl_device), options::binary, headers::list(cl_program), names::list(binary)) :: :ok | {:error, cl_error}
  def async_compile_program(program, devices, options, headers, names) do
    :cl.async_compile_program(program, devices, options, headers, names)
  end

  @doc ~S"""
  Links a collection of programs for the given devices and context.
  """
  @spec link_program(context::cl_context, devices::list(cl_device), options::binary, programs::list(cl_program)) :: {:ok, cl_program} | {:error, cl_error}
  def link_program(context, devices, options, programs) do
    :cl.link_program(context, devices, options, programs)
  end

  @doc ~S"""
  Asynchronously links a collection of programs for the given devices and context.
  """
  @spec async_link_program(context::cl_context, devices::list(cl_device), options::binary, programs::list(cl_program)) :: {:ok, cl_program} | {:error, cl_error}
  def async_link_program(context, devices, options, programs) do
    :cl.async_link_program(context, devices, options, programs)
  end

  @doc ~S"""
  Returns all information about the program object.
  """
  @spec get_program_info(program::cl_program) :: {:ok, keyword()} | {:error, cl_error}
  def get_program_info(program) do
    :cl.get_program_info(program)
  end

  @doc ~S"""
  Returns all build information for the requested device in the program object.
  """
  @spec get_program_build_info(program::cl_program, device::cl_device) :: {:ok, list(keyword())} | {:error, cl_error}
  def get_program_build_info(program, device) do
    :cl.get_program_build_info(program, device)
  end

  ########################################
  # Kernel
  ########################################

  @doc ~S"""
  Create a kernel object for the named function found in the given program.
  """
  @spec create_kernel(program::cl_program, name::binary) :: {:ok, cl_kernel} | {:error, cl_error}
  def create_kernel(program, name) do
    :cl.create_kernel(program, name)
  end

  @doc ~S"""
  Create kernel objects for all functions found in the given program.
  """
  @spec create_kernels_in_program(program::cl_program) :: {:ok, list(cl_kernel)} | {:error, cl_error}
  def create_kernels_in_program(program) do
    :cl.create_kernels_in_program(program)
  end

  @doc ~S"""
  Used to set the argument value for a specific argument of a kernel.
  """
  @spec set_kernel_arg(kernel::cl_kernel, index::non_neg_integer, arg::cl_kernel_arg) :: :ok | {:error, cl_error}
  def set_kernel_arg(kernel, index, arg) do
    :cl.set_kernel_arg(kernel, index, arg)
  end

  @doc ~S"""
  Decrement the reference count on a kernel.

  Once the reference count goes to zero and all attached resources are released, the kernel is deleted.
  To increment the reference count, see `Clex.CL.retain_kernel/1`.
  """
  @spec release_kernel(kernel::cl_kernel) :: :ok | {:error, cl_error}
  def release_kernel(kernel) do
    :cl.release_kernel(kernel)
  end

  @doc ~S"""
  Increment the reference count on a kernel.

  To decrement the reference count, see `Clex.CL.release_kernel/1`.
  """
  @spec retain_kernel(kernel::cl_kernel) :: :ok | {:error, cl_error}
  def retain_kernel(kernel) do
    :cl.retain_kernel(kernel)
  end

  @doc ~S"""
  Returns all information about the kernel object.
  """
  @spec get_kernel_info(kernel::cl_kernel) :: {:ok, keyword()} | {:error, cl_error}
  def get_kernel_info(kernel) do
    :cl.get_kernel_info(kernel)
  end

  @doc ~S"""
  Returns all information about the kernel workgroup.
  """
  @spec get_kernel_workgroup_info(kernel::cl_kernel, device::cl_device) :: {:ok, keyword()} | {:error, cl_error}
  def get_kernel_workgroup_info(kernel, device) do
    :cl.get_kernel_workgroup_info(kernel, device)
  end

  @doc ~S"""
  Returns all information about the arguments for a kernel.
  """
  @spec get_kernel_arg_info(kernel::cl_kernel) :: {:ok, list(keyword())} | {:error, cl_error}
  def get_kernel_arg_info(kernel) do
    :cl.get_kernel_arg_info(kernel)
  end

  ########################################
  # Events
  ########################################

  @doc ~S"""
  Enqueues a command to execute a kernel on a device.
  """
  @spec enqueue_task(queue::cl_command_queue, kernel::cl_kernel, waitlist::list(cl_event)) :: {:ok, cl_event} | {:error, cl_error}
  def enqueue_task(queue, kernel, waitlist) do
    :cl.enqueue_task(queue, kernel, waitlist)
  end

  @doc ~S"""
  Enqueues a command to execute a kernel on a device.
  """
  @spec enqueue_nd_range_kernel(queue::cl_command_queue, kernel::cl_kernel, global::list(non_neg_integer), local::list(non_neg_integer), waitlist::list(cl_event)) :: {:ok, cl_event} | {:error, cl_error}
  def enqueue_nd_range_kernel(queue, kernel, global, local, waitlist) do
    :cl.enqueue_nd_range_kernel(queue, kernel, global, local, waitlist)
  end

  @doc ~S"""
  Enqueues a marker command to command_queue. The marker command returns an event which can be used to queue a wait on
  this marker event i.e. wait for all commands queued before the marker command to complete.
  """
  @spec enqueue_marker(queue::cl_command_queue) :: {:ok, cl_event} | {:error, cl_error}
  def enqueue_marker(queue) do
    :cl.enqueue_marker(queue)
  end

  @doc ~S"""
  Enqueues a synchonrization point that ensures all prior commands in the given queue have completed.
  """
  @spec enqueue_barrier(queue::cl_command_queue) :: :ok | {:error, cl_error}
  def enqueue_barrier(queue) do
    :cl.enqueue_barrier(queue)
  end

  @doc ~S"""
  Enqueues a wait for a specific event or a list of events to complete before any future commands queued in the
  queue are executed.
  """
  @spec enqueue_wait_for_events(queue::cl_command_queue, waitlist::list(cl_event)) :: :ok | {:error, cl_error}
  def enqueue_wait_for_events(queue, waitlist) do
    :cl.enqueue_wait_for_events(queue, waitlist)
  end

  @doc ~S"""
  Enqueue commands to read from a buffer object to host memory, with a returned event to track the command completion.
  """
  @spec enqueue_read_buffer(queue::cl_command_queue, buffer::cl_mem, offset::non_neg_integer, size::non_neg_integer, waitlist::list(cl_event)) :: {:ok, cl_event} | {:error, cl_error}
  def enqueue_read_buffer(queue, buffer, offset, size, waitlist) do
    :cl.enqueue_read_buffer(queue, buffer, offset, size, waitlist)
  end

  @doc ~S"""
  Enqueue commands to write to a buffer object from host memory, with a returned event to track the command completion.
  """
  @spec enqueue_write_buffer(queue::cl_command_queue, buffer::cl_mem, offset::non_neg_integer, size::non_neg_integer, data::binary, waitlist::list(cl_event)) :: {:ok, cl_event} | {:error, cl_error}
  def enqueue_write_buffer(queue, buffer, offset, size, data, waitlist) do
    :cl.enqueue_write_buffer(queue, buffer, offset, size, data, waitlist)
  end

  @doc ~S"""
  Decrement the reference count on an event.

  Once the reference count goes to zero and all attached resources are released, the event is deleted.
  To increment the reference count, see `Clex.CL.retain_event/1`.
  """
  @spec release_event(event::cl_event) :: :ok | {:error, cl_error}
  def release_event(event) do
    :cl.release_event(event)
  end

  @doc ~S"""
  Increment the reference count on an event.

  To decrement the reference count, see `Clex.CL.release_event/1`.
  """
  @spec retain_event(event::cl_event) :: :ok | {:error, cl_error}
  def retain_event(event) do
    :cl.retain_event(event)
  end

  @doc ~S"""
  Returns all specific information about the event object.
  """
  @spec get_event_info(event::cl_event) :: {:ok, list(keyword())} | {:error, cl_error}
  def get_event_info(event) do
    :cl.get_event_info(event)
  end

  @doc ~S"""
  Blocking wait for event to complete, no timeout.
  """
  @spec wait(event::cl_event) :: {:ok, any} | {:error, cl_error}
  def wait(event) do
    :cl.wait(event)
  end

  @doc ~S"""
  Blocking wait for event to complete, with timeout in milliseconds.
  """
  @spec wait(event::cl_event, timeout::non_neg_integer) :: {:ok, any} | {:error, cl_error} | {:error, timeout}
  def wait(event, timeout) do
    :cl.wait(event, timeout)
  end

  @doc ~S"""
  Generate a wait operation that will run non blocking.
  A reference is return that can be used to match the event
  that is sent when the event has completed or resulted in an error.
  The event returned has the form `{cl_event, Ref, Result}`
  where Ref is the reference that was returned from the call and
  Result may be one of `binary() | 'complete'` or `{:error, cl_error()}`.
  """
  @spec async_wait_for_event(event::cl_event) :: {:ok, reference} | {:error, cl_error}
  def async_wait_for_event(event) do
    :cl.async_wait_for_event(event)
  end

  @doc ~S"""
  Wait for all events in waitlist to complete.
  """
  @spec wait_for_events(waitlist::list(cl_event)) :: list({:ok, any} | {:error, cl_error})
  def wait_for_events(waitlist) do
    :cl.wait_for_events(waitlist)
  end

  @doc ~S"""
  Enqueues a marker command which waits for either a list of events to complete, or all previously enqueued commands to complete.
  """
  @spec enqueue_marker_with_wait_list(queue::cl_command_queue, waitlist::list(cl_event)) :: {:ok, cl_event} | {:error, cl_error}
  def enqueue_marker_with_wait_list(queue, waitlist) do
    :cl.enqueue_marker_with_wait_list(queue, waitlist)
  end

  @doc ~S"""
  A synchronization point that enqueues a barrier operation.
  """
  @spec enqueue_barrier_with_wait_list(queue::cl_command_queue, waitlist::list(cl_event)) :: {:ok, cl_event} | {:error, cl_error}
  def enqueue_barrier_with_wait_list(queue, waitlist) do
    :cl.enqueue_barrier_with_wait_list(queue, waitlist)
  end

  ########################################
  # Misc
  ########################################

  @doc ~S"""
  Blocking request issues all previously queued OpenCL commands in a command queue to the device associated with the
  command queue.

  `Clex.CL.flush/1` only guarantees that all queued commands to command queue get
  issued to the appropriate device. There is no guarantee that they
  will be complete after the call returns.
  """
  @spec flush(queue::cl_command_queue) :: :ok | {:error, cl_error}
  def flush(queue) do
    :cl.flush(queue)
  end

  @doc ~S"""
  Asynchronously issues all previously queued OpenCL commands in a command queue to the device associated with the
  command queue.

  `Clex.CL.async_flush/1` only guarantees that all queued commands to command queue get
  issued to the appropriate device. There is no guarantee that they
  will be complete after the call returns.
  """
  @spec async_flush(queue::cl_command_queue) :: :ok | {:error, cl_error}
  def async_flush(queue) do
    :cl.async_flush(queue)
  end

  @doc ~S"""
  Blocks until all previously queued OpenCL commands
  in a command-queue are issued to the associated device and have
  completed.

  `Clex.CL.finish/1` does not return until all queued commands in command_queue
  have been processed and completed. This function is also a
  synchronization point.
  """
  @spec finish(queue::cl_command_queue) :: :ok | {:error, cl_error}
  def finish(queue) do
    :cl.finish(queue)
  end

  @doc ~S"""
  Non-blocking call to ensure previously queued OpenCL commands
  in a command-queue are issued to the associated device and have
  completed.

  `Clex.CL.async_finish/1` does not block until all queued commands in command_queue
  have been processed and completed, and there is no guarantee that all commands have been completed at return time.
  """
  @spec async_finish(queue::cl_command_queue) :: :ok | {:error, cl_error}
  def async_finish(queue) do
    :cl.async_finish(queue)
  end

end

defmodule Clex.CL do
  @moduledoc ~S"""
  This module provides a wrapper for all OpenCL API functions and types exported by the [`:cl`](https://github.com/tonyrog/cl) Erlang module in addition to some convenience revisions to make the functions more idiomatic Elixir where possible.

  It is discouraged to call methods directly from this module, and instead leverage the versioned API modules to ensure the functions you are calling are supported for the OpenCL version implemented on your target platform.
  """

  # OpenCL object types
  @typedoc "Opaque reference to an OpenCL platform"
  @opaque cl_platform               :: {:platform_t, any, reference}
  @typedoc "Opaque reference to an OpenCL device"
  @opaque cl_device                 :: {:device_t, any, reference}
  @typedoc "Opaque reference to an OpenCL compute context"
  @opaque cl_context                :: {:context_t, any, reference}
  @typedoc "Opaque reference to an OpenCL command queue"
  @opaque cl_command_queue          :: {:command_queue_t, any, reference}
  @typedoc "Opaque reference to an OpenCL memory object"
  @opaque cl_mem                    :: {:mem_t, any, reference}
  @typedoc "Opaque reference to an OpenCL sampler object"
  @opaque cl_sampler                :: {:sampler_t, any, reference}
  @typedoc "Opaque reference to an OpenCL program object"
  @opaque cl_program                :: {:program_t, any, reference}
  @typedoc "Opaque reference to an OpenCL kernel object"
  @opaque cl_kernel                 :: {:kernel_t, any, reference}
  @typedoc "Opaque reference to an OpenCL event object"
  @opaque cl_event                  :: {:event_t, any, reference}
  @typedoc "OpenCL error response"
  @type   cl_error                  :: any

  # OpenCL flags and properties
  @typedoc "OpenCL enumeration for device types"
  @type   cl_device_type            :: :gpu | :cpu | :accelerator | :custom | :all | :default
  @typedoc "OpenCL enumeration for sub-device properties"
  @type   cl_sub_devices_property   :: {:equally, non_neg_integer} |
                                       {:by_counts, [non_neg_integer]} |
                                       {:by_affinity_domain, :numa | :l4_cache | :l3_cache | :l2_cache | :l1_cache | :next_partitionable}
  @typedoc "OpenCL enumeration for command-queue properties"
  @type   cl_command_queue_property :: :out_of_order_exec_mode_enable | :profiling_enabled
  @typedoc "OpenCL enumeration for memory object flags"
  @type   cl_mem_flag               :: :read_write | :write_only | :read_only | :use_host_ptr | :alloc_host_ptr | :copy_host_ptr
  @typedoc "OpenCL enumeration for buffer creation types"
  @type   cl_buffer_create_type     :: :region
  @typedoc "OpenCL enumeration for kernel argument types"
  @type   cl_kernel_arg             :: cl_mem | integer | float | binary
  @typedoc "OpenCL enumeration for memory mapping flags"
  @type   cl_map_flag               :: :read | :write
  @type   cl_start_arg              :: {:debug, boolean}
  @typedoc "OpenCL enumeration for memory object types"
  @type   cl_mem_object_type        :: :buffer | :image2d | :image3d |
                                       :image2d_array | :image1d | :image1d_array | :image1d_buffer
  @typedoc "OpenCL enumeration for addressing modes"
  @type   cl_addressing_mode        :: :none | :clamp_to_edge | :clamp | :repeat
  @typedoc "OpenCL enumeration for filter modes"
  @type   cl_filter_mode            :: :nearest | :linear
  @typedoc "OpenCL enumeration for cache types"
  @type   cl_cache_type             :: :none | :read_only | :read_write
  @typedoc "OpenCL enumeration for channel orders"
  @type   cl_channel_order          :: :r | :a | :rg | :ra | :rgb | :rgba | :bgra | :argb | :intensity | :luminance | :rx | :rgx | :rgbx | :depth | :depth_stencil
  @typedoc "OpenCL enumeration for channel types"
  @type   cl_channel_type           :: :snorm_int8 | :snorm_int16 |
                                       :unorm_int8 | :unorm_int16  | :unorm_int24 | :unorm_short_565 | :unorm_short_555 | :unorm_int_101010 |
                                       :signed_int8 | :signed_int16 | :signed_int32 |
                                       :unsigned_int8 | :unsigned_int16 | :unsigned_int32 |
                                       :half_float | :float
  @typedoc "OpenCL enumeration for memory object migration flags"
  @type   cl_mem_migration_flags    :: :host | :content_undefined

  # Records
  require Clex.CL.ImageFormat
  require Clex.CL.ImageDesc

  @typedoc "Record representation of OpenCL `cl_image_format` structure"
  @type   cl_image_format           :: Clex.CL.ImageFormat.t
  @typedoc "Record representation of OpenCL `cl_image_desc` structure"
  @type   cl_image_desc             :: Clex.CL.ImageDesc.t

  ############################################################
  # Platform
  ############################################################

  @doc ~S"""
  Obtain the list of platforms available.
  """
  @doc group: :platform
  @spec get_platform_ids() :: {:ok, list(cl_platform)} | {:error, cl_error}
  def get_platform_ids() do
    :cl.get_platform_ids()
  end

  @doc ~S"""
  Get specific information about the OpenCL platform.

  ### Parameters

  `platform` \
  A platform ID returned by `get_platform_ids/0`.
  """
  @doc group: :platform
  @spec get_platform_info(platform::cl_platform) :: {:ok, keyword()} | {:error, cl_error}
  def get_platform_info(platform) do
    :cl.get_platform_info(platform)
  end

  ############################################################
  # Devices
  ############################################################

  @doc ~S"""
  Obtain the list of devices available on a platform.

  ### Parameters

  `platform` \
  A platform ID returned by `get_platform_ids/0`.

  `device_type` \
  One of `:gpu`, `:cpu`, `:accelerator`, `:custom`, `:all`, or `:default`.
  """
  @doc group: :devices
  @spec get_device_ids(platform::cl_platform, device_type::cl_device_type) :: {:ok, list(cl_device)} | {:error, cl_error}
  def get_device_ids(platform, device_type) do
    :cl.get_device_ids(platform, device_type)
  end

  @doc ~S"""
  Get information about an OpenCL device.

  ### Parameters

  `device` \
  Device reference returned by `get_device_ids/2` or a sub-device created by `create_sub_devices/2`.  If `device` is a sub-device, the specific information for the sub-device will be returned.
  """
  @doc group: :devices
  @spec get_device_info(device::cl_device) :: {:ok, keyword()} | {:error, cl_error}
  def get_device_info(device) do
    :cl.get_device_info(device)
  end

  @doc ~S"""
  Creates an array of sub-devices that each reference a non-intersecting set of compute units within the provided `device`, using criteria
  provided in `property`.

  ### Parameters

  `device` \
  The device to be partitioned.

  `property` \
  Specifies how `device` is to be partition described by a partition scheme. The list of supported partitioning schemes is described in the table below. Only one of the listed partitioning schemes can be specified in `property`.

  Property                             | Description
  :----------------------------------- | :---------
  `{:equally, n::non_neg_integer}`     | Split the aggregate device into as many smaller aggregate devices as can be created, each containing `n` compute units. The value n is passed as the value accompanying this property. If n does not divide evenly into `:partition_max_compute_units`, then the remaining compute units are not used.
  `{:by_counts, [m::non_neg_integer]}` | This property is followed by a list of compute unit counts. For each nonzero count `m` in the list, a sub-device is created with `m` compute units in it. The number of non-zero count entries in the list may not exceed `:partition_max_sub_devices`. The total number of compute units specified may not exceed `:partition_max_compute_units`.
  `{:by_affinity_domain, domain}`      | Split the device into smaller aggregate devices containing one or more compute units that all share part of a cache hierarchy. The value accompanying this property may be drawn from the following list: `:numa`, `:l4_cache`, `:l3_cache`, `:l2_cache`, `:l1_cache`, `:next_partitionable`.
  """
  @doc group: :devices
  @spec create_sub_devices(device::cl_device, property::cl_sub_devices_property) :: {:ok, list(cl_device)} | {:error, cl_error}
  def create_sub_devices(device, property) do
    :cl.create_sub_devices(device, property)
  end

  @doc ~S"""
  Decrements the `device` reference count.

  To increment the reference count, see `retain_device/1`.
  """
  @doc group: :devices
  @spec release_device(device::cl_device) :: :ok | {:error, cl_error}
  def release_device(device) do
    :cl.release_device(device)
  end

  @doc ~S"""
  Increments the `device` reference count.

  To decrement the reference count, see `release_device/1`.
  """
  @doc group: :devices
  @spec retain_device(device::cl_device) :: :ok | {:error, cl_error}
  def retain_device(device) do
    :cl.retain_device(device)
  end

  ############################################################
  # Context
  ############################################################

  @doc ~S"""
  Creates an OpenCL context.

  ### Parameters

  `devices` \
  List of device references returned by `get_device_ids/2` or sub-devices created by `create_sub_devices/2`.
  """
  @doc group: :context
  @spec create_context(devices::list(cl_device)) :: {:ok, cl_context} | {:error, cl_error}
  def create_context(devices) do
    :cl.create_context(devices)
  end

  @doc ~S"""
  Create an OpenCL context from a device type that identifies the specific device(s) to use.

  ### Parameters

  `platform` \
  A platform ID returned by `get_platform_ids/0`.

  `device_type` \
  One of `:gpu`, `:cpu`, `:accelerator`, `:custom`, `:all`, or `:default`.
  """
  @doc group: :context
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
  Decrement the `context` reference count.

  To increment the reference count, see `retain_context/1`.
  """
  @doc group: :context
  @spec release_context(context::cl_context) :: :ok | {:error, cl_error}
  def release_context(context) do
    :cl.release_context(context)
  end

  @doc ~S"""
  Increment the `context` reference count.

  To decrement the reference count, see `release_context/1`.
  """
  @doc group: :context
  @spec retain_context(context::cl_context) :: :ok | {:error, cl_error}
  def retain_context(context) do
    :cl.retain_context(context)
  end

  @doc ~S"""
  Query information about a context.

  ### Parameters

  `context` \
  Specifies the OpenCL context being queried.
  """
  @doc group: :context
  @spec get_context_info(context::cl_context) :: {:ok, keyword()} | {:error, cl_error}
  def get_context_info(context) do
    :cl.get_context_info(context)
  end

  ############################################################
  # Command Queues
  ############################################################

  @doc ~S"""
  Create a command-queue on a specific device.

  ### Parameters

  `context` \
  Must be a valid OpenCL context

  `device` \
  Must be a device associated with context. It can either be in the list of devices specified when context is created using `create_context/1` or have the same device type as the device type specified when the context is created using `create_context_from_type/2`.

  `properties` \
  Specifies a list of properties for the command-queue. Only command-queue properties specified in the table below can be set in properties; otherwise the value specified in `properties` is considered to be not valid

  Property                             | Description
  :----------------------------------- | :---------
  `:out_of_order_exec_mode_enable`       | Determines whether the commands queued in the command-queue are executed in-order or out-of-order. If set, the commands in the command-queue are executed out-of-order. Otherwise, commands are executed in-order.
  `:profiling_enabled`                   | Enable or disable profiling of commands in the command-queue. If set, the profiling of commands is enabled. Otherwise profiling of commands is disabled.

  _Note that `clGetEventProfiling` is not implemented yet in Clex, so `:profiling_enabled` is essentially a NOOP._
  """
  @doc group: :command_queues
  @spec create_queue(context::cl_context, device::cl_device, properties::list(cl_command_queue_property)) :: {:ok, cl_command_queue} | {:error, cl_error}
  def create_queue(context, device, properties) do
    :cl.create_queue(context, device, properties)
  end

  @doc ~S"""
  Create a command-queue on a specific device with default properties.

  ### Parameters

  `context` \
  Must be a valid OpenCL context

  `device` \
  Must be a device associated with context. It can either be in the list of devices specified when context is created using `create_context/1` or have the same device type as the device type specified when the context is created using `create_context_from_type/2`.
  """
  @doc group: :command_queues
  @spec create_queue(context::cl_context, device::cl_device) :: {:ok, cl_command_queue} | {:error, cl_error}
  def create_queue(context, device) do
    :cl.create_queue(context, device, [])
  end

  @doc ~S"""
  Decrements the `queue` reference count.

  To increment the reference count, see `retain_queue/1`.
  """
  @doc group: :command_queues
  @spec release_queue(queue::cl_command_queue) :: :ok | {:error, cl_error}
  def release_queue(queue) do
    :cl.release_queue(queue)
  end

  @doc ~S"""
  Increments the `queue` reference count.

  To decrement the reference count, see `release_queue/1`.
  """
  @doc group: :command_queues
  @spec retain_queue(queue::cl_command_queue) :: :ok | {:error, cl_error}
  def retain_queue(queue) do
    :cl.retain_queue(queue)
  end

  @doc ~S"""
  Query information about a command-queue.

  ### Parameters

  `queue` \
  Specifies the command-queue being queried.
  """
  @doc group: :command_queues
  @spec get_queue_info(queue::cl_command_queue) :: {:ok, keyword()} | {:error, cl_error}
  def get_queue_info(queue) do
    :cl.get_queue_info(queue)
  end

  ############################################################
  # Memory Objects
  ############################################################

  @doc ~S"""
  Creates a buffer object of `size` bytes.

  ### Parameters

  `context` \
    A valid OpenCL context used to create the buffer object.

  `flags` \
    A list of flags used to specify allocation and usage information such as the memory arena that should be used to allocate the buffer object and how it will be used. The following table describes the possible values for flags. If `flags` is an empty list, the default is used which is `:read_write`.

  Flag                              | Description
  :-------------------------------- | :---------
  `:read_write`                     | This flag specifies that the memory object will be read and written by a kernel. This is the default.
  `:write_only`                     | This flags specifies that the memory object will be written but not read by a kernel. Reading from a buffer or image object created with `:write_only` inside a kernel is undefined. `:read_write` and `:write_only` are mutually exclusive.
  `:read_only`                      | This flag specifies that the memory object is a read-only memory object when used inside a kernel. Writing to a buffer or image object created with `:read_only` inside a kernel is undefined. `:read_write` or `:write_only` and `:read_only` are mutually exclusive.
  `:use_host_ptr`                   | This flag is valid only if host_ptr is not NULL. If specified, it indicates that the application wants the OpenCL implementation to use memory referenced by host_ptr as the storage bits for the memory object. OpenCL implementations are allowed to cache the buffer contents pointed to by host_ptr in device memory. This cached copy can be used when kernels are executed on a device. The result of OpenCL commands that operate on multiple buffer objects created with the same host_ptr or overlapping host regions is considered to be undefined. Refer to the description of the alignment rules for host_ptr for memory objects (buffer and images) created using `:use_host_ptr`.
  `:alloc_host_ptr`                 | This flag specifies that the application wants the OpenCL implementation to allocate memory from host accessible memory. `:alloc_host_ptr` and `:use_host_ptr` are mutually exclusive.
  `:copy_host_ptr`                  | This flag is valid only if host_ptr is not NULL. If specified, it indicates that the application wants the OpenCL implementation to allocate memory for the memory object and copy the data from memory referenced by host_ptr. `:copy_host_ptr` and `:use_host_ptr` are mutually exclusive. `:copy_host_ptr` can be used with `:alloc_host_ptr` to initialize the contents of the cl_mem object allocated using host-accessible (e.g. PCIe) memory.

  `size` \
    The size in bytes of the buffer memory object to be allocated.
  """
  @doc group: :memory_objects
  @spec create_buffer(context::cl_context, flags::list(cl_mem_flag), size::non_neg_integer) :: {:ok, cl_mem} | {:error, cl_error}
  def create_buffer(context, flags, size) do
    :cl.create_buffer(context, flags, size)
  end

  @doc ~S"""
  Creates a buffer object of `size` bytes and initializes it with the provided `data`.

  ### Parameters

  `context` \
    A valid OpenCL context used to create the buffer object.

  `flags` \
    A list of flags used to specify allocation and usage information such as the memory arena that should be used to allocate the buffer object and how it will be used. The following table describes the possible values for flags. If `flags` is an empty list, the default is used which is `:read_write`.

  Flag                              | Description
  :-------------------------------- | :---------
  `:read_write`                     | This flag specifies that the memory object will be read and written by a kernel. This is the default.
  `:write_only`                     | This flags specifies that the memory object will be written but not read by a kernel. Reading from a buffer or image object created with `:write_only` inside a kernel is undefined. `:read_write` and `:write_only` are mutually exclusive.
  `:read_only`                      | This flag specifies that the memory object is a read-only memory object when used inside a kernel. Writing to a buffer or image object created with `:read_only` inside a kernel is undefined. `:read_write` or `:write_only` and `:read_only` are mutually exclusive.
  `:use_host_ptr`                   | This flag is valid only if host_ptr is not NULL. If specified, it indicates that the application wants the OpenCL implementation to use memory referenced by host_ptr as the storage bits for the memory object. OpenCL implementations are allowed to cache the buffer contents pointed to by host_ptr in device memory. This cached copy can be used when kernels are executed on a device. The result of OpenCL commands that operate on multiple buffer objects created with the same host_ptr or overlapping host regions is considered to be undefined. Refer to the description of the alignment rules for host_ptr for memory objects (buffer and images) created using `:use_host_ptr`.
  `:alloc_host_ptr`                 | This flag specifies that the application wants the OpenCL implementation to allocate memory from host accessible memory. `:alloc_host_ptr` and `:use_host_ptr` are mutually exclusive.
  `:copy_host_ptr`                  | This flag is valid only if host_ptr is not NULL. If specified, it indicates that the application wants the OpenCL implementation to allocate memory for the memory object and copy the data from memory referenced by host_ptr. `:copy_host_ptr` and `:use_host_ptr` are mutually exclusive. `:copy_host_ptr` can be used with `:alloc_host_ptr` to initialize the contents of the cl_mem object allocated using host-accessible (e.g. PCIe) memory.

  `size` \
  The size in bytes of the buffer memory object to be allocated.

  `data` \
  Buffer data that may already be allocated by the application, used to initialize the newly created buffer based on `flags` settings.
  """
  @doc group: :memory_objects
  @spec create_buffer(context::cl_context, flags::list(cl_mem_flag), size::non_neg_integer, data::iolist) :: {:ok, cl_mem} | {:error, cl_error}
  def create_buffer(context, flags, size, data) do
    :cl.create_buffer(context, flags, size, data)
  end

  @doc ~S"""
  Creates a new buffer object (referred to as a sub-buffer object) from an existing buffer object.

  ### Parameters

  `buffer` \
    A valid object and cannot be a sub-buffer object.

  `flags` \
    A list of flags used to specify allocation and usage information such as the memory arena that should be used to allocate the buffer object and how it will be used. The following table describes the possible values for flags. If `flags` is an empty list, the default is used which is `:read_write`.

  Flag                              | Description
  :-------------------------------- | :---------
  `:read_write`                     | This flag specifies that the memory object will be read and written by a kernel. This is the default.
  `:write_only`                     | This flags specifies that the memory object will be written but not read by a kernel. Reading from a buffer or image object created with `:write_only` inside a kernel is undefined. `:read_write` and `:write_only` are mutually exclusive.
  `:read_only`                      | This flag specifies that the memory object is a read-only memory object when used inside a kernel. Writing to a buffer or image object created with `:read_only` inside a kernel is undefined. `:read_write` or `:write_only` and `:read_only` are mutually exclusive.
  `:use_host_ptr`                   | This flag is valid only if host_ptr is not NULL. If specified, it indicates that the application wants the OpenCL implementation to use memory referenced by host_ptr as the storage bits for the memory object. OpenCL implementations are allowed to cache the buffer contents pointed to by host_ptr in device memory. This cached copy can be used when kernels are executed on a device. The result of OpenCL commands that operate on multiple buffer objects created with the same host_ptr or overlapping host regions is considered to be undefined. Refer to the description of the alignment rules for host_ptr for memory objects (buffer and images) created using `:use_host_ptr`.
  `:alloc_host_ptr`                 | This flag specifies that the application wants the OpenCL implementation to allocate memory from host accessible memory. `:alloc_host_ptr` and `:use_host_ptr` are mutually exclusive.
  `:copy_host_ptr`                  | This flag is valid only if host_ptr is not NULL. If specified, it indicates that the application wants the OpenCL implementation to allocate memory for the memory object and copy the data from memory referenced by host_ptr. `:copy_host_ptr` and `:use_host_ptr` are mutually exclusive. `:copy_host_ptr` can be used with `:alloc_host_ptr` to initialize the contents of the cl_mem object allocated using host-accessible (e.g. PCIe) memory.

  `type` \
  Currently must be `:region`.

  `origin` \
  Offset into `buffer` to create the sub-buffer from.

  `size` \
  The size in bytes of the sub-buffer memory object to be allocated.
  """
  @doc group: :memory_objects
  @spec create_sub_buffer(buffer::cl_mem, flags::list(cl_mem_flag), type::cl_buffer_create_type, origin::non_neg_integer, size::non_neg_integer) :: {:ok, cl_mem} | {:error, cl_error}
  def create_sub_buffer(buffer, flags, type, origin, size) do
    :cl.create_sub_buffer(buffer, flags, type, [origin, size])
  end

  @doc ~S"""
  Decrements the memory object reference count.

  To increment the reference count, see `retain_mem_object/1`.
  """
  @doc group: :memory_objects
  @spec release_mem_object(buffer::cl_mem) :: :ok | {:error, cl_error}
  def release_mem_object(buffer) do
    :cl.release_mem_object(buffer)
  end

  @doc ~S"""
  Increments the memory object reference count.

  To decrement the reference count, see `release_mem_object/1`.
  """
  @doc group: :memory_objects
  @spec retain_mem_object(buffer::cl_mem) :: :ok | {:error, cl_error}
  def retain_mem_object(buffer) do
    :cl.retain_mem_object(buffer)
  end

  @doc ~S"""
  Get information that is common to all memory objects (buffer and image objects).

  ### Parameters

  `buffer` \
  Specifies the memory object being queried.
  """
  @doc group: :memory_objects
  @spec get_mem_object_info(buffer::cl_mem) :: {:ok, keyword()} | {:error, cl_error}
  def get_mem_object_info(buffer) do
    :cl.get_mem_object_info(buffer)
  end

  @doc ~S"""
  Creates a 2D image object.

  The `flags` are used to specify allocation and usage information such as the memory arena that should be used to allocate the buffer object and how it will be used. The following table describes the possible values for flags. If `flags` is an empty list, the default is used which is `:read_write`.

  Flag                                  | Description
  :------------------------------------ | :---------
  `:read_write`                     | This flag specifies that the memory object will be read and written by a kernel. This is the default.
  `:write_only`                     | This flags specifies that the memory object will be written but not read by a kernel. Reading from a buffer or image object created with `:write_only` inside a kernel is undefined. `:read_write` and `:write_only` are mutually exclusive.
  `:read_only`                      | This flag specifies that the memory object is a read-only memory object when used inside a kernel. Writing to a buffer or image object created with `:read_only` inside a kernel is undefined. `:read_write` or `:write_only` and `:read_only` are mutually exclusive.
  `:use_host_ptr`                   | This flag is valid only if host_ptr is not NULL. If specified, it indicates that the application wants the OpenCL implementation to use memory referenced by host_ptr as the storage bits for the memory object. OpenCL implementations are allowed to cache the buffer contents pointed to by host_ptr in device memory. This cached copy can be used when kernels are executed on a device. The result of OpenCL commands that operate on multiple buffer objects created with the same host_ptr or overlapping host regions is considered to be undefined. Refer to the description of the alignment rules for host_ptr for memory objects (buffer and images) created using `:use_host_ptr`.
  `:alloc_host_ptr`                 | This flag specifies that the application wants the OpenCL implementation to allocate memory from host accessible memory. `:alloc_host_ptr` and `:use_host_ptr` are mutually exclusive.
  `:copy_host_ptr`                  | This flag is valid only if host_ptr is not NULL. If specified, it indicates that the application wants the OpenCL implementation to allocate memory for the memory object and copy the data from memory referenced by host_ptr. `:copy_host_ptr` and `:use_host_ptr` are mutually exclusive. `:copy_host_ptr` can be used with `:alloc_host_ptr` to initialize the contents of the cl_mem object allocated using host-accessible (e.g. PCIe) memory.

  See `Clex.CL.ImageFormat` for image format details.

  See `get_supported_image_formats/3` to discover what formats are supported by your OpenCL device.
  """
  @doc group: :memory_objects
  @spec create_image2d(context::cl_context, flags::list(cl_mem_flag), image_format::cl_image_format, width::non_neg_integer, height::non_neg_integer, row_pitch::non_neg_integer, data::binary) :: {:ok, cl_mem} | {:error, cl_error}
  def create_image2d(context, flags, image_format, width, height, row_pitch, data) do
    :cl.create_image2d(context, flags, image_format, width, height, row_pitch, data)
  end

  @doc ~S"""
  Creates a 3D image object.

  The `flags` are used to specify allocation and usage information such as the memory arena that should be used to allocate the buffer object and how it will be used. The following table describes the possible values for flags. If `flags` is an empty list, the default is used which is `:read_write`.

  Flag                                  | Description
  :------------------------------------ | :---------
  `:read_write`                     | This flag specifies that the memory object will be read and written by a kernel. This is the default.
  `:write_only`                     | This flags specifies that the memory object will be written but not read by a kernel. Reading from a buffer or image object created with `:write_only` inside a kernel is undefined. `:read_write` and `:write_only` are mutually exclusive.
  `:read_only`                      | This flag specifies that the memory object is a read-only memory object when used inside a kernel. Writing to a buffer or image object created with `:read_only` inside a kernel is undefined. `:read_write` or `:write_only` and `:read_only` are mutually exclusive.
  `:use_host_ptr`                   | This flag is valid only if host_ptr is not NULL. If specified, it indicates that the application wants the OpenCL implementation to use memory referenced by host_ptr as the storage bits for the memory object. OpenCL implementations are allowed to cache the buffer contents pointed to by host_ptr in device memory. This cached copy can be used when kernels are executed on a device. The result of OpenCL commands that operate on multiple buffer objects created with the same host_ptr or overlapping host regions is considered to be undefined. Refer to the description of the alignment rules for host_ptr for memory objects (buffer and images) created using `:use_host_ptr`.
  `:alloc_host_ptr`                 | This flag specifies that the application wants the OpenCL implementation to allocate memory from host accessible memory. `:alloc_host_ptr` and `:use_host_ptr` are mutually exclusive.
  `:copy_host_ptr`                  | This flag is valid only if host_ptr is not NULL. If specified, it indicates that the application wants the OpenCL implementation to allocate memory for the memory object and copy the data from memory referenced by host_ptr. `:copy_host_ptr` and `:use_host_ptr` are mutually exclusive. `:copy_host_ptr` can be used with `:alloc_host_ptr` to initialize the contents of the cl_mem object allocated using host-accessible (e.g. PCIe) memory.

  See `Clex.CL.ImageFormat` for image format details.

  See `get_supported_image_formats/3` to discover what formats are supported by your OpenCL device.
  """
  @doc group: :memory_objects
  @spec create_image3d(context::cl_context, flags::list(cl_mem_flag), image_format::cl_image_format, width::non_neg_integer, height::non_neg_integer, depth::non_neg_integer, row_pitch::non_neg_integer, slice_pitch::non_neg_integer, data::binary) :: {:ok, cl_mem} | {:error, cl_error}
  def create_image3d(context, flags, image_format, width, height, depth, row_pitch, slice_pitch, data) do
    :cl.create_image3d(context, flags, image_format, width, height, depth, row_pitch, slice_pitch, data)
  end

  @doc ~S"""
  Get the list of image formats supported by an OpenCL implementation.

  ### Parameters

  `context` \
    A valid OpenCL context on which the image object(s) will be created.

  `flags` \
    A list of flags used to specify allocation and usage information about the image memory object being created and is described in the table below. If `flags` is an empty list, the default is used which is `:read_write`.

  Flag                              | Description
  :-------------------------------- | :---------
  `:read_write`                     | This flag specifies that the memory object will be read and written by a kernel. This is the default.
  `:write_only`                     | This flags specifies that the memory object will be written but not read by a kernel. Reading from a buffer or image object created with `:write_only` inside a kernel is undefined. `:read_write` and `:write_only` are mutually exclusive.
  `:read_only`                      | This flag specifies that the memory object is a read-only memory object when used inside a kernel. Writing to a buffer or image object created with `:read_only` inside a kernel is undefined. `:read_write` or `:write_only` and `:read_only` are mutually exclusive.
  `:use_host_ptr`                   | This flag is valid only if host_ptr is not NULL. If specified, it indicates that the application wants the OpenCL implementation to use memory referenced by host_ptr as the storage bits for the memory object. OpenCL implementations are allowed to cache the buffer contents pointed to by host_ptr in device memory. This cached copy can be used when kernels are executed on a device. The result of OpenCL commands that operate on multiple buffer objects created with the same host_ptr or overlapping host regions is considered to be undefined. Refer to the description of the alignment rules for host_ptr for memory objects (buffer and images) created using `:use_host_ptr`.
  `:alloc_host_ptr`                 | This flag specifies that the application wants the OpenCL implementation to allocate memory from host accessible memory. `:alloc_host_ptr` and `:use_host_ptr` are mutually exclusive.
  `:copy_host_ptr`                  | This flag is valid only if host_ptr is not NULL. If specified, it indicates that the application wants the OpenCL implementation to allocate memory for the memory object and copy the data from memory referenced by host_ptr. `:copy_host_ptr` and `:use_host_ptr` are mutually exclusive. `:copy_host_ptr` can be used with `:alloc_host_ptr` to initialize the contents of the cl_mem object allocated using host-accessible (e.g. PCIe) memory.

  `image_type` \
  Describes the image type and must be either `:image1d`, `:image1d_buffer`, `:image2d`, `:image3d`, `:image1d_array` or `:image2d_array`.
  """
  @doc group: :memory_objects
  @spec get_supported_image_formats(context::cl_context, flags::list(cl_mem_flag), image_type::cl_mem_object_type) :: {:ok, list(tuple)} | {:error, cl_error}
  def get_supported_image_formats(context, flags, image_type) do
    :cl.get_supported_image_formats(context, flags, image_type)
  end

  @doc ~S"""
  Enqueue commands to read from an image or image array object to host memory.

  ### Parameters

  `queue` \
  Refers to the command-queue in which the read command will be queued. `queue` and `image` must be created with the same OpenCL context.

  `image` \
  Refers to a valid image or image array object.

  `origin` \
  Defines the (x, y, z) offset in pixels in the 1D, 2D, or 3D image, the (x, y) offset and the image index in the image array or the (x) offset and the image index in the 1D image array. If image is a 2D image object, origin[2] must be 0. If image is a 1D image or 1D image buffer object, origin[1] and origin[2] must be 0. If image is a 1D image array object, origin[2] must be 0. If image is a 1D image array object, origin[1] describes the image index in the 1D image array. If image is a 2D image array object, origin[2] describes the image index in the 2D image array.

  `region` \
  Defines the (width, height, depth) in pixels of the 1D, 2D or 3D rectangle, the (width, height) in pixels of the 2D rectangle and the number of images of a 2D image array or the (width) in pixels of the 1D rectangle and the number of images of a 1D image array. If image is a 2D image object, region[2] must be 1. If image is a 1D image or 1D image buffer object, region[1] and region[2] must be 1. If image is a 1D image array object, region[2] must be 1.

  `row_pitch` \
  The length of each row in bytes. This value must be greater than or equal to the element size in bytes * width. If row_pitch is set to 0, the appropriate row pitch is calculated based on the size of each element in bytes multiplied by width.

  `slice_pitch` \
  Size in bytes of the 2D slice of the 3D region of a 3D image or each image of a 1D or 2D image array being read. This must be 0 if image is a 1D or 2D image. This value must be greater than or equal to row_pitch * height. If slice_pitch is set to 0, the appropriate slice pitch is calculated based on the row_pitch * height.

  `waitlist` \
  Specify events that need to complete before this particular command can be executed. If `waitlist` is empty, then this particular command does not wait on any event to complete. The events specified in `waitlist` act as synchronization points. The context associated with events in `waitlist` and `queue` must be the same.
  """
  @doc group: :memory_objects
  @spec enqueue_read_image(queue::cl_command_queue, image::cl_mem, origin::list(non_neg_integer), region::list(non_neg_integer), row_pitch::non_neg_integer, slice_pitch::non_neg_integer, waitlist::list(cl_event)) :: {:ok, cl_event} | {:error, cl_error}
  def enqueue_read_image(queue, image, origin, region, row_pitch, slice_pitch, waitlist \\ []) do
    :cl.enqueue_read_image(queue, image, origin, region, row_pitch, slice_pitch, waitlist)
  end

  @doc ~S"""
  Enqueues a command to write to an image or image array object from host memory.

  ### Parameters

  `queue` \
  Refers to the command-queue in which the read command will be queued. `queue` and `image` must be created with the same OpenCL context.

  `image` \
  Refers to a valid image or image array object.

  `origin` \
  Defines the (x, y, z) offset in pixels in the 1D, 2D, or 3D image, the (x, y) offset and the image index in the image array or the (x) offset and the image index in the 1D image array. If image is a 2D image object, origin[2] must be 0. If image is a 1D image or 1D image buffer object, origin[1] and origin[2] must be 0. If image is a 1D image array object, origin[2] must be 0. If image is a 1D image array object, origin[1] describes the image index in the 1D image array. If image is a 2D image array object, origin[2] describes the image index in the 2D image array.

  `region` \
  Defines the (width, height, depth) in pixels of the 1D, 2D or 3D rectangle, the (width, height) in pixels of the 2D rectangle and the number of images of a 2D image array or the (width) in pixels of the 1D rectangle and the number of images of a 1D image array. If image is a 2D image object, region[2] must be 1. If image is a 1D image or 1D image buffer object, region[1] and region[2] must be 1. If image is a 1D image array object, region[2] must be 1.

  `row_pitch` \
  The length of each row in bytes. This value must be greater than or equal to the element size in bytes * width. If row_pitch is set to 0, the appropriate row pitch is calculated based on the size of each element in bytes multiplied by width.

  `slice_pitch` \
  Size in bytes of the 2D slice of the 3D region of a 3D image or each image of a 1D or 2D image array being read. This must be 0 if image is a 1D or 2D image. This value must be greater than or equal to row_pitch * height. If slice_pitch is set to 0, the appropriate slice pitch is calculated based on the row_pitch * height.

  `data` \
  The data buffer in host memory where image data is read from.

  `waitlist` \
  Specify events that need to complete before this particular command can be executed. If `waitlist` is empty, then this particular command does not wait on any event to complete. The events specified in `waitlist` act as synchronization points. The context associated with events in `waitlist` and `queue` must be the same.
  """
  @doc group: :memory_objects
  @spec enqueue_write_image(queue::cl_command_queue, image::cl_mem, origin::list(non_neg_integer), region::list(non_neg_integer), row_pitch::non_neg_integer, slice_pitch::non_neg_integer, data::binary, waitlist::list(cl_event)) :: {:ok, cl_event} | {:error, cl_error}
  def enqueue_write_image(queue, image, origin, region, row_pitch, slice_pitch, data, waitlist \\ []) do
    :cl.enqueue_write_image(queue, image, origin, region, row_pitch, slice_pitch, data, waitlist)
  end

  @doc ~S"""
  Enqueues a command to copy image objects.

  ### Parameters

  `queue` \
  Refers to the command-queue in which the read command will be queued. `queue` and `image` must be created with the same OpenCL context.

  `src_image`, `dest_image` \
  Can be 1D, 2D, 3D image or a 1D, 2D image array objects allowing us to perform the following actions:

  * Copy a 1D image object to a 1D image object.
  * Copy a 1D image object to a scanline of a 2D image object and vice-versa.
  * Copy a 1D image object to a scanline of a 2D slice of a 3D image object and vice-versa.
  * Copy a 1D image object to a scanline of a specific image index of a 1D or 2D image array object and vice-versa.
  * Copy a 2D image object to a 2D image object.
  * Copy a 2D image object to a 2D slice of a 3D image object and vice-versa.
  * Copy a 2D image object to a specific image index of a 2D image array object and vice versa.
  * Copy images from a 1D image array object to a 1D image array object.
  * Copy images from a 2D image array object to a 2D image array object.
  * Copy a 3D image object to a 3D image object.

  `src_origin` \
  Defines the (x, y, z) offset in pixels in the 1D, 2D or 3D image, the (x, y) offset and the image index in the 2D image array or the (x) offset and the image index in the 1D image array. If image is a 2D image object, src_origin[2] must be 0. If src_image is a 1D image object, src_origin[1] and src_origin[2] must be 0. If src_image is a 1D image array object, src_origin[2] must be 0. If src_image is a 1D image array object, src_origin[1] describes the image index in the 1D image array. If src_image is a 2D image array object, src_origin[2] describes the image index in the 2D image array

  `dest_origin` \
  Defines the (x, y, z) offset in pixels in the 1D, 2D or 3D image, the (x, y) offset and the image index in the 2D image array or the (x) offset and the image index in the 1D image array. If dst_image is a 2D image object, dst_origin[2] must be 0. If dst_image is a 1D image or 1D image buffer object, dst_origin[1] and dst_origin[2] must be 0. If dst_image is a 1D image array object, dst_origin[2] must be 0. If dst_image is a 1D image array object, dst_origin[1] describes the image index in the 1D image array. If dst_image is a 2D image array object, dst_origin[2] describes the image index in the 2D image array

  `region` \
  Defines the (width, height, depth) in pixels of the 1D, 2D or 3D rectangle, the (width, height) in pixels of the 2D rectangle and the number of images of a 2D image array or the (width) in pixels of the 1D rectangle and the number of images of a 1D image array. If image is a 2D image object, region[2] must be 1. If image is a 1D image or 1D image buffer object, region[1] and region[2] must be 1. If image is a 1D image array object, region[2] must be 1.

  `waitlist` \
  Specify events that need to complete before this particular command can be executed. If `waitlist` is empty, then this particular command does not wait on any event to complete. The events specified in `waitlist` act as synchronization points. The context associated with events in `waitlist` and `queue` must be the same.
  """
  @doc group: :memory_objects
  @spec enqueue_copy_image(queue::cl_command_queue, src_image::cl_mem, dest_image::cl_mem, src_origin::list(non_neg_integer), dest_origin::list(non_neg_integer), region::list(non_neg_integer), waitlist::list(cl_event)) :: {:ok, cl_event} | {:error, cl_error}
  def enqueue_copy_image(queue, src_image, dest_image, src_origin, dest_origin, region, waitlist \\ []) do
    :cl.enqueue_copy_image(queue, src_image, dest_image, src_origin, dest_origin, region, waitlist)
  end

  @doc ~S"""
  Enqueues a command to copy an image object to a buffer object.

  ### Parameters

  `queue` \
  Refers to the command-queue in which the read command will be queued. `queue` and `image` must be created with the same OpenCL context.

  `src_image` \
  A valid image object.

  `dest_buffer` \
  A valid buffer object.

  `src_origin` \
  Defines the (x, y, z) offset in pixels in the 1D, 2D or 3D image, the (x, y) offset and the image index in the 2D image array or the (x) offset and the image index in the 1D image array. If src_image is a 2D image object, src_origin[2] must be 0. If src_image is a 1D image or 1D image buffer object, src_origin[1] and src_origin[2] must be 0. If src_image is a 1D image array object, src_origin[2] must be 0. If src_image is a 1D image array object, src_origin[1] describes the image index in the 1D image array. If src_image is a 2D image array object, src_origin[2] describes the image index in the 2D image array.

  `region` \
  Defines the (width, height, depth) in pixels of the 1D, 2D or 3D rectangle, the (width, height) in pixels of the 2D rectangle and the number of images of a 2D image array or the (width) in pixels of the 1D rectangle and the number of images of a 1D image array. If src_image is a 2D image object, region[2] must be 1. If src_image is a 1D image or 1D image buffer object, region[1] and region[2] must be 1. If src_image is a 1D image array object, region[2] must be 1.

  `dest_offset` \
  Refers to the offset where to begin copying data into dst_buffer. The size in bytes of the region to be copied referred to as dst_cb is computed as width * height * depth * bytes/image element if src_image is a 3D image object, is computed as width * height * bytes/image element if src_image is a 2D image, is computed as width * height * arraysize * bytes/image element if src_image is a 2D image array object, is computed as width * bytes/image element if src_image is a 1D image or 1D image buffer object and is computed as width * arraysize * bytes/image element if src_image is a 1D image array object.

  `waitlist` \
  Specify events that need to complete before this particular command can be executed. If `waitlist` is empty, then this particular command does not wait on any event to complete. The events specified in `waitlist` act as synchronization points. The context associated with events in `waitlist` and `queue` must be the same.
  """
  @doc group: :memory_objects
  @spec enqueue_copy_image_to_buffer(queue::cl_command_queue, src_image::cl_mem, dest_buffer::cl_mem, src_origin::list(non_neg_integer), region::list(non_neg_integer), dest_offset::non_neg_integer, waitlist::list(cl_event)) :: {:ok, cl_event} | {:error, cl_error}
  def enqueue_copy_image_to_buffer(queue, src_image, dest_buffer, src_origin, region, dest_offset, waitlist \\ []) do
    :cl.enqueue_copy_image_to_buffer(queue, src_image, dest_buffer, src_origin, region, dest_offset, waitlist)
  end

  @doc ~S"""
  Enqueues a command to copy from one buffer object to another.

  ### Parameters

  `queue` \
  Refers to the command-queue in which the read command will be queued. `queue` and `image` must be created with the same OpenCL context.

  `src_buffer` \
  A valid buffer object.

  `dest_buffer` \
  A valid buffer object.

  `src_offset` \
  The offset where to begin copying data from `src_buffer`.

  `dest_offset` \
  The offset where to begin copying data into `dest_buffer`.

  `size` \
  Refers to the size in bytes to copy.

  `waitlist` \
  Specify events that need to complete before this particular command can be executed. If `waitlist` is empty, then this particular command does not wait on any event to complete. The events specified in `waitlist` act as synchronization points. The context associated with events in `waitlist` and `queue` must be the same.
  """
  @doc group: :memory_objects
  @spec enqueue_copy_buffer(queue::cl_command_queue, src_buffer::cl_mem, dest_buffer::cl_mem, src_offset::non_neg_integer, dest_offset::non_neg_integer, size::non_neg_integer, waitlist::list(cl_event)) :: {:ok, cl_event} | {:error, cl_error}
  def enqueue_copy_buffer(queue, src_buffer, dest_buffer, src_offset, dest_offset, size, waitlist \\ []) do
    :cl.enqueue_copy_buffer(queue, src_buffer, dest_buffer, src_offset, dest_offset, size, waitlist)
  end

  @doc ~S"""
  Enqueues a command to copy a buffer object to an image object.

  ### Parameters

  `queue` \
  Refers to the command-queue in which the read command will be queued. `queue` and `image` must be created with the same OpenCL context.

  `src_buffer` \
  A valid buffer object.

  `dest_image` \
  A valid image object.

  `src_offset` \
  The offset where to begin copying data from `src_buffer`.

  `dest_origin` \
  Defines the (x, y, z) offset in pixels in the 1D, 2D or 3D image, the (x, y) offset and the image index in the 2D image array or the (x) offset and the image index in the 1D image array. If dst_image is a 2D image object, dst_origin[2] must be 0. If dst_image is a 1D image or 1D image buffer object, dst_origin[1] and dst_origin[2] must be 0. If dst_image is a 1D image array object, dst_origin[2] must be 0. If dst_image is a 1D image array object, dst_origin[1] describes the image index in the 1D image array. If dst_image is a 2D image array object, dst_origin[2] describes the image index in the 2D image array.

  `region` \
    Defines the (width, height, depth) in pixels of the 1D, 2D or 3D rectangle, the (width, height) in pixels of the 2D rectangle and the number of images of a 2D image array or the (width) in pixels of the 1D rectangle and the number of images of a 1D image array. If dst_image is a 2D image object, region[2] must be 1. If dst_image is a 1D image or 1D image buffer object, region[1] and region[2] must be 1. If dst_image is a 1D image array object, region[2] must be 1.

    The size in bytes of the region to be copied from src_buffer referred to as src_cb is computed as width * height * depth * bytes/image_element if dst_image is a 3D image object, is computed as width * height * bytes/image_element if dst_image is a 2D image, is computed as width * height * arraysize * bytes/image_element if dst_image is a 2D image array object, is computed as width * bytes/image_element if dst_image is a 1D image or 1D image buffer object and is computed as width * arraysize * bytes/image_element if dst_image is a 1D image array object.

  `waitlist` \
  Specify events that need to complete before this particular command can be executed. If `waitlist` is empty, then this particular command does not wait on any event to complete. The events specified in `waitlist` act as synchronization points. The context associated with events in `waitlist` and `queue` must be the same.
  """
  @doc group: :memory_objects
  @spec enqueue_copy_buffer_to_image(queue::cl_command_queue, src_buffer::cl_mem, dest_image::cl_mem, src_offset::non_neg_integer, dest_origin::list(non_neg_integer), region::list(non_neg_integer), waitlist::list(cl_event)) :: {:ok, cl_event} | {:error, cl_error}
  def enqueue_copy_buffer_to_image(queue, src_buffer, dest_image, src_offset, dest_origin, region, waitlist \\ []) do
    :cl.enqueue_copy_buffer_to_image(queue, src_buffer, dest_image, src_offset, dest_origin, region, waitlist)
  end

  @doc ~S"""
  Get information specific to an image object.

  ### Parameters

  `image` \
  Specifies the image being queried.
  """
  @doc group: :memory_objects
  @spec get_image_info(image::cl_mem) :: {:ok, keyword()} | {:error, cl_error}
  def get_image_info(image) do
    :cl.get_image_info(image)
  end

  @doc ~S"""
  Enqueue commands to read from a rectangular region from a buffer object to host memory.

  ### Parameters

  `queue` \
  Refers to the command-queue in which the read command will be queued. `queue` and `image` must be created with the same OpenCL context.

  `buffer` \
  Refers to a valid buffer object.

  `buffer_origin` \
  The (x, y, z) offset in the memory region associated with buffer. For a 2D rectangle region, the z value given by buffer_origin[2] should be 0. The offset in bytes is computed as buffer_origin[2] * buffer_slice_pitch + buffer_origin[1] * buffer_row_pitch + buffer_origin[0].

  `host_origin` \
  The (x, y, z) offset in the memory region pointed to by ptr. For a 2D rectangle region, the z value given by host_origin[2] should be 0. The offset in bytes is computed as host_origin[2] * host_slice_pitch + host_origin[1] * host_row_pitch + host_origin[0].

  `region` \
  The (width, height, depth) in bytes of the 2D or 3D rectangle being read or written. For a 2D rectangle copy, the depth value given by region[2] should be 1.

  `buffer_row_pitch` \
  The length of each row in bytes to be used for the memory region associated with buffer. If buffer_row_pitch is 0, buffer_row_pitch is computed as region[0].

  `buffer_slice_pitch` \
  The length of each 2D slice in bytes to be used for the memory region associated with buffer. If buffer_slice_pitch is 0, buffer_slice_pitch is computed as region[1] * buffer_row_pitch.

  `host_row_pitch` \
  The length of each row in bytes to be used for the memory region pointed to by ptr. If host_row_pitch is 0, host_row_pitch is computed as region[0].

  `host_slice_pitch` \
  The length of each 2D slice in bytes to be used for the memory region pointed to by ptr. If host_slice_pitch is 0, host_slice_pitch is computed as region[1] * host_row_pitch.

  `waitlist` \
  Specify events that need to complete before this particular command can be executed. If `waitlist` is empty, then this particular command does not wait on any event to complete. The events specified in `waitlist` act as synchronization points. The context associated with events in `waitlist` and `queue` must be the same.
  """
  @doc group: :memory_objects
  @spec enqueue_read_buffer_rect(queue::cl_command_queue, buffer::cl_mem, buffer_origin::list(non_neg_integer), host_origin::list(non_neg_integer), region::list(non_neg_integer), buffer_row_pitch::non_neg_integer, buffer_slice_pitch::non_neg_integer, host_row_pitch::non_neg_integer, host_slice_pitch::non_neg_integer, waitlist::list(cl_event)) :: {:ok, cl_event} | {:error, cl_error}
  def enqueue_read_buffer_rect(queue, buffer, buffer_origin, host_origin, region, buffer_row_pitch, buffer_slice_pitch, host_row_pitch, host_slice_pitch, waitlist \\ []) do
    :cl.enqueue_read_buffer_rect(queue, buffer, buffer_origin, host_origin, region, buffer_row_pitch, buffer_slice_pitch, host_row_pitch, host_slice_pitch, waitlist)
  end

  @doc ~S"""
  Enqueue commands to write a 2D or 3D rectangular region to a buffer object from host memory.

  ### Parameters

  `queue` \
  Refers to the command-queue in which the read command will be queued. `queue` and `image` must be created with the same OpenCL context.

  `buffer` \
  Refers to a valid buffer object.

  `buffer_origin` \
  The (x, y, z) offset in the memory region associated with buffer. For a 2D rectangle region, the z value given by buffer_origin[2] should be 0. The offset in bytes is computed as buffer_origin[2] * buffer_slice_pitch + buffer_origin[1] * buffer_row_pitch + buffer_origin[0].

  `host_origin` \
  The (x, y, z) offset in the memory region pointed to by ptr. For a 2D rectangle region, the z value given by host_origin[2] should be 0. The offset in bytes is computed as host_origin[2] * host_slice_pitch + host_origin[1] * host_row_pitch + host_origin[0].

  `region` \
  The (width, height, depth) in bytes of the 2D or 3D rectangle being read or written. For a 2D rectangle copy, the depth value given by region[2] should be 1.

  `buffer_row_pitch` \
  The length of each row in bytes to be used for the memory region associated with buffer. If buffer_row_pitch is 0, buffer_row_pitch is computed as region[0].

  `buffer_slice_pitch` \
  The length of each 2D slice in bytes to be used for the memory region associated with buffer. If buffer_slice_pitch is 0, buffer_slice_pitch is computed as region[1] * buffer_row_pitch.

  `host_row_pitch` \
  The length of each row in bytes to be used for the memory region pointed to by ptr. If host_row_pitch is 0, host_row_pitch is computed as region[0].

  `host_slice_pitch` \
  The length of each 2D slice in bytes to be used for the memory region pointed to by ptr. If host_slice_pitch is 0, host_slice_pitch is computed as region[1] * host_row_pitch.

  `data` \
  A valid buffer in host memory where data is to be read into.

  `waitlist` \
  Specify events that need to complete before this particular command can be executed. If `waitlist` is empty, then this particular command does not wait on any event to complete. The events specified in `waitlist` act as synchronization points. The context associated with events in `waitlist` and `queue` must be the same.
  """
  @doc group: :memory_objects
  @spec enqueue_write_buffer_rect(queue::cl_command_queue, buffer::cl_mem, buffer_origin::list(non_neg_integer), host_origin::list(non_neg_integer), region::list(non_neg_integer), buffer_row_pitch::non_neg_integer, buffer_slice_pitch::non_neg_integer, host_row_pitch::non_neg_integer, host_slice_pitch::non_neg_integer, data::binary, waitlist::list(cl_event)) :: {:ok, cl_event} | {:error, cl_error}
  def enqueue_write_buffer_rect(queue, buffer, buffer_origin, host_origin, region, buffer_row_pitch, buffer_slice_pitch, host_row_pitch, host_slice_pitch, data, waitlist \\ []) do
    :cl.enqueue_write_buffer_rect(queue, buffer, buffer_origin, host_origin, region, buffer_row_pitch, buffer_slice_pitch, host_row_pitch, host_slice_pitch, data, waitlist)
  end

  @doc ~S"""
  Enqueues a command to copy a rectangular region from a buffer object to another buffer object.

  ### Parameters

  `queue` \
  Refers to the command-queue in which the read command will be queued. `queue` and `image` must be created with the same OpenCL context.

  `src_buffer` \
  A valid buffer object.

  `dest_buffer` \
  A valid buffer object.

  `src_origin` \
  The (x, y, z) offset in the memory region associated with src_buffer. For a 2D rectangle region, the z value given by src_origin[2] should be 0. The offset in bytes is computed as src_origin[2] * src_slice_pitch + src_origin[1] * src_row_pitch + src_origin[0].

  `dest_origin` \
  The (x, y, z) offset in the memory region associated with dst_buffer. For a 2D rectangle region, the z value given by dst_origin[2] should be 0. The offset in bytes is computed as dst_origin[2] * dst_slice_pitch + dst_origin[1] * dst_row_pitch + dst_origin[0].

  `region` \
  The (width, height, depth) in bytes of the 2D or 3D rectangle being copied. For a 2D rectangle, the depth value given by region[2] should be 1.

  `src_row_pitch` \
  The length of each row in bytes to be used for the memory region associated with src_buffer. If src_row_pitch is 0, src_row_pitch is computed as region[0].

  `src_slice_pitch` \
  The length of each 2D slice in bytes to be used for the memory region associated with src_buffer. If src_slice_pitch is 0, src_slice_pitch is computed as region[1] * src_row_pitch.

  `dest_row_pitch` \
  The length of each row in bytes to be used for the memory region associated with dst_buffer. If dst_row_pitch is 0, dst_row_pitch is computed as region[0].

  `dest_slice_pitch` \
  The length of each 2D slice in bytes to be used for the memory region associated with dst_buffer. If dst_slice_pitch is 0, dst_slice_pitch is computed as region[1] * dst_row_pitch.

  `waitlist` \
  Specify events that need to complete before this particular command can be executed. If `waitlist` is empty, then this particular command does not wait on any event to complete. The events specified in `waitlist` act as synchronization points. The context associated with events in `waitlist` and `queue` must be the same.
  """
  @doc group: :memory_objects
  @spec enqueue_copy_buffer_rect(queue::cl_command_queue, src_buffer::cl_mem, dest_buffer::cl_mem, src_origin::list(non_neg_integer), dest_origin::list(non_neg_integer), region::list(non_neg_integer), src_row_pitch::non_neg_integer, src_slice_pitch::non_neg_integer, dest_row_pitch::non_neg_integer, dest_slice_pitch::non_neg_integer, waitlist::list(cl_event)) :: {:ok, cl_event} | {:error, cl_error}
  def enqueue_copy_buffer_rect(queue, src_buffer, dest_buffer, src_origin, dest_origin, region, src_row_pitch, src_slice_pitch, dest_row_pitch, dest_slice_pitch, waitlist \\ []) do
    # TODO something in the event handler for this function has an issue; tends to segfault when calling wait_for_events/1. :(
    :cl.enqueue_copy_buffer_rect(queue, src_buffer, dest_buffer, src_origin, dest_origin, region, src_row_pitch, src_slice_pitch, dest_row_pitch, dest_slice_pitch, waitlist)
  end

  @doc ~S"""
  Enqueues a command to fill a buffer object with a pattern of a given pattern size.

  ### Parameters

  `queue` \
  Refers to the command-queue in which the read command will be queued. `queue` and `image` must be created with the same OpenCL context.

  `buffer` \
  A valid buffer object.

  `pattern` \
  A pointer to the data pattern of size pattern_size in bytes. pattern will be used to fill a region in buffer starting at offset and is size bytes in size. The data pattern must be a scalar or vector integer or floating-point data type. For example, if buffer is to be filled with a pattern of float4 values, then pattern will be a pointer to a cl_float4 value and pattern_size will be sizeof(cl_float4). The maximum value of pattern_size is the size of the largest integer or floating-point vector data type supported by the OpenCL device. The memory associated with pattern can be reused or freed after the function returns.

  `offset` \
  The location in bytes of the region being filled in buffer and must be a multiple of `pattern` size in bytes.

  `size` \
  The size in bytes of region being filled in buffer and must be a multiple of `pattern` size in bytes.

  `waitlist` \
  Specify events that need to complete before this particular command can be executed. If `waitlist` is empty, then this particular command does not wait on any event to complete. The events specified in `waitlist` act as synchronization points. The context associated with events in `waitlist` and `queue` must be the same.
  """
  @doc group: :memory_objects
  @spec enqueue_fill_buffer(queue::cl_command_queue, buffer::cl_mem, pattern::binary, offset::non_neg_integer, size::non_neg_integer, waitlist::list(cl_event)) :: {:ok, cl_event} | {:error, cl_error}
  def enqueue_fill_buffer(queue, buffer, pattern, offset, size, waitlist \\ []) do
    :cl.enqueue_fill_buffer(queue, buffer, pattern, offset, size, waitlist)
  end

  @doc ~S"""
  Creates a 1D image, 1D image buffer, 1D image array, 2D image, 2D image array or 3D image object.

  The `flags` are used to specify allocation and usage information such as the memory arena that should be used to allocate the buffer object and how it will be used. The following table describes the possible values for flags. If `flags` is an empty list, the default is used which is `:read_write`.

  Flag                                  | Description
  :------------------------------------ | :---------
  `:read_write`                     | This flag specifies that the memory object will be read and written by a kernel. This is the default.
  `:write_only`                     | This flags specifies that the memory object will be written but not read by a kernel. Reading from a buffer or image object created with `:write_only` inside a kernel is undefined. `:read_write` and `:write_only` are mutually exclusive.
  `:read_only`                      | This flag specifies that the memory object is a read-only memory object when used inside a kernel. Writing to a buffer or image object created with `:read_only` inside a kernel is undefined. `:read_write` or `:write_only` and `:read_only` are mutually exclusive.
  `:use_host_ptr`                   | This flag is valid only if host_ptr is not NULL. If specified, it indicates that the application wants the OpenCL implementation to use memory referenced by host_ptr as the storage bits for the memory object. OpenCL implementations are allowed to cache the buffer contents pointed to by host_ptr in device memory. This cached copy can be used when kernels are executed on a device. The result of OpenCL commands that operate on multiple buffer objects created with the same host_ptr or overlapping host regions is considered to be undefined. Refer to the description of the alignment rules for host_ptr for memory objects (buffer and images) created using `:use_host_ptr`.
  `:alloc_host_ptr`                 | This flag specifies that the application wants the OpenCL implementation to allocate memory from host accessible memory. `:alloc_host_ptr` and `:use_host_ptr` are mutually exclusive.
  `:copy_host_ptr`                  | This flag is valid only if host_ptr is not NULL. If specified, it indicates that the application wants the OpenCL implementation to allocate memory for the memory object and copy the data from memory referenced by host_ptr. `:copy_host_ptr` and `:use_host_ptr` are mutually exclusive. `:copy_host_ptr` can be used with `:alloc_host_ptr` to initialize the contents of the cl_mem object allocated using host-accessible (e.g. PCIe) memory.

  See `Clex.CL.ImageFormat` for image format details.

  See `Clex.CL.ImageDesc` for image description details.

  See `get_supported_image_formats/3` to discover what formats are supported by your OpenCL device.
  """
  @doc group: :memory_objects
  @spec create_image(context::cl_context, flags::list(cl_mem_flag), image_format::cl_image_format, image_desc::cl_image_desc, data::binary) :: {:ok, cl_mem} | {:error, cl_error}
  def create_image(context, flags, image_format, image_desc, data) do
    :cl.create_image(context, flags, image_format, image_desc, data)
  end

  @doc ~S"""
  Enqueues a command to fill an image object with a specified color.

  ### Parameters

  `queue` \
  Refers to the command-queue in which the read command will be queued. `queue` and `image` must be created with the same OpenCL context.

  `image` \
  A valid image object.

  `fill_color` \
  The fill color. The fill color is a four component RGBA floating-point color value if the image channel data type is not an unnormalized signed and unsigned integer type, is a four component signed integer value if the image channel data type is an unnormalized signed integer type and is a four component unsigned integer value if the image channel data type is an unormalized unsigned integer type. The fill color will be converted to the appropriate image channel format and order associated with image.

  `origin` \
  Defines the (x, y, z) offset in pixels in the 1D, 2D, or 3D image, the (x, y) offset and the image index in the image array or the (x) offset and the image index in the 1D image array. If image is a 2D image object, origin[2] must be 0. If image is a 1D image or 1D image buffer object, origin[1] and origin[2] must be 0. If image is a 1D image array object, origin[2] must be 0. If image is a 1D image array object, origin[1] describes the image index in the 1D image array. If image is a 2D image array object, origin[2] describes the image index in the 2D image array.

  `region` \
  Defines the (width, height, depth) in pixels of the 1D, 2D or 3D rectangle, the (width, height) in pixels of the 2D rectangle and the number of images of a 2D image array or the (width) in pixels of the 1D rectangle and the number of images of a 1D image array. If image is a 2D image object, region[2] must be 1. If image is a 1D image or 1D image buffer object, region[1] and region[2] must be 1. If image is a 1D image array object, region[2] must be 1.

  `waitlist` \
  Specify events that need to complete before this particular command can be executed. If `waitlist` is empty, then this particular command does not wait on any event to complete. The events specified in `waitlist` act as synchronization points. The context associated with events in `waitlist` and `queue` must be the same.
  """
  @doc group: :memory_objects
  @spec enqueue_fill_image(queue::cl_command_queue, image::cl_mem, fill_color::binary, origin::list(non_neg_integer), region::list(non_neg_integer), waitlist::list(cl_event)) :: {:ok, cl_event} | {:error, cl_error}
  def enqueue_fill_image(queue, image, fill_color, origin, region, waitlist \\ []) do
    :cl.enqueue_fill_image(queue, image, fill_color, origin, region, waitlist)
  end

  @doc ~S"""
  Enqueues a command to indicate which device a set of memory objects should be associated with.

  ### Parameters

  `queue` \
  Refers to the command-queue in which the read command will be queued. `queue` and `image` must be created with the same OpenCL context.

  `mem_objects` \
  A list of memory objects.

  `flags` \
  A list of flags used to specify migration options.  The table below describes the possible values for flags.

    Flag                | Description
  :-------------------- | :---------
  `:host`               | This flag indicates that the specified set of memory objects are to be migrated to the host, regardless of the target command-queue.
  `:content_undefined`  | This flag indicates that the contents of the set of memory objects are undefined after migration. The specified set of memory objects are migrated to the device associated with command_queue without incurring the overhead of migrating their contents.

  `waitlist` \
  Specify events that need to complete before this particular command can be executed. If `waitlist` is empty, then this particular command does not wait on any event to complete. The events specified in `waitlist` act as synchronization points. The context associated with events in `waitlist` and `queue` must be the same.
  """
  @doc group: :memory_objects
  @spec enqueue_migrate_mem_objects(queue::cl_command_queue, mem_objects::list(cl_mem), flags::list(cl_mem_migration_flags), waitlist::list(cl_event)) :: {:ok, cl_event} | {:error, cl_error}
  def enqueue_migrate_mem_objects(queue, mem_objects, flags, waitlist \\ []) do
    :cl.enqueue_migrate_mem_objects(queue, mem_objects, flags, waitlist)
  end

  @doc ~S"""
  Enqueue commands to read from a buffer object to host memory.

  ### Parameters

  `queue` \
  Refers to the command-queue in which the read command will be queued. `queue` and `image` must be created with the same OpenCL context.

  `buffer` \
  Refers to a valid buffer object.

  `offset` \
  The offset in bytes in the buffer object to read from.

  `size` \
  The size in bytes of data being read.

  `waitlist` \
  Specify events that need to complete before this particular command can be executed. If `waitlist` is empty, then this particular command does not wait on any event to complete. The events specified in `waitlist` act as synchronization points. The context associated with events in `waitlist` and `queue` must be the same.
  """
  @doc group: :memory_objects
  @spec enqueue_read_buffer(queue::cl_command_queue, buffer::cl_mem, offset::non_neg_integer, size::non_neg_integer, waitlist::list(cl_event)) :: {:ok, cl_event} | {:error, cl_error}
  def enqueue_read_buffer(queue, buffer, offset, size, waitlist \\ []) do
    :cl.enqueue_read_buffer(queue, buffer, offset, size, waitlist)
  end

  @doc ~S"""
  Enqueue commands to write to a buffer object from host memory.

  ### Parameters

  `queue` \
  Refers to the command-queue in which the read command will be queued. `queue` and `image` must be created with the same OpenCL context.

  `buffer` \
  Refers to a valid buffer object.

  `offset` \
  The offset in bytes in the buffer object to write to.

  `size` \
  The size in bytes of data being written.

  `data` \
  The buffer in host memory where data is to be written from.

  `waitlist` \
  Specify events that need to complete before this particular command can be executed. If `waitlist` is empty, then this particular command does not wait on any event to complete. The events specified in `waitlist` act as synchronization points. The context associated with events in `waitlist` and `queue` must be the same.
  """
  @doc group: :memory_objects
  @spec enqueue_write_buffer(queue::cl_command_queue, buffer::cl_mem, offset::non_neg_integer, size::non_neg_integer, data::binary, waitlist::list(cl_event)) :: {:ok, cl_event} | {:error, cl_error}
  def enqueue_write_buffer(queue, buffer, offset, size, data, waitlist \\ []) do
    :cl.enqueue_write_buffer(queue, buffer, offset, size, data, waitlist)
  end

  ############################################################
  # Sampler Objects
  ############################################################

  @doc ~S"""
  Creates a sampler object.

  ### Parameters

  `context` \
  Must be a valid OpenCL context.

  `normalized` \
  Determines if the image coordinates specified are normalized (`:true`) or not (`:false`).

  `addressing_mode` \
  Specifies how out-of-range image coordinates are handled when reading from an image. This can be set to one of `:none`, `:clamp_to_edge`, `:clamp`, or `:repeat`.

  `filter_mode` \
  Specifies the type of filter that must be applied when reading an image. This can be `:nearest` or`:linear`.
  """
  @doc group: :sampler_objects
  @spec create_sampler(context::cl_context, normalized::boolean, addressing_mode::cl_addressing_mode, filter_mode::cl_filter_mode) :: {:ok, cl_sampler} | {:error, cl_error}
  def create_sampler(context, normalized, addressing_mode, filter_mode) do
    :cl.create_sampler(context, normalized, addressing_mode, filter_mode)
  end

  @doc ~S"""
  Increment the reference count on a sampler.

  To decrement the reference count, see `release_sampler/1`.
  """
  @doc group: :sampler_objects
  @spec retain_sampler(sampler::cl_sampler) :: :ok | {:error, cl_error}
  def retain_sampler(sampler) do
    :cl.retain_sampler(sampler)
  end

  @doc ~S"""
  Decrement the reference count on a sampler.

  Once the reference count goes to zero and all attached resources are released, the sampler is deleted.
  To increment the reference count, see `retain_sampler/1`.
  """
  @doc group: :sampler_objects
  @spec release_sampler(sampler::cl_sampler) :: :ok | {:error, cl_error}
  def release_sampler(sampler) do
    :cl.release_sampler(sampler)
  end

  @doc ~S"""
  Returns information about the sampler object.

  ### Parameters

  `sampler` \
  Specifies the sampler being queried.
  """
  @doc group: :sampler_objects
  @spec get_sampler_info(sampler::cl_sampler) :: {:ok, keyword()} | {:error, cl_error}
  def get_sampler_info(sampler) do
    :cl.get_sampler_info(sampler)
  end

  ############################################################
  # Program Objects
  ############################################################

  @doc ~S"""
  Creates a program object for a context, and loads the source code provided into the program object.

  ### Parameters

  `context` \
  Must be a valid OpenCL context.

  `source` \
  The textual source code to be loaded into the program pbject.  The devices associated with the program object are the devices associated with context. The source code provided is either an OpenCL C program source, header or implementation-defined source for custom devices that support an online compiler.
  """
  @doc group: :program_objects
  @spec create_program_with_source(context::cl_context, source::iodata) :: {:ok, cl_program} | {:error, cl_error}
  def create_program_with_source(context, source) do
    :cl.create_program_with_source(context, source)
  end

  @doc ~S"""
  Creates a program object for a context, and loads the binary bits specified by binary into the program object.

  ### Parameters

  `context` \
  Must be a valid OpenCL context.

  `device_binaries` \
  A list of tuples of the form `{device, binary}` where `device` belongs to `context` and `binary` is one of:

  - A program executable to be run on the device(s) associated with `context`.
  - A compiled program for device(s) associated with `context`.
  - A library of compiled programs for device(s) associated with `context`.
  """
  @doc group: :program_objects
  @spec create_program_with_binary(context::cl_context, device_binaries::list({cl_device, binary})) :: {:ok, cl_program} | {:error, cl_error}
  def create_program_with_binary(context, device_binaries) do
    {devices, binaries} = Enum.unzip(device_binaries)
    :cl.create_program_with_binary(context, devices, binaries)
  end

  @doc ~S"""
  Creates a program object for a context, and loads the information related to the built-in kernels into a program object.

  ### Parameters

  `context` \
  Must be a valid OpenCL context.

  `devices` \
  A list of devices that are in context. `devices` must not be an empty list. The built-in kernels are loaded for devices specified in this list.

  The devices associated with the program object will be the list of devices specified by `devices`. The list of devices specified by `devices` must be devices associated with `context`.

  `kernel_names` \
  A list of built-in kernel names.
  """
  @doc group: :program_objects
  @spec create_program_with_builtin_kernels(context::cl_context, devices::list(cl_device), kernel_names::list(binary)) :: {:ok, cl_program} | {:error, cl_error}
  def create_program_with_builtin_kernels(context, devices, kernel_names) do
    :cl.create_program_with_builtin_kernels(context, devices, Enum.join(kernel_names, ";") |> :binary.bin_to_list())
  end

  @doc ~S"""
  Decrement the reference count on a program.

  Once the reference count goes to zero and all attached resources are released, the program is deleted.
  To increment the reference count, see `retain_program/1`.
  """
  @doc group: :program_objects
  @spec release_program(program::cl_program) :: :ok | {:error, cl_error}
  def release_program(program) do
    :cl.release_program(program)
  end

  @doc ~S"""
  Increment the reference count on a program.

  To decrement the reference count, see `release_program/1`.
  """
  @doc group: :program_objects
  @spec retain_program(program::cl_program) :: :ok | {:error, cl_error}
  def retain_program(program) do
    :cl.retain_program(program)
  end

  @doc ~S"""
  Builds (compiles and links) a program executable from the program source or binary.

  ### Parameters

  `program` \
  The program object.

  `devices` \
  A list of devices associated with `program`. If `devices` is empty, the program executable is built for all devices associated with program for which a source or binary has been loaded. If `devices` is not empty, the program executable is built for devices specified in this list for which a source or binary has been loaded.

  `options` \
  A string of characters that describes the build options to be used for building the program executable. The list of supported options can be found for your target version of OpenCL:

  - [OpenCL 1.0 clBuildProgram](https://www.khronos.org/registry/OpenCL/sdk/1.0/docs/man/xhtml/clBuildProgram.html)
  - [OpenCL 1.1 clBuildProgram](https://www.khronos.org/registry/OpenCL/sdk/1.1/docs/man/xhtml/clBuildProgram.html)
  - [OpenCL 1.2 clBuildProgram](https://www.khronos.org/registry/OpenCL/sdk/1.2/docs/man/xhtml/clBuildProgram.html)
  """
  @doc group: :program_objects
  @spec build_program(program::cl_program, devices::list(cl_device), options::binary) :: :ok | {:error, cl_error}
  def build_program(program, devices, options) do
    :cl.build_program(program, devices, options)
  end

  @doc ~S"""
  Builds (compiles and links) a program executable from the program source or binary using default build options.  If you need to control build options, please refer to `build_program/3`.

  ### Parameters

  `program` \
  The program object.

  `devices` \
  A list of devices associated with `program`. If `devices` is empty, the program executable is built for all devices associated with program for which a source or binary has been loaded. If `devices` is not empty, the program executable is built for devices specified in this list for which a source or binary has been loaded.
  """
  @doc group: :program_objects
  @spec build_program(program::cl_program, devices::list(cl_device)) :: :ok | {:error, cl_error}
  def build_program(program, devices) do
    :cl.build_program(program, devices, '')
  end

  @doc ~S"""
  Allows the implementation to release the resources allocated by the OpenCL compiler.
  """
  @doc group: :program_objects
  @spec unload_compiler() :: :ok | {:error, cl_error}
  def unload_compiler() do
    :cl.unload_compiler()
  end

  @doc ~S"""
  Allows the implementation to release the resources allocated by the OpenCL compiler for platform.

  ### Parameters

  `platform` \
  A valid platform reference returned by `get_platform_ids/0`.
  """
  @doc group: :program_objects
  @spec unload_platform_compiler(platform::cl_platform) :: :ok | {:error, cl_error}
  def unload_platform_compiler(platform) do
    :cl.unload_platform_compiler(platform)
  end

  @doc ~S"""
  Compiles a program’s source for all the devices or a specific device(s) in the OpenCL context associated with `program`.

  ### Parameters

  `program` \
  The program object that is the compilation target.

  `devices` \
  A list of devices associated with `program`. If `devices` is empty, the program executable is built for all devices associated with program for which a source or binary has been loaded. If `devices` is not empty, the program executable is built for devices specified in this list for which a source or binary has been loaded.

  `options` \
  A string of characters that describes the build options to be used for building the program executable. The list of supported options can be found for your target version of OpenCL:

  - [OpenCL 1.2 clBuildProgram](https://www.khronos.org/registry/OpenCL/sdk/1.2/docs/man/xhtml/clCompileProgram.html)

  `named_headers` \
  A list of tuples of the form `{name, header}` where `name` specifies the include name used by source in `program` that comes from an embedded header and `header` is the program object which contains the header source to be used.  If multiple entries in `named_headers` refer to the same header name, the first one encountered will be used.
  """
  @doc group: :program_objects
  @spec compile_program(program::cl_program, devices::list(cl_device), options::binary, named_headers::list({binary, cl_program})) :: :ok | {:error, cl_error}
  def compile_program(program, devices, options, named_headers) do
    {names, headers} = Enum.unzip(named_headers)
    :cl.compile_program(program, devices, options, headers, names)
  end

  @doc ~S"""
  Asynchronously compiles a program’s source for all the devices or a specific device(s) in the OpenCL context associated with `program`.

  ### Parameters

  `program` \
  The program object that is the compilation target.

  `devices` \
  A list of devices associated with `program`. If `devices` is empty, the program executable is built for all devices associated with program for which a source or binary has been loaded. If `devices` is not empty, the program executable is built for devices specified in this list for which a source or binary has been loaded.

  `options` \
  A string of characters that describes the build options to be used for building the program executable. The list of supported options can be found for your target version of OpenCL:

  - [OpenCL 1.2 clBuildProgram](https://www.khronos.org/registry/OpenCL/sdk/1.2/docs/man/xhtml/clCompileProgram.html)

  `named_headers` \
  A list of tuples of the form `{name, header}` where `name` specifies the include name used by source in `program` that comes from an embedded header and `header` is the program object which contains the header source to be used.  If multiple entries in `named_headers` refer to the same header name, the first one encountered will be used.
  """
  @doc group: :program_objects
  @spec async_compile_program(program::cl_program, devices::list(cl_device), options::binary, named_headers::list({binary, cl_program})) :: :ok | {:error, cl_error}
  def async_compile_program(program, devices, options, named_headers) do
    {names, headers} = Enum.unzip(named_headers)
    :cl.async_compile_program(program, devices, options, headers, names)
  end

  @doc ~S"""
  Links a set of compiled program objects and libraries for all the devices or a specific device(s) in the OpenCL context and creates an executable.

  ### Parameters

  `context` \
  Must be a valid OpenCL context.

  `devices` \
  A list of devices associated with `program`. If `devices` is empty, the program executable is built for all devices associated with program for which a source or binary has been loaded. If `devices` is not empty, the program executable is built for devices specified in this list for which a source or binary has been loaded.

  `options` \
  A string of characters that describes the link options to be used for building the program executable. See `build_program/3` for a list of supported compiler and linker options.

  `programs` \
   A list of program objects that are compiled binaries or libraries that are to be linked to create the program executable. For each device in `devices` or if `devices` is empty the list of devices associated with `context`, the following cases occur:

  - All programs specified by `programs` contain a compiled binary or library for the device. In this case, a link is performed to generate a program executable for this device.
  - None of the programs contain a compiled binary or library for that device. In this case, no link is performed and there will be no program executable generated for this device.
  - All other cases will return a `:invalid_operation` error.
  """
  @doc group: :program_objects
  @spec link_program(context::cl_context, devices::list(cl_device), options::binary, programs::list(cl_program)) :: {:ok, cl_program} | {:error, cl_error}
  def link_program(context, devices, options, programs) do
    :cl.link_program(context, devices, options, programs)
  end

  @doc ~S"""
  Asynchronously links a set of compiled program objects and libraries for all the devices or a specific device(s) in the OpenCL context and creates an executable.

  ### Parameters

  `context` \
  Must be a valid OpenCL context.

  `devices` \
  A list of devices associated with `program`. If `devices` is empty, the program executable is built for all devices associated with program for which a source or binary has been loaded. If `devices` is not empty, the program executable is built for devices specified in this list for which a source or binary has been loaded.

  `options` \
  A string of characters that describes the link options to be used for building the program executable. See `build_program/3` for a list of supported compiler and linker options.

  `programs` \
   A list of program objects that are compiled binaries or libraries that are to be linked to create the program executable. For each device in `devices` or if `devices` is empty the list of devices associated with `context`, the following cases occur:

  - All programs specified by `programs` contain a compiled binary or library for the device. In this case, a link is performed to generate a program executable for this device.
  - None of the programs contain a compiled binary or library for that device. In this case, no link is performed and there will be no program executable generated for this device.
  - All other cases will return a `:invalid_operation` error.
  """
  @doc group: :program_objects
  @spec async_link_program(context::cl_context, devices::list(cl_device), options::binary, programs::list(cl_program)) :: {:ok, cl_program} | {:error, cl_error}
  def async_link_program(context, devices, options, programs) do
    :cl.async_link_program(context, devices, options, programs)
  end

  @doc ~S"""
  Returns information about the program object.

  ### Parameters

  `program` \
  Specifies the program object being queried.
  """
  @doc group: :program_objects
  @spec get_program_info(program::cl_program) :: {:ok, keyword()} | {:error, cl_error}
  def get_program_info(program) do
    :cl.get_program_info(program)
  end

  @doc ~S"""
  Returns build information for each device in the program object.

  ### Parameters

  `program` \
  Specifies the program object being queried.

  `device` \
  Specifies the device for which build information is being queried. `device` must be a valid device associated with `program`.
  """
  @doc group: :program_objects
  @spec get_program_build_info(program::cl_program, device::cl_device) :: {:ok, list(keyword())} | {:error, cl_error}
  def get_program_build_info(program, device) do
    :cl.get_program_build_info(program, device)
  end

  ############################################################
  # Kernel Objects
  ############################################################

  @doc ~S"""
  Creates a kernel object.

  A kernel is a function declared in a program. A kernel is identified by the `__kernel` qualifier applied to any function in a program. A kernel object encapsulates the specific `__kernel` function declared in a program and the argument values to be used when executing this `__kernel` function.

  ### Parameters

  `program` \
  A program object with a successfully built executable.

  `name` \
  A function name in the program declared with the `__kernel` qualifier.
  """
  @doc group: :kernel_objects
  @spec create_kernel(program::cl_program, name::binary) :: {:ok, cl_kernel} | {:error, cl_error}
  def create_kernel(program, name) do
    :cl.create_kernel(program, name |> :binary.bin_to_list())
  end

  @doc ~S"""
  Creates kernel objects for all kernel functions in a program object.

  Creates kernel objects for all kernel functions in program. Kernel objects are not created for any `__kernel` functions in program that do not have the same function definition across all devices for which a program executable has been successfully built.

  Kernel objects can only be created once you have a program object with a valid program source or binary loaded into the program object and the program executable has been successfully built for one or more devices associated with program. No changes to the program executable are allowed while there are kernel objects associated with a program object. This means that calls to `build_program/2`, `build_program/3` and `compile_program/4` return `:invalid_operation` if there are kernel objects attached to a program object. The OpenCL context associated with program will be the context associated with kernel. The list of devices associated with program are the devices associated with kernel. Devices associated with a program object for which a valid program executable has been built can be used to execute kernels declared in the program object.

  ### Parameters

  `program` \
  A program object with a successfully built executable.
  """
  @doc group: :kernel_objects
  @spec create_kernels_in_program(program::cl_program) :: {:ok, list(cl_kernel)} | {:error, cl_error}
  def create_kernels_in_program(program) do
    :cl.create_kernels_in_program(program)
  end

  @doc ~S"""
  Used to set the argument value for a specific argument of a kernel.

  ### Parameters

  `kernel` \
  A valid kernel object.

  `index` \
  The argument index. Arguments to the kernel are referred by indices that go from 0 for the leftmost argument to n - 1, where n is the total number of arguments declared by a kernel.

  `arg` \
  Argument value to set, of one of the following types: `cl_mem`, `integer`, `float`, or `binary`.
  """
  @doc group: :kernel_objects
  @spec set_kernel_arg(kernel::cl_kernel, index::non_neg_integer, arg::cl_kernel_arg) :: :ok | {:error, cl_error}
  def set_kernel_arg(kernel, index, arg) do
    :cl.set_kernel_arg(kernel, index, arg)
  end

  @doc ~S"""
  Decrement the reference count on a kernel.

  Once the reference count goes to zero and all attached resources are released, the kernel is deleted.
  To increment the reference count, see `retain_kernel/1`.
  """
  @doc group: :kernel_objects
  @spec release_kernel(kernel::cl_kernel) :: :ok | {:error, cl_error}
  def release_kernel(kernel) do
    :cl.release_kernel(kernel)
  end

  @doc ~S"""
  Increment the reference count on a kernel.

  To decrement the reference count, see `release_kernel/1`.
  """
  @doc group: :kernel_objects
  @spec retain_kernel(kernel::cl_kernel) :: :ok | {:error, cl_error}
  def retain_kernel(kernel) do
    :cl.retain_kernel(kernel)
  end

  @doc ~S"""
  Returns information about the kernel object.

  ### Parameters

  `kernel` \
  Specifies the kernel object being queried.
  """
  @doc group: :kernel_objects
  @spec get_kernel_info(kernel::cl_kernel) :: {:ok, keyword()} | {:error, cl_error}
  def get_kernel_info(kernel) do
    :cl.get_kernel_info(kernel)
  end

  @doc ~S"""
  Returns information about the kernel object that may be specific to a device.

  ### Parameters

  `kernel` \
  Specifies the kernel object being queried.

  `device` \
  Identifies a specific device in the list of devices associated with `kernel`. The list of devices is the list of devices in the OpenCL context that is associated with `kernel`. If the list of devices associated with `kernel` is a single device, device can be `:nil`.
  """
  @doc group: :kernel_objects
  @spec get_kernel_workgroup_info(kernel::cl_kernel, device::cl_device) :: {:ok, keyword()} | {:error, cl_error}
  def get_kernel_workgroup_info(kernel, device) do
    :cl.get_kernel_workgroup_info(kernel, device)
  end

  @doc ~S"""
  Returns all information about the arguments for a kernel.

  ### Parameters

  `kernel` \
  Specifies the kernel object being queried.
  """
  @doc group: :kernel_objects
  @spec get_kernel_arg_info(kernel::cl_kernel) :: {:ok, list(keyword())} | {:error, cl_error}
  def get_kernel_arg_info(kernel) do
    :cl.get_kernel_arg_info(kernel)
  end

  ############################################################
  # Executing Kernels
  ############################################################

  @doc ~S"""
  Enqueues a command to execute a kernel on a device.

  ### Parameters

  `queue` \
  A valid command-queue. The kernel will be queued for execution on the device associated with `queue`.

  `kernel` \
  A valid kernel object. The OpenCL context associated with `kernel` and `queue` must be the same.

  `waitlist` \
  Specify events that need to complete before this particular command can be executed. If `waitlist` is empty, then this particular command does not wait on any event to complete. The events specified in `waitlist` act as synchronization points. The context associated with events in `waitlist` and `queue` must be the same.
  """
  @doc group: :exec_kernels
  @spec enqueue_task(queue::cl_command_queue, kernel::cl_kernel, waitlist::list(cl_event)) :: {:ok, cl_event} | {:error, cl_error}
  def enqueue_task(queue, kernel, waitlist \\ []) do
    :cl.enqueue_task(queue, kernel, waitlist)
  end

  @doc ~S"""
  Enqueues a command to execute a kernel on a device.

  ### Parameters

  `queue` \
  A valid command-queue. The kernel will be queued for execution on the device associated with `queue`.

  `kernel` \
  A valid kernel object. The OpenCL context associated with `kernel` and `queue` must be the same.

  `global_work_size` \
  A list of unsigned values that describe the number of global work-items that will execute the kernel function.

  `local_work_size` \
  A list of unsigned values that describe the number of work-items that make up a work-group (also referred to as the size of the work-group) that will execute the kernel specified by kernel. The total number of work-items in the work-group must be less than or equal to the `:max_work_group_size` value specified in table of OpenCL Device Queries for `get_device_info/1` and the number of work-items specified in `local_work_size` must be less than or equal to the corresponding values specified by `:max_work_item_sizes`. The explicitly specified `local_work_size` will be used to determine how to break the global work-items specified by `global_work_size` into appropriate work-group instances. If `local_work_size` is specified, the values specified in `global_work_size` must be evenly divisible by the corresponding values specified in `local_work_size`.

  local_work_size can also be a NULL value in which case the OpenCL implementation will determine how to be break the global work-items into appropriate work-group instances.

  `waitlist` \
  Specify events that need to complete before this particular command can be executed. If `waitlist` is empty, then this particular command does not wait on any event to complete. The events specified in `waitlist` act as synchronization points. The context associated with events in `waitlist` and `queue` must be the same.
  """
  @doc group: :exec_kernels
  @spec enqueue_nd_range_kernel(queue::cl_command_queue, kernel::cl_kernel, global_work_size::list(non_neg_integer), local_work_size::list(non_neg_integer), waitlist::list(cl_event)) :: {:ok, cl_event} | {:error, cl_error}
  def enqueue_nd_range_kernel(queue, kernel, global_work_size, local_work_size, waitlist \\ []) do
    :cl.enqueue_nd_range_kernel(queue, kernel, global_work_size, local_work_size, waitlist)
  end

  ############################################################
  # Event Objects
  ############################################################

  @doc ~S"""
  Decrement the reference count on an event.

  To increment the reference count, see `retain_event/1`.
  """
  @doc group: :event_objects
  @spec release_event(event::cl_event) :: :ok | {:error, cl_error}
  def release_event(event) do
    :cl.release_event(event)
  end

  @doc ~S"""
  Increment the reference count on an event.

  To decrement the reference count, see `release_event/1`.
  """
  @doc group: :event_objects
  @spec retain_event(event::cl_event) :: :ok | {:error, cl_error}
  def retain_event(event) do
    :cl.retain_event(event)
  end

  @doc ~S"""
  Returns information about the event object.

  ### Parameters

  `event` \
  Specifies the event object being queried.
  """
  @doc group: :event_objects
  @spec get_event_info(event::cl_event) :: {:ok, list(keyword())} | {:error, cl_error}
  def get_event_info(event) do
    :cl.get_event_info(event)
  end

  @doc ~S"""
  Blocking wait for event to complete, no timeout.

  ### Parameters

  `event` \
  Specifies the event object being waited on.
  """
  @doc group: :event_objects
  @spec wait(event::cl_event) :: {:ok, any} | {:error, cl_error}
  def wait(event) do
    :cl.wait(event)
  end

  @doc ~S"""
  Blocking wait for event to complete, with timeout in milliseconds.

  ### Parameters

  `event` \
  Specifies the event object being waited on.

  `timeout` \
  Timeout for wait, in milliseconds.
  """
  @doc group: :event_objects
  @spec wait(event::cl_event, timeout::non_neg_integer) :: {:ok, any} | {:error, cl_error} | {:error, timeout}
  def wait(event, timeout) do
    :cl.wait(event, timeout)
  end

  @doc ~S"""
  Generate a wait operation that will run non blocking.

  A reference is returned that can be used to match the event
  that is sent when the event has completed or resulted in an error.
  The event returned has the form `{:cl_event, Ref, Result}`
  where Ref is the reference that was returned from the call and
  Result may be one of `binary` | `:complete`, or `{:error, cl_error}`.
  """
  @doc group: :event_objects
  @spec async_wait_for_event(event::cl_event) :: {:ok, reference} | {:error, cl_error}
  def async_wait_for_event(event) do
    :cl.async_wait_for_event(event)
  end

  @doc ~S"""
  Waits on the host thread for commands identified by event objects to complete.

  ### Parameters

  `waitlist` \
  Specify events that need to complete before this particular command can be executed. If `waitlist` is empty, then this particular command does not wait on any event to complete. The events specified in `waitlist` act as synchronization points. The context associated with events in `waitlist` and `queue` must be the same.
  """
  @doc group: :event_objects
  @spec wait_for_events(waitlist::list(cl_event)) :: list({:ok, any} | {:error, cl_error})
  def wait_for_events(waitlist) do
    :cl.wait_for_events(waitlist)
  end

  ############################################################
  # Synchronization
  ############################################################

  @doc ~S"""
  Enqueues a marker command to `queue`.

  The marker command is not completed until all commands enqueued before it have completed. The marker command returns a `cl_event` which can be waited on, i.e. this event can be waited on to ensure that all commands which have been queued before the marker command have been completed.

  ### Parameters

  `queue` \
  A valid command-queue.
  """
  @doc group: :synchronization
  @spec enqueue_marker(queue::cl_command_queue) :: {:ok, cl_event} | {:error, cl_error}
  def enqueue_marker(queue) do
    :cl.enqueue_marker(queue)
  end

  @doc ~S"""
  Enqueues a synchronization point that ensures that all queued commands in `queue` have finished execution before the next batch of commands can begin execution.

  ### Parameters

  `queue` \
  A valid command-queue.
  """
  @doc group: :synchronization
  @spec enqueue_barrier(queue::cl_command_queue) :: :ok | {:error, cl_error}
  def enqueue_barrier(queue) do
    :cl.enqueue_barrier(queue)
  end

  @doc ~S"""
  Enqueues a wait for a specific event or a list of events to complete before any future commands queued in the
  queue are executed.

  ### Parameters

  `queue` \
  A valid command-queue.

  `waitlist` \
  Specify events that need to complete before this particular command can be executed. If `waitlist` is empty, then this particular command does not wait on any event to complete. The events specified in `waitlist` act as synchronization points. The context associated with events in `waitlist` and `queue` must be the same.
  """
  @doc group: :synchronization
  @spec enqueue_wait_for_events(queue::cl_command_queue, waitlist::list(cl_event)) :: :ok | {:error, cl_error}
  def enqueue_wait_for_events(queue, waitlist) do
    :cl.enqueue_wait_for_events(queue, waitlist)
  end

  @doc ~S"""
  Enqueues a marker command which waits for either a list of events to complete, or all previously enqueued commands to complete.

  ### Parameters

  `queue` \
  A valid command-queue.

  `waitlist` \
  Specify events that need to complete before this particular command can be executed. If `waitlist` is empty, then this particular command does not wait on any event to complete. The events specified in `waitlist` act as synchronization points. The context associated with events in `waitlist` and `queue` must be the same.
  """
  @doc group: :synchronization
  @spec enqueue_marker_with_wait_list(queue::cl_command_queue, waitlist::list(cl_event)) :: {:ok, cl_event} | {:error, cl_error}
  def enqueue_marker_with_wait_list(queue, waitlist) do
    :cl.enqueue_marker_with_wait_list(queue, waitlist)
  end

  @doc ~S"""
  A synchronization point that enqueues a barrier operation.

  ### Parameters

  `queue` \
  A valid command-queue.

  `waitlist` \
  Specify events that need to complete before this particular command can be executed. If `waitlist` is empty, then this particular command does not wait on any event to complete. The events specified in `waitlist` act as synchronization points. The context associated with events in `waitlist` and `queue` must be the same.
  """
  @doc group: :synchronization
  @spec enqueue_barrier_with_wait_list(queue::cl_command_queue, waitlist::list(cl_event)) :: {:ok, cl_event} | {:error, cl_error}
  def enqueue_barrier_with_wait_list(queue, waitlist) do
    :cl.enqueue_barrier_with_wait_list(queue, waitlist)
  end

  ############################################################
  # Flush and Finish
  ############################################################

  @doc ~S"""
  Blocking request issues all previously queued OpenCL commands in a command queue to the device associated with the
  command queue.

  `flush/1` only guarantees that all queued commands to command queue get
  issued to the appropriate device. There is no guarantee that they
  will be complete after the call returns.

  ### Parameters

  `queue` \
  A valid command-queue.
  """
  @doc group: :flush_and_finish
  @spec flush(queue::cl_command_queue) :: :ok | {:error, cl_error}
  def flush(queue) do
    :cl.flush(queue)
  end

  @doc ~S"""
  Asynchronously issues all previously queued OpenCL commands in a command queue to the device associated with the
  command queue.

  `async_flush/1` only guarantees that all queued commands to command queue get
  issued to the appropriate device. There is no guarantee that they
  will be complete after the call returns.

  ### Parameters

  `queue` \
  A valid command-queue.
  """
  @doc group: :flush_and_finish
  @spec async_flush(queue::cl_command_queue) :: :ok | {:error, cl_error}
  def async_flush(queue) do
    :cl.async_flush(queue)
  end

  @doc ~S"""
  Blocks until all previously queued OpenCL commands
  in a command-queue are issued to the associated device and have
  completed.

  `finish/1` does not return until all queued commands in command_queue
  have been processed and completed. This function is also a
  synchronization point.

  ### Parameters

  `queue` \
  A valid command-queue.
  """
  @doc group: :flush_and_finish
  @spec finish(queue::cl_command_queue) :: :ok | {:error, cl_error}
  def finish(queue) do
    :cl.finish(queue)
  end

  @doc ~S"""
  Non-blocking call to ensure previously queued OpenCL commands
  in a command-queue are issued to the associated device and have
  completed.

  `async_finish/1` does not block until all queued commands in command_queue
  have been processed and completed, and there is no guarantee that all commands have been completed at return time.

  ### Parameters

  `queue` \
  A valid command-queue.
  """
  @doc group: :flush_and_finish
  @spec async_finish(queue::cl_command_queue) :: :ok | {:error, cl_error}
  def async_finish(queue) do
    :cl.async_finish(queue)
  end

end

defmodule Clex.CL10 do
  @moduledoc ~S"""
  This module provides an interface into the [OpenCL 1.0 API](https://www.khronos.org/registry/OpenCL/sdk/1.0/docs/man/xhtml/).
  """

  # Selectively pull in functions + docs from Clex.CL for OpenCL 1.0
  use Clex.VersionedApi

  # Platform
  add_cl_func :platform, :get_platform_ids, []
  add_cl_func :platform, :get_platform_info, [platform]

  # Devices
  add_cl_func :devices, :get_device_ids, [platform, device_type]
  add_cl_func :devices, :get_device_info, [device]

  # Context
  add_cl_func :context, :create_context, [devices]
  add_cl_func :context, :create_context_from_type, [platform, device_type]
  add_cl_func :context, :release_context, [context]
  add_cl_func :context, :retain_context, [context]
  add_cl_func :context, :get_context_info, [context]

  # Command Queues
  add_cl_func :command_queues, :create_queue, [context, device, properties]
  add_cl_func :command_queues, :create_queue, [context, device]
  add_cl_func :command_queues, :release_queue, [queue]
  add_cl_func :command_queues, :retain_queue, [queue]

  # Memory Objects
  add_cl_func :memory_objects, :create_buffer, [context, flags, size]
  add_cl_func :memory_objects, :create_buffer, [context, flags, size, data]
  add_cl_func :memory_objects, :enqueue_read_buffer, [queue, buffer, offset, size, waitlist]
  add_cl_func :memory_objects, :enqueue_write_buffer, [queue, buffer, offset, size, data, waitlist]
  add_cl_func :memory_objects, :retain_mem_object, [buffer]
  add_cl_func :memory_objects, :release_mem_object, [buffer]
  add_cl_func :memory_objects, :create_image2d, [context, flags, image_format, width, height, row_pitch, data]
  add_cl_func :memory_objects, :create_image3d, [context, flags, image_format, width, height, depth, row_pitch, slice_pitch, data]
  add_cl_func :memory_objects, :get_supported_image_formats, [context, flags, image_type]
  add_cl_func :memory_objects, :enqueue_read_image, [queue, image, origin, region, row_pitch, slice_pitch, waitlist]
  add_cl_func :memory_objects, :enqueue_write_image, [queue, image, origin, region, row_pitch, slice_pitch, data, waitlist]
  add_cl_func :memory_objects, :enqueue_copy_image, [queue, src_image, dest_image, src_origin, dest_origin, region, waitlist]
  add_cl_func :memory_objects, :enqueue_copy_image_to_buffer, [queue, src_image, dest_buffer, src_origin, region, dest_offset, waitlist]
  add_cl_func :memory_objects, :enqueue_copy_buffer, [queue, src_buffer, dest_buffer, src_offset, dest_offset, cb, waitlist]
  add_cl_func :memory_objects, :enqueue_copy_buffer_to_image, [queue, src_buffer, dest_image, src_offset, dest_origin, region, waitlist]
  add_cl_func :memory_objects, :get_mem_object_info, [buffer]
  add_cl_func :memory_objects, :get_image_info, [image]

  # Sampler Objects
  add_cl_func :sampler_objects, :create_sampler, [context, normalized, addressing_mode, filter_mode]
  add_cl_func :sampler_objects, :retain_sampler, [sampler]
  add_cl_func :sampler_objects, :release_sampler, [sampler]
  add_cl_func :sampler_objects, :get_sampler_info, [sampler]

  # Program Objects
  add_cl_func :program_objects, :create_program_with_source, [context, source]
  add_cl_func :program_objects, :create_program_with_binary, [context, device_binaries]
  add_cl_func :program_objects, :retain_program, [program]
  add_cl_func :program_objects, :release_program, [program]
  add_cl_func :program_objects, :unload_compiler, []
  add_cl_func :program_objects, :build_program, [program, devices, options]
  add_cl_func :program_objects, :build_program, [program, devices]
  add_cl_func :program_objects, :get_program_info, [program]
  add_cl_func :program_objects, :get_program_build_info, [program, device]

  # Kernel Objects
  add_cl_func :kernel_objects, :create_kernel, [program, name]
  add_cl_func :kernel_objects, :create_kernels_in_program, [program]
  add_cl_func :kernel_objects, :retain_kernel, [kernel]
  add_cl_func :kernel_objects, :release_kernel, [kernel]
  add_cl_func :kernel_objects, :set_kernel_arg, [kernel, index, arg]
  add_cl_func :kernel_objects, :get_kernel_info, [kernel]
  add_cl_func :kernel_objects, :get_kernel_workgroup_info, [kernel, device]

  # Executing Kernels
  add_cl_func :exec_kernels, :enqueue_nd_range_kernel, [queue, kernel, global_work_size, local_work_size, waitlist]
  add_cl_func :exec_kernels, :enqueue_task, [queue, kernel, waitlist]
  # clEnqueueNativeKernel

  # Event Objects
  add_cl_func :event_objects, :wait_for_events, [waitlist]
  add_cl_func :event_objects, :get_event_info, [event]
  add_cl_func :event_objects, :retain_event, [event]
  add_cl_func :event_objects, :release_event, [event]

  # Synchronization
  add_cl_func :synchronization, :enqueue_marker, [queue]
  add_cl_func :synchronization, :enqueue_wait_for_events, [queue, waitlist]
  add_cl_func :synchronization, :enqueue_barrier, [queue]

  # Profiling Operations on Memory Objects and Kernels
  # clGetEventProfilingInfo

  # Flush and Finish
  add_cl_func :flush_and_finish, :flush, [queue]
  add_cl_func :flush_and_finish, :finish, [queue]

end

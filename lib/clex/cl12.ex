defmodule Clex.CL12 do
  @moduledoc ~S"""
  Provides an interface into the [OpenCL 1.2 API](https://www.khronos.org/registry/OpenCL/sdk/1.2/docs/man/xhtml/).
  """

  # Selectively pull in functions + docs from Clex.CL for OpenCL 1.2
  use Clex.VersionedApi

  # Platform
  add_cl_func :get_platform_ids, []
  add_cl_func :get_platform_info, [platform]

  # Devices
  add_cl_func :get_device_ids, [platform, device_type]
  add_cl_func :get_device_info, [device]

  # Partition a Device
  add_cl_func :create_sub_devices, [device, property]
  add_cl_func :retain_device, [device]
  add_cl_func :release_device, [device]

  # Context
  add_cl_func :create_context, [devices]
  add_cl_func :create_context_from_type, [platform, device_type]
  add_cl_func :retain_context, [context]
  add_cl_func :release_context, [context]
  add_cl_func :get_context_info, [context]

  # Command Queues
  add_cl_func :create_queue, [context, device, properties]
  add_cl_func :create_queue, [context, device]
  add_cl_func :retain_queue, [queue]
  add_cl_func :release_queue, [queue]
  add_cl_func :get_queue_info, [queue]

  # Buffer Objects
  add_cl_func :create_buffer, [context, flags, size]
  add_cl_func :create_buffer, [context, flags, size, data]
  add_cl_func :create_sub_buffer, [buffer, flags, type, origin, size]
  add_cl_func :enqueue_read_buffer, [queue, buffer, offset, size, waitlist]
  add_cl_func :enqueue_write_buffer, [queue, buffer, offset, size, data, waitlist]
  add_cl_func :enqueue_read_buffer_rect, [queue, buffer, buffer_origin, host_origin, region, buffer_row_pitch, buffer_slice_pitch, host_row_pitch, host_slice_pitch, waitlist]
  add_cl_func :enqueue_write_buffer_rect, [queue, buffer, buffer_origin, host_origin, region, buffer_row_pitch, buffer_slice_pitch, host_row_pitch, host_slice_pitch, data, waitlist]
  add_cl_func :enqueue_fill_buffer, [queue, buffer, pattern, offset, size, waitlist]
  add_cl_func :enqueue_copy_buffer, [queue, src_buffer, dest_buffer, src_offset, dest_offset, cb, waitlist]
  add_cl_func :enqueue_copy_buffer_rect, [queue, src_buffer, dest_buffer, src_origin, dest_origin, region, src_row_pitch, src_slice_pitch, dest_row_pitch, dest_slice_pitch, waitlist]
  add_cl_func :create_image, [context, flags, image_format, image_desc, data]
  add_cl_func :get_supported_image_formats, [context, flags, image_type]
  add_cl_func :enqueue_read_image, [queue, image, origin, region, row_pitch, slice_pitch, waitlist]
  add_cl_func :enqueue_write_image, [queue, image, origin, region, row_pitch, slice_pitch, data, waitlist]
  add_cl_func :enqueue_fill_image, [queue, image, fill_color, origin, region, waitlist]
  add_cl_func :enqueue_copy_image, [queue, src_image, dest_image, src_origin, dest_origin, region, waitlist]
  add_cl_func :enqueue_copy_image_to_buffer, [queue, src_image, dest_buffer, src_origin, region, dest_offset, waitlist]
  add_cl_func :enqueue_copy_buffer_to_image, [queue, src_buffer, dest_image, src_offset, dest_origin, region, waitlist]
  add_cl_func :enqueue_migrate_mem_objects, [queue, mem_objects, flags, waitlist]
  add_cl_func :get_mem_object_info, [buffer]
  add_cl_func :get_image_info, [image]
  add_cl_func :retain_mem_object, [buffer]
  add_cl_func :release_mem_object, [buffer]
  # clSetMemObjectDestructorCallback

  # Sampler Objects
  add_cl_func :create_sampler, [context, normalized, addressing_mode, filter_mode]
  add_cl_func :retain_sampler, [sampler]
  add_cl_func :release_sampler, [sampler]
  add_cl_func :get_sampler_info, [sampler]

  # Program Objects
  add_cl_func :create_program_with_source, [context, source]
  add_cl_func :create_program_with_binary, [context, devices, binaries]
  add_cl_func :create_program_with_builtin_kernels, [context, devices, kernel_names]
  add_cl_func :retain_program, [program]
  add_cl_func :release_program, [program]
  add_cl_func :build_program, [program, devices, options]
  add_cl_func :build_program, [program, devices]
  add_cl_func :compile_program, [program, devices, options, headers, names]
  add_cl_func :async_compile_program, [program, devices, options, headers, names]
  add_cl_func :link_program, [context, devices, options, programs]
  add_cl_func :async_link_program, [context, devices, options, programs]
  add_cl_func :unload_platform_compiler, [platform]
  add_cl_func :get_program_info, [program]
  add_cl_func :get_program_build_info, [program, device]

  # Kernel Objects
  add_cl_func :create_kernel, [program, name]
  add_cl_func :create_kernels_in_program, [program]
  add_cl_func :retain_kernel, [kernel]
  add_cl_func :release_kernel, [kernel]
  add_cl_func :set_kernel_arg, [kernel, index, arg]
  add_cl_func :get_kernel_info, [kernel]
  add_cl_func :get_kernel_workgroup_info, [kernel, device]

  # Executing Kernels
  add_cl_func :enqueue_nd_range_kernel, [queue, kernel, global, local, waitlist]
  add_cl_func :enqueue_task, [queue, kernel, waitlist]
  # clEnqueueNativeKernel

  # Event Objects
  # clCreateUserEvent
  # clSetUserEventStatus
  add_cl_func :wait_for_events, [waitlist]
  add_cl_func :get_event_info, [event]
  # clSetEventCallback
  add_cl_func :retain_event, [event]
  add_cl_func :release_event, [event]

  # Markers, Barriers, and Waiting
  add_cl_func :enqueue_marker_with_wait_list, [queue, waitlist]
  add_cl_func :enqueue_barrier_with_wait_list, [queue, waitlist]

  # Profiling Operations on Memory Objects and Kernels
  # clGetEventProfilingInfo

  # Flush and Finish
  add_cl_func :flush, [queue]
  add_cl_func :finish, [queue]

end

defmodule Clex.CL12 do
  @moduledoc ~S"""
  This module provides an interface into the [OpenCL 1.2 API](https://www.khronos.org/registry/OpenCL/sdk/1.2/docs/man/xhtml/).
  """

  # Selectively pull in functions + docs from Clex.CL for OpenCL 1.2
  use Clex.VersionedApi

  # Platform
  add_cl_func :platform, :get_platform_ids, []
  add_cl_func :platform, :get_platform_info, [platform]

  # Devices
  add_cl_func :devices, :get_device_ids, [platform, device_type]
  add_cl_func :devices, :get_device_info, [device]

  # Partition a Device
  add_cl_func :devices, :create_sub_devices, [device, property]
  add_cl_func :devices, :retain_device, [device]
  add_cl_func :devices, :release_device, [device]

  # Context
  add_cl_func :context, :create_context, [devices]
  add_cl_func :context, :create_context_from_type, [platform, device_type]
  add_cl_func :context, :retain_context, [context]
  add_cl_func :context, :release_context, [context]
  add_cl_func :context, :get_context_info, [context]

  # Command Queues
  add_cl_func :command_queues, :create_queue, [context, device, properties]
  add_cl_func :command_queues, :create_queue, [context, device]
  add_cl_func :command_queues, :retain_queue, [queue]
  add_cl_func :command_queues, :release_queue, [queue]
  add_cl_func :command_queues, :get_queue_info, [queue]

  # Memory Objects
  add_cl_func :memory_objects, :create_buffer, [context, flags, size]
  add_cl_func :memory_objects, :create_buffer, [context, flags, size, data]
  add_cl_func :memory_objects, :create_sub_buffer, [buffer, flags, type, origin, size]
  add_cl_func :memory_objects, :enqueue_read_buffer, [queue, buffer, offset, size, waitlist]
  add_cl_func :memory_objects, :enqueue_write_buffer, [queue, buffer, offset, size, data, waitlist]
  add_cl_func :memory_objects, :enqueue_read_buffer_rect, [queue, buffer, buffer_origin, host_origin, region, buffer_row_pitch, buffer_slice_pitch, host_row_pitch, host_slice_pitch, waitlist]
  add_cl_func :memory_objects, :enqueue_write_buffer_rect, [queue, buffer, buffer_origin, host_origin, region, buffer_row_pitch, buffer_slice_pitch, host_row_pitch, host_slice_pitch, data, waitlist]
  add_cl_func :memory_objects, :enqueue_fill_buffer, [queue, buffer, pattern, offset, size, waitlist]
  add_cl_func :memory_objects, :enqueue_copy_buffer, [queue, src_buffer, dest_buffer, src_offset, dest_offset, cb, waitlist]
  add_cl_func :memory_objects, :enqueue_copy_buffer_rect, [queue, src_buffer, dest_buffer, src_origin, dest_origin, region, src_row_pitch, src_slice_pitch, dest_row_pitch, dest_slice_pitch, waitlist]
  add_cl_func :memory_objects, :create_image, [context, flags, image_format, image_desc, data]
  add_cl_func :memory_objects, :get_supported_image_formats, [context, flags, image_type]
  add_cl_func :memory_objects, :enqueue_read_image, [queue, image, origin, region, row_pitch, slice_pitch, waitlist]
  add_cl_func :memory_objects, :enqueue_write_image, [queue, image, origin, region, row_pitch, slice_pitch, data, waitlist]
  add_cl_func :memory_objects, :enqueue_fill_image, [queue, image, fill_color, origin, region, waitlist]
  add_cl_func :memory_objects, :enqueue_copy_image, [queue, src_image, dest_image, src_origin, dest_origin, region, waitlist]
  add_cl_func :memory_objects, :enqueue_copy_image_to_buffer, [queue, src_image, dest_buffer, src_origin, region, dest_offset, waitlist]
  add_cl_func :memory_objects, :enqueue_copy_buffer_to_image, [queue, src_buffer, dest_image, src_offset, dest_origin, region, waitlist]
  add_cl_func :memory_objects, :enqueue_migrate_mem_objects, [queue, mem_objects, flags, waitlist]
  add_cl_func :memory_objects, :get_mem_object_info, [buffer]
  add_cl_func :memory_objects, :get_image_info, [image]
  add_cl_func :memory_objects, :retain_mem_object, [buffer]
  add_cl_func :memory_objects, :release_mem_object, [buffer]
  # clSetMemObjectDestructorCallback

  add_cl_func :memory_objects, :enqueue_read_buffer, [queue, buffer, offset, size]
  add_cl_func :memory_objects, :enqueue_write_buffer, [queue, buffer, offset, size, data]
  add_cl_func :memory_objects, :enqueue_read_buffer_rect, [queue, buffer, buffer_origin, host_origin, region, buffer_row_pitch, buffer_slice_pitch, host_row_pitch, host_slice_pitch]
  add_cl_func :memory_objects, :enqueue_write_buffer_rect, [queue, buffer, buffer_origin, host_origin, region, buffer_row_pitch, buffer_slice_pitch, host_row_pitch, host_slice_pitch, data]
  add_cl_func :memory_objects, :enqueue_fill_buffer, [queue, buffer, pattern, offset, size]
  add_cl_func :memory_objects, :enqueue_copy_buffer, [queue, src_buffer, dest_buffer, src_offset, dest_offset, cb]
  add_cl_func :memory_objects, :enqueue_copy_buffer_rect, [queue, src_buffer, dest_buffer, src_origin, dest_origin, region, src_row_pitch, src_slice_pitch, dest_row_pitch, dest_slice_pitch]
  add_cl_func :memory_objects, :enqueue_read_image, [queue, image, origin, region, row_pitch, slice_pitch]
  add_cl_func :memory_objects, :enqueue_write_image, [queue, image, origin, region, row_pitch, slice_pitch, data]
  add_cl_func :memory_objects, :enqueue_fill_image, [queue, image, fill_color, origin, region]
  add_cl_func :memory_objects, :enqueue_copy_image, [queue, src_image, dest_image, src_origin, dest_origin, region]
  add_cl_func :memory_objects, :enqueue_copy_image_to_buffer, [queue, src_image, dest_buffer, src_origin, region, dest_offset]
  add_cl_func :memory_objects, :enqueue_copy_buffer_to_image, [queue, src_buffer, dest_image, src_offset, dest_origin, region]
  add_cl_func :memory_objects, :enqueue_migrate_mem_objects, [queue, mem_objects, flags]

  # Sampler Objects
  add_cl_func :sampler_objects, :create_sampler, [context, normalized, addressing_mode, filter_mode]
  add_cl_func :sampler_objects, :retain_sampler, [sampler]
  add_cl_func :sampler_objects, :release_sampler, [sampler]
  add_cl_func :sampler_objects, :get_sampler_info, [sampler]

  # Program Objects
  add_cl_func :program_objects, :create_program_with_source, [context, source]
  add_cl_func :program_objects, :create_program_with_binary, [context, device_binaries]
  add_cl_func :program_objects, :create_program_with_builtin_kernels, [context, devices, kernel_names]
  add_cl_func :program_objects, :retain_program, [program]
  add_cl_func :program_objects, :release_program, [program]
  add_cl_func :program_objects, :build_program, [program, devices, options]
  add_cl_func :program_objects, :build_program, [program, devices]
  add_cl_func :program_objects, :compile_program, [program, devices, options, named_headers]
  add_cl_func :program_objects, :async_compile_program, [program, devices, options, named_headers]
  add_cl_func :program_objects, :link_program, [context, devices, options, programs]
  add_cl_func :program_objects, :async_link_program, [context, devices, options, programs]
  add_cl_func :program_objects, :unload_platform_compiler, [platform]
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

  add_cl_func :exec_kernels, :enqueue_nd_range_kernel, [queue, kernel, global_work_size, local_work_size]
  add_cl_func :exec_kernels, :enqueue_task, [queue, kernel]

  # Event Objects
  # clCreateUserEvent
  # clSetUserEventStatus
  add_cl_func :event_objects, :wait_for_events, [waitlist]
  add_cl_func :event_objects, :get_event_info, [event]
  # clSetEventCallback
  add_cl_func :event_objects, :retain_event, [event]
  add_cl_func :event_objects, :release_event, [event]

  # Synchronization
  add_cl_func :synchronization, :enqueue_marker_with_wait_list, [queue, waitlist]
  add_cl_func :synchronization, :enqueue_barrier_with_wait_list, [queue, waitlist]

  # Profiling Operations on Memory Objects and Kernels
  # clGetEventProfilingInfo

  # Flush and Finish
  add_cl_func :flush_and_finish, :flush, [queue]
  add_cl_func :flush_and_finish, :finish, [queue]

end

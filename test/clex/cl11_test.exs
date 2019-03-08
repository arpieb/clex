defmodule Clex.CL11Test do
  use ExUnit.Case
  use Clex.CL.ImageFormat

  alias Clex.CL11

  @kernel_source ~S"""
  __kernel void HelloWorld(__global char* data) {
    data[0] = 'H';
    data[1] = 'E';
    data[2] = 'L';
    data[3] = 'L';
    data[4] = 'O';
    data[5] = ' ';
    data[6] = 'W';
    data[7] = 'O';
    data[8] = 'R';
    data[9] = 'L';
    data[10] = 'D';
    data[11] = '!';
    data[12] = '\n';
  }
  """

  ########################################
  # Platform
  ########################################

  test "get_platform_ids" do
    {:ok, platforms} = CL11.get_platform_ids()
    assert is_list(platforms)
    assert {:platform_t, id, reference} = hd(platforms)
  end

  test "get_platform_info" do
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, info} = CL11.get_platform_info(platform)
    assert Keyword.keyword?(info)
  end

  ########################################
  # Devices
  ########################################

  test "get_device_ids" do
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, devices} = CL11.get_device_ids(platform, :all)
    assert is_list(devices)
    assert {:device_t, id, reference} = hd(devices)
  end

  test "get_device_info" do
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, [device | _]} = CL11.get_device_ids(platform, :all)
    {:ok, info} = CL11.get_device_info(device)
    assert Keyword.keyword?(info)
  end

  ########################################
  # Context
  ########################################

  test "create_context" do
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, devices} = CL11.get_device_ids(platform, :all)
    {:ok, context} = CL11.create_context(devices)
    assert {:context_t, id, reference} = context
  end

  test "create_context_from_type" do
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, context} = CL11.create_context_from_type(platform, :all)
    assert {:context_t, id, reference} = context
  end

  test "release_context" do
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, context} = CL11.create_context_from_type(platform, :all)
    assert :ok == CL11.release_context(context)
  end

  test "retain_context" do
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, context} = CL11.create_context_from_type(platform, :all)
    assert :ok == CL11.retain_context(context)
  end

  test "get_context_info" do
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, context} = CL11.create_context_from_type(platform, :all)
    {:ok, info} = CL11.get_context_info(context)
    assert Keyword.keyword?(info)
  end

  ########################################
  # Command Queue
  ########################################

  test "create_queue" do
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, devices} = CL11.get_device_ids(platform, :all)
    {:ok, context} = CL11.create_context(devices)
    {:ok, queue} = CL11.create_queue(context, hd(devices))
    assert {:command_queue_t, id, reference} = queue
  end

  test "release_queue" do
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, devices} = CL11.get_device_ids(platform, :all)
    {:ok, context} = CL11.create_context(devices)
    {:ok, queue} = CL11.create_queue(context, hd(devices))
    assert :ok == CL11.release_queue(queue)
  end

  test "retain_queue" do
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, devices} = CL11.get_device_ids(platform, :all)
    {:ok, context} = CL11.create_context(devices)
    {:ok, queue} = CL11.create_queue(context, hd(devices))
    assert :ok == CL11.retain_queue(queue)
  end

  ########################################
  # Memory Object
  ########################################

  test "create_buffer without data" do
    size = 32
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, devices} = CL11.get_device_ids(platform, :all)
    {:ok, context} = CL11.create_context(devices)

    {:ok, buffer} = CL11.create_buffer(context, [:read_write], size)
    assert {:mem_t, id, reference} = buffer
  end

  test "create_buffer with data" do
    value = <<0, 1, 2, 3>>
    size = byte_size(value)
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, devices} = CL11.get_device_ids(platform, :all)
    {:ok, context} = CL11.create_context(devices)

    {:ok, buffer} = CL11.create_buffer(context, [:read_write], size, value)
    assert {:mem_t, id, reference} = buffer
  end

  test "create_sub_buffer" do
    size = 32
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, devices} = CL11.get_device_ids(platform, :all)
    {:ok, context} = CL11.create_context(devices)
    {:ok, buffer} = CL11.create_buffer(context, [:read_write], size)

    {:ok, sub_buffer} = CL11.create_sub_buffer(buffer, [:read_write], :region, 0, Integer.floor_div(size, 2))
    assert {:mem_t, id, reference} = sub_buffer
  end

  test "enqueue_read_buffer" do
    size = 1024
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, devices} = CL11.get_device_ids(platform, :all)
    {:ok, context} = CL11.create_context(devices)
    {:ok, queue} = CL11.create_queue(context, hd(devices))
    {:ok, buffer} = CL11.create_buffer(context, [:read_write], size)

    {:ok, event} = CL11.enqueue_read_buffer(queue, buffer, 0, size, [])
    assert {:event_t, id, reference} = event

    CL11.flush(queue)
    CL11.wait_for_events([event])
  end

  test "enqueue_write_buffer" do
    value = <<0, 1, 2, 3>>
    size = byte_size(value)
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, devices} = CL11.get_device_ids(platform, :all)
    {:ok, context} = CL11.create_context(devices)
    {:ok, queue} = CL11.create_queue(context, hd(devices))
    {:ok, buffer} = CL11.create_buffer(context, [:read_write], size)

    {:ok, event} = CL11.enqueue_write_buffer(queue, buffer, 0, byte_size(value), value, [])
    assert {:event_t, id, reference} = event

    CL11.flush(queue)
    CL11.wait_for_events([event])
  end

  test "enqueue_read_buffer_rect" do
    size = 1024
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, devices} = CL11.get_device_ids(platform, :all)
    {:ok, context} = CL11.create_context(devices)
    {:ok, queue} = CL11.create_queue(context, hd(devices))
    {:ok, buffer} = CL11.create_buffer(context, [:read_write], size)

    buffer_origin = [0, 0, 0]
    host_origin = [0, 0, 0]
    region = [10, 10, 1]
    {:ok, event} = CL11.enqueue_read_buffer_rect(queue, buffer, buffer_origin, host_origin, region, 0, 0, 0, 0, [])
    assert {:event_t, id, reference} = event

    CL11.flush(queue)
    CL11.wait_for_events([event])
  end

  test "enqueue_write_buffer_rect" do
    w = 10
    h = 10
    size_bits = w * h * 8
    data = <<0::size(size_bits)>>
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, devices} = CL11.get_device_ids(platform, :all)
    {:ok, context} = CL11.create_context(devices)
    {:ok, queue} = CL11.create_queue(context, hd(devices))
    {:ok, buffer} = CL11.create_buffer(context, [:read_write], 1024)

    buffer_origin = [0, 0, 0]
    host_origin = [0, 0, 0]
    region = [w, h, 1]
    {:ok, event} = CL11.enqueue_write_buffer_rect(queue, buffer, buffer_origin, host_origin, region, 0, 0, 0, 0, data, [])
    assert {:event_t, id, reference} = event

    CL11.flush(queue)
    CL11.wait_for_events([event])
  end

  test "retain_mem_object" do
    value = <<0, 1, 2, 3>>
    size = byte_size(value)
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, devices} = CL11.get_device_ids(platform, :all)
    {:ok, context} = CL11.create_context(devices)
    {:ok, buffer} = CL11.create_buffer(context, [:read_write], size, value)
    assert :ok == CL11.retain_mem_object(buffer)
  end

  test "release_mem_object" do
    value = <<0, 1, 2, 3>>
    size = byte_size(value)
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, devices} = CL11.get_device_ids(platform, :all)
    {:ok, context} = CL11.create_context(devices)
    {:ok, buffer} = CL11.create_buffer(context, [:read_write], size, value)
    assert :ok == CL11.release_mem_object(buffer)
  end

  test "create_image2d" do
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, devices} = CL11.get_device_ids(platform, :all)
    {:ok, context} = CL11.create_context(devices)

    img_format = cl_image_format(order: :rgba, type: :unsigned_int8)
    w = 256
    h = 256
    data_size = w * h * 4 * 8
    data = <<0::size(data_size)>>

    {:ok, image} = CL11.create_image2d(context, [:read_write], img_format, w, h, 0, data)
    assert {:mem_t, id, reference} = image
  end

  test "create_image3d" do
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, devices} = CL11.get_device_ids(platform, :all)
    {:ok, context} = CL11.create_context(devices)

    img_format = cl_image_format(order: :rgba, type: :unsigned_int8)
    w = 256
    h = 256
    d = 256
    data_size = w * h * d * 4 * 8
    data = <<0::size(data_size)>>

    {:ok, image} = CL11.create_image3d(context, [:read_write], img_format, w, h, d, 0, 0, data)
    assert {:mem_t, id, reference} = image
  end

  test "get_supported_image_formats" do
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, devices} = CL11.get_device_ids(platform, :all)
    {:ok, context} = CL11.create_context(devices)

    {:ok, formats} = CL11.get_supported_image_formats(context, [:read_only], :image2d)
    assert is_list(formats)
  end

  test "enqueue_read_image" do
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, devices} = CL11.get_device_ids(platform, :all)
    {:ok, context} = CL11.create_context(devices)
    {:ok, queue} = CL11.create_queue(context, hd(devices))

    img_format = cl_image_format(order: :rgba, type: :unsigned_int8)
    w = 256
    h = 256
    data_size = w * h * 4 * 8
    data = <<0::size(data_size)>>
    {:ok, image} = CL11.create_image2d(context, [:read_write], img_format, w, h, 0, data)

    {:ok, event} = CL11.enqueue_read_image(queue, image, [0, 0, 0], [10, 10, 1], 0, 0, [])
    assert {:event_t, id, reference} = event

    CL11.flush(queue)
    CL11.wait_for_events([event])
  end

  test "enqueue_write_image" do
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, devices} = CL11.get_device_ids(platform, :all)
    {:ok, context} = CL11.create_context(devices)
    {:ok, queue} = CL11.create_queue(context, hd(devices))

    img_format = cl_image_format(order: :rgba, type: :unsigned_int8)
    w = 256
    h = 256
    data_size = w * h * 4 * 8
    data = <<0::size(data_size)>>
    {:ok, image} = CL11.create_image2d(context, [:read_write], img_format, w, h, 0, data)

    {:ok, event} = CL11.enqueue_write_image(queue, image, [0, 0, 0], [10, 10, 1], 0, 0, data, [])
    assert {:event_t, id, reference} = event

    CL11.flush(queue)
    CL11.wait_for_events([event])
  end

  test "enqueue_copy_image" do
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, devices} = CL11.get_device_ids(platform, :all)
    {:ok, context} = CL11.create_context(devices)
    {:ok, queue} = CL11.create_queue(context, hd(devices))

    img_format = cl_image_format(order: :rgba, type: :unsigned_int8)
    w = 256
    h = 256
    data_size = w * h * 4 * 8
    data = <<0::size(data_size)>>
    {:ok, src} = CL11.create_image2d(context, [:read_write], img_format, w, h, 0, data)
    {:ok, dest} = CL11.create_image2d(context, [:read_write], img_format, w, h, 0, data)

    {:ok, event} = CL11.enqueue_copy_image(queue, src, dest, [0, 0, 0], [0, 0, 0], [10, 10, 1], [])
    assert {:event_t, id, reference} = event

    CL11.flush(queue)
    CL11.wait_for_events([event])
  end

  test "enqueue_copy_image_to_buffer" do
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, devices} = CL11.get_device_ids(platform, :all)
    {:ok, context} = CL11.create_context(devices)
    {:ok, queue} = CL11.create_queue(context, hd(devices))

    img_format = cl_image_format(order: :rgba, type: :unsigned_int8)
    w = 256
    h = 256
    data_size = w * h * 4 * 8
    data = <<0::size(data_size)>>
    {:ok, src} = CL11.create_image2d(context, [:read_write], img_format, w, h, 0, data)
    {:ok, buffer} = CL11.create_buffer(context, [:read_write], byte_size(data))

    {:ok, event} = CL11.enqueue_copy_image_to_buffer(queue, src, buffer, [0, 0, 0], [10, 10, 1], 0, [])
    assert {:event_t, id, reference} = event

    CL11.flush(queue)
    CL11.wait_for_events([event])
  end

  test "enqueue_copy_buffer" do
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, devices} = CL11.get_device_ids(platform, :all)
    {:ok, context} = CL11.create_context(devices)
    {:ok, queue} = CL11.create_queue(context, hd(devices))

    bufsize = 1024
    {:ok, src} = CL11.create_buffer(context, [:read_write], bufsize)
    {:ok, dest} = CL11.create_buffer(context, [:read_write], bufsize)

    {:ok, event} = CL11.enqueue_copy_buffer(queue, src, dest, 0, 0, bufsize, [])
    assert {:event_t, id, reference} = event

    CL11.flush(queue)
    CL11.wait_for_events([event])
  end

  test "enqueue_copy_buffer_rect" do
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, devices} = CL11.get_device_ids(platform, :all)
    {:ok, context} = CL11.create_context(devices)
    {:ok, queue} = CL11.create_queue(context, hd(devices))

    bufsize = 1024
    {:ok, src} = CL11.create_buffer(context, [:read_write], bufsize)
    {:ok, dest} = CL11.create_buffer(context, [:read_write], bufsize)

    src_origin = [0, 0, 0]
    dest_origin = [0, 0, 0]
    region = [1, 1, 1]
    {:ok, event} = CL11.enqueue_copy_buffer_rect(queue, src, dest, src_origin, dest_origin, region, 0, 0, 0, 0, [])
    assert {:event_t, id, reference} = event

    CL11.finish(queue)
    # CL11.wait_for_events([event]) # TODO something in the event handler for this function has an issue
  end

  test "enqueue_copy_buffer_to_image" do
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, devices} = CL11.get_device_ids(platform, :all)
    {:ok, context} = CL11.create_context(devices)
    {:ok, queue} = CL11.create_queue(context, hd(devices))

    img_format = cl_image_format(order: :rgba, type: :unsigned_int8)
    w = 256
    h = 256
    data_size = w * h * 4 * 8
    data = <<0::size(data_size)>>
    {:ok, dest} = CL11.create_image2d(context, [:read_write], img_format, w, h, 0, data)
    {:ok, src} = CL11.create_buffer(context, [:read_write], byte_size(data))

    {:ok, event} = CL11.enqueue_copy_buffer_to_image(queue, src, dest, 0, [0, 0, 0], [10, 10, 1], [])
    assert {:event_t, id, reference} = event

    CL11.flush(queue)
    CL11.wait_for_events([event])
  end

  test "get_mem_object_info" do
    value = <<0, 1, 2, 3>>
    size = byte_size(value)
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, devices} = CL11.get_device_ids(platform, :all)
    {:ok, context} = CL11.create_context(devices)
    {:ok, buffer} = CL11.create_buffer(context, [:read_write], size, value)

    {:ok, info} = CL11.get_mem_object_info(buffer)
    assert Keyword.keyword?(info)
  end

  test "get_image_info" do
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, devices} = CL11.get_device_ids(platform, :all)
    {:ok, context} = CL11.create_context(devices)

    img_format = cl_image_format(order: :rgba, type: :unsigned_int8)
    w = 256
    h = 256
    data_size = w * h * 4 * 8
    data = <<0::size(data_size)>>
    {:ok, image} = CL11.create_image2d(context, [:read_write], img_format, w, h, 0, data)

    {:ok, info} = CL11.get_image_info(image)
    assert Keyword.keyword?(info)
  end

  ########################################
  # Sampler Objects
  ########################################

  test "create_sampler" do
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, devices} = CL11.get_device_ids(platform, :all)
    {:ok, context} = CL11.create_context(devices)

    {:ok, sampler} = CL11.create_sampler(context, false, :none, :linear)
    assert {:sampler_t, id, reference} = sampler
  end

  test "retain_sampler" do
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, devices} = CL11.get_device_ids(platform, :all)
    {:ok, context} = CL11.create_context(devices)

    {:ok, sampler} = CL11.create_sampler(context, false, :none, :linear)
    assert :ok == CL11.retain_sampler(sampler)
  end

  test "release_sampler" do
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, devices} = CL11.get_device_ids(platform, :all)
    {:ok, context} = CL11.create_context(devices)

    {:ok, sampler} = CL11.create_sampler(context, false, :none, :linear)
    assert :ok == CL11.release_sampler(sampler)
  end

  test "get_sampler_info" do
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, devices} = CL11.get_device_ids(platform, :all)
    {:ok, context} = CL11.create_context(devices)

    {:ok, sampler} = CL11.create_sampler(context, false, :none, :linear)

    {:ok, info} = CL11.get_sampler_info(sampler)
    assert Keyword.keyword?(info)
  end

  ########################################
  # Program Objects
  ########################################

  test "create_program_with_source" do
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, devices} = CL11.get_device_ids(platform, :all)
    {:ok, context} = CL11.create_context(devices)

    {:ok, program} = CL11.create_program_with_source(context, @kernel_source)
    assert {:program_t, id, reference} = program
  end

  test "retain_program" do
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, devices} = CL11.get_device_ids(platform, :all)
    {:ok, context} = CL11.create_context(devices)
    {:ok, program} = CL11.create_program_with_source(context, @kernel_source)

    assert :ok == CL11.retain_program(program)
  end

  test "release_program" do
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, devices} = CL11.get_device_ids(platform, :all)
    {:ok, context} = CL11.create_context(devices)
    {:ok, program} = CL11.create_program_with_source(context, @kernel_source)

    assert :ok == CL11.release_program(program)
  end

  test "unload_compiler" do
    assert :ok == CL11.unload_compiler()
  end

  test "build_program" do
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, devices} = CL11.get_device_ids(platform, :all)
    {:ok, context} = CL11.create_context(devices)
    {:ok, program} = CL11.create_program_with_source(context, @kernel_source)

    assert :ok == CL11.build_program(program, devices)
  end

  test "get_program_info" do
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, devices} = CL11.get_device_ids(platform, :all)
    {:ok, context} = CL11.create_context(devices)
    {:ok, program} = CL11.create_program_with_source(context, @kernel_source)

    {:ok, info} = CL11.get_program_info(program)
    assert Keyword.keyword?(info)
  end

  test "get_program_build_info" do
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, devices} = CL11.get_device_ids(platform, :all)
    {:ok, context} = CL11.create_context(devices)
    {:ok, program} = CL11.create_program_with_source(context, @kernel_source)
    CL11.build_program(program, devices)

    {:ok, info} = CL11.get_program_build_info(program, hd(devices))
    assert Keyword.keyword?(info)
  end

  ########################################
  # Kernel Objects
  ########################################

  test "create_kernel" do
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, devices} = CL11.get_device_ids(platform, :all)
    {:ok, context} = CL11.create_context(devices)
    {:ok, program} = CL11.create_program_with_source(context, @kernel_source)
    CL11.build_program(program, devices)

    {:ok, kernel} = CL11.create_kernel(program, 'HelloWorld')
    assert {:kernel_t, id, reference} = kernel
  end

  test "create_kernels_in_program" do
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, devices} = CL11.get_device_ids(platform, :all)
    {:ok, context} = CL11.create_context(devices)
    {:ok, program} = CL11.create_program_with_source(context, @kernel_source)
    CL11.build_program(program, devices)

    {:ok, kernels} = CL11.create_kernels_in_program(program)
    assert is_list(kernels)
  end

  test "retain_kernel" do
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, devices} = CL11.get_device_ids(platform, :all)
    {:ok, context} = CL11.create_context(devices)
    {:ok, program} = CL11.create_program_with_source(context, @kernel_source)
    CL11.build_program(program, devices)
    {:ok, kernel} = CL11.create_kernel(program, 'HelloWorld')

    assert :ok == CL11.retain_kernel(kernel)
  end

  test "release_kernel" do
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, devices} = CL11.get_device_ids(platform, :all)
    {:ok, context} = CL11.create_context(devices)
    {:ok, program} = CL11.create_program_with_source(context, @kernel_source)
    CL11.build_program(program, devices)
    {:ok, kernel} = CL11.create_kernel(program, 'HelloWorld')

    assert :ok == CL11.release_kernel(kernel)
  end

  test "set_kernel_arg" do
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, devices} = CL11.get_device_ids(platform, :all)
    {:ok, context} = CL11.create_context(devices)
    {:ok, program} = CL11.create_program_with_source(context, @kernel_source)
    CL11.build_program(program, devices)
    {:ok, kernel} = CL11.create_kernel(program, 'HelloWorld')
    {:ok, buffer} = CL11.create_buffer(context, [:read_write], 32)

    assert :ok == CL11.set_kernel_arg(kernel, 0, buffer)
  end

  test "get_kernel_info" do
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, devices} = CL11.get_device_ids(platform, :all)
    {:ok, context} = CL11.create_context(devices)
    {:ok, program} = CL11.create_program_with_source(context, @kernel_source)
    CL11.build_program(program, devices)
    {:ok, kernel} = CL11.create_kernel(program, 'HelloWorld')

    {:ok, info} = CL11.get_kernel_info(kernel)
    assert Keyword.keyword?(info)
  end

  test "get_kernel_workgroup_info" do
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, devices} = CL11.get_device_ids(platform, :all)
    {:ok, context} = CL11.create_context(devices)
    {:ok, program} = CL11.create_program_with_source(context, @kernel_source)
    CL11.build_program(program, devices)
    {:ok, kernel} = CL11.create_kernel(program, 'HelloWorld')

    {:ok, info} = CL11.get_kernel_workgroup_info(kernel, hd(devices))
    assert Keyword.keyword?(info)
  end

  ########################################
  # Executing Kernels
  ########################################

  test "enqueue_nd_range_kernel" do
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, devices} = CL11.get_device_ids(platform, :all)
    {:ok, context} = CL11.create_context(devices)
    {:ok, queue} = CL11.create_queue(context, hd(devices))
    {:ok, program} = CL11.create_program_with_source(context, @kernel_source)
    CL11.build_program(program, devices)
    {:ok, kernel} = CL11.create_kernel(program, 'HelloWorld')
    {:ok, buffer} = CL11.create_buffer(context, [:read_write], 32)
    CL11.set_kernel_arg(kernel, 0, buffer)

    {:ok, event} = CL11.enqueue_nd_range_kernel(queue, kernel, [1], [1], [])
    assert {:event_t, id, reference} = event
  end

  test "enqueue_task" do
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, devices} = CL11.get_device_ids(platform, :all)
    {:ok, context} = CL11.create_context(devices)
    {:ok, queue} = CL11.create_queue(context, hd(devices))
    {:ok, program} = CL11.create_program_with_source(context, @kernel_source)
    CL11.build_program(program, devices)
    {:ok, kernel} = CL11.create_kernel(program, 'HelloWorld')
    {:ok, buffer} = CL11.create_buffer(context, [:read_write], 32)
    CL11.set_kernel_arg(kernel, 0, buffer)

    {:ok, event} = CL11.enqueue_task(queue, kernel, [])
    assert {:event_t, id, reference} = event
  end

  ########################################
  # Event Objects
  ########################################

  test "wait_for_events" do
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, devices} = CL11.get_device_ids(platform, :all)
    {:ok, context} = CL11.create_context(devices)
    {:ok, queue} = CL11.create_queue(context, hd(devices))

    events = []
    {:ok, event} = CL11.enqueue_marker(queue)
    events = [event | events]
    {:ok, event} = CL11.enqueue_marker(queue)
    events = [event | events]

    assert is_list(CL11.wait_for_events(events))
  end

  test "get_event_info" do
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, devices} = CL11.get_device_ids(platform, :all)
    {:ok, context} = CL11.create_context(devices)
    {:ok, queue} = CL11.create_queue(context, hd(devices))
    {:ok, event} = CL11.enqueue_marker(queue)

    {:ok, info} = CL11.get_event_info(event)
    assert Keyword.keyword?(info)
  end

  test "retain_event" do
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, devices} = CL11.get_device_ids(platform, :all)
    {:ok, context} = CL11.create_context(devices)
    {:ok, queue} = CL11.create_queue(context, hd(devices))
    {:ok, event} = CL11.enqueue_marker(queue)

    assert :ok == CL11.retain_event(event)
  end

  test "release_event" do
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, devices} = CL11.get_device_ids(platform, :all)
    {:ok, context} = CL11.create_context(devices)
    {:ok, queue} = CL11.create_queue(context, hd(devices))
    {:ok, event} = CL11.enqueue_marker(queue)

    assert :ok == CL11.release_event(event)
  end

  ########################################
  # Execution of Kernels and Memory Object Commands
  ########################################

  test "enqueue_marker" do
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, devices} = CL11.get_device_ids(platform, :all)
    {:ok, context} = CL11.create_context(devices)
    {:ok, queue} = CL11.create_queue(context, hd(devices))

    {:ok, event} = CL11.enqueue_marker(queue)
    assert {:event_t, id, reference} = event
  end

  test "enqueue_wait_for_events" do
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, devices} = CL11.get_device_ids(platform, :all)
    {:ok, context} = CL11.create_context(devices)
    {:ok, queue} = CL11.create_queue(context, hd(devices))

    events = []
    {:ok, event} = CL11.enqueue_marker(queue)
    events = [event | events]
    {:ok, event} = CL11.enqueue_marker(queue)
    events = [event | events]

    assert :ok == CL11.enqueue_wait_for_events(queue, events)
  end

  test "enqueue_barrier" do
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, devices} = CL11.get_device_ids(platform, :all)
    {:ok, context} = CL11.create_context(devices)
    {:ok, queue} = CL11.create_queue(context, hd(devices))

    assert :ok == CL11.enqueue_barrier(queue)
  end

  ########################################
  # Flush and Finish
  ########################################

  test "flush" do
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, devices} = CL11.get_device_ids(platform, :all)
    {:ok, context} = CL11.create_context(devices)
    {:ok, queue} = CL11.create_queue(context, hd(devices))
    {:ok, _event} = CL11.enqueue_marker(queue)

    assert :ok == CL11.flush(queue)
  end

  test "finish" do
    {:ok, [platform | _]} = CL11.get_platform_ids()
    {:ok, devices} = CL11.get_device_ids(platform, :all)
    {:ok, context} = CL11.create_context(devices)
    {:ok, queue} = CL11.create_queue(context, hd(devices))
    {:ok, _event} = CL11.enqueue_marker(queue)

    assert :ok == CL11.finish(queue)
  end

end

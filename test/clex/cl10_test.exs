defmodule Clex.CL10Test do
  use ExUnit.Case
  #doctest Clex

  #  test "greets the world" do
  #    assert Clex.hello() == :world
  #  end

  alias Clex.CL10

  ########################################
  # Platform
  ########################################

  test "get_platform_ids" do
    {:ok, platforms} = CL10.get_platform_ids()
    assert is_list(platforms)
    assert {:platform_t, id, reference} = hd(platforms)
  end

  test "get_platform_info" do
    {:ok, [platform | _]} = CL10.get_platform_ids()
    {:ok, info} = CL10.get_platform_info(platform)
    assert Keyword.keyword?(info)
  end

  ########################################
  # Devices
  ########################################

  test "get_device_ids" do
    {:ok, [platform | _]} = CL10.get_platform_ids()
    {:ok, devices} = CL10.get_device_ids(platform, :all)
    assert is_list(devices)
    assert {:device_t, id, reference} = hd(devices)
  end

  test "get_device_info" do
    {:ok, [platform | _]} = CL10.get_platform_ids()
    {:ok, [device | _]} = CL10.get_device_ids(platform, :all)
    {:ok, info} = CL10.get_device_info(device)
    assert Keyword.keyword?(info)
  end

  ########################################
  # Context
  ########################################

  test "create_context" do
    {:ok, [platform | _]} = CL10.get_platform_ids()
    {:ok, devices} = CL10.get_device_ids(platform, :all)
    {:ok, context} = CL10.create_context(devices)
    assert {:context_t, id, reference} = context
  end

  test "create_context_from_type" do
    {:ok, context} = CL10.create_context_from_type(:all)
    assert {:context_t, id, reference} = context
  end

  test "release_context" do
    {:ok, context} = CL10.create_context_from_type(:all)
    assert :ok == CL10.release_context(context)
  end

  test "retain_context" do
    {:ok, context} = CL10.create_context_from_type(:all)
    assert :ok == CL10.retain_context(context)
  end

  test "get_context_info" do
    {:ok, context} = CL10.create_context_from_type(:all)
    {:ok, info} = CL10.get_context_info(context)
    assert Keyword.keyword?(info)
  end

  ########################################
  # Command Queue
  ########################################

  test "create_queue" do
    {:ok, [platform | _]} = CL10.get_platform_ids()
    {:ok, devices} = CL10.get_device_ids(platform, :all)
    {:ok, context} = CL10.create_context(devices)
    {:ok, queue} = CL10.create_queue(context, hd(devices))
    assert {:command_queue_t, id, reference} = queue
  end

  test "release_queue" do
    {:ok, [platform | _]} = CL10.get_platform_ids()
    {:ok, devices} = CL10.get_device_ids(platform, :all)
    {:ok, context} = CL10.create_context(devices)
    {:ok, queue} = CL10.create_queue(context, hd(devices))
    assert :ok == CL10.release_queue(queue)
  end

  test "retain_queue" do
    {:ok, [platform | _]} = CL10.get_platform_ids()
    {:ok, devices} = CL10.get_device_ids(platform, :all)
    {:ok, context} = CL10.create_context(devices)
    {:ok, queue} = CL10.create_queue(context, hd(devices))
    assert :ok == CL10.retain_queue(queue)
  end

  ########################################
  # Memory Object
  ########################################

  test "create_buffer without data" do
    size = 32
    {:ok, [platform | _]} = CL10.get_platform_ids()
    {:ok, devices} = CL10.get_device_ids(platform, :all)
    {:ok, context} = CL10.create_context(devices)

    {:ok, buffer} = CL10.create_buffer(context, [:read_write], size)
    assert {:mem_t, id, reference} = buffer
  end

  test "create_buffer with data" do
    size = 32
    value = <<0, 1, 2, 3>>
    {:ok, [platform | _]} = CL10.get_platform_ids()
    {:ok, devices} = CL10.get_device_ids(platform, :all)
    {:ok, context} = CL10.create_context(devices)

    {:ok, buffer} = CL10.create_buffer(context, [:read_write], size, value)
    assert {:mem_t, id, reference} = buffer
  end

  test "enqueue_read_buffer" do
    size = 32
    value = <<0, 1, 2, 3>>
    {:ok, [platform | _]} = CL10.get_platform_ids()
    {:ok, devices} = CL10.get_device_ids(platform, :all)
    {:ok, context} = CL10.create_context(devices)
    {:ok, queue} = CL10.create_queue(context, hd(devices))
    {:ok, buffer} = CL10.create_buffer(context, [:read_write], size, value)

    {:ok, event} = CL10.enqueue_read_buffer(queue, buffer, 0, size, [])
    assert {:event_t, id, reference} = event
  end

  test "enqueue_write_buffer" do
    size = 32
    value = <<0, 1, 2, 3>>
    {:ok, [platform | _]} = CL10.get_platform_ids()
    {:ok, devices} = CL10.get_device_ids(platform, :all)
    {:ok, context} = CL10.create_context(devices)
    {:ok, queue} = CL10.create_queue(context, hd(devices))
    {:ok, buffer} = CL10.create_buffer(context, [:read_write], size)

    {:ok, event} = CL10.enqueue_write_buffer(queue, buffer, 0, byte_size(value), value, [])
    assert {:event_t, id, reference} = event
  end

  test "retain_mem_object" do
    size = 32
    value = <<0, 1, 2, 3>>
    {:ok, [platform | _]} = CL10.get_platform_ids()
    {:ok, devices} = CL10.get_device_ids(platform, :all)
    {:ok, context} = CL10.create_context(devices)
    {:ok, buffer} = CL10.create_buffer(context, [:read_write], size, value)
    assert :ok == CL10.retain_mem_object(buffer)
  end

  test "release_mem_object" do
    size = 32
    value = <<0, 1, 2, 3>>
    {:ok, [platform | _]} = CL10.get_platform_ids()
    {:ok, devices} = CL10.get_device_ids(platform, :all)
    {:ok, context} = CL10.create_context(devices)
    {:ok, buffer} = CL10.create_buffer(context, [:read_write], size, value)
    assert :ok == CL10.release_mem_object(buffer)
  end

  test "get_mem_object_info" do
    {:ok, [platform | _]} = CL10.get_platform_ids()
    {:ok, devices} = CL10.get_device_ids(platform, :all)
    {:ok, context} = CL10.create_context(devices)
    {:ok, buffer} = CL10.create_buffer(context, [:read_write], 32, <<0, 1, 2, 3>>)

    {:ok, info} = CL10.get_mem_object_info(buffer)
    assert Keyword.keyword?(info)
  end

  ########################################
  # Program Objects
  ########################################

  test "create_program_with_source" do
    source = ~S"""
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
    {:ok, [platform | _]} = CL10.get_platform_ids()
    {:ok, devices} = CL10.get_device_ids(platform, :all)
    {:ok, context} = CL10.create_context(devices)

    {:ok, program} = CL10.create_program_with_source(context, source)
    assert {:program_t, id, reference} = program
  end

#  test "create_program_with_binary" do
#    flunk "TODO"
#  end

  test "retain_program" do
    source = ~S"""
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
    {:ok, [platform | _]} = CL10.get_platform_ids()
    {:ok, devices} = CL10.get_device_ids(platform, :all)
    {:ok, context} = CL10.create_context(devices)
    {:ok, program} = CL10.create_program_with_source(context, source)

    assert :ok == CL10.retain_program(program)
  end

  test "release_program" do
    source = ~S"""
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
    {:ok, [platform | _]} = CL10.get_platform_ids()
    {:ok, devices} = CL10.get_device_ids(platform, :all)
    {:ok, context} = CL10.create_context(devices)
    {:ok, program} = CL10.create_program_with_source(context, source)

    assert :ok == CL10.release_program(program)
  end

  test "unload_compiler" do
    assert :ok == CL10.unload_compiler()
  end

  test "build_program" do
    source = ~S"""
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
    {:ok, [platform | _]} = CL10.get_platform_ids()
    {:ok, devices} = CL10.get_device_ids(platform, :all)
    {:ok, context} = CL10.create_context(devices)
    {:ok, program} = CL10.create_program_with_source(context, source)

    assert :ok == CL10.build_program(program, devices)
  end

  test "get_program_info" do
    source = ~S"""
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
    {:ok, [platform | _]} = CL10.get_platform_ids()
    {:ok, devices} = CL10.get_device_ids(platform, :all)
    {:ok, context} = CL10.create_context(devices)
    {:ok, program} = CL10.create_program_with_source(context, source)

    {:ok, info} = CL10.get_program_info(program)
    assert Keyword.keyword?(info)
  end

  test "get_program_build_info" do
    source = ~S"""
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
    {:ok, [platform | _]} = CL10.get_platform_ids()
    {:ok, devices} = CL10.get_device_ids(platform, :all)
    {:ok, context} = CL10.create_context(devices)
    {:ok, program} = CL10.create_program_with_source(context, source)
    CL10.build_program(program, devices)

    {:ok, info} = CL10.get_program_build_info(program, hd(devices))
    assert Keyword.keyword?(info)
  end

  ########################################
  # Kernel Objects
  ########################################

  test "create_kernel" do
    source = ~S"""
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
    {:ok, [platform | _]} = CL10.get_platform_ids()
    {:ok, devices} = CL10.get_device_ids(platform, :all)
    {:ok, context} = CL10.create_context(devices)
    {:ok, program} = CL10.create_program_with_source(context, source)
    CL10.build_program(program, devices)

    {:ok, kernel} = CL10.create_kernel(program, 'HelloWorld')
    assert {:kernel_t, id, reference} = kernel
  end

  test "create_kernels_in_program" do
    source = ~S"""
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
    {:ok, [platform | _]} = CL10.get_platform_ids()
    {:ok, devices} = CL10.get_device_ids(platform, :all)
    {:ok, context} = CL10.create_context(devices)
    {:ok, program} = CL10.create_program_with_source(context, source)
    CL10.build_program(program, devices)

    {:ok, kernels} = CL10.create_kernels_in_program(program)
    assert is_list(kernels)
  end

  test "retain_kernel" do
    source = ~S"""
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
    {:ok, [platform | _]} = CL10.get_platform_ids()
    {:ok, devices} = CL10.get_device_ids(platform, :all)
    {:ok, context} = CL10.create_context(devices)
    {:ok, program} = CL10.create_program_with_source(context, source)
    CL10.build_program(program, devices)
    {:ok, kernel} = CL10.create_kernel(program, 'HelloWorld')

    assert :ok == CL10.retain_kernel(kernel)
  end

  test "release_kernel" do
    source = ~S"""
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
    {:ok, [platform | _]} = CL10.get_platform_ids()
    {:ok, devices} = CL10.get_device_ids(platform, :all)
    {:ok, context} = CL10.create_context(devices)
    {:ok, program} = CL10.create_program_with_source(context, source)
    CL10.build_program(program, devices)
    {:ok, kernel} = CL10.create_kernel(program, 'HelloWorld')

    assert :ok == CL10.release_kernel(kernel)
  end

  test "set_kernel_arg" do
    source = ~S"""
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
    {:ok, [platform | _]} = CL10.get_platform_ids()
    {:ok, devices} = CL10.get_device_ids(platform, :all)
    {:ok, context} = CL10.create_context(devices)
    {:ok, program} = CL10.create_program_with_source(context, source)
    CL10.build_program(program, devices)
    {:ok, kernel} = CL10.create_kernel(program, 'HelloWorld')
    {:ok, buffer} = CL10.create_buffer(context, [:read_write], 32)

    assert :ok == CL10.set_kernel_arg(kernel, 0, buffer)
  end

  test "get_kernel_info" do
    source = ~S"""
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
    {:ok, [platform | _]} = CL10.get_platform_ids()
    {:ok, devices} = CL10.get_device_ids(platform, :all)
    {:ok, context} = CL10.create_context(devices)
    {:ok, program} = CL10.create_program_with_source(context, source)
    CL10.build_program(program, devices)
    {:ok, kernel} = CL10.create_kernel(program, 'HelloWorld')

    {:ok, info} = CL10.get_kernel_info(kernel)
    assert Keyword.keyword?(info)
  end

  test "get_kernel_workgroup_info" do
    source = ~S"""
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
    {:ok, [platform | _]} = CL10.get_platform_ids()
    {:ok, devices} = CL10.get_device_ids(platform, :all)
    {:ok, context} = CL10.create_context(devices)
    {:ok, program} = CL10.create_program_with_source(context, source)
    CL10.build_program(program, devices)
    {:ok, kernel} = CL10.create_kernel(program, 'HelloWorld')

    {:ok, info} = CL10.get_kernel_workgroup_info(kernel, hd(devices))
    assert Keyword.keyword?(info)
  end

  ########################################
  # Executing Kernels
  ########################################

  test "enqueue_nd_range_kernel" do
    source = ~S"""
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
    {:ok, [platform | _]} = CL10.get_platform_ids()
    {:ok, devices} = CL10.get_device_ids(platform, :all)
    {:ok, context} = CL10.create_context(devices)
    {:ok, queue} = CL10.create_queue(context, hd(devices))
    {:ok, program} = CL10.create_program_with_source(context, source)
    CL10.build_program(program, devices)
    {:ok, kernel} = CL10.create_kernel(program, 'HelloWorld')
    {:ok, buffer} = CL10.create_buffer(context, [:read_write], 32)
    CL10.set_kernel_arg(kernel, 0, buffer)

    {:ok, event} = CL10.enqueue_nd_range_kernel(queue, kernel, [1], [1], [])
    assert {:event_t, id, reference} = event
  end

  test "enqueue_task" do
    source = ~S"""
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
    {:ok, [platform | _]} = CL10.get_platform_ids()
    {:ok, devices} = CL10.get_device_ids(platform, :all)
    {:ok, context} = CL10.create_context(devices)
    {:ok, queue} = CL10.create_queue(context, hd(devices))
    {:ok, program} = CL10.create_program_with_source(context, source)
    CL10.build_program(program, devices)
    {:ok, kernel} = CL10.create_kernel(program, 'HelloWorld')
    {:ok, buffer} = CL10.create_buffer(context, [:read_write], 32)
    CL10.set_kernel_arg(kernel, 0, buffer)

    {:ok, event} = CL10.enqueue_task(queue, kernel, [])
    assert {:event_t, id, reference} = event
  end

  ########################################
  # Event Objects
  ########################################

  test "wait_for_events" do
    {:ok, [platform | _]} = CL10.get_platform_ids()
    {:ok, devices} = CL10.get_device_ids(platform, :all)
    {:ok, context} = CL10.create_context(devices)
    {:ok, queue} = CL10.create_queue(context, hd(devices))

    events = []
    {:ok, event} = CL10.enqueue_marker(queue)
    events = [event | events]
    {:ok, event} = CL10.enqueue_marker(queue)
    events = [event | events]

    assert is_list(CL10.wait_for_events(events))
  end

  test "get_event_info" do
    {:ok, [platform | _]} = CL10.get_platform_ids()
    {:ok, devices} = CL10.get_device_ids(platform, :all)
    {:ok, context} = CL10.create_context(devices)
    {:ok, queue} = CL10.create_queue(context, hd(devices))
    {:ok, event} = CL10.enqueue_marker(queue)

    {:ok, info} = CL10.get_event_info(event)
    assert Keyword.keyword?(info)
  end

  test "retain_event" do
    {:ok, [platform | _]} = CL10.get_platform_ids()
    {:ok, devices} = CL10.get_device_ids(platform, :all)
    {:ok, context} = CL10.create_context(devices)
    {:ok, queue} = CL10.create_queue(context, hd(devices))
    {:ok, event} = CL10.enqueue_marker(queue)

    assert :ok == CL10.retain_event(event)
  end

  test "release_event" do
    {:ok, [platform | _]} = CL10.get_platform_ids()
    {:ok, devices} = CL10.get_device_ids(platform, :all)
    {:ok, context} = CL10.create_context(devices)
    {:ok, queue} = CL10.create_queue(context, hd(devices))
    {:ok, event} = CL10.enqueue_marker(queue)

    assert :ok == CL10.release_event(event)
  end

  ########################################
  # Execution of Kernels and Memory Object Commands
  ########################################

  test "enqueue_marker" do
    {:ok, [platform | _]} = CL10.get_platform_ids()
    {:ok, devices} = CL10.get_device_ids(platform, :all)
    {:ok, context} = CL10.create_context(devices)
    {:ok, queue} = CL10.create_queue(context, hd(devices))

    {:ok, event} = CL10.enqueue_marker(queue)
    assert {:event_t, id, reference} = event
  end

  test "enqueue_wait_for_events" do
    {:ok, [platform | _]} = CL10.get_platform_ids()
    {:ok, devices} = CL10.get_device_ids(platform, :all)
    {:ok, context} = CL10.create_context(devices)
    {:ok, queue} = CL10.create_queue(context, hd(devices))

    events = []
    {:ok, event} = CL10.enqueue_marker(queue)
    events = [event | events]
    {:ok, event} = CL10.enqueue_marker(queue)
    events = [event | events]

    assert :ok == CL10.enqueue_wait_for_events(queue, events)
  end

  test "enqueue_barrier" do
    {:ok, [platform | _]} = CL10.get_platform_ids()
    {:ok, devices} = CL10.get_device_ids(platform, :all)
    {:ok, context} = CL10.create_context(devices)
    {:ok, queue} = CL10.create_queue(context, hd(devices))

    assert :ok == CL10.enqueue_barrier(queue)
  end

  ########################################
  # Flush and Finish
  ########################################

  test "flush" do
    {:ok, [platform | _]} = CL10.get_platform_ids()
    {:ok, devices} = CL10.get_device_ids(platform, :all)
    {:ok, context} = CL10.create_context(devices)
    {:ok, queue} = CL10.create_queue(context, hd(devices))
    {:ok, _event} = CL10.enqueue_marker(queue)

    assert :ok == CL10.flush(queue)
  end

  test "finish" do
    {:ok, [platform | _]} = CL10.get_platform_ids()
    {:ok, devices} = CL10.get_device_ids(platform, :all)
    {:ok, context} = CL10.create_context(devices)
    {:ok, queue} = CL10.create_queue(context, hd(devices))
    {:ok, _event} = CL10.enqueue_marker(queue)

    assert :ok == CL10.finish(queue)
  end

end

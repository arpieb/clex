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
    {:ok, [platform | _]} = CL10.get_platform_ids()
    {:ok, devices} = CL10.get_device_ids(platform, :all)
    {:ok, context} = CL10.create_context(devices)

    {:ok, buffer} = CL10.create_buffer(context, [:read_write], 32)
    assert {:mem_t, id, reference} = buffer
  end

  test "create_buffer with data" do
    {:ok, [platform | _]} = CL10.get_platform_ids()
    {:ok, devices} = CL10.get_device_ids(platform, :all)
    {:ok, context} = CL10.create_context(devices)

    {:ok, buffer} = CL10.create_buffer(context, [:read_write], 32, "abc123")
    assert {:mem_t, id, reference} = buffer
  end

  test "enqueue_read_buffer" do
    flunk "TODO"
  end

  test "enqueue_write_buffer" do
    flunk "TODO"
  end

  test "retain_mem_object" do
    {:ok, [platform | _]} = CL10.get_platform_ids()
    {:ok, devices} = CL10.get_device_ids(platform, :all)
    {:ok, context} = CL10.create_context(devices)
    {:ok, buffer} = CL10.create_buffer(context, [:read_write], 32, "abc123")
    assert :ok == CL10.retain_mem_object(buffer)
  end

  test "release_mem_object" do
    {:ok, [platform | _]} = CL10.get_platform_ids()
    {:ok, devices} = CL10.get_device_ids(platform, :all)
    {:ok, context} = CL10.create_context(devices)
    {:ok, buffer} = CL10.create_buffer(context, [:read_write], 32, "abc123")
    assert :ok == CL10.release_mem_object(buffer)
  end

  test "enqueue_map_buffer" do
    flunk "TODO"
  end

  test "enqueue_unmap_mem_object" do
    flunk "TODO"
  end

  test "get_mem_object_info" do
    {:ok, [platform | _]} = CL10.get_platform_ids()
    {:ok, devices} = CL10.get_device_ids(platform, :all)
    {:ok, context} = CL10.create_context(devices)
    {:ok, buffer} = CL10.create_buffer(context, [:read_write], 32, "abc123")

    {:ok, info} = CL10.get_mem_object_info(buffer)
    assert Keyword.keyword?(info)
  end

end

defmodule MemTest do
  use ExUnit.Case
  doctest Mem

  test "new Memory Manager" do
    assert Mem.manager(0, 5) == %{:start_pos => 0, :end_pos => 4,
      :allocations => %{}}
  end

  test "can allocate memory" do
    assert Mem.manager(0, 5)
      |> Mem.alloc(3) == %{:start_pos => 0, :end_pos => 4,
        :allocations => %{0 => 3}}
    end

  test "can free memory" do
    assert Mem.manager(0, 5)
      |> Mem.alloc(3)
      |> Mem.free(0) == %{:start_pos => 0, :end_pos => 4,
        :allocations => %{}}
  end

  test "cannot allocate memory larger than buffer size" do
    assert_raise MemoryError, "not enough available memory", fn ->
      Mem.manager(0, 5) |> Mem.alloc(6) end
  end

  test "cannot free unallocated memory" do
    assert_raise RuntimeError, "tried to free unallocated memory", fn ->
      Mem.manager(0, 5) |> Mem.free(0)
    end
  end

  test "finds a suitable memory address in partially allocated buffer" do
    assert Mem.manager(0, 5)
      |> Mem.alloc(3)
      |> Mem.find_suitable_memory_address(2) == 3
  end

  test "correctly allocates memory if partially allocated buffer" do
    assert Mem.manager(0, 5)
      |> Mem.alloc(3)
      |> Mem.alloc(2) == %{:start_pos => 0, :end_pos => 4,
        :allocations => %{0 => 3, 3 => 2}}
  end

  test "doesn't allocate memory in buffer that can't accommodate" do
    assert_raise MemoryError, "not enough available memory", fn ->
      Mem.manager(0, 5)
        |> Mem.alloc(3)
        |> Mem.alloc(3)
      end
  end
end

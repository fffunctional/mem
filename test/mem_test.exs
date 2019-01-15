defmodule MemTest do
  use ExUnit.Case
  doctest Mem

  test "greets the world" do
    assert Mem.hello() == :world
  end

  test "new Memory Manager" do
    assert Mem.manager(0, 5) == %{:start_pos => 0, :end_pos => 4,
      :allocations => %{}}
  end

  test "can allocate memory" do
    assert Mem.manager(0, 5)
      |> Mem.alloc(3) == %{:start_pos => 0, :end_pos => 4,
        :allocations => %{0 => 3}}
    end
end

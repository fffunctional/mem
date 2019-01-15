defmodule MemTest do
  use ExUnit.Case
  doctest Mem

  test "greets the world" do
    assert Mem.hello() == :world
  end

  test "new Memory Manager" do
    assert Mem.manager(0, 5) == %{0 => 0, 1 => 0, 2 => 0, 3 => 0, 4 => 0}
  end

  test "can allocate memory" do
    assert Mem.manager(0, 5)
      |> Mem.alloc(3) == %{0 => 1, 1 => 1, 2 => 1, 3 => 0, 4 => 0}
    end  
end

defmodule MemoryError do
  defexception message: "not enough available memory"
end

defmodule Mem do
  @moduledoc """
  Documentation for Mem.
  """

  @doc """
  Returns a new 'chunk of contiguous memory' starting at memory address
  start_pos and taking up num_bytes of memory.
  """
  def manager(buffer, num_bytes) do
    end_pos = buffer + num_bytes - 1
    %{:start_pos => buffer, :end_pos => end_pos, :allocations => %{}}
  end

  @doc """
  Given a 'chunk of memory' finds the first available chunk of sufficient
  size and allocates it
  """
  def alloc(manager, size) do
    cond do
      size > manager.end_pos - manager.start_pos -> raise MemoryError
      manager.allocations == %{} ->
        Map.update!(manager, :allocations, &(Map.put(&1, 0, size)))
      true -> raise "allocations not empty" #use find_suitable_memory_address
    end
  end

  @doc """
  Returns the first available memory address than begins a consecutive range
  of unused memory slots of at least the passed-in size
  """
  def find_suitable_memory_address(manager, size) do
    # We need a block of contiguous free memory addresses of size n.
    # each entry in the manager's current allocations blocks out areas of memory.
    # we could start at [manager.start_pos] and see if any allocation's pointer
    # is smaller than [start_pos+size-1]. If so, move forward to the end of that
    # allocation (by usings its size), and see if any allocation's pointer is
    # smaller than [new_pos+size-1]. And so on until we reach a suitable address
    # with available space from it (in which case return this), or exceed the
    # buffer size (in which case raise a MemoryError).
    #
    # If the number of non-contiguous available memory slots is larger than the
    # size but there is not suitable consecutive range, could we move things around
    # to utilize space better? This seems like it might be... advanced.
  end

  @doc """
  Given a memory manager and a 'pointer', de-allocates the memory at that pointer
  """
  def free(manager, pointer) do
    cond do
      not Map.has_key?(manager.allocations, pointer) -> raise "tried to free unallocated memory"
      true -> Map.update!(manager, :allocations, &(Map.delete(&1, pointer)))
    end
  end
end

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
        # this should ultimately be achievable using the find_sm_address function
        Map.update!(manager, :allocations, &(Map.put(&1, 0, size)))
      true ->
        addr = find_suitable_memory_address(manager, size)
        Map.update!(manager, :allocations, &(Map.put(&1, addr, size)))
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
    #
    # ETA: working on the algorithm. First n in the
    # range [mem.mgr.start_pos..mem.mgr.end_pos] where n+size is not
    # >= any key in the mem.mgr.allocations that is >n, and n is not <
    # (the first key in the mem.mgr.allocations that is smaller than it
    # plus the size of that allocation)?

     case manager.start_pos..manager.end_pos
      |> Enum.find(fn n ->

        n |> alloc_end_does_not_overwrite(manager, size) &&
        n |> alloc_start_does_not_overwrite(manager) &&
        n |> no_buffer_overflow(manager, size)

      end) do
        nil -> raise MemoryError
        n   -> n
      end
  end

  defp alloc_end_does_not_overwrite(n, manager, size) do
    Enum.all?(Map.keys(manager.allocations), fn addr ->
      (n + size < addr) || (addr < n)
    end)
  end

  defp alloc_start_does_not_overwrite(n, manager) do
    n >= Enum.find(Map.keys(manager.allocations), fn addr ->
      n > addr + Map.get(manager.allocations, addr) - 1
    end)
  end

  defp no_buffer_overflow(n, manager, size) do
    n + size - 1 <= manager.end_pos
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

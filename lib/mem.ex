defmodule MemoryError do
  defexception message: "not enough available memory"
end

defmodule Mem do
  @moduledoc """
  Documentation for Mem.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Mem.hello()
      :world

  """
  def hello do
    :world
  end

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
      true -> raise "allocations not empty"
    end
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

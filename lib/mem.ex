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
      manager.allocations == %{} ->
        Map.update!(manager, :allocations, fn current -> Map.put(current, 0, size) end)
      true -> raise "allocations not empty"
    end
  end
end

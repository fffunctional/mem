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
  def manager(start_pos, num_bytes) do
    end_pos = start_pos + num_bytes - 1
    start_pos..end_pos
      |> Enum.reduce(%{}, fn addr, acc -> Map.put(acc, addr, 0) end)
  end

  @doc """
  Given a 'chunk of memory' finds the first available chunk of sufficient
  size and allocates it 
  """
  def alloc(size) do
  end
end

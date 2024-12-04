defmodule Utils do

  @spec to_int(binary()) :: integer()
  def to_int(int) do
    String.to_integer(int)
  end
end

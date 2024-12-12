defmodule IncMap do
  use Agent

  def start() do
    Agent.start_link(fn-> %{}end)
  end

  def get(agent, value) do
    Agent.get(agent, &Map.get(&1, value, 0))
  end
  def increment(agent, k) do
    val = get(agent, k)
    Agent.update(agent, &Map.put(&1, k, val+1))
  end

  def map_value_sum(agent) do
    map_keys = Agent.get(agent,  &Map.keys/1)
    Enum.reduce(map_keys, 0, fn key, acc ->
      acc+get(agent, key)
    end)
  end

end

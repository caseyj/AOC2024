defmodule KV do
  use Agent

  def start() do
    Agent.start_link(fn -> %{} end)
  end

  def get(agent, value) do
    Agent.get(agent, &Map.get(&1, value, nil))
  end

  def put(agent, k, v) do
    Agent.update(agent, &Map.put(&1, k, v))
  end

  def print(agent) do
    IO.inspect(Agent.get(agent, & &1))
  end
end

defmodule RequestStub do
  @moduledoc false

  def start_link(_opts) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def get(url, _params \\ %{}, _options \\ []) do
    Agent.get(__MODULE__, &Map.get(&1, {:get, url}, :ok))
  end

  def post(url, _body, _options \\ []) do
    Agent.get(__MODULE__, &Map.get(&1, {:post, url}, :ok))
  end

  def set_response(method, url, response) do
    Agent.update(__MODULE__, &Map.put(&1, {method, url}, response))
  end
end

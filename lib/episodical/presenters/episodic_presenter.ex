defmodule Episodical.Presenters.Episodic do
  alias __MODULE__

  @enforce_keys [:episodic]
  defstruct [:seasons, :episodic, :genres]

  def present(%Episodic{} = input) do
    input
      |> populate_seasons(input)
  end

  defp populate_seasons(%Episodic{} = episodic, %Episodic{episodic: %{episodes: []}}), do: episodic
  defp populate_seasons(%Episodic{} = episodic, %Episodic{episodic: %{episodes: [head | tail]}}) do
    # Add the Season Number key with a list including this episode to the map and recurse
    seasons = episodic.seasons
      |> Map.update(head.season, [head], fn x -> [head | x] end)

    episodic
      |> Map.update!(:seasons, fn x -> Map.merge(x, seasons) end)
      |> populate_seasons(%Episodic{episodic: %{episodes: tail}})
  end
end

defmodule Episodical.ProvidersTest do
  use Episodical.DataCase

  describe "ProviderSearchResults.from_thetvdb" do
    alias Episodical.Presenters.ProviderSearchResults

    test "will generate an empty list with no results" do
      input = %ProviderSearchResults{
        service_type: "thetvdb",
        results: []
      }

      assert {:ok, []} = ProviderSearchResults.from_thetvdb(input)
    end

    test "will generate a list of results with some data" do
      input = %ProviderSearchResults{
        service_type: "thetvdb",
        results: [
          %{
            "name" => "first",
            "first_air_time" => "2020-10-10",
            "overview" => "some overview information",
            "tvdb_id" => 666
          },
          %{
            "name" => "second",
            "first_air_time" => "2021-03-06",
            "overview" => "another overview block",
            "tvdb_id" => 333
          }
        ]
      }

      assert {:ok, results} = ProviderSearchResults.from_thetvdb(input)
      assert length(results) == 2
    end

    test "will provide an error tuple for the wrong service type" do
      input = %ProviderSearchResults{
        service_type: "invalid",
        results: []
      }

      assert {:error, "Invalid results for presenting"} =
               ProviderSearchResults.from_thetvdb(input)
    end
  end

  describe "Episodic.basic" do
    alias Episodical.Presenters.Episodic

    test "will generate an empty episode list with no episodes found" do
      input = %Episodic{episodic: gen_episodic(0)}
      output = Episodic.basic(input)

      assert output.episode_metadata.total_episode_count == 0
    end

    test "will generate a list of episodes with some data" do
      input = %Episodic{episodic: gen_episodic(5)}
      output = Episodic.basic(input)

      assert output.episode_metadata.total_episode_count == 5
    end
  end

  describe "Episodic.present" do
    alias Episodical.Presenters.Episodic

    test "without any episodes" do
      input = %Episodic{episodic: gen_episodic(0)}
      output = Episodic.present(input)

      assert output.seasons == []
    end

    test "with episodes in a single season" do
      input = %Episodic{episodic: gen_episodic(1), episode_metadata: %{}, seasons: %{}}
      output = Episodic.present(input)

      assert length(output.seasons) == 1
    end

    test "with many episodes in many seasons" do
      input = %Episodic{episodic: gen_episodic(3), episode_metadata: %{}, seasons: %{}}
      output = Episodic.present(input)

      assert length(output.seasons) == 3
    end
  end

  defp gen_episodic(episode_count) do
    %Episodical.Model.Episodic{
      title: "first",
      episodes: add_ep([], episode_count),
      status: "continuing"
    }
  end

  defp add_ep(eps, 0), do: eps

  defp add_ep(eps, episode_count) do
    ep = %Episodical.Model.Episodic.Episode{
      index: episode_count,
      title: "Episode #{episode_count}",
      season: episode_count
    }

    add_ep([ep | eps], episode_count - 1)
  end
end

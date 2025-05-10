defmodule Episodical.Model.EpisodicTest do
  use Episodical.DataCase

  alias Episodical.Model.Episodic
  alias Episodical.Repo

  import Episodical.ExternalFixtures
  import Episodical.LocalFixtures
  import Episodical.ModelFixtures

  @genres_input [
    %{
      external_id: "abc-123",
      genre: "first"
    },
    %{
      external_id: "xyz-456",
      genre: "second"
    },
    %{
      external_id: "sdf-789",
      genre: "third"
    }
  ]
  @episodes_input [
    %{
      external_id: "tt-456",
      title: "episode 1",
      season: 1
    },
    %{
      external_id: "tt-123",
      title: "episode 2",
      season: 1
    }
  ]

  describe "#insert_and_get_all_genres" do
    setup [:setup_data]

    test "retrieves upserted genres from input", %{episodic: episodic} do
      {:ok, result_set} =
        Episodic.full_changeset(episodic, %{
          genres: @genres_input,
          episodes: []
        })
        |> Repo.update()

      assert length(result_set.genres) == 3
    end

    test "doesn't change the times when genres are pre-existing", %{episodic: episodic} do
      _ = episodic
    end
  end

  describe "#insert_and_get_all_episodes" do
    setup [:setup_data]

    test "retrieves upserted episodes from input", %{episodic: episodic} do
      {:ok, result_set} =
        Episodic.full_changeset(episodic, %{
          genres: [],
          episodes: @episodes_input
        })
        |> Repo.update()

      assert length(result_set.episodes) == 2
    end
  end

  describe "#assoc_path" do
    setup [:setup_data]

    test "a path can be associated with an episodic", %{episodic: episodic} do
      path = path_fixture()

      got = Episodic.assoc_path(episodic, path)

      assert true = got.valid?
      assert 0 == length(got.errors)
    end
  end

  defp setup_data(_) do
    token = token_fixture() |> Repo.preload([:provider])

    episodic =
      episodic_fixture(provider_id: token.provider.id)
      |> Repo.preload([:provider, :episodes, :genres, :path])

    %{episodic: episodic, provider: token.provider}
  end
end

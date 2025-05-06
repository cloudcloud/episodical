defmodule Episodical.Model.EpisodicTest do
  use Episodical.DataCase

  alias Episodical.Model.Episodic
  alias Episodical.Repo

  import Episodical.ExternalFixtures
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
  @genres_bad_input []

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

    test "doesn't change the times when genres are pre-existing" do
      #
    end
  end

  defp setup_data(_) do
    token = token_fixture() |> Repo.preload([:provider])

    episodic =
      episodic_fixture(provider_id: token.provider.id)
      |> Repo.preload([:provider, :episodes, :genres])

    %{episodic: episodic, provider: token.provider}
  end
end

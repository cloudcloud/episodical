defmodule Episodical.Workers.EpisodicalUpdateTest do
  use Episodical.DataCase

  alias Episodical.Repo
  alias Episodical.Model.Config
  alias Episodical.Workers.EpisodicalUpdate

  import Episodical.ExternalFixtures
  import Episodical.ModelFixtures

  describe "the happy path" do
    setup [:setup_data]

    test "will retrieve some data and store it associated", %{
      episodic: episodic
    } do
      input = %{"id" => episodic.id}

      assert {:ok, ep, files_found} = EpisodicalUpdate.perform(input)
      assert ep.id == episodic.id
      assert files_found == []
    end
  end

  defp setup_data(_) do
    token = token_fixture() |> Repo.preload([:provider])
    episodic = episodic_fixture(provider_id: token.provider.id) |> Repo.preload([:provider])

    config = [
      %{
        name: "episodical_language",
        value: "eng",
        is_active: true
      },
      %{
        name: "episodic_filename_pattern",
        value: ".+\\.S(\\d+)E(\\d+)\\.([a-z0-9]+)",
        is_active: true
      },
      %{
        name: "episodic_path_layout",
        value: ":upper_word_title/:upper_word_season/:files",
        is_active: true
      }
    ]

    config
    |> Enum.each(fn data ->
      Repo.insert!(%Config{
        name: data[:name],
        value: data[:value],
        is_active: data[:is_active]
      })
    end)

    RequestStub.set_response(
      :get,
      "https://api4.thetvdb.com/v4/series/#{episodic.external_id}/extended?meta=episodes&short=true",
      {:ok,
       %{
         status_code: 200,
         body:
           %{
             status: "success",
             data: %{
               id: episodic.external_id,
               remoteIds: [
                 %{
                   sourceName: "IMDB",
                   id: "tt666"
                 }
               ],
               image: "https://example.com/img.png",
               status: %{
                 name: "continuing"
               },
               nextAired: "2025-07-19",
               overview: "This is the overview",
               originalLanguage: "eng",
               genres: [
                 #
               ],
               episodes: [
                 #
               ]
             }
           }
           |> Jason.encode!()
       }}
    )

    %{episodic: episodic, provider: token.provider}
  end
end

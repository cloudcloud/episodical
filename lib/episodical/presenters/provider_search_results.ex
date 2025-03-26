defmodule Episodical.Presenters.ProviderSearchResults do
  alias __MODULE__
  alias Episodical.External.Provider.TheTVDB

  @enforce_keys [:service_type, :results]
  defstruct [:service_type, :results]

  @type t :: %__MODULE__{
              service_type: String.t(),
              results: list(),
            }

  @doc """
  Present the results from TheTVDB API call in a way that's easier to consume and
  use for selection via the UI.
  """
  @spec from_thetvdb(ProviderSearchResults.t()) :: {:ok, ProviderSearchResults.t()} | {:error, String.t()}
  def from_thetvdb(%ProviderSearchResults{} = input) do
    if input.service_type != TheTVDB.service_type? do
      {:error, "Invalid results for presenting"}
    else
      IO.inspect {:ok, Enum.map(input.results, fn x -> %{
        "name" => x["name"],
        "date_began" => x["first_air_time"],
        "overview" => x["overview"],
        "id" => x["tvdb_id"],
      } end)}
    end
  end
end

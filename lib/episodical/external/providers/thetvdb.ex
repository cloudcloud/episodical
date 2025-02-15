defmodule Episodical.External.Provider.TheTVDB do
  @doc """
  For a given model type, is this provider valid for it?
  """
  @spec valid_for?(String.t()) :: boolean()
  def valid_for?("episodic"), do: true
  def valid_for?(_), do: false
end

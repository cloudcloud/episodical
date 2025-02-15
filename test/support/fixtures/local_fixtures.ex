defmodule Episodical.LocalFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Episodical.Local` context.
  """

  @doc """
  Generate a path.
  """
  def path_fixture(attrs \\ %{}) do
    {:ok, path} =
      attrs
      |> Enum.into(%{
        last_checked_at: ~U[2025-02-07 22:58:00.000000Z],
        name: "some name",
        should_auto_check: true
      })
      |> Episodical.Local.create_path()

    path
  end

  @doc """
  Generate a file.
  """
  def file_fixture(attrs \\ %{}) do
    {:ok, file} =
      attrs
      |> Enum.into(%{
        last_checked_at: ~U[2025-02-07 22:58:00.000000Z],
        name: "some name"
      })
      |> Episodical.Local.create_file()

    file
  end
end

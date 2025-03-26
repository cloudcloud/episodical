defmodule Episodical.AuditFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Episodical.Audit` context.
  """

  @doc """
  Generate a log.
  """
  def log_fixture(attrs \\ %{}) do
    {:ok, log} =
      attrs
      |> Enum.into(%{
        action_taken: "some action_taken",
        debug: "some debug",
        entity_id: "some entity_id",
        entity_type: "some entity_type",
        was_success: true
      })
      |> Episodical.Audit.create_log()

    log
  end

  @doc """
  Generate a event.
  """
  def event_fixture(attrs \\ %{}) do
    {:ok, event} =
      attrs
      |> Enum.into(%{
        action_taken: "some action_taken",
        debug: "some debug",
        entity_id: "some entity_id",
        entity_type: "some entity_type",
        was_manual: true
      })
      |> Episodical.Audit.create_event()

    event
  end
end

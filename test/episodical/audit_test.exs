defmodule Episodical.AuditTest do
  use Episodical.DataCase

  alias Episodical.Audit

  describe "logs" do
    alias Episodical.Audit.Log

    import Episodical.AuditFixtures

    @invalid_attrs %{debug: nil, action_taken: nil, entity_id: nil, entity_type: nil, was_success: nil}

    test "list_logs/0 returns all logs" do
      log = log_fixture()
      assert Audit.list_logs() == [log]
    end

    test "get_log!/1 returns the log with given id" do
      log = log_fixture()
      assert Audit.get_log!(log.id) == log
    end

    test "create_log/1 with valid data creates a log" do
      valid_attrs = %{debug: "some debug", action_taken: "some action_taken", entity_id: "some entity_id", entity_type: "some entity_type", was_success: true}

      assert {:ok, %Log{} = log} = Audit.create_log(valid_attrs)
      assert log.debug == "some debug"
      assert log.action_taken == "some action_taken"
      assert log.entity_id == "some entity_id"
      assert log.entity_type == "some entity_type"
      assert log.was_success == true
    end

    test "create_log/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Audit.create_log(@invalid_attrs)
    end

    test "update_log/2 with valid data updates the log" do
      log = log_fixture()
      update_attrs = %{debug: "some updated debug", action_taken: "some updated action_taken", entity_id: "some updated entity_id", entity_type: "some updated entity_type", was_success: false}

      assert {:ok, %Log{} = log} = Audit.update_log(log, update_attrs)
      assert log.debug == "some updated debug"
      assert log.action_taken == "some updated action_taken"
      assert log.entity_id == "some updated entity_id"
      assert log.entity_type == "some updated entity_type"
      assert log.was_success == false
    end

    test "update_log/2 with invalid data returns error changeset" do
      log = log_fixture()
      assert {:error, %Ecto.Changeset{}} = Audit.update_log(log, @invalid_attrs)
      assert log == Audit.get_log!(log.id)
    end

    test "delete_log/1 deletes the log" do
      log = log_fixture()
      assert {:ok, %Log{}} = Audit.delete_log(log)
      assert_raise Ecto.NoResultsError, fn -> Audit.get_log!(log.id) end
    end

    test "change_log/1 returns a log changeset" do
      log = log_fixture()
      assert %Ecto.Changeset{} = Audit.change_log(log)
    end
  end

  describe "events" do
    alias Episodical.Audit.Event

    import Episodical.AuditFixtures

    @invalid_attrs %{debug: nil, action_taken: nil, entity_id: nil, entity_type: nil, was_manual: nil}

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Audit.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Audit.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      valid_attrs = %{debug: "some debug", action_taken: "some action_taken", entity_id: "some entity_id", entity_type: "some entity_type", was_manual: true}

      assert {:ok, %Event{} = event} = Audit.create_event(valid_attrs)
      assert event.debug == "some debug"
      assert event.action_taken == "some action_taken"
      assert event.entity_id == "some entity_id"
      assert event.entity_type == "some entity_type"
      assert event.was_manual == true
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Audit.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      update_attrs = %{debug: "some updated debug", action_taken: "some updated action_taken", entity_id: "some updated entity_id", entity_type: "some updated entity_type", was_manual: false}

      assert {:ok, %Event{} = event} = Audit.update_event(event, update_attrs)
      assert event.debug == "some updated debug"
      assert event.action_taken == "some updated action_taken"
      assert event.entity_id == "some updated entity_id"
      assert event.entity_type == "some updated entity_type"
      assert event.was_manual == false
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Audit.update_event(event, @invalid_attrs)
      assert event == Audit.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Audit.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Audit.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Audit.change_event(event)
    end
  end
end

defmodule Episodical.LocalTest do
  use Episodical.DataCase

  alias Episodical.Local

  describe "paths" do
    alias Episodical.Local.Path

    import Episodical.LocalFixtures

    @invalid_attrs %{name: nil, last_checked_at: nil, should_auto_check: nil}

    test "list_paths/0 returns all paths" do
      path = path_fixture()
      assert Local.list_paths() == [path]
    end

    test "get_path!/1 returns the path with given id" do
      path = path_fixture()
      assert Local.get_path!(path.id) == path
    end

    test "create_path/1 with valid data creates a path" do
      valid_attrs = %{name: "some name", last_checked_at: ~U[2025-02-07 22:58:00.000000Z], should_auto_check: true}

      assert {:ok, %Path{} = path} = Local.create_path(valid_attrs)
      assert path.name == "some name"
      assert path.last_checked_at == ~U[2025-02-07 22:58:00.000000Z]
      assert path.should_auto_check == true
    end

    test "create_path/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Local.create_path(@invalid_attrs)
    end

    test "update_path/2 with valid data updates the path" do
      path = path_fixture()
      update_attrs = %{name: "some updated name", last_checked_at: ~U[2025-02-08 22:58:00.000000Z], should_auto_check: false}

      assert {:ok, %Path{} = path} = Local.update_path(path, update_attrs)
      assert path.name == "some updated name"
      assert path.last_checked_at == ~U[2025-02-08 22:58:00.000000Z]
      assert path.should_auto_check == false
    end

    test "update_path/2 with invalid data returns error changeset" do
      path = path_fixture()
      assert {:error, %Ecto.Changeset{}} = Local.update_path(path, @invalid_attrs)
      assert path == Local.get_path!(path.id)
    end

    test "delete_path/1 deletes the path" do
      path = path_fixture()
      assert {:ok, %Path{}} = Local.delete_path(path)
      assert_raise Ecto.NoResultsError, fn -> Local.get_path!(path.id) end
    end

    test "change_path/1 returns a path changeset" do
      path = path_fixture()
      assert %Ecto.Changeset{} = Local.change_path(path)
    end
  end

  describe "files" do
    alias Episodical.Local.File

    import Episodical.LocalFixtures
    import Episodical.ModelFixtures

    @invalid_attrs %{name: nil, last_checked_at: nil}

    test "list_files/0 returns all files" do
      file = file_fixture()
      assert Local.list_files() == [file]
    end

    test "get_file!/1 returns the file with given id" do
      file = file_fixture()
      assert Local.get_file!(file.id) |> Episodical.Repo.preload([:episodic, :episode, :path]) == file
    end

    test "create_file/1 with valid data creates a file" do
      valid_attrs = %{name: "some name", last_checked_at: ~U[2025-02-07 22:58:00.000000Z]}

      assert {:ok, %File{} = file} = Local.create_file(valid_attrs)
      assert file.name == "some name"
      assert file.last_checked_at == ~U[2025-02-07 22:58:00.000000Z]
    end

    test "create_file/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Local.create_file(@invalid_attrs)
    end

    test "update_file/2 with valid data updates the file" do
      episode = episode_fixture()
      file = file_fixture()

      update_attrs = %{
        name: "some updated name",
        last_checked_at: ~U[2025-02-08 22:58:00.000000Z],
        episode: episode,
        path: file.path
      }

      assert {:ok, %File{} = file} = Local.update_file(file, update_attrs)
      assert file.name == "some updated name"
      assert file.last_checked_at == ~U[2025-02-08 22:58:00.000000Z]
    end

    test "update_file/2 with invalid data returns error changeset" do
      file = file_fixture()
      assert {:error, %Ecto.Changeset{}} = Local.update_file(file, @invalid_attrs)

      new_file = Local.get_file!(file.id) |> Episodical.Repo.preload([:episodic, :episode, :path])
      assert file == new_file
    end

    test "delete_file/1 deletes the file" do
      file = file_fixture()
      assert {:ok, %File{}} = Local.delete_file(file)
      assert_raise Ecto.NoResultsError, fn -> Local.get_file!(file.id) end
    end

    test "change_file/1 returns a file changeset" do
      file = file_fixture()
      assert %Ecto.Changeset{} = Local.change_file(file)
    end
  end
end

defmodule Episodical.LocalTest do
  use Episodical.DataCase

  alias Episodical.Local

  describe "paths" do
    alias Episodical.Local.Path

    import Episodical.LocalFixtures
    import Episodical.ModelFixtures

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
      valid_attrs = %{
        name: "some name",
        last_checked_at: ~U[2025-02-07 22:58:00.000000Z],
        should_auto_check: true
      }

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

      update_attrs = %{
        name: "some updated name",
        last_checked_at: ~U[2025-02-08 22:58:00.000000Z],
        should_auto_check: false
      }

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

    test "use_path_layout/2 will produce specific regex for different options" do
      episodic = episodic_fixture(%{title: "Some Title"})

      [
        %{
          opt: ":upper_word_title/:upper_word_season/:files",
          result: ~r/Some Title\/Season \d+\/(.+)/
        },
        %{
          opt: ":lower_word_title/:upper_word_season/:files",
          result: ~r/some title\/Season \d+\/(.+)/
        },
        %{
          opt: ":upper_snake_word_title/:numerical_season/:files",
          result: ~r/Some_Title\/\d+\/(.+)/
        },
        %{
          opt: ":lower_snake_word_title/:numerical_prefix_season/:files",
          result: ~r/some_title\/\d+\/(.+)/
        },
        %{
          opt: ":upper_camel_word_title/:numerical_season/:files",
          result: ~r/Some-Title\/\d+\/(.+)/
        },
        %{
          opt: ":lower_camel_word_title/:upper_word_season/:files",
          result: ~r/some-title\/Season \d+\/(.+)/
        }
      ]
      |> Enum.each(fn entry ->
        config = %Episodical.Model.Config{name: "episodic_path_layout", value: entry[:opt]}
        assert Path.use_path_layout(config, episodic) == {:ok, entry[:result]}
      end)
    end

    test "find_matching_files/2 will find some files that match a given pattern" do
      path = path_fixture(%{name: "test/test_data/"})

      assert Path.find_matching_files(path, ~r/Episodic\/Season 1\/(.+)/) ==
               {:ok,
                [
                  "#{path.name}Episodic/Season 1/Episodic.S01E01.mkv",
                  "#{path.name}Episodic/Season 1/Episodic.S01E02.mkv"
                ]}
    end

    test "find_matching_files/2 will not find non-matching files" do
      path = path_fixture(%{name: "test/test_data/"})

      assert Path.find_matching_files(path, ~r/Some Ep\/Season 1\/(.+)/) == {:ok, []}
    end

    test "find_matching_files/2 will return symlinks if found" do
      path = path_fixture(%{name: "test/test_data/"})

      assert Path.find_matching_files(path, ~r/Other Ep\/Season 1\/(.+)/) ==
               {:ok,
                [
                  "#{path.name}Other Ep/Season 1/Other.Ep.S01E01.mkv",
                  "#{path.name}Other Ep/Season 1/Other.Ep.S01E02.mkv",
                  "#{path.name}Other Ep/Season 1/Other.Ep.S01E03.mkv"
                ]}
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

      assert Local.get_file!(file.id) |> Episodical.Repo.preload([:episodic, :episode, :path]) ==
               file
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

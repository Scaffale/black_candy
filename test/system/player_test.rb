# frozen_string_literal: true

require "application_system_test_case"

class PlayerSystemTest < ApplicationSystemTestCase
  setup do
    Setting.update(media_path: Rails.root.join("test/fixtures/files"))
    users(:visitor1).current_playlist.replace(Song.ids.sort)
    login_as users(:visitor1)
  end

  test "play song" do
    find(:test_id, "player_play_button").click

    assert_selector(:test_id, "player_play_button", visible: false)
    assert_selector(:test_id, "player_pause_button", visible: true)
    assert_selector(:test_id, "player_header", visible: true)
    assert_selector(:test_id, "player_song_name", text: Song.first.name)
  end

  test "pause song" do
    find(:test_id, "player_play_button").click
    assert_selector(:test_id, "player_play_button", visible: false)
    assert_selector(:test_id, "player_pause_button", visible: true)

    find(:test_id, "player_pause_button").click
    assert_selector(:test_id, "player_play_button", visible: true)
    assert_selector(:test_id, "player_pause_button", visible: false)
  end

  test "play next song" do
    find(:test_id, "player_play_button").click
    find(:test_id, "player_next_button").click

    assert_selector(:test_id, "player_header", visible: true)
    assert_selector(:test_id, "player_song_name", text: Song.second.name)
  end

  test "play previous song" do
    find(:test_id, "player_play_button").click
    find(:test_id, "player_previous_button").click

    assert_selector(:test_id, "player_header", visible: true)
    assert_selector(:test_id, "player_song_name", text: Song.last.name)
  end

  test "favorite toggle" do
    find(:test_id, "player_play_button").click
    assert_selector(:test_id, "player_header", visible: true)
    assert_selector(:test_id, "player_song_name", text: Song.first.name)

    find(:test_id, "player_favorite_button").click
    assert_equal Song.first.name, users(:visitor1).favorite_playlist.songs.first.name

    find(:test_id, "player_favorite_button").click
    assert_equal 0, users(:visitor1).favorite_playlist.songs.count
  end
end

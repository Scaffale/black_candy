# frozen_string_literal: true

require "test_helper"

class ArtistTest < ActiveSupport::TestCase
  test "should have default title when name is empty" do
    assert_equal "Unknown Artist", Artist.create(name: nil).title
  end

  test "should have default title when is various artist" do
    assert_equal "Various Artists", Artist.create(is_various: true).title
  end

  test "should get all albums" do
    assert_equal Album.where(name: %w[album1 album2 album4]).ids.sort, artists(:artist1).all_albums.ids.sort
  end

  test "should get appears on albums" do
    assert_equal Album.where(name: %w[album4]).ids.sort, artists(:artist1).appears_on_albums.ids.sort
  end

  test "should get top songs" do
    api_response = File.read('./test/fixtures/json/lastfm/get_top_tracks_with_fixtures.json')

    stub_request(:get, "http://ws.audioscrobbler.com/2.0/?api_key=&artist=artist1&format=json&method=artist.gettoptracks")
      .to_return(status: 200, body: api_response)

    assert_equal [1,2], artists(:artist1).top_songs.ids.sort
  end
end

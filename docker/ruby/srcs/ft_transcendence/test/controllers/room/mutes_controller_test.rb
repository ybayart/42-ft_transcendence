require 'test_helper'

class Room::MutesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @room_mute = room_mutes(:one)
  end

  test "should get index" do
    get room_mutes_url
    assert_response :success
  end

  test "should get new" do
    get new_room_mute_url
    assert_response :success
  end

  test "should create room_mute" do
    assert_difference('Room::Mute.count') do
      post room_mutes_url, params: { room_mute: { by_id: @room_mute.by_id, end_at: @room_mute.end_at, room_id: @room_mute.room_id, user_id: @room_mute.user_id } }
    end

    assert_redirected_to room_mute_url(Room::Mute.last)
  end

  test "should show room_mute" do
    get room_mute_url(@room_mute)
    assert_response :success
  end

  test "should get edit" do
    get edit_room_mute_url(@room_mute)
    assert_response :success
  end

  test "should update room_mute" do
    patch room_mute_url(@room_mute), params: { room_mute: { by_id: @room_mute.by_id, end_at: @room_mute.end_at, room_id: @room_mute.room_id, user_id: @room_mute.user_id } }
    assert_redirected_to room_mute_url(@room_mute)
  end

  test "should destroy room_mute" do
    assert_difference('Room::Mute.count', -1) do
      delete room_mute_url(@room_mute)
    end

    assert_redirected_to room_mutes_url
  end
end

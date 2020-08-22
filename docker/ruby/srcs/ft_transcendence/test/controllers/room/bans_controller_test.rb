require 'test_helper'

class Room::BansControllerTest < ActionDispatch::IntegrationTest
  setup do
    @room_ban = room_bans(:one)
  end

  test "should get index" do
    get room_bans_url
    assert_response :success
  end

  test "should get new" do
    get new_room_ban_url
    assert_response :success
  end

  test "should create room_ban" do
    assert_difference('Room::Ban.count') do
      post room_bans_url, params: { room_ban: { by_id: @room_ban.by_id, end_at: @room_ban.end_at, room_id: @room_ban.room_id, user_id: @room_ban.user_id } }
    end

    assert_redirected_to room_ban_url(Room::Ban.last)
  end

  test "should show room_ban" do
    get room_ban_url(@room_ban)
    assert_response :success
  end

  test "should get edit" do
    get edit_room_ban_url(@room_ban)
    assert_response :success
  end

  test "should update room_ban" do
    patch room_ban_url(@room_ban), params: { room_ban: { by_id: @room_ban.by_id, end_at: @room_ban.end_at, room_id: @room_ban.room_id, user_id: @room_ban.user_id } }
    assert_redirected_to room_ban_url(@room_ban)
  end

  test "should destroy room_ban" do
    assert_difference('Room::Ban.count', -1) do
      delete room_ban_url(@room_ban)
    end

    assert_redirected_to room_bans_url
  end
end

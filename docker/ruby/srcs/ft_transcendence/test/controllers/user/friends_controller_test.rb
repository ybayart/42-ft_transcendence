require 'test_helper'

class User::FriendsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_friend = user_friends(:one)
  end

  test "should get index" do
    get user_friends_url
    assert_response :success
  end

  test "should get new" do
    get new_user_friend_url
    assert_response :success
  end

  test "should create user_friend" do
    assert_difference('User::Friend.count') do
      post user_friends_url, params: { user_friend: { friend_a_id: @user_friend.friend_a_id, friend_b_id: @user_friend.friend_b_id } }
    end

    assert_redirected_to user_friend_url(User::Friend.last)
  end

  test "should show user_friend" do
    get user_friend_url(@user_friend)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_friend_url(@user_friend)
    assert_response :success
  end

  test "should update user_friend" do
    patch user_friend_url(@user_friend), params: { user_friend: { friend_a_id: @user_friend.friend_a_id, friend_b_id: @user_friend.friend_b_id } }
    assert_redirected_to user_friend_url(@user_friend)
  end

  test "should destroy user_friend" do
    assert_difference('User::Friend.count', -1) do
      delete user_friend_url(@user_friend)
    end

    assert_redirected_to user_friends_url
  end
end

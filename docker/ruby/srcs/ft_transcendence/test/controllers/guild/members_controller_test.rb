require 'test_helper'

class Guild::MembersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @guild_member = guild_members(:one)
  end

  test "should get index" do
    get guild_members_url
    assert_response :success
  end

  test "should get new" do
    get new_guild_member_url
    assert_response :success
  end

  test "should create guild_member" do
    assert_difference('Guild::Member.count') do
      post guild_members_url, params: { guild_member: { user_id: @guild_member.user_id } }
    end

    assert_redirected_to guild_member_url(Guild::Member.last)
  end

  test "should show guild_member" do
    get guild_member_url(@guild_member)
    assert_response :success
  end

  test "should get edit" do
    get edit_guild_member_url(@guild_member)
    assert_response :success
  end

  test "should update guild_member" do
    patch guild_member_url(@guild_member), params: { guild_member: { user_id: @guild_member.user_id } }
    assert_redirected_to guild_member_url(@guild_member)
  end

  test "should destroy guild_member" do
    assert_difference('Guild::Member.count', -1) do
      delete guild_member_url(@guild_member)
    end

    assert_redirected_to guild_members_url
  end
end

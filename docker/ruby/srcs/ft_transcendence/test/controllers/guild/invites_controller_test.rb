require 'test_helper'

class Guild::InvitesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @guild_invite = guild_invites(:one)
  end

  test "should get index" do
    get guild_invites_url
    assert_response :success
  end

  test "should get new" do
    get new_guild_invite_url
    assert_response :success
  end

  test "should create guild_invite" do
    assert_difference('Guild::Invite.count') do
      post guild_invites_url, params: { guild_invite: { user_id: @guild_invite.user_id } }
    end

    assert_redirected_to guild_invite_url(Guild::Invite.last)
  end

  test "should show guild_invite" do
    get guild_invite_url(@guild_invite)
    assert_response :success
  end

  test "should get edit" do
    get edit_guild_invite_url(@guild_invite)
    assert_response :success
  end

  test "should update guild_invite" do
    patch guild_invite_url(@guild_invite), params: { guild_invite: { user_id: @guild_invite.user_id } }
    assert_redirected_to guild_invite_url(@guild_invite)
  end

  test "should destroy guild_invite" do
    assert_difference('Guild::Invite.count', -1) do
      delete guild_invite_url(@guild_invite)
    end

    assert_redirected_to guild_invites_url
  end
end

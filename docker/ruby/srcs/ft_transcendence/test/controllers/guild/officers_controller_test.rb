require 'test_helper'

class Guild::OfficersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @guild_officer = guild_officers(:one)
  end

  test "should get index" do
    get guild_officers_url
    assert_response :success
  end

  test "should get new" do
    get new_guild_officer_url
    assert_response :success
  end

  test "should create guild_officer" do
    assert_difference('Guild::Officer.count') do
      post guild_officers_url, params: { guild_officer: { user_id: @guild_officer.user_id } }
    end

    assert_redirected_to guild_officer_url(Guild::Officer.last)
  end

  test "should show guild_officer" do
    get guild_officer_url(@guild_officer)
    assert_response :success
  end

  test "should get edit" do
    get edit_guild_officer_url(@guild_officer)
    assert_response :success
  end

  test "should update guild_officer" do
    patch guild_officer_url(@guild_officer), params: { guild_officer: { user_id: @guild_officer.user_id } }
    assert_redirected_to guild_officer_url(@guild_officer)
  end

  test "should destroy guild_officer" do
    assert_difference('Guild::Officer.count', -1) do
      delete guild_officer_url(@guild_officer)
    end

    assert_redirected_to guild_officers_url
  end
end

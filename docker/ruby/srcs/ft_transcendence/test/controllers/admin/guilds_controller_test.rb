require 'test_helper'

class Admin::GuildsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_guild = admin_guilds(:one)
  end

  test "should get index" do
    get admin_guilds_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_guild_url
    assert_response :success
  end

  test "should create admin_guild" do
    assert_difference('Admin::Guild.count') do
      post admin_guilds_url, params: { admin_guild: {  } }
    end

    assert_redirected_to admin_guild_url(Admin::Guild.last)
  end

  test "should show admin_guild" do
    get admin_guild_url(@admin_guild)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_guild_url(@admin_guild)
    assert_response :success
  end

  test "should update admin_guild" do
    patch admin_guild_url(@admin_guild), params: { admin_guild: {  } }
    assert_redirected_to admin_guild_url(@admin_guild)
  end

  test "should destroy admin_guild" do
    assert_difference('Admin::Guild.count', -1) do
      delete admin_guild_url(@admin_guild)
    end

    assert_redirected_to admin_guilds_url
  end
end

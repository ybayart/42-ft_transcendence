require 'test_helper'

class Admin::ModeratorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_moderator = admin_moderators(:one)
  end

  test "should get index" do
    get admin_moderators_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_moderator_url
    assert_response :success
  end

  test "should create admin_moderator" do
    assert_difference('Admin::Moderator.count') do
      post admin_moderators_url, params: { admin_moderator: {  } }
    end

    assert_redirected_to admin_moderator_url(Admin::Moderator.last)
  end

  test "should show admin_moderator" do
    get admin_moderator_url(@admin_moderator)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_moderator_url(@admin_moderator)
    assert_response :success
  end

  test "should update admin_moderator" do
    patch admin_moderator_url(@admin_moderator), params: { admin_moderator: {  } }
    assert_redirected_to admin_moderator_url(@admin_moderator)
  end

  test "should destroy admin_moderator" do
    assert_difference('Admin::Moderator.count', -1) do
      delete admin_moderator_url(@admin_moderator)
    end

    assert_redirected_to admin_moderators_url
  end
end

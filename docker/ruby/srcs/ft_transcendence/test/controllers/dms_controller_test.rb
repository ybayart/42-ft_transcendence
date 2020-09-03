require 'test_helper'

class DmsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @dm = dms(:one)
  end

  test "should get index" do
    get dms_url
    assert_response :success
  end

  test "should get new" do
    get new_dm_url
    assert_response :success
  end

  test "should create dm" do
    assert_difference('Dm.count') do
      post dms_url, params: { dm: { user1_id: @dm.user1_id, user2_id: @dm.user2_id } }
    end

    assert_redirected_to dm_url(Dm.last)
  end

  test "should show dm" do
    get dm_url(@dm)
    assert_response :success
  end

  test "should get edit" do
    get edit_dm_url(@dm)
    assert_response :success
  end

  test "should update dm" do
    patch dm_url(@dm), params: { dm: { user1_id: @dm.user1_id, user2_id: @dm.user2_id } }
    assert_redirected_to dm_url(@dm)
  end

  test "should destroy dm" do
    assert_difference('Dm.count', -1) do
      delete dm_url(@dm)
    end

    assert_redirected_to dms_url
  end
end

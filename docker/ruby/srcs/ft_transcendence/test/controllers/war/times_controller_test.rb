require 'test_helper'

class War::TimesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @war_time = war_times(:one)
  end

  test "should get index" do
    get war_times_url
    assert_response :success
  end

  test "should get new" do
    get new_war_time_url
    assert_response :success
  end

  test "should create war_time" do
    assert_difference('War::Time.count') do
      post war_times_url, params: { war_time: {  } }
    end

    assert_redirected_to war_time_url(War::Time.last)
  end

  test "should show war_time" do
    get war_time_url(@war_time)
    assert_response :success
  end

  test "should get edit" do
    get edit_war_time_url(@war_time)
    assert_response :success
  end

  test "should update war_time" do
    patch war_time_url(@war_time), params: { war_time: {  } }
    assert_redirected_to war_time_url(@war_time)
  end

  test "should destroy war_time" do
    assert_difference('War::Time.count', -1) do
      delete war_time_url(@war_time)
    end

    assert_redirected_to war_times_url
  end
end

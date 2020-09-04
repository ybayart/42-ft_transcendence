require 'test_helper'

class Profile::MutesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @profile_mute = profile_mutes(:one)
  end

  test "should get index" do
    get profile_mutes_url
    assert_response :success
  end

  test "should get new" do
    get new_profile_mute_url
    assert_response :success
  end

  test "should create profile_mute" do
    assert_difference('Profile::Mute.count') do
      post profile_mutes_url, params: { profile_mute: {  } }
    end

    assert_redirected_to profile_mute_url(Profile::Mute.last)
  end

  test "should show profile_mute" do
    get profile_mute_url(@profile_mute)
    assert_response :success
  end

  test "should get edit" do
    get edit_profile_mute_url(@profile_mute)
    assert_response :success
  end

  test "should update profile_mute" do
    patch profile_mute_url(@profile_mute), params: { profile_mute: {  } }
    assert_redirected_to profile_mute_url(@profile_mute)
  end

  test "should destroy profile_mute" do
    assert_difference('Profile::Mute.count', -1) do
      delete profile_mute_url(@profile_mute)
    end

    assert_redirected_to profile_mutes_url
  end
end

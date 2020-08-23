require "application_system_test_case"

class User::FriendsTest < ApplicationSystemTestCase
  setup do
    @user_friend = user_friends(:one)
  end

  test "visiting the index" do
    visit user_friends_url
    assert_selector "h1", text: "User/Friends"
  end

  test "creating a Friend" do
    visit user_friends_url
    click_on "New User/Friend"

    fill_in "Friend a", with: @user_friend.friend_a_id
    fill_in "Friend b", with: @user_friend.friend_b_id
    click_on "Create Friend"

    assert_text "Friend was successfully created"
    click_on "Back"
  end

  test "updating a Friend" do
    visit user_friends_url
    click_on "Edit", match: :first

    fill_in "Friend a", with: @user_friend.friend_a_id
    fill_in "Friend b", with: @user_friend.friend_b_id
    click_on "Update Friend"

    assert_text "Friend was successfully updated"
    click_on "Back"
  end

  test "destroying a Friend" do
    visit user_friends_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Friend was successfully destroyed"
  end
end

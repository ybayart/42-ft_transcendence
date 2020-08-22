require "application_system_test_case"

class Room::MutesTest < ApplicationSystemTestCase
  setup do
    @room_mute = room_mutes(:one)
  end

  test "visiting the index" do
    visit room_mutes_url
    assert_selector "h1", text: "Room/Mutes"
  end

  test "creating a Mute" do
    visit room_mutes_url
    click_on "New Room/Mute"

    fill_in "By", with: @room_mute.by_id
    fill_in "End at", with: @room_mute.end_at
    fill_in "Room", with: @room_mute.room_id
    fill_in "User", with: @room_mute.user_id
    click_on "Create Mute"

    assert_text "Mute was successfully created"
    click_on "Back"
  end

  test "updating a Mute" do
    visit room_mutes_url
    click_on "Edit", match: :first

    fill_in "By", with: @room_mute.by_id
    fill_in "End at", with: @room_mute.end_at
    fill_in "Room", with: @room_mute.room_id
    fill_in "User", with: @room_mute.user_id
    click_on "Update Mute"

    assert_text "Mute was successfully updated"
    click_on "Back"
  end

  test "destroying a Mute" do
    visit room_mutes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Mute was successfully destroyed"
  end
end

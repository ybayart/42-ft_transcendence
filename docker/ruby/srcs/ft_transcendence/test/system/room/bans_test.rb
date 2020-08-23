require "application_system_test_case"

class Room::BansTest < ApplicationSystemTestCase
  setup do
    @room_ban = room_bans(:one)
  end

  test "visiting the index" do
    visit room_bans_url
    assert_selector "h1", text: "Room/Bans"
  end

  test "creating a Ban" do
    visit room_bans_url
    click_on "New Room/Ban"

    fill_in "By", with: @room_ban.by_id
    fill_in "End at", with: @room_ban.end_at
    fill_in "Room", with: @room_ban.room_id
    fill_in "User", with: @room_ban.user_id
    click_on "Create Ban"

    assert_text "Ban was successfully created"
    click_on "Back"
  end

  test "updating a Ban" do
    visit room_bans_url
    click_on "Edit", match: :first

    fill_in "By", with: @room_ban.by_id
    fill_in "End at", with: @room_ban.end_at
    fill_in "Room", with: @room_ban.room_id
    fill_in "User", with: @room_ban.user_id
    click_on "Update Ban"

    assert_text "Ban was successfully updated"
    click_on "Back"
  end

  test "destroying a Ban" do
    visit room_bans_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Ban was successfully destroyed"
  end
end

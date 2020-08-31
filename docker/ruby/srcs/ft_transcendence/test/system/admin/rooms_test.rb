require "application_system_test_case"

class Admin::RoomsTest < ApplicationSystemTestCase
  setup do
    @admin_room = admin_rooms(:one)
  end

  test "visiting the index" do
    visit admin_rooms_url
    assert_selector "h1", text: "Admin/Rooms"
  end

  test "creating a Room" do
    visit admin_rooms_url
    click_on "New Admin/Room"

    click_on "Create Room"

    assert_text "Room was successfully created"
    click_on "Back"
  end

  test "updating a Room" do
    visit admin_rooms_url
    click_on "Edit", match: :first

    click_on "Update Room"

    assert_text "Room was successfully updated"
    click_on "Back"
  end

  test "destroying a Room" do
    visit admin_rooms_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Room was successfully destroyed"
  end
end

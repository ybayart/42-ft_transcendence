require "application_system_test_case"

class Admin::ModeratorsTest < ApplicationSystemTestCase
  setup do
    @admin_moderator = admin_moderators(:one)
  end

  test "visiting the index" do
    visit admin_moderators_url
    assert_selector "h1", text: "Admin/Moderators"
  end

  test "creating a Moderator" do
    visit admin_moderators_url
    click_on "New Admin/Moderator"

    click_on "Create Moderator"

    assert_text "Moderator was successfully created"
    click_on "Back"
  end

  test "updating a Moderator" do
    visit admin_moderators_url
    click_on "Edit", match: :first

    click_on "Update Moderator"

    assert_text "Moderator was successfully updated"
    click_on "Back"
  end

  test "destroying a Moderator" do
    visit admin_moderators_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Moderator was successfully destroyed"
  end
end

require "application_system_test_case"

class Admin::GuildsTest < ApplicationSystemTestCase
  setup do
    @admin_guild = admin_guilds(:one)
  end

  test "visiting the index" do
    visit admin_guilds_url
    assert_selector "h1", text: "Admin/Guilds"
  end

  test "creating a Guild" do
    visit admin_guilds_url
    click_on "New Admin/Guild"

    click_on "Create Guild"

    assert_text "Guild was successfully created"
    click_on "Back"
  end

  test "updating a Guild" do
    visit admin_guilds_url
    click_on "Edit", match: :first

    click_on "Update Guild"

    assert_text "Guild was successfully updated"
    click_on "Back"
  end

  test "destroying a Guild" do
    visit admin_guilds_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Guild was successfully destroyed"
  end
end

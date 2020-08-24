require "application_system_test_case"

class Guild::OfficersTest < ApplicationSystemTestCase
  setup do
    @guild_officer = guild_officers(:one)
  end

  test "visiting the index" do
    visit guild_officers_url
    assert_selector "h1", text: "Guild/Officers"
  end

  test "creating a Officer" do
    visit guild_officers_url
    click_on "New Guild/Officer"

    fill_in "User", with: @guild_officer.user_id
    click_on "Create Officer"

    assert_text "Officer was successfully created"
    click_on "Back"
  end

  test "updating a Officer" do
    visit guild_officers_url
    click_on "Edit", match: :first

    fill_in "User", with: @guild_officer.user_id
    click_on "Update Officer"

    assert_text "Officer was successfully updated"
    click_on "Back"
  end

  test "destroying a Officer" do
    visit guild_officers_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Officer was successfully destroyed"
  end
end

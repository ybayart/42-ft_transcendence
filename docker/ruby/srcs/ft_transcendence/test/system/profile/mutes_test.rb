require "application_system_test_case"

class Profile::MutesTest < ApplicationSystemTestCase
  setup do
    @profile_mute = profile_mutes(:one)
  end

  test "visiting the index" do
    visit profile_mutes_url
    assert_selector "h1", text: "Profile/Mutes"
  end

  test "creating a Mute" do
    visit profile_mutes_url
    click_on "New Profile/Mute"

    click_on "Create Mute"

    assert_text "Mute was successfully created"
    click_on "Back"
  end

  test "updating a Mute" do
    visit profile_mutes_url
    click_on "Edit", match: :first

    click_on "Update Mute"

    assert_text "Mute was successfully updated"
    click_on "Back"
  end

  test "destroying a Mute" do
    visit profile_mutes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Mute was successfully destroyed"
  end
end

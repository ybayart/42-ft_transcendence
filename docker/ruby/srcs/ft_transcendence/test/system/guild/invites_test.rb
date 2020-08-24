require "application_system_test_case"

class Guild::InvitesTest < ApplicationSystemTestCase
  setup do
    @guild_invite = guild_invites(:one)
  end

  test "visiting the index" do
    visit guild_invites_url
    assert_selector "h1", text: "Guild/Invites"
  end

  test "creating a Invite" do
    visit guild_invites_url
    click_on "New Guild/Invite"

    fill_in "User", with: @guild_invite.user_id
    click_on "Create Invite"

    assert_text "Invite was successfully created"
    click_on "Back"
  end

  test "updating a Invite" do
    visit guild_invites_url
    click_on "Edit", match: :first

    fill_in "User", with: @guild_invite.user_id
    click_on "Update Invite"

    assert_text "Invite was successfully updated"
    click_on "Back"
  end

  test "destroying a Invite" do
    visit guild_invites_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Invite was successfully destroyed"
  end
end

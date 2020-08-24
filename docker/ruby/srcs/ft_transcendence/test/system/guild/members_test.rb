require "application_system_test_case"

class Guild::MembersTest < ApplicationSystemTestCase
  setup do
    @guild_member = guild_members(:one)
  end

  test "visiting the index" do
    visit guild_members_url
    assert_selector "h1", text: "Guild/Members"
  end

  test "creating a Member" do
    visit guild_members_url
    click_on "New Guild/Member"

    fill_in "User", with: @guild_member.user_id
    click_on "Create Member"

    assert_text "Member was successfully created"
    click_on "Back"
  end

  test "updating a Member" do
    visit guild_members_url
    click_on "Edit", match: :first

    fill_in "User", with: @guild_member.user_id
    click_on "Update Member"

    assert_text "Member was successfully updated"
    click_on "Back"
  end

  test "destroying a Member" do
    visit guild_members_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Member was successfully destroyed"
  end
end

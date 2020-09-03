require "application_system_test_case"

class DmsTest < ApplicationSystemTestCase
  setup do
    @dm = dms(:one)
  end

  test "visiting the index" do
    visit dms_url
    assert_selector "h1", text: "Dms"
  end

  test "creating a Dm" do
    visit dms_url
    click_on "New Dm"

    fill_in "User1", with: @dm.user1_id
    fill_in "User2", with: @dm.user2_id
    click_on "Create Dm"

    assert_text "Dm was successfully created"
    click_on "Back"
  end

  test "updating a Dm" do
    visit dms_url
    click_on "Edit", match: :first

    fill_in "User1", with: @dm.user1_id
    fill_in "User2", with: @dm.user2_id
    click_on "Update Dm"

    assert_text "Dm was successfully updated"
    click_on "Back"
  end

  test "destroying a Dm" do
    visit dms_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Dm was successfully destroyed"
  end
end

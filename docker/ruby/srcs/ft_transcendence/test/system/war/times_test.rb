require "application_system_test_case"

class War::TimesTest < ApplicationSystemTestCase
  setup do
    @war_time = war_times(:one)
  end

  test "visiting the index" do
    visit war_times_url
    assert_selector "h1", text: "War/Times"
  end

  test "creating a Time" do
    visit war_times_url
    click_on "New War/Time"

    click_on "Create Time"

    assert_text "Time was successfully created"
    click_on "Back"
  end

  test "updating a Time" do
    visit war_times_url
    click_on "Edit", match: :first

    click_on "Update Time"

    assert_text "Time was successfully updated"
    click_on "Back"
  end

  test "destroying a Time" do
    visit war_times_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Time was successfully destroyed"
  end
end

require "application_system_test_case"

class WarsTest < ApplicationSystemTestCase
  setup do
    @war = wars(:one)
  end

  test "visiting the index" do
    visit wars_url
    assert_selector "h1", text: "Wars"
  end

  test "creating a War" do
    visit wars_url
    click_on "New War"

    fill_in "Agree", with: @war.agree
    check "All match" if @war.all_match
    fill_in "End at", with: @war.end_at
    fill_in "Guild1", with: @war.guild1_id
    fill_in "Guild2", with: @war.guild2_id
    fill_in "Points1", with: @war.points1
    fill_in "Points2", with: @war.points2
    fill_in "Points to win", with: @war.points_to_win
    fill_in "Start at", with: @war.start_at
    fill_in "Winner", with: @war.winner_id
    click_on "Create War"

    assert_text "War was successfully created"
    click_on "Back"
  end

  test "updating a War" do
    visit wars_url
    click_on "Edit", match: :first

    fill_in "Agree", with: @war.agree
    check "All match" if @war.all_match
    fill_in "End at", with: @war.end_at
    fill_in "Guild1", with: @war.guild1_id
    fill_in "Guild2", with: @war.guild2_id
    fill_in "Points1", with: @war.points1
    fill_in "Points2", with: @war.points2
    fill_in "Points to win", with: @war.points_to_win
    fill_in "Start at", with: @war.start_at
    fill_in "Winner", with: @war.winner_id
    click_on "Update War"

    assert_text "War was successfully updated"
    click_on "Back"
  end

  test "destroying a War" do
    visit wars_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "War was successfully destroyed"
  end
end

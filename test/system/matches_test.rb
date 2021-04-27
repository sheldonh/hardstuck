require "application_system_test_case"

class MatchesTest < ApplicationSystemTestCase
  setup do
    @match = matches(:one)
  end

  test "visiting the index" do
    visit matches_url
    assert_selector "h1", text: "Matches"
  end

  test "creating a Match" do
    visit matches_url
    click_on "Capture Match"

    check "Draw" if @match.draw
    select  @match.losing_member.full_name, from: "Losing member"
    select  @match.winning_member.full_name, from: "Winning member"
    click_on "Create Match"

    assert_text "Match was successfully created"
    assert_selector "h1", text: "Leaderboard"
  end
end

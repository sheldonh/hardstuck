require "test_helper"

class MatchExamples < ActiveSupport::TestCase

  def setup
    Member.destroy_all
    @initial_club = [
      {"name" => "Bronwyn", "current_rank" => 1},
      {"name" => "Jonno",   "current_rank" => 2},
      {"name" => "Connor",  "current_rank" => 3},
      {"name" => "Johan",   "current_rank" => 4},
      {"name" => "Wynand",  "current_rank" => 5},
      {"name" => "Sheldon", "current_rank" => 6},
    ]
    Member.create(@initial_club)
  end

  test "example #1: the upset" do
    create_match(winning_member: "Sheldon", losing_member: "Bronwyn", draw: false).apply_ranking_changes
    expected_club = [
      {"name" => "Jonno",   "current_rank" => 1},
      {"name" => "Bronwyn", "current_rank" => 2},
      {"name" => "Connor",  "current_rank" => 3},
      {"name" => "Sheldon", "current_rank" => 4},
      {"name" => "Johan",   "current_rank" => 5},
      {"name" => "Wynand",  "current_rank" => 6},
    ]
    assert_equal expected_club, actual_club
  end

  test "example #2: the adjacent draw" do
    create_match(winning_member: "Bronwyn", losing_member: "Jonno", draw: true).apply_ranking_changes
    assert_equal @initial_club, actual_club
  end

  test "example #3: the upset draw" do
    create_match(winning_member: "Connor", losing_member: "Bronwyn", draw: true).apply_ranking_changes
    expected_club = [
      {"name" => "Bronwyn", "current_rank" => 1},
      {"name" => "Connor",  "current_rank" => 2},
      {"name" => "Jonno",   "current_rank" => 3},
      {"name" => "Johan",   "current_rank" => 4},
      {"name" => "Wynand",  "current_rank" => 5},
      {"name" => "Sheldon", "current_rank" => 6},
    ]
    assert_equal expected_club, actual_club
  end

  test "example #4: trouble at the top" do
    create_match(winning_member: "Jonno", losing_member: "Bronwyn", draw: false).apply_ranking_changes
    expected_club = [
      {"name" => "Jonno",   "current_rank" => 1},
      {"name" => "Bronwyn", "current_rank" => 2},
      {"name" => "Connor",  "current_rank" => 3},
      {"name" => "Johan",   "current_rank" => 4},
      {"name" => "Wynand",  "current_rank" => 5},
      {"name" => "Sheldon", "current_rank" => 6},
    ]
    assert_equal expected_club, actual_club
  end

  test "example #5: the twist at the top" do
    create_match(winning_member: "Connor", losing_member: "Bronwyn", draw: false).apply_ranking_changes
    expected_club = [
      {"name" => "Jonno",   "current_rank" => 1},
      {"name" => "Connor",  "current_rank" => 2},
      {"name" => "Bronwyn", "current_rank" => 3},
      {"name" => "Johan",   "current_rank" => 4},
      {"name" => "Wynand",  "current_rank" => 5},
      {"name" => "Sheldon", "current_rank" => 6},
    ]
    assert_equal expected_club, actual_club
  end

  def actual_club
    Member.select(:name, :current_rank).order(:current_rank).all.map { |x| x.attributes.to_h.except("id") }
  end

  def create_match(winning_member:, losing_member:, draw:)
    Match.new(winning_member: Member.find_by_name(winning_member), losing_member: Member.find_by_name(losing_member), draw: draw)
  end
end
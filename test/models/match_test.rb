require "test_helper"

class MatchTest < ActiveSupport::TestCase

  test "won't affect rank of higher-ranked winner" do
    match = Match.new(winning_member: members(:one), losing_member: members(:two), draw: false)
    assert_no_changes -> { members(:one).reload.current_rank } do
      match.apply_ranking_changes
    end
  end

  test "decrements rank of higher-ranked loser" do
    match = Match.new(winning_member: members(:two), losing_member: members(:one), draw: false)
    assert_difference -> { members(:one).reload.current_rank } => 1 do
      match.apply_ranking_changes
    end
  end

  test "won't affect rank of adjacent-ranked drawer" do
    match = Match.new(winning_member: members(:one), losing_member: members(:two), draw: true)
    assert_no_difference -> { members(:two).reload.current_rank } do
      match.apply_ranking_changes
    end
  end

  test "increments rank of lower-ranked drawer when not adjacent-ranked" do
    three = Member.create
    match = Match.new(winning_member: members(:one), losing_member: three, draw: true)
    assert_difference -> { three.reload.current_rank } => -1 do
      match.apply_ranking_changes
    end
  end

  test "increases rank of lower-ranked winner by half original rank difference" do
    six = Array.new(4) { Member.create }.last
    match = Match.new(winning_member: six, losing_member: members(:one), draw: false)
    assert_difference -> { six.reload.current_rank } => -2 do
      match.apply_ranking_changes
    end
  end

  test "decrements ranks of members displaced by lower-ranked winner" do
    _three, four, five, six = Array.new(4) { Member.create }
    match = Match.new(winning_member: six, losing_member: members(:one), draw: false)
    assert_difference -> { four.reload.current_rank } => 1, -> { five.reload.current_rank } => 1  do
      match.apply_ranking_changes
    end
  end

  test "increments the rank of the member displaced by a higher-ranked loser" do
    three = Member.create
    match = Match.new(winning_member: three, losing_member: members(:one), draw: false)
    assert_difference -> { members(:two).reload.current_rank } => -1 do
      match.apply_ranking_changes
    end
  end

  test "won't affect ranks of members not displaced by lower-ranked winner" do
    three, _four, _five, six = Array.new(4) { Member.create }
    match = Match.new(winning_member: six, losing_member: members(:one), draw: false)
    assert_no_difference -> { three.reload.current_rank } do
      match.apply_ranking_changes
    end
  end

  test "swaps ranks of lower-ranked winner and higher-ranked loser when adjacent-ranked" do
    match = Match.new(winning_member: members(:two), losing_member: members(:one), draw: false)
    assert_difference -> { members(:two).reload.current_rank } => -1, -> { members(:one).reload.current_rank } => 1 do
      match.apply_ranking_changes
    end
  end

end

require "test_helper"

class MatchTest < ActiveSupport::TestCase

  test "won't affect rank of higher-ranked winner" do
    assert_no_changes -> { members(:one).reload.current_rank } do
      Match.create(winning_member: members(:one), losing_member: members(:two), draw: false)
    end
  end

  test "decrements rank of higher-ranked loser" do
    assert_difference -> { members(:one).reload.current_rank } => 1 do
      Match.create(winning_member: members(:two), losing_member: members(:one), draw: false)
    end
  end

  test "won't affect rank of adjacent-ranked drawer" do
    assert_no_difference -> { members(:two).reload.current_rank } do
      Match.create(winning_member: members(:one), losing_member: members(:two), draw: true)
    end
  end

  test "increments rank of lower-ranked drawer when not adjacent-ranked" do
    three = Member.create(name: "three")
    assert_difference -> { three.reload.current_rank } => -1 do
      Match.create(winning_member: members(:one), losing_member: three, draw: true)
    end
  end

  test "increases rank of lower-ranked winner by half original rank difference" do
    six = Array.new(4) { Member.create(name: "String") }.last
    assert_difference -> { six.reload.current_rank } => -2 do
      Match.create(winning_member: six, losing_member: members(:one), draw: false)
    end
  end

  test "decrements ranks of members displaced by lower-ranked winner" do
    _three, four, five, six = Array.new(4) { Member.create(name: "String") }
    assert_difference -> { four.reload.current_rank } => 1, -> { five.reload.current_rank } => 1  do
      Match.create(winning_member: six, losing_member: members(:one), draw: false)
    end
  end

  test "increments the rank of the member displaced by a higher-ranked loser" do
    three = Member.create(name: "Three")
    assert_difference -> { members(:two).reload.current_rank } => -1 do
      Match.create(winning_member: three, losing_member: members(:one), draw: false)
    end
  end

  test "won't affect ranks of members not displaced by lower-ranked winner" do
    three, _four, _five, six = Array.new(4) { Member.create(name: "String") }
    assert_no_difference -> { three.reload.current_rank } do
      Match.create(winning_member: six, losing_member: members(:one), draw: false)
    end
  end

  test "swaps ranks of lower-ranked winner and higher-ranked loser when adjacent-ranked" do
    assert_difference -> { members(:two).reload.current_rank } => -1, -> { members(:one).reload.current_rank } => 1 do
      Match.create(winning_member: members(:two), losing_member: members(:one), draw: false)
    end
  end

  test "increments participants' games played" do
    assert_difference -> { members(:one).reload.games_played } => 1, -> { members(:two).reload.games_played } => 1 do
      Match.create(winning_member: members(:two), losing_member: members(:one), draw: true)
    end
  end
end

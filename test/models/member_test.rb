require "test_helper"

class MemberTest < ActiveSupport::TestCase
  test "is created ranked last" do
    prior_lowest_rank = Member.maximum(:current_rank)
    member = Member.create(name: "Joe")
    assert_equal prior_lowest_rank + 1, member.current_rank
  end
  
  test "is created with zero games played" do
    member = Member.create(name: "Joe")
    assert_equal 0, member.games_played
  end
  
end

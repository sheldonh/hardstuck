require "test_helper"

class MemberTest < ActiveSupport::TestCase
  test "is created ranked last" do
    prior_lowest_rank = Member.maximum(:current_rank)
    member = Member.create
    assert_equal prior_lowest_rank + 1, member.current_rank
  end
end

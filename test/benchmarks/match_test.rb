require "test_helper"
require "minitest/benchmark"

return unless ENV["WANT_BENCHMARKS"]

class MatchBenchmark < Minitest::Benchmark

  def self.bench_range
    [3, 10, 25, 100, 1_000]
  end

  def bench_apply_ranking_changes
    assert_performance_linear 0.1 do |i|
      Member.transaction do
        Member.destroy_all
        @members = (0..i).map { Member.create(name: "String") }
        match = Match.new(winning_member: @members.last, losing_member: @members.first, draw: false)
        match.apply_ranking_changes
        raise ActiveRecord::Rollback
      end
    end
  end

end
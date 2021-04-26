require "test_helper"
require "minitest/benchmark"

return unless ENV["WANT_BENCHMARKS"]

class MatchBenchmark < Minitest::Benchmark

  def self.bench_range
    [3, 10, 25, 100, 1_000]
  end

  def bench_apply_ranking_changes
    assert_performance_linear 0.1 do |i|
      @members = (0..i).map { Member.create }
      match = Match.new(winning_member: @members.last, losing_member: @members.first, draw: false)
      match.apply_ranking_changes
      Member.destroy_all
    end
  end

end
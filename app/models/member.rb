class Member < ApplicationRecord
    before_create :occupy_lowest_rank

    def outranks?(other)
        self.current_rank < other.current_rank
    end

    def rank_adjacent?(other)
        1 == (self.current_rank - other.current_rank).abs
    end

    def uprank(by = 1)
        decrement(:current_rank, by)
    end

    def downrank(by = 1)
        increment(:current_rank, by)
    end

    private

    def occupy_lowest_rank
        if !self.current_rank?
            self.current_rank = Member.maximum(:current_rank) + 1
        end
    end
end

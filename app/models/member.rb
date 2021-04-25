class Member < ApplicationRecord
    before_create :occupy_lowest_rank

    private
    
    def occupy_lowest_rank
        if !self.current_rank?
            self.current_rank = Member.maximum(:current_rank) + 1
        end
    end
end

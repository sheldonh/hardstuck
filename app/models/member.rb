class Member < ApplicationRecord
  before_create :occupy_lowest_rank
  before_create :default_games_played

  validates :name, presence: true
  
  def full_name
    [name, surname].compact.join(" ")
  end

  def outranks?(other)
    self.current_rank < other.current_rank
  end

  def rank_adjacent?(other)
    1 == (self.current_rank - other.current_rank).abs
  end

  private

  def default_games_played
    if !self.games_played?
      self.games_played = 0
    end
  end
  
  def occupy_lowest_rank
    if !self.current_rank?
      self.current_rank = (Member.maximum(:current_rank) || 0) + 1
    end
  end
end

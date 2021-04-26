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

  def uprank(by = 1)
    decrement(:current_rank, by)
  end

  def downrank(by = 1)
    increment(:current_rank, by)
  end

  def self.uprank(member, by = 1)
    transaction do
      connection.execute "SET CONSTRAINTS members_current_rank DEFERRED"
      by.times do
        member.uprank
        displace_member = Member.where(current_rank: member.current_rank).first
        displace_member.downrank
        displace_member.save!
      end
      member.save!
    end
  end

  def self.downrank(member, by = 1)
    transaction do
      connection.execute "SET CONSTRAINTS members_current_rank DEFERRED"
      by.times do
        member.downrank
        displace_member = Member.where(current_rank: member.current_rank).first
        displace_member.uprank
        displace_member.save!
      end
      member.save!
    end
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

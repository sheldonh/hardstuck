class Match < ApplicationRecord
  belongs_to :winning_member, class_name: "Member"
  belongs_to :losing_member, class_name: "Member"

  # TODO review the use of ActiveRecord hooks for business logic
  before_create :apply_changes

  def higher_ranked_member
    winning_member.outranks?(losing_member) ? winning_member : losing_member
  end

  def lower_ranked_member
    winning_member.outranks?(losing_member) ? losing_member : winning_member
  end

  # TODO verify assumption: downrank loser before upranking winner
  # TODO maybe optimize: grab all the members from highest ranked through lowest ranked, adjust ranks in memory, then do all the saves (with deferred constraints?)
  def apply_ranking_changes
    transaction do
      if draw?
        if !lower_ranked_member.rank_adjacent?(higher_ranked_member)
          Member.uprank(lower_ranked_member)
        end
      elsif losing_member.outranks?(winning_member)
        rank_difference = (winning_member.current_rank - losing_member.current_rank).abs
        uprank_earned = rank_difference / 2
        Member.downrank(losing_member)
        Member.uprank(winning_member, uprank_earned)
      end
    end
  end

  def apply_games_played_changes
    transaction do
      winning_member.increment!(:games_played)
      losing_member.increment!(:games_played)
    end
  end
  
  private
  
  def apply_changes
    transaction do
      apply_games_played_changes
      apply_ranking_changes
    end
  end
end

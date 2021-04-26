class Match < ApplicationRecord
  belongs_to :winning_member, class_name: "Member"
  belongs_to :losing_member, class_name: "Member"

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
      Match.connection.execute "SET CONSTRAINTS members_current_rank DEFERRED"

      if draw?
        if !lower_ranked_member.rank_adjacent?(higher_ranked_member)
          uprank(lower_ranked_member)
        end
      elsif losing_member.outranks?(winning_member)
        rank_difference = (winning_member.current_rank - losing_member.current_rank).abs
        uprank_earned = rank_difference / 2
        downrank(losing_member)
        uprank(winning_member, uprank_earned)
      end
    end
  end

  private

  # TODO resolve feature envy: move method to Member
  def downrank(member, by = 1)
    by.times do
      member.downrank
      displace_member = Member.where(current_rank: member.current_rank).first
      displace_member.uprank
      displace_member.save!
    end
    member.save!
  end

  # TODO resolve feature envy: move method to Member
  def uprank(member, by = 1)
    by.times do
      member.uprank
      displace_member = Member.where(current_rank: member.current_rank).first
      displace_member.downrank
      displace_member.save!
    end
    member.save!
  end

end

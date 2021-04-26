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

  def ranking_changes
    min_rank = [winning_member.current_rank, losing_member.current_rank].min
    max_rank = [winning_member.current_rank, losing_member.current_rank].max
    members = Member.where(current_rank: min_rank..max_rank).order(:current_rank).to_a
    if draw?
      if !lower_ranked_member.rank_adjacent?(higher_ranked_member)
        members.insert(-2, members.pop)
      end
    elsif losing_member.outranks?(winning_member)
      rank_difference = (winning_member.current_rank - losing_member.current_rank).abs
      uprank_earned = rank_difference / 2
      members.insert(1, members.shift)
      members.insert(-(uprank_earned + 1), members.pop)
    end
    members.each_with_index do |member, i|
      member.current_rank = min_rank + i
    end
    members.
      reject { |member| !member.changed? }.
      map { |member| {id: member.id, ranking_change: member.changes["current_rank"]} }
  end

  # TODO verify assumption: downrank loser before upranking winner
  def apply_ranking_changes
    transaction do 
      Member.connection.execute "SET CONSTRAINTS members_current_rank DEFERRED"
      ranking_changes.each do |change|
        Member.update(change[:id], current_rank: change[:ranking_change][1])
      end
    end
    ranking_changes
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

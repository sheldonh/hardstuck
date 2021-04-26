class AlterMembersCurrentRankDeferrable < ActiveRecord::Migration[6.1]
  def up
    remove_index :members, :current_rank
    execute <<-SQL
      alter table members
        add constraint members_current_rank unique (current_rank) DEFERRABLE INITIALLY IMMEDIATE;
    SQL
  end

  def down
    execute <<-SQL
      alter table members
        drop constraint if exists members_current_rank;
    SQL
    add_index :members, :current_rank, unique: true
  end
end

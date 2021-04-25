class CreateMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :members do |t|
      t.string :name
      t.string :surname
      t.string :email_address
      t.date :birthday
      t.integer :games_played
      t.integer :current_rank

      t.timestamps
    end
    add_index :members, :current_rank, unique: true
  end
end

class CreateMatches < ActiveRecord::Migration[6.1]
  def change
    create_table :matches do |t|
      t.references :winning_member, null: false, foreign_key: { to_table: :members, on_delete: :cascade }
      t.references :losing_member, null: false, foreign_key: { to_table: :members, on_delete: :cascade }
      t.boolean :draw

      t.timestamps
    end
  end
end
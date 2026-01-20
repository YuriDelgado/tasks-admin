class CreateActivityAssignments < ActiveRecord::Migration[8.0]
  def change
    create_table :activity_assignments do |t|
      t.references :activity, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :position, null: false

      t.timestamps
    end

    add_index :activity_assignments, [ :activity_id, :position ], unique: true
    add_index :activity_assignments, [ :activity_id, :user_id ], unique: true
  end
end

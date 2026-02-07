class CreateActivityOverrides < ActiveRecord::Migration[8.0]
  def change
    create_table :activity_overrides do |t|
      t.references :activity, null: false, foreign_key: true
      t.references :assigned_to, null: false, foreign_key: { to_table: :users }
      t.references :created_by, null: false, foreign_key: { to_table: :users }
      t.date :date_from, null: false
      t.date :date_to, null: false
      t.string :reason

      t.timestamps
    end

    add_index :activity_overrides,
        [ :activity_id, :date_from, :date_to ],
        name: "index_activity_overrides_on_activity_and_range"
  end
end

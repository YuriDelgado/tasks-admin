class CreateActivities < ActiveRecord::Migration[8.0]
  def change
    create_table :activities do |t|
      t.string :name
      t.text :description
      t.references :user, null: false, foreign_key: true
      t.string :status, null: false, default: "draft"
      t.string :period, null: false, default: "day"
      t.string :activity_type, null: false, default: "chore"
      t.integer :frequency
      t.integer :times_per_period
      t.integer :reward_stars
      t.datetime :start_date
      t.datetime :end_time

      t.timestamps
    end
  end
end

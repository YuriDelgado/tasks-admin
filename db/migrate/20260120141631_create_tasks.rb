class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.references :activity, null: false, foreign_key: true
      t.string :status, null: false, default: "pending"
      t.datetime :due_to
      t.datetime :completed_at

      t.timestamps
    end
  end
end

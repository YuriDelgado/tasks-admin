class CreateTaskOverrides < ActiveRecord::Migration[8.0]
  def change
    create_table :task_overrides do |t|
      t.references :task, null: false, foreign_key: true

      t.references :assigned_to, foreign_key: { to_table: :users }
      t.references :overridden_by, foreign_key: { to_table: :users }

      t.date :due_on
      t.string :reason

      t.timestamps
    end
  end
end

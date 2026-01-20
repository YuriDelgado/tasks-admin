class AddAssignmentToTasks < ActiveRecord::Migration[8.0]
  def change
    add_column :tasks, :assigned_to_id, :bigint
    add_column :tasks, :assignment_source, :string, null: false, default: "rotation"

    add_index :tasks, :assigned_to_id
    add_foreign_key :tasks, :users, column: :assigned_to_id
  end
end

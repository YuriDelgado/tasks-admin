class AddActivityOverrideToTaskOverrides < ActiveRecord::Migration[8.0]
  def change
    add_reference :task_overrides, :activity_override, null: false, foreign_key: true
  end
end

class AddPositionCheckConstraintToActivityAssignments < ActiveRecord::Migration[8.0]
  def change
    change_column_null :activity_assignments, :position, false
  end
end

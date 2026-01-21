class AddAccountToActivities < ActiveRecord::Migration[8.0]
  def change
    add_reference :activities, :account, null: true, foreign_key: true
  end
end

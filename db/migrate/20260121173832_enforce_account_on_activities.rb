class EnforceAccountOnActivities < ActiveRecord::Migration[8.0]
  def change
    change_column_null :activities, :account_id, false
  end
end

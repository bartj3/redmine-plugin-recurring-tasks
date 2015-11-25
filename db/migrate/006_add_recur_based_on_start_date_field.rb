class AddRecurBasedOnStartDateField < ActiveRecord::Migration
  def change
    add_column :recurring_tasks, :recur_based_on_start_date, :boolean, default: false
  end
end

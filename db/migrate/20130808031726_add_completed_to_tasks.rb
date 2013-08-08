class AddCompletedToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :completed, :boolean
    add_column :tasks, :completed_at, :datetime
  end
end

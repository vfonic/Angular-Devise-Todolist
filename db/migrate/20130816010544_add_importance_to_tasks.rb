class AddImportanceToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :importance, :string, default: "yellow"
  end
end

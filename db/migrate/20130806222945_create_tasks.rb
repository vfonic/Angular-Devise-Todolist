class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :title
      t.integer :priority

      t.timestamps
    end
    add_index :tasks, :priority
  end
end

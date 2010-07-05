class AddPriorityToTask < ActiveRecord::Migration

  def self.up
    change_table :tasks do |t|
      t.integer :priority, :default => 5
    end
  end

  def self.down
     remove_column :tasks, :priority
  end

end

class AddRecurranceToTask < ActiveRecord::Migration
  def self.up
    change_table :tasks do |t|
      t.integer :recurrance, :default => 1 
    end 
  end

  def self.down
     remove_column :tasks, :recurrance
  end
end

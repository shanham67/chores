class AddDefaultLastDateToPlan < ActiveRecord::Migration
  def self.up
    change_column :plans, :date, :date, {:default => '2000-01-01'}
    change_table :plans do |t|
      t.boolean :recorded, :default => false
    end 

  end

  def self.down
     remove_column :recorded
  end
end

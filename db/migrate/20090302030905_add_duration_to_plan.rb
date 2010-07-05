class AddDurationToPlan < ActiveRecord::Migration
  def self.up
    change_table :plans do |t|
      t.integer :duration, :default=>60
    end 
  end

  def self.down
     remove_column :plans, :duration
  end
end

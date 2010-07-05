class AddDateCompleteToAssignment < ActiveRecord::Migration
  def self.up
    change_table :assignments do |t|
      t.date :date_complete, {:default => '2000-1-1'}
    end
  end

  def self.down
    remove_column :date_complete
  end
end

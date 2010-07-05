class AddHasChoresToWorkers < ActiveRecord::Migration

  def self.up
    change_table :workers do |t|
      t.boolean :has_chores, :default => false
    end
  end

  def self.down
     remove_column :workers, :has_chores
  end

end

class AddScheduledDateToTask < ActiveRecord::Migration
  def self.up
    change_table :tasks do |t|
      t.date :scheduled_date, {:default => '2000-1-1'}
    end

  end

  def self.down
     remove_column :scheduled_date
  end
end

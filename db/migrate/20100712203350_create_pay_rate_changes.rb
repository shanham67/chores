class CreatePayRateChanges < ActiveRecord::Migration
  def self.up
    create_table :pay_rate_changes do |t|
      t.datetime :effective_date
      t.decimal :old_rate, :precision => 8, :scale => 2, :default => "0.0", :null => false
      t.decimal :new_rate, :precision => 8, :scale => 2, :default => "0.0", :null => false
      t.references :worker
      t.timestamps
    end
  end

  def self.down
    drop_table :pay_rate_changes
  end
end

class AddPayRateToWorker < ActiveRecord::Migration
  def self.up
	  add_column :workers, :pay_rate, :decimal, :precision => 8, :scale => 2, :default => "0.0"
  end

  def self.down
	  remove_column :workers, :pay_rate
  end
end

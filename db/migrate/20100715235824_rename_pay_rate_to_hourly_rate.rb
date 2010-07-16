class RenamePayRateToHourlyRate < ActiveRecord::Migration
  def self.up
       rename_column :workers, :pay_rate, :hourly_rate
  end

  def self.down
       rename_column :workers, :hourly_rate, :pay_rate
  end
end

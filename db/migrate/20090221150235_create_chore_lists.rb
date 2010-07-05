class CreateChoreLists < ActiveRecord::Migration
  def self.up
    create_table :chore_lists do |t|
      t.references :plan
      t.references :worker
      t.integer :duration

      t.timestamps
    end
  end

  def self.down
    drop_table :chore_lists
  end
end

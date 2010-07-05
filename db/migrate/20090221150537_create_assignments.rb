class CreateAssignments < ActiveRecord::Migration
  def self.up
    create_table :assignments do |t|
      t.references :chore_list
      t.references :task
      t.boolean :complete

      t.timestamps
    end
  end

  def self.down
    drop_table :assignments
  end
end

class CreateNotifications < ActiveRecord::Migration
  def self.up
    create_table :notifications do |t|
      t.integer :badge
      t.string :alert
      t.string :sound
      t.string :payload
      t.integer :status
      t.integer :scheduled_count
      t.integer :dispatched_count
      t.integer :app_id

      t.timestamps
      t.datetime "deleted_at"
    end
    
    add_index :notifications, :app_id
  end

  def self.down
    drop_table :notifications
  end
end

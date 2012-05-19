class AddExtraKeyExtraValueToNotifications < ActiveRecord::Migration
  def self.up	
    add_column :notifications, :extra_key, :string
    add_column :notifications, :extra_value, :string
  end

  def self.down
    remove_column :notifications, :extra_key, :string
    remove_column :notifications, :extra_value, :string
  end
end

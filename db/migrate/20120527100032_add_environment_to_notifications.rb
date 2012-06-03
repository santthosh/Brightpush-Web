class AddEnvironmentToNotifications < ActiveRecord::Migration
  def self.up	
    add_column :notifications, :environment, :string
  end

  def self.down
    remove_column :notifications, :environment, :string
  end
end

class AddApplicationTypeToApps < ActiveRecord::Migration
  def self.up	
    add_column :apps, :application_type, :string
  end

  def self.down
    remove_column :apps, :application_type, :string
  end
end

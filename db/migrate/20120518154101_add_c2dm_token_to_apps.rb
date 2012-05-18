class AddC2dmTokenToApps < ActiveRecord::Migration
  def self.up	
    add_column :apps, :c2dm_token, :text
  end

  def self.down
    remove_column :apps, :c2dm_token, :text
  end
end

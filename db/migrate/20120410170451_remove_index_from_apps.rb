class RemoveIndexFromApps < ActiveRecord::Migration
  def up
    remove_index :apps, :column => :key
  end

  def down
    add_index :apps,:column => :key
  end
end

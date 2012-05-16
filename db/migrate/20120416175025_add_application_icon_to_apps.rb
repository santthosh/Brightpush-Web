class AddApplicationIconToApps < ActiveRecord::Migration
  def up
    add_column :apps, :application_icon_file, :string
    add_column :apps, :application_icon_content_type, :string
  end

  def down
    remove_column :apps, :application_icon_file, :string
    remove_column :apps, :application_icon_content_type, :string
  end
end

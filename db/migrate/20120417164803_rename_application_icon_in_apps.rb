class RenameApplicationIconInApps < ActiveRecord::Migration
  def change
	rename_column :apps, :application_icon_file, :application_icon_file_name
  end
end

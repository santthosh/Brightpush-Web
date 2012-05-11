class RenameColumnForApplication < ActiveRecord::Migration
  def change
		remove_column :apps, :development_push_certificate_file
		add_column :apps, :development_push_certificate_file_name, :string
		remove_column :apps, :production_push_certificate_file
		add_column :apps, :production_push_certificate_file_name, :string
  end
end

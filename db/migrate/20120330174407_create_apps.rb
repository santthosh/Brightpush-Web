class CreateApps < ActiveRecord::Migration
  def self.up
    create_table :apps do |t|
      t.integer :account_id
      t.string :name
      t.string :key
      t.binary :development_push_certificate_file
      t.string :development_push_certificate_content_type
      t.string :crypted_development_push_certificate_password
      t.string :crypted_development_push_certificate_salt
      t.binary :production_push_certificate_file
      t.string :production_push_certificate_content_type
      t.string :crypted_production_push_certificate_password
      t.string :crypted_production_push_certificate_salt
      t.timestamps

      t.datetime "deleted_at"
    end
    
    add_index :apps, :name
    add_index :apps, :key, :unique => true
    add_index :apps, :account_id
  end

  def self.down
    drop_table :apps
  end
end
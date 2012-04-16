class App < ActiveRecord::Base
  
  belongs_to :account
  has_many :notifications, :dependent => :destroy
  acts_as_paranoid
  attr_accessible :name, :key, :application_icon, :application_icon_content_type, :development_push_certificate, :development_push_certificate_content_type, :crypted_development_push_certificate_password, :crypted_development_push_certificate_salt, :production_push_certificate, :production_push_certificate_content_type, :crypted_production_push_certificate_password, :crypted_production_push_certificate_salt
  attr_accessor :application_icon_file_name, :development_push_certificate_file_name, :production_push_certificate_file_name
  
  has_attached_file :application_icon, :styles => { :thumb => "48x48>" }
  has_attached_file :development_push_certificate,
                    :storage => :database
  has_attached_file :production_push_certificate,
                    :storage => :database
  #default_scope select_without_file_columns_for(:development_push_certificate)
  
  validates_presence_of :name
  validates_presence_of :key
  validates_uniqueness_of :key, :if => :is_deleted_at?
  validates_attachment_content_type :application_icon, :content_type => 'image/png'
  validates_attachment_content_type :development_push_certificate, :content_type => 'application/x-pkcs12'
  validates_presence_of :crypted_development_push_certificate_password, :if => :development_push_certificate?
  validates_attachment_content_type :production_push_certificate, :content_type => 'application/x-pkcs12'
  validates_presence_of :crypted_production_push_certificate_password, :if => :production_push_certificate?

  def encrypt_passwords
    # encryption for development certificate password with salt
    unless crypted_development_push_certificate_password.blank?
      crypted_development_push_certificate_salt = SecureRandom.base64(8)
      crypted_development_push_certificate_password = Digest::SHA2.hexdigest(self.crypted_development_push_certificate_password + crypted_development_push_certificate_salt)
      update_attributes!(crypted_development_push_certificate_salt: crypted_development_push_certificate_salt, crypted_development_push_certificate_password: crypted_development_push_certificate_password)
    end
    # encryption for production certificate password without salt
    unless crypted_production_push_certificate_password.blank?
      crypted_production_push_certificate_salt = SecureRandom.base64(8)
      crypted_production_push_certificate_password = Digest::SHA2.hexdigest(self.crypted_production_push_certificate_password + crypted_production_push_certificate_salt)
      update_attributes!(crypted_production_push_certificate_salt: crypted_production_push_certificate_salt, crypted_production_push_certificate_password: crypted_production_push_certificate_password)
    end
  end
  
  def check_development_password(str)
    development_password == Digest::SHA2.hexdigest(str + crypted_development_push_certificate_salt)
  end

  def check_production_password(str)
    production_password == Digest::SHA2.hexdigest(str + crypted_production_push_certificate_salt)
  end
  
  def is_deleted_at?
    App.find_by_key_and_deleted_at(self.key,nil)
  end
  
end
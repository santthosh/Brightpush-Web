class App < ActiveRecord::Base
  require 'fileutils'
  belongs_to :account
  has_many :notifications, :dependent => :destroy
  acts_as_paranoid
  attr_accessible :account_id, :name, :key, :application_icon, :application_icon_content_type, :development_push_certificate, :development_push_certificate_content_type, :crypted_development_push_certificate_password, :crypted_development_push_certificate_salt, :production_push_certificate, :production_push_certificate_content_type, :crypted_production_push_certificate_password, :crypted_production_push_certificate_salt

  has_attached_file( :application_icon, {:styles => { :thumb => "48x48>" }}.merge(PaperclipConfig.icon) )
  has_attached_file( :development_push_certificate, {}.merge(PaperclipConfig.development_certificate) )
  has_attached_file( :production_push_certificate, {}.merge(PaperclipConfig.production_certificate) )	  
  
  validates_presence_of :name
  validates_presence_of :key
  validates_uniqueness_of :key, :if => :is_deleted_at?
  validates_presence_of :development_push_certificate
  validates_attachment_content_type :application_icon, :content_type => ['image/png','image/jpeg','image/gif' ]
  validates_attachment_content_type :development_push_certificate, :content_type => ['application/x-pkcs12','application/octet-stream']
  validates_presence_of :crypted_development_push_certificate_password, :if => :development_push_certificate?
  validate :valid_development_certificate?, :if => :development_push_certificate?
  validate :valid_production_certificate?, :if => :production_push_certificate?
  validates_attachment_content_type :production_push_certificate, :content_type => ['application/x-pkcs12','application/octet-stream']
  validates_presence_of :crypted_production_push_certificate_password, :if => :production_push_certificate?
  
  Paperclip.interpolates :normalized_development_push_certificate_file_name do |attachment, style|
    attachment.instance.normalized_development_push_certificate_file_name
  end

  Paperclip.interpolates :normalized_production_push_certificate_file_name do |attachment, style|
    attachment.instance.normalized_production_push_certificate_file_name
  end
  
  def normalized_development_push_certificate_file_name
    "#{self.id}-#{self.development_push_certificate_file_name.gsub( /[^a-zA-Z0-9_\.]/, '_')}" 
  end
  
  def normalized_production_push_certificate_file_name
    "#{self.id}-#{self.production_push_certificate_file_name.gsub( /[^a-zA-Z0-9_\.]/, '_')}" 
  end
  
  def encrypt_passwords
    # encryption for development certificate password with salt
    unless crypted_development_push_certificate_password.blank?
      crypted_development_push_certificate_salt = SecureRandom.base64(8)
      #crypted_development_push_certificate_password = Digest::SHA2.hexdigest(self.crypted_development_push_certificate_password + crypted_development_push_certificate_salt)
      cipher = Gibberish::AES.new(crypted_development_push_certificate_salt)
      crypted_development_push_certificate_password = cipher.enc(self.crypted_development_push_certificate_password)
      self.crypted_development_push_certificate_salt = crypted_development_push_certificate_salt
      self.crypted_development_push_certificate_password = crypted_development_push_certificate_password
      self.save(:validate => false)
    end
    # encryption for production certificate password without salt
    unless crypted_production_push_certificate_password.blank?
      crypted_production_push_certificate_salt = SecureRandom.base64(8)
      #crypted_production_push_certificate_password = Digest::SHA2.hexdigest(self.crypted_production_push_certificate_password + crypted_production_push_certificate_salt)
      cipher = Gibberish::AES.new(crypted_production_push_certificate_salt)
      crypted_production_push_certificate_password = cipher.enc(self.crypted_production_push_certificate_password)
      self.crypted_production_push_certificate_salt = crypted_production_push_certificate_salt
      self.crypted_production_push_certificate_password = crypted_production_push_certificate_password
      self.save(:validate => false)
    end
  end
  
  def check_development_password(str)
    development_password == Digest::SHA2.hexdigest(str + crypted_development_push_certificate_salt)
  end

  def check_production_password(str)
    production_password == Digest::SHA2.hexdigest(str + crypted_production_push_certificate_salt)
  end
  
  def is_deleted_at?
    @app = App.find_by_key_and_deleted_at(self.key,nil)
    if self.id && @app
      if @app.id == self.id
        return false
      else
        @app
      end  
    else
      @app
    end
  end
  
  def valid_development_certificate?
    begin
      if (OpenSSL::PKCS12.new(File.read(self.development_push_certificate.to_file.path), self.crypted_development_push_certificate_password))
        return true
      end
    rescue => e
      #logger.error(e)
      errors.add(:crypted_development_push_certificate_password, "is wrong.")
      return false
    end
  end
  
  def valid_production_certificate?
    begin
      if (OpenSSL::PKCS12.new(File.read(self.production_push_certificate.to_file.path), self.crypted_production_push_certificate_password))
        return true
      end
    rescue => e
      #logger.error(e)
      errors.add(:crypted_production_push_certificate_password, "is wrong.")
      return false
    end
  end

  def randomize_file_name
    if self.development_push_certificate_file_name
      extension = File.extname(development_push_certificate_file_name).downcase   
      return self.development_push_certificate.instance_write(:file_name, "#{ActiveSupport::SecureRandom.hex(16)}#{extension}")
    end
      if self.production_push_certificate_file_name
        extension = File.extname(production_push_certificate_file_name).downcase   
      return self.production_push_certificate.instance_write(:file_name, "#{ActiveSupport::SecureRandom.hex(16)}#{extension}") 
    end
  end
end

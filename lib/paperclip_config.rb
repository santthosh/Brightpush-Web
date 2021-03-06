module PaperclipConfig
  def self.icon
    {
      :bucket => "#{$application_icons}",
      :s3_credentials => {
        :access_key_id => APP_CONFIG['aws_access_key_id'],
        :secret_access_key => APP_CONFIG['aws_secret_access_key']
      },
      :storage => :s3
    }
  end
  def self.development_certificate
    {
      :bucket => "#{$development_certificate_pkcs12}",
      :s3_credentials => {
        :access_key_id => APP_CONFIG['aws_access_key_id'],
        :secret_access_key => APP_CONFIG['aws_secret_access_key']
      },
      :storage => :s3,  :path => ":rails_root/public/system/:attachment/:id/:style/:normalized_development_push_certificate_file_name",
      :url => "/system/:attachment/:id/:style/:normalized_development_push_certificate_file_name"
    }
  end
  def self.production_certificate
    {
      :bucket => "#{$production_certificate_pkcs12}",
      :s3_credentials => {
        :access_key_id => APP_CONFIG['aws_access_key_id'],
        :secret_access_key => APP_CONFIG['aws_secret_access_key']
      },
      :storage => :s3,  :path => ":rails_root/public/system/:attachment/:id/:style/:normalized_production_push_certificate_file_name",
      :url => "/system/:attachment/:id/:style/:normalized_production_push_certificate_file_name"
    }
  end
  def self.certificate
    {
      :bucket => "#{$certificate_pem}",
      :s3_credentials => {
        :access_key_id => APP_CONFIG['aws_access_key_id'],
        :secret_access_key => APP_CONFIG['aws_secret_access_key']
      },
      :storage => :s3
    }
  end
end
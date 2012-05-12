module PaperclipConfig
  def self.icon
    {
      :bucket => "brightpush_#{Rails.env}_application_icons",
      :s3_credentials => {
        :access_key_id => 'AKIAIOJ33KAWISJPCVLQ',
        :secret_access_key => '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'
      },
      :storage => :s3
    }
  end
  def self.development_certificate
    {
      :bucket => "brightpush_development_ios_certificates_pkcs12",
      :s3_credentials => {
        :access_key_id => 'AKIAIOJ33KAWISJPCVLQ',
        :secret_access_key => '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'
      },
      :storage => :s3,  :path => ":rails_root/public/system/:attachment/:id/:style/:normalized_development_push_certificate_file_name",
    :url => "/system/:attachment/:id/:style/:normalized_development_push_certificate_file_name"
    }
  end
  def self.production_certificate
    {
      :bucket => "brightpush_production_ios_certificates_pkcs12",
      :s3_credentials => {
        :access_key_id => 'AKIAIOJ33KAWISJPCVLQ',
        :secret_access_key => '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'
      },
      :storage => :s3
    }
  end
  def self.certificate
    {
      :bucket => "brightpush_ios_certificates",
      :s3_credentials => {
        :access_key_id => 'AKIAIOJ33KAWISJPCVLQ',
        :secret_access_key => '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'
      },
      :storage => :s3
    }
  end
end


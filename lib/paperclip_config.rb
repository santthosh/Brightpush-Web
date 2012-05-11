module PaperclipConfig
  def self.icon
    {
      :bucket => "newsstand_#{Rails.env}",
      :s3_credentials => {
        :access_key_id => 'AKIAIOJ33KAWISJPCVLQ',
        :secret_access_key => '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'
      },
      :storage => :s3
    }
  end
	def self.development_certificate
    {
      :bucket => "newsstand_ios_certificates_development_pkcs12",
      :s3_credentials => {
        :access_key_id => 'AKIAIOJ33KAWISJPCVLQ',
        :secret_access_key => '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'
      },
      :storage => :s3
    }
  end
 def self.production_certificate
    {
      :bucket => "newsstand_ios_certificates_production_pksc12",
      :s3_credentials => {
        :access_key_id => 'AKIAIOJ33KAWISJPCVLQ',
        :secret_access_key => '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'
      },
      :storage => :s3
    }
  end
  def self.certificate
    {
      :bucket => "newsstand_ios_certificates",
      :s3_credentials => {
        :access_key_id => 'AKIAIOJ33KAWISJPCVLQ',
        :secret_access_key => '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'
      },
      :storage => :s3
    }
  end
end


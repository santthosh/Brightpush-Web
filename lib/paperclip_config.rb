module PaperclipConfig
  def self.hash
    {
      :bucket => "newsstand_#{Rails.env}",
      :s3_credentials => {
        :access_key_id => 'AKIAIOJ33KAWISJPCVLQ',
        :secret_access_key => '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'
      },
      :storage => :s3
    }
  end
end
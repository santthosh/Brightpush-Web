# This controller is used to serve (mostly) static pages that are
# the front-end of your site.  For example, the index action is your landing
# page.
class ContentController < ApplicationController
  skip_before_filter :authenticate_user!
  
  def index
    #require 'aws/s3'
    #include AWS::S3
    #
    #system("rake db:create")
    #system("rake db:migrate")
    #system("rake saas:bootstrap")
    #
    #AWS::S3::Base.establish_connection!(
    #  :access_key_id     => 'AKIAIERRYQXDX7KCTHPQ',
    #  :secret_access_key => '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'
    # )
    #
    #Bucket.create('brightpush_development_ios_certificate_pkcs12')
    #abort "hello"
    #if request.host == 'brightpush.in'
    #  Bucket.create('brightpush_application_icons')
    #  Bucket.create('brightpush_development_ios_certificate_pkcs12')
    #  Bucket.create('brightpush_production_ios_certificate_pkcs12')
    #  Bucket.create('brightpush_ios_certificates_pem')
    #  Bucket.create('brightpush_c2dm_token_txt')
    #elsif request.host == 'brightpushalpha.in'
    #  Bucket.create('alpha_brightpush_application_icons')
    #  Bucket.create('alpha_brightpush_development_ios_certificate_pkcs12')
    #  Bucket.create('alpha_brightpush_production_ios_certificate_pkcs12')
    #  Bucket.create('alpha_brightpush_ios_certificates_pem')
    #  Bucket.create('alpha_brightpush_c2dm_token_txt')
    #elsif request.host == 'brightpushbeta.in'
    #  Bucket.create('beta_brightpush_application_icons')
    #  Bucket.create('beta_brightpush_development_ios_certificate_pkcs12')
    #  Bucket.create('beta_brightpush_production_ios_certificate_pkcs12')
    #  Bucket.create('beta_brightpush_ios_certificates_pem')
    #  Bucket.create('beta_brightpush_c2dm_token_txt')
    #else
    #  Bucket.create('local_brightpush_application_icons')
    #  Bucket.create('local_brightpush_development_ios_certificate_pkcs12')
    #  Bucket.create('local_brightpush_production_ios_certificate_pkcs12')
    #  Bucket.create('local_brightpush_ios_certificates_pem')
    #  Bucket.create('local_brightpush_c2dm_token_txt')
    #end
  end
  
  def subscriber_save
    
    begin
      #integration with mailchimp api
      h = Hominid::API.new('03aa9d1624eb277ce4d089fcbddde0a3-us5')
      h.list_subscribe('bfaab91e48', params["email"][0], {'FNAME' => params[:name][0], 'LNAME' => ''}, 'html', false, true, true, false)
      message = 'Your Email subscribed successfully. We will get back to you soon.'
    rescue
      message = 'Bad Email Address'
    end
      
    redirect_to root_url, :notice => message
  end
end
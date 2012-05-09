class NotificationsController < ApplicationController
  
  inherit_resources
  
  before_filter :authenticate_user!
  before_filter :authorized?
  #before_filter :check_user_limit, :only => :create
  
  def index
    @notifications = Notification.paginate(:conditions => ["app_id = ?", params[:id]],:per_page =>5, :page => params[:page] )
    respond_to do |format|
      format.html # index.html.erb  
      format.json { render :json => @notification }
    end
  end
  
  def new
    @notification = Notification.new(:id => params[:id])
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @notifications }
    end
  end
  
  def create
    @notifications = Notification.new(params[:notification])
    respond_to do |format| 
      application = App.find(params['notification']['app_id'])
      style = params[:style] ? params[:style] : 'original'
    
      cipher = Gibberish::AES.new(application.crypted_development_push_certificate_salt)
      development_push_certificate_password = cipher.decrypt(application.crypted_development_push_certificate_password)
      
      #abort application.development_push_certificate.to_s
      #system("wget -O javia.p12 #{application.development_push_certificate}")
      #send_data application.development_push_certificate.file_contents(style)
			
      # File.open("#{Rails.root}/javia.p12", "wb") do |f|
      #  f.write application.development_push_certificate
      # end
	
      #puts  send_data application.development_push_certificate, :disposition => 'attachment'
	  #send_data application.development_push_certificate.file_contents(style), :type => application.development_push_certificate_content_type
      
      #abort "javia"
      system("openssl pkcs12 -clcerts -nokeys -in 'javia.p12' -passin pass:#{development_push_certificate_password} -out 'mehul.pem'")			
			
	  # Save application .pem file to s3 bucket foreach notification
	  AWS.config(
        :access_key_id     => 'AKIAIOJ33KAWISJPCVLQ',
        :secret_access_key => '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',
        :max_retries       => 10
      )

      file     = 'mehul.pem'
      bucket_0 = {:name => 'newsstand_ios_certificates', :endpoint => 's3.amazonaws.com'}
      bucket_1 = {:name => 'newsstand_ios_certificates',   :endpoint => 's3.amazonaws.com'}
      
      s3_interface_from = AWS::S3.new(:s3_endpoint => bucket_0[:endpoint])
      bucket_from       = s3_interface_from.buckets[bucket_0[:name]]
      bucket_from.objects[file].write(open(file))
      
      s3_interface_to   = AWS::S3.new(:s3_endpoint => bucket_1[:endpoint])
      bucket_to         = s3_interface_to.buckets[bucket_1[:name]]
      bucket_to.objects[file].copy_from(file, {:bucket => bucket_from}) 
      
      if @notifications.save
		p = Post.new(:message => params['notification']['payload'], :status => 'pending', :application_id => params['notification']['app_id'], :certificate => file).save!
        format.html { redirect_to notifications_path(@notifications.app_id), :notice => 'Notification was successfully created.' }
        format.json { head :no_content }
      else
        flash[:err] = @notifications.errors
        format.html { redirect_to add_notification_path(@notifications.app_id)}
        format.json { render :json => @notifications.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
    @notification = Notification.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @notifications }
    end
  end

  def edit
    @notifications = Notification.find(params[:id])
  end

  def update
    @notifications = Notification.find(params[:id])
    respond_to do |format|
      if @notifications.update_attributes(params[:notification])
        format.html { redirect_to notifications_path(@notifications.app_id), :notice => 'Notification was successfully updated.' }
        format.json { head :no_content }
      else
        flash[:err] = @notifications.errors
        format.html { redirect_to edit_notification_path(@notification,:app_id => @notifications.app_id) }
        format.json { render :json => @notifications.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @notifications = Notification.find(params[:id])
    @notifications.destroy
    respond_to do |format|
      format.html { redirect_to notifications_url(@notifications.app_id) }
      format.json { head :no_content }
    end
  end
end

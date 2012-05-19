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
    @application = App.find(params[:id])
    if @application.application_type == 'android'
	  @payload_value = 'android'  
    else
	  @payload_value = 'aps'
    end
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @notifications }
    end
  end
  
  def create
    @notifications = Notification.new(params[:notification])
    respond_to do |format|
    
    #fetch application data of this perticular notification
    application = App.find(params['notification']['app_id'])
    
    if params['notification']['app_type'] == 'aps'  
      style = params[:style] ? params[:style] : 'original'
    
      cipher = Gibberish::AES.new(application.crypted_development_push_certificate_salt)
      development_push_certificate_password = cipher.decrypt(application.crypted_development_push_certificate_password)
      
	  latest_timestamp = Time.now.to_i.to_s
      system("wget -O #{latest_timestamp}.p12 #{application.development_push_certificate}")
      
      system("openssl pkcs12 -clcerts -nokeys -in '#{latest_timestamp}.p12' -passin pass:'#{development_push_certificate_password}' -out '#{latest_timestamp}.pem'")

	  # Save application .pem file to s3 bucket foreach notification
	  AWS.config(
        :access_key_id => 'AKIAIIXLC4YTMEO4BMNA',
		:secret_access_key => '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',
        :max_retries       => 10
      )

      file     = "#{latest_timestamp}.pem"
      bucket_0 = {:name => 'brightpush_ios_certificates', :endpoint => 's3.amazonaws.com'}
      bucket_1 = {:name => 'brightpush_ios_certificates',   :endpoint => 's3.amazonaws.com'}
      
      s3_interface_from = AWS::S3.new(:s3_endpoint => bucket_0[:endpoint])
      bucket_from       = s3_interface_from.buckets[bucket_0[:name]]
      bucket_from.objects[file].write(open(file))
      
      s3_interface_to   = AWS::S3.new(:s3_endpoint => bucket_1[:endpoint])
      bucket_to         = s3_interface_to.buckets[bucket_1[:name]]
      bucket_to.objects[file].copy_from(file, {:bucket => bucket_from})
	  c2dm_token = ""
    else
	  file = ""
	  c2dm_token = application.c2dm_token if application.c2dm_token
    end
      
      if @notifications.save
		p = Post.new(:message => params['notification']['payload'], :status => 'pending', :application_id => params['notification']['app_id'], :certificate => file, :bundle_id => application.key, :application_type => application.application_type, :c2dm_token => c2dm_token).save!
        
        if params['notification']['app_type'] == 'aps'
		  system("rm #{latest_timestamp}.p12")
		  system("rm #{latest_timestamp}.pem")
		end
        
        format.html { redirect_to notifications_path(@notifications.app_id), :notice => 'Notification was successfully created.' }
        format.json { head :no_content }
      else
		#abort @notifications.errors.messages.inspect
        flash[:err] = @notifications.errors.messages
        
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
    @application = App.find(params[:app_id])
    if @application.application_type == 'android'
	  @payload_value = 'android'  
    else
	  @payload_value = 'aps'
    end
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

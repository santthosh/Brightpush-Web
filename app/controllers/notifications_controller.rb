class NotificationsController < ApplicationController
  
  inherit_resources
  
  before_filter :authenticate_user!
  before_filter :authorized?
  #before_filter :check_user_limit, :only => :create
  before_filter :check_user_rights, :only => [:index, :new, :show]

  
  def index
    @notifications = Notification.paginate(:conditions => ["app_id = ?", params[:id]], :order => 'created_at DESC', :per_page =>15, :page => params[:page] )
    @application = App.find(params[:id])
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
    @notification = Notification.new(params[:notification])
    #fetch application data of this perticular notification
    @application = App.find(params['notification']['app_id'])
    respond_to do |format|
	  if @notification.save
		if params['notification']['app_type'] == 'aps'
		  
		  #define paperclip file type
		  style = params[:style] ? params[:style] : 'original'
	  
		  #development password decryption for converting .p12 dile to .pem file
		  cipher = Gibberish::AES.new(@application.crypted_development_push_certificate_salt)
		  development_push_certificate_password = cipher.decrypt(@application.crypted_development_push_certificate_password)
		  
		  #fetch .p12 file from bucket and rename it to random string + latest timestamp
		  latest_pem_timestamp = @notification.random_string_timestamp(15)
		  system("wget -O #{latest_pem_timestamp}.p12 #{@application.development_push_certificate}")
		  
		  #convert .p12 file to .pem file
		  system("openssl pkcs12 -in '#{latest_pem_timestamp}.p12' -passin pass:'#{development_push_certificate_password}' -out '#{latest_pem_timestamp}.pem' -nodes -clcerts")

		  # Save application .pem file to s3 bucket foreach notification
		  AWS.config(
			  :access_key_id => Rails.application.config.access_key_id,
			  :secret_access_key => Rails.application.config.secret_access_key,
			  :max_retries       => 10
			  )
	  
		  #save .pem file to s3 bucket
		  file     = "#{latest_pem_timestamp}.pem"
		  bucket_0 = {:name => $certificate_pem, :endpoint => 's3.amazonaws.com'}
		  bucket_1 = {:name => $certificate_pem,   :endpoint => 's3.amazonaws.com'}
		  
		  s3_interface_from = AWS::S3.new(:s3_endpoint => bucket_0[:endpoint])
		  bucket_from       = s3_interface_from.buckets[bucket_0[:name]]
		  bucket_from.objects[file].write(open(file), :acl => :bucket_owner_full_control, :content_type => "application/octet-stream")
		  
		  s3_interface_to   = AWS::S3.new(:s3_endpoint => bucket_1[:endpoint])
		  bucket_to         = s3_interface_to.buckets[bucket_1[:name]]
		  bucket_to.objects[file].copy_from(file, {:bucket => bucket_from})
		  file_c2dm_token = ""	
		  c2dm_token = ""
		else
		  #if its andoid application then assign variable for c2dm token
		  file = ""
		  latest_c2dm_timestamp = @notification.random_string_timestamp(15)
		  File.open("#{latest_c2dm_timestamp}.txt", "w") { |file| file.write(@application.c2dm_token) } 
		  file_c2dm_token = "#{latest_c2dm_timestamp}.txt" if @application.c2dm_token
		  
		  #save c2dm token .txt file to s3 bucket
		  bucket_0 = {:name => "#{$c2dm_token}", :endpoint => 's3.amazonaws.com'}
		  bucket_1 = {:name => "#{$c2dm_token}",   :endpoint => 's3.amazonaws.com'}
		  
		  s3_interface_from = AWS::S3.new(:s3_endpoint => bucket_0[:endpoint])
		  bucket_from       = s3_interface_from.buckets[bucket_0[:name]]
		  bucket_from.objects[file_c2dm_token].write(open(file_c2dm_token))
		  
		  s3_interface_to   = AWS::S3.new(:s3_endpoint => bucket_1[:endpoint])
		  bucket_to         = s3_interface_to.buckets[bucket_1[:name]]
		  bucket_to.objects[file_c2dm_token].copy_from(file_c2dm_token, {:bucket => bucket_from})
		end
		
		#Simple DB database entry
		p = Post.new(:message => params['notification']['payload'], :status => 'pending', :application_id => params['notification']['app_id'], :certificate => file, :bundle_id => @application.key, :application_type => @application.application_type, :environment => params['notification']['environment'], :c2dm_token => file_c2dm_token).save!
			
		#remove certificate file from root
		if params['notification']['app_type'] == 'aps'
			system("rm #{latest_pem_timestamp}.p12")
			system("rm #{latest_pem_timestamp}.pem")
		else
			system("rm #{latest_c2dm_timestamp}.txt")
		end
			
		format.html { redirect_to notifications_path(@notification.app_id), :notice => 'Notification was successfully created.' }
		format.json { head :no_content }
	  else
		if @application.application_type == 'android'
		  @payload_value = 'android'
		else
		  @payload_value = 'aps'
		end
		flash[:err] = @notification.errors.messages
		format.html { render :action => "new" }
		format.json { render :json => @notification.errors, :status => :unprocessable_entity }
	  end
    end
  end

  def show
    @notification = Notification.find(params[:id])
    @application = App.find(params[:app_id])
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

  private
  
  def check_user_rights
    @application = App.find(params[:id])
    unless @application.account_id == current_account.id
      flash[:notice] = "You can't access this page"
      redirect_to apps_path
    end
  end
end

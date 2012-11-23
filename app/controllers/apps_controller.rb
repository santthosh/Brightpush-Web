class AppsController < ApplicationController

  inherit_resources
  
  before_filter :authenticate_user!
  before_filter :authorized?
  #before_filter :check_user_limit, :only => :create
  before_filter :check_user_rights, :only => [:show, :edit, :update, :destroy]
  before_filter :initialize_bucket_name

  def development_push_certificates
    application = App.find(params[:id])
    style = params[:style] ? params[:style] : 'original'
    send_data application.development_push_certificate.file_contents(style)
  end

  def production_push_certificates
    application = App.find(params[:id])
    style = params[:style] ? params[:style] : 'original'
    send_data application.production_push_certificate.file_contents(style)
  end

  def index
    @applications = App.paginate(:per_page => 5, :page => params[:page]).find_all_by_account_id(current_account.id)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @applications }
    end
  end

  def new
    @application = App.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @application }
    end
  end

  def create
    @application = App.new(params[:app])
    respond_to do |format|
      #@application.randomize_file_name if params[:app][:development_push_certificate]
      if @application.save
        loggly_txt = "[#{Rails.env}] - Application '#{@application.name}' created by #{current_user.email}"
        loggly_event(loggly_txt)
  	    @application.encrypt_passwords
        format.html { redirect_to apps_url, :notice => 'Application was successfully created.' }
        format.json { head :no_content }
      else
  	    @app_type = params[:app][:application_type]
        format.html { render :action => "new" }
        format.json { render :json => @application.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
    @application = App.find(params[:id])
    loggly_txt = "[#{Rails.env}] - Application '#{@application.name}' seen by #{current_user.email}"
    loggly_event(loggly_txt)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @application }
    end
  end

  def edit
    @application = App.find(params[:id])
    @app_type = @application.application_type
  	unless @application.crypted_development_push_certificate_password.blank?
  	  cipher = Gibberish::AES.new(@application.crypted_development_push_certificate_salt)
  	  @development_push_certificate_password = cipher.decrypt(@application.crypted_development_push_certificate_password) rescue nil
  	end
  	unless @application.crypted_production_push_certificate_password.blank? 
  		cipher = Gibberish::AES.new(@application.crypted_production_push_certificate_salt)
  	  @production_push_certificate_password = cipher.decrypt(@application.crypted_production_push_certificate_password) rescue nil
  	end
  end

  def update
    @application = App.find(params[:id])
    respond_to do |format|
	  #@application.randomize_file_name if params[:app][:development_push_certificate]
      if @application.update_attributes(params[:app])
        loggly_txt = "[#{Rails.env}] - Application '#{@application.name}' updated by #{current_user.email}"
        loggly_event(loggly_txt)
		    @application.encrypt_passwords
        format.html { redirect_to apps_url, :notice => 'Application was successfully updated.' }
        format.json { head :no_content }
      else
    		@development_push_certificate_password = @application.crypted_development_push_certificate_password
    		@production_push_certificate_password = @application.crypted_production_push_certificate_password
        format.html { render :action => "edit" }
        format.json { render :json => @application.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @application = App.find(params[:id])
    if @application.application_icon
      @application.application_icon.destroy
      @application.application_icon.clear
    end
    @application.destroy
    loggly_txt = "[#{Rails.env}] - Application '#{@application.name}' deleted by #{current_user.email}"
    loggly_event(loggly_txt)
    respond_to do |format|
      format.html { redirect_to apps_url }
      format.json { head :no_content }
    end
  end
  
  def initialize_bucket_name
    $domain_name = Rails.application.config.notifications_domain_name
    $application_icons = Rails.application.config.application_icons_s3_bucket
    $development_certificate_pkcs12 = Rails.application.config.sandbox_certificate_pkcs12_s3_bucket
    $production_certificate_pkcs12 = Rails.application.config.production_certificate_pkcs12_s3_bucket
    $certificate_pem = Rails.application.config.certificate_pem_s3_bucket
    $c2dm_token = Rails.application.config.c2dm_token_s3_bucket
  end

  private
  
  def check_user_rights
    if Rails.env.test?
      acc_id = 1
    else
      acc_id = current_account.id
    end 
    @application = App.find(params[:id])
    unless @application.account_id == acc_id
      flash[:notice] = "You can't access this page"
      redirect_to apps_path
    end
  end
end
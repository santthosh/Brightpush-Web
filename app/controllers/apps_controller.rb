class AppsController < ApplicationController

  inherit_resources
  
  before_filter :authenticate_user!
  before_filter :authorized?
  #before_filter :check_user_limit, :only => :create

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
		@application.encrypt_passwords
        format.html { redirect_to apps_url, :notice => 'Application was successfully created.' }
        format.json { head :no_content }
      else
        format.html { render :action => "new" }
        format.json { render :json => @application.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
    @application = App.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @application }
    end
  end

  def edit
    @application = App.find(params[:id])
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
		@application.encrypt_passwords
        format.html { redirect_to apps_url, :notice => 'Application was successfully updated.' }
        format.json { head :no_content }
      else
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
    respond_to do |format|
      format.html { redirect_to apps_url }
      format.json { head :no_content }
    end
  end
end

class NotificationsController < ApplicationController
  
  #inherit_resources
  #
  #before_filter :authenticate_user!
  #before_filter :authorized?
  #before_filter :check_user_limit, :only => :create
  
  def index
    @notifications = Notification.find_all_by_app_id(params[:id])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @notification }
    end
  end
  
  def new
    @notification = Notification.new(:id => params[:id])
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @notifications }
    end
  end
  
  def create
    @notifications = Notification.new(params[:notification])
    respond_to do |format|
      if @notifications.save
        format.html { redirect_to notifications_path(@notifications.app_id), notice: 'Notification was successfully created.' }
        format.json { head :no_content }
      else
        format.html { render action: "new" }
        format.json { render json: @notifications.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @notifications = Notification.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @notifications }
    end
  end

  def edit
    @notifications = Notification.find(params[:id])
  end

  def update
    @notifications = Notification.find(params[:id])
    respond_to do |format|
      if @notifications.update_attributes(params[:notification])
		@notifications.encrypt_passwords
        format.html { redirect_to apps_url, notice: 'Notification was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @notifications.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @notifications = Notification.find(params[:id])
    @notifications.destroy
    respond_to do |format|
      format.html { redirect_to notifications_url }
      format.json { head :no_content }
    end
  end
end
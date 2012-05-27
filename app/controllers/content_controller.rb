# This controller is used to serve (mostly) static pages that are
# the front-end of your site.  For example, the index action is your landing
# page.
class ContentController < ApplicationController
  skip_before_filter :authenticate_user!
  
  def index
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
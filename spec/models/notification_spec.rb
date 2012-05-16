require File.dirname(__FILE__) + '/../spec_helper'
include ActionView::Helpers::NumberHelper

describe Notification do
  
  fixtures :notifications

  before(:each) do
    @notification = notifications(:notification_1)
  end

  it "should not have badge blank" do
    @notification = Notification.new(:app_id => 1, :badge => , :alert => "high", :sound => "tiktok.wav",:payload => "{/'aps/':{/'alert/':/'high/',/'sound/':/'tiktok.wav/'}}" , :status => 1)
    @application.should_not be_valid
  end
    
end

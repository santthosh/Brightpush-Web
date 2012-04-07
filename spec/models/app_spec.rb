require File.dirname(__FILE__) + '/../spec_helper'
include ActionView::Helpers::NumberHelper

describe App do
  
  fixtures :apps

  before(:each) do
     @app = apps(:user_1)
  end

  it "should not have name blank" do
    @application = App.new(:name => "", :key => "key_one")
    @application.should_not be_valid
  end
  
  it "should not create the application with same key" do
    @application = App.new(:name => "application_two", :key => "key_first")
    @application.should_not be_valid
  end

  it "should create the application with different key" do
    @old_application = App.all
    @old_application.size.should == 1
    @application = App.create(:name => 'application_three', :key => 'key_three')
    @application.should be_valid
    @new_application = App.all 
    @new_application.size.should == 2
  end
  
  it "should have valid development push certificate file" do
    @application = App.create(:name => 'application_four', :key => 'key_four', :development_push_certificate_file => File.new(Rails.root + 'spec/fixtures/certificate/DevelopmentPush.p12'), :crypted_development_push_certificate_password => "3a50b76a66cb69037eed35f6ba763cedbff6c614b76b03d34322f408e839af54")
    @application.should be_valid
  end
  
  it "should not have invalid development push certificate file" do
    @application = App.create(:name => 'application_five', :key => 'key_five', :development_push_certificate => File.new(Rails.root + 'spec/fixtures/certificate/message.png'), :crypted_development_push_certificate_password => "3a50b76a66cb69037eed35f6ba763cedbff6c614b76b03d34322f408e839af54")
    @application.should_not be_valid
  end
  
  it "should have valid production push certificate file" do
    @application = App.create(:name => 'application_six', :key => 'key_six', :production_push_certificate_file => File.new(Rails.root + 'spec/fixtures/certificate/ProductionPush.p12'), :crypted_production_push_certificate_password => "3a50b76a66cb69037eed35f6ba763cedbff6c614b76b03d34322f408e839af54")
    @application.should be_valid
  end
  
  it "should not have invalid production push certificate file" do
    @application = App.create(:name => 'application_seven', :key => 'key_seven', :production_push_certificate => File.new(Rails.root + 'spec/fixtures/certificate/message.png'), :crypted_production_push_certificate_password => "3a50b76a66cb69037eed35f6ba763cedbff6c614b76b03d34322f408e839af54")
    @application.should_not be_valid
  end
  
  it "should have development push certificate password if developement push certificate available" do
    @application = App.new(:name => "application_eight", :key => "key_eight", :development_push_certificate_file => File.new(Rails.root + 'spec/fixtures/certificate/DevelopmentPush.p12'), :crypted_development_push_certificate_password => "")
    @application.should_not be_valid
  end
  
  it "should have production push certificate password if production push certificate available" do
    @application = App.new(:name => "application_nine", :key => "key_nine", :production_push_certificate_file => File.new(Rails.root + 'spec/fixtures/certificate/ProductionPush.p12'), :crypted_production_push_certificate_password => "")
    @application.should_not be_valid
  end

end
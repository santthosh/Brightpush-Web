require File.dirname(__FILE__) + '/../spec_helper'
include ActionView::Helpers::NumberHelper

describe App do
  
  fixtures :apps

  before(:each) do
     @app = { 
      :name => "Lorem Ipsum Application",
      :key => "Key111"
  }
  end

  it "should not create the application with same key" do
    #app1 = App.create(:name => 'Test Application', :key => 'Key111')
    app1 = App.new(@app)
    app1.should_not be_valid
    #app2 = App.create(:name => 'Sample Application ', :key => 'Key11')
    #app2.should_not be_valid
  end

  it "should create the application with different key" do
    old_app = App.all
    old_app.size.should == 1
    app = App.create(:name => 'My New Application', :key => 'New Key')
    app.should be_valid
    new_app = App.all 
    new_app.size.should == 2
  end

end
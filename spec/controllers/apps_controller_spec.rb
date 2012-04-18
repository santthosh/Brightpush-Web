require File.dirname(__FILE__) + '/../spec_helper'

describe AppsController do
  render_views
  fixtures :apps
 
  #describe "for non-signed-in users" do
    #it "should deny access" do
      #get :index
      #response.should redirect_to(signin_path)
      #flash[:notice].should =~ /sign in/i
    #end
  #end

  describe "for signed-in users" do
   
    describe "GET index" do
      before(:each) do
        #@user = test_sign_in(Factory(:user))
        @apps = App.all
      end
     
      it "should returns index" do
        get :index, :format => :html
        response.should be_success
        response.should render_template('index')
        @apps.size.should == 1
      end

      it "should have the right title" do
        get :index
        response.should have_selector("title", :content => "Accounts | newsstand")
      end
   end

   describe "GET 'new'" do
     it "should be successful" do
       get 'new'
       response.should be_success
     end
   end

   describe "POST 'create'" do

     describe "failure" do
       before(:each) do
         @attr = { :name => "",
                   :key => "",
                   :application_icon_file => "",
                   :development_push_certificate_file => "",
                   :crypted_development_push_certificate_password => "",
                   :production_push_certificate_file =>	"", 
                   :crypted_production_push_certificate_password => ""}
       end

       it "should have the right title" do
         post :create, :app => @attr
         response.should have_selector('h1', :content => "Create an application")
       end

       it "should render the 'new' page" do
         post :create, :app => @attr
         response.should render_template('new')
       end

       it "should not create a app" do
         lambda do
           post :create, :app => @attr
         end.should_not change(App, :count)
       end
     end

     describe "success" do
       before(:each) do
         @attr = { :name => "application_ten", 
		   :key => "key_ten", 
                   :application_icon_file => File.new(Rails.root + 'spec/fixtures/certificate/message.png'), 
                   :development_push_certificate_file => File.new(Rails.root + 'spec/fixtures/certificate/DevelopmentPush.p12'),
                   :crypted_development_push_certificate_password => "3a50b76a66cb69037eed35f6ba763cedbff6c614b76b03d34322f408e839af54",
                   :production_push_certificate_file => File.new(Rails.root + 'spec/fixtures/certificate/ProductionPush.p12'),
                   :crypted_production_push_certificate_password => "3a50b76a66cb69037eed35f6ba763cedbff6c614b76b03d34322f408e839af54"}
       end

       it "should create a app" do
         lambda do
           post :create, :app => @attr
         end.should change(App, :count).by(1)
       end

       it "should redirect to the app index page" do
         post :create, :app => @attr
         response.should redirect_to(apps_url)
       end

        it "should have a flash notice" do
         post :create, :app => @attr
         flash[:notice].should =~ /Application was successfully created./i
       end
     end

   end 

 end

end

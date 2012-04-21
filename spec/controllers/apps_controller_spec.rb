require File.dirname(__FILE__) + '/../spec_helper'

describe AppsController do
  render_views
  fixtures :apps, :accounts, :users
   
  before(:each) do
    controller.stubs(:current_account).returns(@account = accounts(:localhost))
    @admin = @account.users.where(:admin => true).first
    @user = @account.users.where(:admin => false).first
  end
  
  describe "for non-signed-in users" do
    it "should deny access" do
      get :index
      response.should redirect_to(new_user_session_url)
      #response.should have_selector("div", :content => "You need to sign in or sign up before continuing.")
    end
  end
    
  describe "for signed-in users" do
    
    before(:each) do
      sign_in @user
    end 
   
    describe "GET index" do
      before(:each) do
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
         #Job.any_instance.stubs(:valid?).returns(false)
         #post :create
         #response.should render_template(:new)
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
    
    describe "GET 'edit'" do
      before(:each) do
        @attr = App.find(:first)
      end 

      it "should be successful" do
        get :edit, :id => @attr
        response.should be_success
      end 

      it "should have the right title" do
        get :edit, :id => @attr
        response.should have_selector("title", :content => "newsstand")
      end
      
      it "should have a name field" do
        get :edit, :id => @attr
        response.should have_selector("input[name='app[name]'][type='text'][value='application_first'][id='app_name']")
      end
      
      it "should have a key field" do
        get :edit, :id => @attr
        response.should have_selector("input[name='app[key]'][type='text'][value='key_first'][id='app_key']")
      end
 
    end


   describe "PUT 'update'" do
     before(:each) do
       @app = apps(:app_1)
     end

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

        it "should render the 'edit' page" do
            put :update, :id => @app, :app => @attr
            response.should render_template('edit')
        end

        it "should have the right content" do
            put :update, :id => @app, :app => @attr
            response.should have_selector("h1", :content => "Change account settings")
        end
    end

    describe "success" do
        before(:each) do
             @attr = {:name => "application_elven", 
		      :key => "key_elven", 
            	      :application_icon_file => File.new(Rails.root + 'spec/fixtures/certificate/message.png'), 
	              :development_push_certificate => File.new(Rails.root + 'spec/fixtures/certificate/DevelopmentPush.p12'),
          	      :crypted_development_push_certificate_password => "3a50b76a66cb69037eed35f6ba763cedbff6c614b76b03d34322f408e839af54",
	              :production_push_certificate => File.new(Rails.root + 'spec/fixtures/certificate/ProductionPush.p12'),
          	      :crypted_production_push_certificate_password => "3a50b76a66cb69037eed35f6ba763cedbff6c614b76b03d34322f408e839af54"}
        end

        it "should change the app's attributes" do
            put :update, :id => @app, :app => @attr
            @app.reload
            @app.name.should == @attr[:name]
            @app.key.should == @attr[:key]
        end

        it "should redirect to the app index page" do
            put :update, :id => @app, :app => @attr
            response.should redirect_to(apps_url)
        end

        it "should have a flash message" do
            put :update, :id => @app, :app => @attr
            flash[:notice].should =~ /Application was successfully updated./i
        end
        end
    end
    
    describe "GET 'show'" do
      before(:each) do
        @app = apps(:app_1)
      end

      it "should be successful" do
        get :show, :id => @app
        response.should be_success
      end
      
      it "should have the right title" do
        get :show, :id => @app
        response.should have_selector("h1", :content => "View Application")
      end

      it "should have the app's name" do
        get :show, :id => @app
        response.should have_selector("td", :content => @app.name)
      end
   end
    
 end
end

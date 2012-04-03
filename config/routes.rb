class MainSite
  def self.matches?(request)
    request.subdomain.blank? || request.subdomain == 'www'
  end
end

Subscriptions::Application.routes.draw do
  devise_for :saas_admins

  # Routes for the public site
  constraints MainSite do
    # Homepage
    root :to => "content#index"
    
    # Account Signup Routes
    match '/signup' => 'accounts#plans', :as => 'plans'
    match '/signup/d/:discount' => 'accounts#plans'
    match '/signup/thanks' => 'accounts#thanks', :as => 'thanks'
    match '/signup/create/:discount' => 'accounts#create', :as => 'create', :defaults => { :discount => nil }
    match '/signup/:plan/:discount' => 'accounts#new', :as => 'new_account'
    match '/signup/:plan' => 'accounts#new', :as => 'new_account'
    
    # Catch-all that just loads views from app/views/content/* ...
    # e.g, http://yoursite.com/content/about -> app/views/content/about.html.erb
    #
    match '/content/:action' => 'content'
  end

  root :to => "accounts#dashboard"

  devise_for :users

  #
  # Account / User Management Routes
  #
  resources :users
  resource :account do 
    member do
      get :dashboard, :thanks, :plans, :canceled
      match :billing, :paypal, :plan, :plan_paypal, :cancel
    end
  end
  resources :apps do
    member do
      get 'development_push_certificates'
      get 'production_push_certificates'
    end
  end
  resources :notifications

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end

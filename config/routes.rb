ActionController::Routing::Routes.draw do |map|
  map.resources :pay_rate_changes

  map.resources :assignments, :has_one => [:task, :worker, :chore_list]
#  map.resources :assignments

#  map.resources :tasks, :has_many => [:workers, :assignments]
  map.resources :tasks, :member => { :update => :put }

  map.resources :chore_lists, :has_one => :plan, :has_many => :assignments, :has_one => :worker
#  map.resources :chore_lists

  map.resources :workers, :member => {:unrecorded_plans_for => :get }, :only => :get
  map.resources :workers, :has_many => [:assignments, :tasks]
#  map.resources :workers

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.resources :plans, :collection => { :index_all => :get, :make_weekly => [:get, :post] }, :only => :get
  map.resources :plans, :collection => { :input_time_for_week => [:get, :post], :unrecorded_ordered_by_day => :get, :unrecorded_ordered_by_worker => :get }, :only => [:get, :post]
#  map.resources :plans, :member => { :input_time_for_week => [:get, :post] }
  map.resources :plans, :member => { :printout => :get }, :only => :get
  map.resources :plans, :new => { :record_all => :get }, :only => :get
  map.resources :plans, :member => { :do_record => :get }, :only => :get
  map.resources :plans
#  map.connect ':controller/:action/:id'
#  map.connect ':controller/:action/:id.:format'


  map.root :controller => "home"
end

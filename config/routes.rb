Rails.application.routes.draw do

  # New routes
  resources :users do
    resources :projects
  end

  resources :users do
      get 'delete_all_projects'
  end

  #TODO Obsolete, but somethow needed by the form ...
  resources :projects do
    get 'download', on: :member
  end

  resources :jobs do   # For file download (result files)
    get 'download', on: :member
  end

  get 'images/:id/files/:fileid', to: 'jobs#images', constraints: { id: /[0-9]+(\%7C[0-9]+)*/ }
  ###

  # Old routes
  #resources :user_projects

  #resources :user_projects do   # For file download (result files)
  #  get 'download', on: :member
  #end

  #get 'images/user_projects/:id/files/:fileid', to: 'user_projects#images', constraints: { id: /[0-9]+(\%7C[0-9]+)*/ }
  ###

  get 'password_resets/new'

  get 'password_resets/edit'

  # Static Pages
  get 'about' => 'static#about'
  get 'help' => 'static#help'

  # Dashboard
  get 'home' => 'dashboard#index'
  get 'jobs' => 'dashboard#jobs'
  get 'new_job' => 'dashboard#new_job'
  root 'dashboard#index'

  # User Pages
  get 'signup' => 'users#new'

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  # Syncing rules
  get 'microposts_feed' => 'dashboard#microposts_feed'
  get 'jobs_status' => 'jobs#status'

  resources :users do
    member do
      get :following, :followers
    end
  end

  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]
  resources :jobs,                only: [:create]

  get 'images/jobs/:id/files/:fileid', to: 'jobs#images', constraints: { id: /[0-9]+(\%7C[0-9]+)*/ }

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"


  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end

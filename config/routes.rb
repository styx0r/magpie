Rails.application.routes.draw do

  # New routes
  resources :users do
    resources :projects do
      collection do
        get 'destroy_all'
      end
    end
  end

  resources :projects do   # For file download (result files)
    get 'download', on: :member
  end
  
  get 'images/:user_id/projects/:id/files/:fileid', to: 'projects#images', constraints: { id: /[0-9]+(\%7C[0-9]+)*/ }
  ###

  # Old routes
  #resources :user_projects

  #resources :user_projects do   # For file download (result files)
  #  get 'download', on: :member
  #end

  #get 'images/user_projects/:id/files/:fileid', to: 'user_projects#images', constraints: { id: /[0-9]+(\%7C[0-9]+)*/ }
  ###

  resources :job_monitors
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

  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]

  get 'images/user_projects/:id/files/:fileid', to: 'user_projects#images', constraints: { id: /[0-9]+(\%7C[0-9]+)*/ }

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

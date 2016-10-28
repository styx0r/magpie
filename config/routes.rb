Rails.application.routes.draw do

  resources :models

  resources :hashtags, param: :tag

  # Autocomplete routes
  get "autocomplete/hashtags" => "hashtags#autocomplete"
  ######

  # New routes
  resources :users do
    resources :projects
  end

  resources :users do
      get 'delete_all_projects'
      get 'hashtag_delete'
  end

  #TODO Obsolete, but somethow needed by the form ...
  resources :projects do
    get 'download', on: :member
    get 'delete_marked_jobs'
  end

  resources :jobs do   # For file download (result files)
    get 'download', on: :member
    get 'download_config', on: :member
    put 'highlight', on: :member
  end

  get 'models/:id/:revision/download', to: 'models#download', as: "model_download"

  get 'images/:id/files/:fileid', to: 'jobs#images', constraints: { id: /[0-9]+(\%7C[0-9]+)*/ }

  get 'password_resets/new'

  get 'password_resets/edit'

  # Static Pages
  get 'about' => 'static#about'
  get 'help' => 'static#help'

  # Dashboard
  get 'home' => 'dashboard#index'
  root 'dashboard#index'

  # User Pages
  get 'signup' => 'users#new'

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  # Syncing rules
  get 'microposts_feed' => 'dashboard#microposts_feed'
  get 'jobs_status' => 'jobs#status'
  get 'job_running' => 'jobs#running'
  get 'project_modeldescription' => 'projects#modeldescription'
  get 'project_modelconfig' => 'projects#modelconfig'
  get 'project_modelrevisions' => 'projects#modelrevisions'

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


  # with this action cable runs within the same server process when we run rails server
  mount ActionCable.server => '/cable/'

end

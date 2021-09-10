# NOTE: (cmhobbs) if ArgumentError exceptions arise during boot or on
#      loading routes, first assume clashes with a resources block as
#      noted in the rails 3.2->4.0 upgrade document:
#
#      https://guides.rubyonrails.org/upgrading_ruby_on_rails.html#action-pack
Serve2perform::Application.routes.draw do
  resources :mentorship_circles do
    resources :comments
    member do
      get 'documents'
      get 'audio'
      post 'like', to: 'socializations#like'
      get 'duplicate'
    end
  end

  post 'mentorship_circles/join',  to: 'mentorship_circles#join'
  post 'mentorship_circles/leave', to: 'mentorship_circles#leave'

  resources :collaboration_circles do
    resources :comments
    member do
      get 'documents'
      get 'audio'
      post 'like', to: 'socializations#like'
      get 'duplicate'
    end
  end

  post 'collaboration_circles/join',  to: 'collaboration_circles#join'
  post 'collaboration_circles/leave', to: 'collaboration_circles#leave'

  mount Serve2perform::API => '/'

  resources :inquiries do
    resources :comments
    member do
      get 'documents'
      post 'like', to: 'socializations#like'
      get 'duplicate'
    end
  end

  resources :user_groups do
    collection do
      get ':id/approve' => 'user_groups#approve'
      get 'register'
      get 'manage'
      put 'destroy_many'
      post 'destroy_many'
    end
  end

  resources :coach_action_plans

  resources :mentor_action_plans

  resources :volunteer_action_plans

  resources :comments

  resources :recognitions do
    collection do
      get 'find'
    end
  end

  resources :feedbacks

  resources :facilities do
    collection do
      get 'new'
      get 'show'
      post 'edit'
    end
  end

  resources :testimonials do
    collection do
      get ':id/approve' => 'testimonials#approve'
    end
  end

  resources :fast_contents do
    member do
      get 'documents'
      get 'audio'
    end
  end

  resources :user_licenses do
    collection do
      get 'manage'
      put 'update_many'
    end
  end

  resources :videos

  resources :pacs do
    resources :comments
    collection do
      get 'getFacilities'
      get 'getAddress'
      get 'getType'
      get 'cancel'
    end
  end

  resources :pac_members do
    collection do
      get ':id/approve' => 'pac_members#approve'
      get 'register'
      post :invite
    end
  end

  resources :best_practices do
    resources :comments
    member do
      get 'documents'
      get 'audio'
      post 'like', to: 'socializations#like'
      get 'duplicate'
    end
  end

  resources :recommendations do
    resources :comments
    collection do
      get 'find'
      get 'list'
      get ':id/approve' => 'recommendations#approve'
      get 'register_pde'
    end
    member do
      post 'validate', to: 'socializations#validate'
    end
  end

  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'registrations',
    sessions: 'sessions'
  }

  resources :users do
    collection do
      get 'find'
      get 'historical_opportunities'
      get 'chatter'
      get 'manage'
      put 'update_many'
    end
    member do
      get 'avatars'
    end
  end

  devise_scope :users do
    get '/users/historical_opportunities' => 'users#historical_opportunities'
    get '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'

    # FIXME: (cmhobbs) changing this "match" to "get" breaks hard:
    #       Invalid route name, already in use: 'user'
    #
    #       userdefs at line 152 may be messing with it and i'm not
    #       sure if this line is needed anymore?
    # match '/users/:id' => 'users#show', :as => :user
  end

  resources :opportunities do
    collection do
      get :autocomplete_opportunity_title
      post 'update_many'
      get 'edit_many'
      get 'getFacilities'
      get 'getAddress'
      get 'getPrice'
      get 'register_pde'
      get 'getType'
      get 'oneClickRegister'
      get 'oneClickWebRegister'
    end
  end

  resources :competencies, only: [:update]

  resources :assessments

  resources :assessment_reports do
    member do
      get :share
      post :share_with_email
    end
  end

  resources :organizations, param: :slug, only: %i[new create show edit update] do
    member do
      get :sync
      get :sync_linkedin
      get 'findUsers' => 'organizations#find_users'
      get 'analytics' => 'organizations#analytics'
      get 'avatars'
      get 'banners'
      get 'search'
      get 'getFacilities'
      get 'getAddress'
      get 'getType'
      get 'resources'
      post 'add_users'
    end
  end

  post 'organizations/leave', to: 'organizations#leave'

  resources :invites do
    collection do
      get :invite_email
      post :send_email
    end
  end

  resources :coupon_uses, only: %i[new create]

  resources :assessment_purchases, only: %i[show new create]

  resources :user_license_purchases, only: %i[show new create]

  resources :single_user_license_purchases, only: %i[show new create]

  resources :opportunity_applications

  resources :opportunity_scholarships, only: %i[new create]

  resources :opportunity_purchases

  resources :recommendation_applications

  resources :support_requests, only: %i[new create]

  resources :skills do
    collection do
      post 'update_many'
      get 'edit_many'
    end
  end

  resources :organization_reports do
    member do
      get  :share
      post :share_with_email
    end
  end

  resources :admin do
    collection do
      get 'reports'
      get 'scholarship_request'
    end
  end

  resources :availability do
    collection do
      post 'edit'
    end
  end

  resources :pac_availability do
    collection do
      post 'edit'
    end
  end

  resources :canvas do
    collection do
      get 'canvas' => 'canvas#index'
      post 'canvas' => 'canvas#post'
      get 'callback' => 'static#callback'
    end
  end

  devise_scope :user do
    # root to: 'home#index'
    root to: 'devise/sessions#new'
  end

  get '/signup' => 'signup#index'

  get '/resources' => 'pages#resources'
  get '/ondemand' => 'pages#on_demand'
  get '/collisions' => 'pages#collisions'
  get '/certifications' => 'pages#certifications'
  get '/about' => 'pages#about'
  get '/speakerseries' => 'pages#speaker_series'
  get '/list' => 'pages#list'
  get '/thoughtleadership' => 'pages#thought_leadership'
  get '/templates' => 'pages#templates'
  get '/marketplace' => 'home#index'

  require 'sidekiq/web'
  if Rails.env.production?
    Sidekiq::Web.use Rack::Auth::Basic do |username, password|
      username == 'sidekiqadmin' && password == 'S2Pworkers!'
    end
  end
  mount Sidekiq::Web, at: '/sidekiq'

  require 'resque/server'
  Resque::Server.use(Rack::Auth::Basic) do |username, password|
    username == 'resqueadmin' && password == 'S2Pworkers!'
  end
  mount Resque::Server.new, at: '/resque'

  get '/marketplace/', to: 'marketplace#index'

  post 'accounts/generate', to: 'accounts#generate'
end

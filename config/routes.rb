Rails.application.routes.draw do

  devise_for :users, :controllers => { 
    :sessions => 'users/sessions',
    :registrations => 'users/registrations'
  }

  devise_scope :user do
    get "/companies/employee_login", :to => "users/sessions#employee_login"
    get '/companies/admin_login', :to => 'users/sessions#admin_login'
    post '/users/create_employee_session', :to => 'users/sessions#create_employee_session'
    post '/users/create_admin_session', :to => 'users/sessions#create_admin_session'
    get 'companies/:id/new_employee', :to => 'users/registrations#new_employee', as: :companies_new_employee
    post 'companies/:id/create_employee', :to => 'users/registrations#create_employee', as: :companies_create_employee
    get 'companies/:id/users', :to => 'companies#users', as: :companies_users
    delete 'companies/:company_id/users/:id', :to => 'users/registrations#destroy_employee', as: :companies_destroy_employee
    get 'companies/:company_id/users/:id/edit', :to => 'users/registrations#edit_employee', as: :companies_edit_employee
    put 'companies/:company_id/users/:id/update', :to => 'users/registrations#update_employee', as: :companies_update_employee
  end

  resources :user_projects, only: [:new, :create, :update, :destroy] do
    resources :attendance_tracks do
      # idつく/つかない → member/collection
      collection do
        post "register_start_at"
        get "top"
      end

      member do
        put "register_end_at"
      end
    end
  end

  resources :companies do
    scope module: :companies do
      resources :projects do 
        member do
          resources :contracts do 
            collection do
              get 'new_assign_employee'
              get 'new_assign_not_employee'
              post 'create_employee_assignment'
              post 'create_not_employee_assignment'
            end
          end
        end
      end
    end
    member do
      get "assign"
      get "validate_employee"
    end
  end

  resources :users do
    scope module: :users do
      resources :projects, as: :custom_projects
    end
  end

  resources :users, only: [:show]

  # letter_opener
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end

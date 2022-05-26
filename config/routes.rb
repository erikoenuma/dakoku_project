Rails.application.routes.draw do
  resources :projects
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
  end


  resources :user_projects do
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

  resources :users, only: [:show]

  # deviseでログイン後ここに遷移する
  root to: "projects#index"

  # letter_opener
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end

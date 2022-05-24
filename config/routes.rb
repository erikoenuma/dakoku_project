Rails.application.routes.draw do
  resources :projects
  devise_for :users
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

  # deviseでログイン後ここに遷移する
  root to: "projects#index"
end

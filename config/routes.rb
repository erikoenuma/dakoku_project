Rails.application.routes.draw do
  resources :attendance_tracks
  resources :projects
  devise_for :users

  # deviseでログイン後ここに遷移する
  # root to:
end

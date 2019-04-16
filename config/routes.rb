Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post 'api/exercise/new-user', to: 'api#new_user'
  get 'api/exercise/users', to: 'api#list_users'
  post 'api/exercise/add', to: 'api#add_exercise'
  get 'api/exercise/log', to: 'api#exercise_log'
end

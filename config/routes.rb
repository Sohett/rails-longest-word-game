Rails.application.routes.draw do
  get '/game', to: 'plays#game'

  get '/score', to: 'plays#score'

  root to: 'plays#home'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

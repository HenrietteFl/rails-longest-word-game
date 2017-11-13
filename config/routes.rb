Rails.application.routes.draw do
  get '/game', to: 'challenge#game'

  get '/score', to: 'challenge#score'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

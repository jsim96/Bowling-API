Rails.application.routes.draw do
  resources :game_players do
    collection do
      # Get the current score of a player in a game
      get 'getresult/:game/:player' => 'game_players#getresult'
    end
  end
  resources :frame_scores do
    collection do
      # Scores a player's roll in a frame
      post 'result'
    end
  end
  resources :games do
    collection do
      # Starts a game
      post 'start'
      # Get the winner of a game
      get 'getwinner/:game' => 'games#getwinner'
    end
  end
  resources :players

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
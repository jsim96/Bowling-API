class GamesController < ApplicationController
  before_action :set_game, only: [:show, :update, :destroy]

  # GET /games
  def index
    @games = Game.all

    render json: @games
  end

  # GET /games/1
  def show
    render json: @game
  end

  # POST /games
  def create
    @game = Game.new(game_params)

    if @game.save
      render json: @game, status: :created, location: @game
    else
      render json: @game.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /games/1
  def update
    if @game.update(game_params)
      render json: @game
    else
      render json: @game.errors, status: :unprocessable_entity
    end
  end

  # DELETE /games/1
  def destroy
    @game.destroy
  end

  # POST request games/start
  def start
    newGame = params.require(:game).permit(:description, players: [])
    # Validation start
    errors = Array.new # Hold error messages
    # Check number of players
    if newGame[:players].length < 2 or newGame[:players].length > 8
      errors.push("Number of players must be 2 to 8")
    end

    # Validation end
    if errors.length > 0
      render json: errors, status: unprocessable_entity and return
    end

    @game = Game.create({:description => newGame[:description]})
    @gamePlayers = Array.new
    newGame[:players].each { |p|
      player = Player.find_by_name(p)
      if not player
        # Create new player when not found
        player = Player.create({:name => p})
      end
      # Create GamePlayer with game status Open and Cumulative Score 0
      gamePlayer = GamePlayer.create({"game_id" => @game.id, "player_id" => player.id, 
        "current_frame" => 0, "game_status" => 'O', "cumulative_score" => 0})
      @gamePlayers.push(gamePlayer)
    }
    render json: @gamePlayers
  end

  # GET request games/getwinner
  def getwinner
    @game = Game.find(params[:game])
    if @game.nil?
      render json: "Game #{params[:game]} not found", status: notfound and return
    end
    # Find the winner (or the leading player so far)
    winner = GamePlayer.where("game_id = ?", params[:game]).order("cumulative_score DESC"). first
    if winner.nil?
      render json: "No winner found for this game", status: :notfound and return
    else
      render json: winner
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def game_params
      params.require(:game).permit(:description)
    end
end

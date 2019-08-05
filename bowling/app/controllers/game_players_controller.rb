class GamePlayersController < ApplicationController
  before_action :set_game_player, only: [:show, :update, :destroy]

  # GET /game_players
  def index
    @game_players = GamePlayer.all

    render json: @game_players
  end

  # GET /game_players/1
  def show
    render json: @game_player
  end

  # POST /game_players
  def create
    @game_player = GamePlayer.new(game_player_params)

    if @game_player.save
      render json: @game_player, status: :created, location: @game_player
    else
      render json: @game_player.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /game_players/1
  def update
    if @game_player.update(game_player_params)
      render json: @game_player
    else
      render json: @game_player.errors, status: :unprocessable_entity
    end
  end

  # DELETE /game_players/1
  def destroy
    @game_player.destroy
  end

  # GET /game_players/getresult
  def getresult
    @game_player = GamePlayer.where("game_id = ? and player_id = ?", params[:game], params[:player]).first
    if @game_player.nil?
      # Error, not found
      render json: "Game #{params[:game]} with Player #{params[:player]} not found", 
        status: :notfound and return
    else
      # Return result
      render json: @game_player
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game_player
      @game_player = GamePlayer.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def game_player_params
      params.require(:game_player).permit(:game_id, :player_id, :current_frame, :game_status, :cumulative_score)
    end
end

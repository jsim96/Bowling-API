class FrameScoresController < ApplicationController
  before_action :set_frame_score, only: [:show, :update, :destroy]

  # GET /frame_scores
  def index
    @frame_scores = FrameScore.all

    render json: @frame_scores
  end

  # GET /frame_scores/1
  def show
    render json: @frame_score
  end

  # POST /frame_scores
  def create
    @frame_score = FrameScore.new(frame_score_params)

    if @frame_score.save
      render json: @frame_score, status: :created, location: @frame_score
    else
      render json: @frame_score.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /frame_scores/1
  def update
    if @frame_score.update(frame_score_params)
      render json: @frame_score
    else
      render json: @frame_score.errors, status: :unprocessable_entity
    end
  end

  # DELETE /frame_scores/1
  def destroy
    @frame_score.destroy
  end
  
  # POST /frame_scores/result
  def result
    # Params should be {"result": {"game": 1, "player": 2, "frame": 3, "roll": 1, "pins": 5}}
    roll_result = params.require(:result).permit(:game, :player, :frame, :roll, :pins)
    # Validation start
    errors = Array.new
    game_player = GamePlayer.where("game_id = ? AND player_id = ?", roll_result[:game], roll_result[:player]).first
    if game_player.nil?
      errors.push("Game Player for Game #{roll_result[:game]} and Player #{roll_result[:player]} not found")
    end
    # Ensure frame 1 to 12 (11 and 12 are special frames caused by strike or spare in Frame 10)
    if roll_result[:frame] < 1 or roll_result[:frame] > 12
      errors.push("Frame must be 1 to 12")
    end
    # Ensure roll is 1 or 2
    if roll_result[:roll] < 1 or roll_result[:roll] > 2
      errors.push("Roll must be 1 or 2")
    end
    # Ensure pins 0 - 10
    if roll_result[:pins] < 0 or roll_result[:pins] > 10 
      errors.push("Pins fallen must be 0 to 10")
    end
    # For Frame > 10, only roll 1 allowed
    if roll_result[:frame] > 10 and roll_result[:roll] != 1 
      errors.push("Special Frames > 10 can only have Roll 1")
    end
    # Game Status for this player
    game_status = 'O'
    # Following checks depend on game player's existence
    if game_player
      # Ensure game is not over
      if game_player.game_status == 'F'
	      errors.push("Cannot accept result when Game is over")
      end
      # For Frame > 10, check previous Frames has rolls to add > 0
      if roll_result[:frame] > 10
        sum_rolls_to_add = FrameScore.where("game_player_id = ? AND frame_number < ? and rolls_to_add > 0",
	        game_player.id, roll_result[:frame]).sum(:rolls_to_add)
        if sum_rolls_to_add == 0
	        errors.push("For Frame #{roll_result[:frame]}, there are no previous frames with Spare or Strike")
        elsif sum_rolls_to_add == 1
	        # Last roll to compute score, game must end after this roll
	        game_status = 'F'
        end
      end
      # Get FrameScore (unique by game_player and frame no)
      @frame_score = FrameScore.where("game_player_id = ? AND frame_number = ?", game_player.id, roll_result[:frame]).first
      if @frame_score and roll_result[:roll] == 1 
        errors.push("First Roll Frame Result already exists")
      end
      if roll_result[:roll] == 2
	      if @frame_score.nil?
          errors.push("Frame Score for this frame not found for roll 2")
        elsif @frame_score.frame_result == 'X'
	        errors.push("Not allowed to have second roll when frame is a Strike")
        elsif @frame_score.roll_one_score + roll_result[:pins] > 10 
          errors.push("Total pins for 2 rolls for this frame cannot exceed 10")
        end
      end
    end
    if errors.length > 0 
      render json: errors, status: :unprocessible_entity and return
    end
    # Create or Update result
    frame_result = 'O'
    rolls_to_add = 0
    if roll_result[:frame] > 10
      # For special frames, do not score the frame at all
      cum_pins = 0
      roll_score = 0
    else
      cum_pins = roll_result[:pins] # Cumulative pins added for this and previous frames
      roll_score = roll_result[:pins] # Score for this roll
      if roll_result[:pins] == 10 
        frame_result = 'X'
	      rolls_to_add = 2
      end
    end

    if roll_result[:roll] == 1
       # Create when first roll
       @frame_score = FrameScore.create({game_player: game_player, frame_number: roll_result[:frame], roll_one_score: roll_result[:pins], rolls_to_add: rolls_to_add, frame_result: frame_result, frame_score: roll_score})
       # Update previous frame if it was a strike or spare
    else
       # Roll 2, update when second roll
       if @frame_score.roll_one_score + roll_result[:pins] == 10 
	      frame_result = '/'
	      rolls_to_add = 1
       end 
      @frame_score.update(roll_two_score: roll_result[:pins], rolls_to_add: rolls_to_add, frame_result: frame_result, frame_score: @frame_score.frame_score + roll_score) 
    end
    # Reread previous frames to increment their scores for strikes and spares
    FrameScore.where("game_player_id = ? AND frame_number < ? and rolls_to_add > 0",  game_player.id, 
      roll_result[:frame]).order(:frame_number).each do |fs|
        fs.update(frame_score: fs.frame_score + roll_result[:pins], rolls_to_add: fs.rolls_to_add - 1)
        # Add to player's cumulative score
        cum_pins = cum_pins + roll_result[:pins]
    end
    # Game finished for this player at frame 10? (For frame > 10, we have already decided above)
    if roll_result[:frame] == 10 and frame_result == 'O'
      game_status = 'F'
    end

    # Update cumulative score for player in this game
    game_player.update(current_frame: roll_result[:frame], game_status: game_status,
      cumulative_score: game_player.cumulative_score + cum_pins)

    render json: {:game_player => game_player, :frame_score => @frame_score}, status: :ok
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_frame_score
      @frame_score = FrameScore.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def frame_score_params
      params.require(:frame_score).permit(:game_player_id, :frame_number, :roll_one_score, :roll_two_score, :frame_result, :frame_score)
    end
end

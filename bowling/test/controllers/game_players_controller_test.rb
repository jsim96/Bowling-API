require 'test_helper'

class GamePlayersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @game_player = game_players(:one)
  end

  test "should get index" do
    get game_players_url, as: :json
    assert_response :success
  end

  test "should create game_player" do
    assert_difference('GamePlayer.count') do
      post game_players_url, params: { game_player: { cumulative_score: @game_player.cumulative_score, current_frame: @game_player.current_frame, game_id: @game_player.game_id, game_status: @game_player.game_status, player_id: @game_player.player_id } }, as: :json
    end

    assert_response 201
  end

  test "should show game_player" do
    get game_player_url(@game_player), as: :json
    assert_response :success
  end

  test "should update game_player" do
    patch game_player_url(@game_player), params: { game_player: { cumulative_score: @game_player.cumulative_score, current_frame: @game_player.current_frame, game_id: @game_player.game_id, game_status: @game_player.game_status, player_id: @game_player.player_id } }, as: :json
    assert_response 200
  end

  test "should destroy game_player" do
    assert_difference('GamePlayer.count', -1) do
      delete game_player_url(@game_player), as: :json
    end

    assert_response 204
  end
end

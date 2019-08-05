require 'test_helper'

class FrameScoresControllerTest < ActionDispatch::IntegrationTest
  setup do
    @frame_score = frame_scores(:one)
  end

  test "should get index" do
    get frame_scores_url, as: :json
    assert_response :success
  end

  test "should create frame_score" do
    assert_difference('FrameScore.count') do
      post frame_scores_url, params: { frame_score: { frame_number: @frame_score.frame_number, frame_result: @frame_score.frame_result, frame_score: @frame_score.frame_score, game_player_id: @frame_score.game_player_id, roll_one_score: @frame_score.roll_one_score, roll_two_score: @frame_score.roll_two_score } }, as: :json
    end

    assert_response 201
  end

  test "should show frame_score" do
    get frame_score_url(@frame_score), as: :json
    assert_response :success
  end

  test "should update frame_score" do
    patch frame_score_url(@frame_score), params: { frame_score: { frame_number: @frame_score.frame_number, frame_result: @frame_score.frame_result, frame_score: @frame_score.frame_score, game_player_id: @frame_score.game_player_id, roll_one_score: @frame_score.roll_one_score, roll_two_score: @frame_score.roll_two_score } }, as: :json
    assert_response 200
  end

  test "should destroy frame_score" do
    assert_difference('FrameScore.count', -1) do
      delete frame_score_url(@frame_score), as: :json
    end

    assert_response 204
  end
end

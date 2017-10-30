require 'test_helper'

class PlaysControllerTest < ActionDispatch::IntegrationTest
  test "should get game" do
    get plays_game_url
    assert_response :success
  end

  test "should get score" do
    get plays_score_url
    assert_response :success
  end

end

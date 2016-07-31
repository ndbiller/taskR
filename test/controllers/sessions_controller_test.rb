require "test_helper"

class SessionsControllerTest < ActionController::TestCase
  def test_new
    get :new
    assert_response :success
  end

end

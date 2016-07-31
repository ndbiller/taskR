require "test_helper"

class UsersControllerTest < ActionController::TestCase
  def test_new
    get signup_path
    assert_response :success
  end

end

require "test_helper"

class StaticPagesControllerTest < ActionController::TestCase
  def test_home
    get :home
    assert_response :success
  end

end

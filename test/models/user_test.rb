require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def user
    @user = User.new(name: 'Example User', email: 'user@example.com', password: 'foobar', password_confirmation: 'foobar')
  end

  test 'should be valid' do
    assert user.valid?
  end

  def test_valid
    assert user.valid?
  end
end

class ApplicationController < ActionController::API
  include Secured

  def create_user
    User.create(email: @email, first_name: @first_name, last_name: @last_name)
  end

  def user_exists?
    user = User.where(["email = ?", @email])
    user.any?
  end
end

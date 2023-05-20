class ApplicationController < ActionController::API
  include Secured

  def get_user!
    User.find_or_create_by!(email: @token_user[:email]) do |u|
      u.update @token_user
    end
  end
end

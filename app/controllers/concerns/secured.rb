# frozen_string_literal: true

require_relative "../../../lib/auth0_client.rb"

module Secured
  extend ActiveSupport::Concern

  REQUIRES_AUTHENTICATION = { message: "Requires authentication" }.freeze
  BAD_CREDENTIALS = {
    message: "Bad credentials",
  }.freeze
  MALFORMED_AUTHORIZATION_HEADER = {
    error: "invalid_request",
    error_description: "Authorization header value must follow this format: Bearer access-token",
    message: "Bad credentials",
  }.freeze
  INSUFFICIENT_PERMISSIONS = {
    error: "insufficient_permissions",
    error_description: "The access token does not contain the required permissions",
    message: "Permission denied",
  }.freeze

  def authenticate
    token = token_from_request
    return if performed?

    validation_response = Auth0Client.validate_token token

    logger.debug("validation_response: #{validation_response}")

    @decoded_token = validation_response.decoded_token

    if @decoded_token.nil?
      render json: { message: validation_response.error }, status: 401
      return
    end

    @token_user = map_user_from_token

    if @token_user[:email].nil?
      render json: { message: "Must have email." }, status: 401
    end

    return unless (error = validation_response.error)

    render json: { message: error.message }, status: error.status
  end

  def validate_permissions(permissions)
    raise "validate_permissions needs to be called with a block" unless block_given?
    return yield if @decoded_token.validate_permissions(permissions)
    render json: INSUFFICIENT_PERMISSIONS, status: :forbidden
  end

  private

  def token_from_request
    authorization_header_elements = request.headers["Authorization"]&.split
    render json: REQUIRES_AUTHENTICATION, status: :unauthorized and return unless authorization_header_elements

    unless authorization_header_elements.length == 2
      render json: MALFORMED_AUTHORIZATION_HEADER,
             status: :unauthorized and return
    end

    scheme, token = authorization_header_elements
    render json: BAD_CREDENTIALS, status: :unauthorized and return unless scheme.downcase == "bearer"
    token
  end

  def authorize(user)
    unless user.email == @token_user[:email]
      render json: { message: "User is not authorized." }, status: 401
    end
  end

  def map_user_from_token
    body = @decoded_token[0][0]
    { :last_name => body["given_name"], :first_name => body["family_name"],
       :email => body["email"], :pfp_link => body["picture"] }
  end
end

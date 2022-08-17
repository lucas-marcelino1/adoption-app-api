class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  rescue_from StandardError, with: :standard_error
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :registration_number, address_attributes: [:city, :state, :zipcode, :details]])
  end

  private

  def standard_error
    render status: :internal_server_error, json: { errors: { title: 'Something went wrong.', 
                                                  details: "Sorry, we encountered unexpected error." }}
  end

end

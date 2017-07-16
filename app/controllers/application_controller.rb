class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  after_filter :store_action
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  def store_action
    return unless request.get? 
    if (request.path != "/users/sign_in" &&
        request.path != "/users/sign_up" &&
        request.path != "/users/password/new" &&
        request.path != "/users/password/edit" &&
        request.path != "/users/confirmation" &&
        request.path != "/users/sign_out" &&
        !request.xhr?) # don't store ajax calls
      store_location_for(:user, community_index_path)
    end
  end
  
  protected
  def authenticate_user!
    if user_signed_in?
      super
    else
      redirect_to root_path, :alert => 'You must be logged in to access this page'
      ## if you want render 404 page
      ## render :file => File.join(Rails.root, 'public/404'), :formats => [:html], :status => 404, :layout => false
    end
  end
  
  protected
  def authenticate_admin!
    if user_signed_in? && current_user.admin
      authenticate_user!
    else
      redirect_to community_index_path, :alert => 'You do not have the rights to access this page. Please contact the admin.'
    end
  end
 
  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [[:first_name], [:last_name]])
  end
  
end

require 'application_responder'

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception

protected
  def store_location
    if (request.get? && request.format.html? && !request.xhr? && !devise_controller?)
      store_location_for(:user, request.url)
    end
  end

private
  def profile_completing?
    params['controller'] == 'profiles' &&
       (params['action'] == 'update' || params['action'] == 'edit')
  end

  def check_profile_completion
    if current_user.need_profile_completion? && !profile_completing?
      redirect_to(edit_profile_path(current_user), notice: I18n.t('profile.completion'))
    end
  end
end

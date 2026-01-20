module Api
  class BaseController < ActionController::API
    include Devise::Controllers::Helpers

    before_action :authenticate_user!
  end
end

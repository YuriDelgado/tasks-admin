module Api
  class BaseController < ActionController::API
    include Devise::Controllers::Helpers

    before_action :authenticate_user!

    private

      def current_account
        current_user.account
      end
  end
end

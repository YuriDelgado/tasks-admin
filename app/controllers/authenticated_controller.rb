class AuthenticatedController < ApplicationController
  before_action :authenticate_user!

  private

  def current_account
    current_user.account
  end
end

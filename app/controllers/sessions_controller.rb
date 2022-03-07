class SessionsController < ApplicationController
  def create_table
    user = User.find_or_create_from_auth_hash!(request.env["omniauth.auth"])
    session[:user_id] = user.index
    redirect_to root_path, notice: "ログインしました"
  end
end

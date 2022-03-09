class ApplicationController < ActionController::Base
  before_action :authenticate
  helper_method :logged_in?, :current_user

  private

  # logged_in?メソッドでは、session[:user_id]に値が入っていればログインとしてtrue、そうでなければ未ログインとしてfalseを返しています。!!はnot演算子です。not演算子を2つ重ねることで、session[:user_id]がfalseまたはnilの時はfalseを、それ以外の値の時はtrueへ変換します。
  def logged_in?
    !!current_user
  end

  def current_user
    return unless session[:user_id]
    @current_user || = User.find(session[:user_id])
  end

  def authenticate
    return if logged_in?
    redirect_to root_path, alert: "ログインしてください"
  end
end

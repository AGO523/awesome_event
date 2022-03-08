class ApplicationController < ActionController::Base
  helper_method :logged_in?

  private

  # logged_in?メソッドでは、session[:user_id]に値が入っていればログインとしてtrue、そうでなければ未ログインとしてfalseを返しています。!!session[:user_id]の先頭に付いている2つの!はnot演算子です。not演算子を2つ重ねることで、session[:user_id]がfalseまたはnilの時はfalseを、それ以外の値の時はtrueへ変換します。
  def logged_in?
    !!session[:user_id]
  end
end

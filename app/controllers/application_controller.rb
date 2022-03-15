class ApplicationController < ActionController::Base
  before_action :authenticate
  helper_method :logged_in?, :current_user
  
  # ActiveRecord::RecordNotFoundもしくはActionController::RoutingErrorが発生した時にはerror404というアクション、それ以外の時にはerror500というアクションが実行されます
  # rescue_fromの順番には注意しましょう。rescue_fromは後に登録したものから順番に判定するので、もしrescue_fromExceptionが下にあるとここですべてのエラーがマッチしてしまうため、上にあるrescue_fromが意味のないものになってしまいます。
  rescue_from Exception, with: :error500
  rescue_from ActiveRecord::RecordNotFound, ActionController::RoutingError, with: :error404

  private

  # logged_in?メソッドでは、session[:user_id]に値が入っていればログインとしてtrue、そうでなければ未ログインとしてfalseを返しています。!!はnot演算子です。not演算子を2つ重ねることで、session[:user_id]がfalseまたはnilの時はfalseを、それ以外の値の時はtrueへ変換します。
  def logged_in?
    !!current_user
  end

  def current_user
    return unless session[:user_id]
    @current_user ||= User.find(session[:user_id])
  end

  def authenticate
    return if logged_in?
    redirect_to root_path, alert: "ログインしてください"
  end

  # ActionView::MissingTemplateエラーになってしまいエラー画面が正しく出力できません。そこでrenderメソッドにformats:[:html]オプションを渡し、リクエストがどんなフォーマットを要求してもHTMLのみを返すようにしています。
  def error404
    render "error404", status: 404, formats: [:html]
  end
  
  # error500の時にはログにエラーの種類とバックトレースを出力
  def error500
    logger.error [e, *e.backtrace].join("\n")
    render "error500", status: 500, format: [:html]
  end
end

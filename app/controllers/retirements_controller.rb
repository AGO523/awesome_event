class RetirementsController < ApplicationController
  def new
  end

  def create
    # createアクションが実行された際に、ユーザレコードの削除が成功したらセッションを削除してログアウトした場合と同じ状態にしています
    if current_user.destroy
      reset_session
      redirect_to root_path, notice: "退会完了しました"
    end
  end
end

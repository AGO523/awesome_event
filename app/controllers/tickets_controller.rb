class TicketsController < ApplicationController
  # 未ログイン状態で「参加する」ボタンを押した時にnewアクションが実行されます。そこでApplicationControllerのbefore_actionで設定しているauthenticateメソッドが実行され、トップページに遷移することを期待しています。ログイン状態ではnewアクションへのリンクは表示されないので、newアクションが実際に実行されることはないように思えますが、ユーザがurlを直接入力するケースを考えActionController::RoutingErrorをraiseするようにしています。
  def new
    raise ApplicationController::RoutingError, "ログイン状態で TicketsController#new にアクセス"
  end

  # ログイン状態で「参加する」ボタンを押して表示されたモーダルウィンドウでコメントを入力し「送信」ボタンを押すとcreateアクションが実行されます。Ticketを新規に作り、作成に成功したらリダイレクト、失敗したらエラーメッセージを描画するようにします。
  def create
    event = Event.find(params[:event_id])
    @ticket = current_user.tickets.build do |t|
      t.event = event
      t.comment = pramas[:ticket][:comment]
    end
    if @ticket.save
      redirect_to event, notice: "このイベントに参加表明しました"
    end
  end
end

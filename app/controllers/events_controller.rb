class EventsController < ApplicationController
before_action :authenticate, only: :show

  def show
    @event = Event.find(params[:id])
    # includes(:user)としているのは、@ticketsの各要素をeachで参照する時に、belongs_toで定義したuserメソッドを呼び出しているためです。includes(:user)は、Ticketsの取得時に関連するUserオブジェクトを一度に取得します。includes(:user)を使わないと@ticketsの要素の数だけSQLクエリが発行されることになります。このような挙動を通称N+1問題と呼びます。
    @tickets = @event.tickets.includes(:user).order(:created_at)
  end

  def new
    @event = current_user.created_events.build
  end

  def create
    @event = current_user.created_events.build(event_params)

    if @event.save
      redirect_to @event, notice: "作成しました"
    end
  end

  def edit 
    # イベントを作成したユーザだけがイベント編集ページにアクセス可能
    @event = current_user.created_events.find(params[:id])
  end

  def update
    @event = current_user.created_events.find(params[:id])
    if @event.update(event_params)
      redirect_to @event, notice: "更新しました"
    end
  end

  def destroy
    @event = current_user.created_events.find(params[:id])
    @event.destroy!
    redirect_to root_path, notice: "削除しました"
  end

  private

  def event_params
    params.require(:event).permit(:name, :place, :content, :start_at, :end_at)
  end
end

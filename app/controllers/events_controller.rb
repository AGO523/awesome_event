class EventsController < ApplicationController
before_action :authenticate, only: :show

  def show
    @event = Event.find(params[:id])
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

  def updated_at
    @event = current_user.created_events.find(params[:id])
    if @event.update(event_params)
      redirect_to @event, notice: "更新しました"
    end
  end

  private

  def event_params
    params.require(:event).permit(:name, :place, :content, :start_at, :end_at)
  end
end

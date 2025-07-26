class ChatMessagesController < ApplicationController
  before_action :set_plan
  before_action :authorize_member!, only: [ :index, :create ]

  def index
    @chat_messages = @plan.chat_messages.includes(:user).order(created_at: :asc)
  end

  def create
    @chat_message = @plan.chat_messages.build(chat_message_params)
    @chat_message.user = current_user

    if @chat_message.save
      Turbo::StreamsChannel.broadcast_prepend_to(
        "chat_#{@plan.id}",
        target: "chat_messages",
        partial: "chat_messages/chat_message",
        locals: { chat_message: @chat_message })
      head :no_content
    else
      render :index, status: :unprocessable_entity
    end
  end

  def authorize_member!
    @plan = Plan.find(params[:plan_id])
    unless @plan.members.include?(current_user) || @plan.user == current_user
      redirect_to plans_path, alert: "このプランを編集する権限がありません"
    end
  end

  private

  def set_plan
    @plan = Plan.find(params[:plan_id])
  end

  def chat_message_params
    params.require(:chat_message).permit(:content)
  end
end

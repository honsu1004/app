class ChatMessagesController < ApplicationController
  before_action :set_plan
  before_action :authorize_member!, only: [ :index, :create ]
  before_action :set_chat_messages, only: [ :index, :create ]

  def index
    @plan = Plan.find(params[:plan_id])
    @chat_message = @plan.chat_messages.includes(:user).order(:created_at)
    @chat_message = ChatMessage.new
  end

  def create
    @plan = Plan.find(params[:plan_id])
    @chat_message = @plan.chat_messages.new(chat_message_params)
    @chat_message.user = current_user

    if @chat_message.save

    else
      logger.debug "❌ ChatMessage Save Failed: #{@chat_message.errors.full_messages}"
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
    params.require(:chat_message).permit(:content).merge(user_id: current_user.id, plan_id: params[:plan_id])
  end

  def set_chat_messages
    @chat_messages = @plan.chat_messages.includes(:user)
  end
end

class ChatMessagesController < ApplicationController
  before_action :set_plan
  before_action :authorize_member!, only: [ :index, :create ]
  before_action :set_chat_messages, only: [ :index, :create ]

  def index
    @chat_message = @chat_messages.new
  end

  def create
    @chat_message = ChatMessage.new(chat_message_params)

    respond_to do |format|
      if @chat_message.save
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.prepend("chat_messages",
            partial: "chat_messages/chat_message",
            locals: { chat_message: @chat_message })
          end
          format.html { redirect_to plan_chatmessages_path(@plan) }
        end
      else
        logger.debug "❌ ChatMessage Save Failed: #{@chat_message.errors.full_messages}"
        format.html { render :index, status: :unprocessable_entity }
      end
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

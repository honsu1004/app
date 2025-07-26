class ChatChannel < ApplicationCable::Channel
  def subscribed
    @plan = Plan.find(params[:plan_id])
    stream_from "chat_channel_#{@plan_id}"
  end

  def unsubscribed
  end
end

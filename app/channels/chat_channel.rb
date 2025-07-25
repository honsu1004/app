class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_#{params[:plan_id]}"
  end

  def unsubscribed
  end
end

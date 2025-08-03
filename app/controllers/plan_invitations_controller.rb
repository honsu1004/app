class PlanInvitationsController < ApplicationController
  def accept
    token = params[:token] || params[:id] # どちらでも対応
    invitation = PlanInvitation.find_by(token: token)

    if invitation.nil?
      redirect_to root_path, alert: "招待状が見つかりませんでした"
      return
    end

    if user_signed_in?
      invitation.update(accepted_at: Time.current)
      redirect_to invitation.plan, notice: "プランに参加しました！"
    else
      session[:pending_invitation_token] = invitation.token
      redirect_to new_user_registration_path, notice: "アカウント作成後にプランへ参加できます"
    end
  end

  private

  def join_plan(invitation)
    if invitation.accepted_at.nil?
      invitation.plan.members << current_user
      invitation.update!(accepted_at: Time.current)
    end
    redirect_to invitation.plan, notice: "プランに参加しました！"
  end
end

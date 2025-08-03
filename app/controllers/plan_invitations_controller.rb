class PlanInvitationsController < ApplicationController
  def accept
    invitation = PlanInvitation.find_by!(token: params[:token])

    if user_signed_in?
      join_plan(invitation)
    else
      # サインアップ後に処理するためセッションに保存
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

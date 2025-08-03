class PlanInvitationsController < ApplicationController
  def accept
    invitation = PlanInvitation.find_by(token: params[:token])
    unless invitation
      redirect_to root_path, alert: "招待が無効です" and return
    end

    if user_signed_in?
      # ログイン中なら直接参加処理
      join_plan(invitation, current_user)
      redirect_to plan_path(invitation.plan), notice: "プランに参加しました"
    else
      # 招待メールに対応するユーザーがいるか確認
      invited_email = invitation.email
      if invited_email.present? && User.exists?(email: invited_email)
        # 既存ユーザー → ログインへ
        session[:pending_invitation_token] = invitation.token
        redirect_to new_user_session_path, notice: "ログインしてプランに参加してください"
      else
        # 新規ユーザー → サインアップへ
        session[:pending_invitation_token] = invitation.token
        redirect_to new_user_registration_path, notice: "新規登録してプランに参加してください"
      end
    end
  end

  private

  def join_plan(invitation, user)
    unless invitation.plan.members.exists?(user.id)
      invitation.plan.members << user
      invitation.update!(accepted_at: Time.current)
    end
  end
end

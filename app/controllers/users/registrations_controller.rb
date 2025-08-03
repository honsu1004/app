class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super do |user|
      # サインアップ直後に招待を処理
      if session[:pending_invitation_token].present?
        token = session.delete(:pending_invitation_token)
        invitation = PlanInvitation.find_by(token: token)

        if invitation && invitation.accepted_at.nil?
          invitation.plan.members << user
          invitation.update!(accepted_at: Time.current)
        end
      end
    end
  end
end

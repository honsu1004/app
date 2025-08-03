class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super do |user|
      if user.persisted? && session[:pending_invitation_token].present?
        token = session.delete(:pending_invitation_token)
        invitation = PlanInvitation.find_by(token: token)

        if invitation && invitation.accepted_at.nil?
          plan = invitation.plan
          unless plan.members.exists?(user.id) # すでにメンバーでなければ追加
            plan.members << user
          end
          invitation.update!(accepted_at: Time.current)
        end
      end
    end
  end
end

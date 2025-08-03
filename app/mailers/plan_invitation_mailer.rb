class PlanInvitationMailer < ApplicationMailer
  default from: "no-reply@tomotabi.com"

  def invite(invitation)
    @invitation = invitation
    @plan = invitation.plan
    @plan_invitation = invitation
    @accept_url = accept_plan_invitation_url(@plan_invitation.token)
    mail(to: invitation.email, subject: "旅行プランへの招待")
  end
end

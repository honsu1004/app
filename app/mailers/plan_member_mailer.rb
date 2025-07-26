class PlanMemberMailer < ApplicationMailer
  def invite_email(plan, user, inviter)
    @plan = plan
    @user = user
    @inviter = inviter

    mail(to: @user.email, subject: "#{@inviter.name}さんから『#{@plan.title}』の招待が届きました")
  end
end

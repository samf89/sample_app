class UserMailer < ApplicationMailer
  default from: "noreply@example.com"

  def account_activation(user)
    @user = user 
    mail to: @user.email, subject: "Sample app account activation"
  end

  def password_reset(user)
    @user = user
    mail to: @user.email, subject: "Sample app password reset"
  end

end

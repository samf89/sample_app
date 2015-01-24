class UserMailer < ApplicationMailer
  default from: "noreply@example.com"

  def account_activation(user)
    @user = user 

    mail to: @user.email, subject: "Sample app account activation"
  end

  def password_reset
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end

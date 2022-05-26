class RegistrationMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.registration_mailer.welcome.subject
  #
  def welcome(user, password)
    @user = user
    @password = password

    mail(
      subject: "Welcome!",
      to: user.email
    )
  end
end

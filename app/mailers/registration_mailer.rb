class RegistrationMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.registration_mailer.welcome.subject
  #
  def welcome(user, password, company)
    @user = user
    @password = password
    @company = company

    mail(
      subject: "「打刻で案件管理」#{@company.name}にようこそ",
      to: user.email
    )
  end
end

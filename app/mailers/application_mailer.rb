class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("MAIL_FROM", "no-reply@kotonoha-app.com")
  layout "mailer"
end

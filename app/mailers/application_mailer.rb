class ApplicationMailer < ActionMailer::Base
  default from: "noreply@magpie.imb.medizin.tu-dresden.de"
  layout 'mailer'
end

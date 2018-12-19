class ApplicationMailer < ActionMailer::Base
  default from: 'Homeward Fitness <do_not_reply@homewardfitness.com>'
  add_template_helper(ApplicationHelper)
  layout 'mailer'
end

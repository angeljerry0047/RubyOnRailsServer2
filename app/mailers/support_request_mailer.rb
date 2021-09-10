class SupportRequestMailer < ActionMailer::Base
    default from: "notification@serve2perform.com"
   
    def new_request(request)
      @request = request

      mail(
        to:       "tgrosse@serve2perform.com",
        subject:  "New SERVE2MENTOR Support Request"
      )
    end
  
  end

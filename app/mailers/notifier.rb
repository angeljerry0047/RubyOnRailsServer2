# coding: utf-8
# XXX (cmhobbs) why does this abomination exist?  please, let's refactor it.
class Notifier < ActionMailer::Base
  default from: "notification@serve2perform.com"
  NotAuthorizedError = Class.new(SecurityError)

  def assessment(recipient, subject, text, assessment_report_id)
    @assessment_report = AssessmentReport.find(assessment_report_id)
    @account = recipient
    @subject = subject
    @text = text
    attachments['assessment_report.pdf'] = AssessmentReportPdf.new(@assessment_report).render
    mail(:to => recipient, :subject => @subject, :body => @text)
  end
  
  def need_more_coupon_purchases(user)
    if user.managed_organization.nil?
      raise NotAuthorizedError
    else
      mail(
        :to => user.email, 
        :content_type => "text/html",
        :subject => "You are close to reaching your assessment code limit!",
        :body => self.class.low_threshold_email(user)
      )
    end
  end
  
  def pac_membership_approval(pac_member)
    @pac = pac_member.pac
    @starttime = Time.parse(@pac.start_time)
    @endtime = Time.parse(@pac.end_time)
    @start = @pac.start_date.change(hour: @starttime.hour, min: @starttime.min)
    @end = @pac.start_date.change(hour: @endtime.hour, min: @endtime.min)
    @calendar = Icalendar::Calendar.new
    event = Icalendar::Event.new
    event.dtstart = @start
    event.dtend = @end
    event.summary = @pac.title
    @calendar.add_event(event)
    @calendar.publish
    @owner = @pac.owner
    
    if @pac.opportunity_type_id == 1
    mail(
        :to => pac_member.member.email,
        :cc => @owner.email,
        :content_type => "text/html",
        :subject => pac_member.pac.title,
        :body => self.class.pac_member_acceptance_email(pac_member),
      )
    else mail(
        :to => pac_member.member.email, 
        :cc => @owner.email,
        :content_type => "text/html",
        :subject => pac_member.pac.title,
        :body => self.class.pac_member_acceptance_email_virtual(pac_member)
      )
    end
    
end

  def new_account_email(recipient, name, generated_password)
    @subject  = "Welcome to SERVE2MENTOR!"
    @name     = name
    @password = generated_password
    
    mail(
      to:           recipient,
      content_type: 'text/html',
      body: self.class.new_account_email_body(name, generated_password)
    )
  end

  def self.new_account_email_body(name, password)
    # FIXME (cmhobbs) interpolate name and password
    <<-EMAIL
      <!doctype html>
      <html>
        <head>
          <meta name="viewport" content="width=device-width" />
          <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
          <title>Simple Transactional Email</title>
          <style>
            /* -------------------------------------
                GLOBAL RESETS
            ------------------------------------- */
            img {
              border: none;
              -ms-interpolation-mode: bicubic;
              max-width: 100%; }
            body {
              background-color: #f6f6f6;
              font-family: sans-serif;
              -webkit-font-smoothing: antialiased;
              font-size: 14px;
              line-height: 1.4;
              margin: 0;
              padding: 0; 
              -ms-text-size-adjust: 100%;
              -webkit-text-size-adjust: 100%; }
            table {
              border-collapse: separate;
              mso-table-lspace: 0pt;
              mso-table-rspace: 0pt;
              width: 100%; }
              table td {
                font-family: sans-serif;
                font-size: 14px;
                vertical-align: top; }
            /* -------------------------------------
                BODY & CONTAINER
            ------------------------------------- */
            .body {
              background-color: #f6f6f6;
              width: 100%; }
            /* Set a max-width, and make it display as block so it will automatically stretch to that width, but will also shrink down on a phone or something */
            .container {
              display: block;
              Margin: 0 auto !important;
              /* makes it centered */
              max-width: 580px;
              padding: 10px;
              width: 580px; }
            /* This should also be a block element, so that it will fill 100% of the .container */
            .content {
              box-sizing: border-box;
              display: block;
              Margin: 0 auto;
              max-width: 580px;
              padding: 10px; }
            .green-background{
              background-color: #093;
              color: #fff;
              margin-bottom: 20px;
              padding: 10px;
            }
            .green-background > h1, .green-background > h2{
              color: #fff;
            }
            /* -------------------------------------
                HEADER, FOOTER, MAIN
            ------------------------------------- */
            .main {
              background: #fff;
              border-radius: 3px;
              width: 100%; }
            .wrapper {
              box-sizing: border-box;
              padding: 20px; }
            .footer {
              clear: both;
              padding-top: 10px;
              text-align: center;
              width: 100%; }
              .footer td,
              .footer p,
              .footer span,
              .footer a {
                color: #999999;
                font-size: 12px;
                text-align: center; }
            /* -------------------------------------
                TYPOGRAPHY
            ------------------------------------- */
            h1,
            h2,
            h3,
            h4 {
              color: #000000;
              font-family: sans-serif;
              font-weight: 400;
              line-height: 1.4;
              margin: 0;
              Margin-bottom: 10px; }
            h1 {
              font-size: 80px;
              font-weight: 300;
              text-align: center;
              text-transform: capitalize; }
            p,
            ul,
            ol {
              font-family: sans-serif;
              font-size: 16px;
              font-weight: normal;
              margin: 0;
              Margin-bottom: 15px; }
              p li,
              ul li,
              ol li {
                list-style-position: inside;
                margin-left: 5px; }
            a {
              color: #3498db;
              position: relative;
              text-decoration: underline; }
            .video-title-overlay{
              background-color: #093;
              bottom: 30px;
              color: #fff;
              font-weight: bold;
              padding: 10px;
              position: absolute;
            }
            /* -------------------------------------
                BUTTONS
            ------------------------------------- */
            .btn {
              box-sizing: border-box;
              width: 100%; }
              .btn > tbody > tr > td {
                padding-bottom: 15px; }
              .btn table {
                width: auto; }
              .btn table td {
                background-color: #ffffff;
                border-radius: 5px;
                text-align: center; }
              .btn a {
                background-color: #ffffff;
                border: solid 1px #093;
                border-radius: 5px;
                box-sizing: border-box;
                color: #3498db;
                cursor: pointer;
                display: inline-block;
                font-size: 14px;
                font-weight: bold;
                margin: 0;
                padding: 12px 25px;
                text-decoration: none;
                text-transform: capitalize; }
            .btn-primary table td {
              background-color: #093; }
            .btn-primary a {
              background-color: #093;
              border-color: #093;
              color: #ffffff; }
            /* -------------------------------------
                OTHER STYLES THAT MIGHT BE USEFUL
            ------------------------------------- */
            .last {
              margin-bottom: 0; }
            .first {
              margin-top: 0; }
            .align-center {
              text-align: center; }
            .align-right {
              text-align: right; }
            .align-left {
              text-align: left; }
            .clear {
              clear: both; }
            .mt0 {
              margin-top: 0; }
            .mb0 {
              margin-bottom: 0; }
            .preheader {
              color: transparent;
              display: none;
              height: 0;
              max-height: 0;
              max-width: 0;
              opacity: 0;
              overflow: hidden;
              mso-hide: all;
              visibility: hidden;
              width: 0; }
            .powered-by a {
              text-decoration: none; }
            hr {
              border: 0;
              border-bottom: 1px solid #f6f6f6;
              Margin: 20px 0; }
            /* -------------------------------------
                RESPONSIVE AND MOBILE FRIENDLY STYLES
            ------------------------------------- */
            @media only screen and (max-width: 620px) {
              table[class=body] h1 {
                font-size: 50px !important;
                margin-bottom: 10px !important; }
              table[class=body] p,
              table[class=body] ul,
              table[class=body] ol,
              table[class=body] td,
              table[class=body] span,
              table[class=body] a {
                font-size: 16px !important; }
              table[class=body] .wrapper,
              table[class=body] .article {
                padding: 10px !important; }
              table[class=body] .content {
                padding: 0 !important; }
              table[class=body] .container {
                padding: 0 !important;
                width: 100% !important; }
              table[class=body] .main {
                border-left-width: 0 !important;
                border-radius: 0 !important;
                border-right-width: 0 !important; }
              table[class=body] .btn table {
                width: 100% !important; }
              table[class=body] .btn a {
                width: 100% !important; }
              table[class=body] .img-responsive {
                height: auto !important;
                max-width: 100% !important;
                width: auto !important; }}
            /* -------------------------------------
                PRESERVE THESE STYLES IN THE HEAD
            ------------------------------------- */
            @media all {
              .ExternalClass {
                width: 100%; }
              .ExternalClass,
              .ExternalClass p,
              .ExternalClass span,
              .ExternalClass font,
              .ExternalClass td,
              .ExternalClass div {
                line-height: 100%; }
              .apple-link a {
                color: inherit !important;
                font-family: inherit !important;
                font-size: inherit !important;
                font-weight: inherit !important;
                line-height: inherit !important;
                text-decoration: none !important; } 
              .btn-primary table td:hover {
                background-color: #1b5e20 !important; }
              .btn-primary a:hover {
                background-color: #1b5e20 !important;
                border-color: #1b5e20 !important; } }
          </style>
        </head>
        <body class="">
          <table border="0" cellpadding="0" cellspacing="0" class="body">
            <tr>
              <td>&nbsp;</td>
              <td class="container">
                <div class="content">
      
                  <!-- START CENTERED WHITE CONTAINER -->
                  <span class="preheader">Welcome to SERVE2MENTOR!</span>
                  <table class="main">
      
                    <!-- START MAIN CONTENT AREA -->
                    <tr>
                      <td class="wrapper">
                        <table border="0" cellpadding="0" cellspacing="0">
                          <tr>
                            <td>
                              <div class="green-background">
                                <h1>Hello and welcome to SERVE2MENTOR!</h1>

                                  <p>We have created a user profile for you and your sign in 
                                  credentials for <a href="https://www.serve2mentor.com">www.serve2mentor.com</a>
                                  are as follows:</p>

                                  <p>
                                    <ul>
                                      <li>Your username is your email address.</li>
                                      <li>Your temporary password is: #{password}</li>
                                    </ul>
                                  </p>
 
                                  <p>Once you've signed in, please remember to change your password.</p>

                                  <p>To help you start engaging the platform to connect, engage, and 
                                  learn, here are four recommended steps to follow:</p>

                                  <p>
                                    <ul>
                                      <li>Step 1: Learn how the SERVE2MENTOR methodology works. You can 
                                      access on demand videos on this topic from the homepage.</li>
                                      <li>Step 2: Learn examples of how to apply the SERVE2MENTOR
                                      methodology. You can access on demand videos on this topic from the
                                      homepage.</li>
                                      <li>Step 3: Select a SERVE2MENTOR role and learn how it works. You
                                      can access on demand videos on this topic from the homepage.</li>
                                      <li>Step 4: Take action. Create a SERVE2MENTOR post and share it
                                      with your SERVE2MENTOR Community.</li>
                                    </ul>
                                  </p>
 
                                  <p>Enjoy making a difference in your success and in the success of others!</p>
                            </td>
                          </tr>
                        </table>
                      </td>
                    </tr>
      
                  <!-- END MAIN CONTENT AREA -->
                  </table>
      
                  <!-- START FOOTER -->
                  <div class="footer">
                    <table border="0" cellpadding="0" cellspacing="0">
                      <tr>
                        <td class="content-block">
                          <a href="https://www.serve2mentor.com" target="_blank">www.serve2mentor.com</a>.
                        </td>
                      </tr>
                    </table>
                  </div>
                  <!-- END FOOTER -->
                  
                <!-- END CENTERED WHITE CONTAINER -->
                </div>
              </td>
              <td>&nbsp;</td>
            </tr>
          </table>
        </body>
      </html>
    EMAIL
  end

  def self.pac_member_acceptance_email(pac_member)
    pac = pac_member.pac
    <<-EMAIL
    <!DOCTYPE html>
    <html>
      <head>
        <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
      </head>
      <body>
        Dear #{pac_member.member.name},
         <br /><br />
          Thank you for joining the #{pac.title} collaboration team. Below are the details of the team:
           <br />
           <br />
           <b>Created By:</b>#{pac.owner.name}<br />
           <b>Description:</b>#{pac.description}<br />
           <b>Date:</b>#{pac.start_date.strftime("%m/%d/%Y")}<br />
           <b>Time:</b>#{pac.start_time}<br />
           <b>Location:</b>#{pac.facility.name}<br /> 
           <br />
           <br />
           Thank you,
         <br /><br />
        The SERVE2MENTOR Team
      </body>
    </html>
    EMAIL
  end

  def self.pac_member_acceptance_email_virtual(pac_member)
    pac = pac_member.pac
    <<-EMAIL
    <!DOCTYPE html>
    <html>
      <head>
        <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
      </head>
      <body>
        Dear #{pac_member.member.name},
         <br /><br />
          Thank you for joining the #{pac.title} collaboration team. Below are the details of the team:
           <br />
           <br />
           <b>Created By:</b>#{pac.owner.name}<br />
           <b>Description:</b>#{pac.description}<br />
           <b>Date:</b>#{pac.start_date.strftime("%m/%d/%Y")}<br />
           <b>Time:</b>#{pac.start_time}<br />
           <b>Online Info:</b>#{pac.online_info}<br />
           <br />
           <br />
           Thank you,
         <br /><br />
        The SERVE2MENTOR Team
      </body>
    </html>
    EMAIL
  end

  def new_invite_email_collegue_email(recipient, current_user)
    email_with_name = "#{current_user.name} <#{current_user.email}>"
    mail(
        :from => email_with_name,
        :to => recipient, 
        :content_type => 'text/html',
        :subject => "You've been invited to join SERVE2MENTOR!", 
        :body => self.class.invite_email_collegue_email(recipient, current_user)
        )
  end

  def self.invite_email_collegue_email(recipient, current_user)
    <<-EMAIL
    <!DOCTYPE html>
    <html>
      <head>
        <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
      </head>
      <body>
          You have been invited by #{current_user.name} to join SERVE2MENTOR; where you can collaborate with collegues, learn skills from peers, and teach newfound skills to others!
          <br /><br />
          Go to www.serve2mentor.com and sign up today.  
         <br /><br />
        Thanks,
        <br />
        The SERVE2MENTOR Team
      </body>
    </html>
    EMAIL
  end

  def new_user_welcome_email(user)
    mail(
        :to => user.email, 
        :content_type => "text/html",
        :subject => "Welcome to www.serve2mentor.com!",
        :body => self.class.welcome_email(user)
      )
  end

  def new_fast_content_email(user, fast_content)
    mail(
        :to => user.email, 
        :content_type => "text/html",
        :subject => "SERVE2MENTOR Resources",
        :body => self.class.fast_content_email(user, fast_content)
      )
  end

  def self.fast_content_email(user, fast_content)
    <<-EMAIL
    <!DOCTYPE html>
    <html>
      <head>
        <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
      </head>
      <body>
        Dear #{user.name},
         <br /><br />
          A new resource for #{fast_content.organization.title} has been added to www.serve2mentor.com with the topic of #{fast_content.topic}. 
      </body>
    </html>
    EMAIL
  end

  def new_best_practice_email(user, best_practice)
    if best_practice.is_public
    email_with_name = "#{best_practice.user.name} <notification@serve2perform.com>"
    mail(
        :from => email_with_name,
        :to => user.email, 
        :content_type => "text/html",
        :subject => "SERVE2MENTOR Insight",
        :body => self.class.best_practice_email(user, best_practice)
      )
    else
    email_with_name = "#{best_practice.user.name} <notification@serve2perform.com>"
    mail(
        :from => email_with_name,
        :to => user.email, 
        :content_type => "text/html",
        :subject => "SERVE2MENTOR Insight",
        :body => self.class.best_practice_company_email(user, best_practice)
      )
  end
end

  def self.best_practice_company_email(user, best_practice)
    <<-EMAIL
    <!DOCTYPE html>
    <html>
      <head>
        <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
      </head>
      <body>
        Dear #{user.name},
         <br/>
         I have posted an Insight on <a href="https://www.serve2mentor.com/" target="_blank">www.serve2mentor.com</a>.
         <br/><br/>
         Click <a href="https://www.serve2mentor.com/best_practices/#{best_practice.id}" target="_blank">here</a> to <b>View</b>, <b>Like</b>, and to <b>Comment</b> on this Insight.
      </body>
    </html>
    EMAIL
  end

    def self.best_practice_email(user, best_practice)
    <<-EMAIL
    <!DOCTYPE html>
    <html>
      <head>
        <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
      </head>
      <body>
        Dear #{user.name},
         <br/>
         I have posted a Insight on <a href="https://www.serve2mentor.com/" target="_blank">www.serve2mentor.com</a>.
         <br/><br/>
         Click <a href="https://www.serve2mentor.com/best_practices/#{best_practice.id}" target="_blank">here</a> to <b>View</b>, <b>Like</b>, and to <b>Comment</b> on this Insight.
      </body>
    </html>
    EMAIL
  end

  def new_inquiry_email(user, inquiry)
    if inquiry.is_public
    email_with_name = "#{inquiry.user.name} <notification@serve2perform.com>"
    mail(
        :from => email_with_name,
        :to => user.email, 
        :content_type => "text/html",
        :subject => "SERVE2MENTOR Question",
        :body => self.class.inquiry_email(user, inquiry)
      )
  else
    email_with_name = "#{inquiry.user.name} <notification@serve2perform.com>"
    mail(
        :from => email_with_name,
        :to => user.email, 
        :content_type => "text/html",
        :subject => "SERVE2MENTOR Question",
        :body => self.class.inquiry_company_email(user, inquiry)
      )
  end
end

  def self.inquiry_company_email(user, inquiry)
    <<-EMAIL
    <!DOCTYPE html>
    <html>
      <head>
        <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
      </head>
      <body>
        Dear #{user.name},
         <br/>
         I have posted a <b>#{inquiry.category} question</b> on <a href="https://www.serve2mentor.com/" target="_blank">www.serve2mentor.com</a>.
         <br/><br/>
         Click <a href="https://www.serve2mentor.com/inquiries/#{inquiry.id}" target="_blank">here</a> to <b>View</b>, <b>Like</b>, and to provide an answer to this question.
         <br /><br />
        Have a great day!
      </body>
    </html>
    EMAIL
  end

    def self.inquiry_email(user, inquiry)
    <<-EMAIL
    <!DOCTYPE html>
    <html>
      <head>
        <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
      </head>
      <body>
        Dear #{user.name},
         <br/>
         I have posted a <b>#{inquiry.category} question</b> on <a href="https://www.serve2mentor.com/" target="_blank">www.serve2mentor.com</a>. 
         <br/><br/>
         Click <a href="https://www.serve2mentor.com/inquiries/#{inquiry.id}" target="_blank">here</a> to <b>View</b>, <b>Like</b>, and to provide an answer to this question.
         <br /><br />
        Have a great day!
      </body>
    </html>
    EMAIL
  end

  def new_comment_email(user, best_practice, comment)
    if best_practice.is_public
    email_with_name = "#{comment.user.name} <notification@serve2perform.com>"
    mail(
        :from => email_with_name,
        :to => user.email, 
        :content_type => "text/html",
        :subject => "SERVE2MENTOR Comment",
        :body => self.class.comment_email(user, best_practice, comment)
      )
  else
  email_with_name = "#{comment.user.name} <notification@serve2perform.com>"
    mail(
        :from => email_with_name,
        :to => user.email, 
        :content_type => "text/html",
        :subject => "Check out my comment on the #{best_practice.category} idea on SERVE2MENTOR",
        :body => self.class.comment_company_email(user, best_practice, comment)
      )
  end
end

  def self.comment_company_email(user, best_practice, comment)
    <<-EMAIL
    <!DOCTYPE html>
    <html>
      <head>
        <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
      </head>
      <body>
        Dear #{user.name},
         <br/>
         I have posted a comment on the <b>Insight by #{best_practice.user.name}</b> on <a href="https://www.serve2mentor.com/" target="_blank">www.serve2mentor.com</a>. 
         <br/><br/>
         Click <a href="https://www.serve2mentor.com/best_practices/#{best_practice.id}" target="_blank">here</a> to <b>View</b>, <b>Like</b>, <b>Comment</b> and join in on the discussion.
      </body>
    </html>
    EMAIL
  end

    def self.comment_email(user, best_practice, comment)
    <<-EMAIL
    <!DOCTYPE html>
    <html>
      <head>
        <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
      </head>
      <body>
        Dear #{user.name},
         <br/>
         I have posted a comment on the <b>Insight by #{best_practice.user.name}</b> on <a href="https://www.serve2mentor.com/" target="_blank">www.serve2mentor.com</a>. 
         <br/><br/>
         Click <a href="https://www.serve2mentor.com/best_practices/#{best_practice.id}" target="_blank">here</a> to <b>View</b>, <b>Like</b>, <b>Comment</b> and join in on the discussion.
      </body>
    </html>
    EMAIL
  end

  def new_answer_email(user, inquiry, comment)
    if inquiry.is_public
    email_with_name = "#{comment.user.name} <notification@serve2perform.com>"
    mail(
        :from => email_with_name,
        :to => user.email, 
        :content_type => "text/html",
        :subject => "Check out my answer on the #{inquiry.category} question on SERVE2MENTOR",
        :body => self.class.answer_email(user, inquiry, comment)
      )
  else
  email_with_name = "#{comment.user.name} <notification@serve2perform.com>"
    mail(
        :from => email_with_name,
        :to => user.email, 
        :content_type => "text/html",
        :subject => "Check out my comment on the #{inquiry.category} question on SERVE2MENTOR",
        :body => self.class.answer_company_email(user, inquiry, comment)
      )
  end
end

  def self.answer_company_email(user, inquiry, comment)
    <<-EMAIL
    <!DOCTYPE html>
    <html>
      <head>
        <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
      </head>
      <body>
        Dear #{user.name},
         <br/>
         I have posted an answer on the <b>#{inquiry.category} question</b> on <a href="https://www.serve2mentor.com/" target="_blank">www.serve2mentor.com</a>. 
         <br/><br/>
         Click <a href="https://www.serve2mentor.com/inquiries/#{inquiry.id}" target="_blank">here</a> to <b>View</b>, <b>Like</b>, <b>Answer</b> and join in on the discussion.
         <br /><br />
        Have a great day!
      </body>
    </html>
    EMAIL
  end

    def self.answer_email(user, inquiry, comment)
    <<-EMAIL
    <!DOCTYPE html>
    <html>
      <head>
        <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
      </head>
      <body>
        Dear #{user.name},
         <br/>
         I have posted an answer on the <b>#{inquiry.category} question</b> on <a href="https://www.serve2mentor.com/" target="_blank">www.serve2mentor.com</a>. 
         <br/><br/>
         Click <a href="https://www.serve2mentor.com/inquiries/#{inquiry.id}" target="_blank">here</a> to <b>View</b>, <b>Like</b>, <b>Answer</b> and join in on the discussion.
         <br /><br />
        Have a great day!
      </body>
    </html>
    EMAIL
  end

  def new_pac_comment_email(user, pac, comment)
    email_with_name = "#{comment.user.name} <notification@serve2perform.com>"
    mail(
        :from => email_with_name,
        :to => user.member.email, 
        :content_type => "text/html",
        :subject => "SERVE2MENTOR Comment",
        :body => self.class.pac_comment_email(user, pac, comment)
      )
  
end

    def self.pac_comment_email(user, pac, comment)
    <<-EMAIL
    <!DOCTYPE html>
    <html>
      <head>
        <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
      </head>
      <body>
        Dear #{user.member.name},
         <br/>
         I have posted a comment on the <b>#{pac.title} Collaboration</b> on <a href="https://www.serve2mentor.com/" target="_blank">www.serve2mentor.com</a>. 
         <br/><br/>
         Click <a href="https://www.serve2mentor.com/pacs/#{pac.id}" target="_blank">here</a> to <b>View</b>, <b>Comment</b> and join in on the discussion.
      </body>
    </html>
    EMAIL
  end


  def new_opportunity_email(user, opportunity)
    @opportunity = opportunity
    @oppcat = @opportunity.opportunity_category_id
    email_with_name = "#{opportunity.owner.name} <notification@serve2perform.com>"
    if @oppcat == 18
    mail(
      :from => email_with_name,
      :to => user.email, 
      :content_type => "text/html",
      :subject => "SERVE2MENTOR Mentorship",
      :body => self.class.mentor_opportunity_email(user, opportunity)
    )
    elsif @oppcat == 19
    mail(
      :from => email_with_name,
      :to => user.email, 
      :content_type => "text/html",
      :subject => "SERVE2MENTOR Job Shadowing",
      :body => self.class.internship_opportunity_email(user, opportunity)
    )
    elsif @oppcat == 21
    mail(
      :from => email_with_name,
      :to => user.email, 
      :content_type => "text/html",
      :subject => "SERVE2MENTOR Volunteer",
      :body => self.class.volunteer_opportunity_email(user, opportunity)
    )
    end
  end

  def self.mentor_opportunity_email(user, opportunity)
    <<-EMAIL
    <!DOCTYPE html>
    <html>
      <head>
        <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
      </head>
      <body>
        Dear #{user.name},
         <br /><br />
          I posted to be a #{opportunity.title} on <a href="https://www.serve2mentor.com/" target="_blank">www.serve2mentor.com</a>.
          <br /><br/>
          Click <a href="https://www.serve2mentor.com/opportunities/#{opportunity.id}" target="_blank">here</a> to check it out.
      </body>
    </html>
    EMAIL
  end

  def self.internship_opportunity_email(user, opportunity)
    <<-EMAIL
    <!DOCTYPE html>
    <html>
      <head>
        <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
      </head>
      <body>
        Dear #{user.name},
         <br /><br />
          I posted to be a #{opportunity.title} on <a href="https://www.serve2mentor.com/" target="_blank">www.serve2mentor.com</a>.
          <br /><br/>
          Click <a href="https://www.serve2mentor.com/opportunities/#{opportunity.id}" target="_blank">here</a> to check it out.
      </body>
    </html>
    EMAIL
  end

  def self.volunteer_opportunity_email(user, opportunity)
    <<-EMAIL
    <!DOCTYPE html>
    <html>
      <head>
        <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
      </head>
      <body>
        Dear #{user.name},
         <br /><br />
          I posted a Volunteer Opportunity on <a href="https://www.serve2mentor.com/" target="_blank">www.serve2mentor.com</a>.
          <br /><br/>
          Click <a href="https://www.serve2mentor.com/opportunities/#{opportunity.id}" target="_blank">here</a> to check it out.
      </body>
    </html>
    EMAIL
  end

  def new_recommendation_email(recommendation)
    mail(
        :to => recommendation.user.email, 
        :content_type => "text/html",
        :subject => "SERVE2MENTOR Recommendation",
        :body => self.class.recommendation_email(recommendation)
      )
  end

  def self.recommendation_email(recommendation)
    <<-EMAIL
    <!DOCTYPE html>
    <html>
      <head>
        <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
      </head>
      <body>
        Dear #{recommendation.user.name},
         <br /><br />
          You have been recommended by #{recommendation.creator.name} on SERVE2MENTOR to be a #{recommendation.rec_type}. View the recommendation here:  http://www.serve2mentor.com/recommendations/#{recommendation.id}
      </body>
    </html>
    EMAIL
  end

  def mc_join_email(mc, mentee)
    mail(
        :to => mc.mentor.email, 
        :content_type => "text/html",
        :subject => "SERVE2MENTOR - new mentee",
        :body => self.class.mc_email(mc, mentee)
      )
  end

  def self.mc_email(mc, mentee)
    <<-EMAIL
    <!DOCTYPE html>
    <html>
      <head>
        <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
      </head>
      <body>
        Dear #{mc.mentor.name},
         <br /><br />
         #{mentee.name} has joined your #{mc.mctype} mentorship!  Here's a link to their profile:
         <br /><br />
         https://www.serve2mentor.com/users/#{mentee.id}
      </body>
    </html>
    EMAIL
  end

  def mc_mentee_join_email(mc, mentee)
    mail(
        :to => mentee.email, 
        :content_type => "text/html",
        :subject => "SERVE2MENTOR - joined mentorship",
        :body => self.class.mc_mentee_email(mc, mentee)
      )
  end

  def self.mc_mentee_email(mc, mentee)
    <<-EMAIL
    <!DOCTYPE html>
    <html>
      <head>
        <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
      </head>
      <body>
        Dear #{mentee.name},
         <br /><br />
         You have joined the #{mc.mctype} Mentorship Opportunity hosted by #{mc.mentor.name}.  You should
         expect to hear from your mentor soon.
      </body>
    </html>
    EMAIL
  end

  
   def new_testimonial_email(testimonial)
    mail(
        :to => testimonial.opportunity.owner.email, 
        :content_type => "text/html",
        :subject => "You've received a testimonial on www.serve2mentor.com.",
        :body => self.class.testimonial_email(testimonial)
      )
  end

  def self.testimonial_email(testimonial)
    <<-EMAIL
    <!DOCTYPE html>
    <html>
      <head>
        <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
      </head>
      <body>
        Dear #{testimonial.opportunity.owner.name},
         <br /><br />
          You have received a testimonial from #{testimonial.creator.name} for the #{testimonial.opportunity.title} opportunity on www.serve2mentor.com. To approve this testimonial and post it to your profile, sign into SERVE2MENTOR and visit the following link. http://www.serve2mentor.com/testimonials/#{testimonial.id}/approve 
         <br /><br />
        Thanks,
        <br />
        The SERVE2MENTOR Team
      </body>
    </html>
    EMAIL
  end

  def new_feedback_email(feedback)
    mail(
        :to => feedback.opportunity.owner.email, 
        :content_type => "text/html",
        :subject => "You've received feedback on www.serve2mentor.com.",
        :body => self.class.feedback_email(feedback)
      )
  end

  def self.feedback_email(feedback)
    <<-EMAIL
    <!DOCTYPE html>
    <html>
      <head>
        <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
      </head>
      <body>
        Dear #{feedback.opportunity.owner.name},
         <br /><br />
          You have received feedback for the #{feedback.opportunity.title} skill on www.serve2mentor.com. To view your skill feedback, visit the Manage Skills page under your profile in SERVE2MENTOR.
        Thanks,
        <br />
        The SERVE2MENTOR Team
      </body>
    </html>
    EMAIL
  end

  def self.welcome_email(user)
    <<-EMAIL
    <!DOCTYPE html>
    <html>
      <head>
        <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
      </head>
      <body>
        Dear #{user.name},
         <br /><br />
        Welcome to <a href="http://www.serve2mentor.com">www.serve2mentor.com</a>!<br />
        Whether you are looking to grow your professional network, learn new skills, ideate with others, practice your leadership, or search and connect to a career mentor or sponsor, you've come to the right place.
         <br /><br />
         If you have not already done so, we encourage you to fully complete your SERVE2MENTOR profile. This will help facilitate your engagement with the www.serve2mentor.community. It can be done clicking on "My SERVE2MENTOR".
        <br /><br />
        Thanks,
        <br />
        The SERVE2MENTOR Team
      </body>
    </html>
    EMAIL
  end
  
  def self.low_threshold_email(user)
    <<-EMAIL
    <!DOCTYPE html>
    <html>
      <head>
        <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
      </head>
      <body>
        Hi #{user.name},
         <br /><br />
        You are getting close to running out of assessment codes on the SERVE2MENTOR platform. Please contact notification@serve2perform.com to purchase more.
         <br /><br />
        Thanks,
        <br />
        The SERVE2MENTOR Team
      </body>
    </html>
    EMAIL
  end

    def new_pac_email(user, pac)
    @pac = pac
    @owner = @pac.owner
    if @pac.opportunity_type_id == 1
      mail(
        :to => user.member.email, 
        :cc => @owner.email,
        :content_type => "text/html",
        :subject => "SERVE2MENTOR Collaboration Team Invite",
        :body => self.class.pac_email_person(user, pac)
      )
    else mail(
        :to => user.member.email, 
        :cc => @owner.email,
        :content_type => "text/html",
        :subject => "SERVE2MENTOR Collaboration Team Invite",
        :body => self.class.pac_email_virtual(user, pac)
      )
  end
end

   def self.pac_email_person(user, pac)
    <<-EMAIL
    <!DOCTYPE html>
    <html>
      <head>
        <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
      </head>
      <body>
        Dear #{user.member.name},
         <br /><br />
          You've been invited to a Collaboration Team regarding #{pac.title}. Below are the details of the team:
           <br />
           <br />
           <b>Created By:</b>#{pac.owner.name}<br />
           <b>Description:</b>#{pac.description}<br />
           <b>Date:</b>#{pac.start_date.strftime("%m/%d/%Y")}<br />
           <b>Time:</b>#{pac.start_time}<br />
           <b>Location:</b>#{pac.facility.name}<br /> 
           <br />
           <br />
           To acknowledge your participation in this team, please log in to www.serve2mentor.com and visit the below page.
           https://www.serve2mentor.com/pac_members/#{user.id}/approve
           <br /><br />
           Thank you,
         <br /><br />
        The SERVE2MENTOR Team
      </body>
    </html>
    EMAIL
  end

  def self.pac_email_virtual(user, pac)
    <<-EMAIL
    <!DOCTYPE html>
    <html>
      <head>
        <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
      </head>
      <body>
        Dear #{user.member.name},
         <br /><br />
          You've been invited to a Collaboration Team regarding #{pac.title}. Below are the details of the team:
           <br />
           <br />
           <b>Created By:</b>#{pac.owner.name}<br />
           <b>Description:</b>#{pac.description}<br />
           <b>Date:</b>#{pac.start_date.strftime("%m/%d/%Y")}<br />
           <b>Time:</b>#{pac.start_time}<br />
           <b>Web Conferecing Info:</b>#{pac.online_info}<br /> 
           <br />
           <br />
           To acknowledge your participation in this team, please log in to www.serve2mentor.com and visit the below page.
           https://www.serve2mentor.com/pac_members/#{user.id}/approve
           <br /><br />
           Thank you,
         <br /><br />
        The SERVE2MENTOR Team
      </body>
    </html>
    EMAIL
  end
  
  def new_opportunity_application(opportunity_application)
    @opportunity_application = opportunity_application
    @manager = @opportunity_application.opportunity.owner
    @user = @opportunity_application.user
    @opportunity = @opportunity_application.opportunity
    @oppcat = @opportunity.opportunity_category_id
    if @opportunity.opportunity_type_id == 2
    mail(
      :to => @user.email,
      :cc => @manager.email,
      :bcc => "tdenison@performancegpa.com",
      :content_type => "text/html",
      :subject => "SERVE2MENTOR Opportunity",
      :body => self.class.webcast_application_email(@opportunity_application),
      :return_path => @opportunity_application.user.email
    )
  elsif @opportunity.opportunity_type_id == 1
    mail(
      :to => @user.email,
      :cc => @manager.email,
      :content_type => "text/html",
      :subject => "SERVE2MENTOR Opportunity",
      :body => self.class.application_email(@opportunity_application),
      :return_path => @opportunity_application.user.email
    )
  end
  end

  def self.application_email(opportunity_application)
    @manager = opportunity_application.opportunity.owner
    @opportunity = opportunity_application.opportunity
    @user = opportunity_application.user
    <<-EMAIL
      <!DOCTYPE html>
      <html>
        <head>
          <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
        </head>
        <body>
           Dear #{@user.name},
           <br />
           <br />  
           Congratulations, you have successfully registered for this opportunity.
           <br />
           <br />
           <b>Title:</b>#{@opportunity.title}<br />
           <b>Date:</b>#{@opportunity.start_date.strftime("%m/%d/%Y")}<br />
           <b>Time:</b>#{@opportunity.meeting_time}<br />
           <b>Location:</b>#{@opportunity.location}<br /> 
           <br />
           <br />
           If you are not able to participate, please notify your connection as soon as possible.
        </body>
      </html>
    EMAIL
  end

    def self.webcast_application_email(opportunity_application)
    @manager = opportunity_application.opportunity.owner
    @opportunity = opportunity_application.opportunity
    @user = opportunity_application.user
    <<-EMAIL
      <!DOCTYPE html>
      <html>
        <head>
          <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
        </head>
        <body>
           Dear #{@user.name},
           <br />
           <br />  
           Congratulations, you have successfully registered for this opportunity.
           <br />
           <br />
           <b>Title:</b>#{@opportunity.title}<br />
           <b>Date:</b>#{@opportunity.start_date.strftime("%m/%d/%Y")}<br />
           <b>Time:</b>#{@opportunity.meeting_time}<br />
           <b>Location:</b>#{@opportunity.location}<br /> 
           <br />
           <br />
           If you are not able to participate, please notify your connection as soon as possible.
        </body>
      </html>
    EMAIL
  end

  def skill_completed_email(opportunity_application)
    @opportunity_application = opportunity_application
    @manager = @opportunity_application.opportunity.owner
    @user = @opportunity_application.user
    @opportunity = @opportunity_application.opportunity
    @oppcat = @opportunity.opportunity_category_id
    mail(
        :to => @user.email, 
        :content_type => "text/html",
        :subject => "SERVE2MENTOR Review",
        :body => self.class.completed_email(opportunity_application)
      )
  end

  def self.completed_email(opportunity_application)
    <<-EMAIL
    <!DOCTYPE html>
    <html>
      <head>
        <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
      </head>
      <body>
        Dear #{@user.name},
         <br /><br />
          Now that you have attended #{@opportunity.title}, we know #{@manager.name} would love your feedback. Please sign in to SERVE2MENTOR and visit https://www.serve2mentor.com/feedbacks/new?opportunity_id=#{@opportunity.id} to help develop those developing you. 
         <br /><br />
        Thanks,
        <br />
        The SERVE2MENTOR Team
      </body>
    </html>
    EMAIL
  end

  def recommendation_completed_email(recommendation_application)
    @recommendation_application = recommendation_application
    @manager = @recommendation_application.recommendation.user
    @user = @recommendation_application.user
    @recommendation = @recommendation_application.recommendation
    @reccat = @recommendation.opportunity_category_id
    mail(
        :to => @user.email, 
        :content_type => "text/html",
        :subject => "SERVE2MENTOR Review",
        :body => self.class.rec_completed_email(recommendation_application)
      )
  end

  def self.rec_completed_email(recommendation_application)
    <<-EMAIL
    <!DOCTYPE html>
    <html>
      <head>
        <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
      </head>
      <body>
        Dear #{@user.name},
         <br /><br />
          Now that you have attended a mentorship, we know #{@manager.name} would love your feedback. Please sign in to SERVE2MENTOR and visit https://www.serve2mentor.com/testimonials/new?recommendation_id=#{@recommendation.id} to help develop those developing you. 
         <br /><br />
        Thanks,
        <br />
        The SERVE2MENTOR Team
      </body>
    </html>
    EMAIL
  end

  
  def new_manager_opportunity_application(opportunity_application)
    @opportunity_application = opportunity_application
    @manager = @opportunity_application.opportunity.owner
    @user = @opportunity_application.user
    @opportunity = @opportunity_application.opportunity
    @oppcat = @opportunity.opportunity_category_id
    @opptitle = @opportunity.title
    if @oppcat == 17
      mail(
      :to => @manager.email,
      :cc => @user.email,
      :content_type => "text/html",
      :subject => "#{@user.name} wants you for their #{@opportunity.opportunity_category.name}!",
      :body => self.class.opportunity_coach_application_email(@opportunity_application),
      :return_path => @opportunity_application.user.email
    )
    elsif @oppcat == 18
      if @opptitle == "Mentee"
        mail(
        :to => @manager.email,
        :content_type => "text/html",
        :subject => "SERVE2MENTOR Mentorship",
        :body => self.class.opportunity_mentee_application_email(@opportunity_application),
        :return_path => @opportunity_application.user.email
      )
      elsif @opptitle == "Mentor"
        mail(
        :to => @manager.email,
        :content_type => "text/html",
        :subject => "SERVE2MENTOR Mentorship",
        :body => self.class.opportunity_mentor_application_email(@opportunity_application),
        :return_path => @opportunity_application.user.email
      )
      end
    elsif @oppcat == 19
      if @opptitle == "Job Shadow Host"
        mail(
        :to => @manager.email,
        :content_type => "text/html",
        :subject => "SERVE2MENTOR Job Shadowing",
        :body => self.class.opportunity_js_host_application_email(@opportunity_application),
        :return_path => @opportunity_application.user.email
      )
      elsif @opptitle == "Job Shadow Student"
        mail(
        :to => @manager.email,
        :content_type => "text/html",
        :subject => "SERVE2MENTOR Job Shadowing",
        :body => self.class.opportunity_js_student_application_email(@opportunity_application),
        :return_path => @opportunity_application.user.email
      )
      end
    elsif @oppcat == 21
      if @opptitle == "Volunteer Opportunity"
        mail(
        :to => @manager.email,
        :content_type => "text/html",
        :subject => "SERVE2MENTOR Volunteer",
        :body => self.class.opportunity_volunteer_opp_application_email(@opportunity_application),
        :return_path => @opportunity_application.user.email
      )
      elsif @opptitle == "Volunteer"
        mail(
        :to => @manager.email,
        :content_type => "text/html",
        :subject => "SERVE2MENTOR Volunteer",
        :body => self.class.opportunity_volunteer_application_email(@opportunity_application),
        :return_path => @opportunity_application.user.email
      )
      end
    else
      mail(
      :to => @manager.email,
      :cc => @user.email,
      :content_type => "text/html",
      :subject => "#{@user.name} wants you for their #{@opportunity.opportunity_category.name}!",
      :body => self.class.opportunity_manager_application_email(@opportunity_application),
      :return_path => @opportunity_application.user.email
    )
    end
  end

  def self.opportunity_mentor_application_email(opportunity_application)
    @manager = opportunity_application.opportunity.owner
    @opportunity = opportunity_application.opportunity
    @user = opportunity_application.user
    <<-EMAIL
      <!DOCTYPE html>
      <html>
        <head>
          <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
        </head>
        <body>
           Dear #{@manager.name},
           <br />
           <br />  
           Congratulations, #{@user.name} registered to be mentored by you! Below is their contact information along with a link to the action plan. We recommend you meet with them as soon as possible to help complete the Action Plan Template.
           <br />
           <br />
           #{@user.email}
           <br />
           <br />
           <a href="https://www.serve2mentor.com/coach_action_plans/new" target="_blank">Action Plan Template</a>
        </body>
      </html>
    EMAIL
  end

  def self.opportunity_mentee_application_email(opportunity_application)
    @manager = opportunity_application.opportunity.owner
    @opportunity = opportunity_application.opportunity
    @user = opportunity_application.user
    <<-EMAIL
      <!DOCTYPE html>
      <html>
        <head>
          <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
        </head>
        <body>
           Dear #{@manager.name},
           <br />
           <br />  
           Congratulations, #{@user.name} registered to be your mentor! Below is their contact information along with a link to the action plan. We recommend you meet with them as soon as possible to help complete the Action Plan Template.
           <br />
           <br />
           #{@user.email}
           <br />
           <br />
           <a href="https://www.serve2mentor.com/coach_action_plans/new" target="_blank">Action Plan Template</a>
        </body>
      </html>
    EMAIL
  end

  def self.opportunity_js_host_application_email(opportunity_application)
    @manager = opportunity_application.opportunity.owner
    @opportunity = opportunity_application.opportunity
    @user = opportunity_application.user
    <<-EMAIL
      <!DOCTYPE html>
      <html>
        <head>
          <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
        </head>
        <body>
           Dear #{@manager.name},
           <br />
           <br />  
           Congratulations, #{@user.name} registered to be your Job Shadow Student! Below is their contact information, please contact them for scheduling.
           <br />
           <br />
           #{@user.email}
        </body>
      </html>
    EMAIL
  end

  def self.opportunity_js_student_application_email(opportunity_application)
    @manager = opportunity_application.opportunity.owner
    @opportunity = opportunity_application.opportunity
    @user = opportunity_application.user
    <<-EMAIL
      <!DOCTYPE html>
      <html>
        <head>
          <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
        </head>
        <body>
           Dear #{@manager.name},
           <br />
           <br />  
           Congratulations, #{@user.name} registered to be your Job Shadow Leader! Below is their contact information, please contact them for scheduling.
           <br />
           <br />
           #{@user.email}
        </body>
      </html>
    EMAIL
  end

  def self.opportunity_volunteer_opp_application_email(opportunity_application)
    @manager = opportunity_application.opportunity.owner
    @opportunity = opportunity_application.opportunity
    @user = opportunity_application.user
    <<-EMAIL
      <!DOCTYPE html>
      <html>
        <head>
          <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
        </head>
        <body>
           Dear #{@manager.name},
           <br />
           <br />  
           Congratulations, #{@user.name} registered for your Volunteer opportunity! Below is their contact information along with a link to the action plan. We recommend you meet with them as soon as possible to help complete the Action Plan Template.
           <br />
           <br />
           #{@user.email}
           <br /><br />
           <a href="https://www.serve2mentor.com/volunteer_action_plans/new" target="_blank">Action Plan Template</a>
        </body>
      </html>
    EMAIL
  end

  def self.opportunity_volunteer_application_email(opportunity_application)
    @manager = opportunity_application.opportunity.owner
    @opportunity = opportunity_application.opportunity
    @user = opportunity_application.user
    <<-EMAIL
      <!DOCTYPE html>
      <html>
        <head>
          <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
        </head>
        <body>
           Dear #{@manager.name},
           <br />
           <br />  
           Congratulations, #{@user.name} registered for you to be a Volunteer! Below is their contact information along with a link to the action plan. We recommend you meet with them as soon as possible to help complete the Action Plan Template.
           <br />
           <br />
           #{@user.email}
           <br /><br />
           <a href="https://www.serve2mentor.com/volunteer_action_plans/new" target="_blank">Action Plan Template</a>
        </body>
      </html>
    EMAIL
  end

  def self.opportunity_manager_application_email(opportunity_application)
    @manager = opportunity_application.opportunity.owner
    @opportunity = opportunity_application.opportunity
    @user = opportunity_application.user
    <<-EMAIL
      <!DOCTYPE html>
      <html>
        <head>
          <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
        </head>
        <body>
           Dear #{@manager.name},
           <br />
           <br />  
           Congratulations, #{@user.name} registered for your #{@opportunity.title} post. Below is their contact information.
           <br />
           <br />
           #{@user.email}
        </body>
      </html>
    EMAIL
  end

  def new_opportunity_registration_approval(opportunity)
    @opportunity = opportunity 
      if @opportunity.opportunity_type_id == 1
        mail(
          :to => @opportunity.facility.approval_mail,
          :content_type => "text/html",
          :subject => "Post Facility Request",
          :body => self.class.opportunity_registration_approval_email(@opportunity),
        )
      else mail(
          :to => "notification@serve2perform.com",
          :content_type => "text/html",
          :subject => "Post Webcast Request",
          :body => self.class.opportunity_webcast_approval_email(@opportunity),
        )
      end
  end
  
  def self.opportunity_registration_approval_email(opportunity)
    @opportunity = opportunity 
    <<-EMAIL
      <!DOCTYPE html>
      <html>
        <head>
          <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
        </head>
        <body>
           Dear #{@opportunity.facility.approval_name},
           <br />
           <br />
           We would like to confirm the availability of #{@opportunity.facility.name} for the #{@opportunity.title} post.
           <br />
           <br />
           Please go to http://www.serve2mentor.com/availability/#{@opportunity.id} and enter the code: <b> #{@opportunity.approval_code} </b>.
            On the next screen you will be able to accept or reject the request based on your facility's availability.
           <br />
           <br />
           If you have any questions, please do not hesitate to contact us at notification@serve2perform.com or (479) 301-2012.
           <br />
           <br />
           Sincerely,
           <br />
           <br />
           The SERVE2MENTOR Team
           <br />
        </body>
      </html>
    EMAIL
  end
  
  def self.opportunity_webcast_approval_email(opportunity)
    @opportunity = opportunity 
    <<-EMAIL
      <!DOCTYPE html>
      <html>
        <head>
          <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
        </head>
        <body>
           Dear Info,
           <br />
           <br />
           We would like to confirm the availability of #{@opportunity.opportunity_type.name} for the #{@opportunity.title} post.
           <br />
           <br />
           Please go to http://www.serve2mentor.com/availability/#{@opportunity.id} and enter the code: <b> #{@opportunity.approval_code} </b>.
            On the next screen you will be able to accept or reject the request based on the availability. Please enter the webinar number as well as the account used to create the webcast if applicable.
           <br />
           <br />
           If you have any questions, please do not hesitate to contact us at notification@serve2perform.com or (479) 301-2012.
           <br />
           <br />
           Sincerely,
           <br />
           <br />
           The SERVE2MENTOR Team
           <br />
        </body>
      </html>
    EMAIL
  end

  def new_pac_registration_approval(pac)
    @pac = pac 
      if @pac.opportunity_type_id == 1
        mail(
          :to => @pac.facility.approval_mail,
          :content_type => "text/html",
          :subject => "Collaboration Team Facility Request",
          :body => self.class.pac_registration_approval_email(@pac),
            )
      end
  end
  
  def self.pac_registration_approval_email(pac)
    @pac = pac 
    <<-EMAIL
      <!DOCTYPE html>
      <html>
        <head>
          <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
        </head>
        <body>
           Dear #{@pac.facility.approval_name},
           <br />
           <br />
           We would like to confirm the availability of #{@pac.facility.name}  on 
           #{@pac.start_date.strftime("%m/%d/%Y")} at #{@pac.start_time} for the #{@pac.title} team.
           <br />
           <br />
           Please go to http://www.serve2mentor.com/pac_availability/#{@pac.id} and enter the code: <b> #{@pac.approval_code} </b>.
            On the next screen you will be able to accept or reject the request based on your facility's availability.
           <br />
           <br />
           If you have any questions, please do not hesitate to contact us at notification@serve2perform.com or (479) 301-2012.
           <br />
           <br />
           Sincerely,
           <br />
           <br />
           The SERVE2MENTOR Team
           <br />
        </body>
      </html>
    EMAIL
  end

  def new_pac_registration_owner(pac)
    @pac = pac 
    if @pac.opportunity_type_id == 1
        mail(
        :to => @pac.owner.email ,
        :content_type => "text/html",
        :subject => "Collaboration Team Facility Request",
        :body => self.class.pac_registration_owner_email(@pac),
      )
      else 
        mail(
        :to => @pac.owner.email ,
        :content_type => "text/html",
        :subject => "Collaboration Team Facility Request",
        :body => self.class.pac_webcast_owner_email(@pac),
      )
      end
  end
  
  def self.pac_registration_owner_email(pac)
    @pac = pac 
    <<-EMAIL
      <!DOCTYPE html>
      <html>
        <head>
          <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
        </head>
        <body>
           Dear #{@pac.owner.name},
           <br />
           <br />
           Thank you for submitting your team! Your request to reserve  #{@pac.facility.name} on 
           #{@pac.start_date.strftime("%m/%d/%Y")} at #{@pac.start_time} for the #{@pac.title} post has been sent to the facility contact for approval. 
           You will receive another email when your request has been accepted or rejected. 
           In the case, that your request is rejected please contact me at notification@serve2perform.com or (479) 301-2013 to identify another location for your session.
           <br />
           <br />
           Please contact the facility contact, #{@pac.facility.approval_name} at #{@pac.facility.approval_mail} for any questions or concerns. 
           <br />
           <br />
           Sincerely,
           <br />
           <br />
           The SERVE2MENTOR Team
        </body>
      </html>
    EMAIL
  end

    def self.pac_webcast_owner_email(pac)
    @pac = pac 
    <<-EMAIL
      <!DOCTYPE html>
      <html>
        <head>
          <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
        </head>
        <body>
           Dear #{@pac.owner.name},
           <br />
           <br />
           Thank you for submitting your team! Your request to reserve a host a #{@pac.opportunity_type.name} on 
           #{@pac.start_date.strftime("%m/%d/%Y")} at #{@pac.start_time} for the #{@pac.title} post has been sent to the facility contact for approval. 
           You will receive another email when your request has been accepted or rejected. 
           In the case, that your request is rejected please contact us at notification@serve2perform.com or (479) 301-2013 to identify another location for your session.
           <br />
           <br />
           Sincerely,
           <br />
           <br />
           The SERVE2MENTOR Team
        </body>
      </html>
    EMAIL
  end

  def new_opportunity_registration_owner(opportunity)
    @opportunity = opportunity 
    if @opportunity.opportunity_type_id == 1
        mail(
        :to => @opportunity.owner.email ,
        :content_type => "text/html",
        :subject => "Post Facility Request",
        :body => self.class.opportunity_registration_owner_email(@opportunity),
      )
      else 
        mail(
        :to => @opportunity.owner.email ,
        :content_type => "text/html",
        :subject => "Post Facility Request",
        :body => self.class.opportunity_webcast_owner_email(@opportunity),
      )
      end
  end
  
  def self.opportunity_registration_owner_email(opportunity)
    @opportunity = opportunity 
    <<-EMAIL
      <!DOCTYPE html>
      <html>
        <head>
          <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
        </head>
        <body>
           Dear #{@opportunity.owner.name},
           <br />
           <br />
           Thank you for submitting your post! Your request to reserve  #{@opportunity.facility.name} on 
           #{@opportunity.start_date.strftime("%m/%d/%Y")} at #{@opportunity.start_time} for the #{@opportunity.title} post has been sent to the facility contact for approval. 
           You will receive another email when your request has been accepted or rejected. 
           In the case, that your request is rejected please contact me at notification@serve2perform.com or (479) 301-2013 to identify another location for your session.
           <br />
           <br />
           Please contact the facility contact, #{@opportunity.facility.approval_name} at #{@opportunity.facility.approval_mail} for any questions or concerns. 
           <br />
           <br />
           Sincerely,
           <br />
           <br />
           The SERVE2MENTOR Team
        </body>
      </html>
    EMAIL
  end

    def self.opportunity_webcast_owner_email(opportunity)
    @opportunity = opportunity 
    <<-EMAIL
      <!DOCTYPE html>
      <html>
        <head>
          <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
        </head>
        <body>
           Dear #{@opportunity.owner.name},
           <br />
           <br />
           Thank you for submitting the #{@opportunity.opportunity_type.name} post!

           In the case, that your request is rejected please contact us at notification@serve2perform.com or (479) 301-2013 to identify another location for your session.
           <br />
           <br />
           Sincerely,
           <br />
           <br />
           The SERVE2MENTOR Team
        </body>
      </html>
    EMAIL
  end

  def reject_pac_availability(pac)
    @pac = pac 
    if @pac.opportunity_type.id == 1
    mail(
      :to => @pac.owner.email,
      :content_type => "text/html",
      :subject => "Collaboration Team Facility Request Rejected",
      :body => self.class.reject_pac_availability_email(@pac)
    )
    else
        mail(
      :to => @pac.owner.email,
      :content_type => "text/html",
      :subject => "Collaboration Team Facility Request Rejected",
      :body => self.class.reject_webcast_pac_availability_email(@pac)
    )
    end
  end
  def self.reject_pac_availability_email(pac)
    @pac = pac 
    <<-EMAIL
      <!DOCTYPE html>
      <html>
        <head>
          <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
        </head>
        <body>
           Dear #{@pac.facility.approval_name},
           <br />
           <br />
           Your request to reserve #{@pac.facility.name}  on 
           #{@pac.start_date.strftime("%m/%d/%Y")} at #{@pac.start_time} for the #{@pac.title} skill has been rejected.
           <br />
           <br />
           Please contact us at notification@serve2perform.com or (479) 301-2012 to identify another location for your session. 
           <br />
           <br />
           Sincerely,
           <br />
           <br />
           The SERVE2MENTOR Team
        </body>
      </html>
    EMAIL
  end

  def self.reject_webcast_pac_availability_email(pac)
    @pac = pac 
    <<-EMAIL
      <!DOCTYPE html>
      <html>
        <head>
          <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
        </head>
        <body>
           Dear #{@pac.facility.approval_name},
           <br />
           <br />
           Your request to reserve #{@pac.opportunity_type.name}  on 
           #{@pac.start_date.strftime("%m/%d/%Y")} at #{@pac.start_time} for the #{@pac.title} skill has been rejected.
           <br />
           <br />
           Please contact us at notification@serve2perform.com or (479) 301-2012 to identify another location for your session. 
           <br />
           <br />
           Sincerely,
           <br />
           <br />
           The SERVE2MENTOR Team
        </body>
      </html>
    EMAIL
  end

  
  def reject_opportunity_availability(opportunity)
    @opportunity = opportunity 
    if @opportunity.opportunity_type.id == 1
    mail(
      :to => @opportunity.owner.email,
      :content_type => "text/html",
      :subject => "Post Facility Request Rejected",
      :body => self.class.reject_opportunity_availability_email(@opportunity)
    )
    else
        mail(
      :to => @opportunity.owner.email,
      :content_type => "text/html",
      :subject => "Post Facility Request Rejected",
      :body => self.class.reject_webcast_opportunity_availability_email(@opportunity)
    )
    end
  end
  def self.reject_opportunity_availability_email(opportunity)
    @opportunity = opportunity 
    <<-EMAIL
      <!DOCTYPE html>
      <html>
        <head>
          <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
        </head>
        <body>
           Dear #{@opportunity.facility.approval_name},
           <br />
           <br />
           Your request to reserve #{@opportunity.facility.name}  on 
           #{@opportunity.start_date.strftime("%m/%d/%Y")} at #{@opportunity.start_time} for the #{@opportunity.title} skill has been rejected.
           <br />
           <br />
           Please contact us at notification@serve2perform.com or (479) 301-2012 to identify another location for your session. 
           <br />
           <br />
           Sincerely,
           <br />
           <br />
           The SERVE2MENTOR Team
        </body>
      </html>
    EMAIL
  end

  def self.reject_webcast_opportunity_availability_email(opportunity)
    @opportunity = opportunity 
    <<-EMAIL
      <!DOCTYPE html>
      <html>
        <head>
          <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
        </head>
        <body>
           Dear #{@opportunity.facility.approval_name},
           <br />
           <br />
           Your request to reserve #{@opportunity.opportunity_type.name}  on 
           #{@opportunity.start_date.strftime("%m/%d/%Y")} at #{@opportunity.start_time} for the #{@opportunity.title} skill has been rejected.
           <br />
           <br />
           Please contact us at notification@serve2perform.com or (479) 301-2012 to identify another location for your session. 
           <br />
           <br />
           Sincerely,
           <br />
           <br />
           The SERVE2MENTOR Team
        </body>
      </html>
    EMAIL
  end

  def confirm_pac_availability(pac)
    @pac = pac 
    if @pac.opportunity_type_id == 1
    mail(
      :to => @pac.owner.email,
      :content_type => "text/html",
      :subject => "Collaboration Team Facility Request Accepted",
      :body => self.class.confirm_pac_availability_email(@pac)
    )
    elsif @pac.opportunity_type_id == 2     
    mail(
      :to => @pac.owner.email,
      :bcc => "tdenison@performancegpa.com",
      :content_type => "text/html",
      :subject => "Collaboration Team Facility Request Accepted",
      :body => self.class.confirm_gtm_pac_availability_email(@pac)
    ) 
    else
      mail(
      :to => @pac.owner.email,
      :bcc => "tdenison@performancegpa.com",
      :content_type => "text/html",
      :subject => "Collaboration Team Facility Request Accepted",
      :body => self.class.confirm_webcast_pac_availability_email(@pac)
    ) 
    end
  end
  def self.confirm_pac_availability_email(pac)
    @pac = pac 
    <<-EMAIL
      <!DOCTYPE html>
      <html>
        <head>
          <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
        </head>
        <body>
           Dear #{@pac.facility.approval_name},
           <br />
           <br />
           Your request to reserve #{@pac.facility.name}  on 
           #{@pac.start_date.strftime("%m/%d/%Y")} at #{@pac.start_time} for the #{@pac.title} skill has been accepted.
           <br />
           <br />
           Please contact the facility contact, #{@pac.facility.approval_name} at #{@pac.facility.approval_mail} for any questions or concerns.
           <br />
           <br />
           Sincerely,
           <br />
           <br />
           The SERVE2MENTOR Team
        </body>
      </html>
    EMAIL
  end

      def self.confirm_gtm_pac_availability_email(pac)
    @pac = pac 
    <<-EMAIL
      <!DOCTYPE html>
      <html>
        <head>
          <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
        </head>
        <body>
           Dear #{@pac.owner.name},
           <br />
           <br />
           Your request to reserve #{@pac.opportunity_type.name}  on 
           #{@pac.start_date.strftime("%m/%d/%Y")} at #{@pac.start_time} for the #{@pac.title} skill has been accepted. The meeting id is #{@pac.webcast_id}. 
           Please visit http://gotomeeting.com and click join meeting, where you will be asked for the meeting id listed above. Follow the directions to begin the meeting.
           <br />
           <br />
           Please contact us at notification@serve2perform.com or (479) 301-2012 for any questions or concerns.
           <br />
           <br />
           Sincerely,
           <br />
           <br />
           The SERVE2MENTOR Team
        </body>
      </html>
    EMAIL
  end



    def self.confirm_webcast_pac_availability_email(pac)
    @pac = pac 
    <<-EMAIL
      <!DOCTYPE html>
      <html>
        <head>
          <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
        </head>
        <body>
           Dear #{@pac.owner.name},
           <br />
           <br />
           Your request to reserve #{@pac.opportunity_type.name}  on 
           #{@pac.start_date.strftime("%m/%d/%Y")} at #{@pac.start_time} for the #{@pac.title} skill has been accepted. You have been registered for the event and will need to log on approximately 10 minutes early to receive control of the meeting.
           <br />
           <br />
           Please contact us at notification@serve2perform.com or (479) 301-2012 for any questions or concerns.
           <br />
           <br />
           Sincerely,
           <br />
           <br />
           The SERVE2MENTOR Team
        </body>
      </html>
    EMAIL
  end
  
  def confirm_opportunity_availability(opportunity)
    @opportunity = opportunity 
    if @opportunity.opportunity_type_id == 1
    mail(
      :to => @opportunity.owner.email,
      :content_type => "text/html",
      :subject => "Post Facility Request Accepted",
      :body => self.class.confirm_opportunity_availability_email(@opportunity)
    )
    elsif @opportunity.opportunity_type_id == 2     
    mail(
      :to => @opportunity.owner.email,
      :bcc => "tdenison@performancegpa.com",
      :content_type => "text/html",
      :subject => "Post Facility Request Accepted",
      :body => self.class.confirm_gtm_opportunity_availability_email(@opportunity)
    ) 
    else
      mail(
      :to => @opportunity.owner.email,
      :bcc => "tdenison@performancegpa.com",
      :content_type => "text/html",
      :subject => "Post Facility Request Accepted",
      :body => self.class.confirm_webcast_opportunity_availability_email(@opportunity)
    ) 
    end
  end
  def self.confirm_opportunity_availability_email(opportunity)
    @opportunity = opportunity 
    <<-EMAIL
      <!DOCTYPE html>
      <html>
        <head>
          <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
        </head>
        <body>
           Dear #{@opportunity.facility.approval_name},
           <br />
           <br />
           Your request to reserve #{@opportunity.facility.name}  on 
           #{@opportunity.start_date.strftime("%m/%d/%Y")} at #{@opportunity.start_time} for the #{@opportunity.title} skill has been accepted.
           <br />
           <br />
           Please contact the facility contact, #{@opportunity.facility.approval_name} at #{@opportunity.facility.approval_mail} for any questions or concerns.
           <br />
           <br />
           Sincerely,
           <br />
           <br />
           The SERVE2MENTOR Team
        </body>
      </html>
    EMAIL
  end

      def self.confirm_gtm_opportunity_availability_email(opportunity)
    @opportunity = opportunity 
    <<-EMAIL
      <!DOCTYPE html>
      <html>
        <head>
          <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
        </head>
        <body>
           Dear #{@opportunity.owner.name},
           <br />
           <br />
           Your request to reserve #{@opportunity.opportunity_type.name}  on 
           #{@opportunity.start_date.strftime("%m/%d/%Y")} at #{@opportunity.start_time} for the #{@opportunity.title} skill has been accepted. The meeting id is #{@opportunity.webcast_id}. 
           Please visit http://gotomeeting.com and click join meeting, where you will be asked for the meeting id listed above. Follow the directions to begin the meeting.
           <br />
           <br />
           Please contact us at notification@serve2perform.com or (479) 301-2012 for any questions or concerns.
           <br />
           <br />
           Sincerely,
           <br />
           <br />
           The SERVE2MENTOR Team
        </body>
      </html>
    EMAIL
  end



    def self.confirm_webcast_opportunity_availability_email(opportunity)
    @opportunity = opportunity 
    <<-EMAIL
      <!DOCTYPE html>
      <html>
        <head>
          <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
        </head>
        <body>
           Dear #{@opportunity.owner.name},
           <br />
           <br />
           Your request to reserve #{@opportunity.opportunity_type.name}  on 
           #{@opportunity.start_date.strftime("%m/%d/%Y")} at #{@opportunity.start_time} for the #{@opportunity.title} skill has been accepted. You have been registered for the event and will need to log on approximately 10 minutes early to receive control of the meeting.
           <br />
           <br />
           Please contact us at notification@serve2perform.com or (479) 301-2012 for any questions or concerns.
           <br />
           <br />
           Sincerely,
           <br />
           <br />
           The SERVE2MENTOR Team
        </body>
      </html>
    EMAIL
  end
  
  def scholarship_request(scholarship)
    @OpportunityScholarship = scholarship 
    mail(
      :to => "notification@serve2perform.com",
      :content_type => "text/html",
      :subject => "Opportunity Scholarship Request",
      :body => self.class.scholarship_request_email(@OpportunityScholarship)
    )
  end
  def self.scholarship_request_email(scholarship)
    @opportunity_scholarship = scholarship 
    <<-EMAIL
      <!DOCTYPE html>
      <html>
        <head>
          <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
        </head>
        <body>
           Dear Info,
           <br />
           <br />
           #{@opportunity_scholarship.user.name} has requested a scholarship for the #{@opportunity_scholarship.opportunity.title} skill. 
           <br />
           <br />             
           Reason for scholarship request:
           <br />
           #{@opportunity_scholarship.reason_to_apply} 
           <br />
           <br />
           Please go to http://www.serve2mentor.com/admin/scholarship_request/ to accept or reject this scholarship request.
           <br />
           <br />
           <b>Thank you!</b>
        </body>
      </html>
    EMAIL
  end  
  
  

  def skill_purchase_notification(purchase)
    @purchase = purchase
    mail(
      :to => "notification@serve2perform.com",
      :content_type => "text/html",
      :subject => "A purchase has been made on SERVE2MENTOR",
      :body => self.class.skill_purchase_email(@purchase)
    )
  end
  def self.skill_purchase_email(purchase)
    @purchase = purchase
    @user = User.find(purchase.user_id)
    @opportunity = Opportunity.find(purchase.opportunity.id)
    <<-EMAIL
      <!DOCTYPE html>
      <html>
        <head>
          <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
        </head>
        <body>
           Dear Info,
           <br />
           <br />
           #{@user.name} has purchased use of the #{@opportunity.title} skill. 
           <br />
           <br />             
           <b>Thank you!</b>
        </body>
      </html>
    EMAIL
  end  
  

  def scholarship_rejected(scholarship)
    @opportunity_scholarship = scholarship 
    mail(
      :to => @opportunity_scholarship.user.email,
      :content_type => "text/html",
      :subject => "Scholarship Request",
      :body => self.class.scholarship_rejected_email(@opportunity_scholarship)
    )
  end
  def self.scholarship_rejected_email(scholarship)
    @opportunity_scholarship = scholarship 
    <<-EMAIL
      <!DOCTYPE html>
      <html>
        <head>
          <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
        </head>
        <body>
           Dear #{@opportunity_scholarship.user.name},
           <br />
           <br />
           Thank you for your interest in attending the #{@opportunity_scholarship.opportunity.title} skill. After reviewing  
           your scholarship application, we are unable to accept your scholarship request at this time.
           <br />
           <br />
           If you have any questions, please do not hesitate to contact us at notification@serve2perform.com or (479) 301-2012.
           <br />
           <br />
           We look forward to working with you on subsequent opportunities.
           <br />
           <br />
           Sincerely,
           <br />
           The SERVE2MENTOR Team
        </body>
      </html>
    EMAIL
  end    
  

  def scholarship_acceptance(scholarship)
    @opportunity_scholarship = scholarship 
    mail(
      :to => @opportunity_scholarship.user.email,
      :content_type => "text/html",
      :subject => "Congratulations!",
      :body => self.class.scholarship_acceptance_email(@opportunity_scholarship)
    )
  end
  def self.scholarship_acceptance_email(scholarship)
    @opportunity_scholarship = scholarship 
    <<-EMAIL
      <!DOCTYPE html>
      <html>
        <head>
          <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
        </head>
        <body>
           Dear #{@opportunity_scholarship.user.name},
           <br />
           <br />
           Thank you for your interest in attending the #{@opportunity_scholarship.opportunity.title} skill. We are pleased to   
           inform you that your scholarship request has been accepted. 
           <br />
           <br />
           If you have any questions, please do not hesitate to contact us at notification@serve2perform.com or (479) 301-2012.
           <br />
           <br />
           Sincerely,
           <br />
           The SERVE2MENTOR Team
        </body>
      </html>
    EMAIL
  end  
  
  def organizationreport(recipient, subject, text, organization_report)
    @organization_report = organization_report
    @account = recipient
    @subject = subject
    @text = text
    attachments['organization_report.pdf'] = OrganizationReportPdf.new(@organization_report).render
    mail(:to => recipient, :subject => @subject, :body => @text)
  end  

  def new_recommendation_application(recommendation_application)
    @recommendation_application = recommendation_application
    @manager = @recommendation_application.recommendation.user
    @user = @recommendation_application.user
    @recommendation = @recommendation_application.recommendation
    @oppcat = @recommendation.opportunity_category_id
    if @oppcat == 4
      mail(
      :to => @manager.email,
      :cc => @user.email,
      :content_type => "text/html",
      :subject => "#{@user.name} wants you for their mentor!",
      :body => self.class.recommendation_coach_application_email(@recommendation_application),
      :return_path => @recommendation_application.user.email
    )
    elsif @oppcat == 1 or 8 or 10 or 14 or 16 
      mail(
      :to => @manager.email,
      :cc => @user.email,
      :content_type => "text/html",
      :subject => "#{@user.name} wants you for their mentor!",
      :body => self.class.recommendation_coach_application_email(@recommendation_application),
      :return_path => @recommendation_application.user.email
    )
    else
    mail(
      :to => @manager.email,
      :cc => @user.email,
      :content_type => "text/html",
      :subject => "#{@user.name} wants you for their mentor!",
      :body => self.class.recommendation_application_email(@recommendation_application),
      :return_path => @recommendation_application.user.email
    )            
    end
  end

  def self.recommendation_mentor_application_email(recommendation_application)
    @manager = recommendation_application.recommendation.user
    @recommendation = recommendation_application.recommendation
    @user = recommendation_application.user
    <<-EMAIL
      <!DOCTYPE html>
      <html>
        <head>
          <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
        </head>
        <body>
           Dear #{@manager.name},
           <br />
           <br />  
           Congratulations, #{@user.name} registered for your post as a mentor! Below is their contact information along with a link to the action plan. We recommend you fill it out to help achieve the desired learning and development goals.
           As an added bonus, once the action plan is filled out, you will gain a point towards a badge! Happy practicing!
           <br />
           <br />
           #{@user.email}
           <br /><br />
           https://www.serve2mentor.com/mentor_action_plans/new
           <br /><br />
           Thank you!,
           <br />
           <br />
           The SERVE2MENTOR Team
        </body>
      </html>
    EMAIL
  end

  def self.recommendation_coach_application_email(recommendation_application)
    @manager = recommendation_application.recommendation.user
    @recommendation = recommendation_application.recommendation
    @user = recommendation_application.user
    <<-EMAIL
      <!DOCTYPE html>
      <html>
        <head>
          <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
        </head>
        <body>
           Dear #{@manager.name},
           <br />
           <br />  
           Congratulations, #{@user.name} registered for your post as a mentor! Below is their contact information along with a link to the action plan. We recommend you fill it out to help achieve the desired learning and development goals.
           As an added bonus, once the action plan is filled out, you will gain a point towards a badge! Happy practicing!
           <br />
           <br />
           #{@user.email}
           <br /><br />
           https://www.serve2mentor.com/coach_action_plans/new
           <br /><br />
           Thank you!,
           <br />
           <br />
           The SERVE2MENTOR Team
        </body>
      </html>
    EMAIL
  end

  def self.recommendation_application_email(recommendation_application)
    @manager = recommendation_application.recommendation.user
    @recommendation = recommendation_application.recommendation
    @user = recommendation_application.user
    <<-EMAIL
      <!DOCTYPE html>
      <html>
        <head>
          <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
        </head>
        <body>
           Dear #{@manager.name},
           <br />
           <br />  
           Congratulations, #{@user.name} registered for your post as a mentor! Below is their contact information. Happy practicing!
           <br />
           <br />
           #{@user.email}
           <br /><br />
           Thank you!,
           <br />
           <br />
           The SERVE2MENTOR Team
        </body>
      </html>
    EMAIL
  end

  def new_recommendation_approval(recommendation)
   mail(
        :to => recommendation.user.email, 
        :content_type => "text/html",
        :subject => "You've recommendation is live on www.serve2mentor.com.",
      :body => self.class.recommendation_approval_email(recommendation),
      :return_path => recommendation.user.email
    )
  end

  def self.recommendation_approval_email(recommendation)
     <<-EMAIL
    <!DOCTYPE html>
    <html>
      <head>
        <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
      </head>
      <body>
        Dear #{recommendation.user.name},
         <br /><br />
          Thank you for approving your recommendation to be a mentor for our www.serve2mentor.community. Your skill has ben posted on the skills page.
         <br /><br />
        Thanks,
        <br />
        The SERVE2MENTOR Team
      </body>
    </html>
    EMAIL
  end

  def send_receipt(purchase)
    @purchase = purchase
    @user = User.find(purchase.user_id)
    mail(
        :to => @user.email, 
        :content_type => "text/html",
        :subject => "Thank you for your purchase on SERVE2MENTOR",
        :body => self.class.receipt_email(@purchase)
      )
  end

  def self.receipt_email(purchase)
    @purchase = purchase
    @user = User.find(purchase.user_id)
    @opportunity = Opportunity.find(purchase.opportunity.id)
    @charge_object = Stripe::Charge.retrieve(:id => @purchase.charge_id)
    @charge_amount = @charge_object.amount / 100
    <<-EMAIL
    <!DOCTYPE html>
    <html>
      <head>
        <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
      </head>
      <body>
        Dear #{@user.name},
         <br /><br />
          Thank you for your purchase on www.serve2mentor.com. Below is a receipt for your records.
         <br /><br />
           <b>Skill Name:</b>#{@opportunity.title}<br />
           <b>Order Date:</b>#{@purchase.created_at.strftime("%m/%d/%Y")}<br />
           <b>Amount:</b>$#{@charge_amount.to_i}.00<br />
           <b>Card Type:</b>#{@charge_object.card.type}<br /> 
        Thanks,
        <br />
        The SERVE2MENTOR Team
      </body>
    </html>
    EMAIL
  end

  def send_license_receipt(purchase)
    @purchase = purchase
    @user = User.find(purchase.user_id)
    mail(
        :to => @user.email, 
        :content_type => "text/html",
        :subject => "Thank you for your purchase on SERVE2MENTOR",
        :body => self.class.license_receipt_email(@purchase)
      )
  end

  def self.license_receipt_email(purchase)
    @purchase = purchase
    @user = User.find(purchase.user_id)
    @charge_object = Stripe::Charge.retrieve(:id => @purchase.charge_id)
    @charge_amount = @charge_object.amount / 100
    <<-EMAIL
    <!DOCTYPE html>
    <html>
      <head>
        <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
      </head>
      <body>
        Dear #{@user.name},
         <br /><br />
          Thank you for your purchase on www.serve2mentor.com. Below is a receipt for your records.
         <br /><br />
           <b>Order Date:</b>#{@purchase.created_at.strftime("%m/%d/%Y")}<br />
           <b>Amount:</b>$#{@charge_amount.to_i}.00<br />
           <b>Card Type:</b>#{@charge_object.card.type}<br /> 
        Thanks,
        <br />
        The SERVE2MENTOR Team
      </body>
    </html>
    EMAIL
  end

  def new_mass_email(user, sender)
    email_with_name = "Adam Arroyos <aarroyos@performancegpa.com>"
    mail(
        :from => email_with_name,
        :to => user.email, 
        :content_type => "text/html",
        :subject => "A gift from SERVE2MENTOR",
        :body => self.class.mass_email(user, sender)
      )
  end

  def self.mass_email(user, sender)
    <<-EMAIL
    <!DOCTYPE html>
    <html>
      <head>
        <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
      </head>
      <body>
        Greetings #{user.name},
        <br/><br/>
        In this season of giving, we've decided to offer each of you the opportunity to give a complimentary one-year user license to your friends, family, and colleagues. 
        There is no limit to how many you can give but the deadline for this offer is January 31, 2015. To make the giving process even easier for you, we've created a 
        <a href="www.facebook.com/SERVE2MENTOR" target="_blank">Facebook page</a> that you can share with your networks to provide them with an overview of your gift, the SERVE2MENTOR
        platform, and provide them with examples of some of the valuable social learning that has taken place. We hope you are as excited to share this gift with others as we are in sharing it with you.
        <br /><br />
        Happy Holidays!
        <br /><br />
        Adam Arroyos, PhD<br/>
        Founder and CEO<br/>
        Grandslam Performance Associates, LLC<br/>
      </body>
    </html>
    EMAIL
  end

  def pac_membership_request(pac_member)
    @pac = pac_member.pac
    mail(
        :to => @pac.owner.email, 
        :content_type => "text/html",
        :subject => "#{pac_member.member.name} wants to join the #{@pac.title} team.", 
        :body => self.class.pac_member_request_email(pac_member),
      )
  end

  def self.pac_member_request_email(pac_member)
    pac = pac_member.pac
    <<-EMAIL
    <!DOCTYPE html>
    <html>
      <head>
        <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
      </head>
      <body>
        Dear #{pac.owner.name},
         <br /><br />
          #{pac_member.member.name} would like to join the PAC, #{pac.title} that you created on www.serve2mentor.com. Please click <a href="https://www.serve2mentor.com/pac_members/#{pac_member.id}/approve">here</a> to approve their membership.
           <br />
           <br />
           Thank you,
         <br /><br />
        The SERVE2MENTOR Team
      </body>
    </html>
    EMAIL
  end

  def user_group_membership_request(user_group)
    @user_group = user_group
    @org = @user_group.group
    @member = @user_group.member
    @admin = @org.users.where(:role => 'admin')
    @admin_first = @admin.first
    mail(
        :to => @admin_first.email, 
        :content_type => "text/html",
        :subject => "#{@member.name} wants to join the #{@org.title} group.", 
        :body => self.class.user_group_member_request_email(@user_group),
      )
  end

  def self.user_group_member_request_email(user_group)
    @user_group = user_group
    @org = @user_group.group
    @member = @user_group.member
    @admin = @org.users.where(:role => 'admin') 
    @admin_first = @admin.first
    <<-EMAIL
    <!DOCTYPE html>
    <html>
      <head>
        <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
      </head>
      <body>
        Dear #{@admin_first.name},
         <br /><br />
          #{@member.name} would like to join the group, #{@org.title}, on www.serve2mentor.com. Please click <a href="https://www.serve2mentor.com/user_groups/#{@user_group.id}/approve">here</a> to approve their membership.
           <br />
           <br />
           Thank you,
         <br /><br />
        The SERVE2MENTOR Team
      </body>
    </html>
    EMAIL
  end

  def user_group_membership_approval(user_group)
    @user_group = user_group
    @org = @user_group.group
    @member = @user_group.member
    mail(
        :to => @member.email, 
        :content_type => "text/html",
        :subject => "You've been approved to join the #{@org.title} group.", 
        :body => self.class.user_group_membership_approval_email(@user_group),
      )
  end

  def self.user_group_membership_approval_email(user_group)
    @user_group = user_group
    @org = @user_group.group
    @member = @user_group.member
    <<-EMAIL
    <!DOCTYPE html>
    <html>
      <head>
        <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
      </head>
      <body>
        Dear #{@member.name},
         <br /><br />
          You've been approved to join the group, #{@org.title}, on www.serve2mentor.com. Click <a href="https://www.serve2mentor.com/organizations/#{@org.slug}">here</a> to join in on the conversation.
           <br />
           <br />
           Thank you,
         <br /><br />
        The SERVE2MENTOR Team
      </body>
    </html>
    EMAIL
  end
  
  def new_point_email(user, point)
    @pointtype = point.badge_type.id
    case @pointtype
      when 1 
        mail(
            :to => user.email, 
            :content_type => "text/html",
            :subject => "You have earned an #{point.badge_type.name} point on SERVE2MENTOR!",
            :body => self.class.ideator_point_email(user, point)
          )
      when 2
        mail(
            :to => user.email, 
            :content_type => "text/html",
            :subject => "You have earned a #{point.badge_type.name} point on SERVE2MENTOR!",
            :body => self.class.mentor_point_email(user, point)
          )
      when 3
        mail(
            :to => user.email, 
            :content_type => "text/html",
            :subject => "You have earned a #{point.badge_type.name} point on SERVE2MENTOR!",
            :body => self.class.coach_point_email(user, point)
          )
      when 6
        mail(
            :to => user.email, 
            :content_type => "text/html",
            :subject => "You have earned a #{point.badge_type.name} point on SERVE2MENTOR!",
            :body => self.class.collaborator_point_email(user, point)
          )
      end
  end

  def self.ideator_point_email(user, point)
    @userpoint = user.points.where(:badge_type_id => 1).count
    case @userpoint
      when 1
        @points_needed = "four points"
      when 2
        @points_needed = "three points"
      when 3
        @points_needed = "two points"
      when 4
      @point_needed = "one point"
    end
    <<-EMAIL
    <!DOCTYPE html>
    <html>
      <head>
        <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
      </head>
      <body>
        Dear #{user.name},
         <br/><br/>
         Congratulations! You have been awarded a point towards the ideator badge on SERVE2MENTOR and are only #{@points_needed} away from earning the badge. 
         As a reminder, to gain an ideator point, you must post an idea that is liked by at least three people and has at least one comment. 
         We congratulate you once again, and wish you the best as you continue your professional development on SERVE2MENTOR.    
        <br /><br />
        Regards
        <br /><br />
        The SERVE2MENTOR Team<br/>
      </body>
    </html>
    EMAIL
  end

  def self.collaborator_point_email(user, point)
    <<-EMAIL
    <!DOCTYPE html>
    <html>
      <head>
        <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
      </head>
      <body>
        Dear #{user.name},
         <br/><br/>
         Congratulations! You have been awarded a point towards the collaborator badge on SERVE2MENTOR and now only need one more point to earn the badge. 
         As a reminder, you earn a collaborator point each time create a pac (performance acceleration circle), so keep collaborating. 
         We congratulate you once again, and wish you the best as you continue your professional development on SERVE2MENTOR.
         <br /><br />  
        Regards
        <br /><br />
        The SERVE2MENTOR Team<br/>
      </body>
    </html>
    EMAIL
  end

  def self.mentor_point_email(user, point)
    if user.points.where(:badge_type_id => 3).count == 1
      @points_needed = "two points"
    else
      @point_needed = "one point"
    end
    <<-EMAIL
    <!DOCTYPE html>
    <html>
      <head>
        <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
      </head>
      <body>
        Dear #{user.name},
         <br/><br/>
         Congratulations! You have been awarded a point towards the #{point.badge_type.name} badge on SERVE2MENTOR and are only #{@points_needed} away from earning the badge. 
         You gain a #{point.badge_type.name} point each time submit a #{point.badge_type.name} action plan, so keep #{point.badge_type.name}ing. 
         We congratulate you once again, and wish you the best as you continue your professional development on SERVE2MENTOR.  
        <br /><br />
        Regards
        <br /><br />
        The SERVE2MENTOR Team<br/>
      </body>
    </html>
    EMAIL
  end

  def self.coach_point_email(user, point)
    if user.points.where(:badge_type_id => 4).count == 1
      @points_needed = "two points"
    else
      @point_needed = "one point"
    end
    <<-EMAIL
    <!DOCTYPE html>
    <html>
      <head>
        <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
      </head>
      <body>
        Dear #{user.name},
         <br/><br/>
         Congratulations! You have been awarded a point towards the #{point.badge_type.name} badge on SERVE2MENTOR and are only #{@points_needed} away from earning the badge. 
         You gain a #{point.badge_type.name} point each time submit a #{point.badge_type.name} action plan, so keep #{point.badge_type.name}ing. 
         We congratulate you once again, and wish you the best as you continue your professional development on SERVE2MENTOR.  
        <br /><br />
        Regards
        <br /><br />
        The SERVE2MENTOR Team<br/>
      </body>
    </html>
    EMAIL
  end

  def new_badge_email(user, badge)
    mail(
        :to => user.email, 
        :content_type => "text/html",
        :subject => "You have been awarded the #{badge.badge_type.name} badge on SERVE2MENTOR!",
        :body => self.class.badge_email(user, badge)
      )
  end

  def self.badge_email(user, badge)
    <<-EMAIL
    <!DOCTYPE html>
    <html>
      <head>
        <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
      </head>
      <body>
        Dear #{user.name},
         <br/><br/>
         Congratulations! You have been awarded the #{badge.badge_type.name} badge on SERVE2MENTOR. 
         You can view this and all previous badges by clicking <a href="https://www.serve2mentor.com/users/#{user.id}" target="_blank">here</a>.
         We congratulate you once again, and wish you the best as you continue your professional development on SERVE2MENTOR.
        <br /><br />
        Regards
        <br /><br />
        The SERVE2MENTOR Team<br/>
      </body>
    </html>
    EMAIL
  end

  def new_mass_badge_email(user, badge)
    mail(
        :to => user.email, 
        :content_type => "text/html",
        :subject => "SERVE2MENTOR badge",
        :body => self.class.mass_badge_email(user, badge),
        :return_path => badge.user.email
      )
  end

  def self.mass_badge_email(user, badge)
    <<-EMAIL
    <!DOCTYPE html>
    <html>
      <head>
        <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
      </head>
      <body>
        Dear #{user.name},
         <br /><br />
          Please join us in congratulating #{badge.user.name} for receiving the #{badge.badge_type.name} badge!  
          <br /><br/>
          To view their profile and all the badges they've earned, click <a href="https://www.serve2mentor.com/users/#{badge.user_id}">here</a>. 
          <br /><br/>
          Click <a href="https://www.serve2mentor.com/about#badge">here</a> to learn more about SERVE2MENTOR badges.
      </body>
    </html>
    EMAIL
  end

def new_coach_action_plan(coach_action_plan)
    @coach_action_plan = coach_action_plan
    @coach = @coach_action_plan.user
    @participant = @coach_action_plan.participant
    mail(
      :to => @coach.email,
      :cc => @participant.email,
      :content_type => "text/html",
      :subject => "Thank you for creating a coach action plan!",
      :body => self.class.coach_action_plan_email(@coach_action_plan),
    )
  end

  def self.coach_action_plan_email(coach_action_plan)
    @coach_action_plan = coach_action_plan
    @coach = @coach_action_plan.user
    @participant = @coach_action_plan.participant
    <<-EMAIL
      <!DOCTYPE html>
      <html>
        <head>
          <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
        </head>
        <body>
           Dear #{@coach.name},
           <br />
           <br />  
           Congratulations, you have successfully created a coach action plan for you and #{@participant.name}. 
           <br />
           <br />
           You can access this plan at this link at any time to review your goals and success indicators. <br/>
           <a href="https://www.serve2mentor.com/coach_action_plans/#{@coach_action_plan.id}">My Coaching Action Plan for #{@participant.name}</a>
           <br />
           <br />
           And, at any time, you can access this plan via <a href="https://www.serve2mentor.com">SERVE2MENTOR</a> by clicking "My Profile" and then "Manage Posts".
           <br />
           <br />
           Thank you,
           <br />
           <br />
           The SERVE2MENTOR Team
        </body>
      </html>
    EMAIL
  end

def new_mentor_action_plan(mentor_action_plan)
    @mentor_action_plan = mentor_action_plan
    @mentor = @mentor_action_plan.user
    @mentee = @mentor_action_plan.participant
    mail(
      :to => @mentor.email,
      :cc => @mentee.email,
      :content_type => "text/html",
      :subject => "Thank you for creating a mentor action plan!",
      :body => self.class.mentor_action_plan_email(@mentor_action_plan),
    )
  end

  def self.mentor_action_plan_email(mentor_action_plan)
    @mentor_action_plan = mentor_action_plan
    @mentor = @mentor_action_plan.user
    @mentee = @mentor_action_plan.participant
    <<-EMAIL
      <!DOCTYPE html>
      <html>
        <head>
          <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
        </head>
        <body>
           Dear #{@mentor.name},
           <br />
           <br />  
           Congratulations, you have successfully created a mentor action plan for you and #{@mentee.name}. 
           <br />
           <br />
           You can access this plan at this link at any time to review your goals and success indicators. <br/>
           <a href="https://www.serve2mentor.com/mentor_action_plans/#{@mentor_action_plan.id}">My Mentoring Action Plan for #{@mentee.name}</a>
           <br />
           <br />
           And, at any time, you can access this plan via <a href="https://www.serve2mentor.com">SERVE2MENTOR</a> by clicking "My Profile" and then "Manage Posts".
           <br />
           <br />
           Thank you,
           <br />
           <br />
           The SERVE2MENTOR Team
        </body>
      </html>
    EMAIL
  end

def new_volunteer_action_plan(volunteer_action_plan)
    @volunteer_action_plan = volunteer_action_plan
    @volunteer = @volunteer_action_plan.user
    @liason = @volunteer_action_plan.liason
    mail(
      :to => @volunteer.email,
      :cc => @liason.email,
      :content_type => "text/html",
      :subject => "Thank you for creating a volunteer action plan!",
      :body => self.class.volunteer_action_plan_email(@volunteer_action_plan),
    )
  end

  def self.volunteer_action_plan_email(volunteer_action_plan)
    @volunteer_action_plan = volunteer_action_plan
    @volunteer = @volunteer_action_plan.user
    @liason = @volunteer_action_plan.liason
    <<-EMAIL
      <!DOCTYPE html>
      <html>
        <head>
          <meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
        </head>
        <body>
           Dear #{@volunteer.name},
           <br />
           <br />  
           Congratulations, you have successfully created a volunteer action plan for you and #{@liason.name}. 
           <br />
           <br />
           You can access this plan at this link at any time to review your goals and success indicators. <br/>
           <a href="https://www.serve2mentor.com/volunteer_action_plans/#{@volunteer_action_plan.id}">My Volunteering Action Plan for #{@liason.name}</a>
           <br />
           <br />
           And, at any time, you can access this plan via <a href="https://www.serve2mentor.com">SERVE2MENTOR</a> by clicking "My Profile" and then "Manage Posts".
           <br />
           <br />
           Thank you,
           <br />
           <br />
           The SERVE2MENTOR Team
        </body>
      </html>
    EMAIL
  end


end

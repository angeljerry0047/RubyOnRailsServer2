class OpportunityWorker
  include Sidekiq::Worker
 
  def perform(opportunity_id)
    opportunity = Opportunity.find(opportunity_id)

    # FIXME (cmhobbs) does this include UserGroup associations?
    opportunity.organization.users.each do |member|
      Notifier.delay.new_opportunity_email(member, opportunity) unless member.mute_notifications
    end

  end

end

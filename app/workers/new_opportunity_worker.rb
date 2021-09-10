class NewOpportunityWorker
  @queue = :default

  def self.perform(opportunity_id)
    opportunity = Opportunity.find(opportunity_id)

    User.receives_email.each do |user|
      OpportunityMailer.new_opportunity(user, opportunity).deliver_now
    end
  end

end
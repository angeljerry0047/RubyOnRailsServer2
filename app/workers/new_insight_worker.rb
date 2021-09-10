class NewInsightWorker
  @queue = :default

  def self.perform(insight_id)
    insight = BestPractice.find(insight_id)

    User.receives_email.each do |user|
      unless user == insight.user
        InsightMailer.new_insight(user, insight).deliver_now
      end
    end
  end

end

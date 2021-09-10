module RecommendationsHelper

  # NOTE (cmhobbs) this should maybe be a presenter instead.
  # fite me.
  #
  # Return a hash of recommendations for a given user where keys are
  # recommendation types (best practice category titles) and values
  # are arrays of recommendations)
  def sorted_user_recommendations(user)
    recommendations = Recommendation.where(user_id: user.id)

    {}.tap do |h|
      recommendations.each do |recommendation|
        rec_type = recommendation.rec_type
        ( h[rec_type] ||= [] ) << recommendation
      end
    end
  end
end

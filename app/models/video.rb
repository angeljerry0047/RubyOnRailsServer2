# == Schema Information
#
# Table name: videos
#
#  id                      :integer          not null, primary key
#  title                   :string(255)
#  internal                :boolean
#  description             :text
#  embed_code              :text
#  competency_ids          :integer
#  category                :integer
#  learning_objectives     :string(255)
#  opportunity_category_id :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

# FIXME (cmhobbs+tyreldenison) remove this model
class Video < ActiveRecord::Base
  def self.permitted(params)
    video_whitelist = [
      :category,
      :competency_ids,
      :description,
      :embed_code,
      :internal,
      :learning_objectives,
      :opportunity_category_id,
      :title
    ]

    params.permit(video: video_whitelist)
  end
end

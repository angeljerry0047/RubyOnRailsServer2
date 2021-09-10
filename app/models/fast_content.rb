# == Schema Information
#
# Table name: fast_contents
#
#  id              :integer          not null, primary key
#  topic           :string(255)
#  description     :text
#  ext_link        :text
#  emb_link        :text
#  author          :string(255)
#  user_id         :integer
#  organization_id :integer
#  category_id     :integer
#  documents       :string(255)
#  audio           :string(255)
#  images          :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  link_title      :string(255)
#

class FastContent < ActiveRecord::Base
  def self.permitted(params)
    fast_content_whitelist = [
      :author,
      :category_id,
      :description,
      :emb_link,
      :ext_link,
      :organization_id,
      :topic,
      :user_id,
      :documents,
      :documents_cache,
      :audio,
      :audio_cache,
      :images,
      :images_cache,
      :link_title
    ]

    params.permit(fast_content: fast_content_whitelist)
  end

  belongs_to :user
  belongs_to :organization

  has_many :fast_content_departments
  has_many :departments, :through => :fast_content_departments

  mount_uploader :documents, DocumentUploader 
  mount_uploader :audio, AudioUploader

  scope :in_organization, ->(organization_id) {
    where(:organization_id => organization_id).
    order( 'created_at DESC')
  }

  def external_link
    if (ext_link =~ /http:\/\//) == 0
      ext_link
    else
      "http://" + ext_link
    end
  end

end

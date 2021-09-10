# == Schema Information
#
# Table name: badges
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  badge_type_id :integer
#  year          :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'spec_helper'

describe Badge do

  describe '#image_filename' do

    let(:badge_type) { BadgeType.new(name: 'Thought Leader') }
    let(:badge)      { Badge.new(year: 2015) }

    let(:image_filename)        { 'thoughtleader2015.png' }
    let(:mobile_image_filename) { 'thoughtleader2015mobile.png' }

    before do
      badge.stub(:badge_type) { badge_type }
    end

    it 'returns a badge image filename for the current year' do
      result = badge.image_filename
      expect(result).to eq(image_filename) 
    end

    it 'returns a mobile badge image filename for the current year' do
      result = badge.image_filename(true)
      expect(result).to eq(mobile_image_filename) 
    end

  end

end

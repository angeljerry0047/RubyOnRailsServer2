require 'spec_helper'

describe MentorshipCircle do
  describe '#full?' do
    it 'returns true if users.count == max_mentees' do
      circle = FactoryBot.create(:mentorship_circle, max_mentees: 1)
      user = FactoryBot.create(:professional)
      circle.users << user

      expect(circle.full?).to eq(true)
    end

    it 'returns false if users.count < max_mentees' do
      circle = FactoryBot.create(:mentorship_circle, max_mentees: 1)

      expect(circle.full?).to eq(false)
    end
  end
end

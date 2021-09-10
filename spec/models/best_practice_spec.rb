# == Schema Information
#
# Table name: best_practices
#
#  id                        :integer          not null, primary key
#  user_id                   :integer
#  title                     :string(255)
#  body                      :text
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  category                  :string(255)
#  emb_link                  :text
#  ext_link                  :text
#  documents                 :string(255)
#  audio                     :string(255)
#  link_title                :string(255)
#  idea_help                 :text
#  best_practice_category_id :integer
#  organization_id           :integer
#  is_public                 :boolean
#  got_point                 :boolean          default(FALSE)
#  anonymous                 :boolean
#

require 'spec_helper'

describe BestPractice do
  describe '#likes' do
    let(:insight)  { stub_model(BestPractice, likers: likers) }
    let(:user)     { stub_model(User) }
    let(:likers)   { [user] }

    it 'returns the number of users that like the BestPractice' do
      expect(insight.likes).to eq(1)
    end
  end

  describe '#external_link_display_text' do
    it 'returns existing link_title if it exists' do
      insight = FactoryBot.create(:best_practice, link_title: 'view me')
      expect(insight.external_link_display_text).to eq('view me')
    end

    it 'returns View Link if link_title is blank' do
      insight = FactoryBot.create(:best_practice, link_title: '')
      expect(insight.external_link_display_text).to eq('View Link')
    end
  end

  describe '.public_find' do
    let(:public_insight)  { FactoryBot.create(:best_practice, is_public: true) }
    let(:private_insight) { FactoryBot.create(:best_practice, is_public: false) }

    let(:public_id)  { public_insight.id }
    let(:private_id) { private_insight.id }

    it 'returns public insights' do
      result = BestPractice.public_find(public_id)
      expect(result.id).to be(public_id)
    end

    it 'does not return private insights' do
      expect { BestPractice.public_find(private_id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '.top_ten' do
    let(:public_insights) do
      FactoryBot.create_list(:best_practice, 11, is_public: true)
    end

    # NOTE: (cmhobbs) simulate the likes table provided by the
    #      socialization gem
    let(:join_public_likes) do
      [].tap do |result|
        public_insights.map do |insight|
          rand(1..5).times do
            result << { 'likeable_id' => insight.id.to_s }
          end
        end
      end
    end

    let(:top_ten) { BestPractice.top_ten }

    before do
      BestPractice.stub(:join_public_likes) { join_public_likes }
    end

    # FIXME: (cmhobbs) this feels fragile
    it 'returns an array of ten elements' do
      expect(top_ten.length).to eq(10)
    end
  end

  describe '.like_counts' do
    let(:join_public_likes) do
      [
        { 'likeable_id' => '8'  },
        { 'likeable_id' => '8'  },
        { 'likeable_id' => '8'  },
        { 'likeable_id' => '3'  },
        { 'likeable_id' => '3'  },
        { 'likeable_id' => '1'  },
        { 'likeable_id' => '1'  },
        { 'likeable_id' => '15' }
      ]
    end

    let(:expected_counts) do
      { '8' => 3, '3' => 2, '1' => 2, '15' => 1 }
    end

    before do
      BestPractice.stub(:join_public_likes) { join_public_likes }
    end

    it 'returns a Hash of BestPractice ids and counts' do
      result = BestPractice.like_counts
      expect(result).to eq(expected_counts)
    end
  end

  describe '.top_ten_ids' do
    let(:like_counts) do
      {
        '33' => 6,
        '34' => 11,
        '35' => 9,
        '42' => 3,
        '43' => 3,
        '45' => 4,
        '46' => 4,
        '47' => 2,
        '48' => 5,
        '49' => 3,
        '50' => 3,
        '51' => 4,
        '55' => 4,
        '60' => 8
      }
    end

    let(:expected_ids) do
      # ["34", "35", "60", "33", "48", "55", "45", "46", "51", "49"]
      %w[33 34 35 45 46 48 50 51 55 60]
    end

    before do
      BestPractice.stub(:like_counts) { like_counts }
    end

    it 'returns a sorted array of the top ten BestPractice ids' do
      result = BestPractice.top_ten_ids.sort
      expect(result).to eq(expected_ids.sort)
    end
  end
end

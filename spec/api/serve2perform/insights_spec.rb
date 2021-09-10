require 'spec_helper'

describe Serve2perform::Insights do

  context 'v0.1' do

    let!(:public_insight)  { FactoryBot.create(:best_practice, is_public: true) }
    let!(:private_insight) { FactoryBot.create(:best_practice, is_public: false) }

    describe 'GET /api/v0.1/insights/top_ten' do
 
      let(:top_ten_path) { '/api/v0.1/insights/top_ten.json' }

      let(:join_public_likes) do
        [
          { 'likeable_id' => public_insight.id  },
          { 'likeable_id' => public_insight.id  },
          { 'likeable_id' => public_insight.id  }
        ]
      end

      before do
        BestPractice.stub(:join_public_likes) { join_public_likes }
        get top_ten_path
      end

      it 'resolves' do
        expect(response.status).to be(200)
      end

      it 'returns the top ten best practices' do
        insight_id = JSON.parse(response.body).first.fetch('id')
        expect(insight_id).to eq(public_insight.id)
      end

    end

    describe 'GET /api/v0.1/insights' do
    
      let(:insights_path) { '/api/v0.1/insights.json' }

      before do
        get insights_path
      end

      it 'resolves' do
        expect(response.status).to be(200)
      end

      it 'returns all public best practices' do
        body        = JSON.parse(response.body)
        insight_ids = body.map { |insight| insight.fetch('id') }

        expect(insight_ids).to include(public_insight.id)  
      end

      it 'does not return private best practices' do
        body        = JSON.parse(response.body)
        insight_ids = body.map { |insight| insight.fetch('id') }

        expect(insight_ids).to_not include(private_insight.id)
      end

    end

    describe 'GET /api/v0.1/insights/id' do

      let(:public_id_path)  { "/api/v0.1/insights/#{public_insight.id}.json" }
      let(:private_id_path) { "/api/v0.1/insights/#{private_insight.id}.json" }

      it 'resolves' do
        get public_id_path
        expect(response.status).to be(200)
      end

      it 'returns a best practice matching the given id' do
        get public_id_path
        
        insight_id = JSON.parse(response.body).fetch('id')

        expect(insight_id).to eq(public_insight.id)
      end

      it 'does not return private best practices' do
        get private_id_path

        expect(response.status).to eq(404)
      end

    end

  end
end

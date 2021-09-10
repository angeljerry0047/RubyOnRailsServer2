require 'spec_helper'

describe FastContentWorker do

  let(:fast_content_owner)   { double('user') }
  let(:recipient)            { double('user') }
  let(:user_set)             { [fast_content_owner, recipient] }

  let(:fast_content)         { mock_model(FastContent, user: fast_content_owner) }
  let(:fast_content_worker)  { FastContentWorker.new }

  before do
    FastContent.stub(:find) { fast_content }

    fast_content_worker.stub(:user_set) { user_set }
    fast_content_worker.stub(:notify)
  end

  describe '#perform' do
    
    it 'does not notify the User associated with the FastContent' do
      expect(fast_content_worker).to receive(:notify).once
      fast_content_worker.perform('42')
    end

  end
end

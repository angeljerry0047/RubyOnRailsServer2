require 'spec_helper'

describe Serve2perform::API do
  
  context 'v0.1' do
    
    describe 'GET /api/v0.1/hello' do

      let(:hello_path) { '/api/v0.1/hello.json' }
      let(:greeting)   { 'my hovercraft is full of eels!' }

      it 'resolves' do
        get hello_path
        expect(response.status).to be(200)
      end

      it 'greets us for sanity' do
        get hello_path

        body = JSON.parse(response.body).fetch('greeting')
        expect(body).to eq(greeting)
      end
  
    end
  end
end
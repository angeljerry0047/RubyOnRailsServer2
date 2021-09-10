module Serve2perform
  class API < Grape::API
    prefix 'api'
    version 'v0.1', using: :path

    get :hello do
      { greeting: 'my hovercraft is full of eels!' }
    end

    rescue_from ActiveRecord::RecordNotFound do |e|
      Rack::Response.new({
        error_code: 404,
        error_message: e.message
      }.to_json, 404).finish
    end

    rescue_from :all do |e|
      Rack::Response.new({
        error_code: 500,
        error_message: e.message
      }.to_json, 500).finish
    end

    mount Serve2perform::Insights
  end
end


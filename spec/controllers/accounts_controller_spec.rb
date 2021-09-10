require 'spec_helper'

describe AccountsController do
  let(:organization) { FactoryBot.create(:company, id: 257) }

  it 'rejects most requests' do
    post :generate
    expect(response.status).to eq(401)
  end

  it 'accepts requests with the learning marketplace domain header' do
    organization
    current_user_count = User.count

    headers = { "X-Shopify-Shop-Domain" => "learning-marketplace.myshopify.com" }
    params = {
      "email" => "mister@example.com",
      "billing_address" => { "first_name" => "Mister", "last_name" => "Example" },
      "line_items" => [
        { "title" => "Shopify Item One" },
        { "title" => "Some Hub Item" }
      ]
    }

    request.headers.merge! headers
    post :generate, params

    expect(response.status).to eq(200)
    expect(User.count).to eq(current_user_count + 1)

    user = User.last

    expect(user.name).to eq("Mister Example")
    expect(user.email).to eq("mister@example.com")
    expect(user.via_shopify).to eq(true)
  end
end
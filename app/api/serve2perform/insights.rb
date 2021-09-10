module Serve2perform
  
  class Insights < Grape::API

    resource :insights do

      desc "Get the ten most liked BestPractices"
      get '/top_ten' do
        BestPractice.top_ten
      end
    
      desc "Get all public BestPractices"
      get  do
        BestPractice.is_public
      end
  
      segment '/:id' do
        desc "Get a public BestPractice by id"
        get do
          BestPractice.public_find(params['id'])
        end
      end

    end

  end
end

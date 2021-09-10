# NOTE (cmhobbs) likely broken in rails 4.0
#      https://guides.rubyonrails.org/upgrading_ruby_on_rails.html#action-pack
Rails.application.config.middleware.use OmniAuth::Builder do
end

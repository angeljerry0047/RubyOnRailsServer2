if Rails.env.production?
  Stripe.api_key = 'sk_live_I503NAcvHACyk9SEWXwKnu26'
  PUBLISHABLE_STRIPE_KEY = 'pk_live_vQnrDf8BhisUDYf1U72JrGTu'
else
  Stripe.api_key = 'sk_test_EBNqI5jkQajPXC7oQBHRtWp6'
  PUBLISHABLE_STRIPE_KEY = 'pk_test_1fB6eriYUgIeHlJEr9c4Ltg6'
end
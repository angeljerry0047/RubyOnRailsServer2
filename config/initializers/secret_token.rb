# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
Serve2perform::Application.config.secret_token = 'c1ae99d52187efb68e64c1e673491c228f9d77803f307ef4a7647924de3d78e6b36add5949288b28e3ce35360754ac473806358637b88171d6a63f470f2ffe63'

# NOTE (cmhobbs) as soon as rails 4.0 upgrade is complete, add
#      secret_key_base as seen here:
#
#      https://guides.rubyonrails.org/upgrading_ruby_on_rails.html#action-pack
#
#      READ THE WHOLE SECTION ON THIS KNOB

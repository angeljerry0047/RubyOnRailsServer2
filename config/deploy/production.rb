server '178.128.74.191', port: 1001, roles: [:web, :app, :db], primary: true

# NOTE (cmhobbs) we're using production here to mirror the prod
#      environment.  if we decide to gain other hosting for staging
#      things, we can alter this directive anda rebuld the db.
set :rails_env, 'production'
set :branch,    ENV.fetch("CAPISTRANO_BRANCH", 'master')

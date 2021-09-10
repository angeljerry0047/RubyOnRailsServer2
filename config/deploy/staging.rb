server '159.65.75.146', port: 1001, roles: [:web, :app, :db], primary: true

# NOTE (cmhobbs) we're using production here to mirror the prod
#      environment.  if we decide to gain other hosting for staging
#      things, we can alter this directive anda rebuld the db.
set :rails_env, 'production'
set :branch,    ENV.fetch("CAPISTRANO_BRANCH", 'develop')

namespace :rails do
  desc "Open rails console in staging"
  task :staging_console do
    on roles(:app) do
    exec "ssh -p 1001 -i ~/.ssh/id_rsa.pub deploy@159.65.75.146 -t 'source ~/.profile && #{current_path}/script/rails console production'"
    end
  end
end

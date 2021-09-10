set :repo_url,        'git@github.com:serve2perform/serve2perform.git'
set :application,     'serve2perform'
set :user,            'deploy'
set :puma_threads,    [4, 16]
set :puma_workers,    0

# Don't change these unless you know what you're doing
set :pty,             false  # NOTE (cmhobbs) necessary to fix a cap-sidekiq bug
set :use_sudo,        false
set :stage,           :production # XXX (cmhobbs) change this with multiple envs?
set :deploy_via,      :remote_cache
set :deploy_to,       "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
      execute "mkdir #{shared_path}/log -p"
    end
  end

  before :start, :make_dirs
end

namespace :deploy do
  desc "deploy app for the first time (expects pre-created but empty DB)"
  task :cold do
    before 'deploy:migrate', 'deploy:initdb'
    invoke 'deploy'
  end

  desc "initialize a brand-new database (db:schema:load, db:seed)"
  task :initdb do
    on primary :web do |host|
      within release_path do
        execute :rake, 'db:schema:load'
        execute :rake, 'db:migrate'
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  # USAGE:
  # cap staging deploy:rake task=rake_namespace:rake_task
  desc 'Run rake task remotely'
  task rake: [:set_rails_env] do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, ENV['task']
        end
      end
    end
  end
  
  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
  after  :finishing,    :restart
end

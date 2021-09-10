# require 'fileutils'

# worker_processes Integer(ENV["WEB_CONCURRENCY"] || 3)
# timeout 15
# preload_app true
# worker_processes 4
# listen '/tmp/nginx.socket', backlog: 1024

# before_fork do |server, worker|
#   FileUtils.touch('/tmp/app-initialized')
#   Signal.trap 'TERM' do
#     puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
#     Process.kill 'QUIT', Process.pid
#   end

#   defined?(ActiveRecord::Base) and
#     ActiveRecord::Base.connection.disconnect!
# end

# after_fork do |server, worker|
#   Signal.trap 'TERM' do
#     puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
#   end

#   if defined?(ActiveRecord::Base)
#     config = ActiveRecord::Base.configurations[Rails.env] ||
#       Rails.application.config.database_configuration[Rails.env]
#     config['adapter'] = 'postgis'
#     ActiveRecord::Base.establish_connection(config)
#   end
# end

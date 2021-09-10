class Chef
  class Recipe
    # Does this instance run sidekiq?
    def sidekiq_instance?
      role = node[:instance_role]
      role == 'solo' || role == 'eylocal' || (role == 'util' && node[:name] =~ /^sidekiq/) || role == 'app_master'
    end
  end
end
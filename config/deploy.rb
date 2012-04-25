require 'bundler/capistrano'

set :application, "matriclick"
server "matriclick.com", :app, :web, :db, :primary => true
set :repository,  "git@github.com:redvel-ltda/matriclick.git"
set :scm, "git"
set :deploy_via, :remote_cache
set :branch, "master"
set :user, "ubuntu"
set :use_sudo, false
set :keep_releases, 3

task :production do
  set :deploy_to, "/home/#{user}/apps/#{application}"
  set :database_name, "#{application}"
end

task :qa do
  set :deploy_to, "/home/#{user}/apps/qa_#{application}"
  set :database_name, "qa_#{application}"
end

ssh_options[:forward_agent] = true

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

namespace :db do  
  task :create_yml, :role => :app do
    run "echo 'production:' >> database_#{database_name}.yml"
    run "echo '  adapter: mysql2' >> database_#{database_name}.yml"
    run "echo '  encoding: utf8' >> database_#{database_name}.yml"
    run "echo '  reconnect: false' >> database_#{database_name}.yml"
    run "echo '  database: #{database_name}_production' >> database_#{database_name}.yml"
    run "echo '  pool: 5' >> database_#{database_name}.yml"
    run "echo '  username: root' >> database_#{database_name}.yml"
    run "echo '  password: mysql.ezakimak' >> database_#{database_name}.yml"
    run "echo '  socket: /var/run/mysqld/mysqld.sock' >> database_#{database_name}.yml"
  end
  
  task :db_config, :except => { :no_release => true }, :role => :app do  
    run "cp -f ~/database_#{database_name}.yml #{release_path}/config/database.yml" 
    run "cd #{release_path} && rake RAILS_ENV=production db:create" 
  end 
  
  task :run_migration, :role => :app do
    run "cd #{release_path} && rake RAILS_ENV=production db:migrate"
    run "cd #{release_path} && rake RAILS_ENV=production db:seed"
  end
end

namespace :rvm do
  task :trust_rvmrc do
    run "rvm rvmrc trust #{release_path}"
  end
end

namespace :sitemap do
  task :refresh_sitemaps do
    run "cd #{latest_release} && bundle exec rake sitemap:refresh RAILS_ENV=#{rails_env}"
  end
end

after "deploy", "sitemap:refresh_sitemaps"
after "deploy:finalize_update", "db:db_config"
after "db:db_config", "rvm:trust_rvmrc"
after "rvm:trust_rvmrc", "db:run_migration"
after "deploy:setup", "db:create_yml"
before "deploy:symlink", "deploy:cleanup"

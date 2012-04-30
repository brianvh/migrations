set :stages, %w(staging production)
set :default_stage, "staging"
# require 'capistrano/ext/multistage'

set :whenever_command, "bundle exec whenever"
set :whenever_environment, defer { stage }
require "whenever/capistrano"

set :user, "migrations"
set :use_sudo, false
set :deploy_to, "/home/#{user}/app/"

set :scm, "git"
set :application, "migrations"
set :repository, "webops@dev.dartmouth.edu:git/#{application}.git" 
set :scm_command, "/usr/local/bin/git"
set :git_shallow_clone, 1
 

require "bundler/capistrano"
before 'deploy:update_code', 'deploy:set_tag_branch'

namespace :deploy do
  desc "Use the supplied TAG as the branch to be deployed"
  task :set_tag_branch do
    deploy_tag = ENV['TAG']
    if deploy_tag
      self[:branch] = deploy_tag
      puts "Deployment set to tag \"#{deploy_tag}\""
    else
      raise "You must specify the tag to deploy with TAG=<tag name>"
    end
  end

  desc "Override restart task for Passenger deployment"
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

require 'rspec/core/rake_task'
require 'dotenv'
Dotenv.load
RSpec::Core::RakeTask.new(:spec)
task :default => :spec

namespace :travis do
  desc 'load .env variables into travis env'
  task :env do
    # use this to push variables to travis
    # the names are the lower case names of the env
    # variables set in your .env file
    %w{github_token}.each do |w|
      key = w.upcase
      `travis env set -- #{key} '#{ENV[key]}'`
    end
  end
end

task :run do
  sh "slnky service run github"
end

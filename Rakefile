require 'resque/tasks'

desc "loads up the environment"
task :environment, :env do |t, args|
  require './setup_env'
  args.with_defaults(:env => 'development')

  Openyale.configure do |oyc|
    oyc.root_path = File.join(File.dirname(__FILE__), 'spec')
  end

  Openyale.setup(args[:env])
end

# task "resque:setup" => :environment

task :console, [:env] => :environment do |t, args|
  require 'pry'
  binding.pry
end

namespace :db do
  desc "creates the schema"
  task :migrate, [:env] => :environment do |t, args|
    DataMapper.auto_migrate!
  end

  desc "updates the schema"
  task :upgrade, [:env] => :environment do |t, args|
    DataMapper.auto_upgrade!
  end
end

source :rubygems

gem 'eventmachine'
gem 'erubis'
gem 'resque'
gem 'resque-status'
gem 'rake'
gem 'activesupport'
gem 'sinatra'

gem 'datamapper'
gem 'dm-postgres-adapter'

group :development, :test do
  gem 'pry'
end

group :test do
  gem 'minitest' #, '~> 2.9.1'
  gem 'minitest-matchers' #, '~> 1.1.3'
  gem 'mocha' #, '~> 0.10.0
  gem 'guard'
  gem 'guard-minitest'
end

if RbConfig::CONFIG['target_os'] =~ /darwin/i
  gem 'rb-fsevent', '>= 0.3.2'
  gem 'growl',      '~> 1.0.3'
end
if RbConfig::CONFIG['target_os'] =~ /linux/i
  gem 'rb-inotify', '>= 0.5.1'
  gem 'libnotify',  '~> 0.1.3'
end
if RbConfig::CONFIG['target_os'] =~ /mswin|mingw/i
  gem 'win32console',             :require => false
  gem 'rb-fchange',   '~> 0.0.2', :require => false
  gem 'rb-notifu',    '~> 0.0.4', :require => false
end
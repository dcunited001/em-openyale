YALE_ROOT = File.dirname(__FILE__)
DIR = File.join(YALE_ROOT, 'config', 'redis.conf')

# check for redis
if !system("which redis-server")
  puts '', "** can't find `redis-server` in your path"
  puts "** try running `sudo rake install`"
  abort ''
end

# start redis-test when tests start
# kill when tests end
# def at_exit_kill_redis
#   at_exit do
#     next if $!

#     if defined?(MiniTest)
#       exit_code = MiniTest::Unit.new.run(ARGV)
#     else
#       exit_code = Test::Unit::AutoRunner.run
#     end

#     pid = `ps -e -o pid,command | grep [r]edis-test`.split(" ")[0]
#     puts "Killing test redis server..."
#     `rm -f #{DIR}/dump.rdb`
#     Process.kill("KILL", pid.to_i)
#     exit exit_code
#   end
# end

# def start_redis
#   puts "Starting redis for testing at localhost:9736..."
#   `redis-server #{DIR}/redis-test.conf`
#   Resque.redis = 'localhost:9736/1'
#   Redisk.redis = 'localhost:9736/1'
# end

require 'spec_helper'

# at_exit_kill_redis
# start_redis

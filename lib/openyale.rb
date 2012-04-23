
require 'lib/openyale_helpers'

module Openyale
  extend OpenyaleHelpers

  require 'config'
  require 'redis_config'
  require 'mapper'

  # autoload :Models, 'models' # this is done in Openyale::Mapper#load_models ...
  autoload :Jobs, 'jobs'
  autoload :OpenyaleServer, 'openyale_server'

  set_defaults(:config, {
    'root_path' => 'specify/in/config/block', 
    'config_path' => 'config',
    'em_config' => 'em.yml',
    'redis_config' => 'redis.yml',
    'db_config' => 'database.yml',
    'num_concurrent' => 3})

  class << self

    def configure
      yield self
    end

    def setup(env, opts = {})
      conf = read_config(env, opts)
      connect_to_db(conf.db)
      connect_to_redis(conf.redis)
      conf
    end

    def read_config(env, opts = {})
      config = Openyale::Config.new(env, opts)
      config.execute
    end

    def connect_to_db(opts = {})
      db = Openyale::Mapper.new(opts)
      db.execute
    end

    def connect_to_redis(opts = {})
      redis = Openyale::RedisConfig.new(opts)
      redis.execute
    end

    def em_path(root = self.root_path, config = self.config_path, em = self.em_config)
      File.join(root, config, em)
    end

    def redis_path(root = self.root_path, config = self.config_path, redis = self.redis_config)
      File.join(root, config, redis)
    end

    def db_path(root = self.root_path, config = self.config_path, db = self.db_config)
      File.join(root, config, db)
    end

    def method_missing(method, *args, &block)
      setter = method.to_s.gsub(/=$/, '').to_sym if method.to_s =~ /=$/

      val = case 
        when (@@config.keys.include?(method.to_s)) then @@config[method.to_s]
        when (setter and @@config.keys.include?(setter.to_s)) then @@config[setter.to_s] = args
      end

      val || super
    end
  end

end




class Openyale::Config
  include ConfigMissing
  
  attr_accessor :env, :config
  attr_accessor :db, :redis

  def initialize(env = ENV['EM_ENV'], opts = {})
    @env = env || 'development'
    @config = Openyale.config.merge(opts)
  end

  def execute
    load_em
    load_redis
    load_db
    self
  end

  def load_em(file = nil)
    em_opts = read_yaml(file || em_path)[env]
    em_opts.each {|k,v| config[k] = v }
    config
  end

  def load_redis(file = nil)
    @redis = read_yaml(file || redis_path)[env]
  end

  def load_db(file = nil)
    @db = read_yaml(file || db_path)[env]
  end

  def em_path
    Openyale.em_path(root_path, config_path, em_config)
  end

  def redis_path
    Openyale.em_path(root_path, config_path, redis_config)
  end

  def db_path
    Openyale.em_path(root_path, config_path, db_config)
  end

  private 

  def read_yaml(file)
    yaml = begin
      input = File.read(file)
      eruby = Erubis::Eruby.new(input)
      YAML::load(eruby.result(binding())) || {}
    rescue => ex
      raise ex, ex.message
    end
  end

end


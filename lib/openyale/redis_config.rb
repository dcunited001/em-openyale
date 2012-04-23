class Openyale::RedisConfig
  include ConfigMissing
  
  attr_accessor :config
  def initialize(config = {})
    @config = config
  end

  def execute
    set_redis_url
    set_expire_in
    self
  end

  def set_redis_url
    Resque.redis = url
  end

  def set_expire_in
    Resque::Plugins::Status::Hash.expire_in = expire_in
  end

end

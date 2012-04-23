class Openyale::Mapper
  include ConfigMissing
  
  attr_accessor :config
  def initialize(config = {})
    @config = config
  end

  def execute
    start_logger
    make_connection
    load_models
    finalize
    self
  end

  def start_logger
    DataMapper::Logger.new(log_file, log_level)
  end

  def make_connection
    DataMapper.setup(:default, connection_url)
  end

  def load_models
    Openyale.class_eval { require 'models' }
  end

  def finalize
    DataMapper.finalize
  end

  def connection_url
    "postgres://#{username}:#{password}@#{host}/#{database}"
  end

  def self.setup!(config = {})
    dm = new(config)
    dm.execute
  end
end

module OpenyaleHelpers
  def set_defaults(sym, val)
    mattr_accessor(sym)
    class_variable_set("@@#{sym.to_s}", val)
  end

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

module ConfigMissing
  def method_missing(method, *args, &block)
    setter = method.to_s.gsub(/=$/, '').to_sym if method.to_s =~ /=$/

    val = case 
      when (@config.keys.include?(method.to_s)) then @config[method.to_s]
      when (setter and @config.keys.include?(setter.to_s)) then @config[setter.to_s] = args
    end

    val || super
  end
end
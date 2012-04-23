module Openyale::Jobs
  Dir[File.join(File.dirname(__FILE__),'jobs','*.rb')].each { |f| require f }
end
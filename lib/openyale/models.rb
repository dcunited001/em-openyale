module Openyale::Models
  #load all models
  Dir[File.join(File.dirname(__FILE__),'models','*.rb')].each { |f| require f }
end

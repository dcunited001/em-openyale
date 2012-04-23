#!/bin/ruby
require './setup_env'

Openyale.configure do |oyc|
  oyc.root_path = File.dirname(__FILE__)
end

EventMachine.run {
  EventMachine.start_server "127.0.0.1", 8081, Openyale::OpenyaleServer
}

require './setup_env'

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/spec')

gem "minitest"
require "minitest/spec"
require "minitest/autorun"
require "minitest/matchers"
require "minitest/pride"
require "mocha"
require "pry"

require 'redisk'

YALE_ROOT = File.dirname(__FILE__)

Openyale.configure do |oyc|
  oyc.root_path = YALE_ROOT
end

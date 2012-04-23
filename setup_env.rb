require 'rubygems'
require 'bundler/setup'

require 'eventmachine'
require 'data_mapper'
require 'erubis'
require 'resque'
require 'resque-status'

#active support
require 'active_support/core_ext/module/attribute_accessors.rb'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.dirname(__FILE__) + '/lib/openyale')

require 'lib/openyale'
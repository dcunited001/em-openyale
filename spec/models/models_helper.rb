require 'spec_helper'

conf = Openyale.read_config('test')
db = Openyale.connect_to_db(conf.db)
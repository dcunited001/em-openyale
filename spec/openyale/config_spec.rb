require 'spec_helper'

describe Openyale::Config do
  let(:em_config) 
  let(:db_config)
  let(:redis_config)

  subject { Openyale::Config.new('test', 'root_path' => YALE_ROOT ) }

  describe "#initialize" do
    it "sets the root path" do
      subject.root_path.must_equal YALE_ROOT
    end

    it "sets defaults for em, db and redis filenames" do
      subject.em_config.must_equal 'em.yml'
      subject.redis_config.must_equal 'redis.yml'
      subject.db_config.must_equal 'database.yml'
    end

    it "sets the environment to 'development' unless specified" do
      subject.env.must_equal 'test'

      oy_config = Openyale::Config.new('development')
      oy_config.env.must_equal 'development'
    end

    it "sets the config options and makes the keys available as methods" do
      oy_config = Openyale::Config.new('test', 'option1' => 'opt1')
      oy_config.config['option1'].must_equal 'opt1'
      oy_config.option1.must_equal 'opt1'
    end
  end

  describe "#execute" do
    it "reads em, db, and redis configs" do
      subject.expects(:load_em)
      subject.expects(:load_redis)
      subject.expects(:load_db)

      subject.execute
    end
  end

  describe "#em" do
    it "reads in the proper configuration from em.yml" do
      subject.load_em
      subject.config.keys.must_include 'vids_path'
    end
  end

  describe "#redis" do
    it "reads in the proper configuration from redis.yml" do
      subject.load_redis
      subject.redis['url'].must_equal 'localhost:6379:oyc_test'
    end
  end

  describe "#db" do
    it "reads in the proper configuration from database.yml" do
      subject.load_db
      subject.db.keys.must_include 'database'
    end
  end
  
end
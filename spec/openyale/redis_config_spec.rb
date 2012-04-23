require 'spec_helper'

describe Openyale::RedisConfig do
  let(:redis_config) { Openyale.read_yaml(Openyale.redis_path)['test'] }
  subject { Openyale::RedisConfig.new(redis_config) }

  describe "#initialize" do
    it "makes the url and expire_in accessible" do
      subject.url.must_equal redis_config['url']
      subject.expire_in.must_equal redis_config['expire_in']
    end
  end

  describe "#execute" do
    it "sets the redis_url and exire_in" do
      subject.expects(:set_redis_url)
      subject.expects(:set_expire_in)

      subject.execute
    end
  end
end
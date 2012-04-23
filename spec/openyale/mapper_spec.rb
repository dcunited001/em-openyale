require 'spec_helper'

describe Openyale::Mapper do
  let(:db_config) { Openyale.read_yaml(Openyale.db_path)['test'] }
  subject { Openyale::Mapper.new(db_config) }

  describe "#execute" do
    it 'creates a logger and makes a connection' do
      subject.expects(:start_logger)
      subject.expects(:make_connection)

      subject.execute
    end
  end

  describe "#connection_url" do
    it "generates a url with the appropriate params" do
      c_url = "postgres://#{db_config['username']}:#{db_config['password']}@#{db_config['host']}/#{db_config['database']}"
      subject.connection_url.must_equal c_url
    end
  end

  describe "#config" do
    it "can retrieve params from the db config" do
      subject.config.keys.must_include 'database', 'username'
      subject.database.must_equal db_config['database']
      subject.username.must_equal db_config['username']
    end
  end
end
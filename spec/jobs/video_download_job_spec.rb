require 'jobs/jobs_helper'

describe Openyale::Jobs::VideoDownloadJob do
  before do
    @conf = Openyale.setup('test')
    Resque.redis.flushall
  end

  let(:url) { "http://openmedia.yale.edu/cgi-bin/open_yale/media_downloader.cgi?file=/courses/fall06/plsc114/mov/chapters/plsc114_01_091106.mov" }
  let(:vid) { v = Openyale::Models::Video.create(:url => url); v.set_properties; v }
  let(:uuid) { '123' }
  subject { Openyale::Jobs::VideoDownloadJob.new(uuid, :vid_id => vid.id, :root => @conf.vids_path) }

  describe "#process" do
    it "retrieves the video object, gets the commands to use, gets the size .... " do
      subject.expects(:get_video)
      subject.expects(:get_commands)
      subject.expects(:get_size)

      subject.perform
    end
  end

  describe "#get_video" do
    it "sets root and retrieves the correct video" do
      subject.get_video
      subject.root.must_equal @conf.vids_path
      subject.vid_id.must_equal vid.id
      subject.video.id.must_equal vid.id
    end
  end

  describe "#get_commands" do
    it "gets the correct commands" do
      subject.get_video
      subject.get_commands
      subject.headers_command.must_equal "curl -I #{subject.video.actual_url} | grep Content-Length" 
      subject.download_command.must_equal "curl -o #{subject.video.full_file_path(subject.root)} #{subject.video.actual_url}"
    end
  end

  describe "#get_size" do
    it "gets the size of the file to be downloaded" do
      subject.get_video
      subject.get_commands

      subject.expects(:send_command).with(subject.headers_command).returns("Content-Length: 331208728")
      subject.get_size

      subject.video.size.must_equal(331208728)
    end
  end
end
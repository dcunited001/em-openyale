require 'jobs/jobs_helper'

describe Openyale::Jobs::VideoDownloadJob do
  before do
    @conf = Openyale.setup('test')
    Resque.redis.flushall
  end

  let(:url) { "http://openmedia.yale.edu/cgi-bin/open_yale/media_downloader.cgi?file=/courses/fall06/plsc114/mov/chapters/plsc114_01_091106.mov" }
  let(:vid) { v = Openyale::Models::Video.create(:url => url); v.set_properties; v }
  let(:uuid) { '123' }
  subject { Openyale::Jobs::VideoDownloadJob.new(uuid, 'vid_id' => vid.id, 'root' => @conf.vids_path) }

  describe "#process" do
    it "retrieves the video object, gets the commands to use, gets the size .... " do
      subject.expects(:get_video)
      subject.expects(:get_commands)
      subject.expects(:get_size)
      subject.expects(:download_video)

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
      subject.download_command.must_equal "curl -o '#{subject.video.full_file_path(subject.root)}' '#{subject.video.actual_url}' & echo $!"
    end
  end

  describe "#get_size" do
    it "gets the size of the file to be downloaded" do
      subject.get_video
      subject.get_commands

      subject.expects(:send_command).with(subject.headers_command).returns("Content-Length: 331208728")
      subject.get_size

      subject.size.must_equal(331208728)
    end
  end

  describe "#get_downloaded_bytes" do
    it "returns the downloaded bytes" do
      subject.get_video
      File.expects(:size).with(subject.full_file_path).returns(1024)

      subject.get_downloaded_bytes.must_equal(1024)
    end
  end

  describe "#download_video" do
    before do
      subject.get_video
      subject.get_commands

      subject.expects(:send_command).with(subject.headers_command).returns("Content-Length: 331208728")
      subject.get_size
    end

    it "downloads the video with curl, then loops until complete" do
      subject.stubs(:size).returns(15)
      subject.expects(:send_command).with(subject.download_command).returns("[2] 39749\n39749")
      subject.expects(:update_until_complete)

      subject.download_video

      # subject.stubs(:size).returns(15)
      # subject.expects(:send_command).with(subject.download_command).returns("[2] 39749\n39749")
      # subject.stubs(:get_downloaded_bytes)
      # 3.times { subject.expects(:downloaded_bytes).returns(15) }
      # 2.times { subject.expects(:downloaded_bytes).returns(10) }
      # 2.times { subject.expects(:downloaded_bytes).returns(5) }
      # subject.stubs(:get_pct_complete).returns(100)
      # subject.stubs(:curl_running).returns(true)

      # subject.download_video
    end
  end

  describe "#curl_running" do
    it "knows if curls been bad" do
      output = <<EOS
  davidconner    12345   0.0  0.0  2457040   1592 s000  S    12:04PM   0:00.01 curl
  davidconner    40174   0.0  0.1  2477488  10700 s000  S+   12:04PM   0:00.53 curl
  davidconner    40039   0.0  1.0   861628  80940   ??  S    11:53AM   0:06.31 curl
EOS

      subject.stubs(:send_command).with("ps -ef | grep curl").returns(output)
      subject.pid = 12345
      subject.curl_running.must_equal true
      subject.pid = 123456
      subject.curl_running.must_equal false
    end
  end
end
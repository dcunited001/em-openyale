require 'models/models_helper'

describe Openyale::Models::Video do
  let(:vid_url) { 'http://openmedia.yale.edu/cgi-bin/open_yale/media_downloader.cgi?file=/courses/fall06/plsc114/mov/chapters/plsc114_01_091106.mov' }
  let(:oyc_path) { '/courses/fall06/plsc114/mov/chapters/plsc114_01_091106.mov' }
  let(:actual_url) { 'http://openmedia.yale.edu/projects/courses/fall06/plsc114/mov/chapters/plsc114_01_091106.mov'}
  let(:full_file_path) { File.join('~/vids', subject.classname, subject.filename) }
  let(:curl_command) { "curl -o #{full_file_path} #{actual_url}"}

  subject { Openyale::Models::Video.create(:url => vid_url) }

  describe "#initialize" do
    it "gets set to the INITIAL status" do
      subject.status.must_equal Openyale::Models::Video::INITIAL
    end

    it "sets the url" do
      subject.url.must_equal vid_url
    end
  end

  describe "#set_properties" do
    it "sets the actual_url, the class and the path and saves" do
      subject.expects(:get_oyc_path)
      subject.expects(:set_actual_url)
      subject.expects(:set_class)
      subject.expects(:set_filename)
      subject.expects(:save)

      subject.set_properties
    end
  end

  describe "#get_oyc_path" do
    it "gets the value of the file param from the url" do
      subject.get_oyc_path.must_equal oyc_path
    end
  end

  describe "#set_actual_url" do
    it "sets the actual_url to download from" do
      subject.get_oyc_path
      subject.set_actual_url
      subject.actual_url.must_equal actual_url
    end
  end

  describe "#set_class" do
    it "sets the class name from the url" do
      subject.get_oyc_path
      subject.set_class
      subject.classname.must_equal 'plsc114'
    end
  end

  describe "#set_filename" do
    it "sets the filename" do
      subject.get_oyc_path
      subject.set_filename
      subject.filename.must_equal 'plsc114_01_091106.mov'
    end
  end

  describe "#enqueue" do
    it "adds to queue and sets status to QUEUED" do
      Openyale::Jobs::VideoDownloadJob.expects(:create).with(:vid_id => subject.id)
      subject.expects(:save)
      subject.enqueue
      subject.status.must_equal Openyale::Models::Video::QUEUED
    end
  end

  describe "#full_file_path" do
    it "lists the full path the the local file, given the root" do
      subject.set_properties
      subject.full_file_path('~/vids').must_equal full_file_path
    end
  end

  # describe "#get_command" do
  #   it "sets the command to be used" do
  #     subject.set_properties
  #     subject.get_command('~/vids').must_equal curl_command
  #   end
  # end
end
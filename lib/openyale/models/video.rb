class Openyale::Models::Video 
  include DataMapper::Resource

  #statuses
  INITIAL = 'INITIAL'
  QUEUED = 'QUEUED'
  SHIFTED = 'SHIFTED'
  DOWNLOADING = 'DOWNLOADING'
  COMPLETE = 'COMPLETE'

  property :id, Serial
  property :status, String, :default => INITIAL
  
  property :url, String, :length => 255
  property :actual_url, String, :length => 255

  property :filename, String
  property :classname, String

  property :bytes_complete, Integer, :default => 0
  property :pct_complete, Integer, :default => 0
  
  property :size, Integer
  property :pid, Integer

  def set_properties
    get_oyc_path
    set_actual_url
    set_class
    set_filename
    save
  end

  def enqueue
    Openyale::Jobs::VideoDownloadJob.create(:vid_id => id)
    self.status = QUEUED
    save
  end

  def self.download_video(url)
    vid = Openyale.new(:url => url)
    vid.set_properties
    vid.enqueue
  end

  def get_oyc_path
    @oyc_path ||= /^http:\/\/.*file=(.*)$/.match(url)[1]
  end

  def set_actual_url
    self.actual_url = actual_url_root + @oyc_path
  end

  def set_class
    self.classname = @oyc_path.split('/')[3]
  end

  def set_filename
    self.filename = @oyc_path.split('/').last
  end

  def shift!
    self.status = SHIFTED
    save
  end

  def actual_url_root
    "http://openmedia.yale.edu/projects"
  end

  def full_file_path(root = '.')
    File.join(root, classname, filename)
  end

  # http://openmedia.yale.edu/cgi-bin/open_yale/media_downloader.cgi?file=/courses/fall06/plsc114/mov/chapters/plsc114_01_091106.mov
  # http://openmedia.yale.edu/projects/courses/fall06/plsc114/mov/chapters/plsc114_01_091106.mov
end

class Openyale::Jobs::VideoDownloadJob
  include Resque::Plugins::Status

  @queue = :video_download

  attr_accessor :vid_id, :video

  def perform
    get_video
  end

  def get_video
    @vid_id = options[:vid_id]
    @video = Video.find(vid_id)
  end

  def check_progress

  end

end
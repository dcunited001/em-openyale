class Openyale::Jobs::VideoDownloadJob
  include Resque::Plugins::Status

  @queue = :video_download

  attr_accessor :vid_id, :video
  attr_accessor :file, :root
  attr_accessor :download_command, :headers_command

  def perform
    get_video
    get_commands
    get_size
  end

  def get_video
    self.root = options[:root]
    self.vid_id = options[:vid_id]
    self.video = Openyale::Models::Video.get(vid_id)
    self.video.shift!
  end

  def get_commands
    self.download_command = "curl -o #{video.full_file_path(@root)} #{video.actual_url}"
    self.headers_command = "curl -I #{video.actual_url} | grep Content-Length"
  end

  def get_size
    response = send_command(headers_command)
    match = /Content-Length: (\d+)/i.match(response)
    if match[1]
      self.video.size = match[1].to_s
      self.video.save
    else
      raise "No Header"
    end
  end

  private

  def send_command(command)
    system(command)
  end

end
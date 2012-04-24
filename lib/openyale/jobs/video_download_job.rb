class Openyale::Jobs::VideoDownloadJob
  include Resque::Plugins::Status

  @queue = :video_download

  attr_accessor :vid_id, :video
  attr_accessor :file, :root
  attr_accessor :download_command, :headers_command
  attr_accessor :pid, :downloaded_bytes, :size

  def perform
    get_video
    get_commands
    get_size
    download_video
  end

  def get_video
    self.root = options['root']
    self.vid_id = options['vid_id'].to_i
    self.video = Openyale::Models::Video.get(vid_id)
    self.video.shift!
  end

  def get_commands
    self.download_command = "curl -o \"#{full_file_path}\" \"#{video.actual_url}\" & echo $!"
    self.headers_command = "curl -I #{video.actual_url} | grep Content-Length"
  end

  def get_size
    response = send_command(headers_command)
    match = /Content-Length: (\d+)/i.match(response)
    if match[1]
      self.size = match[1].to_i
    else
      raise "No Header"
    end
  end

  def download_video
    response = send_command(self.download_command)
    get_pid(response)

    require 'pry'
    binding.pry

    self.video.status = Openyale::Models::Video::DOWNLOADING
    self.video.size = self.size
    self.video.save

    at(self.downloaded_bytes = 0, self.size, "At 0/#{self.size} BYTES")
    update_until_complete
  end

  def update_until_complete
    while (self.downloaded_bytes < self.size) || (curl_running) do
      get_downloaded_bytes
      at(self.downloaded_bytes, self.size, "At 0/#{self.size} BYTES")
      sleep 5
    end

    raise "Incomplete" unless (self.get_pct_complete >= 99)
    self.video.status == Openyale::Models::Video::COMPLETE
  end

  def full_file_path
    self.video.full_file_path(@root)
  end

  def get_downloaded_bytes
    @downloaded_bytes = File.size(self.full_file_path)
  end

  def curl_running
    response = send_command("ps -ef | grep curl")
    !!(response =~ Regexp.new(self.pid.to_s))
  end

  private

  def send_command(command)
    stdin, stdout, stderr = Open3.popen3(command)
    output = stdout.gets
    err = stderr.gets
    puts output
    puts stderr
    output
  end

  def get_pct_complete
    (100*self.downloaded_bytes / self.size)
  end

  def get_pid(response)
    lines = response.split("\n")
    if (lines.length > 1)
      self.pid = /\d+/.match(lines.last)[1].to_i
    else 
      -1
    end
  end

end
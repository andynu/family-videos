require 'open3'
class VideoConversionJob < ActiveJob::Base
  queue_as :default

  def perform(video_id, current_path)
    logger.info "video_convert_job video_id=#{video_id} current_path=#{current_path}"
    redis = Redis.current
    redis_prefix = [Rails.application.engine_name,:id,video_id].join("/")
    redis.set(redis_prefix + "/conversion_status", "converting")

    directory = File.dirname(current_path)
    extension = File.basename(current_path).split[-1]
    tmpfile = File.join(directory, "tmpfile."+extension)

    logger.warn directory
    logger.warn "\n"+`md5sum #{directory}/*`

    FileUtils.move(current_path,tmpfile)
    Kernel.sleep 10

    logger.warn ["#{tmpfile}",File.exists?(tmpfile)].join("\t")

    logger.warn directory
    logger.warn "\n"+`md5sum #{directory}/*`

    cmd = "ffmpeg2theora --frontend -o #{current_path} #{tmpfile}"
    logger.info "video_convert_job begin encoding cmd=\"#{cmd}\""
    begin
    Open3.popen3(cmd) {|stdin,stdout,stderr,wait_thr|
      while line = stdout.gets
        ffmpeg_status = JSON.parse(line)
        logger.debug line
        redis.set(redis_prefix + "/conversion_status", "converting")
        redis.set(redis_prefix + "/ffmpeg_status", ffmpeg_status)
      end
      exit_status = wait_thr.value
      unless exit_status.success?
        logger.error "video_convert_job error."
        logger.error stderr.read
      end
    }
    rescue Exception => e
      logger.error "video_convert_job EXCEPTION #{e}"
    end

    logger.warn directory
    logger.warn "\n"+`md5sum #{directory}/*`

    logger.info "video_convert_job complete"
    redis.set(redis_prefix + "/conversion_status", "complete")

    File.delete(tmpfile)
    logger.info "video_convert_job cleaned up"
  end
end

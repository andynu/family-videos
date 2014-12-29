class Video < ActiveRecord::Base
    mount_uploader :video, VideoUploader

    def video_conversion_status
      redis = Redis.current
      redis_prefix = [Rails.application.engine_name,:id,id].join("/")
      conversion_status = redis.get(redis_prefix + "/conversion_status")
      ffmpeg_status = (redis.get(redis_prefix + "/ffmpeg_status")||"").gsub(/=>/,':')
      return {
        status: conversion_status,
        ffmpeg: JSON.parse(ffmpeg_status)
      }
    end
end

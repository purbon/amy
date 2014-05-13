module SchedulerHelpers

  def self.included(base)
    base.class_eval do
      base.extend Methods
      include Methods
    end
  end

  module Methods

    def pause(job_id)
      job = cache.get job_id
      job.pause
      job_id
    end

    def resume(job_id)
      job = cache.get job_id
      job.resume
      job_id
    end

    def status(job_id)
      job = cache.get job_id
      return {} if job.nil?
      { "paused" => job.paused?, "running" => job.running? }
    end

    def info(job_id)
      info = cache.get_info(job_id)
      return {} if info.nil?
      info
    end

    def unschedule(job_id)
      job = cache.get job_id
      job.unschedule
      cache.remove job_id
      job_id
    end

    def dump
      map = {}
      cache.dump.each do |job_id|
        map[job_id] = { :status => self.status(job_id), :info => cache.get_info(job_id) }
      end
      map
    end

  end
end

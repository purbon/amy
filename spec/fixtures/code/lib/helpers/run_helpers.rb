module RunHelpers

  def self.included(base)
    base.class_eval do
      base.extend Methods
        include Methods
      end
    end
 
  module Methods

    private

    def run_job(conf, options, job_id)
      time = Time.now
      begin 
        collection = conf.split('.')[0]
        name       = conf.split('.')[1]
        log "running #{collection} #{name} with options #{options.inspect} and conf #{conf}"
        get_clazz(collection, name).run(options)
        @inspector.add_field(collection, name, job_id, 'ok', 1)
      rescue Exception => e
        log "exception while running #{conf}"
        log "#{e}"
        @inspector.add_field(collection, name, job_id, 'ko', 1)        
      end
      time = Time.now-time;
      @inspector.add_execution_time(collection, name, job_id, time)
    end

    def get_clazz(collection, name) 
      config = @config.get(collection, name)
      if config['class'] then
        config['class'].split('.').last.constantize
      else
        Scheduler::Runner.new(config)
      end
    end

  end
end

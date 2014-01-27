module Helpers

  def self.included(base)
    base.class_eval do
      base.extend Methods
        include Methods
      end
    end
 
  module Methods
  
    def log(msg, level='info')
      begin
        logger = Log4r::Logger['scheduler']
        if logger.nil? then
          puts $stdout.puts msg
          return
        end
        logger.send level.to_sym, msg
      rescue Exception => e
        $stderr.puts "log error #{e}"
      end
    end

    def read_parameters(request, type='json')
      if (type == 'json')
        params       = request.params if request.params
        body_content = request.body.read
        params = JSON.parse(body_content.to_s) if body_content
        params
      else
        raise "Wrong parameters data format, check it!"
      end
    end

    def get_param(params, key, remove=false)
        return false unless params[key]
        get = params[key]
        params.delete key if remove
        get
    end

  end
end

module Amy::Model
  
  class Main

    attr_reader :path

    def initialize
      @resources = []
      @apiversion = ""
      @base_url = ""
      @path = 'index.html'
    end

    def add_resource(resource)
      @resources << resource
    end
    
    def set_version(version)
      @apiversion = version
    end

    def set_base_url(base_url)
      @base_url = base_url
    end

    def get_binding
      binding
    end

  end
end

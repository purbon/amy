module Amy::Model
  
  class Main

    attr_reader :path
    attr_writer :version, :base_url, :links

    def initialize
      @resources  = []
      @version    = ""
      @base_url   = ""
      @links      = []
      @path       = 'index.html'
    end

    def add_resource(resource)
      @resources << resource
    end

    def get_binding
      binding
    end

  end
end

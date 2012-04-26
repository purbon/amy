module Amy::Model
  
  class Main

    attr_reader :path

    def initialize
      @resources = []
      @path = 'index.html'
    end

    def add_resource(resource)
      @resources << resource
    end

    def get_binding
      binding
    end

  end
end

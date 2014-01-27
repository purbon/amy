module Parser
  class Defs

    attr_accessor :method, :url

    def initialize
      @props  = {}
      @method = ""
      @url    = ""
    end

    def add_prop(key, text)
      @props[key] = text
    end

    def get_props
      @props
    end

    def empty?
      @props.empty?
    end

  end
end

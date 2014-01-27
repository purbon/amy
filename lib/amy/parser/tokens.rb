module Parser
  
  module Tokens
    STRING  = 'string'
    COMMENT = 'comment'
  end

  class Token
    attr_accessor :type, :value, :lineno
    def initialize(type, value, lineno)
      @type   = type
      @value  = value
      @lineno = lineno
    end
  end
end

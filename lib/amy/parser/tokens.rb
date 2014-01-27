module Parser
  
  module Tokens
    STRING      = 'string'
    COMMENT_TAG = 'comment_tag'
    COMMENT     = 'comment'
    PROPERTY    = 'property'
    TEXT        = 'text'
  end

  class Token
    attr_accessor :type, :value, :lineno
    def initialize(type, value, lineno)
      @type   = type
      @value  = value
      @lineno = lineno
    end

    def is_ct?
      Tokens::COMMENT_TAG == @type
    end
    def is_c?
      Tokens::COMMENT == @type or Tokens::COMMENT_TAG == @type
    end

    def is_p?
      Tokens::PROPERTY == @type
    end

    def is_s?
      Tokens::STRING == @type
    end

    def is_a?(type)
      @type == type
    end

  end
end

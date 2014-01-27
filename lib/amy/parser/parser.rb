require 'amy/parser/lexer'
require 'amy/parser/defs'

module Parser
  class Parser
    
    def initialize
       @lexer = Lexer.new
    end

    def parse(file)
      @lexer.set_input(file)
      parse_tokens(@lexer)
    end

    private

    def parse_tokens(lexer)
      defs = []
      while(not lexer.eof?)
        token = lexer.next
        if token.is_ct? then
          _def = parse_defs(lexer)
          defs << _def unless _def.empty?
        end
      end
      return defs
    end

    def parse_defs(lexer)
      defs = Defs.new
      return defs if (lexer.eof?)
      finish = false
      prop   = ""
      value  = ""
      while (not lexer.eof? and not finish)
        token = lexer.next
        if token.is_ct? then
          set_property defs, prop, value
          finish = true
        elsif prop.empty? and token.is_p? then
          prop = token.value
        elsif not prop.empty? and token.is_p? then
          set_property defs, prop, value
          prop = token.value
          value = ""
        elsif not prop.empty? and token.is_s? then
          value << " #{token.value}"
        end
      end
      defs.method = lexer.next.value
      finish = false
      lexer.next
      while(not lexer.eof? and not finish)
        token = lexer.next
        if ["'", '"'].include?(token.value) then
          finish = true
        else
          defs.url << token.value
        end
      end
      return defs
    end

    def set_property(defs, prop, value)
      if ("@params" == prop) then
        params = {}
        fields = value.split(" ")
        last_key = ""
        fields.each_with_index do |field, i|
          if (i%2 == 0) then
            last_key = field
          else
            params[last_key] = field
            last_key = ""
          end
        end
        defs.add_prop prop, params
      else
        defs.add_prop prop, value.strip
      end
    end
  end
end

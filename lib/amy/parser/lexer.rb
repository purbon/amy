require 'amy/parser/tokens'

module Parser
  class Lexer

    def initialize
      @filename = ""
      @file     = nil
      @debug    = false
    end

    def set_debug(debug)
      @debug = debug
    end

    def set_input(file)
      @filename = file
      @file     = File.new(file)
    end

    ##
    # Get's the next token
    #
    def next
      raise IOError.new("Stream is at the end of file.") if eof?
      end_of_token = false
      token = ""
      while not end_of_token
        c = @file.getc
        puts "next c: #{c.inspect} v: #{valid_char?(c)} s: #{single_char?(c)} e: #{is_end_character?(c)}" if @debug
        if eof? then
          end_of_token = true
        elsif (single_char?(c)) then
          if (token.empty?)
              token = c
          else
            @file.seek(-1, IO::SEEK_CUR)
          end
          end_of_token = true
        elsif (valid_char?(c)) then
          token << c
        elsif is_end_character?(c) then
          move_till_next_token
          end_of_token = (not token.empty?)
        end
      end
      puts "next" if @debug
      build_token(token)
    end

    ##
    # Set's the lexer back to the begin
    #
    def rewind
      @file.rewind
    end

    def eof?
      @file.eof?
    end

    def lineno
      @file.lineno
    end

    private

    def move_till_next_token
      there = false
      while not there
        c = @file.getc
        puts "move c:#{c.inspect} v: #{valid_char?(c)} s: #{single_char?(c)}" if @debug
        if eof? then
          there = true
        elsif single_char?(c) or valid_char?(c) then
          @file.seek(-1, IO::SEEK_CUR)
          there = true
        end
      end
      puts "move" if @debug
    end

    def valid_char?(c)
      not (c =~ /[[:alpha:]|[:digit:]|_|@|<|:|-]/).nil?
    end

    def single_char?(c)
      not (c =~ /['|"|#|\/|\\|\[|\]]/).nil?
    end

    def is_white_space?(c)
      not (c =~ /\s/).nil?
    end

    def is_end_character?(c)
      eof? or single_char?(c) or !valid_char?(c)
    end

    def build_token(token)
      type = Parser::Tokens::STRING
      if (token.start_with?("#"))
        type = Parser::Tokens::COMMENT
      elsif (token.start_with?("@")) 
        type = Parser::Tokens::PROPERTY
      end
      Parser::Token.new(type, token, @file.lineno)
    end
  end
end

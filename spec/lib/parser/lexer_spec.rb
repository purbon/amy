require 'spec_helper'
require 'amy/parser/lexer'

describe Parser::Lexer do

  let(:filename) { File.join(ROOT, 'spec/fixtures/lexer.txt') }

  before(:each) do
    @lexer = Parser::Lexer.new
    @lexer.set_input(filename)
  end

  it "should start the parser properly" do
    @lexer.lineno.should == 0
  end

  describe "#tokenize" do

    it "should detect the first token properly" do
       @lexer.next.value.should == "require"
    end
    
    it "should iterate till the end of the file properly" do
      while not @lexer.eof? 
        @lexer.next.should_not be_nil
      end
    end

  end

end

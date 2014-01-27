require 'spec_helper'
require 'amy/parser/parser'

describe Parser::Parser do

  let(:filename) { File.join(ROOT, 'spec/fixtures/lexer.txt') }
  let(:parser) { Parser::Parser.new }

  before(:each) do
    @defs = parser.parse(filename)
  end

  it "should detect method fields in comments" do
    @defs.first.method.should == "get"
  end

  it "should detect properties in comments" do
   @defs.first.get_props['@name'].should == "Front Page"
  end
 
end

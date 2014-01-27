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

  it "should detect params properly" do
    params = @defs[1].get_props["@params"]
    params.should be_a(Hash)
  end

  it "should be able to fetch params property values" do
    params = @defs[1].get_props["@params"]
    params["collection"].should == "string"
  end
 
end

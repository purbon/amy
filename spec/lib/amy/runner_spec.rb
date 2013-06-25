require 'spec_helper'
require 'amy'

describe Amy::Parser do
  
  let(:dir){ File.join(ROOT, 'examples/') }
  
  before(:all) do
    FileUtils.rm_rf 'doc/'
  end

  it "should generate proper main data" do
    parser = Amy::Parser.new
    parser.execute(dir)
  end
end

require 'spec_helper'
require 'amy'

describe Amy::Parser do
  
  let(:dir){ File.join(ROOT, 'spec/fixtures/') }

  it "should generate proper main data" do
    parser = Amy::Parser.new DOC_DIR
    parser.execute(dir)
  end
end

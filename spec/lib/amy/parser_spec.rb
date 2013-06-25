require 'spec_helper'
require 'amy'

describe Amy::Parser do
  
  let(:dir){ File.join(ROOT, 'spec/fixtures/') }

  xit "should be nice and green" do
      parser = Amy::Parser.new(dir)
      parser.run
  end
end

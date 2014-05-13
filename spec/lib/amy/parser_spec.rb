require 'spec_helper'
require 'amy'

describe Amy::Proc do

  let(:parser) { Amy::Proc.new }
  let(:dir){ File.join(ROOT, 'spec/fixtures/') }

  describe "load_specs" do

    it "should load specs file" do
      spec = parser.load_specs dir
      spec['base_url'].should  eq('http://api.linkedenergy.eu:1884')
    end

    it "shouĺd rise an exception for invalid arguments" do
      expect {  parser.load_specs('spec/fitures') }.to raise_error(ArgumentError)
    end 
  
  end

  describe "" do
    
  end

end

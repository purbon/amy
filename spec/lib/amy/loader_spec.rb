require 'spec_helper'
require 'amy'

describe Amy::Loader do

  let(:loader) { Amy::Loader.new }
  let(:dir){ File.join(ROOT, 'spec/fixtures/files') }

  describe "Loader#load_specs" do

    it "should load specs file" do
      spec = loader.load_specs dir
      spec['base_url'].should  eq('http://api.linkedenergy.eu:1884')
    end

    it "should raise an exception for invalid arguments" do
      expect { loader.load_specs "spec/fitures" }.to raise_error(ArgumentError)
    end
  
    describe 'Loader#load_specs from source_code' do

      let(:loader) { Amy::Loader.new('code') }
      let(:dir)    { File.join(ROOT, 'spec/fixtures/code/') }

      it "should load the set of specs from a given source code definition" do
        specs = loader.load_specs dir
        specs['resources'].keys.should match_array([ "/registry", "/registry/:collection/:name", "/registry/:collection", 
                                                     "/jobs/:collection", "/jobs/:collection/:name" ])
      end

    end
  end

end

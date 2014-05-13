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
  
    describe 'load_specs#source_code' do

      let(:parser) { Amy::Proc.new }
      
      before(:each) do
        Amy::Proc.any_instance.stub(load_options_file: {'mode' => 'code'})
      end

      it "should access the source code to be loaded" do
        expect(parser).to receive(:parse_source_code).and_return 'source_code_spec'
        spec   = parser.load_specs dir
        spec['resources'].should eq('source_code_spec')
      end

    end
  end

end

require 'spec_helper'
require 'amy'

describe Amy::Aggregator do

  let(:parser)     { Amy::Proc.new }
  let(:aggregator) { Amy::Aggregator.new(DOC_DIR, 'file') }
  let(:dir)        { File.join(ROOT, 'spec/fixtures/') }
  
  describe "compile_json_specs" do

    let(:specs) { parser.load_specs(dir) }

    before(:each) do
      expect(aggregator).to receive(:flush_specs).and_return('')
    end

    it "should load specs file" do
      coll    = aggregator.compile_json_specs_with dir, specs
      methods = coll['resources']['/orgs']['config'].keys
      methods.should match_array(["create", "get", "options", "head", "monitor"])
    end
  
  end

end

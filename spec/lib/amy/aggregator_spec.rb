require 'spec_helper'
require 'amy'

describe Amy::Aggregator do

  let(:parser)     { Amy::Proc.new }
  let(:aggregator) { Amy::Aggregator.new(DOC_DIR, 'file') }
  let(:dir)        { File.join(ROOT, 'spec/fixtures/files/') }
  
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

  describe 'generate_main_page_with' do

    let(:specs) { parser.load_specs(dir) }
    
    before(:each) do
      Amy::Generator.any_instance.stub(flush_page: {})
      expect(aggregator).to receive(:flush_specs).and_return('')
      aggregator.compile_json_specs_with dir, specs
    end

    it "should get the main page compiled" do
      page = aggregator.generate_main_page_with specs
      page.slice(-20..-1).should eq("  </body>\n  </html>\n")
    end

  end

  describe 'parse_source_code' do

    let(:parser)     { Amy::Proc.new }
    let(:aggregator) { Amy::Aggregator.new(DOC_DIR, 'code') }
    let(:dir)        { File.join(ROOT, 'spec/fixtures/code/') }

    it "should get the specs from source code" do
      specs = aggregator.parse_source_code dir
      specs.keys.should match_array([ "/registry", "/registry/:collection/:name", 
                                      "/registry/:collection", "/jobs/:collection", 
                                      "/jobs/:collection/:name"
                                    ])
    end

  end

end

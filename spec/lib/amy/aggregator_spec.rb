require 'spec_helper'
require 'amy'

describe Amy::Aggregator do

  let(:loader)     { Amy::Loader.new }
  let(:aggregator) { Amy::Aggregator.new(DOC_DIR, 'file') }
  let(:dir)        { File.join(ROOT, 'spec/fixtures/files/') }
  
  describe "compile_json_specs" do

    let(:specs) { loader.load_specs(dir) }

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

    let(:specs) { loader.load_specs(dir) }
    
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

  describe "copy_styles_and_js" do

   before(:each) do
      Dir.stub(:mkdir).with('/tmp/doc/js')
      FileUtils.stub(:cp).with(anything,'/tmp/doc/js/amy.js')
      FileUtils.stub(:cp).with(anything,'/tmp/doc/data.json')      
      Dir.stub(:mkdir).with('/tmp/doc/style')
      FileUtils.stub(:cp).with(anything,'/tmp/doc/style/style.css')      
   end

    it "should create the directory layout without errors" do
     expect { aggregator.copy_styles_and_js }.to_not raise_error
    end

  end

end

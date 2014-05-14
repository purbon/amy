require 'spec_helper'
require 'amy'

describe Amy::Proc do

  let(:amy_proc) { Amy::Proc.new }
  let(:dir){ File.join(ROOT, 'spec/fixtures/files') }

  describe "execution" do

    before(:each) do
      loader = amy_proc.instance_variable_get(:@loader)
      loader.should_receive(:load_specs).and_return {}

      agg = amy_proc.instance_variable_get(:@aggregator)
      agg.should_receive(:compile_json_specs_with).and_return nil
      agg.should_receive(:generate_main_page_with).and_return nil
      agg.should_receive(:copy_styles_and_js).and_return nil
    end

    it "should execute the right steps to compile the pages" do
      amy_proc.execute(dir).should be_true
    end

  end

end

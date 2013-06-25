require 'spec_helper'
require 'amy'

describe Amy::Generator do
  
  let(:dir)      { File.join(ROOT, 'spec/fixtures/') }
  let(:template) { File.join(Amy::BASE_DIR, "views/resource.erb.html") }

  let(:object)   { Amy::Model::Resource.new(File.join(dir, "orgs"), "orgs", "title") }

  it "should generate the documentation set properly" do
    g = Amy::Generator.new DOC_DIR
    g.do template, object
  end
end

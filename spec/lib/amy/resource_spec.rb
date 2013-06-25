require 'spec_helper'
require 'amy'

describe Amy::Model::Resource do

  let (:dir) { File.join(ROOT, 'spec/fixtures/orgs') }

  it "should load all basic resources defined within the main directory" do
    resource_def = File.join(dir, 'resource.def')
    resource = JSON.parse(IO.read(resource_def))
    model    = Amy::Model::Resource.new(dir, resource['name'], resource['title'])
    model.build
  end
  
end

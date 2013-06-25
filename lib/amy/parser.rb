require 'fileutils'

module Amy
  class Parser

    def initialize(base_dir = "doc/")
      @generator = Amy::Generator.new base_dir
    end

    def execute(dir)
      specs = load_specs dir
      generate_main_page_with specs
      specs['resources'].each_pair do | resource, options|
        puts "Generating resource documentation of #{options['title']}"
        name = options['dir']
        parse_a_resource File.join(dir, name), name, options['title']
      end
      copy_styles_and_js
      true
    end

    private

    def copy_styles_and_js
      base_dir = @generator.base_dir
      Dir.mkdir("#{base_dir}/js")
      FileUtils.cp("#{Amy::BASE_DIR}/views/js/amy.js", "#{base_dir}/js/amy.js")
      Dir.mkdir("#{base_dir}/style")
      FileUtils.cp("#{Amy::BASE_DIR}/views/style/style.css", "#{base_dir}/style/style.css")
    end

    def parse_a_resource(dir, name, title)
      resource = JSON.parse(IO.read(File.join(dir,"resource.def")))
      generate_resource_page_with dir, resource, name, title
    end

    def load_specs(dir)
      JSON.parse(IO.read(File.join(dir,"/specs.def")))
    end

    def generate_main_page_with(specs)
      main_page = Amy::Model::Main.new
      specs['resources'].each_pair { |resource, options|
         main_page.add_resource( { 'resource' => resource, 'title' => options['title'] } )
      }
      main_page.set_version  specs['api_version']
      main_page.set_base_url specs['base_url']
      @generator.do("#{Amy::BASE_DIR}/views/main.erb.html", main_page)
    end
    
    def generate_resource_page_with(dir, specs, name, title)
      resource_page = Amy::Model::Resource.new(dir, name, title)
      resource_page.build
      @generator.do("#{Amy::BASE_DIR}/views/resource.erb.html", resource_page)
    end

  end
end

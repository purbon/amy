require 'fileutils'

module Amy
  class Parser

    def initialize(base_dir = "doc/")
      @generator = Amy::Generator.new base_dir
    end

    def execute(dir)
      specs  = load_specs dir
      compile_json_specs_with dir, specs
      generate_main_page_with specs
      copy_styles_and_js
      true
    end

    private

    def compile_json_specs_with(dir, specs)
      specs['resources'].each_pair { |resource, options|
        resource_spec = JSON.parse(IO.read(File.join(File.join(dir, options['dir']),"resource.def")))
        resource_page = Amy::Model::Resource.new(File.join(dir, options['dir']), resource_spec, options['dir'], options['title'])
        resource_page.build
        options['config'] = resource_page.sections['config']
      }
      File.open("#{Amy::BASE_DIR}/views/js/data.json", 'w') do |f|
        f.write(specs.to_json)
      end
    end

    def parse_a_resource(dir, name, title)
      resource = JSON.parse(IO.read(File.join(dir,"resource.def")))
      generate_resource_page_with dir, resource, name, title
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
      resource_page = Amy::Model::Resource.new(dir, specs, name, title)
      resource_page.build
      @generator.do("#{Amy::BASE_DIR}/views/resource.erb.html", resource_page)
    end

    def load_specs(dir)
      JSON.parse(IO.read(File.join(dir,"/specs.def")))
    end

    def copy_styles_and_js
      base_dir = @generator.base_dir
      Dir.mkdir("#{base_dir}/js")
      FileUtils.cp("#{Amy::BASE_DIR}/views/js/amy.min.js", "#{base_dir}/js/amy.js")
      FileUtils.cp("#{Amy::BASE_DIR}/views/js/data.json", "#{base_dir}/data.json")      
      Dir.mkdir("#{base_dir}/style")
      FileUtils.cp("#{Amy::BASE_DIR}/views/style/style.css", "#{base_dir}/style/style.css")
    end

  end
end

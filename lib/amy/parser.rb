require 'fileutils'

module Amy
  class Parser

    def initialize(dir)
      @dir       = dir
      @generator = Amy::Generator.new
    end

    def run
      specs = load_specs(@dir)
      generate_main_page_with specs
      specs.each_pair do |k,v|
        puts "Generating resource documentation of #{v}"
        parse_a_resource("#{@dir}/#{k}",k,v)
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
      resource = JSON.parse(IO.read("#{dir}/resource.def"));
      generate_resource_page_with dir, resource, name, title
    end

    def load_specs(dir)
      JSON.parse(IO.read("#{dir}/specs.def"))
    end

    def generate_main_page_with(specs)
      main_page = Amy::Model::Main.new
      specs.each_pair { |resource, title|
         main_page.add_resource( { 'resource' => resource, 'title' => title } )
      }
      @generator.do("#{Amy::BASE_DIR}/views/main.erb.html", main_page)
    end
    
    def generate_resource_page_with(dir, specs, name, title)
      resource_page = Amy::Model::Resource.new(dir, name, title)
      specs.each { |section| resource_page.add_section section }
      @generator.do("#{Amy::BASE_DIR}/views/resource.erb.html", resource_page)
    end

  end
end

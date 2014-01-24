require 'fileutils'
require 'maruku'

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
         options['config'] = build_resource File.join(dir, options['dir']), resource_spec
      }
      File.open("#{Amy::BASE_DIR}/views/js/data.json", 'w') do |f|
        f.write(specs.to_json)
      end
    end

    def build_resource(dir, specs)
     resources = Dir.new(dir)
     to_skip   = [ '.', '..', 'resource.def' ]
     record    = specs['config']
     resources.entries.each do |entry|
        next if to_skip.include?(entry)
        content = IO.read File.join(resources.path, entry)
        method  = File.basename(entry, File.extname(entry)).upcase
        doc     = Maruku.new(content)
        record[method.downcase]['content'] = doc.to_html
     end
     record
    end

    def generate_main_page_with(specs)
      main_page = Amy::Model::Main.new
      specs['resources'].each_pair { |resource, options|
         main_page.add_resource( { 'resource' => resource, 'title' => options['title'] } )
      }
      main_page.set_links    specs['links'] || []
      main_page.set_version  specs['api_version']
      main_page.set_base_url specs['base_url']
      @generator.do("#{Amy::BASE_DIR}/views/main.erb.html", main_page)
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

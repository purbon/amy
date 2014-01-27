require 'fileutils'
require 'maruku'
require 'amy/parser/parser'

module Amy
  class Parser

    OPTIONS_FILE = ".amy"

    def initialize(base_dir = "doc/")
      @generator = Amy::Generator.new base_dir
      @options   = load_options_file
      @mode      = @options['mode'] || 'file'
    end

    require 'pp'

    def execute(dir)
      specs  = load_specs dir
      if (@mode == "code")
        specs['links'] = @options['links']
        specs['base_url'] = @options['base_url']
        specs['api_version'] = @options['api_version']
      end
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
      } if (@mode == "file")
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
      if "file" == @mode then
        JSON.parse(IO.read(File.join(dir,"/specs.def")))
      elsif "code" == @mode then
        { 'resources' => parse_source_code(dir) }
      end
    end

    def parse_source_code(dir)
      parser = ::Parser::Parser.new
      data   = {}
      Dir.foreach(dir) do |file|
        next if [".", ".."].include?(file)
        path = File.join(dir, file)
        if (File.directory?(path)) then
          parse_source_code(path).each_pair do |key, val|
            if data[key].nil? then
               data[key] = val
            else
              data[key].merge!(val)
            end
          end
        else
          defs = parser.parse(path)
          if not defs.empty? then
            defs.each do |_def|
              data[_def.url] = { 'title' => '', 'config' => {} } if data[_def.url].nil?
              record = { 'url' => _def.url, 'title' => _def.get_props["@title"], 'content' => '' }
              data[_def.url]['config'][_def.method] = record
            end
          end
        end
      end
      return data
    end

    def copy_styles_and_js
      base_dir = @generator.base_dir
      Dir.mkdir("#{base_dir}/js")
      FileUtils.cp("#{Amy::BASE_DIR}/views/js/amy.min.js", "#{base_dir}/js/amy.js")
      FileUtils.cp("#{Amy::BASE_DIR}/views/js/data.json", "#{base_dir}/data.json")      
      Dir.mkdir("#{base_dir}/style")
      FileUtils.cp("#{Amy::BASE_DIR}/views/style/style.css", "#{base_dir}/style/style.css")
    end

    def load_options_file
      return {} unless File.exist?(OPTIONS_FILE)
      YAML::load(File.open(OPTIONS_FILE))
    end

  end
end

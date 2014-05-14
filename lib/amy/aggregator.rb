#--
# Copyright (c) 2013-2014 Pere Urbon-Bayes
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. 
#
# Check LICENSE.txt for the complete license description.
#
#++

require 'fileutils'
require 'maruku'
require 'amy/parser/parser'

module Amy

  # This class is the responsible of cracking the documentation
  # definition, even if it's a set of files or directly parsing the
  # source code and then generate the set of files.
  #
  # Author:: Pere Urbon-Bayes (pere.urbon at gmail.com)
  #
  class Aggregator

    OPTIONS_FILE = ".amy"

    def initialize(base_dir, mode)
      @generator = Amy::Generator.new base_dir
      @mode      = mode
    end

    # Compile a set of predefined specs into a bunch of JSON data that
    # later will be used to power the content under the documentation
    # engine.
    def compile_json_specs_with(dir, specs)
      specs['resources'].each_pair { |resource, options|
        resource_spec = JSON.parse(IO.read(File.join(File.join(dir, options['dir']),"resource.def")))
        options['config'] = build_resource File.join(dir, options['dir']), resource_spec
      } if (@mode == "file")
      flush_specs specs
      specs
    end

    # With a set of valid specs loaded it generated the main page using
    # a default ERB template.
    def generate_main_page_with(specs)
      main_page = Amy::Model::Main.new
      specs['resources'].each_pair { |resource, options|
         main_page.add_resource( { 'resource' => resource, 'title' => options['title'] } )
      }
      main_page.links    = specs['links'] || []
      main_page.version  = specs['api_version']
      main_page.base_url = specs['base_url']
      @generator.do("#{Amy::BASE_DIR}/views/main.erb.html", main_page)
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
              if _def.get_props['@params'] then
                record['params'] = []
                _def.get_props['@params'].each_pair do |k,v|
                  record['params'] << [k,v]
                end
              end
              record['content'] = _def.get_props['@content'].gsub(/\n/,'<br/>') if _def.get_props['@content']
              if _def.get_props['@description'] then
                data[_def.url]['title'] = _def.get_props['@description']
              end
              data[_def.url]['config'][_def.method] = record
            end
          end
        end
      end
      return data
    end

    # Copy to it's final destination a set of utility files that will be
    # used by the documentation to work.
    def copy_styles_and_js
      base_dir = @generator.base_dir
      Dir.mkdir("#{base_dir}/js")
      FileUtils.cp("#{Amy::BASE_DIR}/views/js/amy.min.js", "#{base_dir}/js/amy.js")
      FileUtils.cp("#{Amy::BASE_DIR}/views/js/data.json", "#{base_dir}/data.json")      
      Dir.mkdir("#{base_dir}/style")
      FileUtils.cp("#{Amy::BASE_DIR}/views/style/style.css", "#{base_dir}/style/style.css")
    end

    private

    # Given a directory and a set of specs it parses the defined
    # resources and extracts it's content and the Markdown definitions 
    # that later on will be used to create proper html content. 
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

    def flush_specs(specs)
      File.open("#{Amy::BASE_DIR}/views/js/data.json", 'w') do |f|
        f.write(specs.to_json)
      end
    end


  end
end

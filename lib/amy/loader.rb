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

require 'amy/parser/parser'

module Amy

  #
  # This class is the responsible of loading the documentation specs,
  # even if they are being loaded from a bunch of files or from a givn
  # source code.
  #
  # Author:: Pere Urbon-Bayes (pere.urbon at gmail.com)
  #
  class Loader

    def initialize(mode='file')
      @mode      = mode
    end

    # Load a set of specs from a given directory. This specs can be from
    # a file, or from a set of code files.
    def load_specs(dir)
      if "file" == @mode then
        load_from_file(dir)      
      elsif "code" == @mode then
        { 'resources' => parse_source_code(dir) }
      else
        raise ArgumentError
      end
    end

    private

    # Load a JSON file including the documentation specs
    def load_from_file(dir, file="/specs.def")
      JSON.parse(IO.read(File.join(dir, file))) rescue raise ArgumentError
    end

    # Parse a bunch of files extracting the specs defined in them
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
          parse_source_file_definition(data, defs) unless defs.empty?
        end
      end
      return data
    end

    private 

    # For a given set of expects it compose a proper definition with
    # it's data variables.
    def parse_source_file_definition(data, defs={})
      return if defs.empty?
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
      data
    end

  end
end

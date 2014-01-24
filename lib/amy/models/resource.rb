require 'maruku'

module Amy::Model
  class Resource

    attr_reader :path, :sections
    
    def initialize(dir, specs, name, title)
      @specs    = specs
      @dir      = dir
      @title    = title
      @path     = "#{name}.html"
      @verbs = [ 'get', 'post', 'put', 'delete' ]
      @sections = []
    end

    def build
     resources = Dir.new(@dir)
     to_skip   = [ '.', '..', 'resource.def' ]
     record    = { 'config' => @specs['config'] }
     resources.entries.each do |entry|
        next if to_skip.include?(entry)
        content = load_file File.join(resources.path, entry)
        method  = find_method_name entry
        doc     = Maruku.new(content)
        record['config'][method.downcase]['content'] = doc.to_html
     end
     @sections = record
    end

    def get_binding; binding end
    
    private
    
    def load_file(filename)
      IO.read(filename)
    end

    def find_method_name(entry, specs="") 
      File.basename(entry, File.extname(entry)).upcase
    end

  end
end

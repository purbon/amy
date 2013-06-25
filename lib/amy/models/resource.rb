require 'maruku'

module Amy::Model
  class Resource

    attr_reader :path, :sections
    
    def initialize(dir, name, title)
      @dir      = dir
      @title    = title
      @path     = "#{name}.html"
      @verbs = [ 'get', 'post', 'put', 'delete' ]
      @sections = []
    end

    def build
     resources = Dir.new(@dir)
     to_skip   = [ '.', '..', 'resource.def' ]
     record    = { 'entries' => {} }
     resources.entries.each do |entry|
        next if to_skip.include?(entry)
        content = load_file File.join(resources.path, entry)
        method  = find_method_name entry
        doc     = Maruku.new(content)
        record['entries'][method] = doc.to_html
     end
     @sections << record
    end

    def get_binding; binding end
    
    private
    
    def load_file(filename)
      IO.read(filename)
    end

    def find_params_url(specs) 
     method = File.split(@dir).last
     params = "http[s]:// ... / #{method} / #{specs['params'].join(' / ')}"
     params = "#{params} / #{specs['location']}" if specs['special']
     params
    end

    def is_special_location?(specs)
      return true if ['crud/'].include?(specs['location'])
      specs['special'].include?(specs['location'])
    end

    def find_method_name(entry, specs="") 
      File.basename(entry, File.extname(entry)).upcase
    end


  end
end

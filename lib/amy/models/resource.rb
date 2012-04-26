require 'maruku'

module Amy::Model
  class Resource

    attr_reader :path
    
    def initialize(dir, name, title)
      @dir      = dir
      @title    = title
      @path     = "#{name}.html"
      @verbs = [ 'get', 'post', 'put', 'delete' ]
      @sections = []
    end

    def add_section(section)
      section['special'] ||= false
      record       = { 'params' => find_params_url(section), 'entries' => {} }
      resource_dir = Dir.new("#{@dir}/#{section['location']}")
      resource_dir.entries.each do |entry|
        next unless entry.end_with?('.def')
        content = load_file "#{resource_dir.path}/#{entry}"
        method = find_method_name entry, section
        doc = Maruku.new(content)
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

    def find_method_name(entry, specs) 
      File.basename(entry, File.extname(entry)).upcase
    end


  end
end

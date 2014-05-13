require 'erb'
require 'amy/templates/main'

module Amy
  class Generator

    attr_reader :base_dir

    def initialize(base_dir="doc/")
      @base_dir = base_dir
    end

    def do(template, object)
      Dir.mkdir(@base_dir) if (not File.exist?(@base_dir) or not File.directory?( @base_dir ))
      output = compile_erb template, object
      flush_page object.path, output
      output
    end

    private

    def compile_erb(template, object)
      ehtml  = ERB.new(IO.read(template))
      ehtml.result(object.get_binding)
    end

    def flush_page(path, output)
      File.open("#{@base_dir}#{path}", 'w') do |f|
        f.write(output)
      end
    end

  end
end

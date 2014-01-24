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
      ehtml  = ERB.new(IO.read(template))
      output = ehtml.result(object.get_binding)
      File.open("#{@base_dir}#{object.path}", 'w') do |f|
        f.write(output)
      end
    end

  end
end

require 'fileutils'
require 'maruku'
require 'amy/parser/parser'
require 'amy/aggregator'
require 'amy/helpers/helpers'

module Amy
  class Proc

    include Helpers

    OPTIONS_FILE = ".amy"

    def initialize(base_dir = "doc/")
      @options    = load_options_file OPTIONS_FILE
      @mode       = @options['mode'] || 'file'
      @aggregator = Amy::Aggregator.new(base_dir, @mode)
    end

    def execute(dir)
      specs  = load_specs dir
      if (@mode == "code")
        specs['links'] = @options['links']
        specs['base_url'] = @options['base_url']
        specs['api_version'] = @options['api_version']
      end
      @aggregator.compile_json_specs_with dir, specs
      @aggregator.generate_main_page_with specs
      @aggregator.copy_styles_and_js
      true
    end

  end
end

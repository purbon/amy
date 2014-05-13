module Helpers

  def self.included(base)
    base.class_eval do
      base.extend Methods
      include Methods
    end
  end

  module Methods

    def load_specs(dir)
      if "file" == @mode then
        JSON.parse(IO.read(File.join(dir,"/specs.def"))) rescue raise ArgumentError
      elsif "code" == @mode then
        { 'resources' => parse_source_code(dir) }
      else
        raise ArgumentError
      end
    end

    def load_options_file(file)
      return {} unless File.exist?(file)
      YAML::load(File.open(file))
    end

  end

end

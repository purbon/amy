require 'simplecov'
SimpleCov.start

ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))
$LOAD_PATH.unshift File.join(ROOT, 'lib')

require 'tempfile'
require 'fileutils'

temp_file = Tempfile.new("t")
temp_dir  = File.dirname(temp_file)
temp_file.close
temp_file.delete

DOC_DIR = File.join temp_dir, "doc"
FileUtils.rm_rf DOC_DIR

Dir.mkdir(DOC_DIR)

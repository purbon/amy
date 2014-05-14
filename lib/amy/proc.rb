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
require 'amy/aggregator'
require 'amy/helpers/helpers'

module Amy
 
  #
  # This class holds the responsability to crack down the different
  # files and compile the resulting webpage with the documentation.
  #
  # Author:: Pere Urbon-Bayes (pere.urbon at gmail.com)
  #
  class Proc

    include Helpers

    OPTIONS_FILE = ".amy"

    
    # Initialize processor to be able to run againts the documentation
    # reference

    def initialize(base_dir = "doc/")
      @options    = load_options_file OPTIONS_FILE
      @mode       = @options['mode'] || 'file'
      @aggregator = Amy::Aggregator.new(base_dir, @mode)
    end

    # Execute the processor againts a code base and generate the
    # documentation

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

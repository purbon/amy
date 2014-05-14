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

require 'erb'
require 'amy/templates/main'

module Amy

  #
  # The Generator is the responsible of compiling the ERB layout file
  # and generate the proper HTML output with the documentation.
  #
  # Author:: Pere Urbon-Bayes (pere.urbon @ gmail.com) 
  #
  class Generator

    attr_reader :base_dir

    
    # Initialize the generator to output it's content agains a given
    # path.
    def initialize(base_dir="doc/")
      @base_dir = base_dir
    end

    # Compile a given template agains a model object used to generate
    # and fill the ERB template.
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

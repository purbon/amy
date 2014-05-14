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

#
# This Helpers module include a set of common functions used across the
# different classes, but that can not be attached to given one by
# default.
#
# Author:: Pere Urbon-Bayes (pere.urbon at gmail.com)
#
module Helpers

  def self.included(base)
    base.class_eval do
      base.extend Methods
      include Methods
    end
  end

  module Methods

    # Load a set of specs from a given directory. This specs can be from
    # a file, or from a set of code files.
    def load_specs(dir)
      if "file" == @mode then
        JSON.parse(IO.read(File.join(dir,"/specs.def"))) rescue raise ArgumentError
      elsif "code" == @mode then
        { 'resources' => parse_source_code(dir) }
      else
        raise ArgumentError
      end
    end

    # Load the default options file used to configure Amy in case of
    # necessity.
    def load_options_file(file)
      return {} unless File.exist?(file)
      YAML::load(File.open(file))
    end

  end

end

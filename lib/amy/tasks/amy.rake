ROOT = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift File.join(ROOT, 'lib')
Dir.glob('lib/**').each{ |d| $LOAD_PATH.unshift(File.join(ROOT, d)) }

namespace :dev do
  desc "Build and run the current gem version, no need to install it"
  task :build, [:source] do |t, args|
    require 'amy'
    parser = Amy::Parser.new
    parser.execute args[:source]
  end
  desc "Compile and minimize the generated js files"
  task :compilejs do
    puts "Compiling JS using the coffeescript compiler"
    `coffee -j views/js/amy.js -c views/js`
    require 'uglifier'
    File.open("views/js/amy.min.js", "w") do |file| 
      file.write Uglifier.compile(File.read("views/js/amy.js"))
    end
  end
  task :build => :compilejs
end

task :build => 'dev:compilejs'

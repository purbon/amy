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

require 'ant'

DEST_PATH = 'pkg/classes'

directory 'pkg/classes'

desc "Clean up build artifacts"
task :clean do
  rm_rf "pkg/classes"
  rm_rf "lib/enumerator/*.jar"
end

desc "Compile the extension, need jdk7 because vertx relies on it"
task :compile => [DEST_PATH] do |t|
  ant.javac :srcdir => "src", :destdir => t.prerequisites.first,
    :source => "1.8", :target => "1.8", :debug => true, :includeantruntime => false
end

desc "Build the jar"
task :jar => [:clean, :compile] do
  ant.jar :basedir => "pkg/classes", :destfile => "lib/enumerator/ruby_lazy_enumerator.jar", :includes => "**/*.class"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task test: :jar

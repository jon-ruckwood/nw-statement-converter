
require 'rake/clean'
require 'rake/testtask'

CLEAN.include('bin/*.rb')

MARKER = "##KLASS_SUBS##"
KLASS_FILE = "lib/nw_converter.rb"

task :default => [ :build, :chmod ]

##
# Build
#
desc "Build all script variants"
task :build do
  Dir["lib/*.tmpl"].each do | tmpl | 
    tmpl_contents = File.open(tmpl) { | f | f.read }
    klass_contents = File.open(KLASS_FILE) { | f | f.read }
    script_output = tmpl_contents.sub(MARKER, klass_contents)
    # generate file name
    file_name = File.basename(tmpl, ".*") + ".rb"
    puts "Building #{file_name}"
    File.open("bin/" + file_name, "w") { | f | f << script_output }
  end
end

desc "Make scripts executable"
task :chmod do
  Dir["bin/*.rb"].each { | file | File.chmod(0775, file) }
end

# TODO: strip comments out?
#task :strip do
#  Dir["bin/*.rb"].each do | file |
#    
#  end
#end

# TODO: look into...
#task :dist do
#  PKG_FILES = FileList[ 'Rakefile', 'doc/*', 'lib/*', 'test/**/*' ]
#  PKG_FILES.exclude('.svn')
#end

##
# Test
# 
Rake::TestTask.new(:test) do | task |
  task.test_files = FileList['test/test*.rb']
  task.warning = true
  task.verbose = false
end

##
# Misc fun!
#
desc "Look for TODO and FIXME tags!"
task :todo do
  FileList['lib/*', 'test/*.rb'].egrep(/#.*(FIXME|TODO)/)
end


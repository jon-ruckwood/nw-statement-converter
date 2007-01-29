=begin
  Rakefile Builds scripts to make the NationwideStatementConverter usable.
  Copyright (C) 2007  Jonathan Ruckwood
  
  This program is free software; you can redistribute it and/or
  modify it under the terms of the GNU General Public License
  as published by the Free Software Foundation; either version 2
  of the License, or (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
=end
MARKER = "##KLASS_SUBS##"
KLASS_FILE = "nw_converter.rb"
SCRIPT_VARIANTS = { :standalone => { :tmpl => "standalone_script.tmpl", :out => "nw_converter_sa.rb" },
                    :bundled    => { :tmpl => "bundle_script.tmpl" , :out => "nw_converter_bn.rb" } }
##
# Tasks
#
desc "Default task (build all)"
task :default => :all

desc "Build all"
task :all => [ :standalone, :bundled ]

desc "Build the stand alone script that can handle one statement at a time."
task :standalone do
  puts "Building standalone script."
  build(:standalone)
  puts "Done!"
end

desc "Build the script that can be used to make a Mac app bundle that handles mutliple statements."
task :bundled do
  puts "Building bundle script."
  build(:bundled)
  puts "Done!"
end

desc "Remove the built scripts."
task :clean do
  SCRIPT_VARIANTS.each_value do | v |
    fileOut = v[:out]
    begin 
      puts "Removed #{fileOut}" if File.delete(fileOut)
    rescue Errno::ENOENT
      puts "No file named '#{fileOut}' to delete!"
    end
  end
  puts "Done!"
end

# TODO: Test tasks

##
# Helper functions
# 
def build(variant)
  tmplIn = SCRIPT_VARIANTS[variant][:tmpl]
  fileOut = SCRIPT_VARIANTS[variant][:out]
  # Get the contents of the two files, combile and save
  puts "Combining #{KLASS_FILE} and #{tmplIn} into script #{fileOut}"
  converterKlass = File.open(KLASS_FILE) { | f | f.read }
  tmplScript = File.open(tmplIn) { | f | f.read }
  outputScript = tmplScript.gsub(MARKER, converterKlass)
  File.open(fileOut, "w") { | f | f << outputScript }
end
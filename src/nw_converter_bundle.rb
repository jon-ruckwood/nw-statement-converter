#!/usr/bin/ruby

# Get the resource path so we can load required files -- yuck!
RESOURCE_PATH = ARGV[0] + "/Contents/Resources/"

require RESOURCE_PATH + 'nw_converter.rb'

##
# Entry point for the bundle script. This variant is for use when creating a Mac
# app bundle which can handle multiple files.
#
# Note: ARGV[0] is ignored because it's the app bundle path
if ARGV[1].nil?
  puts "Please drop one or more statements onto the application to convert"
  puts "Finished."
  exit
else
  # Handles multiple drops
  total = ARGV.size - 1
  for i in 1..total
    puts "Processing statement #{i} of #{total}"
    statementPath = ARGV[i]
    statementContents = nil
    # read in
    begin 
      statementContents = File.open(statementPath) { | f | f.read }
    rescue Errno::ENOENT
      puts "Error, the file cannot be found! Please check the path and try again"
      puts "Statement path was '#{statementPath}'"
      puts "Abandoning conversion of statement #{i}"
    end
    # convert
    converter = NationwideStatementConverter.new
    convertedStatement = converter.convert(statementContents)
    # save new converted statement
    fileName = File.basename(statementPath, ".*") + " Converted.csv"
    dirName = File.dirname(statementPath)
    savePath = dirName + "/" + fileName
    puts "Saving converted statement to #{savePath}"
    File.open(savePath, "w") { | f | f << convertedStatement }
    puts "Completed converting statement no. #{i}"
   end
   puts "Finished."
end
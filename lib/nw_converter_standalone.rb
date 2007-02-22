#!/usr/bin/ruby

require 'nw_converter'

##
# Entry point for stand alone script, handles one statement at a time
#
if ARGV[0].nil?
  puts "Please supply a path to the statement you want to convert"
  puts "Exiting..."
  exit
else
  statementPath = ARGV[0]
  statementContents = nil
  # read in
  begin 
    statementContents = File.open(statementPath) { | f | f.read }
  rescue Errno::ENOENT
    puts "Error, the file cannot be found! Please check the path and try again"
    puts "Exiting..."
    exit
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
  puts "Finished"
end
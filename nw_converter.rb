#!/usr/bin/ruby
#
# nw_converter.rb converts CSV banking statements from Nationwide into a more agreeable format for iBank to import.
# Copyright (C) 2007  Jonathan Ruckwood
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
# 
# Contact:
#   Jonathan Ruckwood <jonathan.ruckwood@gmail.com>
#
require 'date'

class NationwideStatementConverter
  
  # constants
  GBP = "\243"
  ROW_SEP = "\r\n"
  COL_SEP = ","
  INPUT_COLS = ["Date", "Transactions", "Credits", "Debits", "Balance"]
  EXPECTED_COL_NO = INPUT_COLS.size
  OUTPUT_COLS = ["Date", "Payee", "Memo", "Amount"]
  DATE_SEP = "/"

  ##
  # Converts rows from:
  #   Date, Transactions, Credits, Debits, Balance
  # To:
  #   Date, Memo, Amount
  # And outputs the resulting string
  ##
  def convert(content)
    output = ""
    # add the column headings
    output += outputHeader
    # split into rows
    rows = content.split(ROW_SEP)
    # examine each row
    rows.each_with_index do | row, i |
    
      # we only care for rows with the expected number of columns and not the header row!
      if row.split(COL_SEP).size == EXPECTED_COL_NO && ( row.index(INPUT_COLS[0]).nil? && row.index(INPUT_COLS[1]).nil? )
        # extract the details
        date, memo, credit, debit, balance = row.split(COL_SEP)
        
        # reformat the date
        begin
          date = reformatDate(date)
        rescue ArgumentError => e
          puts "Error parsing date on line #{i}, setting to default"
          # set to default
          date = reformatDate("1900/01/01")
        end
        
        # push all credit/debit values into an amount column
        amount = nil
        # row is either credit or debit
        if debit.empty?
          if !credit.empty? && !credit.index(GBP).nil?
            amount = credit
          else
            puts "Error could not find £ in Credit field of line #{i}"
          end
        else
          # add a minus sign to debit
          symIndex = debit.index(GBP)
          if !symIndex.nil?
            amount = debit.insert(symIndex+1, "-")
          else
            puts "Error could not find £ in Debit field of line #{i}"
          end        
        end
        if amount.nil?
          puts "Error could not find Debit or Credit on line #{i}, defaulting Amount to zero"
          amount = 0
        end
        
        # construct the new row
		output += "#{date}#{COL_SEP}#{COL_SEP}#{memo}#{COL_SEP}#{amount}" + ROW_SEP    
      else
        puts "Ignoring line number #{i}"
      end
    end
    
    # output
    return output
    
  end

  private
  
  def outputHeader
    return OUTPUT_COLS.join(", ") + ROW_SEP
  end
  
  def reformatDate(date)
    d = Date.parse(date)
    return "#{d.year}/#{d.month}/#{d.day}"
  end

end

##
# Script entry point
##
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
  fileName = File.basename(statementPath, ".*") + " (Converted).csv"
  dirName = File.dirname(statementPath)
  savePath = dirName + "/" + fileName
  puts "Saving converted statement to #{savePath}"
  File.open(savePath, "w") { | f | f << convertedStatement }
  puts "Finished"
end

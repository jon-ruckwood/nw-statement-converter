=begin
  nw_converter.rb converts CSV banking statements from Nationwide into a more agreeable format for iBank to import.
  Copyright (C) 2010  Jonathan Ruckwood
  
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

require 'date'

##
# Converts the contents of a CSV statement from Nationwide 
# bank into a format which iBank is able to import
#
# @version: 1.0.3
# @author: Jonathan Ruckwood
#
class NationwideStatementConverter
  
  # constants
  GBP = "\243"
  ROW_SEP = "\n"
  COL_SEP = ","
  INPUT_COLS = %w{ Date Transactions Debits Credits Balance }
  EXPECTED_COL_NO = INPUT_COLS.size
  OUTPUT_COLS = %w{ Date Payee Memo Amount }
  DATE_SEP = "/"

  ##
  # Reformats a date into YYYY/mm/dd
  #
  def reformat_date(date)
    d = Date.parse(date)
    return "#{d.year}/#{d.month}/#{d.day}"
  end

  ##
  # Checks to see whether a row has the expected number of columns
  # 
  def expected_col_no?(row)
    valid = row.split(COL_SEP).size == EXPECTED_COL_NO
    return valid
  end

  ##
  # Checks to see if the row is the header row
  #
  def is_header_row?(row)
    return row.include?(INPUT_COLS[0]) && row.include?(INPUT_COLS[1])
  end

  ##
  # Converts rows from:
  #   INPUT_COLS
  # To:
  #   OUTPUT_COLS
  # And outputs the resulting string
  #
  def convert(content)
    output = ""
    # add the column headings
    output += outputHeader
    # split into rows
    rows = content.split(ROW_SEP)
    # examine each row
    rows.each_with_index do | row, i |
      # we only care for rows with the expected number of columns
      if expected_col_no?(row) 
        # skip the header row
        # TODO: This shouldn't really be checked after we've encountered it
        if !is_header_row?(row)        
            # extract the details
            date, memo, debit, credit, balance = row.split(COL_SEP)
            
            # reformat the date
            begin
              date = reformat_date(date)
            rescue ArgumentError => e
              #puts "Error parsing date on line #{i}, setting to default"
              report(i, "Error parsing date... setting to default")
              # set to default
              date = reformat_date("1900/1/1")
            end
            
            # push all credit/debit values into an amount column
            amount = nil
            # row is either credit or debit
            if debit.empty?
              if !credit.empty? && credit.include?(GBP)
                amount = credit
              else
                report(i, "Could not find '£' in Credit field")
              end
            else
              # add a minus sign to debit
              symIndex = debit.index(GBP)
              if !symIndex.nil?
                amount = debit.insert(symIndex+1, "-")
              else
                report(i, "Could not find '£' in Debit field")
              end        
            end
            if amount.nil?
              report i, "Could not determine a Debit or Credit value... defaulting Amount to 0.00"
              amount = 0
            end
            
            # construct the new row
    		output += "#{date}#{COL_SEP}#{COL_SEP}#{memo}#{COL_SEP}#{amount}" + ROW_SEP    
          else
            report(i, "Skipping header line") 
          end
        else
          report(i, "Ignoring, not enough columns")
        end
    end
    
    # output
    return output  
  end

  private

  def report(lineno, msg)
    puts "line #{lineno}: #{msg}"
  end

  ##
  # Constructs the header for converted CSV document
  #  
  def outputHeader
    return OUTPUT_COLS.join(", ") + ROW_SEP
  end

end

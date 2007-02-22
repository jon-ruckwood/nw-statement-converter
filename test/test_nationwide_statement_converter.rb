require 'lib/nw_converter.rb'
require 'test/unit'

class TestNationwideStatementConverter < Test::Unit::TestCase
  
  def setup
    @converter = NationwideStatementConverter.new
  end

  def get_file_contents(path)
    contents = nil
    begin 
      contents = File.open(path) { | f | f.read }
    rescue Errno::ENOENT
      puts "Error: File not found at path '#{path}' "
    end
  end
  
  def write_file(path, data)
    File.open(path, "w") { | f | f << data }
  end
  
  def test_expected_col_no?()
    sep = NationwideStatementConverter::COL_SEP
    ok_row = NationwideStatementConverter::INPUT_COLS.join sep
    bad_row = %w{One Two Three}.join sep
    
    #puts "Good Row: #{ok_row}"
    assert(@converter.expected_col_no?(ok_row))
    #puts "Bad Row: #{bad_row}"
    assert(!@converter.expected_col_no?(bad_row))
  end
  
  def test_is_header_row?()
    header_row = "Date, Transactions, Credits, Debits, Balance"
    data_row = "08 December 2006,\"Pay card\",,\"£27.54\",\"£2933.54\""
    empty_row = "\r\n"
    
    assert(@converter.is_header_row?(header_row))
    assert(!@converter.is_header_row?(data_row))
    assert(!@converter.is_header_row?(empty_row))
  end
  
  def test_reformat_date()
    output = "1900/1/1"
    dates = [output.dup, "01-01-1900", "1st January 1900"]

    dates.each do | date |
      assert_equal(@converter.reformat_date(date), output)
    end
    assert_raise(ArgumentError) { @converter.reformat_date "94135" }
  end
  
  def test_convert
    # Read in the statement data
    sample = get_file_contents("test/data/SampleStatement.csv")
    flunk("Couldn't load sample file") if sample.nil?
    expected_result = get_file_contents("test/data/result.csv") 
    flunk("Couldn't load result file") if expected_result.nil?
    # test conversion
    converted = @converter.convert(sample)
    write_file("ConvertedTest.csv", converted)
    assert_equal(converted, expected_result)
   end
  
end

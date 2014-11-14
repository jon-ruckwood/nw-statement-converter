Nationwide Statement Converter
==============================

Requirements
============

PowerPc/Intel Mac running Mac OS X 10.4 (Tiger) or later


Intro
=====

This program will converter Nationwide CSV statement files into a format
that will work with iBank's import feature. To operate simply select one
or more CSV files and drag them onto the Nationwide Statement Converter
program.

This opens a new window and shows you the details of the conversion progress.
Any errors or problems will be displayed in this window. Your converted
statements will be saved in same the location as the statements you dropped
onto the program.

The conversion process will turn transactions in the statement from:

Date, Transactions, Credits, Debits, Balance
08 December 2006,"Pay card",,"L27.54","L2933.54"
11 December 2006,"Pay card",,"L220.00","L2713.54"
11 December 2006,"Transfer",,"L30.00","L2683.54"

To:

Date, Payee, Memo, Amount
2006/12/8,,"Pay card","L-27.54"
2006/12/11,,"Pay card","L-220.00"
2006/12/11,,"Transfer","L-30.00"

Once you have converted your statements load up iBank's Import Screen. For
iBank to import the converted statements correctly you need to ensure that
the column order matches the following:

Date, Payee, Memo, Amount

And that the Date Format drop down is set to:

yyyy/mm/dd

These steps should ensure iBank imports the data correctly.


Problems
========

 * Partial Conversion Failure on MiniStatement.csv Files
	- The date will not be converted correctly, you will need to edit the
	converted file by hand.

 * Ruby related errors, e.g. “Command not found”
	- If you are running a version of Mac OS X prior to 10.4 (Tiger) it is
	possible that Ruby is not installed on your system. Ruby is a programming
	language that the converter is written in.

	- You can check if ruby is on your computer by doing the following:
		1. Open Terminal (Located in Applications -> Utilities)
		2. Typing "ruby -v" and hitting return in the Terminal window
		3. If Ruby is there you should see some text along the lines of:

		ruby 1.8.2 (2004-12-25) [universal-darwin8.0]

	- If Ruby is on your system it may be worth filing a bug on the project site
	to see if the problem can be resolved.


Bug Reporting
=============

If you experience any problems that are not covered in the Problems section please
feel free to submit them to:

https://github.com/jon-ruckwood/nw-statement-converter/issues


Thanks
======

The bundled version was created using Sveinbjorn Thordarson's Platypus development tool.
You can find out more about this handy tool here:

http://www.sveinbjorn.org/platypus


License
=======

Converts CSV banking statements from Nationwide into a more agreeable format for iBank to import.
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

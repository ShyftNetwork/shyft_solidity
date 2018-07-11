/*
	This file is part of solidity.

	solidity is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	solidity is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with solidity.  If not, see <http://www.gnu.org/licenses/>.
*/
/**
 * @author Christian <c@ethdev.com>
 * @date 2014
 * Formatting functions for errors referencing positions and locations in the source.
 */

#include <libsolidity/interface/SourceReferenceFormatter.h>
#include <libsolidity/parsing/Scanner.h>
#include <libsolidity/interface/Exceptions.h>
//Alex Binesh: Start Stack Overflow- Invalid use of parameters in Assembly code
extern bool bShyft_Display_Extra_Assembly_Error_Info;
//Alex Binesh: End Stack Overflow- Invalid use of parameters in Assembly code
 using namespace std;

namespace dev
{
namespace solidity
{

void SourceReferenceFormatter::printSourceLocation(SourceLocation const* _location)
{
	if (!_location || !_location->sourceName)
		return; // Nothing we can print here
	auto const& scanner = m_scannerFromSourceName(*_location->sourceName);
	int startLine;
	int startColumn;
	tie(startLine, startColumn) = scanner.translatePositionToLineColumn(_location->start);
	int endLine;
	int endColumn;
	tie(endLine, endColumn) = scanner.translatePositionToLineColumn(_location->end);
	if (startLine == endLine)
	{
		string line = scanner.lineAtPosition(_location->start);

		int locationLength = endColumn - startColumn;
		if (locationLength > 150)
		{
			line = line.substr(0, startColumn + 35) + " ... " + line.substr(endColumn - 35);
			endColumn = startColumn + 75;
			locationLength = 75;
		}
		if (line.length() > 150)
		{
			line = " ... " + line.substr(startColumn, locationLength) + " ... ";
			startColumn = 5;
			endColumn = startColumn + locationLength;
		}

		m_stream << line << endl;

		for_each(
			line.cbegin(),
			line.cbegin() + startColumn,
			[this](char const& ch) { m_stream << (ch == '\t' ? '\t' : ' '); }
		);
		m_stream << "^";
		if (endColumn > startColumn + 2)
			m_stream << string(endColumn - startColumn - 2, '-');
		if (endColumn > startColumn + 1)
			m_stream << "^";
		m_stream << endl;
	}
	else{
		if (! bShyft_Display_Extra_Assembly_Error_Info){
			m_stream <<
				scanner.lineAtPosition(_location->start) <<
				endl <<
				string(startColumn, ' ') <<
				"^\n" <<
				"Spanning multiple lines.\n";
		}
	}
//Alex Binesh: Start Stack Overflow- Invalid use of parameters in Assembly code

		// The below is a snippet of scanner.m_source_m_source string which contacins the stack overflow error details
		// We are interested in the variables in the assembley{} section, e.g. MyInteger and   YourInteger
		// .....
		// unbalancedStack() {\n\t\tuint MyInteger;\n\t\tuint YourInteger;\n\t\t
		// assembly {\n\t\t            MyInteger\n\t\t            YourInteger\n\t\t}\n\t}\n}"
	if (bShyft_Display_Extra_Assembly_Error_Info)
	{
		int iReversePointer=0;
		int j=-1, iStartOfTokens=_location->start;
		string sNextLine="";
		int iTokenLength=0;
		//iReversePointer=_location->end;


		//i +=  scanner.lineAtPosition(_location->start).length();// Skip the "assembly {" line and inspect the parameters

		if ( iStartOfTokens == _location->end){ //Rewind if the line pointer is at the end. In cases where previous error messages have caused the pointer to advance
			while  (iReversePointer < 100)  {
	//			cout <<  scanner.lineAtPosition(_location->start -k)   << endl;
				iStartOfTokens -= iReversePointer;
				j=scanner.lineAtPosition(iStartOfTokens).find("assembly");
				if (j  > -1)
				{
					iStartOfTokens -= iReversePointer;
		            //Only print the lines below if this error is related to assembly{} block
					break;
				}
				iReversePointer++;
			}
		}

		j=scanner.lineAtPosition(iStartOfTokens).find("assembly");
        if (j  > -1) {
		    int iCounter=0;
	  	    int  iLeftBracketCount=0, iFoundLocation=0;
		    cout<< "\nError: Please check the expressions in your assembly code as one or more may be causing this error:"<<endl;
//		    cout <<scanner.lineAtPosition(_location->start-iReversePointer)<<endl;
		    while (iCounter++ <= 500) {// Loop a limited number of times to avoid an infinite loop since we don't know where "assembly" directive is
				sNextLine =scanner.lineAtPosition(iStartOfTokens);
                sNextLine.replace('\t',' ');
                iTokenLength =scanner.lineAtPosition(iStartOfTokens).length();
                iStartOfTokens += iTokenLength;
				iFoundLocation = scanner.lineAtPosition(iStartOfTokens).find("{");//End of assembly {..} block
				if (iFoundLocation > -1) {//If nested braces
					iLeftBracketCount++;
				}

				iFoundLocation = scanner.lineAtPosition(iStartOfTokens).find("}");//End of assembly {..} block
                if (iFoundLocation > -1) {
                  	if (iLeftBracketCount>0){
						iLeftBracketCount--;
						
					}
					else{
                      break;
					}
                  }

                  //j = scanner.lineAtPosition(_location->start - iReversePointer).find("assembly");
                  //if (-1 == j)
                  {
                  	//sNextLine =scanner.lineAtPosition(_location->start - iReversePointer);
                  	if ( "" != sNextLine){
						//if (! scanner.lineAtPosition(_location->start-iReversePointer).find("assembly"))
						{
							cout << sNextLine << endl;
						}
					}
                  }

			}
          }
 	} //if (bShyft_Display_Extr...
 //Alex Binesh: End Stack Overflow- Invalid use of parameters in Assembly code

}

void SourceReferenceFormatter::printSourceName(SourceLocation const* _location)
{
	if (!_location || !_location->sourceName)
		return; // Nothing we can print here
	auto const& scanner = m_scannerFromSourceName(*_location->sourceName);
	int startLine;
	int startColumn;
	tie(startLine, startColumn) = scanner.translatePositionToLineColumn(_location->start);
	m_stream << *_location->sourceName << ":" << (startLine + 1) << ":" << (startColumn + 1) << ": ";
}

void SourceReferenceFormatter::printExceptionInformation(
	Exception const& _exception,
	string const& _name
)
{
 	SourceLocation const* location = boost::get_error_info<errinfo_sourceLocation>(_exception);
	auto secondarylocation = boost::get_error_info<errinfo_secondarySourceLocation>(_exception);


//Alex Binesh: Start Stack Overflow- Invalid use of parameters in Assembly code
	if (!bShyft_Display_Extra_Assembly_Error_Info)
	{
//Alex Binesh: End Stack Overflow- Invalid use of parameters in Assembly code
		printSourceName(location);
		m_stream << _name;
 		if (string const* description = boost::get_error_info<errinfo_comment>(_exception))
			m_stream << ": " << *description << endl;
		else
			m_stream << endl;

 //Alex Binesh: Start Stack Overflow- Invalid use of parameters in Assembly code
	}                                                                           		
//Alex Binesh: End Stack Overflow- Invalid use of parameters in Assembly code   		
	printSourceLocation(location);
	if (secondarylocation && !secondarylocation->infos.empty())
	{
			for (auto info: secondarylocation->infos)
			{
				printSourceName(&info.second);
				m_stream << info.first << endl;
				printSourceLocation(&info.second);
			}
			m_stream << endl;
	}

}

}
}

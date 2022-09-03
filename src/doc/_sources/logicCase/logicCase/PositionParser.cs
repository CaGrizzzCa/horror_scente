using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace logicCase
{
  class PositionParser
  {
		public static string[] Parse(string input)
		{
			string[] patterns = new string[]{
			@"^(\w+)",							// sprite name
			@"\W(-?\d+)\b",						// pos_x
			@"\b\d+\b\D*[^-\d](-?\d+)\b",	// pos_y
			@"(?!.*px)\W+([\D]+\d*)$"	// subfolder
		};
			string[] output = new string[patterns.Length];
			for (int i = 0; i < patterns.Length; i++)
			{
				Match m = Regex.Match(input, patterns[i]);
				if (m.Success)
				{
					output[i] = m.Groups[1].Captures[0].ToString();
				}
			}
			return output;
		}

		public static string ClearSubfoldersAndExtension(string input) {
			string output = input;
			string pattern = @"\\?(\w+)\.\w+$";
			Match m = Regex.Match(input, pattern);
			if (m.Success)
				output = m.Groups[1].Captures[0].ToString();
			return output;
		}
	}
}

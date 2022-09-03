using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Text.RegularExpressions;

namespace logicCase
{
    public class FuncString
    {
        private static int NextFuncID = 0;

        private int FuncID;

        public List<FuncString> FuncStrings;

        private FuncString AllOwner;
        private Dictionary<int,FuncString> AllFuncStrings;

        Regex regex_comment_multi = new Regex(@"(--\[\[(.|\r|\n)*?\]\])");              //многострочный комментарий
        Regex regex_comment = new Regex(@"(--.*)");                                     //комментарий
        Regex regex_quot = new Regex("(\"[^\"]*\")");                                   //текст в кавычках
        Regex regex_amp = new Regex("('[^']*')");                                       //текст в апострофах

        Regex regex_func = new Regex(@"((?<= |^|[(){};\[\]])(function)(?= |&|[(){};\[\]]))", RegexOptions.Multiline);          //начало функции

        Regex regex_beg = new Regex(@"((?<= |^|[(){};\[\]])(while|function|for|if)(?= |&|[(){};\[\]]))"); //end
        Regex regex_end = new Regex(@"((?<= |^|[(){};\[\]])(end)(?= |&|[(){};\[\]]))"); //end




        public FuncString(string code)
        {
            AllFuncStrings = new Dictionary<int, FuncString>();
            FuncStringInit(code, this);
        }

        private FuncString(string code, FuncString allOwner)
        {
            FuncStringInit(code, allOwner);
        }

        private void FuncStringInit( string code, FuncString allOwner)
        {
            FuncID = NextFuncID;
            NextFuncID++;

            AllOwner = allOwner;
            FuncStrings = new List<FuncString>();
            AllFuncStrings[FuncID] = this;

            //Console.WriteLine(code);
            //Console.WriteLine("#######################\n#######################\n#######################\n#######################\n#######################\n");

            //регексы текста, которые нужно выпилить чтобы не мешали искать функции


            code = regex_comment_multi.Replace(code, "##regex_comment_multi##");
            code = regex_comment.Replace(code, "##regex_comment##");
            code = regex_quot.Replace(code, "##regex_quot##");
            code = regex_amp.Replace(code, "##regex_amp##");

            //Console.WriteLine(code);
            //Console.WriteLine("#######################\n#######################\n#######################\n#######################\n#######################\n");

            //code = "##FUNC_" + funcID + "##" + code + "##/FUNC_"+ funcID + "##";
            Match func_match = regex_func.Match(code);

            while (func_match.Success)
            {
                Console.WriteLine(func_match.Index);
                Console.WriteLine("******");
                Console.WriteLine(code.Substring(0,100));
                Console.WriteLine("******");
                Console.WriteLine(code.Substring(func_match.Index, 100));
                Console.WriteLine("******");

                //if (func_match.Index > 0)
                //{
                string func_code = GetFuncString(code, func_match.Index);
                    Console.WriteLine(func_code);
                    break;
               // }
               // else
                //{
                    //func_match = func_match.NextMatch();
                //}
            }
        }

        private string GetFuncString( string code, int start )
        {
            string func_code = code.Substring(start);
            Console.WriteLine("******");
            //Console.WriteLine(func_code);
            Console.WriteLine("******");

            int end_count = 0;

            Match end_match = regex_end.Match(func_code);
            Match beg_match = regex_beg.Match(func_code);

            while(end_match.Success)
            {
                Console.WriteLine(end_count + ": beg_match = " + beg_match.Value + "(" + beg_match.Index + "); end_match = " + end_match.Value + "(" + end_match.Index + ");");

                    if(beg_match.Success && beg_match.Index < end_match.Index )
                    {
                        Console.WriteLine(2);
                        end_count++;
                    Console.WriteLine("******");
                    Console.WriteLine(beg_match.Value);
                    Console.WriteLine(code.Substring(beg_match.Index, 100));

                    beg_match = beg_match.NextMatch();
                    Console.WriteLine(">>>>>>>******");
                    Console.WriteLine(beg_match.Value);
                    Console.WriteLine(code.Substring(beg_match.Index, 100));
                }
                    else
                    {
                        Console.WriteLine(3);
                        end_count--;
                        if (end_count <= 0)
                        {
                            break;
                        }
                    end_match = end_match.NextMatch();
                    }

                
            }
            string answer = func_code.Substring(0, end_match.Index + end_match.Length);

            return answer;
        }
    }
}

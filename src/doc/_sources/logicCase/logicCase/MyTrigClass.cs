using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

namespace logicCase
{
    public class MyTrigClass
    {

        string name;
        public string Name { get { return name; } set { name = value; } }

        List<string> code = new List<string>();

        public MyTrigClass( string freeTrigName)
        {
            code.Add("--");
            name = freeTrigName;
        }

        public MyTrigClass( List<string> xml, int id)
        {
            name = ModuleClass.getObjValue(xml[id], "name");
            //System.Windows.Forms.MessageBox.Show("имя " + name);
            for (int i = 0; i < xml.Count; i++)
                code.Add(xml[i]);
        }

        public int GetCodeCount()
        {
            return code.Count;
        }

        public string GetName()
        {
            return name;
        }

        public List<string> GetCode()
        {
            return code;
        }

        public void Save(StreamWriter f, int stacks)
        {
            //f.WriteLine("        <trig name=\""+name+"\">");
            //f.Write("            <code>");
            for (int i = 0; i < code.Count; i++)
            {
                if (i == code.Count - 1)
                {
                    //if (i == 0)
                    //{
                        f.Write(code[i]);
                        //f.WriteLine("</code>");
                    //}
                    //else
                    //{
                        //f.Write(code[i]);//!!
                    //}
                }
                else
                {
                    f.WriteLine(code[i]);
                }
            }
            
            //f.WriteLine("        </trig>");
        }

        public void AddTrimmer()
        {
            code.Add("--------------------------------------------------------------------");
        }

        public void AddListToCode(List<string> lst)
        {
            for (int i = 0; i < lst.Count; i++)
            {
                code.Add(lst[i]);
            }
        }
        public void AddListToCode(List<string> lst, int startIndex)
        {
            startIndex = startIndex >= 0 ? startIndex : 0;
            for (int i = 0; i < lst.Count; i++)
            {
                code.Insert(startIndex + i, lst[i]);
            }
        }
        public void AddCode(string str, int id)
        {
            code.Insert(id, str);
        }
    }
}

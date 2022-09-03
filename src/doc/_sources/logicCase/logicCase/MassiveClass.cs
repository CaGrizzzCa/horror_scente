using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace logicCase
{
    class MassiveClass
    {
        List<string> list;
        string name;

        public MassiveClass( List<string> list, string name )
        {
            this.list = list;
            this.name = name;
            /*
            for (int i = 0; i < list.Count; i++)
            {
                if (list[i].IndexOf(name) > -1)
                {
                    string buf = list[i];
                    buf = FirstSpaseClear(buf);
                }

            }*/
        }

        string FirstSpaseClear(string s)
        {
            if (s.IndexOf(" ") == 0)
                return FirstSpaseClear(s.Substring(1));
            else
                return s;
        }

    }
}

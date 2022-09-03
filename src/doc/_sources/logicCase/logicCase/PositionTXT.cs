using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Forms;

namespace logicCase
{
    public class PositionObj
    {
        public string name { get; private set; }
        public int posX { get; private set; }
        public int posY { get; private set; }

        public PositionObj( string positionString )
        {
            string buf = positionString;
            buf = buf.Replace("px", "");
            buf = buf.Replace("  ", " ");
            name = buf.Substring(0, buf.IndexOf(" "));
            buf = buf.Substring(buf.IndexOf(" ") + 1);
            posX = Convert.ToInt16(buf.Substring(0, buf.IndexOf(" ")));
            posY = Convert.ToInt16(buf.Substring(buf.IndexOf(" ")+1));
        }

        public void MovePosition( int x, int y )
        {
            posX += x;
            posY += y;
        }

        public string GetSaveString()
        {
            return name + " " + posX + " px " + posY + " px";
        }
    }

    public class PositionTXT
    {
        
        Dictionary<string, PositionObj> childs = new Dictionary<string, PositionObj>();
        List<PositionObj> order = new List<PositionObj>();
        string openPath;

        public PositionTXT(string path)
        {
            StreamReader sr = new StreamReader(path);
            string line;
            while ((line = sr.ReadLine())!=null)
            {
                if(!string.IsNullOrEmpty(line))
                {
                    PositionObj po = new PositionObj(line);
                    if(childs.ContainsKey(po.name))
                    {
                        MessageBox.Show(path+"\nПовторное имя объекта "+po.name);
                    }
                    else
                    {
                        order.Add(po);
                        childs.Add(po.name, po);
                    }
                }
            }
            openPath = path;
            sr.Close();
        }

        public void MovePositions( int x, int y )
        {
            foreach(KeyValuePair<string,PositionObj> kvp in childs)
            {
                kvp.Value.MovePosition(x, y);
            }
        }

        public void Save()
        {
            StreamWriter sw = new StreamWriter(openPath);
            for(int i = 0;i < order.Count;i++)
            {
                sw.WriteLine(order[i].GetSaveString());
            }
            sw.Close();
        }
    }
}

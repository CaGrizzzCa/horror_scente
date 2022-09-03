using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Diagnostics;

namespace logicCase
{
    public partial class gObjForm : Form
    {
        PrgItemClass item;
        string fbeg, fend;

        public gObjForm(PrgItemClass item, string fbeg, string fend)
        {
            
            InitializeComponent();
            this.item = item;
            this.Text = item.Type+"_"+ item.gobj.name;
            this.fbeg = fbeg;
            this.fend = fend;
        }

        private void gObjForm_SizeChanged(object sender, EventArgs e)
        {
            //richTextBoxBeg
        }

        private void gObjForm_Shown(object sender, EventArgs e)
        {

            if (fbeg != null)
                this.richTextBoxBeg.Text = (fbeg.Replace("###","\n"));
            if (fend != null)
                this.richTextBoxEnd.Text = (fend.Replace("###", "\n"));
        }

        private void gObjForm_MouseDown(object sender, MouseEventArgs e)
        {

        }

        private void richTextBoxBeg_Click(object sender, EventArgs e)
        {
            
        }

        List<string> StrToList(string s)
        {
            List<string> l = new List<string>();
            while (s.IndexOf("\n") > -1)
            {
                //Program.form.Debag(s);
                l.Add(s.Substring(0, s.IndexOf("\n")));
                s = s.Substring(s.IndexOf("\n") + 1);
            }
            l.Add(s);
            return l;
        }
        string ListToString(List<string> l)
        {
            string s = "";
            for (int i = 0; i < l.Count; i++)
            {
                s += l[i];
                //Program.form.Debag(s);
                if (i < l.Count - 1)
                    s += "\n";
            }
            return s;
        }

        private void gObjForm_FormClosed(object sender, FormClosedEventArgs e)
        {

            this.Dispose();
            item.propForm = null;
        }

        private void richTextBoxBeg_DoubleClick(object sender, EventArgs e)
        {
            //if (fbeg == null)
            //{
            //    if (item.Type == "use" | item.Type == "clk")
            //    {
            //        fbeg = "function()\n        ld.obj:" + item.Type + "I()\n    end";
            //    }
            //    else
            //    {
            //        fbeg = fbeg = "function()\n    end";
            //    }
            //}
            //if (fbeg != null)
            //{
                System.IO.StreamWriter sw = new System.IO.StreamWriter("fbeg.lua");
                //Program.form.Debag(fbeg);
                string s = fbeg;
                if (s == null)
                {
                    if (item.Type == "use" | item.Type == "clk")
                    {
                        s = "function()\n        ld.obj:" + item.Type + "I()\n    end";
                    }
                    else
                    {
                        s = "function()\n        \n        end";
                    }
                }
                program.form.Debag(s);
                s = s.Replace("###", "\n");
                s = s.Replace("\r", "");
                s = s.Replace("&apos;", "'");
                program.form.Debag(s);
                List<string> ls = StrToList(s);
                string bf = ls[0];
                string ef = ls[ls.Count - 1];
                ls.RemoveAt(0);
                ls.RemoveAt(ls.Count - 1);
                s = ListToString(ls);
                program.form.Debag(s);
                sw.Write(s);
                sw.Close();
                Process NPad = Process.Start("Notepad++.exe", " -nosession -alwaysOnTop " + AppDomain.CurrentDomain.BaseDirectory + "\\" + "fbeg.lua");
                NPad.WaitForExit();
                System.IO.StreamReader sr = new System.IO.StreamReader("fbeg.lua");
                s = sr.ReadToEnd();
                sr.Close();
                s = s.Replace("\t", "    ");

                if (s == "        ")
                {
                    s = "";
                }
                else
                {
                    
                    System.IO.File.Delete("fbeg.lua");
                    program.form.Debag(s);
                    ls = StrToList(s);
                    ls.Insert(0, bf);
                    ls.Add(ef);
                    for (int i = 0; i < ls.Count; i++)
                    {
                        ls[i] = ls[i].Replace("\t", "    ");
                    }
                    this.richTextBoxBeg.Text = ListToString(ls);
                    //Program.form.Debag(s);
                    s = "";
                    for (int i = 0; i < ls.Count; i++)
                    {
                        //Program.form.Debag(s);
                        ls[i] = ls[i].Replace("\t", "    ");
                        if (i < ls.Count - 1)
                            ls[i] = ls[i] + "###";
                        s += ls[i];
                    }
                    //Program.form.Debag(s);
                    s = s.Replace("'", "&apos;");
                    s = s.Replace("\n", "");
                    s = s.Replace("\r", "");
                    //Program.form.Debag(s);

                    if (item.Type == "get")
                    {
                        if (s.Length == 0)
                            s = null;
                        item.gobj.get[item.Num].fbeg = s;
                        this.fbeg = s;
                        //Program.form.Debag(item.Type + " " + item.gobj.get[item.Num].fbeg);
                        item.fbeg = s;
                    }
                    else if (item.Type == "use")
                    {
                        item.gobj.use[item.Num].fbeg = s;
                        this.fbeg = s;
                        //Program.form.Debag(item.Type + " " + item.gobj.use[item.Num].fbeg);
                        item.fbeg = s;
                    }
                    else if (item.Type == "clk")
                    {
                        item.gobj.clk[item.Num].fbeg = s;
                        this.fbeg = s;
                        //Program.form.Debag(item.Type + " " + item.gobj.clk[item.Num].fbeg);
                        item.fbeg = s;
                    }

                }
                //System.Windows.Forms.MessageBox.Show(this.BackColor.A.ToString()+" "+this.BackColor.R.ToString()+" "+this.BackColor.G.ToString()+" "+this.BackColor.B.ToString());
            //}
        }

        private void richTextBoxEnd_DoubleClick(object sender, EventArgs e)
        {
            //if (fend == null)
            //{
            //    fend = "function()\n        end";
            //}
            //if (fend != null)
            //{
                System.IO.StreamWriter sw = new System.IO.StreamWriter("fend.lua");
                //Program.form.Debag(fbeg);
                string s = fend;
                if (s == null)
                {
                    s = "function()\n        \n        end";
                }
                s = s.Replace("###", "\n");
                s = s.Replace("\r", "");
                s = s.Replace("&apos;","'");
                List<string> ls = StrToList(s);
                string bf = ls[0];
                string ef = ls[ls.Count - 1];
                ls.RemoveAt(0);
                ls.RemoveAt(ls.Count - 1);
                s = ListToString(ls);
                sw.Write(s);
                program.form.Debag("_"+s+"_");
                sw.Close();
                Process NPad = Process.Start("Notepad++.exe", "-nosession -alwaysOnTop " + AppDomain.CurrentDomain.BaseDirectory + "\\" + "fend.lua");
                NPad.WaitForExit();
                System.IO.StreamReader sr = new System.IO.StreamReader("fend.lua");
                s = sr.ReadToEnd();
                sr.Close();
                s = s.Replace("\t", "    ");

                if (s == "        ")
                {
                    s = "";
                }
                else
                {
                    System.IO.File.Delete("fend.lua");
                    ls = StrToList(s);
                    ls.Insert(0, bf);
                    ls.Add(ef);
                    for (int i = 0; i < ls.Count; i++)
                    {
                        ls[i] = ls[i].Replace("\t", "    ");
                    }
                    this.richTextBoxEnd.Text = ListToString(ls);

                    s = "";
                    for (int i = 0; i < ls.Count; i++)
                    {
                        //Program.form.Debag(s);
                        ls[i] = ls[i].Replace("\t", "    ");
                        if (i < ls.Count - 1)
                            ls[i] = ls[i] + "###";
                        s += ls[i];
                    }
                    s = s.Replace("'", "&apos;");
                    s = s.Replace("\n", "");
                    s = s.Replace("\r", "");

                    program.form.Debag(s);
                    if (s.Length == 0)
                        s = null;
                    if (item.Type == "get")
                    {
                        item.gobj.get[item.Num].fend = s;
                        this.fend = s;
                        item.fend = s;
                    }
                    else if (item.Type == "use")
                    {
                        item.gobj.use[item.Num].fend = s;
                        this.fend = s;
                        item.fend = s;
                    }
                    else if (item.Type == "clk")
                    {
                        item.gobj.clk[item.Num].fend = s;
                        this.fend = s;
                        item.fend = s;
                    }
                }

                //System.Windows.Forms.MessageBox.Show(this.BackColor.A.ToString()+" "+this.BackColor.R.ToString()+" "+this.BackColor.G.ToString()+" "+this.BackColor.B.ToString());
            //}
        }
    }
}

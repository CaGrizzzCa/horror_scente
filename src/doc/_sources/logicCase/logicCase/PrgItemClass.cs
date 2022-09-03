using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Reflection;
using System.Diagnostics;

namespace logicCase
{
    public partial class PrgItemClass : Label
    {
        public GameObj gobj;
        string type;
        int num;
        Form1 form = program.form;
        public gObjForm propForm;
        public string fbeg;
        public string fend;

        public string Type { private set { } get { return this.type; } }
        public int Num { private set { } get { return this.num; } }

        public PrgItemClass( GameObj go, string fullName, int num)
        {
            if (fullName.IndexOf("get_") == 0)
            {
                type = "get";
                fbeg = go.get[num].fbeg;
                fend = go.get[num].fend;

            }
            else if (fullName.IndexOf("use_") == 0)
            {
                type = "use";
                fbeg = go.use[num].fbeg;
                fend = go.use[num].fend;
            }
            else if (fullName.IndexOf("clk_") == 0)
            {
                type = "clk";
                fbeg = go.clk[num].fbeg;
                fend = go.clk[num].fend;
            }
            type = fullName.Substring(0, 3);
            this.num = num;
            gobj = go;
            this.MouseDown += new MouseEventHandler(prgL_MouseDown);
            this.MouseDoubleClick += new MouseEventHandler(prgL_MouseDoubleClick);
            this.MouseClick += new MouseEventHandler(prgL_MouseClick);

        }



        void Debag(string s)
        {
            form.Debag(s);
        }

        void prgL_MouseDown(object sender, EventArgs e)
        {
            //form.Debag(gobj.GetCode());


        }
        void prgL_MouseDoubleClick(object sender, EventArgs e)
        {
            MessageBox.Show("inv_complex_" + gobj.name);
            if (type == "get")
            {
                
                DialogResult drslt = MessageBox.Show("создать комплексный объект?", "inv_complex_" + gobj.name, MessageBoxButtons.YesNoCancel);
                if (drslt == DialogResult.Yes)
                {

                }
                else
                {
                    if (propForm == null)
                    {
                        //form.Debag(fbeg);
                        //form.Debag(fend);
                        propForm = new gObjForm(this, fbeg, fend);
                        propForm.Show();
                    }
                    else
                    {
                        form.Debag(fbeg);
                        propForm.Activate();
                    }
                }
            }
        }
        void prgL_MouseClick(object sender, EventArgs e)
        {


        }
    }
}

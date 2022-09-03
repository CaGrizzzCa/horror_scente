using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Runtime.Serialization;

namespace BlueLogic
{
    public static class program
    {
        public static editForm form;

        public static gameLogic logic = new gameLogic();

        [STAThread]
        static void Main(string[] args)
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            form = new editForm();

            if (args != null)
                foreach (string str in args)
                {
                    form.openFile(str);
                    break;
                }

            Application.Run(form);
        }
        
    }
}

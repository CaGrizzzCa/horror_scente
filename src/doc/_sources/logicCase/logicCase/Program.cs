using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows.Forms;
using System.Diagnostics;
//using BlueLogic;

namespace logicCase
{
    static class program
    {
        public static Form1 form;
        //public static gameLogic logic = new gameLogic();
        /// <summary>
        /// Главная точка входа для приложения.
        /// </summary>
        [STAThread]
        static void Main(string[] arg)
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);

            string[] ARG = { @"D:\Work\CS4\exe\assets\levels\level\inv_deploy\inv_complex_angelbase\angelamulet2.png" };

            form = new Form1(arg);
            

            Application.Run(form);

        }
    }
}

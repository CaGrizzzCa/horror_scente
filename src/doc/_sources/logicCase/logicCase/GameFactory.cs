using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Diagnostics;
using System.Text.RegularExpressions;
using System.ComponentModel;
using System.Reflection;
using System.Windows.Forms;

namespace logicCase
{
    public class GameFactory
    {
        protected static List<ModuleClass> mc = program.form.Modules;
        public Dictionary<string,GameObj> items = new Dictionary<string, GameObj>();// = new List<gameObj>();
        //public string log = "";
        
        public GameFactory(Form1 form)
        {

            mc = form.modules;
            loadTrigStr();

            //items["gaff"].GetCode();
        }
        //public void loadGameFactory()
        //{
        //    mc = program.form.modules;
        //    loadTrigStr();
        //}
        /// <summary>
        /// Загрузка всех объектов
        /// </summary>
        /// <param name="str">строка с кодом</param>
        public void LoadItem(string str)
        {
            luaint lua = new luaint(func2str(str));
            items = items.Concat(lua.loadCode()).ToDictionary(e => e.Key, e => e.Value);
        }
        /// <summary>
        /// Загрузка объектов комнаты
        /// </summary>
        /// <param name="str">строка с кодом</param>
        /// <param name="rmname">имя комнаты</param>
        public void LoadItem(string str, string rmname)
        {
            luaint lua = new luaint(func2str(str));
            Dictionary<string, GameObj> dd = lua.loadCode();
            foreach(GameObj go in dd.Values)
            {
                go.rm_owner = rmname;
                if (go.rm.Count == 0)
                {
                    //go.rm.Add(rmname);
                }
            }
            items = items.Concat(dd).ToDictionary(e => e.Key, e => e.Value);
        }
        /// <summary>
        /// Загружает игровые объекты с триггеров.
        /// </summary>
        private void loadTrigStr()
        {
            //перебор модулей
            string name;
            for (int i = 0; i < mc.Count; i++)
            {
                //загрузка тригера
                name = mc[i].GetName();
                List<string> file = mc[i].GetTrig("trg_" + name.Substring(3) + "_init").GetCode();
                bool itemFound = false;

                //копируем код с игровыми объектами в  строку
                StringBuilder code = new StringBuilder();
                string str;
                int count=0;
                int index = 0;
                foreach(string line in file)
                {
                    index++;
                    if (itemFound || ((line.IndexOf("ld.gobj[")) != -1 && (line.IndexOf("ld.gobj[") < line.IndexOf("--") || line.IndexOf("--") == -1)))
                    {
                        if (count == 0)
                            count = index;
                        itemFound = true;
                        code.AppendLine(line);
                    }
                }
                //System.Windows.Forms.MessageBox.Show(log);
                //log = "";
                //загружаем объекты. Если объектов нет, длина str будет 0-1
                str = code.ToString();
                if (str.Length > 2)
                {
                    LoadItem(str, mc[i].GetName());
                }
                //удаление строчек после нахождения игровых объектов
                while (file.Count >= count && count!= 0)
                    file.RemoveAt(file.Count - 1);
            }
        }
        /// <summary>
        /// Делает из всех функций вида sget = function() end; sget = 'function() end;' для записи их как строки
        /// </summary>
        /// <param name="str">код</param>
        /// <returns>измененый код</returns>
        private string func2str(string str)
        {
            /// Апострофы деют полную совместимость, т.к. в коде NotEngine они превращаются в "&apos;", а значит не будут мешать в этом коде
            Regex key = new Regex(@"[a-zA-Z][a-zA-Z0-9_]+");
            Regex open = new Regex(@"[;, \r\n][a-zA-Z0-9_ ]+=+([ ]+function|function)");
            Regex func = new Regex(@"function+[^*]+");

            Match _open;
            Match _func;
            Match _key ;
            int index = 0;
            _open = open.Match(str, index);
            while (_open.Length > 0)
            {
                index = _open.Index + 1;
                _key = key.Match(str, index);
                index++;
                _func = func.Match(str, index);
                str = str.Replace(findFunc(str.Substring(_func.Index)), "'" + findFunc(str.Substring(_func.Index)).Replace("'","\'").Replace("\r\n","###") + "'");
                _open = open.Match(str, index);
            }
            return str;
        }
        private string findFunc(string str)
        {
            int index = str.IndexOf("function") + 1;
            int openclose = 1;
            int alc = 1;

            while (openclose != 0)
            {


                int beg = str.IndexOf("function", index);
                int end = str.IndexOf(" end", index);

                if ((str.IndexOf(" if ", index) > -1 & str.IndexOf(" if ", index) < end)
                 || (str.IndexOf(" if(", index) > -1 & str.IndexOf(" if(", index) < end)
                 || (str.IndexOf(";if ", index) > -1 & str.IndexOf(";if ", index) < end)
                 || (str.IndexOf(";if(", index) > -1 & str.IndexOf(";if(", index) < end))
                {
                    //System.Windows.Forms.MessageBox.Show(str.Substring(index));
                    alc++;
                    openclose += 1;
                }

                if (beg > end || beg == -1)
                {

                    openclose -= 1;
                    index = end + 1;
                }
                else
                {
                    openclose += 1;
                    index = beg + 1;
                }
            }
            //if(alc>1) System.Windows.Forms.MessageBox.Show(str.Substring(0, index + 3));
            //log += str.Substring(0, index + 3) + "\n";
            return str.Substring(0, index + 3);
        }
    }
}
using System;
using System.Collections.Generic;
using System.Collections;
using System.Linq;
using System.Text;
using LuaInterface;
using System.Diagnostics;
using CSharpLua;
using System.Reflection;
using System.IO;


namespace logicCase
{
    class luaint
    {
        private Lua lua = new Lua();
        private string _code;
        private Assembly _assembly;
        private string _luaInit;
        private string _luaPrepare;
        /// <summary>
        /// инициализирует код lua для классов из текстовых файлов проекта и строки
        /// </summary>
        /// <param name="code"></param>
        public luaint(string code)
        {
            StreamReader _textStreamReader;
            _code = code;
            _assembly = Assembly.GetExecutingAssembly();
            _textStreamReader = new StreamReader(_assembly.GetManifestResourceStream("logicCase.LuaIni.txt"));
            _luaInit = _textStreamReader.ReadToEnd();
            _textStreamReader.Close();
            _textStreamReader = new StreamReader(_assembly.GetManifestResourceStream("logicCase.LuaPrepare.txt"));
            _luaPrepare = _textStreamReader.ReadToEnd();
            _textStreamReader.Close();
            //pashet !!
        }
        /// <summary>
        /// читаем файлы из ресурсов, выполняем код в нужной последовательности
        /// </summary>
        /// <returns>имя объекта, игровой объект</returns>
        public Dictionary<string, GameObj> loadCode()
        {
            string log = "";
            try
            {
                /// инициализация объектов C# в lua
                lua.DoString(_luaInit);
                /// инициализация полученного кода
                lua.DoString(_code);
                /// инициализация игровых объектов и запись их в C# объекты
                lua.DoString(_luaPrepare);
                /// копирование(или передача ссылки, даже не знаю) из lua c# в c# объекты.
                /// возможно сделать запись сразу в C#, для этого нужно регистрировать объекты C# в lua
                ArrayList names = (ArrayList)lua["names"];
                Dictionary<string, GameObj> value = new Dictionary<string, GameObj>();
                int i = 0;
                foreach (string name in names)
                {
                    log += name + "\n";
                    //System.Windows.Forms.MessageBox.Show(name);
                    value.Add(name, (GameObj)((ArrayList)lua["Gobj"])[i]);
                    i++;
                }
                //System.Windows.Forms.MessageBox.Show(log);
                lua.Close();
                return value;
            }
            catch (Exception exs)
            {
                System.Windows.Forms.MessageBox.Show(log);
                Debug.WriteLine(exs.Message);
                throw (exs);
            }
        }
    }
}

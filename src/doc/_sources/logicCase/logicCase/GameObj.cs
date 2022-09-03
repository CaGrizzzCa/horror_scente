using System;
using System.Collections.Generic;
using System.Collections;
using System.Linq;
using System.Text;
using System.ComponentModel;
using System.Reflection;

namespace logicCase
{    
    /// <summary>
    /// Класс игроввых объектов. В качестве use и get используются классы. Это нужно для совсестимости с кодом lua и пластичности.
    /// </summary>
    public class GameObj
    {
        public string rm_owner;
        public int _objNum;
        public static int _counter = 1;

        public int _index;
        public string name;
        public ArrayList rm = new ArrayList();
        // string zz;
        public string inv;
        public Gets get = new Gets();
        public Uses use = new Uses();
        public Clks clk = new Clks();

        // методы
        //установка объекту комнаты владельца
        public string RmOwner
        {
            set
            {
                program.form.Debag("for "+ name +" rm_owner set to " + value);
                rm_owner = value;
            }
        }
        //установка GET комнаты владельца
        public void GetRmSet(int n, string value)
        {
            program.form.Debag("for " + name + " №"+n+" GetRm set to " + value);
            get[n].rm = value;
        }
        //установка GET zz владельца
        public void GetZzSet(int n, string value)
        {
            program.form.Debag("for " + name + " №" + n + " GetZz set to " + value);
            get[n].zz = value;
        }
        //установка GET mg владельца
        public void GetMgSet(int n, string value)
        {
            program.form.Debag("for " + name + " №" + n + " GetMg set to " + value);
            get[n].mg = value;
        }
        //установка GET ho владельца
        public void GetHoSet(int n, string value)
        {
            program.form.Debag("for " + name + " №" + n + " GetHo set to " + value);
            get[n].ho = value;
        }
        //установка GET fly set
        public void GetFlySet(int n, string value)
        {
            program.form.Debag("for " + name + " №" + n + " GetFly set to " + value);
            get[n].fly = value;
        }

        public string Addrm
        {
            set
            {
                program.form.Debag("Addrm " + value);
                if (rm.Count <= _index)
                    rm.Add(value);
                else
                    rm[_index] = value;
            }
        }
        public Get Addget
        {
            set
            {
                get[_index] = value;
                if (get.Count <= 1)
                {
                    _objNum = _counter;
                    _counter++;
                }
            }
        }
        public Use Adduse
        {
            set
            {
                use[_index] = value;
            }
        }
        public Clk Addclk
        {
            set
            {
                clk[_index] = value;
            }
        }
        /// <summary>
        /// Возвращает строку с lua кодом этого объекта.
        /// </summary>
        /// <returns></returns>
        public string GetCode()
        {
            this._index = 0;
            StringBuilder str = new StringBuilder();
            string name = this.name;
            this.name = null;

            string rm_owner_temp = this.rm_owner;
            this.rm_owner = null;
            int counter_tmp = _counter;
            _counter = 0;
            int objNum_tmp = _objNum;
            _objNum = 0;
            
            str.AppendLine("ld.gobj[\"" + name + "\"] = ");
            str = parseClass(str, this,"", 0);

            this.rm_owner = rm_owner_temp;
            this.name = name;

            _counter = counter_tmp;
            _objNum = objNum_tmp;

            str.Replace("###", Environment.NewLine);
            //Program.form.Debag(str.ToString());
            return str.ToString();
        }

        List<FieldInfo> orderedList(List<FieldInfo> l, string[] args)
        {
            List<FieldInfo> ord = new List<FieldInfo>();
            for (int i = 0; i < args.Count() - 1; i++)
            {
                for (int ii = 0; ii < l.Count; ii++)
                {
                    
                }
                //while (l.Count > 0)
                //{
                    for (int ii = 0; ii < l.Count & ii > -1; ii++)
                    {
                        
                        if (l[ii].Name == args[i])
                        {
                            ord.Add(l[ii]);
                            l.RemoveAt(ii);
                            ii--;
                        }
                    }
                //    for (int ii = 0; ii < l.Count & ii>-1; ii++)
                //    {
                //        ord.Add(l[ii]);
                //        l.RemoveAt(ii);
                //        ii--;
                //    }
                //}
            }
            for (int ii = 0; ii < l.Count & ii > -1; ii++)
            {
                ord.Add(l[ii]);
                l.RemoveAt(ii);
                ii--;
            }
            return ord;
        }

        private StringBuilder parseClass(StringBuilder str,dynamic cls, string tabs, int n)
        {
            ///здесь используется рефлексия для определения вложенности. Эта штука должна работать при изменении полей класса, т.к. не связана с чем-то конкретно.
            ///Может быть использована и для приведения любых других объектов записанных из lua.
            ///Принцип работы. Перебираются поля FieldInfo c информацией о полях объекта. Проверяется тип и соответственно ему строится объект.
            ///При нахождении поля, которое не указано, функция вызвается для найденного поля(рекурсия).
            String tab = "  ";
            String open = "{";
            String end = "};";
            String apos = "\"";
            String equally = " = ";
            tabs += tab;
            if (tabs == tab)
                str.AppendLine(open);
            else
                str.AppendLine(tabs+open);

            //для записи в определенном порядке//
            string s = "";
            List<FieldInfo> fil = new List<FieldInfo>();
            foreach (FieldInfo fieldInfo in cls.GetType().GetFields())
            {
                s += fieldInfo.Name + "\n";
                fil.Add(fieldInfo);
            }
            //System.Windows.Forms.MessageBox.Show(s);

            string[] order = { "rm", "zz", "mg", "ho", "inv", "fly", "sound", "get", "use", "clk","set","del", "fbeg", "fend" };

            fil = orderedList(fil, order);
            s = "";
            for (int i = 0; i < fil.Count; i++)
            {
                s += fil[i].Name + "\n";
            }
            //System.Windows.Forms.MessageBox.Show(s);
            /////////////////////////////////////
            

            //foreach (FieldInfo fieldInfo in cls.GetType().GetFields())
            //{
            for(int filc = 0;filc<fil.Count;filc++)
            {
                FieldInfo fieldInfo = fil[filc];
                if (fieldInfo.FieldType.Name == "ArrayList")
                {
                    IList al = (IList)fieldInfo.GetValue(cls);
                    if (al.Count > 0)
                    {
                        str.AppendLine(tabs+fieldInfo.Name + " = ");
                        str.AppendLine(tabs+open);
                        foreach (string value in al)
                        {
                            str.AppendLine(tabs+tab + apos + value + apos + ";");
                        }
                        str.AppendLine(tabs+end);
                    }
                }
                else if (fieldInfo.FieldType.Name == "String")
                {
                    string value = fieldInfo.GetValue(cls);
                    tabs += tab;
                    if (value != null )
                    {
                        //if (fieldInfo.Name.Substring(0, 1) == "f")
                        //    str.AppendLine(tabs+fieldInfo.Name + equally + value.ToString() + ";");
                        if (fieldInfo.Name == "fbeg" | fieldInfo.Name == "fend" )
                            str.AppendLine(tabs+fieldInfo.Name + equally + value.ToString() + ";");
                        else
                            str.AppendLine(tabs+fieldInfo.Name + equally + apos + value.ToString() + apos + ";");
                    }
                    tabs = tabs.Substring(0, tabs.Length - tab.Length);
                } 
                else if (fieldInfo.FieldType.Name == "Int32")
                {
                    Int32 value = fieldInfo.GetValue(cls);
                    if (value != 0)
                    {
                        str.AppendLine(tabs+fieldInfo.Name + equally + value.ToString() + ";");
                    }
                }
                else
                {
                    var al = fieldInfo.GetValue(cls);
                    if (al[n].rm != null )
                    {
                        str.AppendLine(tabs + fieldInfo.Name + " = ");
                        str.AppendLine(tabs + open);

                        for (int i = 0; al.Count > i; i++)
                        {
                            //if (al[i].rm != null)
                            //{
                            parseClass(str, al[i], tabs,n+1);
                            //}
                        }
                        str.AppendLine(tabs + end);
                    }
                }
            }

            if (tabs == tab)
                str.AppendLine(end);
            else
                str.AppendLine(tabs + end);
            return str;
        }
    }
    public class Gets
    {
        private List<Get> get = new List<Get>(1);
        public Gets()
        {
            get.Add(new Get());
        }
        public Get this[int index] 
        {
            get
            {
                return get[index];
            }
            set
            {
                while (get.Count <= index)
                    this.Add(new Get());
                get[index] = value;
            }  
        }
        public int Count
        {
            get { return get.Count; }
        }
        public void Add(Get value)
        {
            get.Add(value);
        }
        public void Remove(Get value)
        {
            get.Remove(value);
        }

        public Get Last
        {
            get
            {
                return get[get.Count];
            }
            set
            {
                get[get.Count] = value;
            }
        }
    }
    public class Get
    {
        public string rm;
        public string zz;
        public string mg;
        public string ho;
        public string fly;
        public int sound;
        public ArrayList  set = new ArrayList ();
        public ArrayList  del= new ArrayList ();
        public string fbeg;
        public string fend;
    }

    public class Clk
    {
        public string rm;
        public string zz;
        public string mg;
        public string zone;
        public string fbeg;
        public string fend;
    }
    public class Clks
    {
        private List<Clk> clk = new List<Clk>(1);
        public Clks()
        {
            clk.Add(new Clk());
        }
        public Clk this[int index]
        {
            get
            {
                return this.clk[index];
            }
            set
            {
                while (clk.Count <= index)
                    this.Add(new Clk());
                this.clk[index] = value;
            }
        }
        public int Count
        {
            get { return clk.Count; }
        }
        public void Add(Clk value)
        {
            clk.Add(value);
        }
        public void Remove(Clk value)
        {
            clk.Remove(value);
        }
        public Clk Last
        {
            get
            {
                return clk[clk.Count];
            }
            set
            {
                clk[clk.Count] = value;
            }
        }
    }
    public class Uses
    {
        private List<Use> use = new List<Use>(1);
        public Uses()
        {
            use.Add(new Use());
        }
        public Use this[int index]
        {
            get 
            { 
                return this.use[index];
            }
            set 
            {
                while (use.Count <= index)
                    this.Add(new Use());
                this.use[index] = value;
            }
        }
        public int Count
        {
            get { return use.Count; }
        }
        public void Add(Use value)
        {
            use.Add(value);
        }
        public void Remove(Use value)
        {
            use.Remove(value);
        }
        public Use Last
        {
            get
            {
                return use[use.Count];
            }
            set
            {
                use[use.Count] = value;
            }
        }
    }
    public class Use
    {
        public string rm;
        public string zz;
        public string mg;
        public string zone;
        public int sound;
        public ArrayList del = new ArrayList();
        public ArrayList  set= new ArrayList ();
        public ArrayList  seton= new ArrayList ();
        public ArrayList  setoff= new ArrayList ();
        public ArrayList  setvon= new ArrayList ();
        public string fbeg;
        public string fend;
    }
}

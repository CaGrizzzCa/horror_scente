using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

namespace logicCase
{
    public interface intMod
    {
        List<string> TrigNames { get; }             //возвращяет список имен тригеров
        List<string> TrigCode( string name );       //возвращяет код тригера
        List<string> TrigCreate(string trigName);   //создает пустой тригер, возвращяет его код ( в коде пустого тригера будет "--" )
        List<MyObjClass> AllObjs { get; }           //возвращяет все объекты модуля( включяя вложеные объекты ) кроме рута
        bool TrigRemove(string name);               //удаляет тригер с именем
    }

    public class ModuleClass : intMod
    {
        public void GetAllObjs(List<MyObjClass> ol)
        {
            for (int o = 0; o < objs.Count; o++)
            {
                objs[o].GetAllObjs(ol);
            }
        }
        public List<MyObjClass> GetAllObjs()
        {
            List<MyObjClass> ol = new List<MyObjClass>();
            GetAllObjs(ol);
            return ol;
        }

        public static Form1 FormRef;
        string moduleName;
        List<MyObjClass> objs = new List<MyObjClass>();
        List<MyTrigClass> trigs = new List<MyTrigClass>();
        List<MyObjClass> stack = new List<MyObjClass>();
        MyControl mainRoomControl;
        List<MyObjClass> zoomControl = new List<MyObjClass>();

        public ModuleClass(List<string> xml, List<string> lua)
        {
            MyObjClass.FormRef = FormRef;
            for (int i = 0; i < xml.Count; i++)
            {
                string s = xml[i];
                if (i == 0 & xml[i].IndexOf("<module name=\"") == -1)
                {
                    System.Windows.Forms.MessageBox.Show("ошибка при чтении XML");
                    break;
                }
                else
                {
                    if (getObjType(s) == "module")
                    {
                        moduleName = getObjValue(s, "name");
                        //FormRef.richTextBox1.AppendText(moduleName + "\n");
                    }
                    else if (s.IndexOf("<objs>")>-1)
                    {
                        continue;
                    }
                    else if (s.IndexOf("</objs>") > -1)
                    {
                        //System.Windows.Forms.MessageBox.Show("обьекты модуля загружены");
                        //FormRef.richTextBox1.AppendText("обьекты модуля загружены" + "\n");
                        break;
                    }
                    else
                    {
                        //objs.Add(new MyObjClass( xml[2] ) );
                        //stack.Add(objs[0]);
                        objLoader(xml, 2, lua);
                        //FormRef.richTextBox1.AppendText("обьекты модуля загружены ???" + "\n");
                        break;
                    }
                }
            }
            //FormRef.richTextBox1.AppendText("конец конструктора ???" + "\n");

        }

        void objAdd(string obj)
        {
            System.Windows.Forms.MessageBox.Show("заглушка");
        }
        void objAdd( MyObjClass obj )
        {
            //FormRef.richTextBox1.AppendText("обьекты добавлен " + obj.GetName()+ "\n");
            objs.Add(obj);
        }

        public List<MyObjClass> GetObjs()
        {
            return objs;
        }

        static public string getObjValue( string obj, string name )
        {
            string finder = " " + name + "=\"";
            int si = obj.IndexOf( finder );
            if (si > -1)
            {
                string value = obj.Substring(si + finder.Length);
                value = value.Substring(0, value.IndexOf("\""));
                return value;
            }
            else
            {
                //System.Windows.Forms.MessageBox.Show(obj+"\n"+name+"\nERROR");
                return "ERROR";
            }
        }
        static public string getObjType(string obj)
        {
            if (obj.IndexOf("<") > -1)
            {
                string type = obj.Substring(obj.IndexOf("<") + 1);
                if (type.IndexOf(" ") > -1)
                {
                    int end = type.IndexOf(" ");
                    type = type.Substring(0, end);
                    return type;
                }
                else
                {
                    return "END_OBJ";
                }
            }
            else
                return "ERROR_NO_TYPE";
        }

        string probels(int n)
        {
            string s="|";
            for (int i = 0; i < n; i++)
            {
                s += "--";
            }
            return s;
        }

        void trigsLoader(List<string> xml)
        {
            //FormRef.richTextBox1.AppendText("trigsLoader start " +id+ "\n");
            //string obj = xml[id];
            //if (obj.IndexOf("<trigs>") > -1)
            //{
            //    //Console.WriteLine("\n\nTRIGERS");
            //    //System.Windows.Forms.MessageBox.Show("загрузка тригеров " );
            //    trigsLoader(xml, id + 1);
            //}
            //else if (obj.IndexOf("<trig name=\"") > -1)
            //{
            //    trigs.Add(new MyTrigClass( xml, id ) );
            //    trigsLoader(xml, id + trigs[trigs.Count-1].GetCodeCount()+2);
            //}
            //else if (obj.IndexOf("</trigs>") > -1)
            //{
            //    //System.Windows.Forms.MessageBox.Show("тригеры модуля загружены "+trigs.Count);
            //}
            //FormRef.richTextBox1.AppendText("trigsLoader end " + id + "\n");


            trigs.Add(new MyTrigClass(xml,0));
            //if (mainRoomControl != null)
            //{
            //    //FormRef.Debag(mainRoomControl.GetDefResName());
            //}
        }

        void objLoader(List<string> xml, int id, List<string> lua)
        {
            string obj = xml[id];
            //Console.Write(probels( stack.Count ));
            //FormRef.richTextBox1.AppendText(id+"\n");
            if (obj.IndexOf("</objs>") > -1)
            {
                //System.Windows.Forms.MessageBox.Show("обьекты модуля загружены");
                //System.Windows.Forms.MessageBox.Show(objs.Count.ToString());
                //FormRef.richTextBox1.AppendText("обьекты модуля загружены " + id + "\n");
                //FormRef.richTextBox1.AppendText("objs.Count.ToString() " + objs.Count.ToString() + "\n");
                for (int j = 0; j < objs[0].GetObjsList().Count; j++)
                {
                    //System.Windows.Forms.MessageBox.Show(objs[j].GetMyType());
                    //FormRef.richTextBox1.AppendText(objs[0].GetObjsList()[j].GetMyType());
                    //if (objs[0].GetObjsList()[j].GetMyType() == "room")
                    string nm = objs[0].GetObjsList()[j].GetName();
                    //Console.WriteLine(nm);
                    if (nm.IndexOf("rm_") == 0 || nm.IndexOf("mg_") == 0 || nm.IndexOf("ho_") == 0)
                    {
                        //System.Windows.Forms.MessageBox.Show("нашли комнату "+objs[0].GetObjsList()[j].GetName());
                        //FormRef.richTextBox1.AppendText("нашли комнату " + objs[0].GetObjsList()[j].GetName() + "\n");
                        mainRoomControl = objs[0].GetObjsList()[j].GetMyControl();
                        //mainRoomControl = FormRef.GetControl(nm);
                        break;
                    }
                }
                for (int j = 0; j < objs[0].GetObjsList().Count; j++)
                {
                    //FormRef.richTextBox1.AppendText("objs[0].GetObjsList().Count " + j + "\n");
                    if (objs[0].GetObjsList()[j].GetName().IndexOf("zz_") == 0)
                    {
                        //System.Windows.Forms.MessageBox.Show("нашли zz " + objs[0].GetObjsList()[j].GetName());
                        //FormRef.richTextBox1.AppendText("нашли зз пытаемся атачить  objs[0].GetObjsList()[j].GetName()  " + objs[0].GetObjsList()[j].GetName() + "\n");
                        if (objs[0].GetObjsList()[j].GetMyControl() == null)
                        {
                            System.Windows.Forms.MessageBox.Show(objs[0].GetObjsList()[j].GetName() + " >> не найден контрол зумзоны!");
                        }
                        else
                        {
                            objs[0].GetObjsList()[j].GetMyControl().AttachTo(mainRoomControl);
                        }
                    }
                }
                trigsLoader(lua);
                //return 0;
            }

                /*
            else if( obj.IndexOf(" />")>-1)
            {
                objs.Add(new MyObjClass( xml[id] ) );
                objLoader(xml, id + 1);
            }*/
            else
            {
                int ncount = 1;
                //string nobj = obj;
                while (obj.IndexOf(">") == -1)
                {
                    obj += xml[id + ncount];
                    ncount++;
                    //FormRef.Debag(ncount + " " + nobj);
                }

                if (stack.Count == 0)
                {
                    if (obj.IndexOf("/>") > -1)
                    {
                        MyObjClass added_obj = new MyObjClass(xml, id, this);
                        objAdd(added_obj);
                        //objs.Add(added_obj);
                        //stack.Add(added_obj);
                        objLoader(xml, id + ncount, lua);
                    }
                    else if (obj.IndexOf("</") > -1)
                    {
                        objLoader(xml, id + ncount, lua);
                    }
                    else if (obj.IndexOf("\">") > -1)
                    {
                        MyObjClass added_obj = new MyObjClass(xml, id, this);
                        objAdd(added_obj);
                        //objs.Add(added_obj);
                        stack.Add(added_obj);
                        objLoader(xml, id + ncount, lua);
                    }
                }
                else
                {
                    if (obj.IndexOf("/>") > -1)
                    {
                        MyObjClass added_obj = new MyObjClass(xml, id, this);
                        stack[stack.Count - 1].objAdd(added_obj);
                        //objs.Add(added_obj);
                        //stack.Add(added_obj);
                        objLoader(xml, id + ncount, lua);
                    }
                    else if (obj.IndexOf("</") > -1)
                    {
                        //Console.WriteLine("");
                        stack.RemoveAt(stack.Count - 1);
                        objLoader(xml, id + ncount, lua);
                    }
                    else if (obj.IndexOf("\">") > -1)
                    {
                        MyObjClass added_obj = new MyObjClass(xml, id, this);
                        stack[stack.Count - 1].objAdd(added_obj);
                        stack.Add(added_obj);
                        objLoader(xml, id + ncount, lua);
                    }
                }
                //return 1;
            }
            //FormRef.richTextBox1.AppendText("ObjLoader end id " + id + "\n");
        }

        public List<MyObjClass> GetObjsList()
        {
            return objs;
        }
        public List<MyTrigClass> GetTrigsList()
        {
            return trigs;
        }
        public MyTrigClass GetTrig(string name)
        {
            //for (int i = 0; i < trigs.Count; i++)
            //{
            //    if (trigs[i].GetName() == name)
            //        return trigs[i];
            //}
            //return null;
            if (trigs.Count > 0)
                return trigs[0];
            return null;
        }

        public List<string> GetTrigCode(string trigName)
        {
            //for (int i = 0; i < trigs.Count; i++)
            //{
            //    if (trigs[i].GetName() == trigName )
            //        return trigs[i].GetCode();
            //}
            //System.Windows.Forms.MessageBox.Show("тригер не найден " + trigName);
            if (trigs.Count > 0)
                return trigs[0].GetCode();
            return new List<string>();
        }

        public MyControl GetMainRoomControl()
        {
            return mainRoomControl;
        }

        public string GetName()
        {
            return moduleName;
        }

        public void SaveObjs(StreamWriter f)
        {
            int stacks = 2;
            for (int i = 0; i < objs.Count; i++)
            {
                objs[i].Save(f, stacks);
            }
        }
        public void SaveTrigs(StreamWriter f)
        {
            int stacks = 2;
            for (int i = 0; i < trigs.Count; i++)
            {
                trigs[i].Save(f, stacks);
            }
        }
        public void AddTrig(MyTrigClass trg, bool alfabetic)
        {
            //trigs.Add(trg);
            for (int i = 1; i < trigs.Count; i++)
            {
                int cmp = trg.GetName().CompareTo(trigs[i].GetName());
                //FormRef.richTextBox1.AppendText(trg.GetName() + " " +trigs[i].GetName()+" "+ cmp+"\n");
                if (cmp == -1)
                {
                    if (alfabetic)
                    {
                        trigs.Insert(i, trg);
                        //FormRef.richTextBox1.AppendText("return\n");
                        return;
                    }
                }
                else if (cmp == 1)
                {
                    //FormRef.richTextBox1.AppendText("continue\n");
                    continue;
                    
                }
                else if (cmp == 0)
                {
                    System.Windows.Forms.MessageBox.Show("такой тригер уже существует!!! "+trigs[i].GetName());
                }
            }
            trigs.Add(trg);
            FormRef.richTextBox1.AppendText("add on last\n");
        }
        public void AddTrig(MyTrigClass trg)
        {
            AddTrig(trg, true);
        }


        public void SetNodForTree( System.Windows.Forms.TreeNode node )
        {
            for (int o = 0; o < objs.Count; o++)
            {
                System.Windows.Forms.TreeNode nod = new System.Windows.Forms.TreeNode(objs[o].GetName());
                node.Nodes.Add(nod);
                objs[o].SetNodForTree( nod );
            }
        }

        public void DeleteCheck()
        {
            for (int i = 0; i < objs.Count; i++)
            {
                if (objs[i].GetName() == "DELETE")
                {
                    objs.RemoveAt(i);
                    DeleteCheck();
                    return;
                }
                else
                {
                    objs[i].DeleteCheck();
                }
            }
            return;
        }

        //реализация интерфейса IndMod
        public List<string> TrigNames 
        {
            get
            {
                List<string> l = new List<string>();
                for (int i = 0; i < trigs.Count; i++)
                {
                    l.Add(trigs[i].GetName());
                }
                return l;
            }
        }
        public List<string> TrigCode( string name )
        {
                for (int i = 0; i < trigs.Count; i++)
                {
                    if (trigs[i].GetName() == name)
                        return trigs[i].GetCode();
                }
                return null;
        }
        public List<string> TrigCreate(string trigName)
        {
            MyTrigClass mt = new MyTrigClass(trigName);
            AddTrig(mt);
            List<string> tc = mt.GetCode();
            //tc.Clear();
            return tc;
        }
        public List<MyObjClass> AllObjs
        {
            get
            {
                List<MyObjClass> ao = new List<MyObjClass>();
                objs[0].GetAllObjs(ao);
                return ao;
            }
        }
        public bool TrigRemove( string name )
        {
            for(int t=0;t<trigs.Count;t++)
            {
                if (trigs[t].Name==name)
                {
                    trigs.RemoveAt(t);
                    return true;
                }
            }
            return false;
        }

        ~ModuleClass()
        {
            FormRef.modules.Remove(this);
        }

        public void Destroy()
        {

            for (int i = 0; i < zoomControl.Count; i++)
            {
                zoomControl[i].GetMyControl().Destroy();
            }
            
            FormRef.modules.Remove(this);
            mainRoomControl.Dispose();

        }
    }
}

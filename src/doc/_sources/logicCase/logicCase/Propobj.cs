using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace logicCase {
  public class Propobj {
    protected Form1 form = program.form;
    protected string objtype;
    protected Dictionary<string, string> properties = new Dictionary<string, string>();
    protected List<Propobj> childs = new List<Propobj>();

    public Propobj(string obj, string separator = "\"") {
      Init(obj, separator);
    }

    //public Propobj(List<string> objs, string separator = "\"")
    //{
    //    Propobj main = new Propobj(objs[0], separator);

    //    if(!objs[0].EndsWith("/>"))
    //    {
    //        objs.RemoveAt(0);

    //        while (objs.Count > 0 && !objs[0].TrimStart().StartsWith("<" + main.ObjType + " "))
    //            main.childs.Add(new Propobj(objs[0], separator));
    //    }
    //}

    private void Init(string obj, string separator = "\"") {

      string cls = obj.Substring(obj.IndexOf("<") + 1);
      if (cls.IndexOf(" ") < 0) {
        cls = cls.Substring(0, cls.IndexOf(">"));

        objtype = cls;
        //Console.WriteLine("Propobj 0 >> " + obj + " >> " + objtype);

        return;
      }
      else
        cls = cls.Substring(0, cls.IndexOf(" "));
      objtype = cls;

      //Console.WriteLine("Propobj 1 >> " + obj + " >> " + objtype);


      try {
        string cut = "<" + cls + " ";
        obj = obj.Substring(obj.IndexOf(cut) + cut.Length);
        while (obj.IndexOf(separator) > -1) {
          string name = obj.Substring(0, obj.IndexOf('='));
          //form.Debag(name);
          obj = obj.Substring(obj.IndexOf(separator) + separator.Length);
          string value = obj.Substring(0, obj.IndexOf(separator));
          //form.Debag(value);
          obj = obj.Substring(value.Length + separator.Length + 1);
          properties.Add(name, value.Replace("&quot;", "\""));
        }
      }
      catch {

        form.Debag("wrong propobj string " + obj, System.Drawing.Color.Red);
      }
    }

    public Propobj(List<string> objs, string separator = "\"") {
      Init(objs[0], separator);
      if (objs.Count > 0
          && !objs[0].TrimStart().EndsWith("/>")
         ) {
        objs.RemoveAt(0);



        while (objs.Count > 0 && !objs[0].TrimStart().StartsWith("</")) {
          childs.Add(new Propobj(objs, separator));
          //objs.RemoveAt(0);
        }

      }
      else {
        objs.RemoveAt(0);
      }
    }

    public string Propertie(string pole) {
      try {
        //if (save)
        //{
        //    return properties[pole];//.Replace("\\","/");
        //}
        //else
        //{
        string marker_beg = "<![CDATA[";
        string marker_end = "]]>";
        string s = properties[pole];

        if (s.StartsWith(marker_beg)) {
          s = s.Substring(marker_beg.Length);
          s = s.Substring(0, s.Length - marker_end.Length);
        }
        return s;
        //}
      }
      catch {
        return null;
      }
    }

    public void SetPropertie(string pole, string value) {
      try {
        properties[pole] = value;
      }
      catch {

      }
    }

    public string ObjType {
      get {
        return objtype;
      }
    }

    public virtual void Show() {
      Show(0);
    }

    public virtual void Show(int tabs) {
      string tabler = "\t";
      string tab = "";
      for (int i = 0; i<tabs; i++)
        tab+=tabler;
      string s = "\n" + tab + "--- " + objtype + " ---";
      foreach (KeyValuePair<string, string> kv in properties) {
        s += "\n" + tab + "\t" + kv.Key + "\t" + kv.Value;
      }
      form.Debag(s);
    }

    public virtual void ShowWithChilds(int tabs = 0) {
      string tabler = "\t";
      string tab = "";
      for (int i = 0; i < tabs; i++)
        tab += tabler;

      Console.WriteLine(tab + "\"" + objtype + "\"");


      string s = "\n" + tab + "--- " + objtype + " ---";
      foreach (KeyValuePair<string, string> kv in properties) {
        s += "\n" + tab + "\t" + kv.Key + "\t" + kv.Value;
      }

      form.Debag(s);

      for (int i = 0; i < Childs.Count; i++)
        Childs[i].ShowWithChilds( tabs+1);

    }

    public string FindPropertieFromString(string str, string item) {
      item = " " + item + "=\"";
      int f = str.IndexOf(item);
      if (f > -1) {
        str = str.Substring(f + item.Length);
        str = str.Substring(0, str.IndexOf("\""));
        form.Debag(str);
        return str;
      }
      else {
        return null;
      }
    }

    public List<Propobj> Childs {
      get {
        return childs;
      }
    }

    public Propobj GetChildOfType(string childType) {
      int count = Childs.Count;
      for (int i = 0; i < count; i++)
        if (Childs[i].ObjType == childType)
          return Childs[i];
      return null;
    }

    public Dictionary<string,string> GetProperties() {
      var answer = new Dictionary<string, string>();
      foreach (var kvp in properties)
        answer.Add(kvp.Key, kvp.Value);
      return answer;
    }
  }
}

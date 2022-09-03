using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Drawing;
using System.IO;

namespace logicCase {
  public interface intObj {
    Dictionary<string, intObj> GetZZ {
      get;  // возвращяет dictionary объектов зз, для объекта комнаты
    }
    MyObjClass Parent {
      get;  // возвращяет родительский объект
    }
    Dictionary<string, dynamic> Childs {
      get;  // возвращяет детей объекта
    }
    string Status {
      get;  // возвращяет принадлежность к игровому типу : "rm", "zz", "ho", "mg"
    }

  }

  public class MyObjClass:intObj {
    public static Dictionary<string, MyObjClass> CreatetObjs = new Dictionary<string, MyObjClass>();
    public static Form1 FormRef;
    string type;
    string name;
    public ModuleClass ownerModule;
    //MyControl ownerControl;
    public List<MyObjClass> objs = new List<MyObjClass>();
    Dictionary<string, string> properties = new Dictionary<string, string>();
    List<string> p_name = new List<string>();
    List<string> p_value = new List<string>();
    MyControl control;
    List<MyObjClass> stack = new List<MyObjClass>();
    bool isSubroomType = false;
    public bool IsSubroomType {
      get {
        return isSubroomType;
      }
    }
    //MyObjClass ownerObj;


    MyObjClass(string obj) {
      System.Windows.Forms.MessageBox.Show("Заглушка");
      this.type = ModuleClass.getObjType(obj);
      this.name = ModuleClass.getObjValue(obj, "name");
      propertiesParsing(obj);
    }
    public MyObjClass(List<string> xml, int id, ModuleClass ownerModule ) {
      this.ownerModule = ownerModule;
      MyControl.FormRef = FormRef;
      string obj = xml[id];
      int ncount = 1;
      while (obj.IndexOf(">") == -1) {
        if(xml[id + ncount].Trim().Length>0)
          obj += "\r\n"+xml[id + ncount];
        ncount++;
      }
      this.type = ModuleClass.getObjType(obj);
      this.name = ModuleClass.getObjValue(obj, "_name");
      //if (obj.IndexOf( "_boneshipho_")>-1)
      //{
      //    FormRef.Debag("*"+obj);
      //}
      //Console.WriteLine( "MyObjClass " + obj + "\n\t" + type + " " +name );
      propertiesParsing(obj);
      //if (ownerModule == null)
      //    return;
      if (name.EndsWith("_clone")) {
        FormRef.Debag("WARNING: clone obj " + name, Color.Red);
      }
      else {
        if (name.IndexOf("rm_") == 0 || name.IndexOf("mg_") == 0 || name.IndexOf("ho_") == 0) {
          createRoom();
        }
        if (name.IndexOf("zz_") == 0) {
          createZoom();
        }
        //if (ModuleClass.getObjValue(obj, "__type") == "spr_gm" & this.name.StartsWith("inv_complex_"))
        if (this.name.StartsWith("inv_complex_")) {
          createZoom();
        }
      }
      CreatetObjs[name] = this;
    }

    public void SetMyObjClassName(string name) {
      this.name = name;
    }

    public string GetName() {
      return name;
    }
    public string GetMyType() {
      return type;
    }

    public string GetTypeProperty() {
      return GetPropertie("__type");
    }

    public void objAdd(MyObjClass obj) {
      if(obj.Parent!=null) {
        obj.Parent.objs.Remove(obj);
      }
      objs.Add(obj);
    }

    public List<MyObjClass> GetObjsList() {
      return objs;
    }

    void propertiesParsing( string obj) {
      if (obj.IndexOf("<") > -1) {
        obj = obj.Substring(obj.IndexOf("<"));
      }
      if (obj.IndexOf(" ") == -1) {
        //System.Windows.Forms.MessageBox.Show(obj+" exit");
        return;
      }
      obj = obj.Substring(obj.IndexOf(" ") + 1);
      if (obj.Length < 3 || obj.IndexOf("/>") == 0) {
        return;
      }
      string buf = obj.Substring(obj.IndexOf("=") + 1);
      string devider = "\"";
      if (buf.IndexOf("'") == 0)
        devider = "'";
      p_name.Add( obj.Substring( 0, obj.IndexOf("=") ) );
      obj = obj.Substring( obj.IndexOf( devider ) +1 );
      p_value.Add(obj.Substring(0, obj.IndexOf(devider)));
      properties.Add(p_name[p_name.Count - 1], p_value[p_value.Count - 1]);
      //System.Windows.Forms.MessageBox.Show(obj);
      obj = obj.Substring(p_value[p_value.Count - 1].Length);
      propertiesParsing(obj);

    }

    public Dictionary<string, string> GetProperties() {
      return properties;
    }

    public string GetPropertie(string name) {
      for (int i = 0; i < p_name.Count; i++) {
        if (p_name[i] == name) {
          return p_value[i];
        }
      }
      return "";
    }
    public bool SetPropertie(string propertie, string value) {
      int finded_n = -1;
      for (int i = 0; i < p_name.Count; i++) {
        if(p_name[i]==propertie) {
          finded_n = i;
          break;
        }
      }
      if (finded_n>-1) {
        properties[propertie] = value;
        p_value[finded_n] = value;
        return true;
      }
      else {
        properties[propertie] = value;
        p_value.Add(value);
        p_name.Add(propertie);
        //FormRef.Debag(name+"***" + propertie + "***" + value + "***" + p_name[p_name.Count - 1] + "***" + p_value[p_value.Count - 1]+"***");
      }
      return false;
    }

    void createRoom() {
      control = new MyControl( properties["__type"], name, this);
      //control.BackColor = Color.SlateGray;
      FormRef.Controls.Add(control);
      control.Parent = FormRef;
      control.Show();
      control.ToFront();
      //control.Location = new Point(200, 200);
      FormRef.RoomsAdd(control);
    }
    void createZoom() {
      control = new MyControl(properties["__type"], name, this);
      FormRef.Controls.Add(control);
      control.Parent = FormRef;
      control.Show();
      control.ToFront();
      //control.Location = new Point(200, 200);
      FormRef.ZoomsAdd(control);
      isSubroomType = true;
    }

    public MyControl GetMyControl() {
      return control;
    }

    public ModuleClass GetModule() {
      return ownerModule;
    }

    string TextStack( string s, int stacks ) {
      string buf="";
      for (int i = 0; i < stacks; i++) {
        buf+=s;
      }
      return buf;
    }
    public void Save(StreamWriter f, int stacks) {
      foreach( var v in _reatachBeforeSave) {
        Console.WriteLine("_reatachBeforeSave >> " + v.name);
        v.ReAtach();
      }
      _reatachBeforeSave.Clear();
      //for (int i = 0; i < objs.Count; i++)
      //{
      //    try
      //    {
      //        Convert.ToInt32(objs[i].GetPropertie("pos_z"));
      //    }
      //    catch
      //    {
      //        System.Windows.Forms.MessageBox.Show(objs[i].GetPropertie("pos_z"));
      //    }
      //}

      f.Write( TextStack( "    ", stacks ) );
      f.Write("<" + type + GetPropertiesString());
      if (objs.Count == 0) {
        f.WriteLine("/>");
        return;
      }
      else {

        //objs = objs.OrderBy(z => Convert.ToDouble(z.GetPropertie("pos_z"))).ToList();
        //objs.Sort(delegate(MyObjClass o1, MyObjClass o2)
        //{
        //    double v1 = Convert.ToDouble(o1.GetPropertie("pos_z"));
        //    double v2 = Convert.ToDouble(o2.GetPropertie("pos_z"));
        //    if (v1 == v2) return 0;
        //    else if (v2 > v1) return -1;
        //    else if (v1 > v2) return 1;
        //    else return v2.CompareTo(v1);

        //});
        f.WriteLine(">");
        for (int i = 0; i < objs.Count; i++) {
          objs[i].Save(f, stacks + 1);

        }
        f.WriteLine(TextStack( "    ", stacks )+"</" + type + ">");
      }
    }

    string GetPropertiesString() {
      string buf = "";
      for (int i = 0; i < p_name.Count; i++) {
        //if (p_value[i].IndexOf("&quot;") > -1)
        //{
        //    buf += " " + p_name[i] + "='" + p_value[i] + "'";
        //}
        //else
        //{
        if(p_name[i]=="res") {
          p_value[i] = p_value[i].Replace("\\","/");
        }
        buf += " " + p_name[i] + "=\"" + p_value[i] + "\"";
        //}
      }
      //if (buf.IndexOf("#x0D;")>-1)
      //    FormRef.Debag("*\n" + buf + "\n" + buf.Replace("#x0D;", "#x0D;\r\n")+"\n*");
      return buf.Replace("#x0D;", "#x0D;\r\n");
    }

    public List<string> GetPropNames() {
      return p_name;
    }
    public List<string> GetPropValues() {
      return p_value;
    }

    public void objAddAt(MyObjClass obj, int index) {
      objs.Insert(index, obj);
      //objs.Add(obj);
    }
    public MyObjClass ObjsLoader(List<string> xml, int id) {
      //FormRef.Debag("ObjsLoader >>");
      //FormRef.Debag(xml);
      //FormRef.Debag("<< ObjsLoader");
      MyObjClass added_obj = null;
      if (id > xml.Count-1) return null;

      string obj = xml[id];
      {
        if (stack.Count == 0) {
          if (obj.IndexOf("/>") > -1) {
            added_obj = new MyObjClass(xml, id, ownerModule);
            objAddAt(added_obj,0);
            ObjsLoader(xml, id + 1);
          }
          else if (obj.IndexOf("</") > -1) {
            ObjsLoader(xml, id + 1);
          }
          else if (obj.IndexOf(">") > -1) {
            added_obj = new MyObjClass(xml, id, ownerModule);
            objAddAt(added_obj,0);
            //objs.Add(added_obj);
            stack.Add(added_obj);
            ObjsLoader(xml, id + 1);
          }
        }
        else {
          if (obj.IndexOf("/>") > -1) {
            added_obj = new MyObjClass(xml, id, ownerModule);
            stack[stack.Count - 1].objAdd(added_obj);
            //objs.Add(added_obj);
            //stack.Add(added_obj);
            ObjsLoader(xml, id + 1);
          }
          else if (obj.IndexOf("</") > -1) {
            stack.RemoveAt(stack.Count - 1);
            ObjsLoader(xml, id + 1);
          }
          else if (obj.IndexOf("\">") > -1) {
            added_obj = new MyObjClass(xml, id, ownerModule);
            stack[stack.Count - 1].objAdd(added_obj);
            stack.Add(added_obj);
            ObjsLoader(xml, id + 1);
          }
        }
        ownerModule.AllObjs.Add(added_obj);
        return added_obj;
      }
    }

    public string getNamePost() {
      if (GetName().StartsWith("inv"))
        return GetName().Substring(GetName().LastIndexOf("_") + 1);
      else
        return GetName().Substring(GetName().IndexOf("_") + 1);
    }

    public string getNamePrefix() {
      var index = GetName().IndexOf("_");
      if(index<0) {
        return GetName();
      }
      return GetName().Substring(0,GetName().IndexOf("_"));
    }

    public void AddTexObjText( string text, int dy = 0 ) {
      List<string> obj = FormRef.LoadXML("res\\txt\\TextObjText.xml");
      FormRef.xmlReplace(obj,"##name##","txt_"+getNamePost());
      FormRef.xmlReplace(obj,"##text##",text);
      MyObjClass txt = ObjsLoader(obj,0);
      txt.SetPropertie("pos_y", dy.ToString());
    }

    public int GetZzCount() {
      int count = 0;
      for (int i = 0; i < objs.Count; i++) {
        FormRef.richTextBox1.AppendText(objs[i].GetMyType() + "\n");
        if (objs[i].getNamePrefix() == "zz")
          count++;
      }
      return count;
    }

    public void GetAllObjs(List<MyObjClass> allObjs) {
      for (int i = 0; i < objs.Count; i++) {
        allObjs.Add(objs[i]);
        objs[i].GetAllObjs(allObjs);
      }
    }

    public void SetNodForTree( System.Windows.Forms.TreeNode node ) {
      for (int o = 0; o < objs.Count; o++) {
        System.Windows.Forms.TreeNode nod = new System.Windows.Forms.TreeNode(objs[o].GetName());

        if (objs[o].GetName().StartsWith("rm_"))
          nod.BackColor = Color.SlateGray;
        else if (objs[o].GetName().StartsWith("ho_"))
          nod.BackColor = Color.LightCoral;
        else if (objs[o].GetName().StartsWith("mg_"))
          nod.BackColor = Color.Orange;
        else if (objs[o].GetName().StartsWith("zz_"))
          nod.BackColor = Color.Gainsboro;
        node.Nodes.Add(nod);
        objs[o].SetNodForTree(nod);
      }
    }


    //Реализация интерфейса
    MyObjClass ParenStep(MyObjClass o, string s) {
      MyObjClass mo = null;
      for (int i = 0; i < o.objs.Count; i++) {
        if (o.objs[i].name == s) {
          return o;
        }
        else {
          mo = ParenStep(o.objs[i], s);
          if (mo != null) {
            return mo;
          }
        }
      }
      return mo;
    }
    public MyObjClass Parent {
      get {
        return ParenStep(ownerModule.GetObjsList()[0], this.name);
      }
    }
    public Dictionary<string, dynamic> Childs {
      get {
        Dictionary<string, dynamic> d = new Dictionary<string, dynamic>();
        for (int i = 0; i < objs.Count; i++) {
          d.Add(objs[i].name, objs[i]);
        }
        return d;
      }
    }
    public string Status {
      get {
        MyControl mc = ownerModule.GetMainRoomControl();
        List<MyObjClass> ol = mc.GetAllObjs();
        for (int i = 0; i < ol.Count; i++) {
          if (ol[i].name == this.name) {
            //ROOM
            if (mc.GetName().IndexOf("rm_") == 0) {
              return "rm";
            }
            if (mc.GetName().IndexOf("ho_") == 0) {
              return "ho";
            }
            if (mc.GetName().IndexOf("mg_") == 0) {
              return "mg";
            }
            return "warning";
          }
        }
        List<MyControl> cl = mc.GetChilds();
        for (int i = 0; i < cl.Count; i++) {
          ol = cl[i].GetAllObjs();
          for (int j = 0; j < ol.Count; j++) {
            if (ol[j].name == this.name) {
              //zoom
              return "zz";
            }
          }
        }
        return "other";
      }
    }
    public Dictionary<string, intObj> GetZZ {
      get {
        Dictionary<string, intObj> zzl = new Dictionary<string, intObj>();
        if (type == "room") {

          MyControl mc = ownerModule.GetMainRoomControl();
          List<MyObjClass> ol = ownerModule.GetObjsList()[0].GetObjsList();
          for (int i = 0; i < ol.Count; i++) {
            if (ol[i].type == "subroom") {
              zzl.Add(ol[i].name, ol[i]);
            }
          }


        }
        return zzl;
      }
    }

    public void Delete() {
      this.name = "DELETE";
      ownerModule.DeleteCheck();
    }

    public void DeleteCheck() {
      for (int i = 0; i < objs.Count; i++) {
        if (objs[i].GetName() == "DELETE") {
          objs.RemoveAt(i);
          DeleteCheck();
          return;
        }
        else {
          objs[i].DeleteCheck();
        }
      }
      return;
    }

    public MyControl GetOwnerControl() {
      MyControl mc = control;

      if (control == null && Parent != null)
        mc = Parent.GetOwnerControl();
      else
        mc = control;

      return mc;
    }

    public void ReAtach() {
      MyObjClass o;
      List<MyObjClass> objs = Parent.objs;
      for (int i = 0; i < objs.Count; i++) {
        if (objs[i].GetName() == name) {
          //FormRef.Debag(i+"\t"+ name);
          o = objs[i];
          objs.Remove(o);
          objs.Add(o);
        }
      }
    }

    private List<MyObjClass> _reatachBeforeSave = new List<MyObjClass>();

    public void ReAtachBeforeSave() {
      if(Parent!=null) {
        Parent._reatachBeforeSave.Add(this);
        //Console.WriteLine("ReAtachBeforeSave >> ADDED >> " + name);
      }
      else {
        //Console.WriteLine("ReAtachBeforeSave >> Not Founded Owner >> " + name);

      }
    }

    public bool IsTagged() {
      return IsTagged(false);
    }

    public bool IsTagged(bool recursivly) {
      MyObjClass moc;
      return IsTagged(recursivly,out moc);
    }

    private bool IsTagged(bool recursivly, out MyObjClass moc) {
      string tag = GetPropertie("anim_tag");
      if (tag.Length > 0) {
        moc = this;
        return true;
      }
      if (recursivly && Parent!= null) {
        return Parent.IsTagged(true,out moc);
      }
      moc = null;
      return false;
    }

    public bool IsTaggedParent() {
      if(Parent==null) {
        return false;
      }
      return Parent.IsTagged();
    }

    public bool IsTaggedParent(bool recursivly) {
      if (Parent == null) {
        return false;
      }
      return Parent.IsTagged(recursivly);
    }

    /// <summary>
    /// определяет, находится ли объект под влиянием тага в анимации
    /// </summary>
    /// <returns></returns>
    public bool IsTaggedByAnim() {
      string anim_tag;
      return IsTaggedByAnim(out anim_tag);
    }

    /// <summary>
    /// определяет, находится ли объект под влиянием тага в анимации
    /// </summary>
    /// <param name="anim_tag">anim_tag влияющий на объект</param>
    /// <returns></returns>
    public bool IsTaggedByAnim(out string anim_tag) {
      MyObjClass moc;
      if (IsTagged(true, out moc)) {
        if (moc != null && moc.Parent != null && moc.Parent.GetTypeProperty() == "anim") {
          anim_tag = moc.GetPropertie("anim_tag");
          return true;
        }
      }
      anim_tag = "";
      return false;
    }
  }
}

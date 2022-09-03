using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.IO;
using System.Text.RegularExpressions;
using System.Runtime.CompilerServices;
using System.Diagnostics;

using System.Runtime.InteropServices;

using System.Xml;
using System.Drawing.Imaging;

namespace logicCase {
  // ModuleClass GetModule(string name)                       возвращяет модуль по имени
  // List<ModuleClass> GetModules()                           возвращяет модули комнат
  // List<MyObjClass> GetRooms()                              возвращяет объекты всех RM
  // List<MyObjClass> GetHos()                                возвращяет объекты всех HO
  // List<MyObjClass> GetMgs()                                возвращяет объекты всех MG
  // List<MyObjClass> GetZooms()                              возвращяет объекты всех ZZ
  // MyControl GetControl( string rm_name )                   возвращяет Control "rm_name", "mg_name", "ho_name", "zz_name",
  // MyObjClass GetObj( string obj_name )                     возвращяет объект по имени
  // public List<MyControl> GetCreatedControls()              возврвщяет список всех созданых крнтролов, включая не связанных


  public partial class Form1 : Form {
    private string exeVersion = "1.0.0";

    NotEditorProject _notEditorProject;

    public MyObjClass GetObj(string obj_name) {
      for (int i = 0; i < modules.Count; i++) {
        List<MyObjClass> ao = new List<MyObjClass>();
        modules[i].GetObjs()[0].GetAllObjs(ao);
        for (int j = 0; j < ao.Count; j++) {
          if (ao[j].GetName() == obj_name) {
            return ao[j];
          }
        }
      }
      return null;
    }
    public List<MyObjClass> GetObj(Regex regex) {
      List<MyObjClass> objs = new List<MyObjClass>();
      for (int i = 0; i < modules.Count; i++) {
        List<MyObjClass> ao = new List<MyObjClass>();
        modules[i].GetObjs()[0].GetAllObjs(ao);
        for (int j = 0; j < ao.Count; j++) {
          if (regex.IsMatch(ao[j].GetName())) {
            objs.Add(ao[j]);
          }
        }
      }
      return objs;
    }
    public MyObjClass GetInvObj(string inv_name) {
      List<MyObjClass> ao = new List<MyObjClass>();

      try {
        InvMod.GetObjs()[0].GetAllObjs(ao);
        for (int j = 0; j < ao.Count; j++) {
          if (ao[j].GetName() == inv_name) {
            return ao[j];
          }
        }
      }
      catch {
        return null;
      }
      return null;
    }
    public List<MyObjClass> GetInvObj(Regex regex) {
      List<MyObjClass> objs = new List<MyObjClass>();
      List<MyObjClass> ao = new List<MyObjClass>();
      InvMod.GetObjs()[0].GetAllObjs(ao);
      for (int j = 0; j < ao.Count; j++) {
        if (regex.IsMatch(ao[j].GetName())) {
          objs.Add(ao[j]);
        }
      }
      return objs;
    }
    public ModuleClass GetModule(string name) {
      for (int i = 0; i < modules.Count; i++) {
        if (modules[i].GetName() == name) {
          return modules[i];
        }
      }
      return null;
    }
    public List<ModuleClass> GetModules() {
      return modules;
    }
    public List<MyObjClass> GetRooms() {
      List<MyObjClass> l = new List<MyObjClass>();
      List<MyControl> acl = GetCreatedControls(); //modules[0].GetMainRoomControl().GetAllChilds();
      //l.Add(modules[0].GetMainRoomControl().GetOwnerObj());
      for (int i = 0; i < acl.Count; i++) {
        if (acl[i].GetOwnerObj().GetName().IndexOf("rm_") == 0)
          l.Add(acl[i].GetOwnerObj());
      }
      return l;
    }
    public List<MyObjClass> GetHos() {
      List<MyObjClass> l = new List<MyObjClass>();
      List<MyControl> acl = GetCreatedControls(); //modules[0].GetMainRoomControl().GetAllChilds();
      for (int i = 0; i < acl.Count; i++) {
        if (acl[i].GetOwnerObj().GetName().IndexOf("ho_") == 0)
          l.Add(acl[i].GetOwnerObj());
      }
      return l;
    }
    public List<MyObjClass> GetMgs(
      [CallerMemberName] string memberName = "",
      [CallerFilePath] string sourceFilePath = "",
      [CallerLineNumber] int sourceLineNumber = 0) {
      //Debag("--- GetMgs BEG ---");
      //Debag("GetMgs\n\t" + memberName + "\n\t" + sourceFilePath + "\n\t" + sourceLineNumber);
      List<MyObjClass> l = new List<MyObjClass>();
      List<MyControl> acl = GetCreatedControls(); //modules[0].GetMainRoomControl().GetAllChilds();
      //MessageBox.Show("GetMgs\n\t" + memberName + "\n\t" + sourceFilePath + "\n\t" + sourceLineNumber);

      for (int i = 0; i < acl.Count; i++) {
        //Debag(acl[i].GetName());
        if (acl[i].GetName().IndexOf("mg_") == 0)
          l.Add(acl[i].GetOwnerObj());
      }
      //Debag("--- GetMgs END ---");
      return l;
    }
    public List<MyObjClass> GetZooms() {
      List<MyObjClass> l = new List<MyObjClass>();
      List<MyControl> acl = GetCreatedControls();//modules[0].GetMainRoomControl().GetAllChilds();
      for (int i = 0; i < acl.Count; i++) {
        if (acl[i].GetName().IndexOf("zz_") == 0)
          l.Add(acl[i].GetOwnerObj());
      }
      return l;
    }
    public List<MyObjClass> GetComplex() {
      List<MyObjClass> l = new List<MyObjClass>();
      List<MyControl> acl = GetCreatedControls();//modules[0].GetMainRoomControl().GetAllChilds();
      for (int i = 0; i < acl.Count; i++) {
        if (acl[i].GetName().IndexOf("inv_") == 0)
          l.Add(acl[i].GetOwnerObj());
      }
      return l;
    }
    public List<MyControl> GetCreatedControls() {
      return allControls;
    }
    public List<MyObjClass> GetAllObjs() {                  //возвращяет все объекты проекта
      List<MyObjClass> ol = new List<MyObjClass>();
      for (int m = 0; m < modules.Count; m++) {
        List<MyObjClass> mol = modules[m].AllObjs;
        for (int o = 0; o < mol.Count; o++)
          ol.Add(mol[o]);
        //modules[m].GetAllObjs(ol);
      }
      return ol;
    }

    public Propobj LogicCaseSettings {
      get;
      private set;
    }

    /// <summary>
    /// адрес от exe проекта
    /// </summary>
    public string projectDir;
    /// <summary>
    /// полный адрес уровня
    /// </summary>
    string levelDir;
    /// <summary>
    /// адрес стартовой комнаты
    /// </summary>
    string levelStartRoomDir;
    /// <summary>
    /// имя стартовой комнаты rm_XXX
    /// </summary>
    string levelStartRoom;
    /// <summary>
    /// адрес "репозитария"
    /// </summary>
    public string repDir {
      get;
      set;
    }
    public string exeDir => repDir + "exe\\";

    Point DownPoint;
    bool IsDragMode = false;
    List<string> levelXML = new List<string>();
    ModuleClass levelMod;
    public ModuleClass InvMod;
    string levelName;
    public List<ModuleClass> modules = new List<ModuleClass>();
    List<MyControl> rooms = new List<MyControl>();
    List<MyControl> zooms = new List<MyControl>();
    MyControl main_control;
    public List<MyControl> allControls = new List<MyControl>();
    List<string> room_names = new List<string>();
    public List<string> progress_names = new List<string>();
    List<string> levelInit;
    List<string> roomsM;
    public MyObjClass inventoryObj;
    List<LineClass> drawLinesList = new List<LineClass>();
    public FileStackClass FSaver = new FileStackClass();
    Dictionary<string, Propobj> loadedConfig = new Dictionary<string, Propobj>();
    public Dictionary<string, Propobj> loadedIgnore = new Dictionary<string, Propobj>();
    public Dictionary<string, bool> loadedIgnoreBool = new Dictionary<string, bool>();
    //List<string> loadedConfig = new List<string>();
    //FormProgress ProgressForm;
    //GameFactory gf;
    Scheme scheme;
    GameHint gameHint;

    //public GameFactory GetFactory()
    //{
    //    return gf;
    //}

    public Dictionary<string, bool> ARG_CMD = new Dictionary<string, bool>();
    public Dictionary<string, string> ARG_STR = new Dictionary<string, string>();
    public string[] ARG;

    private string resenderDir = "none";
    private string resenderArgs = "none";

    public Form1(string[] arg) {

      InitializeComponent();
      ModuleClass.FormRef = this;
      MyControl.FormRef = this;

      if (arg.Length > 0) {

        resenderArgs = "\n";
        for (int i = 0; i < arg.Length; i++) {
          if (arg[i].StartsWith("##RESENDER##")) {
            resenderDir = arg[i].Replace("##RESENDER##","");
          }
          resenderArgs += i + " >> " + arg[i] + "\n";
        }
        //MessageBox.Show(resenderArgs);
      }

      ARG = arg;
      ARG_CMD["creation_only"] = false;

      ARG_STR["creation_only_inside_folder"] = "";

      if (ARG.Length > 0) {
        if (ARG[0].StartsWith("##CHANGE_DIR##")) {
          //MessageBox.Show("!!!!!!!!!!!!!!!!!!!!");

          this.Show();
          this.WindowState = FormWindowState.Maximized;

          ARG_CMD["creation_only"] = false;
          //MessageBox.Show(ARG[0].Replace("##CHANGE_DIR##", ""));
          string dirbuf = ARG[0].Replace("##CHANGE_DIR##", "");
          ARG = new string[0];
          LoadLevel(dirbuf);

        }
        else {
          try {
            //List<string> xml = LoadXML(arg[0]);
            //if (FindId(xml, "<module name=\"") > -1)
            //{

            ARG_CMD["creation_only"] = true;
            //}
          }
          catch {
            ARG_CMD["creation_only"] = false;
          }
        }
      }
      else {
        ARG_CMD["creation_only"] = false;
      }

      if (ARG_CMD["creation_only"]) {
        this.Hide();
        this.MaximizedBounds = new Rectangle(0, 0, 0, 0);
      }


    }
    public string LevelName { private set { } get {
        return this.levelName;
      }
    }
    public string LevelDir { private set { } get {
        return this.levelDir;
      }
    }
    public List<ModuleClass> Modules { private set { } get {
        return this.modules;
      }
    }

    public void EXIT() {
      this.Close();
      Application.Exit();
      Application.ExitThread();
      Environment.Exit(0);
    }

    private void Form1_Load(object sender, EventArgs e) {
      IncreaseFileVersionBuild();

      LoadConfig(true);

      try {
        LogicCaseSettings = new Propobj(LoadXML("settings.xml"));
      }
      catch {
        LogicCaseSettings = new Propobj("<LogicCaseSettings/>");
        MessageBox.Show("Не удалось загрузить settings.xml");
      }

      //LogicCaseSettings.ShowWithChilds();


      ARG_STR["creation_only_inside_folder"] = "";

      if (ARG_CMD["creation_only"]) {
        WindowState = FormWindowState.Minimized;

        this.Hide();
        string path = ARG[0].Substring(0, ARG[0].LastIndexOf("\\"));
        string file_adr = ARG[0];
        string game_path = "xxx";
        try {
          game_path = Application.ExecutablePath.Remove(Application.ExecutablePath.LastIndexOf(
                        @"src\doc\LogicCase\logicCase.exe"));
        }
        catch {
          //break;
        }

        //MessageBox.Show(game_path);
        //MessageBox.Show(path);

        if (!path.StartsWith(game_path)) {
          try {
            string new_exe_path = ARG[0].Remove(ARG[0].LastIndexOf(@"exe\assets\"));

            //MessageBox.Show(game_path);
            //MessageBox.Show(new_exe_path + @"src\doc\LogicCase\LogicCase.exe");

            System.Diagnostics.Process.Start(new_exe_path + @"src\doc\LogicCase\logicCase.exe", ARG[0]);
            EXIT();
            return;
          }
          catch {
            //MessageBox.Show("при попытке запустить LogicCase из дириктории проэкта возникла ошибка");
          }
        }

        if (file_adr.EndsWith(".xml")) {
          //MessageBox.Show(game_path  + file_adr);
          try {
            List<string> xml = LoadXML(file_adr);
            if (xml[0].StartsWith("<animation")) {
              //MessageBox.Show(game_path + @"src\doc\AnimationToNEA3\AnimationToNEA3.exe" + "\n" + file_adr);

              try {
                //MessageBox.Show("OK");
                System.Diagnostics.Process.Start(game_path + @"src\doc\AnimationToNEA3\AnimationToNEA3.exe", file_adr); // открытие анимации xml через logiccase
                EXIT();
                return;
              }
              catch {
                //MessageBox.Show("CATCH");
                System.Diagnostics.Process.Start("Notepad++.exe", file_adr);
                EXIT();
                return;
              }
            }
            else if (xml[0].StartsWith("<strings>") || xml[1].StartsWith("<strings>")) {
              //MessageBox.Show(game_path + @"tool\textEditor\StringEditor.exe" + "\n" + file_adr);

              try {
                //MessageBox.Show("OK");
                System.Diagnostics.Process.Start(game_path + @"tool\textEditor\StringEditor.exe", file_adr);
                EXIT();
                return;
              }
              catch {
                //MessageBox.Show("CATCH");
                System.Diagnostics.Process.Start("Notepad++.exe", file_adr);
                EXIT();
                return;
              }
            }
            else if (xml[0].StartsWith("<module")) {
              ARG_CMD["creation_only"] = false;
              this.Show();
              WindowState = FormWindowState.Maximized;
              return;
            }
            else {
              try {
                System.Diagnostics.Process.Start("Notepad++.exe", file_adr);
              }
              catch {
                MessageBox.Show("не удалось обработать xml");
              }
              EXIT();
              return;
            }

          }
          catch {
            try {
              System.Diagnostics.Process.Start("Notepad++.exe", file_adr);
            }
            catch {
              MessageBox.Show("не удалось обработать xml");
            }
            EXIT();
            return;
          }
        }



        if (file_adr.EndsWith(".png")) {
          if (!path.StartsWith(game_path) || !path.StartsWith(game_path + @"exe\assets\levels\level")) { // если нужна добавлялка не только в level, но и в интерфейсных папках или меню
            System.Diagnostics.Process.Start(
              Environment.GetEnvironmentVariable("windir") + @"\System32\rundll32.exe",
              Environment.GetEnvironmentVariable("windir") + @"\System32\shimgvw.dll,ImageView_Fullscreen " + file_adr);
            //MessageBox.Show(s);
            //System.Diagnostics.Process.Start(game_path + @"src\doc\LogicCase\NexusImage.exe", file_adr);
            EXIT();
            return;
          }
        }


        string name = path.Substring(path.LastIndexOf("\\") + 1);
        if(!name.StartsWith("rm") && !name.StartsWith("zz") && !name.StartsWith("ho") && !name.StartsWith("inv")
            && !name.StartsWith("mg")) {
          ARG_STR["creation_only_inside_folder"] = "\\" + name;
          //MessageBox.Show(path);
          path = path.Replace("\\" + name, "");
          name = path.Substring(path.LastIndexOf("\\") + 1);
          //MessageBox.Show("обработка чпрайта вне контрола \n"+ name + "\n" + ARG_STR["creation_only_inside_folder"]);
          //Close();
        }
        if (name.StartsWith("inv_")) {

          path = path.Substring(0, path.LastIndexOf("\\"));
          path = path.Substring(0, path.LastIndexOf("\\"));

          string[] dirs = Directory.GetDirectories(path, "rm_*");
          //MessageBox.Show(dirs[0]);
          path = dirs[0];

          if (name.StartsWith("rm_"))
            ARG_STR["creation_only_rm_name"] = name;
          else
            ARG_STR["creation_only_rm_name"] = path.Substring(path.LastIndexOf("\\") + 1);
        }
        else {
          if (name.StartsWith("zz_")) {
            path = path.Substring(0, path.LastIndexOf("\\"));
          }

          if (name.StartsWith("rm_"))
            ARG_STR["creation_only_rm_name"] = name;
          else
            ARG_STR["creation_only_rm_name"] = path.Substring(path.LastIndexOf("\\") + 1);
        }

        //MessageBox.Show(arg[0] + "\n" + path + "\n" + name);

        ARG_STR["creation_only_control_name"] = name;
        this.WindowState = FormWindowState.Minimized;



        this.TopMost = true;
        //MessageBox.Show(path);
        LoadLevel(path);
        if (GetControl(name) == null) {
          CheckProjectResources(GetControl("level_inv"));

        }
        else {
          CheckProjectResources(GetControl(name));
        }
        this.Hide();
      }
      else {
        WindowState = FormWindowState.Maximized;
      }

    }

    public List<string> LoadXML(string path) {

      List<string> xml = new List<string>();
      try {
        File.ReadAllLines(Application.StartupPath.ToString() + "\\" + path,
        Encoding.GetEncoding(Encoding.UTF8.CodePage)).ToList().ForEach(s => {
          xml.Add(s);
        });

        int removed = 0;

        if (xml[0] == "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
            && xml[1] == ""
            && xml[2] == "<strings>") {
          for (int i = 0; i < xml.Count; i++) {
            if (i % 2 == 0 && xml[i] == "") {
              xml[i] = "##REMOVE!!!##";
            }
          }
          for (int i = 0; i < xml.Count; i++) {
            if (xml[i] == "##REMOVE!!!##") {
              xml.RemoveAt(i);
              i--;
              removed++;
            }
          }
          MessageBox.Show("removed " + removed);
        }

        return xml;
      }
      catch {

        try {
          File.ReadAllLines(path, Encoding.GetEncoding(Encoding.UTF8.CodePage)).ToList().ForEach(s => {
            xml.Add(s);
          });

          int removed = 0;

          if (xml[0] == "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
              && xml[1] == ""
              && xml[2] == "<strings>") {
            for (int i = 0; i < xml.Count; i++) {
              if (i % 2 == 1 && xml[i] == "") {
                xml[i] = "##REMOVE!!!##";
              }
            }
            for (int i = 0; i < xml.Count; i++) {
              if (xml[i] == "##REMOVE!!!##") {
                xml.RemoveAt(i);
                i--;
                removed++;
              }
            }
            MessageBox.Show("removed " + removed);
          }

          return xml;
        }
        catch {
          MessageBox.Show("не удалось загрузить \n" + Application.StartupPath.ToString() + "\\" + path + "\n\n"
                          + path);

          Debag("не удалось загрузить " + path);

          return xml;
        }
      }
    }

    public void SaveXML( List<string> xml, string adres ) {
      File.WriteAllLines(adres, xml);
    }

    string probels(int n) {
      string s = "";
      if (n > 0) s = "";
      for (int i = 0; i < n; i++) {
        s += "---";
      }
      return s;
    }
    string objsPars(List<MyObjClass> objs, string s, int stack) {
      for (int i = 0; i < objs.Count; i++) {
        s += probels(stack) + "*" + objs[i].GetName() + "*" + objs[i].GetMyType() + "*\n";

        if (objs[i].GetObjsList().Count > 0) {
          s += objsPars(objs[i].GetObjsList(), "", stack + 1);

        }
      }
      stack--;
      return s;
    }
    string trigsPars(List<MyTrigClass> trig) {
      string s = "";
      for (int i = 0; i < trig.Count; i++) {
        s += trig[i].GetName() + "\n";
        List<string> code = trig[i].GetCode();
        for (int j = 0; j < code.Count; j++) {
          s += "   " + code[j] + "\n";
        }

      }
      return s;
    }

    void moduleShow(ModuleClass mod) {
      Debag("moduleShow(ModuleClass mod)");
      //richTextBox1.AppendText(objsPars(mod.GetObjsList(), "", 0));
      //richTextBox1.AppendText(trigsPars(mod.GetTrigsList()));
      for (int i = 0; i < mod.GetObjsList().Count; i++) {

      }
    }

    private void button1_Click(object sender, EventArgs e) {
      if (richTextBox1.Visible == true)
        richTextBox1.Visible = false;
      else
        richTextBox1.Visible = true;
      this.richTextBox1.BringToFront();
    }

    public void PanelToFront() {
      this.panel1.BringToFront();
    }

    public void RoomsAdd(MyControl rm) {
      rooms.Add(rm);
    }
    public void ZoomsAdd(MyControl zm) {
      zooms.Add(zm);
    }
    public List<MyControl> RoomsGet() {
      return rooms;
    }
    public List<MyControl> ZoomsGet() {
      return zooms;
    }

    void InsertToMassive(List<string> l, string mname, string value) {
      for (int i = 0; i < l.Count; i++) {
        if (l[i] == mname) {
          for (int j = i + 1; j < l.Count; j++) {
            if (l[j].IndexOf("}") > -1) { // == "}")
              l.Insert(j, value);
            }
          }
        }
      }
    }
    List<string> GetMassiveList(List<string> l, string mname) {
      List<string> answer = new List<string>();
      for (int i = 0; i < l.Count; i++) {
        //richTextBox1.AppendText("ищем " + mname + "\n");
        if (l[i].IndexOf(mname) > -1) {
          //richTextBox1.AppendText("нашли массив "+mname+"\n");
          for (int j = i + 1; j < l.Count; j++) {
            string buf = l[j];
            buf = buf.Replace("--[[AUTO]]", "");


            if (buf.IndexOf("--[[") > -1) {
              //buf = buf.Substring(0,buf.IndexOf("--[[")) + buf.Substring(buf.IndexOf("--[[") + 4);
              //Debag(buf);

              if (buf.IndexOf("]]") > -1) {
                string s = buf.Substring(0, buf.IndexOf("--[["));
                s += buf.Substring(buf.IndexOf("]]") + 2);
                //buf = buf.Substring(buf.IndexOf("]]") + 2);
                buf = s;
              }
              else {
                buf = "";
              }
              //Debag("\t"+buf);

            }

            buf = FirstSpaseClear(buf);
            if (buf.IndexOf("--") == 0) {
              continue;
            }
            else {
            }

            if (buf.IndexOf("{") == 0) {
              continue;
            }
            if (buf.IndexOf("\"") > -1) {
              buf = buf.Substring(buf.IndexOf("\"") + 1);
              buf = buf.Substring(0, buf.IndexOf("\""));
              //Debag(">>  " + buf);
              answer.Add(buf);
            }
            if (buf.IndexOf("}") == 0) {
              return answer;
            }
          }
          return answer;
        }
      }
      return answer;
    }
    string FirstSpaseClear(string s) {
      if (s.IndexOf(" ") == 0)
        return FirstSpaseClear(s.Substring(1));
      else
        return s;
    }

    Dictionary<string, bool> attached_rooms = new Dictionary<string, bool>();
    void BuildLogic() {
      MyControl mc = modules[0].GetMainRoomControl();
      List<MyObjClass> ol = mc.GetAllObjs();
      try {
        for (int o = 0; o < ol.Count; o++) {
          //Debag(ol[o].GetName());
          List<string> types = new List<string>();
          types.Add("rm");
          types.Add("mg");
          types.Add("ho");
          //types.Add("zz");
          for (int t = 0; t < types.Count; t++) {
            if (ol[o].GetName().IndexOf("g" + types[t] + "_") == 0) {
              //Debag(ol[o].GetName());
              string s = ol[o].GetName();
              s = types[t] + "_" + s.Substring(s.LastIndexOf("_") + 1);
              MyControl rm = GetControl(s);
              //Debag(s);
              //MyControl nroom =
              if (rm != null) {
                //MessageBox.Show(ol[o].GetName());
                if (rm.GetOwnerControl() != null & mc.GetOwnerControl() != null) {
                  MessageBox.Show("у контролов уже есть родители\n" + rm.GetName() + " <<< " + mc.GetName() +
                                  "\n" + rm.GetOwnerControl().GetName() + " <<< " + mc.GetOwnerControl().GetName() +
                                  "\n объект вызвавший закольцовку => \n" + ol[o].GetName() + "\n BuildLogic()");
                }
                rm.AttachTo(mc, ol[o].GetName());
                //mc.ChildAdd(rm);
              }
              else {
                //Debag("!!!");
              }
            }
          }
        }
        var controlls = GetAllControls();
        foreach(var controll in controlls) {
          foreach(var obj in controll.GetAllObjs()) {
            if(obj.getNamePrefix()=="gzz") {
              var zzName = "zz_" + obj.GetName().Substring(obj.GetName().LastIndexOf("_")+1);
              var zzObj = GetObj(zzName);
              if(zzObj == null) {
                Debag("Объект не найден! " + zzName, Color.Red);
              }
              else {
                //if(controll.getNamePrefix()=="zz") {
                //  zzObj.GetMyControl().AttachTo(controll.GetOwnerControl());
                //}
                //else {
                zzObj.GetMyControl().AttachTo(controll);
                //}
              }
            }
          }
        }
      }
      catch(Exception e) {
        MessageBox.Show(" BuildLogic Exception !!!!!!!!!!!!!!!!!!!!!!!!!");

        MessageBox.Show(e.Message + "\n\n" + e.GetBaseException() + "\n\n" + e.StackTrace);
      }
    }

    #region View
    public void AddDrawLine(LineClass l) {
      drawLinesList.Add(l);
    }
    public void ReDrawLines() {
      /*Graphics g = this.CreateGraphics();

        for (int i = 0; i < drawLinesList.Count; i++)
        {
          drawLinesList[i].DrawLine(g);
        }*/
    }
    public void DrawScreen() {
      try {
        //Bitmap bm = new Bitmap(this.Width, this.Height);
        //Graphics g = Graphics.FromImage(bm);
        Graphics g = this.CreateGraphics();
        g.Clear(this.BackColor);
        int w, h;
        w = this.Width;
        h = this.Height;
        //DrawScreen(main_control, g);
        for (int i = 0; i < allControls.Count; i++) {
          Pen p = new Pen(allControls[i].BackColor);
          p.Width = 3;
          MyControl mc = allControls[i].GetOwnerControl();
          if (mc == null) continue;
          Point p1 = new Point(mc.Location.X + mc.Width / 2, mc.Location.Y + mc.Height / 2);
          Point p2 = new Point(allControls[i].Location.X + allControls[i].Width / 2,
                               allControls[i].Location.Y + allControls[i].Height / 2);
          if ((p1.X > 0 && p1.X < w && p1.Y > 0 && p1.Y < h) || (p2.X > 0 && p2.X < w && p2.Y > 0 && p2.Y < h)) {
            mc.Visible = true;
            g.DrawLine(p, p1, p2);
          }
          else {
            mc.Visible = false;
          }
          //ControlPaint.DrawReversibleLine(p1, p2, p.Color);
          //DrawScreen(ch[i], g);
        }
        g.Dispose();
        //this.BackgroundImage = null;
        //this.BackgroundImage = bm;
        //this.Invalidate();
      }
      catch {

      }

    }
    void DrawScreen(MyControl mc, Graphics g) {
      List<MyControl> ch = mc.GetChilds();
      for (int i = 0; i < ch.Count; i++) {
        Pen p = new Pen(ch[i].BackColor);
        p.Width = 3;
        Point p1 = new Point(mc.Location.X + mc.Width / 2, mc.Location.Y + mc.Height / 2);
        Point p2 = new Point(ch[i].Location.X + ch[i].Width / 2, ch[i].Location.Y + ch[i].Height / 2);
        g.DrawLine(p, p1, p2);
        DrawScreen(ch[i], g);
      }
      treeView1.BringToFront();
    }

    void MoveScreen(Point dp) {
      //main_control.Location = new Point(main_control.Location.X + dp.X, main_control.Location.Y + dp.Y);
      //MoveScreen(main_control, dp);
      //List<MyControl> acl = GetCreatedControls();
      if (dp.X == 0 & dp.Y == 0)
        return;
      List<MyControl> acl = GetAllControls();
      for (int i = 0; i < acl.Count; i++) {
        acl[i].Location = new Point(acl[i].Location.X + dp.X, acl[i].Location.Y + dp.Y);
      }
      treeView1.BringToFront();
    }
    void MoveScreen(MyControl mc, Point dp) {
      if (dp.X == 0 & dp.Y == 0)
        return;
      List<MyControl> ch = mc.GetChilds();
      for (int i = 0; i < ch.Count; i++) {
        ch[i].Location = new Point(ch[i].Location.X + dp.X, ch[i].Location.Y + dp.Y);

        MoveScreen(ch[i], dp);

      }
      treeView1.BringToFront();
    }
    private void Form1_MouseDown(object sender, MouseEventArgs e) {
      DownPoint = e.Location;
      IsDragMode = true;
    }
    private void Form1_MouseMove(object sender, MouseEventArgs e) {
      if (IsDragMode) {
        Point p = e.Location;
        Point dp = new Point(p.X - DownPoint.X, p.Y - DownPoint.Y);
        DownPoint = e.Location;
        if (dp.X == 0 & dp.Y == 0) {
        }
        else {
          MoveScreen(dp);
          DrawScreen();
        }
      }
    }
    private void Form1_MouseUp(object sender, MouseEventArgs e) {
      IsDragMode = false;
      DrawScreen();
    }
    #endregion
    void LoadLevelUNSAFE(string dirbuf) {

      levelStartRoomDir = dirbuf;

      levelDir = levelStartRoomDir.Substring(0, levelStartRoomDir.LastIndexOf("\\"));
      repDir = levelDir.Substring(0, levelDir.IndexOf("\\exe") + 1);
      levelStartRoom = levelStartRoomDir.Substring(levelStartRoomDir.LastIndexOf("\\") + 1);
      //MessageBox.Show("levelStartRoom " + levelStartRoom);
      levelName = levelDir.Substring(levelDir.LastIndexOf("\\") + 1);
      projectDir = levelDir.Substring(levelDir.LastIndexOf(@"\exe"));


      if (File.Exists(levelDir + "\\mod_" + levelName + ".xml")) {
        levelXML = LoadXML(levelDir + "\\mod_" + levelName + ".xml");
        levelMod = new ModuleClass(levelXML, LoadXML(levelDir + "\\mod_" + levelName + ".lua"));
        InvMod = new ModuleClass(LoadXML(levelDir + "\\mod_" + levelName + "_inv.xml"),
                                 LoadXML(levelDir + "\\mod_" + levelName + "_inv.lua"));
      }
      else {
        return;
      }

      inventoryObj = InvMod.GetObjs()[0].GetObjsList()[0];
      levelInit = levelMod.GetTrigCode("trg_" + levelName + "_init");
      roomsM = GetMassiveList(levelInit, "  game.room_names =");
      progressBar1.Maximum = roomsM.Count - 1;
      progressBar1.Value = 0;
      if (ARG_CMD["creation_only"]) {
        // ARG_STR["creation_only_rm_name"];
        for (int i = 0; i < roomsM.Count; i++) {
          if (ARG_STR["creation_only_rm_name"] == roomsM[i]) {
            this.Text = levelDir + "\\" + roomsM[i] + "\\mod_" + roomsM[i].Substring(3) + ".xml";
            modules.Add(new ModuleClass(LoadXML(levelDir + "\\" + roomsM[i] + "\\mod_" + roomsM[i].Substring(3) + ".xml"),
                                        LoadXML(levelDir + "\\" + roomsM[i] + "\\mod_" + roomsM[i].Substring(3) + ".lua")));
            progressBar1.Value = 0;
            main_control = modules[0].GetMainRoomControl();
            //progressBar1.Refresh();
            break;
          }
        }
      }
      else {
        for (int i = 0; i < roomsM.Count; i++) {
          if (levelStartRoom == roomsM[i]) {
            this.Text = levelDir + "\\" + roomsM[i] + "\\mod_" + roomsM[i].Substring(3) + ".xml";
            modules.Add(new ModuleClass(LoadXML(levelDir + "\\" + roomsM[i] + "\\mod_" + roomsM[i].Substring(3) + ".xml"),
                                        LoadXML(levelDir + "\\" + roomsM[i] + "\\mod_" + roomsM[i].Substring(3) + ".lua")));
            progressBar1.Value = 0;
            main_control = modules[0].GetMainRoomControl();
            //progressBar1.Refresh();
          }
        }

        for (int i = 0; i < roomsM.Count; i++) {
          if (levelStartRoom != roomsM[i]) {

            this.Text = levelDir + "\\" + roomsM[i] + "\\mod_" + roomsM[i].Substring(3) + ".xml";
            modules.Add(new ModuleClass(LoadXML(levelDir + "\\" + roomsM[i] + "\\mod_" + roomsM[i].Substring(3) + ".xml"),
                                        LoadXML(levelDir + "\\" + roomsM[i] + "\\mod_" + roomsM[i].Substring(3) + ".lua")));
            progressBar1.Value = i;
            //progressBar1.Refresh();
          }
        }
      }
      modules.Add(InvMod);
      BuildLogic();
      progressBar1.Hide();
      this.Text = "logicCase";
      LoadConfig();
      RePlace();

      try {
        main_control.Location = new Point(Convert.ToInt16(
                                            loadedConfig[main_control.GetOwnerObj().GetName()].Propertie("pos_x")),
                                          Convert.ToInt16(loadedConfig[main_control.GetOwnerObj().GetName()].Propertie("pos_y")));
      }
      catch {
        //Debag("!!!" + main_control.GetOwnerObj().GetName());
      }

      this.Text = "LogicCase - " + levelStartRoomDir;//.Replace(projectDir, "");

      BuildPRG();

      List<MyControl> MCL = GetCreatedControls();
      for (int i = 0; i < MCL.Count; i++) {
        try {
          MCL[i].Location = new Point(Convert.ToInt16(loadedConfig[MCL[i].GetOwnerObj().GetName()].Propertie("pos_x")),
                                      Convert.ToInt16(loadedConfig[MCL[i].GetOwnerObj().GetName()].Propertie("pos_y")));
        }
        catch {
          //Debag("!!!" + MCL[i].GetOwnerObj().GetName());
        }
      }

      modules = modules.OrderBy(x => x.GetName()).ToList();
      treeView1.NodeMouseClick += treeView1_NodeMouseClick;
      treeView1.NodeMouseDoubleClick += treeView1_NodeMouseDoubleClick;
      TreeViewBuild();

      gameHint = new GameHint(this);

      List<MyControl> acl = GetCreatedControls();
      for (int i = 0; i < acl.Count; i++) {
        acl[i].panelItems.AutoSize = true;
        acl[i].menuStrip1_MouseLeave(null, null);
      }

      DrawScreen();
    }

    void LoadLevel(string dirbuf) {
      if (checkBoxUnsafeLoading.Checked) {
        LoadLevelUNSAFE(dirbuf);
        return;
      }
      try {
        if (levelStartRoomDir != null) {
          return;
        }

        try {
          string game_path = Application.ExecutablePath.Remove(Application.ExecutablePath.LastIndexOf(
                               @"src\doc\LogicCase\logicCase.exe"));
          if (!dirbuf.StartsWith(game_path)) {
            try {
              string new_exe_path = dirbuf.Remove(dirbuf.LastIndexOf(@"exe\assets\levels\"));
              System.Diagnostics.Process.Start(new_exe_path + @"src\doc\LogicCase\logicCase.exe",
                                               "\"##CHANGE_DIR##" + dirbuf + "\" \"##RESENDER##" + Application.ExecutablePath + "\"");
              EXIT();
              return;
            }
            catch {
              try {
                string new_exe_path = dirbuf.Remove(dirbuf.LastIndexOf(@"exe\assets\levels\"));
                System.Diagnostics.Process.Start(new_exe_path + @"src\doc\logicCase\LogicCase.exe",
                                                 "\"##CHANGE_DIR##" + dirbuf + "\" \"##RESENDER##" + Application.ExecutablePath + "\"");
                EXIT();
                return;
              }
              catch {
                MessageBox.Show("при попытке запустить LogicCase из дириктории проэкта возникла ошибка");
              }
            }
          }
        }
        catch {
          //MessageBox.Show("LogicCase находится в неверной директории\n" + Application.ExecutablePath + "\n>>>>\n" + @"*\src\doc\LogicCase\logicCase.exe");
          try {
            string new_exe_path = dirbuf.Remove(dirbuf.LastIndexOf(@"exe\assets\levels\"));
            System.Diagnostics.Process.Start(new_exe_path + @"src\doc\LogicCase\logicCase.exe",
                                             "\"##CHANGE_DIR##" + dirbuf + "\" \"##RESENDER##" + Application.ExecutablePath + "\"");
            EXIT();
            return;
          }
          catch {
            try {
              string new_exe_path = dirbuf.Remove(dirbuf.LastIndexOf(@"exe\assets\levels\"));
              System.Diagnostics.Process.Start(new_exe_path + @"src\doc\LogicCase\LogicCase.exe",
                                               "\"##CHANGE_DIR##" + dirbuf + "\" \"##RESENDER##" + Application.ExecutablePath + "\"");
              EXIT();
              return;
            }
            catch {
              MessageBox.Show("при попытке запустить LogicCase из дириктории проэкта возникла ошибка");
            }
          }
          return;
        }


        LoadLevelUNSAFE(dirbuf);

      }
      catch (Exception e) {
        System.Windows.Forms.MessageBox.Show("WARNING!!!\n" + e.Message);
      }
    }

    public void TreeViewBuild() {
      treeView1.Nodes.Clear();
      for (int i = 0; i < modules.Count; i++) {
        TreeNode nod = new TreeNode(modules[i].GetName());

        if (modules[i].GetName().StartsWith("rm_"))
          nod.BackColor = Color.SlateGray;
        else if (modules[i].GetName().StartsWith("ho_"))
          nod.BackColor = Color.LightCoral;
        else if (modules[i].GetName().StartsWith("mg_"))
          nod.BackColor = Color.Orange;


        treeView1.Nodes.Add(nod);
        modules[i].SetNodForTree(nod);

      }
    }

    private void Form1_Shown(object sender, EventArgs e) {
      LoadConfig();
      //FuncString funcString = new FuncString(ListToString( LoadXML(@"E:\Work\RD3\exe\assets\levels\levelext\ho_flowersext\mod_flowersext.lua")));

    }

    void treeView1_NodeMouseClick(object sender, TreeNodeMouseClickEventArgs e) {
      SetTreeViewMaxWidth();
    }

    void treeView1_NodeMouseDoubleClick(object sender, TreeNodeMouseClickEventArgs e) {
      MyObjClass obj = GetObj(e.Node.Text);
      if (obj == null) return;
      List<string> nms = obj.GetPropNames();
      List<string> vls = obj.GetPropValues();
      string s = "";
      s += "type = " + obj.GetMyType() + "\n";
      for (int i = 0; i < nms.Count; i++) {
        s += nms[i] + " = " + vls[i] + "\n";
      }
      MessageBox.Show(s);
    }
    void LoadConfig(bool show = false) {
      try {
        List<string> l = LoadXML("config.xml");
        if (show) {
          string dir = "";
          int count = 0;
          for (int i = 0; i < l.Count; i++) {
            if (l[i].IndexOf("<project ") > -1) {
              dir = l[i].Substring(l[i].IndexOf("level_dir=") + 11);
              dir = dir.Substring(0, dir.IndexOf("\""));
              ToolStripMenuItem ts = new ToolStripMenuItem(dir);
              ts.Name = "ToolStripMenuItemProject_" + count;
              ts.MouseUp += ts_MouseUp;
              LevelToolStripMenuItem.DropDownItems.Add(ts);

              //if (i == 0)
              //{
              //    ts.ShortcutKeys = Keys.Control;
              //}
              count++;
            }

          }
        }
        else {
          loadedConfig = new Dictionary<string, Propobj>();
          loadedIgnore = new Dictionary<string, Propobj>();
          loadedIgnoreBool = new Dictionary<string, bool>();
          string dir = "";
          for (int i = 0; i < l.Count; i++) {
            if (dir.Length > 0 && dir == levelStartRoomDir) {
              if (l[i].IndexOf("<control ") > -1) {
                string name = l[i].Substring(l[i].IndexOf("_name") + 7);
                name = name.Substring(0, name.IndexOf("\""));
                //loadedConfig.Add(name, new MyObjClass(l, i, null));
                Propobj po = new Propobj(l[i]);
                MyControl mc = GetControl(name);

                try {

                  //if (mc != null)
                  //{
                  //mc.Location = new Point(Convert.ToInt16(po.Propertie("pos_x")), Convert.ToInt16(po.Propertie("pos_y")));
                  loadedConfig.Add(name, po);
                  //}
                }
                catch (Exception e) {
                  MessageBox.Show(e.Message + "\nLoadConfig\n" + l[i] + "\n" + "loadedConfig.Add(name, po)");
                }
                //else
                //{
                //    Debag("not finded " + name);
                //}
                continue;
              }
              if (l[i].IndexOf("<ignore ") > -1) {
                string name = l[i].Substring(l[i].IndexOf("_name") + 7);
                name = name.Substring(0, name.IndexOf("\""));
                //loadedConfig.Add(name, new MyObjClass(l, i, null));
                Propobj po = new Propobj(l[i]);

                try {
                  loadedIgnore.Add(name, po);
                  loadedIgnoreBool[name] = true;
                }
                catch (Exception e) {
                  //MessageBox.Show(e.Message + "\nLoadConfig\n" + l[i] + "\n" + "loadedIgnore.Add(name, po)");
                  Debag(e.Message + "\nLoadConfig\n" + l[i] + "\n" + "loadedIgnore.Add(name, po)", Color.Red);
                  //loadedIgnore[name]
                }
                continue;
              }
              else if (l[i].IndexOf("</project>") > -1) {
                //if (dir == levelDir)
                break;
                //else
                //    continue;
              }
            }
            else if (l[i].IndexOf("<project ") > -1) {
              //Debag(l[i]);
              dir = l[i].Substring(l[i].IndexOf("level_dir=") + 11);
              dir = dir.Substring(0, dir.IndexOf("\""));
              //Debag(dir + "\t\t" + levelStartRoomDir);
              if (dir != levelStartRoomDir)
                dir = "";

              continue;
            }


          }
        }
      }
      catch (Exception e) {
        MessageBox.Show("не удалось загрузить config.\n" + e.Message);
      }

    }

    void ts_MouseUp(object sender, MouseEventArgs e) {
      ToolStripMenuItem ts = (ToolStripMenuItem)sender;
      LoadLevel(ts.Text);
    }

    void SetObjOwnerControl() {
      for (int i = 0; i < modules.Count; i++) {

      }
    }

    int replaceRmCount = 0;
    void RePlace(bool readConfig = true) {
      //main_control.Location = new Point(400, 200);
      List<MyControl> acl = GetCreatedControls();
      int invCount = 0;
      for (int i = 0; i < acl.Count; i++) {
        if (acl[i].getNamePrefix() == "inv") {
          acl[i].Location = new Point(50, 100 + invCount * 125);
          //acl[i].ToFront();
          invCount++;
        }
        else {
          //acl[i].Location = new Point(300, 200);
        }
      }
      replaceRmCount = 1;
      Propobj po = null;
      int pos_x = 350;
      int pos_y = 175;
      if (readConfig && loadedConfig.TryGetValue(main_control.GetName(), out po)) {
        int.TryParse(po.Propertie("pos_x"), out pos_x);
        int.TryParse(po.Propertie("pos_y"), out pos_y);
      }
      main_control.Location = new Point(pos_x, pos_y);
      RePlace(main_control,0, readConfig);

    }
    void RePlace(MyControl mc, int column = 0, bool readConfig = true) {
      int rm_count = 0, count = 0;

      Point loc = mc.Location;

      int pos_x = 0;
      int pos_y = 0;
      int width = 175;
      Propobj po = null;

      List<MyControl> ch = mc.GetRoomsInChilds();
      foreach(var v in ch) {
        if(!readConfig || !loadedConfig.ContainsKey(v.GetName())) {
          ch = ch .OrderBy(o => o.GetRoomsInChilds(true).Count).ToList();
          break;
        }
      }

      for (int i = 0; i < ch.Count; i++) {
        if (ch[i].getNamePrefix() == "rm" ) {
          rm_count++;
          replaceRmCount++;
          pos_x = loc.X + ( column + ch.Count - rm_count) *width;
          pos_y = replaceRmCount * width;


          if(readConfig && loadedConfig.TryGetValue(ch[i].GetName(),out po)) {
            int.TryParse(po.Propertie("pos_x"), out pos_x);
            int.TryParse(po.Propertie("pos_y"), out pos_y);
          }


          ch[i].Location = new Point(pos_x, pos_y);
          Debag(mc.GetName() + " " + column + " " + rm_count + " " + (column + rm_count - 1));
          RePlace(ch[i], (Math.Max(0, column - ch.Count)), readConfig);
        }
      }
      ch = mc.GetChilds();
      for (int i = 0; i < ch.Count; i++) {
        if (ch[i].GetName().IndexOf("rm_") == -1) {
          count++;
          pos_x = loc.X + ( count ) * width;
          pos_y = loc.Y;

          if (readConfig && loadedConfig.TryGetValue(ch[i].GetName(), out po)) {
            int.TryParse(po.Propertie("pos_x"), out pos_x);
            int.TryParse(po.Propertie("pos_y"), out pos_y);
          }

          ch[i].Location = new Point(pos_x, pos_y);

        }
      }
    }

    public List<MyControl> GetAllControls() {
      return allControls;
    }

    private void buttonSave_Click(object sender, EventArgs e) {
      SaveProject();
    }


    public void SaveProject() {
      //SaveMulInvSpr();
      FSaver.Save();
      List<string> ls = LoadXML("config.xml");
      //MessageBox.Show(Application.StartupPath.ToString() + "\\config.xml");
      bool projFinded = false;
      for (int i = 0; i < ls.Count; i++) {
        if (projFinded == true) {
          //richTextBox1.AppendText("string " + i + " " + ls[i]);
          if (ls[i].IndexOf("<control ") > -1) {
            //richTextBox1.AppendText("removed at " + i + " " + ls[i]);
            ls.RemoveAt(i);
            i--;
            continue;
          }
          else if (ls[i].IndexOf("<ignore ") > -1) {
            ls.RemoveAt(i);
            i--;
            continue;
          }
          else if (ls[i].IndexOf("</project>") > -1) {
            ls.RemoveAt(i);
            break;
          }
        }
        else if (ls[i].IndexOf("<project ") == 0) {
          if (new Propobj(ls[i]).Propertie("level_dir") == levelStartRoomDir) {
            projFinded = true;
            //richTextBox1.AppendText("start removing at " + i);
            ls.RemoveAt(i);
            i--;
            continue;
          }
        }

      }

      if (!ARG_CMD["creation_only"]) {
        StreamWriter config = new StreamWriter(Application.StartupPath.ToString() + "\\config.xml");
        //config.WriteLine("<project level_dir=\""+levelDir+"\">");
        ls.Insert(0, "<project level_dir=\"" + levelStartRoomDir + "\">");
        List<MyControl> MCL = GetCreatedControls();
        for (int i = 0; i < MCL.Count; i++) {
          ls.Insert(i + 1, "\t<control _name=\"" + MCL[i].GetOwnerObj().GetName() + "\" pos_x=\"" + MCL[i].Location.X +
                    "\" pos_y=\"" + MCL[i].Location.Y + "\" />");
          //config.WriteLine("\t<control name=\"" + allControls[i].GetOwnerObj().GetName() + "\" pos_x=\"" + allControls[i].Location.X + "\" pos_y=\"" + allControls[i].Location.Y + "\" />");
        }
        int strNow = MCL.Count + 1;
        foreach (KeyValuePair<string, Propobj> kvp in loadedIgnore) {
          bool ignor;
          if (loadedIgnoreBool.TryGetValue(kvp.Key, out ignor)) {
            ls.Insert(strNow, "\t<ignore _name=\"" + kvp.Value.Propertie("_name") + "\"/>");
            strNow++;
          }
        }

        ls.Insert(strNow, "</project>");
        //config.WriteLine("</project>");

        for (int i = 0; i < ls.Count; i++) {
          config.WriteLine(ls[i]);
        }

        config.Close();
      }
      else {



      }

      progressBar1.Visible = true;
      progressBar1.Value = 0;
      progressBar1.Maximum = modules.Count + 1;
      progressBar1.Show();


      //объекты сохраняются в порядке прогресса
      List<string> prg = GetMassiveList(levelInit, "  game.progress_names =");
      string[] prgs = prg.ToArray();
      for (int i = 0; i < prgs.Count(); i++) {
        //Debag(prg[i]);
        prgs[i] = prgs[i].Substring(4);
      }



      for (int i = 0; i <= modules.Count + 1; i++) {
        ModuleClass mod;
        StreamWriter f;
        StreamWriter ft;
        if (i == modules.Count) {
          mod = levelMod;
          if (ARG_CMD["creation_only"] && !ARG_STR["creation_only_control_name"].StartsWith("inv"))
            continue;
          //if (ARG_CMD["creation_only"]  && GetControl(ARG_STR["creation_only_control_name"]).GetOwnerObj().GetModule().GetName() != mod.GetName())
          //    continue;
          f = new StreamWriter(levelDir + "\\mod_" + mod.GetName() + ".xml");
          ft = new StreamWriter(levelDir + "\\mod_" + mod.GetName() + ".lua");
        }
        else if (i == modules.Count + 1) {
          mod = InvMod;
          if (ARG_CMD["creation_only"] && !ARG_STR["creation_only_control_name"].StartsWith("inv"))
            continue;
          //if (ARG_CMD["creation_only"] && GetControl(ARG_STR["creation_only_control_name"]).GetOwnerObj().GetModule().GetName() != mod.GetName())
          //    continue;
          f = new StreamWriter(levelDir + "\\mod_" + mod.GetName() + ".xml");
          ft = new StreamWriter(levelDir + "\\mod_" + mod.GetName() + ".lua");
        }
        else {
          if (ARG_CMD["creation_only"] && ARG_STR["creation_only_control_name"].StartsWith("inv"))
            continue;
          mod = modules[i];
          if (ARG_CMD["creation_only"]
              && GetControl(ARG_STR["creation_only_control_name"]).GetOwnerObj().GetModule().GetName() != mod.GetName())
            continue;
          if (mod.GetName() == levelName + "_inv") {
            f = new StreamWriter(levelDir + "\\mod_" + mod.GetName() + ".xml");
            ft = new StreamWriter(levelDir + "\\mod_" + mod.GetName() + ".lua");
          }
          else {
            f = new StreamWriter(levelDir + "\\" + mod.GetName() + "\\mod_" + mod.GetName().Substring(3) + ".xml");
            ft = new StreamWriter(levelDir + "\\" + mod.GetName() + "\\mod_" + mod.GetName().Substring(3) + ".lua");
          }
        }




        f.WriteLine("<module name=\"" + mod.GetName() + "\" version=\"1.0\">");
        f.WriteLine("    <objs>");

        mod.SaveObjs(f);

        f.WriteLine("    </objs>");
        //f.WriteLine("    <trigs>");

        mod.SaveTrigs(ft);

        //f.WriteLine("    </trigs>");
        f.WriteLine("</module>");
        f.Close();

        ft.Close();



        progressBar1.Value = i;
      }
      progressBar1.Hide();
      progressBar1.Visible = false;

      StreamWriter tmpF = new StreamWriter(Application.StartupPath.ToString() + "\\temp.tmp");
      tmpF.Write(levelStartRoomDir);
      tmpF.Close();

      _notEditorProject = _notEditorProject == null ? _notEditorProject = new NotEditorProject(this) : _notEditorProject;
      foreach (var v in modules) {
        _notEditorProject.AddModuleIfNotExist(v, this);
      }
      _notEditorProject.Save();
      _notEditorProject = null;

      //Application.Restart();
    }

    public void PrgCreation(MyControl mc, string s, string dopCMD, string prg_creation_before = "") {
      int ObjsOnCreateMoveWidth = 50;

      if (FindId(progress_names, s, true) > -1) {
        MessageBox.Show("Прогресс с таким именем существует\n" + progress_names[FindId(
                          progress_names, s, true)]);
        //if (dopCMD.Length>0)
        return;
      }

      string razdel =
        "--*********************************************************************************************************************";

      //Debag("PrgCreation");
      //Debag("\tcontrol name -> " + mc.GetName() != null ? mc.GetName() : "null" + "\ts -> " + s + "\tdopCMD -> " + dopCMD);


      string tp = s.Substring(0, s.IndexOf("_"));
      string nm = s.Substring(s.IndexOf("_") + 1);

      string rm = "inv_complex";


      if (tp != "complex" && mc.GetOwnerObj().GetModule().GetMainRoomControl() != null) {
        rm = mc.GetOwnerObj().GetModule().GetMainRoomControl().getNamePost();
      }

      string prg = s;
      string zrm = mc == null ? "" : mc.getNamePost();

      string homgrm = mc == null ? "level_inv" : ( mc.getNamePrefix() == "zz" ? "rm" : mc.getNamePrefix() );


      Debag("PrgCreation >> \ttp -> " + tp + "\tnm -> " + nm);

      //try
      //{
      int id = -1;

      #region mc == null

      if (mc == null) {
        s = s.Replace("complex_", "");
        //MessageBox.Show("PrgCreation complex " + s);

        ModuleCreation(mc, s, dopCMD);
        List<string> obj = LoadXML(@"res/get/complex.xml");
        xmlReplace(obj, "##name##", s);


        MyObjClass complex_hub = GetObj("obj_inventory_complex_hub");

        if (complex_hub == null) {
          MessageBox.Show("В модуле инвентаря остутствует 'obj_inventory_complex_hub'");
          return;
        }

        MyObjClass INV_OBJ = complex_hub.ObjsLoader(obj, 0);


        //MessageBox.Show(INV_OBJ.Parent.GetName());

        MyObjClass invo = GetObj("inv_" + s);
        if (invo == null) {
          MessageBox.Show( "Инвентарный объект не найден\n"+ "inv_" + s);
        }
        else {
          invo.SetPropertie("event_mdown", "common_impl.ShowComplexItem( &apos;" + s + "&apos; )");
          List<string> plus = LoadXML(@"res/get/plus.xml");
          xmlReplace(plus, "##name##", s);
          invo.ObjsLoader(plus, 0);
        }
        mc = GetControl("inv_complex_" + s);
        FSaver.FolderCreate(repDir + "\\exe\\" + mc.GetDefResName());
        FSaver.FolderCreate(repDir + "\\exe\\" + mc.GetDefResName()+"\\state");
        FSaver.FolderCreate(repDir + "\\exe\\" + mc.GetDefResName()+"\\layers");
        FSaver.FolderCreate(repDir + "\\exe\\" + mc.GetDefResName()+"\\anims");
      }

      #endregion

      else if (tp == "aud") {
        addSFX( mc, s, dopCMD );
      }

      #region tp == "mg"

      else if (tp == "mg") {
        string name = nm;
        List<string> misc = LoadXML(@"res/" + tp + "/" + tp + "_rm_misc.lua");

        xmlReplace(misc, "##rm##", nm);
        xmlReplace(misc, "##rm_owner##", mc.getNamePost());

        MyTrigClass trg;
        if (rm == "inv_complex")
          trg = mc.GetOwnerObj().GetModule().GetTrig("trg_" + levelName + "_inv_deploy_init");
        else
          trg = mc.GetOwnerObj().GetModule().GetTrig("trg_" + rm + "_init_" + tp);

        //Debag(progress_names);


        id = FindId(trg.GetCode(), "-- function *** PROGRESS MISC *** () end");
        if (id < 0) {
          MessageBox.Show("Нужно добавить -- function *** PROGRESS MISC *** () end в модуль " +
                          mc.GetOwnerObj().ownerModule.GetName());
        }

        trg.AddListToCode(misc, id + 2);
        //Debag(code);
        ModuleCreation(mc, s, dopCMD);
      }

      #endregion
      #region tp == "inv"

      else if (tp == "inv") {

        //ModuleCreation(mc, s, dopCMD);

        if (s.IndexOf("MUL") == -1) {
          string name = nm;
          tp = "get";

          List<string> inv_obj = LoadXML(@"res/" + tp + "/" + tp + "_inv_obj.xml");
          xmlReplace(inv_obj, "##name##", name);
          xmlReplace(inv_obj, "##res##", projectDir.Replace("\\exe\\", "") + "\\" + dopCMD.Replace("COMPLEX",
                     "") + "\\inv" + "\\inv_" + name);

          //Debag(gameDir);
          //Debag(levelDir);
          //Debag(projectDir);
          Debag("***\t" + s + "\t" + dopCMD.Replace("COMPLEX", ""));
          //MessageBox.Show(dopCMD.Replace("COMPLEX", ""));

          MyObjClass INV_OBJ = GetObj(levelName + "_inv_hub").ObjsLoader(inv_obj, 0);
          //INV_OBJ.AddTexObjText(name);

          FSaver.Copy("res\\" + tp + "\\" + tp + "_spr_inv.png", levelDir + "\\" + dopCMD.Replace("COMPLEX",
                      "") + "\\inv" + "\\inv_" + name + ".png");
          FSaver.Copy("res\\" + tp + "\\" + tp + "_spr_obj.png", levelDir + "\\" + dopCMD.Replace("COMPLEX",
                      "") + "\\layers" + "\\" + name + ".png");

          //FSaver.FolderCreate("\\" + dopCMD.Replace("COMPLEX", "") + "\\state");
          //INV_OBJ.SetPropertie("res", projectDir.Replace("\\exe\\", "") + "\\" + dopCMD.Replace("COMPLEX", "") + "\\inv_" + name);

        }

        List<string> misc = LoadXML(@"res/ho/ho_rm_misc.lua");

        xmlReplace(misc, "##rm##", dopCMD.Replace("COMPLEX", "").Substring(3));
        xmlReplace(misc, "##rm_owner##", mc.getNamePost());

        MyTrigClass trg;
        if (rm == "inv_complex")
          trg = mc.GetOwnerObj().GetModule().GetTrig("trg_" + levelName + "_inv_deploy_init");
        else
          trg = mc.GetOwnerObj().GetModule().GetTrig("trg_" + rm + "_init_" + tp);

        //Debag(progress_names);


        id = FindId(trg.GetCode(), "-- function *** PROGRESS MISC *** () end");
        if (id < 0) {
          MessageBox.Show("Нужно добавить -- function *** PROGRESS MISC *** () end в модуль " +
                          mc.GetOwnerObj().ownerModule.GetName());
        }

        trg.AddListToCode(misc, id + 2);
        //Debag(code);

        ModuleCreation(mc, s, dopCMD);


      }

      #endregion
      #region tp == "get"

      else if (tp == "get") {

        string name = nm;
        string item = name;
        string PROCESS = "";

        int count = 0;
        try {
          count = Convert.ToInt32(name[name.Length - 1].ToString());
        }
        catch {
        }

        string COMPLEX = "";

        if (dopCMD.IndexOf("COMPLEX") > -1) {
          COMPLEX = "COMPLEX";
          //MessageBox.Show(dopCMD + "\n" + dopCMD.Replace(COMPLEX, ""));
          dopCMD.Replace(COMPLEX, "");
        }

        if (dopCMD == "mul") {
          int pos_z = 1;
          try {
            pos_z = Convert.ToInt16(name.Substring(name.Length - 1));
            item = name.Substring(0, name.Length - 1);
          }
          catch {
            item = name;
          }

          count = 1;
          for (int i = 0; i < progress_names.Count; i++) {
            if (progress_names[i].StartsWith("get_" + item))
              count++;
          }
          //MessageBox.Show(item + " " + count);
          count = (count > 1) ? count : 2;
          //MessageBox.Show("repiat "+item + " " + count);

          List<string> mget = LoadXML("res\\get\\multigetadd_data\\" + count + ".xml");
          xmlReplace(mget, "##ft_name##", "inv_" + item + "_t");

          List<string> mgett = LoadXML("res\\get\\multigetadd_data\\" + count + "_ft.xml");
          xmlReplace(mgett, "##ft_name##", "inv_" + item + "_t");

          FSaver.Copy(mget, levelDir + "\\common\\inv\\inv_" + item + ".xml");
          FSaver.Copy(mgett, levelDir + "\\common\\inv\\inv_" + item + "_t.xml");
          FSaver.Copy("res\\get\\multigetadd_data\\" + count + "_ft_00.png",
                      levelDir + "\\common\\inv\\inv_" + item + "_t_00.png");

          Debag("Creating mul get >> " + " >> " + name + " >> " + item + " >> " + count);
          Debag("mul res copy >> " + "res\\get\\multigetadd_data\\" + count + "_ft_00.png" + " >> " + levelDir +
                "\\common\\inv\\inv_" + item + "_t_00.png");

          MyTrigClass ttrg = InvMod.GetTrig("");

          if (GetObj("inv_" + item) == null) {

            List<string> inv_obj = LoadXML(@"res/" + tp + "/" + tp + "_inv_obj_mul.xml");
            xmlReplace(inv_obj, "##item##", item);
            xmlReplace(inv_obj, "##name##", name);
            MyObjClass INV_OBJ = GetObj(levelName + "_inv_hub").ObjsLoader(inv_obj, 0);
            //INV_OBJ.AddTexObjText(item,-25);

            List<string> process = LoadXML("res\\get\\process.lua");
            xmlReplace(process, "##item##", item);
            xmlReplace(process, "##prg##", prg);
            xmlReplace(process, "##Item##", item.Substring(0, 1).ToUpper() + item.Substring(1));


            ttrg.AddListToCode(process, 0);

            //Debag(process);
            //MessageBox.Show(INV_OBJ.GetName());
            //MessageBox.Show(GetObj(INV_OBJ.GetName()).GetName());
            //MessageBox.Show(GetObj("inv_" + item).GetName());
          }
          else {
            List<string> cde = ttrg.GetCode();
            int iid = FindId(cde, "function public.ProcessGet" + item.Substring(0, 1).ToUpper() + item.Substring(1) + "All(");
            iid = FindId(cde, "local prg_all = {", iid + 1);
            string ss = cde[iid];
            string ss1 = ss.Substring(0, ss.IndexOf("}"));
            string ss2 = ss.Substring(ss.IndexOf("}"));
            cde[iid] = ss1 + ",\"" + prg + "\"" + ss2;
            //Debag(cde[iid]);
          }

          //добавляем спрайт инвентарника в рут инвентарного объекта
          List<string> inv_obj_add = LoadXML(@"res/" + tp + "/" + tp + "_inv_obj_mul_add.xml");
          xmlReplace(inv_obj_add, "##prg##", prg);
          xmlReplace(inv_obj_add, "##name##", name);
          xmlReplace(inv_obj_add, "##item##", item);
          xmlReplace(inv_obj_add, "##zrm##", zrm);
          xmlReplace(inv_obj_add, "##res##", mc.GetDefResName() + "inv\\" + "inv_" + name);
          xmlReplace(inv_obj_add, "##rm##", rm);
          xmlReplace(inv_obj_add, "##homgrm##", homgrm);
          if (mc.getNamePrefix() == "inv")
            xmlReplace(inv_obj_add, "inv_inv_complex", levelName + "_inv");

          MyObjClass INV_OBJ_ADD = GetObj("inv_" + item).ObjsLoader(inv_obj_add,0);
          INV_OBJ_ADD.SetPropertie("pos_z", pos_z.ToString());
          if (mc.getNamePrefix() == "inv")
            INV_OBJ_ADD.SetPropertie("inv_inv_complex", levelName + "_inv");

          PROCESS = ",function() level_inv.ProcessGet" + item.Substring(0,
                    1).ToUpper() + item.Substring(1) + "All( \"" + prg + "\" ) end";

        }
        else {

          List<string> inv_obj = LoadXML(@"res/" + tp + "/" + tp + "_inv_obj.xml");
          xmlReplace(inv_obj, "##prg##", prg);
          xmlReplace(inv_obj, "##name##", name);
          xmlReplace(inv_obj, "##item##", item);
          xmlReplace(inv_obj, "##zrm##", zrm);
          xmlReplace(inv_obj, "##res##", mc.GetDefResName() + "inv\\" + "inv_" + name); // ["inv_" + name] заменить на ["//inv//inv_" + name] если нужна вложенность инвентарика в дополнительную папку inv
                    xmlReplace(inv_obj, "##rm##", rm);
          xmlReplace(inv_obj, "##homgrm##", mc.getNamePrefix() == "zz" ? "rm" : mc.getNamePrefix());
          if (mc.getNamePrefix() == "inv")
            xmlReplace(inv_obj, "inv_inv_complex", levelName + "_inv");
          MyObjClass INV_OBJ = GetObj(levelName + "_inv_hub").ObjsLoader(inv_obj, 0);
          //INV_OBJ.AddTexObjText(item,-25);

          //INV_OBJ.SetPropertie("res", mc.GetDefResName() + "inv_" + name);

          if (mc.getNamePrefix() == "inv")
            INV_OBJ.SetPropertie("inv_inv_complex", levelName + "_inv");

          //mc.GetOwnerObj().ObjsLoader(obj, 0);
          //GetObj("level_inv").objAdd(INV_OBJ);
        }



        //Debag(prg);
        //Debag(name);
        //Debag(zrm);
        //Debag(rm);
        //Debag(mc.getNamePrefix());




        List<string> obj = LoadXML(@"res/" + tp + "/" + tp + "_obj.xml");
        xmlReplace(obj, "##prg##", prg);
        xmlReplace(obj, "##name##", name);
        xmlReplace(obj, "##item##", item);
        xmlReplace(obj, "##zrm##", zrm);
        xmlReplace(obj, "##rm##", rm);
        xmlReplace(obj, "##homgrm##", mc.getNamePrefix() == "zz" ? "rm" : mc.getNamePrefix());
        if (mc.getNamePrefix() == "inv") {
          xmlReplace(obj, "inv_inv_complex", levelName + "_inv");
          //FSaver.FolderCreate();
        }

        //MyObjClass OBJ = new MyObjClass(obj, 0, mc.GetOwnerObj().GetModule());
        MyObjClass OBJ = mc.GetOwnerObj().ObjsLoader(obj, 0);
        //mc.GetOwnerObj().ObjsLoader(obj, 0);
        //mc.GetOwnerObj().objAdd(OBJ)

        if (COMPLEX == "COMPLEX") {
          COMPLEX = "\n  ObjSet( \"inv_" + item + "\", { drag = 0 } );";
          //MessageBox.Show(COMPLEX);
        }

        List<string> code = LoadXML(@"res/" + tp + "/" + tp + "_func_" + mc.getNamePrefix() + ".xml");
        xmlReplace(code, "##prg##", prg);
        xmlReplace(code, "##name##", name);
        xmlReplace(code, "##item##", item);
        xmlReplace(code, "##zrm##", zrm);
        xmlReplace(code, "##rm##", rm);
        xmlReplace(code, "##process##", PROCESS);
        xmlReplace(code, "##complex##", COMPLEX);
        xmlReplace(code, "##homgrm##", mc.getNamePrefix() == "zz" ? "rm" : mc.getNamePrefix());

        if (mc.GetOwnerControl() != null)
          xmlReplace(code, "##mgowner##", mc.GetOwnerControl().getNamePost());

        removeListIsTags(code, "##<is_" + mc.getNamePrefix() + ">##");


        MyTrigClass trg;
        if (rm == "inv_complex") {
          trg = mc.GetOwnerObj().GetModule().GetTrig("trg_" + levelName + "_inv_deploy_init");
        }
        else {
          trg = mc.GetOwnerObj().GetModule().GetTrig("trg_" + rm + "_init_" + tp);
        }

        if (dopCMD != "mul")
          FSaver.Copy("res\\" + tp + "\\" + tp + "_spr_inv.png", repDir + "exe\\" + mc.GetDefResName() + "inv\\" + "inv_" + name + ".png"); // копировать в папку //inv если нужно
        else
          FSaver.Copy("res\\" + tp + "\\" + tp + "_spr_inv.png", repDir + "exe\\" + mc.GetDefResName() + "inv\\" + "inv_" + name + ".png"); // копировать в папку //inv если нужно

        //MessageBox.Show("res\\" + tp + "\\" + tp + "_spr_obj.png" + "\n" + gameDir + "exe\\" + mc.GetDefResName() + name + ".png");
        FSaver.Copy("res\\" + tp + "\\" + tp + "_spr_obj.png", repDir + "exe\\" + mc.GetDefResName() + "layers\\" + name + ".png"); // копировать в папку //layers или //anim если нужно
        OBJ.SetPropertie("res", mc.GetDefResName() + "layers\\" + name);


        ProgressAdd(prg, prg_creation_before);

        gameHint.AddHint(code, mc.GetOwnerObj().GetModule());
        //Debag(progress_names);

        //Debag(code);

        if (mc.getNamePrefix() == "inv") {
          FSaver.FolderCreate(repDir + "exe\\" + mc.GetDefResName() + "\\state");
        }

        if (prg_creation_before != "") {
          id = FindId(trg.GetCode(), "common_impl.hint[ \"" + prg_creation_before + "\" ]") - 1;
        }
        if (id < 0) {
          if (mc.getNamePrefix() == "zz" || mc.getNamePrefix() == "inv") {
            id = FindId(trg.GetCode(), "-- function *** PROGRESS ZZ " + mc.GetName() + " *** () end");
            if (id == -1) {

              id = FindId(trg.GetCode(), "-- function *** PROGRESS MISC *** () end");
              if (id < 0) {
                MessageBox.Show("Нужно добавить -- function *** PROGRESS MISC *** () end в модуль " +
                                mc.GetOwnerObj().ownerModule.GetName());
              }
              id -= 1;

              trg.GetCode().Insert(id, razdel);
              trg.GetCode().Insert(id, "-- function *** PROGRESS ZZ " + mc.GetName() + " *** () end");
              trg.GetCode().Insert(id, razdel);

              id += 3;

            }
            else {
              int lid = -1;
              lid = FindId(trg.GetCode(), "-- function *** PROGRESS ZZ ", id + 1);
              if (lid > -1)
                id = lid - 1;
              else {
                id = FindId(trg.GetCode(), "-- function *** PROGRESS MISC *** () end") - 1;
                if (id < 0) {
                  MessageBox.Show("Нужно добавить -- function *** PROGRESS MISC *** () end в модуль " +
                                  mc.GetOwnerObj().ownerModule.GetName());
                }
              }
            }
          }
          else {
            id = FindId(trg.GetCode(), "-- function *** PROGRESS ZZ ");
            if (id < 0) {
              id = FindId(trg.GetCode(), "-- function *** PROGRESS MISC *** () end");
              if (id < 0) {
                MessageBox.Show("Нужно добавить -- function *** PROGRESS MISC *** () end в модуль " +
                                mc.GetOwnerObj().ownerModule.GetName());
              }
            }
            id -= 1;

          }
        }
        trg.AddListToCode(code, id);

        List<MyObjClass> l = mc.GetAllObjs();
        int objCount = 0;
        for (int i = 1; i < l.Count; i++) {
          if (l[i].GetPropertie("event_mdown").IndexOf(".get_") > -1)
            objCount++;
        }
        OBJ.SetPropertie("pos_x", (-190 + objCount * ObjsOnCreateMoveWidth + (mc.IsSubroomType ? 0 : 240)).ToString());
        OBJ.SetPropertie("pos_y", (110 + (mc.IsSubroomType ? 0 : 240)).ToString());
        OBJ.AddTexObjText(tp.ToUpper() + " " + name.Replace("_", " "));


      }

      #endregion
      #region tp == "clk"

      else if (tp == "clk") {
        string name = nm;
        List<string> obj = LoadXML(@"res/" + tp + "/" + tp + "_zone.xml");
        xmlReplace(obj, "##prg##", prg);
        xmlReplace(obj, "##name##", name);
        xmlReplace(obj, "##zrm##", zrm);
        xmlReplace(obj, "##rm##", rm);
        xmlReplace(obj, "##homgrm##", homgrm);
        if (mc.getNamePrefix() == "inv")
          xmlReplace(obj, "inv_inv_complex", levelName + "_inv");

        MyObjClass OBJ = mc.GetOwnerObj().ObjsLoader(obj, 0);

        List<string> code = LoadXML(@"res/" + tp + "/" + tp + "_func_" + mc.getNamePrefix() + ".xml");
        xmlReplace(code, "##prg##", prg);
        xmlReplace(code, "##name##", name);
        xmlReplace(code, "##zrm##", zrm);
        xmlReplace(code, "##rm##", rm);
        xmlReplace(code, "##homgrm##", homgrm);

        if (scheme != null) {
          Action action = scheme.GetActionByPrgName(prg);
          xmlReplace(code, "##sfx##", action != null ? action.getSFXname() : "0");
        }
        else {
          xmlReplace(code, "##sfx##", "aud_" + prg + "_" + rm);
        }

        if (mc.GetOwnerControl() != null)
          xmlReplace(code, "##mgowner##", mc.GetOwnerControl().getNamePost());

        removeListIsTags(code, "##<is_" + mc.getNamePrefix() + ">##");

        MyTrigClass trg;
        if (rm == "inv_complex")
          trg = mc.GetOwnerObj().GetModule().GetTrig("trg_" + levelName + "_inv_deploy_init");
        else
          trg = mc.GetOwnerObj().GetModule().GetTrig("trg_" + rm + "_init_" + tp);

        ProgressAdd(prg, prg_creation_before);

        gameHint.AddHint(code, mc.GetOwnerObj().GetModule());
        //Debag(progress_names);

        if (prg_creation_before != "") {
          id = FindId(trg.GetCode(), "common_impl.hint[ \"" + prg_creation_before + "\" ]") - 1;
        }
        if (id < 0) {
          if (mc.getNamePrefix() == "zz" || mc.getNamePrefix() == "inv") {
            id = FindId(trg.GetCode(), "-- function *** PROGRESS ZZ " + mc.GetName() + " *** () end");
            if (id == -1) {

              id = FindId(trg.GetCode(), "-- function *** PROGRESS MISC *** () end");
              if (id < 0) {
                MessageBox.Show("Нужно добавить -- function *** PROGRESS MISC *** () end в модуль " +
                                mc.GetOwnerObj().ownerModule.GetName());
              }
              id -= 1;

              trg.GetCode().Insert(id, razdel);
              trg.GetCode().Insert(id, "-- function *** PROGRESS ZZ " + mc.GetName() + " *** () end");
              trg.GetCode().Insert(id, razdel);

              id += 3;

            }
            else {
              int lid = -1;
              lid = FindId(trg.GetCode(), "-- function *** PROGRESS ZZ ", id + 1);
              if (lid > -1)
                id = lid - 1;
              else {
                id = FindId(trg.GetCode(), "-- function *** PROGRESS MISC *** () end") - 1;
                if (id < 0) {
                  MessageBox.Show("Нужно добавить -- function *** PROGRESS MISC *** () end в модуль " +
                                  mc.GetOwnerObj().ownerModule.GetName());
                }
              }
            }
          }
          else {
            id = FindId(trg.GetCode(), "-- function *** PROGRESS ZZ ");
            if (id < 0) {
              id = FindId(trg.GetCode(), "-- function *** PROGRESS MISC *** () end");
              if (id < 0) {
                MessageBox.Show("Нужно добавить -- function *** PROGRESS MISC *** () end в модуль " +
                                mc.GetOwnerObj().ownerModule.GetName());
              }
            }
            id -= 1;

          }
        }
        trg.AddListToCode(code, id);

        List<MyObjClass> l = mc.GetAllObjs();
        int objCount = 0;
        for (int i = 1; i < l.Count; i++) {
          if (l[i].GetName().EndsWith("_zone") && l[i].GetPropertie("__type") == "partsys_gm"
              && l[i].GetName().IndexOf("_" + tp + "_") > -1)
            objCount++;
        }
        OBJ.SetPropertie("pos_x", (-190 + objCount * ObjsOnCreateMoveWidth + (mc.IsSubroomType ? 0 : 240)).ToString());
        OBJ.SetPropertie("pos_y", (-190 + (mc.IsSubroomType ? 0 : 240)).ToString());
        OBJ.AddTexObjText(tp.ToUpper() + " " + name.Replace("_", " "));
        //Debag(code);
      }

      #endregion
      #region tp == "win"

      else if (tp == "win") {
        string name = nm;
        List<string> obj = LoadXML(@"res/" + tp + "/" + tp + "_zone.xml");
        xmlReplace(obj, "##prg##", prg);
        xmlReplace(obj, "##name##", name);
        xmlReplace(obj, "##zrm##", zrm);
        xmlReplace(obj, "##rm##", rm);

        xmlReplace(obj, "##homgrm##", homgrm);
        if (mc.getNamePrefix() == "inv")
          xmlReplace(obj, "inv_inv_complex", levelName + "_inv");


        MyObjClass OBJ = mc.GetOwnerObj().ObjsLoader(obj, 0);

        List<string> code = LoadXML(@"res/" + tp + "/" + tp + "_func_" + mc.getNamePrefix() + ".xml");
        xmlReplace(code, "##prg##", prg);
        xmlReplace(code, "##name##", name);
        xmlReplace(code, "##zrm##", zrm);
        xmlReplace(code, "##rm##", rm);
        xmlReplace(code, "##homgrm##", homgrm);

        if (mc.GetOwnerControl() != null)
          xmlReplace(code, "##mgowner##", mc.GetOwnerControl().getNamePost());

        removeListIsTags(code, "##<is_" + mc.getNamePrefix() + ">##");

        MyTrigClass trg;
        if (rm == "inv_complex")
          trg = mc.GetOwnerObj().GetModule().GetTrig("trg_" + levelName + "_inv_deploy_init");
        else
          trg = mc.GetOwnerObj().GetModule().GetTrig("trg_" + rm + "_init_" + tp);

        ProgressAdd(prg, prg_creation_before);

        gameHint.AddHint(code, mc.GetOwnerObj().GetModule());
        //Debag(progress_names);


        if (prg_creation_before != "") {
          id = FindId(trg.GetCode(), "common_impl.hint[ \"" + prg_creation_before + "\" ]") - 1;
        }
        if (id < 0) {
          if (mc.getNamePrefix() == "zz" || mc.getNamePrefix() == "inv") {
            id = FindId(trg.GetCode(), "-- function *** PROGRESS ZZ " + mc.GetName() + " *** () end");
            if (id == -1) {

              id = FindId(trg.GetCode(), "-- function *** PROGRESS MISC *** () end");
              if (id < 0) {
                MessageBox.Show("Нужно добавить -- function *** PROGRESS MISC *** () end в модуль " +
                                mc.GetOwnerObj().ownerModule.GetName());
              }
              id -= 1;

              trg.GetCode().Insert(id, razdel);
              trg.GetCode().Insert(id, "-- function *** PROGRESS ZZ " + mc.GetName() + " *** () end");
              trg.GetCode().Insert(id, razdel);

              id += 3;

            }
            else {
              int lid = -1;
              lid = FindId(trg.GetCode(), "-- function *** PROGRESS ZZ ", id + 1);
              if (lid > -1)
                id = lid - 1;
              else {
                id = FindId(trg.GetCode(), "-- function *** PROGRESS MISC *** () end") - 1;
                if (id < 0) {
                  MessageBox.Show("Нужно добавить -- function *** PROGRESS MISC *** () end в модуль " +
                                  mc.GetOwnerObj().ownerModule.GetName());
                }
              }
            }
          }
          else {
            id = FindId(trg.GetCode(), "-- function *** PROGRESS ZZ ");
            if (id < 0) {
              id = FindId(trg.GetCode(), "-- function *** PROGRESS MISC *** () end");
              if (id < 0) {
                MessageBox.Show("Нужно добавить -- function *** PROGRESS MISC *** () end в модуль " +
                                mc.GetOwnerObj().ownerModule.GetName());
              }
            }
            id -= 1;

          }
        }
        trg.AddListToCode(code, id);
        //Debag(code);

        List<MyObjClass> l = mc.GetAllObjs();
        int objCount = 0;
        for (int i = 1; i < l.Count; i++) {
          if (l[i].GetName().EndsWith("_zone") && l[i].GetPropertie("__type") == "partsys_gm"
              && (l[i].GetName().IndexOf("_" + tp + "_") > -1 || l[i].GetName().IndexOf("_dlg_") > -1))
            objCount++;
        }
        OBJ.SetPropertie("pos_x", (-190 + objCount * ObjsOnCreateMoveWidth + (mc.IsSubroomType ? 0 : 240)).ToString());
        OBJ.SetPropertie("pos_y", (-90 + (mc.IsSubroomType ? 0 : 240)).ToString());
        OBJ.AddTexObjText(tp.ToUpper() + " " + name.Replace("_", " "));

      }

      #endregion
      #region tp == "dlg"

      else if (tp == "dlg") {
        string name = nm;
        string namePost = name;
        if(namePost.IndexOf("_")>-1) {
          namePost = namePost.Substring(namePost.IndexOf("_") + 1);
        }
        List<string> obj = LoadXML(@"res/" + tp + "/" + tp + "_zone.xml");
        xmlReplace(obj, "##prg##", prg);
        xmlReplace(obj, "##name##", name);
        xmlReplace(obj, "##name_post##", namePost);
        xmlReplace(obj, "##zrm##", zrm);
        xmlReplace(obj, "##rm##", rm);
        xmlReplace(obj, "##homgrm##", homgrm);
        if (mc.getNamePrefix() == "inv")
          xmlReplace(obj, "inv_inv_complex", levelName + "_inv");

        MyObjClass OBJ = mc.GetOwnerObj().ObjsLoader(obj, 0);
        //Debag("DLG!!!ZONE   " + OBJ.GetName());



        if (mc.getNamePrefix() != "inv") {
          //dialog animation root
          List<string> root = LoadXML(@"res/" + tp + "/" + tp + "_root.xml");
          xmlReplace(root, "##prg##", prg);
          xmlReplace(root, "##name##", name);
          xmlReplace(root, "##name_post##", namePost);
          xmlReplace(root, "##zrm##", zrm);
          xmlReplace(root, "##rm##", rm);
          xmlReplace(root, "##homgrm##", homgrm);

          var dlg_root_obj = mc.GetOwnerObj().GetModule().GetObjs()[0].ObjsLoader(root, 0);
          dlg_root_obj.ReAtachBeforeSave();
          //Debag(dlg_root_obj.GetName() + " >> ReAtachBeforeSave ");
          //Debag(dlg_root_obj. GetName() + " >> ReAtachBeforeSave ");
        }

        //MyObjClass OBJ = mc.GetOwnerObj().ObjsLoader(obj, 0);

        List<string> code = LoadXML(@"res/" + tp + "/" + tp + "_func_" + mc.getNamePrefix() + ".xml");
        xmlReplace(code, "##prg##", prg);
        xmlReplace(code, "##name##", name);
        xmlReplace(code, "##name_post##", namePost);
        xmlReplace(code, "##zrm##", zrm);
        xmlReplace(code, "##rm##", rm);
        xmlReplace(code, "##homgrm##", homgrm);

        if (mc.GetOwnerControl() != null)
          xmlReplace(code, "##mgowner##", mc.GetOwnerControl().getNamePost());

        removeListIsTags(code, "##<is_" + mc.getNamePrefix() + ">##");

        MyTrigClass trg;
        if (rm == "inv_complex")
          trg = mc.GetOwnerObj().GetModule().GetTrig("trg_" + levelName + "_inv_deploy_init");
        else
          trg = mc.GetOwnerObj().GetModule().GetTrig("trg_" + rm + "_init_" + tp);

        ProgressAdd(prg, prg_creation_before);

        gameHint.AddHint(code, mc.GetOwnerObj().GetModule());
        //Debag(progress_names);


        if (prg_creation_before != "") {
          id = FindId(trg.GetCode(), "common_impl.hint[ \"" + prg_creation_before + "\" ]") - 1;
        }
        if (id < 0) {
          if (mc.getNamePrefix() == "zz" || mc.getNamePrefix() == "inv") {
            id = FindId(trg.GetCode(), "-- function *** PROGRESS ZZ " + mc.GetName() + " *** () end");
            if (id == -1) {

              id = FindId(trg.GetCode(), "-- function *** PROGRESS MISC *** () end");

              if (id < 0) {
                MessageBox.Show("Нужно добавить -- function *** PROGRESS MISC *** () end в модуль " +
                                mc.GetOwnerObj().ownerModule.GetName());
              }

              id -= 1;

              trg.GetCode().Insert(id, razdel);
              trg.GetCode().Insert(id, "-- function *** PROGRESS ZZ " + mc.GetName() + " *** () end");
              trg.GetCode().Insert(id, razdel);

              id += 3;

            }
            else {
              int lid = -1;
              lid = FindId(trg.GetCode(), "-- function *** PROGRESS ZZ ", id + 1);
              if (lid > -1)
                id = lid - 1;
              else {
                id = FindId(trg.GetCode(), "-- function *** PROGRESS MISC *** () end") - 1;
                if (id < 0) {
                  MessageBox.Show("Нужно добавить -- function *** PROGRESS MISC *** () end в модуль " +
                                  mc.GetOwnerObj().ownerModule.GetName());
                }
              }
            }
          }
          else {
            id = FindId(trg.GetCode(), "-- function *** PROGRESS ZZ ");
            if (id < 0) {
              id = FindId(trg.GetCode(), "-- function *** PROGRESS MISC *** () end");
              if (id < 0) {
                MessageBox.Show("Нужно добавить -- function *** PROGRESS MISC *** () end в модуль " +
                                mc.GetOwnerObj().ownerModule.GetName());
              }
            }
            id -= 1;

          }
        }
        trg.AddListToCode(code, id);
        //Debag(code);

        List<MyObjClass> l = mc.GetAllObjs();
        int objCount = 0;
        for (int i = 1; i < l.Count; i++) {
          if (l[i].GetName().EndsWith("_zone") && l[i].GetPropertie("__type") == "partsys_gm"
              && (l[i].GetName().IndexOf("_" + tp + "_") > -1 || l[i].GetName().IndexOf("_win_") > -1))
            objCount++;
        }
        OBJ.SetPropertie("pos_x", (-190 + objCount * ObjsOnCreateMoveWidth + (mc.IsSubroomType ? 0 : 240)).ToString());
        OBJ.SetPropertie("pos_y", (-90 + (mc.IsSubroomType ? 0 : 240)).ToString());
        OBJ.AddTexObjText(tp.ToUpper() + " " + name.Replace("_", " "));

      }

      #endregion
      #region tp == "use"

      else if (tp == "use") {
        string name = nm;
        List<string> zone = LoadXML(@"res/" + tp + "/" + tp + "_zone.xml");
        xmlReplace(zone, "##prg##", prg);
        xmlReplace(zone, "##name##", name);
        xmlReplace(zone, "##zrm##", zrm);

        xmlReplace(zone, "##rm##", mc.getNamePrefix() == "inv" ? "inv" : rm);
        xmlReplace(zone, "##homgrm##", mc.getNamePrefix() == "inv" ? "level" : homgrm);


        MyObjClass OBJ = mc.GetOwnerObj().ObjsLoader(zone, 0);

        List<string> code = LoadXML(@"res/" + tp + "/" + tp + "_func_" + mc.getNamePrefix() + ".xml");
        xmlReplace(code, "##prg##", prg);
        xmlReplace(code, "##name##", name);

        if (scheme != null) {
          Action action = scheme.GetActionByPrgName(prg);
          xmlReplace(code, "##sfx##", action != null ? action.getSFXname() : "0");
          xmlReplace(code, "##sfx_xx##", action != null ? action.getSFXnameXX() : "0");
        }

        if (name.IndexOf("_") > -1)
          xmlReplace(code, "##item##", name.Substring(0, name.IndexOf("_")));
        else
          xmlReplace(code, "##item##", name);


        xmlReplace(code, "##zrm##", zrm);

        //xmlReplace(code, "##rm##", rm);
        //xmlReplace(code, "##homgrm##", homgrm);
        xmlReplace(code, "##rm##", mc.getNamePrefix() == "inv" ? "inv" : rm);
        xmlReplace(code, "##homgrm##", mc.getNamePrefix() == "inv" ? "level" : homgrm);


        if (mc.GetOwnerControl() != null)
          xmlReplace(code, "##mgowner##", mc.GetOwnerControl().getNamePost());

        removeListIsTags(code, "##<is_" + mc.getNamePrefix() + ">##");



        //Debag(projectDir + mc.GetDefResName()+"\n"+gameDir);
        MyTrigClass trg;
        if (rm == "inv_complex") {
          trg = mc.GetOwnerObj().GetModule().GetTrig("trg_" + levelName + "_inv_deploy_init");
        }
        else {
          trg = mc.GetOwnerObj().GetModule().GetTrig("trg_" + rm + "_init_" + tp);
        }

        ProgressAdd(prg, prg_creation_before);

        gameHint.AddHint(code, mc.GetOwnerObj().GetModule());
        //Debag(progress_names);

        //Debag(code);


        if (prg_creation_before != "") {
          id = FindId(trg.GetCode(), "common_impl.hint[ \"" + prg_creation_before + "\" ]") - 1;
        }
        if (id < 0) {
          if (mc.getNamePrefix() == "zz" || mc.getNamePrefix() == "inv") {
            id = FindId(trg.GetCode(), "-- function *** PROGRESS ZZ " + mc.GetName() + " *** () end");
            if (id == -1) {

              id = FindId(trg.GetCode(), "-- function *** PROGRESS MISC *** () end");

              if (id < 0) {
                MessageBox.Show("Нужно добавить -- function *** PROGRESS MISC *** () end в модуль " +
                                mc.GetOwnerObj().ownerModule.GetName());
              }
              id -= 1;

              trg.GetCode().Insert(id, razdel);
              trg.GetCode().Insert(id, "-- function *** PROGRESS ZZ " + mc.GetName() + " *** () end");
              trg.GetCode().Insert(id, razdel);

              id += 3;

            }
            else {
              int lid = -1;
              lid = FindId(trg.GetCode(), "-- function *** PROGRESS ZZ ", id + 1);
              if (lid > -1)
                id = lid - 1;
              else {
                id = FindId(trg.GetCode(), "-- function *** PROGRESS MISC *** () end") - 1;
                if (id < 0) {
                  MessageBox.Show("Нужно добавить -- function *** PROGRESS MISC *** () end в модуль " +
                                  mc.GetOwnerObj().ownerModule.GetName());
                }
              }
            }
          }
          else {
            id = FindId(trg.GetCode(), "-- function *** PROGRESS ZZ ");
            if (id < 0) {
              id = FindId(trg.GetCode(), "-- function *** PROGRESS MISC *** () end");
              if (id < 0) {
                MessageBox.Show("Нужно добавить -- function *** PROGRESS MISC *** () end в модуль " +
                                mc.GetOwnerObj().ownerModule.GetName());
              }
            }
            id -= 1;

          }
        }
        trg.AddListToCode(code, id >= 0 ? id : 0);

        List<MyObjClass> l = mc.GetAllObjs();
        int objCount = 0;
        for (int i = 1; i < l.Count; i++) {
          if (l[i].GetName().EndsWith("_zone") && l[i].GetPropertie("__type") == "partsys_gm"
              && l[i].GetPropertie("event_mdown").IndexOf("need") > -1)
            objCount++;
        }
        OBJ.SetPropertie("pos_x", (-190 + objCount * ObjsOnCreateMoveWidth + (mc.IsSubroomType ? 0 : 240)).ToString());
        OBJ.SetPropertie("pos_y", (10 + (mc.IsSubroomType ? 0 : 240)).ToString());
        OBJ.AddTexObjText(tp.ToUpper() + " " + name.Replace("_", " "));


      }

      #endregion

      else {
        ModuleCreation(mc, s, dopCMD);
      }
      //}
      //catch
      //{
      //    MessageBox.Show("Не удалось создать прогрес \nprg -> " + prg + "\n zrm -> " + zrm + "\nrm -> " + rm);
      //}
    }

    void removeListIsTags(List<string> code, string need_tag = "") {
      List<string> tags = new List<string>();
      tags.Add("##<is_zz>##");
      tags.Add("##<is_zz_owned>##");
      tags.Add("##<is_mg>##");
      tags.Add("##<is_rm>##");
      tags.Add("##<is_inv>##");
      for (int t = 0; t < tags.Count; t++) {
        string tag = tags[t];
        if (need_tag == tag) {
          xmlReplace(code, tag, "");
        }
        else {
          for (int i = 0; i < code.Count; i++) {
            string line = code[i];
            while (code[i].IndexOf(tag) > -1) {
              string l1 = line.Substring(0, line.IndexOf(tag));
              line = line.Substring(line.IndexOf(tag) + tag.Length);
              string l2 = line.Substring(line.IndexOf(tag) + tag.Length);
              code[i] = l1 + l2;
              line = code[i];
              if (code[i].Length == 0) {
                code.RemoveAt(i);
                i--;
              }
            }
          }
        }
      }
    }

    List<GameObj> orderedList(List<GameObj> l, string[] order) {
      List<GameObj> ord = new List<GameObj>();
      for (int i = 0; i < order.Count() - 1; i++) {
        for (int ii = 0; ii < l.Count; ii++) {

        }
        for (int ii = 0; ii < l.Count & ii > -1; ii++) {

          if (l[ii].name == order[i]) {
            ord.Add(l[ii]);
            l.RemoveAt(ii);
            ii--;
          }
        }
      }
      for (int ii = 0; ii < l.Count & ii > -1; ii++) {
        ord.Add(l[ii]);
        l.RemoveAt(ii);
        ii--;
      }
      return ord;
    }

    bool moduleCreationPrgAdding = true;
    public void ModuleCreationNoPrg(MyControl mc, string s, string dopCMD) {
      //Debag("ModuleCreationNoPrg "+s+"dopCmd");
      moduleCreationPrgAdding = false;
      ModuleCreation(mc, s, dopCMD);
    }

    public void ModuleCreation(MyControl mc, string s, string dopCMD) {

      Debag("ModuleCreation " + s + " " + dopCMD);
      string ct = s.Substring(0, 2);

      bool hoMul = s.Contains("MUL");
      s = s.Replace("MUL", "");
      bool hoComplex = s.Contains("COMPLEX");
      s = s.Replace("COMPLEX", "");

      if (dopCMD.Length > 0) {
        ct = dopCMD.Substring(0, 2);
        string buf = dopCMD;
        dopCMD = s;
        s = buf;
      }
      Debag("s => " + s + "\tct => " + ct + "\tdopCmd => " + dopCMD);
      if (mc == null) {

      }
      else if (ct == "rm") {
        if (!Directory.Exists(levelDir + "\\" + s)) {
          //MessageBox.Show("папка с именем " + levelDir + "\\" + s + " уже существует");
          //return;
          FSaver.FolderCreate(levelDir + "\\" + s); // дополнительно создавать папки //anim //layers //inv
          FSaver.FolderCreate(levelDir + "\\" + s + "\\anims");
          FSaver.FolderCreate(levelDir + "\\" + s + "\\inv");
          FSaver.FolderCreate(levelDir + "\\" + s + "\\layers");
        }

        if (!File.Exists(levelDir + "\\" + s + "\\back.jpg"))
          FSaver.Copy("res\\rm\\back.jpg", levelDir + "\\" + s + "\\back.jpg");

        if (ct != "zz" && !File.Exists(levelDir + "\\" + s + "\\miniback.jpg"))
          FSaver.Copy("res\\rm\\miniback.jpg", levelDir + "\\" + s + "\\miniback.jpg");
        //FSaver.Copy("res\\rm\\rm_rmrmrm.xml", levelDir + "\\" + s + "\\mod_"+s.Substring(3)+".xml");

        List<string> xml = LoadXML("res\\rm\\rm_rmrmrm.xml");
        xmlReplace(xml, "##rm##", s.Substring(3));

        xmlReplace(xml, "##lvl##", levelName);
        if (levelName == "levelext")
          xmlReplace(xml, "##global_progress##", "ext");
        else
          xmlReplace(xml, "##global_progress##", "std");


        List<string> lua = LoadXML("res\\rm\\rm_rmrmrm.lua");
        xmlReplace(lua, "##rm##", s.Substring(3));

        xmlReplace(lua, "##lvl##", levelName);
        if (levelName == "levelext")
          xmlReplace(lua, "##global_progress##", "ext");
        else
          xmlReplace(lua, "##global_progress##", "std");

        modules.Add(new ModuleClass(xml, lua));
        // добавляем комнату в ng_var.room_names
        //int id1 =

        ProgressAddRoom(s);
        if (moduleCreationPrgAdding)
          ProgressAdd("opn_" + s.Substring(3), "");

        List<string> grm_back = LoadXML("res\\rm\\grm_back.xml");
        xmlReplace(grm_back, "##rm##", s.Substring(3));
        xmlReplace(grm_back, "##brm##", mc.GetName().Substring(3));
        modules[modules.Count - 1].GetMainRoomControl().GetOwnerObj().ObjsLoader(grm_back, 0);
        modules[modules.Count - 1].GetMainRoomControl().AttachTo(mc);

        List<string> grm_forward = LoadXML("res\\rm\\grm_forward.xml");
        try {
          FSaver.Copy("res\\rm\\gate_trmtrmtrm.png", levelDir + "\\" + mc.GetName() + "\\layers" + "\\grm_rm_" + s.Substring(3) + ".png");
        }
        catch {

        }
        xmlReplace(grm_forward, "##rm##", mc.GetName().Substring(3));
        xmlReplace(grm_forward, "##trm##", s.Substring(3));
        MyObjClass addedObj = mc.GetOwnerObj().ObjsLoader(grm_forward, 0);

        int grmCount = 0;
        List<MyControl> ch = mc.GetChilds();
        for (int i = 0; i < ch.Count; i++) {
          if (ch[i].GetName().StartsWith("rm_") | ch[i].GetName().StartsWith("ho_") | ch[i].GetName().StartsWith("mg_"))
            grmCount++;
        }
        addedObj.SetPropertie("pos_x", (-75 + grmCount * 150).ToString());
        addedObj.SetPropertie("pos_y", "575");
        addedObj.AddTexObjText(ct.ToUpper() + " " + s.Substring(3));



      }
      else if (ct == "zz") {

        string owner_rm_name = mc.getNamePrefix() == "zz" ? mc.GetOwnerControl().GetName() : mc.GetName();

        if (Directory.Exists(levelDir + "\\" + owner_rm_name + "\\" + s) && GetObj(s) != null) {
          MessageBox.Show("Control с именем " + s + " уже существует");
          return;
        }
        else {
          FSaver.FolderCreate(levelDir + "\\" + owner_rm_name + "\\" + s); // дополнительно создавать папки //anim //layers //inv
          FSaver.FolderCreate(levelDir + "\\" + owner_rm_name + "\\" + s + "\\anims");
          FSaver.FolderCreate(levelDir + "\\" + owner_rm_name + "\\" + s + "\\inv");
          FSaver.FolderCreate(levelDir + "\\" + owner_rm_name + "\\" + s + "\\layers");
          FSaver.FolderCreate(levelDir + "\\" + owner_rm_name + "\\layers" + "\\" + s ); // папка для трешиков/пэтчей при вписке ЗумЗон в локацию
        }

        FSaver.Copy("res\\zz\\back.jpg", levelDir + "\\" + owner_rm_name + "\\" + s + "\\back.jpg", false);

        //subroom
        List<string> xml = LoadXML("res\\zz\\zz_zzzzzz.xml");
        xmlReplace(xml, "##zz##", s.Substring(3));

        MyObjClass obj = new MyObjClass(xml, 0, mc.GetOwnerObj().GetModule());
        List<MyObjClass> l = mc.GetOwnerObj().GetModule().GetObjs()[0].objs;
        l.Insert(0, obj);
        obj.SetPropertie("res", "assets/levels/" + levelName + "/" + owner_rm_name + "/" + s + "/back");

        //stock particle
        List<string> particlexml = LoadXML("res\\zz\\zz_zzzzzz_stock_particle.xml");
        xmlReplace(particlexml, "##zz##", s.Substring(3));
        MyObjClass particleobj = new MyObjClass(particlexml, 0, mc.GetOwnerObj().GetModule());
        obj.objAddAt(particleobj, 0);

        obj.GetMyControl().AttachTo(mc);
        //gzz
        List<string> gzzxml = LoadXML("res\\zz\\gzz_rmrmrm_zzzzzz.xml");
        xmlReplace(gzzxml, "##zz##", s.Substring(3));
        xmlReplace(gzzxml, "##rm##", mc.GetName().Substring(3));
        MyObjClass gzzobj = new MyObjClass(gzzxml, 0, mc.GetOwnerObj().GetModule());

        List<string> objxml = LoadXML("res\\zz\\obj_rmrmrm_zzzzzz.xml"); //объект рут для трешей/патчей при вписке ЗЗ в локацию
        xmlReplace(objxml, "##zz##", s.Substring(3));
        xmlReplace(objxml, "##rm##", mc.GetName().Substring(3));
        MyObjClass objobj = new MyObjClass(objxml, 0, mc.GetOwnerObj().GetModule());

        int zzCount = 0;
        if (mc.getNamePrefix() == "zz") {
          List<MyControl> ch = mc.GetChilds();
          for (int i = 0; i < ch.Count; i++) {
            if (ch[i].getNamePrefix() == "zz")
              zzCount++;
          }
        }
        else {
          foreach (var v in mc.GetChilds()) {
            if (v.getNamePrefix() == "zz") {
              zzCount++;
            }
          }
        }
        Debag("\n\n\n" + mc.GetName() + " " + zzCount + "\n\n\n");
        gzzobj.SetPropertie("pos_x", (-50 + 100 * zzCount).ToString());
        gzzobj.SetPropertie("pos_y", "450");
        mc.GetOwnerObj().objAddAt(gzzobj, 0);
        gzzobj.AddTexObjText(ct.ToUpper() + " " + s.Substring(3));

        mc.GetOwnerObj().objAddAt(objobj, 0);


        List<string> trg = mc.GetOwnerObj().GetModule().GetTrigCode("trg_" + mc.GetName().Substring(3) + "_init");

        int id = FindId(trg, "function private.InitZz()") + 1;
        List<string> zz_init = LoadXML("res\\zz\\zz_zzzzzz_init.xml");
        xmlReplace(zz_init, "##zz##", s.Substring(3));

        xmlReplace(zz_init, "##zz_owner##", mc.getNamePost());
        removeListIsTags(zz_init, mc.getNamePrefix() == "zz" ? "##<is_zz_owned>##" : "");

        mc.GetOwnerObj().GetModule().GetTrig("").AddListToCode(zz_init, id);


      }
      else if (ct == "ho") {

        s = s.Replace("COMPLEX", "");

        FSaver.FolderCreate(levelDir + "\\" + s); // дополнительно создавать папки //anim //layers //inv
        FSaver.FolderCreate(levelDir + "\\" + s + "\\anims");
        FSaver.FolderCreate(levelDir + "\\" + s + "\\inv");
        FSaver.FolderCreate(levelDir + "\\" + s + "\\layers");
        FSaver.Copy("res\\ho\\back.jpg", levelDir + "\\" + s + "\\back.jpg");
        if (ct != "zz") FSaver.Copy("res\\ho\\miniback.jpg", levelDir + "\\" + s + "\\miniback.jpg");
        //FSaver.Copy("res\\ho\\ho_hohoho.xml", levelDir + "\\" + s + "\\mod_" + s.Substring(3) + ".xml");

        FSaver.Copy("res\\ho\\ho_obj.png", levelDir + "\\" + s + "\\layers" + "\\aaa.png");
        FSaver.Copy("res\\ho\\ho_obj.png", levelDir + "\\" + s + "\\layers" + "\\bbb.png");
        FSaver.Copy("res\\ho\\ho_obj.png", levelDir + "\\" + s + "\\layers" + "\\ccc.png");
        FSaver.Copy("res\\ho\\ho_obj.png", levelDir + "\\" + s + "\\layers" + "\\ddd.png");
        FSaver.Copy("res\\ho\\ho_obj.png", levelDir + "\\" + s + "\\layers" + "\\eee.png");
        FSaver.Copy("res\\ho\\ho_obj.png", levelDir + "\\" + s + "\\layers" + "\\fff.png");
        FSaver.Copy("res\\ho\\ho_obj.png", levelDir + "\\" + s + "\\layers" + "\\ggg.png");
        FSaver.Copy("res\\ho\\ho_obj.png", levelDir + "\\" + s + "\\layers" + "\\hhh.png");
        FSaver.Copy("res\\ho\\ho_obj.png", levelDir + "\\" + s + "\\layers" + "\\iii.png");
        FSaver.Copy("res\\ho\\ho_obj.png", levelDir + "\\" + s + "\\layers" + "\\jjj.png");
        FSaver.Copy("res\\ho\\ho_obj.png", levelDir + "\\" + s + "\\layers" + "\\kkk.png");
        FSaver.Copy("res\\ho\\ho_obj.png", levelDir + "\\" + s + "\\layers" + "\\lll.png");

        //FSaver.Copy("res\\ho\\inv.png", levelDir + "\\" + s + "\\inv_"+dopCMD+".png");
        //FSaver.Copy("res\\ho\\obj.png", levelDir + "\\" + s + "\\layers\\" + dopCMD.Substring(4) + ".png");

        //FSaver.Copy("res\\get\\get_spr_inv.png", levelDir + "\\" + s + "\\inv_" + dopCMD.Substring(4) + ".png");
        //FSaver.Copy("res\\get\\get_spr_obj.png", levelDir + "\\" + s + "\\"+dopCMD.Substring(4) + ".png");

        if (dopCMD == "")
          dopCMD = "auto";

        List<string> xml = LoadXML("res\\ho\\ho_hohoho.xml");
        //for (int i = 0; i < xml.Count; i++)
        //{
        //    xml[i] = xml[i].Replace("##rm##", s.Substring(3));
        //    xml[i] = xml[i].Replace("##rmowner##", mc.getNamePost());
        //    xml[i] = xml[i].Replace("##inv##", dopCMD.Substring(4));
        //    xml[i] = xml[i].Replace("##lvl##", levelName);

        //    if (levelName == "levelext")
        //        xml[i] = xml[i].Replace("##global_progress##", "ext");
        //    else
        //        xml[i] = xml[i].Replace("##global_progress##", "std");

        //}

        xmlReplace(xml,"##rm##", s.Substring(3));
        xmlReplace(xml,"##rmowner##", mc.getNamePost());
        xmlReplace(xml,"##inv##", dopCMD.Substring(4));
        xmlReplace(xml,"##lvl##", levelName);

        if (levelName == "levelext")
          xmlReplace(xml,"##global_progress##", "ext");
        else
          xmlReplace(xml,"##global_progress##", "std");



        List<string> lua = LoadXML("res\\ho\\ho_hohoho.lua");
        //for (int i = 0; i < lua.Count; i++)
        //{
        //    lua[i] = lua[i].Replace("##rm##", s.Substring(3));
        //    lua[i] = lua[i].Replace("##rmowner##", mc.getNamePost());
        //    lua[i] = lua[i].Replace("##inv##", dopCMD.Substring(4));
        //    lua[i] = lua[i].Replace("##lvl##", levelName);

        //    if (levelName == "levelext")
        //        lua[i] = lua[i].Replace("##global_progress##", "ext");
        //    else
        //        lua[i] = lua[i].Replace("##global_progress##", "std");
        //}

        xmlReplace(lua,"##rm##", s.Substring(3));
        xmlReplace(lua, "##rmowner##", mc.getNamePost());

        if (hoMul) {
          try {
            Convert.ToInt16(dopCMD.Substring(dopCMD.Length - 1));
            xmlReplace(lua, "##inv##", dopCMD.Substring(4, dopCMD.Length - 5));
            if (hoComplex) {
              xmlReplace(lua, "##complex##", "\n    ObjSet( \"" + ("inv_" + dopCMD.Substring(4,
                         dopCMD.Length - 5) ) + "\", { drag = 0; })");
            }
          }
          catch {
            xmlReplace(lua, "##inv##", dopCMD.Substring(4));
            if (hoComplex) {
              xmlReplace(lua, "##complex##", "\n    ObjSet( \"" + ("inv_" + dopCMD.Substring(4)) + "\", { drag = 0; })");
            }
          }
        }
        else {
          xmlReplace(lua, "##inv##", dopCMD.Substring(4));
          if (hoComplex) {
            xmlReplace(lua, "##complex##", "\n    ObjSet( \"" + ("inv_" + dopCMD.Substring(4)) + "\", { drag = 0; })");
          }
        }
        xmlReplace(lua, "##complex##", "");


        xmlReplace(lua, "##lvl##", levelName);

        if (levelName == "levelext")
          xmlReplace(lua, "##global_progress##", "ext");
        else
          xmlReplace(lua, "##global_progress##", "std");

        ModuleClass homod = new ModuleClass(xml, lua);

        modules.Add(homod);
        //InvAdd(modules[modules.Count-1].GetMainRoomControl(), dopCMD);

        ProgressAddRoom(s);
        if (moduleCreationPrgAdding) {
          ProgressAdd("opn_" + s.Substring(3), "");
          ProgressAdd("win_" + s.Substring(3), "");
        }

        List<string> grm_back = LoadXML("res\\rm\\grm_back.xml");
        xmlReplace(grm_back, "##rm##", s.Substring(3));
        xmlReplace(grm_back, "##brm##", mc.getNamePost());
        modules[modules.Count - 1].GetMainRoomControl().GetOwnerObj().ObjsLoader(grm_back, 0);
        modules[modules.Count - 1].GetMainRoomControl().AttachTo(mc);


        List<string> grm_forward = LoadXML("res\\ho\\gho_forward.xml");
        xmlReplace(grm_forward, "##rm##", mc.GetName().Substring(3));
        xmlReplace(grm_forward, "##trm##", s.Substring(3));
        MyObjClass addedObj = mc.GetOwnerObj().ObjsLoader(grm_forward, 0);

        int grmCount = 0;
        List<MyControl> ch = mc.GetChilds();
        for (int i = 0; i < ch.Count; i++) {
          if (ch[i].GetName().StartsWith("rm_") | ch[i].GetName().StartsWith("ho_") | ch[i].GetName().StartsWith("mg_"))
            grmCount++;
        }
        addedObj.SetPropertie("pos_x", (-75 + grmCount * 150).ToString());
        addedObj.SetPropertie("pos_y", "575");
        addedObj.AddTexObjText(ct.ToUpper() + " " + s.Substring(3));


        MyObjClass inv = GetObj("spr_" + s.Substring(3) + "_win");
        inv.SetPropertie("active", "0");
        inv.SetPropertie("visible", "0");
        inv.SetPropertie("input", "0");
        inv.SetPropertie("_name", "spr_" + s.Substring(3) + "_win");
        inv.SetMyObjClassName("spr_" + s.Substring(3) + "_win");

        if (hoMul) {
          MyControl hoc = GetControl(s);
          if (s == null) {
            // MessageBox.Show("Ошибка при создании мульти гета\n"+s+"\n"+dopCMD);
            Debag("Ошибка при создании мульти гета для ХО\n" + s + "\n" + dopCMD);
          }
          else {
            //MessageBox.Show("Пробуем создать мульти гет для ХО\n" + s+"\n"+dopCMD);
            Debag("Пробуем создать мульти гет для ХО\n" + s + "\n" + dopCMD+ "\nmul" +
                  (hoComplex ? "COMPLEX" : ""));

            ProgressAddEnabled = false;
            PrgCreation(hoc, "get_" + dopCMD.Substring(4), "mul"+(hoComplex?"COMPLEX":""));
            ProgressAddEnabled = true;

            var myGetObj = GetObj("spr_" + s.Substring(3) + "_" + dopCMD.Substring(4));
            if(myGetObj!=null) {
              myGetObj.Delete();
            }
          }
        }

        //inv.GetObjsList().RemoveAt(0);
        //
      }
      else if (ct == "mg") {
        //if (Directory.Exists(levelDir + "\\" + s))
        //{
        //    //MessageBox.Show("папка с именем " + levelDir + "\\" + s + " уже существует");
        //    return;
        //}
        /*
          try
          {
            Directory.CreateDirectory(levelDir + "\\" + s);
          }
          catch
          {
            //MessageBox.Show("не удалось создать папку с именем " + levelDir + "\\" + s);
          }*/
        FSaver.FolderCreate(levelDir + "\\" + s); // дополнительно создавать папки //anim //layers //inv
        FSaver.FolderCreate(levelDir + "\\" + s + "\\anims");
        FSaver.FolderCreate(levelDir + "\\" + s + "\\inv");
        FSaver.FolderCreate(levelDir + "\\" + s + "\\layers");
        FSaver.Copy("res\\mg\\back.jpg", levelDir + "\\" + s + "\\back.jpg");
        FSaver.Copy("res\\mg\\miniback.jpg", levelDir + "\\" + s + "\\miniback.jpg");
        //FSaver.Copy("res\\mg\\mg.xml", levelDir + "\\" + s + "\\mod_" + s.Substring(3) + ".xml");

        List<string> xml = LoadXML("res\\mg\\mg_mgmgmg.xml");
        for (int i = 0; i < xml.Count; i++) {
          xml[i] = xml[i].Replace("##rm##", s.Substring(3));
          xml[i] = xml[i].Replace("##lvl##", levelName);

          if (levelName == "levelext")
            xml[i] = xml[i].Replace("##global_progress##", "ext");
          else
            xml[i] = xml[i].Replace("##global_progress##", "std");

          //xml[i] = xml[i].Replace("##prg##", "std");
          //xml[i] = xml[i].Replace("##rm##", this.Name.Substring(3));
        }
        List<string> lua = LoadXML("res\\mg\\mg_mgmgmg.lua");
        for (int i = 0; i < lua.Count; i++) {
          lua[i] = lua[i].Replace("##rm##", s.Substring(3));
          //xml[i] = xml[i].Replace("##prg##", "std");
          lua[i] = lua[i].Replace("##rmowner##", mc.getNamePost());

          if (levelName == "levelext")
            lua[i] = lua[i].Replace("##global_progress##", "ext");
          else
            lua[i] = lua[i].Replace("##global_progress##", "std");
        }
        modules.Add(new ModuleClass(xml, lua));

        ProgressAddRoom(s);
        if (moduleCreationPrgAdding)
          ProgressAdd("win_" + s.Substring(3), "");

        List<string> grm_back = LoadXML("res\\rm\\grm_back.xml");
        xmlReplace(grm_back, "##rm##", s.Substring(3));
        xmlReplace(grm_back, "##brm##", mc.getNamePost());
        modules[modules.Count - 1].GetMainRoomControl().GetOwnerObj().ObjsLoader(grm_back, 0);
        modules[modules.Count - 1].GetMainRoomControl().AttachTo(mc);

        List<string> grm_forward = LoadXML("res\\mg\\gmg_forward.xml");
        xmlReplace(grm_forward, "##rmowner##", mc.getNamePost());
        xmlReplace(grm_forward, "##rm##", s.Substring(3));
        MyObjClass addedObj = mc.GetOwnerObj().ObjsLoader(grm_forward, 0);

        int grmCount = 0;
        List<MyControl> ch = mc.GetChilds();
        for (int i = 0; i < ch.Count; i++) {
          if (ch[i].GetName().StartsWith("rm_") | ch[i].GetName().StartsWith("ho_") | ch[i].GetName().StartsWith("mg_"))
            grmCount++;
        }
        addedObj.SetPropertie("pos_x", (-75 + grmCount * 150).ToString());
        addedObj.SetPropertie("pos_y", "575");
        addedObj.AddTexObjText(ct.ToUpper() + " " + mc.getNamePost());


      }

      DrawScreen();

      //SaveProject();
      moduleCreationPrgAdding = true;
      TreeViewBuild();

    }

    #region XML
    public int FindId(List<string> l, string find) {
      for (int i = 0; i < l.Count; i++) {
        if (l[i].IndexOf(find) > -1) {
          return i;
        }
      }
      return -1;
    }
    public int FindId(List<string> l, List<string> find, bool identical) {
      for (int i = 0; i < l.Count; i++) {
        for (int j = 0; j < find.Count; j++) {
          if ((i + j) < l.Count && l[i + j] != find[j]) {
            break;
          }
          if (j == find.Count - 1)
            return i;
        }
      }
      return -1;
    }
    public int FindId(List<string> l, string find, bool identical) {
      int id = FindId(l, find, 0);
      while (id > -1) {
        if (l[id] == find)
          return id;
        else
          id = FindId(l, find, id + 1);
      }
      return -1;
    }
    public int FindId(List<string> l, string find, int begin) {
      for (int i = begin; i < l.Count; i++) {
        if (l[i].IndexOf(find) > -1) {
          return i;
        }
      }
      return -1;
    }

    public int FindId(List<string> l, string find, int begin, int end) {
      for (int i = begin; i < l.Count; i++) {
        if(i>end) {
          return -1;
        }
        if (l[i].IndexOf(find) > -1) {
          return i;
        }
      }
      return -1;
    }
    public void xmlReplace(List<string> xml, string find, string replace) {
      for (int i = 0; i < xml.Count; i++) {
        xml[i] = xml[i].Replace(find, replace);
        xml[i] = xml[i].Replace("##lvl##", levelName);

        if (levelName == "levelext")
          xml[i] = xml[i].Replace("##global_progress##", "ext");
        else
          xml[i] = xml[i].Replace("##global_progress##", "std");
      }
    }

    Dictionary<List<string>, bool> xmlReloadDict = new Dictionary<List<string>, bool>();
    public void xmlReload(List<string> list, string is_in_string = null) {
      //Console.WriteLine("BEG!!!");
      int count = 0;
      int id = list[count].IndexOf("><");
      string s1, s2;
      while (id > -1) {
        if ((id + 1) < list[count].Length) {
          s1 = list[count].Substring(0, id + 1);
          count++;
          if (count == list.Count) {
            list.Insert(count, list[count - 1].Substring(id + 1));
          }
          list[count - 1] = s1;
        }
        else {
          count++;
        }
        if (count < list.Count)
          id = list[count].IndexOf("><");
        else
          id = -1;
        //Console.WriteLine(list[count - 1]);

      }
      if (is_in_string != null) {
        for (int i = 0; i < list.Count; i++) {
          int find = list[i].IndexOf(is_in_string);
          if (find == -1) {
            list.RemoveAt(i);
            i--;
          }
        }
      }
      //Console.WriteLine("END!!!");
    }
    #endregion
    public void BuildPRG() {

      progress_names = GetMassiveList(levelInit, "  game.progress_names =");

      try {
        for (int i = 0; i < progress_names.Count; i++) {
          string name = progress_names[i].Substring(4);
          int num = 0;

          if (name.IndexOf("_") > -1) {
            num = Convert.ToInt32(name.Substring(name.IndexOf("_") + 1)) - 1;
            name = name.Substring(0, name.IndexOf("_"));
          }
          //Debag(progress_names[i]);
          if (progress_names[i].IndexOf("get_") == 0) {

          }
          else if (progress_names[i].IndexOf("use_") == 0) {

          }
          else if (progress_names[i].IndexOf("clk_") == 0) {

          }
        }
      }
      catch {

      }

    }

    private bool ProgressAddEnabled = true;
    public void ProgressAdd(string prg, string prg_before) {
      if (!ProgressAddEnabled)
        return;

      //id = FindId(levelInit, "}", FindId(levelInit, "ng_var.progress_names"));
      Debag(prg + "   " + FindId(levelInit, "  game.progress_names ="));

      if (prg_before == "") {
        progress_names.Add(prg);
        levelInit.Insert(FindId(levelInit, "  };", FindId(levelInit, "  game.progress_names =")),
                         "--[[AUTO]]  ,\"" + prg + "\"");
      }
      else {
        for (int i = 0; i < progress_names.Count; i++) {
          if (progress_names[i] == prg_before) {
            progress_names.Insert(i, prg);
            break;
          }
        }
        int id = FindId(levelInit, "  game.progress_names =");
        id = FindId(levelInit, "\"" + prg_before + "\"", id);
        levelInit.Insert(id, "--[[AUTO]]  ,\"" + prg + "\"");
      }
    }
    public void ProgressAddRoom(string room) {
      //id = FindId(levelInit, "}", FindId(levelInit, "ng_var.progress_names"));
      room_names.Add(room);
      levelInit.Insert(FindId(levelInit, "  };", FindId(levelInit, "  game.room_names =")), "--[[AUTO]]  ,\"" + room + "\"");
    }


    public void InvAdd(MyControl mc, string inv) {
      List<string> l = LoadXML("res\\get\\inv.xml");
      xmlReplace(l, "##inv##", inv);
      List<MyObjClass> mol = InvMod.GetObjsList()[0].GetObjsList()[0].GetObjsList();
      for (int i = 0; i < mol.Count; i++) {
        if (mol[i].GetName() == "inv_" + inv) {
          return;
        }
      }
      MyObjClass obj = InvMod.GetObjsList()[0].GetObjsList()[0].ObjsLoader(l, 0);

      //Debag("\n\n!!!!!!!!\n" + obj.GetName() +"\n"+ obj.GetModule().GetName()  + "\n!!!!!!!!\n\n");
      //mc.GetOwnerObj().ObjsLoader(l,0);
      if (mc.getNamePrefix() == "rm") {
        obj.SetPropertie("res", mc.GetOwnerObj().GetPropertie("res").Substring(0,
                         mc.GetOwnerObj().GetPropertie("res").LastIndexOf("/") + 1) + "inv_" + inv);
      }
      else {
        obj.SetPropertie("res", mc.GetOwnerObj().GetPropertie("res").Substring(0,
                         mc.GetOwnerObj().GetPropertie("res").LastIndexOf("/") + 1) + "inv_" + inv);
      }
      //obj.SetPropertie("res", mc.GetOwnerObj().GetPropertie("res").Substring(0, mc.GetOwnerObj().GetPropertie("res").Length - 4) + "inv_"+inv );
    }
    public bool InvAddMul(MyControl mc, string inv) {
      List<string> l = LoadXML("res\\get\\inv_mul_get.xml");
      xmlReplace(l, "##inv##", inv);
      List<MyObjClass> mol = InvMod.GetObjsList()[0].GetObjsList()[0].GetObjsList();
      for (int i = 0; i < mol.Count; i++) {
        if (mol[i].GetName() == "inv_" + inv) {
          return false;
        }
      }
      MyObjClass obj = InvMod.GetObjsList()[0].GetObjsList()[0].ObjsLoader(l, 0);
      return true;
    }

    private void panel1_Resize(object sender, EventArgs e) {
      DrawScreen();
    }

    // Open writer's logic file dialog
    private void buttonLoadLogic_Click(object sender, EventArgs e) {
      openFileDialogLoadLogic.Filter = "Файлы BlueLogic (*.logic)|*.logic";
      openFileDialogLoadLogic.ShowDialog();
    }

    //Объекты для загрузки данных от писателей


    // Copy the content of the opened file to the objects
    private void openFileDialogLoadLogic_FileOk(object sender, CancelEventArgs e) {
      //program.logic.load(openFileDialogLoadLogic.FileName);
      LogicParsing();
    }


    void LogicParsing() {

      RePlace();


    }

    public MyControl GetControl(string name,
                                [CallerMemberName] string memberName = "",
                                [CallerFilePath] string sourceFilePath = "",
                                [CallerLineNumber] int sourceLineNumber = 0) {
      //MessageBox.Show("GetControl\n\t" + memberName + "\n\t" + sourceFilePath + "\n\t" + sourceLineNumber);

      List<MyObjClass> rl = new List<MyObjClass>();
      if (name.IndexOf("rm_") == 0) {
        rl = GetRooms();
      }
      else if (name.IndexOf("mg_") == 0) {
        //MessageBox.Show("GetControl( " + name + " )");
        rl = GetMgs();
      }
      else if (name.IndexOf("ho_") == 0) {
        rl = GetHos();
      }
      else if (name.IndexOf("zz_") == 0) {
        rl = GetZooms();
      }
      else if (name.IndexOf("inv_") == 0) {
        rl = GetComplex();
      }
      for (int i = 0; i < rl.Count; i++) {
        //Debag("room control name " + rl[i].GetName() + "\n");
        if (rl[i].GetName() == name) {
          //Debag("finded " + name);
          return rl[i].GetMyControl();
        }
      }
      return null;
    }

    public void Debag(string s,
                      [CallerMemberName] string memberName = "",
                      [CallerFilePath] string sourceFilePath = "",
                      [CallerLineNumber] int sourceLineNumber = 0) {
      //MessageBox.Show("Debag\n\t" + memberName + "\n\t" + sourceFilePath + "\n\t" + sourceLineNumber);
      int len = this.richTextBox1.Text.Length;

      this.richTextBox1.AppendText(s + "\n");

      string[] slash = new string[] { "\\", "/" };

      for (int i = 0; i < slash.Length; i++) {

        if (s.IndexOf(slash[i] + "rm_") > -1) {
          int fnd = s.IndexOf(slash[i] + "rm_") + 1;
          string ss = s.Substring(fnd);

          this.richTextBox1.Select(len + s.IndexOf(slash[i] + "rm_") + 1, ss.IndexOf(slash[i]));
          this.richTextBox1.SelectionColor = Color.Red;
        }
        if (s.IndexOf(slash[i] + "zz_") > -1) {
          int fnd = s.IndexOf(slash[i] + "zz_") + 1;
          string ss = s.Substring(fnd);

          this.richTextBox1.Select(len + s.IndexOf(slash[i] + "zz_") + 1, ss.IndexOf(slash[i] + ""));
          this.richTextBox1.SelectionColor = Color.Green;
        }
        if (s.IndexOf(slash[i] + "mg_") > -1) {
          int fnd = s.IndexOf(slash[i] + "mg_") + 1;
          string ss = s.Substring(fnd);

          this.richTextBox1.Select(len + s.IndexOf(slash[i] + "mg_") + 1, ss.IndexOf(slash[i] + ""));
          this.richTextBox1.SelectionColor = Color.Orange;
        }
        if (s.IndexOf(slash[i] + "ho_") > -1) {
          int fnd = s.IndexOf(slash[i] + "ho_") + 1;
          string ss = s.Substring(fnd);

          this.richTextBox1.Select(len + s.IndexOf(slash[i] + "ho_") + 1, ss.IndexOf(slash[i] + ""));
          this.richTextBox1.SelectionColor = Color.LightCoral;
        }
        if (s.IndexOf(slash[i] + "inv_") > -1) {
          int fnd = s.IndexOf(slash[i] + "inv_") + 1;
          string ss = s.Substring(fnd);

          this.richTextBox1.Select(len + s.IndexOf(slash[i] + "inv_") + 1, ss.IndexOf(slash[i] + ""));
          this.richTextBox1.SelectionColor = Color.YellowGreen;
        }
        if (s.IndexOf(".ogg") > -1) {
          int fnd = s.IndexOf(".ogg") + 1;
          string ss = s.Substring(fnd);

          this.richTextBox1.Select(len + s.IndexOf(".ogg") + 1, (".ogg").Length);
          this.richTextBox1.SelectionColor = Color.MediumBlue;
        }
        if (s.IndexOf("<![CDATA[") > -1) {
          int fnd = s.IndexOf("<![CDATA[");
          string ss = s.Substring(fnd);

          this.richTextBox1.Select(len + s.IndexOf("<![CDATA["), ("<![CDATA[").Length);
          this.richTextBox1.SelectionColor = Color.LightGray;
        }
        if (s.IndexOf("]]>") > -1) {
          int fnd = s.IndexOf("]]>");
          string ss = s.Substring(fnd);

          this.richTextBox1.Select(len + s.IndexOf("]]>"), ("]]>").Length);
          this.richTextBox1.SelectionColor = Color.LightGray;
        }

        this.richTextBox1.SelectionStart = this.richTextBox1.TextLength;
        this.richTextBox1.ScrollToCaret();
      }
    }

    public void Debag(string s, Color clr) {
      int start = this.richTextBox1.Text.Length;
      this.richTextBox1.AppendText(s + "\n");
      this.richTextBox1.Select(start, s.Length);
      this.richTextBox1.SelectionColor = clr;
    }

    public void Debag(List<string> sl, string tab = "") {
      for (int i = 0; i < sl.Count; i++) {
        Debag(tab + sl[i]);
      }
    }

    private void buttonTrigs_Click(object sender, EventArgs e) {
      //return;
      for (int i = 0; i < modules.Count; i++) {
        //for (int j = 0; j < modules[i].GetTrigsList().Count; j++)
        //{
        //    Debag(modules[i].GetTrigsList()[j].GetName());
        //}
        //Debag("---------\nmodule " + modules[i].GetName());
        List<string> trg = modules[i].GetTrigCode("trg_" + modules[i].GetName().Substring(3) + "_preclose");

        if (trg != null) {
          //Debag("trg_" + modules[i].GetName().Substring(3) + "_preclose");
          //Debag("trg_" + modules[i].GetName().Substring(3) + "_preclose");
          if (modules[i].GetName().IndexOf("ho_") == 0) {
            //trg.Add("ld.hint.HintFxHoSoftClear(ne_params.sender)");
            for (int t = 0; t < trg.Count; t++) {
              if (trg[t].IndexOf("ld.hint.HintFxRmSoftClear(ne_params.sender)") > -1) {
                Debag("replace in " + modules[i].GetName());
                trg[t] = trg[t].Replace("ld.hint.HintFxRmSoftClear(ne_params.sender)", "ld.hint.HintFxHoSoftClear(ne_params.sender)");
              }
            }
          }
          else if (modules[i].GetName().IndexOf("mg_") == 0) {
            for (int t = 0; t < trg.Count; t++) {
              if (trg[t].IndexOf("ld.hint.HintFxHoSoftClear(ne_params.sender)") > -1) {
                Debag("replace in " + modules[i].GetName());
                trg[t] = trg[t].Replace("ld.hint.HintFxHoSoftClear(ne_params.sender)", "ld.hint.HintFxRmSoftClear(ne_params.sender)");
              }
            }
            //trg.Add("ld.hint.HintFxRmSoftClear(ne_params.sender)");
          }
        }
        List<MyControl> mcl = modules[i].GetMainRoomControl().GetChilds();
        for (int j = 0; j < mcl.Count; j++) {
          //Debag(mcl[j].GetName());
          //Debag("trg_" + mcl[j].GetName().Substring(3) + "_preclose");
          trg = modules[i].GetTrigCode("trg_" + mcl[j].GetName().Substring(3) + "_preclose");
          if (trg != null) {
            //trg.Add("ld.hint.HintFxZzSoftClear(ne_params.sender)");
            for (int t = 0; t < trg.Count; t++) {
              if (trg[t].IndexOf("ld.hint.HintFxRmSoftClear(ne_params.sender)") > -1) {
                Debag("replace in " + mcl[j].GetName());
                trg[t] = trg[t].Replace("ld.hint.HintFxRmSoftClear(ne_params.sender)", "ld.hint.HintFxZzSoftClear(ne_params.sender)");
              }
            }
          }
          else {
            Debag("trg_" + mcl[j].GetName().Substring(3) + "_preclose НЕНАЙДЕН!!!");
          }

          trg = modules[i].GetTrigCode("trg_" + mcl[j].GetName().Substring(3) + "_preopen");
          if (trg != null) {
            //trg.Add("ld.hint.HintFxRmSoftClear(\"" + modules[i].GetName() + "\")");
          }
          else {
            //Debag("trg_" + mcl[j].GetName().Substring(3) + "_preopen НЕНАЙДЕН!!!");
          }

        }
      }
    }
    void CheckProjectResources() {
      Debag("Check Start at " + DateTime.Now.ToLongTimeString());

      GameResChecker grs = new GameResChecker(LogicCaseSettings);


      long start = DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond;

      //localVarCheck();
      //return;
      //localFuncCheck();
      //bbtCheck();

      string TEXT_BUF = this.Text;


      this.richTextBox1.ReadOnly = true;
      this.richTextBox1.BackColor = Color.FromArgb(244, 244, 244);
      List<MyObjClass> aol = GetAllObjs();
      List<List<string>> animL = new List<List<string>>();
      List<List<string>> fxL = new List<List<string>>();

      Debag("всего в проекте: \n\t" + aol.Count + " объектов");

      Dictionary<string, int> state = new Dictionary<string, int>();
      state.Add("spr", 0);
      state.Add("video", 0);

      state.Add("obj", 0);
      state.Add("partsys", 0);
      state.Add("partsys_pm", 0);
      state.Add("partsys_gm", 0);
      state.Add("anim", 0);
      bool qqq = false;


      string miss_res = "Ссылаются на отсутствующие ресурсы >>>\n";

      Dictionary<string, List<string>> res_types = new Dictionary<string, List<string>>();
      res_types["spr"] = new List<string>();
      res_types["video"] = new List<string>();
      res_types["anim"] = new List<string>();
      res_types["partsys"] = new List<string>();
      res_types["partsys_gm"] = new List<string>();
      res_types["partsys_pm"] = new List<string>();
      res_types["text"] = new List<string>();


      res_types["spr"].Add(".png");
      res_types["spr"].Add(".jpg");
      res_types["video"].Add(".ogg");
      res_types["anim"].Add(".xml");
      res_types["partsys"].Add(".xml");
      res_types["partsys_gm"].Add(".xml");
      res_types["partsys_pm"].Add(".xml");
      res_types["text"].Add(".nefnt");

      for (int i = 0; i < aol.Count; i++) {
        foreach (KeyValuePair<string, int> kvp in state) {
          if (kvp.Key == aol[i].GetPropertie("__type")) {
            state[kvp.Key]++;
            break;
          }
        }

        MyObjClass mo = aol[i];
        string mo_res = mo.GetPropertie("res");
        if (mo_res.Length > 0) {
          string adr = "";
          bool exist = false;
          List<string> obj_res_types;
          if (res_types.TryGetValue(mo.GetPropertie("__type"), out obj_res_types)) {
            for (int rt = 0; rt < obj_res_types.Count; rt++) {
              adr = repDir + "exe\\" + mo_res + obj_res_types[rt];
              adr = adr.Replace("/", "\\");

              if (File.Exists(adr)) {
                exist = true;
                break;
              }
            }
          }
          else {
            exist = true;
          }

          if (!exist) {
            miss_res += "\t" + mo.GetName() + "\t" + adr + "\n";
          }
        }

      }
      Debag(miss_res + "<<< Ссылаются на отсутствующие ресурсы");

      foreach (KeyValuePair<string, int> kvp in state) {
        Debag("\t\t" + kvp.Key + " " + kvp.Value);
      }

      Debag("\t" + GetRooms().Count + " комнат");
      Debag("\t" + GetHos().Count + " HO scenes");
      Debag("\t" + GetMgs().Count + " мини игр");
      Debag("\t" + GetZooms().Count + " зум зон");

      //
      System.IO.FileInfo rm_back = new System.IO.FileInfo("res\\rm\\back.jpg");
      System.IO.FileInfo zz_back = new System.IO.FileInfo("res\\zz\\back.jpg");
      System.IO.FileInfo mini_back = new System.IO.FileInfo("res\\rm\\miniback.jpg");
      List<string> backs_string = new List<string>();
      List<string> sprites_string = new List<string>();
      List<string> no_animation = new List<string>();
      List<string> comited_animations = new List<string>();
      List<string> comited_fx = new List<string>();
      List<string> no_fx = new List<string>();
      List<string> standarts = new List<string>();

      Dictionary<string, List<string>> ANM = new Dictionary<string, List<string>>();
      Dictionary<string, List<string>> PSS = new Dictionary<string, List<string>>();
      Dictionary<string, List<string>> PSSrnd = new Dictionary<string, List<string>>();

      string file_out_rm = "";
      //

      progressBar1.Visible = true;
      progressBar1.BringToFront();
      progressBar1.Maximum = modules.Count;
      progressBar1.Value = 0;

      //progressBar1.Style = ProgressBarStyle.Marquee;
      //progressBar1.MarqueeAnimationSpeed = 500;


      Debag("--------------------НЕ ПОДКЛЮЧЕННЫЕ ФАЙЛЫ");

      //Debag("projectDir "+projectDir);
      //Debag("levelDir " + levelDir);
      //Debag("levelStartRoomDir " + levelStartRoomDir);
      //Debag("levelStartRoom " + levelStartRoom);
      string asets = levelDir.Replace(projectDir, "") + "\\exe\\";
      //Debag("asets " + asets);
      //проверка подключенных ресурсов
      for (int m = 0; m < modules.Count; m++) {
        this.Text = (m * 100 / modules.Count) + "% " + modules[m].GetName();


        //if (modules[m].GetName() == levelName + "_inv")
        //    continue;
        //if (modules[m].GetName() != "rm_extpark")
        //    continue;
        List<MyControl> mcl = new List<MyControl>();

        if (modules[m].GetName() == levelName + "_inv") {
          ModuleClass mod = modules[m];
          List<MyObjClass> mao = mod.AllObjs;
          for (int sss = 0; sss < mao.Count; sss++) {
            if (mao[sss].GetMyControl() != null) {
              mcl.Add(mao[sss].GetMyControl());
              //Debag("\tLEVEL_INV\t"+mao[sss].GetMyControl().GetName());
            }
          }
        }
        else {
          mcl.Add(modules[m].GetMainRoomControl());
          var childs = modules[m].GetMainRoomControl().GetChilds();
          for (int i = 0; i < childs.Count; i++) {
            //Debag("checking " + m + " " + modules[m].GetMainRoomControl().GetName());
            if (childs[i].GetName().IndexOf("zz_") == 0) {
              mcl.Add(childs[i]);
              //Debag("\t adding " + childs[i].GetName());
            }
            //else
            //Debag("ignoring " + modules[m].GetMainRoomControl().GetChilds()[i].GetName());
          }
        }
        for (int c = 0; c < mcl.Count; c++) {

          List<string> fassets = new List<string>();

          string rmnm = "";
          if (modules[m].GetName() == levelName + "_inv") {
            rmnm = "inv_deploy\\";
          }
          else if (mcl[c].GetName().IndexOf("zz_") == 0) {
            rmnm = modules[m].GetName() + "\\";
          }

          var dirName = levelDir + "\\" + rmnm + mcl[c].GetName();

          if(!Directory.Exists(dirName)) {
            MessageBox.Show($"Отсутствует директория!!!!!!!!!!!!!\n\n"
                            + dirName
                            + "\n\nдля " + mcl[c].GetName()
                           );
            continue;
          }

          string[] files = Directory.GetFiles(dirName);
          List<string> flsfull = mStrToList(files);
          List<string> fl = mStrToList(files, dirName + "\\");
          //удаляем стандартные файлы
          for (int f = 0; f < fl.Count(); f++) {
            if(fl[f].LastIndexOf(".")<0) {
              MessageBox.Show("Отсутствует расширение файла!\n"+ flsfull[f]);
              flsfull.RemoveAt(f);
              fl.RemoveAt(f);
              files = flsfull.ToArray();
              f--;
              continue;
            }
            string rus = isRussianSymbols(fl[f].Substring(0, fl[f].LastIndexOf(".")));
            if (rus.Length>0) {
              standarts.Add("\t* русские буквы в файле \t *" + fl[f] + "*\n\t\t"+rus);
            }
            else if (isWrongSimbols(fl[f].Substring(0, fl[f].LastIndexOf(".")))) {
              standarts.Add("\t* неправильные символы в файле \t *" + fl[f] + "*");
            }
            if ((fl[f].IndexOf(".ogg") != -1) && (!fl[f].StartsWith("vid")) && (fl[f].IndexOf(".oggalpha") == -1)
                && (!fl[f].StartsWith("inv_"))) {
              standarts.Add("\t* имя видео должно начинаться с vid_... \t *" + flsfull[f].Substring(
                              flsfull[f].LastIndexOf("\\exe\\")) + "*");
            }
            if (fl[f].StartsWith("inv_") && fl[f].EndsWith(".png") && fl[f].IndexOf(".ogg") == -1
                && fl[f].Substring(4).IndexOf("_") == -1) {
              string flf = fl[f];
              string flsfullf = flsfull[f];
              System.Drawing.Image invImage = System.Drawing.Image.FromFile(flsfullf);
              if (invImage.Width > 100 || invImage.Height > 100)
                standarts.Add("\t* неправильное разрешение инвентарного спрайта\t *" +
                              flsfullf.Substring(flsfullf.LastIndexOf("\\exe\\")) + "*\t" + invImage.Width + "*" + invImage.Height);
            }
            if (fl[f] == "miniback.jpg"
                || fl[f] == "back.jpg"
                || fl[f].IndexOf(".txt") > -1
                || fl[f].IndexOf(".oggalpha") > -1
                || fl[f].IndexOf(".srt") > -1
                || fl[f].IndexOf(".lua") > -1
                //|| fl[f].IndexOf("mod_") == 0
                || fl[f].IndexOf("inv_") == 0) {
              grs.ResAdd(files[f]);
              if (fl[f] == "back.jpg") {
                System.IO.FileInfo back = new System.IO.FileInfo(files[f]);
                System.IO.FileInfo check_back = rm_back;
                if (mcl[c].getNamePrefix() == "zz") {
                  check_back = zz_back;
                }
                if (back.Length == check_back.Length) {
                  //Debag("\tдля " + mcl[c].GetName() + " заглушка back.jpg");
                  //Debag("\t"+files[f]);
                  //backs_string.Add( "для " + mcl[c].GetName() + " заглушка back.jpg" );
                  if (mcl[c].getNamePrefix() == "zz")
                    backs_string.Add("\tZZ back\t" + files[f].Replace(levelDir, ""));
                  else
                    backs_string.Add("\tRM BACK\t" + files[f].Replace(levelDir, ""));

                }
                if (mcl[c].getNamePrefix() == "rm" || mcl[c].getNamePrefix() == "mg" || mcl[c].getNamePrefix() == "ho") {
                  if (File.Exists(files[f].Replace("\\back.jpg", "\\miniback.jpg"))) {
                    back = new System.IO.FileInfo(files[f].Replace("\\back.jpg", "\\miniback.jpg"));
                  }
                  else {
                    back = new System.IO.FileInfo(files[f].Replace("\\back.jpg", "\\miniback.png"));
                  }

                  if (back.Length == mini_back.Length) {
                    //Debag("\tдля " + mcl[c].GetName() + " заглушка miniback.jpg");
                    //Debag("\t" + files[f].Replace("\\back.jpg", "\\miniback.jpg"));
                    //backs_string.Add( "для " + mcl[c].GetName() + " заглушка miniback.jpg" );
                    backs_string.Add("\tmini back\t" + files[f].Replace("\\back.jpg", "\\miniback.jpg").Replace(levelDir, ""));
                  }
                }

              }
              if (fl[f].IndexOf("inv_") == 0) {
                System.IO.FileInfo invinfo = new System.IO.FileInfo(flsfull[f]);
                System.IO.FileInfo definvinfo = new System.IO.FileInfo("res\\get\\get_spr_inv.png");
                if (invinfo.Length == definvinfo.Length & (fl[f].EndsWith(".png") || fl[f].EndsWith(".jpg"))) {
                  //Debag("Инвентарная заглушка\t" + flsfull[f], Color.Red);
                  sprites_string.Add("\tINVентарный спрайт \t" + flsfull[f].Replace(levelDir, ""));
                }
                else {
                  //Debag(flsfull[f].Replace("\\inv_", "\\"), Color.Maroon);
                }
                try {
                  string fadr = flsfull[f].Substring(0, flsfull[f].LastIndexOf("."));
                  System.IO.FileInfo finfo = new System.IO.FileInfo(fadr.Replace("\\inv_", "\\") + ".png");
                  System.IO.FileInfo deffinfo = new System.IO.FileInfo("res\\get\\get_spr_obj.png");
                  if (finfo.Length == deffinfo.Length & (flsfull[f].EndsWith(".png") || flsfull[f].EndsWith(".jpg"))) {
                    //Debag("заглушка инвентарного спрайта на локации\t" + flsfull[f], Color.Red);
                    sprites_string.Add("\tСПРАЙТ на локации \t" + fadr.Replace("\\inv_", "\\").Replace(levelDir,
                                       "") + ".png");
                  }
                }
                catch {
                  //string fadr = flsfull[f].Substring(0, flsfull[f].LastIndexOf("."));

                  //Debag("alert " + fadr.Replace("\\inv_", "\\") + ".png", Color.Blue);
                }
                //else
                //{
                //   // Debag("replaced\t" + files[f], Color.Green);
                //}
              }
              if (fl[f] != "back.jpg") {
                //Debag(fl[f]);
                fl.RemoveAt(f);
                flsfull.RemoveAt(f);
                files = flsfull.ToArray();
                f--;
              }
              else {
                string s = ("assets\\levels\\" + levelName + "\\" + rmnm + mcl[c].GetName() + "\\" + fl[f]);
                //Debag(fl[f]);
                fassets.Add(s.Substring(0, s.IndexOf(".")));
              }
            }
            else {

              if (files[f].EndsWith(".jpg") || files[f].EndsWith(".png")) {
                grs.ResAdd(files[f]);

                using (System.Drawing.Image objImage = System.Drawing.Image.FromFile(files[f])) {
                  int w = objImage.Width;
                  int h = objImage.Height;
                  //if (w % 2 != 0 | h % 2 != 0)
                  //{
                  //    Debag("Изображение не кратно 2 !!! " + files[f].Substring(files[f].LastIndexOf("\\exe\\")), Color.Red);
                  //}
                  //else
                  //{
                  //    Debag(w + " " + h + " " + w % 2 + " " + h % 2 + " " + files[f], Color.Red);
                  //}
                  if (w % 2 != 0)
                    standarts.Add("*\t ширина изображения не кратно 2 \t" + files[f].Substring(
                                    files[f].LastIndexOf("\\exe\\")));
                  if (h % 2 != 0)
                    standarts.Add("*\t выстота изображения не кратно 2 \t" + files[f].Substring(
                                    files[f].LastIndexOf("\\exe\\")));
                }
              }

              string s = ("assets\\levels\\" + levelName + "\\" + rmnm + mcl[c].GetName() + "\\" + fl[f]);
              //Debag(fl[f]);
              fassets.Add(s.Substring(0, s.IndexOf(".")));
            }
          }

          //List<MyObjClass> ol;// = mcl[c].GetAllObjs();
          //if (mcl[c].getNamePrefix() == "rm")
          //    //ol = GetAllObjs();
          //    ol = modules[m].AllObjs;
          //else
          //    ol = mcl[c].GetAllObjs();

          List<MyObjClass> ol = mcl[c].GetOwnerObj().GetModule().AllObjs;


          //проверяем для списка файлов в папке
          for (int f = 0; f < fl.Count(); f++) {
            bool b;
            if (loadedIgnoreBool.TryGetValue(fassets[f], out b)) {
              if (b) {
                fl.RemoveAt(f);
                fassets.RemoveAt(f);
                f--;
                continue;
              }
            }


            bool fused = false; //старший маркер использованности файла
            //проверяем для объектов комнаты
            for (int o = 0; o < ol.Count(); o++) {
              //Debag("*"+ol[o].GetPropertie("res").Replace("/", "\\") + "*   ==   *" + "assets\\levels\\" + levelName + "\\" + mc.GetName() + "\\" + fl[f]+"*");
              string ores = ol[o].GetPropertie("res").Replace("/", "\\");
              string fres = ("assets\\levels\\" + levelName + "\\" + rmnm + mcl[c].GetName() + "\\" + fl[f]);
              fres = fres.Substring(0, fres.IndexOf("."));

              //Debag( ol[o].GetName() + " => "+ ores + "___" + fres);
              if (ores == fres) { // || ores == "")
                //Debag("res included for " + ol[o].GetName() + " " + fres);
                fused = true;
                break;
              }
            }
            if (!fused) {
              //if (fl[f] == "bulb.png")
              //{
              //Debag("File " + fl[f] + " не найден в объекте комнаты ");
              //Debag("f " + f + "; c " + c + "; cname " + mcl[c].GetName());
              //}
            }
            else {
              //Debag(fl[f] + "   найден в объекте комнаты");
              fl.RemoveAt(f);
              fassets.RemoveAt(f);
              f--;
            }
          }

          string xmlScanPath = levelDir + "\\" + rmnm + mcl[c].GetName();
          string[] xmlFiles = Directory.GetFiles(xmlScanPath, "*.xml");  //search all xml files in \\anims folder
          if (Directory.Exists(xmlScanPath + "\\anims"))
            xmlFiles = xmlFiles.Concat(Directory.GetFiles(xmlScanPath + "\\anims")).ToArray(); //search all xml files in \\anims folder
          List<string> xmlFL = mStrToList(xmlFiles);
          for (int f = 0; f < fl.Count(); f++) {
            //Debag(fl[f]);
            //Debag("файл не подключен " + fl[f]);

            //проверяем файл для частиц
            bool fx_in_room = false;
            for (int x = 0; x < xmlFL.Count; x++) {

              int id = 0;

              List<string> ps;// = LoadXML(xmlFL[x]);
              if (!PSS.TryGetValue(xmlFL[x], out ps)) {
                ps = LoadXML(xmlFL[x]);
                if (FindId(ps, "<ps type = \"jan\">") > -1) {
                  xmlReload(ps, "res = \"");
                  PSS[xmlFL[x]] = ps;
                }
                else {
                  ps = null;
                }

              }
              if (ps == null)
                continue;

              id = FindId(ps, "res = ");
              fx_in_room = true;

              bool next = true;
              int strtd = 1;
              while (id > -1 & next & f > -1) {
                //Debag(xmlFL[x] + " " + id);
                if (id > -1) {
                  //MessageBox.Show(id.ToString());
                  id = FindId(ps, "res = ", id);
                  if (id > -1) {
                    strtd = 0;
                    string res = ps[id];
                    string rf = "";

                    try {
                      res = res.Substring(res.IndexOf("\"") + 1);
                      res = res.Substring(0, res.IndexOf("\""));
                      rf = fl[f].Substring(0, fl[f].IndexOf("."));
                    }
                    catch(Exception e) {
                      MessageBox.Show("Не правильный формат ресурса в частице\n\n"
                                      + xmlFiles[f] + "\n\n"
                                      + id + "\n\n"
                                      + ps[id] + "\n\n"
                                      +e.Message + "\n\n"
                                      + e.StackTrace
                                     );
                    }


                    rf = "assets\\levels\\" + levelName + "\\" + rmnm + mcl[c].GetName() + "\\" + rf;
                    //Debag("res in ps " + res + " " + rf);


                    if (res == rf) {
                      //Debag("файл " + fl[f] + " найден в " + xmlFL[x]);
                      //xmlFL.RemoveAt(x);
                      //x--;
                      //Debag(fl[f]);
                      fl.RemoveAt(f);
                      fassets.RemoveAt(f);
                      f--;
                      ps.RemoveAt(id);
                      next = false;
                      break;
                    }

                  }
                }
                id = FindId(ps, "res = ", id + 1);
              }
            }

            //проверяем файл для частиц RND
            for (int x = 0; x < xmlFL.Count; x++) {

              int id = 0;

              List<string> ps;// = LoadXML(xmlFL[x]);
              if (!PSSrnd.TryGetValue(xmlFL[x], out ps)) {
                ps = LoadXML(xmlFL[x]);
                if (FindId(ps, "<ps type=\"rnd\"") > -1) {
                  xmlReload(ps, " res=\"");
                  PSSrnd[xmlFL[x]] = ps;
                }
                else {
                  ps = null;
                }

              }
              if (ps == null)
                continue;

              id = FindId(ps, " res=\"");
              fx_in_room = true;

              bool next = true;
              int strtd = 1;
              while (id > -1 & next & f > -1) {
                //Debag(xmlFL[x] + " " + id);
                if (id > -1) {
                  //MessageBox.Show(id.ToString());
                  id = FindId(ps, " res=\"", id);
                  if (id > -1) {
                    strtd = 0;
                    string res = ps[id].Substring(ps[id].IndexOf(" res=\"") + 1);

                    res = res.Substring(res.IndexOf("\"") + 1);
                    res = res.Substring(0, res.IndexOf("\""));

                    string rf = fl[f].Substring(0, fl[f].IndexOf("."));
                    rf = "assets\\levels\\" + levelName + "\\" + rmnm + mcl[c].GetName() + "\\" + rf;
                    //Debag("res in ps " + res + " " + rf);


                    if (res == rf.Substring(rf.LastIndexOf("\\")+1)) {
                      //Debag("файл " + fl[f] + " найден в " + xmlFL[x]);
                      //xmlFL.RemoveAt(x);
                      //x--;
                      //Debag(fl[f]);
                      fl.RemoveAt(f);
                      fassets.RemoveAt(f);
                      f--;
                      ps.RemoveAt(id);
                      next = false;
                      break;
                    }

                  }
                }
                id = FindId(ps, " res=\"", id + 1);
              }
            }

            //проверяем файл для анимаций
            bool animation_in_room = false;
            for (int x = 0; x < xmlFL.Count; x++) {
              //Debag("проверяем анимацию файл " + xmlFL[x]);
              int id = 0;

              List<string> ps;// = LoadXML(xmlFL[x]);
              if (!ANM.TryGetValue(xmlFL[x], out ps)) {
                ps = LoadXML(xmlFL[x]);
                if (FindId(ps, "<animation",0,3) > -1) {
                  xmlReload(ps, " res=\"");
                  ANM[xmlFL[x]] = ps;
                  grs.ResAdd(xmlFL[x]);
                  //for (int aaa = 0; aaa < ps.Count; aaa++)
                  //    Console.WriteLine(ps[aaa]);
                }
                else {
                  ps = null;
                }

              }

              if (ps == null)
                continue;


              if (id > -1)
                animation_in_room = true;
              bool next = true;
              while (id > -1 & next & f > -1) {
                //Debag(xmlFL[x] + " " + id);
                if (id > -1) {
                  //MessageBox.Show(id.ToString());
                  //Debag(xmlFL[x] + " " + id);
                  id = FindId(ps, " res=\"", id);
                  string res = ps[id];
                  res = res.Substring(res.IndexOf(" res=\"") + 6);
                  res = res.Substring(0, res.IndexOf("\""));


                  string rf = fl[f];
                  if (fl[f].IndexOf(".") > -1) {
                    rf = fl[f].Substring(0, fl[f].IndexOf("."));
                  }
                  //rf = "assets\\levels\\" + levelName + "\\" + rmnm + mcl[c].GetName() + "\\" + rf;
                  //Debag("res in anim " + res + " * " + rf);
                  if (res == rf || res.Replace(mcl[c].GetDefResName().Replace("\\", "/"), "") == rf) {
                    //Debag("файл " + fl[f] + " найден в " + xmlFL[x]);
                    //xmlFL.RemoveAt(x);
                    //x--;
                    //Debag(fl[f]);
                    fl.RemoveAt(f);
                    fassets.RemoveAt(f);
                    f--;
                    next = false;
                    break;
                  }
                  id = FindId(ps, " res=\"", id + 1);
                }
              }
            }
            if (animation_in_room == false) {
              if (mcl[c].getNamePrefix() == ("rm")
                  || mcl[c].getNamePrefix() == ("zz")
                  || mcl[c].getNamePrefix() == "ho"
                  || mcl[c].getNamePrefix() == "mg") {
                if (no_animation.Count > 0) {
                  if (no_animation[no_animation.Count - 1].IndexOf(mcl[c].GetName()) == -1) {

                    //no_animation.Add("\t" + mcl[c].GetOwnerObj().GetPropertie("res").Replace("/back", "/").Replace("\\back", "\\").Replace("/", "\\").Replace("assets\\levels\\level", ""));
                    no_animation.Add("\t" + mcl[c].GetDefResName());
                    //Debag("\t\tотсутствует анимация для " + mcl[c].GetName());
                  }
                }
                else {
                  //no_animation.Add("\t" + mcl[c].GetOwnerObj().GetPropertie("res").Replace("/back", "/").Replace("\\back", "\\").Replace("/", "\\").Replace("assets\\levels\\level", ""));
                  no_animation.Add("\t" + mcl[c].GetDefResName());
                  //Debag("\t\tотсутствует анимация для " + mcl[c].GetName());
                }
              }
            }
            if (fx_in_room == false) {
              if (mcl[c].getNamePrefix() == ("rm")
                  || mcl[c].getNamePrefix() == ("zz")
                  || mcl[c].getNamePrefix() == "ho"
                  || mcl[c].getNamePrefix() == "mg") {
                if (no_fx.Count > 0) {
                  if (no_fx[no_fx.Count - 1].IndexOf(mcl[c].GetName()) == -1) {
                    //no_fx.Add("\t" + mcl[c].GetOwnerObj().GetPropertie("res").Replace("/back", "/").Replace("\\back", "\\").Replace("/", "\\").Replace("assets\\levels\\level", ""));
                    no_fx.Add("\t" + mcl[c].GetDefResName());
                    //Debag("\t\tотсутствует частицы для " + mcl[c].GetName());
                  }
                }
                else {
                  //no_fx.Add("\t" + mcl[c].GetOwnerObj().GetPropertie("res").Replace("/back", "/").Replace("\\back", "\\").Replace("/", "\\").Replace("assets\\levels\\level", ""));
                  no_fx.Add("\t" + mcl[c].GetDefResName());
                  //Debag("\t\tотсутствует частицы для " + mcl[c].GetName());
                }
              }
            }
          }
          for (int f = 0; f < fl.Count(); f++) {

            //Debag(fl[f]);
            bool finded = false;
            string on = "";
            string tf = fassets[f];
            if (fl[f].IndexOf(".") > -1) {
              tf = fassets[f];
            }
            tf = tf.Replace("\\", "/");

            for (int o = 0; o < aol.Count; o++) {

              //if (aol[o].GetPropertie("res").IndexOf(tf) > -1)
              if (aol[o].GetPropertie("res") == tf) {

                //Debag(aol[o].GetPropertie("res") + "   " + tf);
                finded = true;
                //on = aol[o].GetPropertie("name");
                //if (on.IndexOf("_angel") > -1)
                //{
                //Debag(aol[o].GetPropertie("name") + " remove " + tf);
                //}
                //aol.RemoveAt(o);

                break;
              }
            }
            if (!finded) {

              if (fl[f].IndexOf(".xml") > -1) {
                List<string> xml = LoadXML(levelDir + "\\" + rmnm + mcl[c].GetName() + "\\" + fl[f]);
                xmlReload(xml);
                if (FindId(xml, "<animation") > -1) {
                  List<string> param = new List<string>();
                  param.Add(("assets\\levels\\" + levelName + "\\" + rmnm + mcl[c].GetName() + "\\" + fl[f]).Replace(".xml",
                            ""));    //ресурс 0
                  param.Add(mcl[c].getNamePost());  //zrm 1
                  param.Add(fl[f].Replace(".xml", ""));  //fnm 2
                  if (rmnm.Length > 0) {
                    param.Add(rmnm + "\\"); //rm_rm 3
                    param.Add(mcl[c].GetName());    //zz_zz 4
                  }
                  else {
                    param.Add(""); //rm_rm 3
                    param.Add(mcl[c].GetName());    //zz_zz 4
                  }
                  animL.Add(param);
                }
                else if (FindId(xml, "<ps type = \"jan\">") > -1) {
                  List<string> param = new List<string>();
                  param.Add(("assets\\levels\\" + levelName + "\\" + rmnm + mcl[c].GetName() + "\\" + fl[f]).Replace(".xml",
                            ""));    //ресурс 0
                  param.Add(mcl[c].getNamePost());  //zrm 1
                  param.Add(fl[f].Replace(".xml", ""));  //fnm 2
                  if (rmnm.Length > 0) {
                    param.Add(rmnm + "\\"); //rm_rm 3
                    param.Add(mcl[c].GetName());    //zz_zz 4
                  }
                  else {
                    param.Add(""); //rm_rm 3
                    param.Add(mcl[c].GetName());    //zz_zz
                  }
                  fxL.Add(param);
                }
                else if (FindId(xml, "<ps type=\"rnd\">") > -1) {
                  List<string> param = new List<string>();
                  param.Add(("assets\\levels\\" + levelName + "\\" + rmnm + mcl[c].GetName() + "\\" + fl[f]).Replace(".xml",
                            ""));    //ресурс 0
                  param.Add(mcl[c].getNamePost());  //zrm 1
                  param.Add(fl[f].Replace(".xml", ""));  //fnm 2
                  if (rmnm.Length > 0) {
                    param.Add(rmnm + "\\"); //rm_rm 3
                    param.Add(mcl[c].GetName());    //zz_zz 4
                  }
                  else {
                    param.Add(""); //rm_rm 3
                    param.Add(mcl[c].GetName());    //zz_zz
                  }
                  fxL.Add(param);
                }
              }
              else {
                //if (mcl[c].GetName().IndexOf("mg_") != 0)
                if (true) {
                  //file_out_rm
                  if (mcl[c].GetName() != file_out_rm) {
                    file_out_rm = mcl[c].GetName();
                    if (file_out_rm.IndexOf("rm_") == 0)
                      Debag("--- " + file_out_rm + " ---", Color.Red);
                    else
                      Debag("\t --- " + file_out_rm + " ---", Color.Green);
                  }

                  //bool ff = false;
                  //foreach ( KeyValuePair<string,MyObjClass> kvp in MyObjClass.CreatetObjs)
                  //{
                  //    if
                  //}

                  bool oof = false;
                  string ofn = fl[f].Substring(0, fl[f].IndexOf("."));
                  //Debag("assets\\levels\\" + levelName + "\\" + rmnm + mcl[c].GetName() + "\\" + ofn);
                  List<MyObjClass> ool = mcl[c].GetOwnerObj().Parent.objs;
                  for (int i = 0; i < ool.Count; i++) {
                    //Debag(ool[i].GetPropertie("res"));
                    if (ool[i].GetPropertie("res").Replace("/",
                                                           "\\") == "assets\\levels\\" + levelName + "\\" + rmnm + mcl[c].GetName() + "\\" + ofn) {

                      oof = true;
                      break;
                    }
                  }
                  foreach (KeyValuePair<string, MyObjClass> kvp in MyObjClass.CreatetObjs) {
                    if (kvp.Value.GetPropertie("res").Replace("/",
                        "\\") == "assets\\levels\\" + levelName + "\\" + rmnm + mcl[c].GetName() + "\\" + ofn) {

                      oof = true;
                      break;
                    }
                  }
                  if (!oof) {
                    bool b;
                    if (!loadedIgnoreBool.TryGetValue(rmnm + mcl[c].GetName() + "\\" + fl[f], out b) || !b)
                      Debag("\t\t\\" + rmnm + mcl[c].GetName() + "\\" + fl[f]);
                  }
                  else {

                  }
                }

              }
            }
            else {
              //if (fl[f].IndexOf(".ogg") == -1)
              //Debag("файл/объект не в своей директории " + on + "  ==>  " + fl[f]);
              fl.RemoveAt(f);
              fassets.RemoveAt(f);
              f--;
            }
          }
        }

        progressBar1.PerformStep();
      }

      Debag("Анимации использующие остутствующие ресурсы >>>>");
      foreach (KeyValuePair<string, List<string>> kvp in ANM) {
        string show = "  Анимация >> " + kvp.Key.Substring(kvp.Key.IndexOf("\\exe\\")) + "\n";
        bool need_show = false;
        for (int i = 0; i < kvp.Value.Count; i++) {
          string s = kvp.Value[i];
          string marker = "res=\"";
          if (s.IndexOf(marker) > -1) {

            s = s.Substring(s.IndexOf(marker) + marker.Length);
            s = s.Substring(0, s.IndexOf("\""));

            if (s.Length == 0)
              continue;

            if(s.IndexOf("/")>-1) {
              s = s.Replace("/", "\\");

              string name = kvp.Value[i];
              string nm = "name=\"";
              name = name.Substring(name.IndexOf(nm) + nm.Length);
              name = name.Substring(0, name.IndexOf("\""));

              show += "     вложенный спрайт => " + name + " >> " + s +"\n";
              need_show = true;
            }

            if (s.IndexOf("/") > -1) {
              s = repDir + "exe\\" + s;
              //Debag("/////////////////////////////////" + s, Color.Red);
            }
            else {
              s = kvp.Key.Substring(0, kvp.Key.LastIndexOf("\\") + 1) + s;
            }
            if (File.Exists(s + ".png") || File.Exists(s + ".jpg")) {
              //Debag("\t\t" + s, Color.Green);

            }
            else {

              string name = kvp.Value[i];
              string nm = "name=\"";
              name = name.Substring(name.IndexOf(nm) + nm.Length);
              name = name.Substring(0, name.IndexOf("\""));

              show += "    несуществуещий спрайт " + s.Substring(s.IndexOf("\\exe\\")) +
                      "\n      Имя объекта => " + name + "\n";
              need_show = true;
            }
          }
        }
        if (need_show)
          Debag(show);
      }
      Debag("Частица использующие остутствующие ресурсы >>>>");
      foreach (KeyValuePair<string, List<string>> kvp in PSS) {
        string show = "";
        bool need_show = false;
        for (int i = 0; i < kvp.Value.Count; i++) {
          string s = kvp.Value[i];
          string marker = "res = \"";
          if (s.IndexOf(marker) > -1) {
            //show += "  Частица >> " + kvp.Key.Substring(kvp.Key.IndexOf("\\exe\\")) + " << ссылается на несуществуещие спрайты\n";

            s = s.Substring(s.IndexOf(marker) + marker.Length);
            s = s.Substring(0, s.IndexOf("\""));

            string res = s;

            if (s.Length == 0)
              continue;

            s = repDir + "exe\\" + s;

            if (File.Exists(s + ".png") || File.Exists(s + ".jpg")) {
              //Debag("\t\t" + s, Color.Green);

            }
            else {
              show += "  Частица >> " + kvp.Key.Substring(kvp.Key.IndexOf("\\exe\\")) +
                      " << ссылается на несуществуещие спрайты\n";
              show += "      res >>> " + res + "\n";
              need_show = true;
            }
          }
        }

        if (need_show)
          Debag(show);
      }
      //Debag("Частица RND использующие остутствующие ресурсы >>>>");
      foreach (KeyValuePair<string, List<string>> kvp in PSS) {
        string show = "";
        bool need_show = false;
        for (int i = 0; i < kvp.Value.Count; i++) {
          string s = kvp.Value[i];
          string marker = " res=\"";
          if (s.IndexOf(marker) > -1) {
            //show += "  Частица >> " + kvp.Key.Substring(kvp.Key.IndexOf("\\exe\\")) + " << ссылается на несуществуещие спрайты\n";

            s = s.Substring(s.IndexOf(marker) + marker.Length);
            s = s.Substring(0, s.IndexOf("\""));

            string res = s;

            if (s.Length == 0)
              continue;

            s = repDir + "exe\\" + s;

            if (File.Exists(s + ".png") || File.Exists(s + ".jpg")) {
              //Debag("\t\t" + s, Color.Green);

            }
            else {
              show += "  Частица >> " + kvp.Key.Substring(kvp.Key.IndexOf("\\exe\\")) +
                      " << ссылается на несуществуещие спрайты\n";
              show += "      res >>> " + res + "\n";
              need_show = true;
            }
          }
        }

        if (need_show)
          Debag(show);
      }
      //Debag("<<<<");

      //Debag("\n----------------------------------НЕ ПОДКЛЮЧЕНЫЕ ЧАСТИЦЫ");
      for (int i = 0; i < fxL.Count; i++) {
        string type = "fx";
        string resf = "";
        if (fxL[i][0].IndexOf("_pm") > -1 | fxL[i][0].IndexOf("pm_") > -1) {
          type = "pfx";
          resf = "_pm";
        }
        comited_fx.Add("\t" + type + " \t" + fxL[i][0].Replace("assets\\levels\\level", ""));
        //Debag("\t" + type + " " + fxL[i][0]);
        List<string> anm = LoadXML("res\\objs\\partsys" + resf + ".xml");
        xmlReplace(anm, "##zrm##", fxL[i][1]);
        xmlReplace(anm, "##fnm##", fxL[i][2]);
        xmlReplace(anm, "##rm_rm##", fxL[i][3]);
        xmlReplace(anm, "##zz_zz##", fxL[i][1]);


        try {
          //MyObjClass mo = new MyObjClass(anm, 0, GetControl(fxL[i][4]).GetOwnerObj().ownerModule);
          //mo.SetPropertie("res", fxL[i][0]);
          //GetControl(fxL[i][4]).GetOwnerObj().objAdd(mo);
          //Debag("     создана частица - " + type + "_" + fxL[i][1] + "_" + fxL[i][2]);
        }
        catch {

        }
      }
      //Debag("\n----------------------------------НЕ ПОДКЛЮЧЕНЫЕ АНИМАЦИИ");
      for (int i = 0; i < animL.Count; i++) {
        bool finded = false;
        for (int a = 0; a < aol.Count; a++) {
          if (aol[a].GetPropertie("res") == animL[i][0]) {
            //Debag("НАЙДЕНО В ОБ " + aol[a].GetName());
            finded = true;
            break;
          }
        }
        if (finded) continue;
        comited_animations.Add("\t" + animL[i][0].Replace("assets\\levels\\level", ""));
        //Debag("\t" + animL[i][0]);
        List<string> anm = LoadXML("res\\objs\\complexanim.xml");
        xmlReplace(anm, "##zrm##", animL[i][1]);
        xmlReplace(anm, "##fnm##", animL[i][2]);
        xmlReplace(anm, "##rm_rm##", animL[i][3]);
        xmlReplace(anm, "##zz_zz##", animL[i][1]);


        try {
          //MyObjClass mo = new MyObjClass(anm, 0, GetControl(animL[i][4]).GetOwnerObj().ownerModule);
          //mo.SetPropertie("res", animL[i][0]);
          //GetControl(animL[i][4]).GetOwnerObj().objAdd(mo);
          //Debag("     создана анимация - " + "anm_" + animL[i][1] + "_" + animL[i][2]);
        }
        catch {

        }
      }



      Debag("\n----------------------------------НЕ ПОДКЛЮЧЕНЫЕ АНИМАЦИИ");
      Debag(comited_animations);
      Debag("\n----------------------------------НЕ ПОДКЛЮЧЕНЫЕ ЧАСТИЦЫ");
      Debag(comited_fx);

      Debag("\n----------------------------------ИГНОР");
      List<string> oil = loadedIgnore.Keys.ToList();
      oil.Sort();
      Debag(oil, "\t");

      Debag("\n----------------------------------ЗАГЛУШКИ back");
      Debag(backs_string);
      Debag("\n----------------------------------ЗАГЛУШКИ sprites");
      Debag(sprites_string);
      Debag("\n----------------------------------ОТСУТСТВУЮЩИЕ АНИМАЦИИ");
      Debag(no_animation);
      Debag("\n----------------------------------ОТСУТСТВУЮЩИЕ ЧАСТИЦЫ");
      Debag(no_fx);
      Debag("\n----------------------------------СТАНДАРТЫ");
      Debag(standarts);

      Debag("\n----------------------------------GameResChecker");
      Debag(grs.MessageGet());


      this.richTextBox1.BackColor = this.BackColor;
      this.richTextBox1.ReadOnly = false;

      Debag("Check Ends at " + DateTime.Now.ToLongTimeString());
      long difference = ((DateTime.Now.Ticks / TimeSpan.TicksPerMillisecond - start));

      Debag("Elapsed time " + difference / 1000 + "." + difference % 1000);
      //int start = DateTime.Now.Millisecond;




      this.Text = TEXT_BUF;

      progressBar1.Visible = false;
    }
    private void buttonRessCheck_Click(object sender, EventArgs e) {
      CheckProjectResources();
    }
    public List<string> mStrToList(string[] s, string del) {
      List<string> l = new List<string>();
      for (int i = 0; i < s.Count(); i++) {
        l.Add(s[i].Replace(del, ""));
      }
      return l;
    }
    public List<string> mStrToList(string[] s) {
      List<string> l = new List<string>();
      for (int i = 0; i < s.Count(); i++) {
        l.Add(s[i]);
      }
      return l;
    }

    public List<string> getFunction(List<string> code, string funcName, bool with_coments = true) {
      List<string> fls = new List<string>();

      string func = "";
      int id = FindId(code, funcName);

      if (id == -1) {
        fls.Add("No Func");
        return fls;
      }

      int ends = 0;
      MatchCollection mc;

      //if (id > -1)
      //{
      //    hint[hnt.name] = hnt;
      //}
      //else
      //{
      //    continue;
      //}

      string coment = code[id];
      string S = code[id];
      coment = coment.Trim();
      if (coment.IndexOf("--") > -1) {
        coment = coment.Substring(0, coment.IndexOf("--"));
        if (!with_coments) {
          S = coment;
        }
      }

      string searth = "*\n" + coment + "\n*";

      Regex reg_func = new Regex(@"([\s]function[\s]|[\s]function\(|;function[\s])");
      Regex reg_for = new Regex(@"([\s]for[\s]|;for[\s])");
      Regex reg_then = new Regex(@"([\s]then[\s])");
      Regex reg_elseif = new Regex(@"([\s]elseif[\s])");
      Regex reg_end = new Regex(@"([\s]end[\s]|[\s]end;|;end[\s]|;end;|[\s]end,|[\s]end\))");

      //Regex reg_func = new Regex(@"([\s]function[\s]|[\s]function\(|;function[\s])|=function\(");
      mc = reg_func.Matches(searth);
      ends += mc.Count;

      //Regex reg_for = new Regex(@"([\s]for[\s]|;for[\s])");
      mc = reg_for.Matches(searth);
      ends += mc.Count;

      //Regex reg_then = new Regex(@"([\s]then[\s])");
      mc = reg_then.Matches(searth);
      ends += mc.Count;

      //Regex reg_elseif = new Regex(@"([\s]elseif[\s])");
      mc = reg_elseif.Matches(searth);
      ends -= mc.Count;

      //Regex reg_while = new Regex(@"([\s]+while[\s]+)");
      //mc = reg_while.Matches(searth);
      //ends += mc.Count;

      //Regex reg_end = new Regex(@"([\s]end[\s]|[\s]end;|;end[\s]|;end;|[\s]end,)");
      mc = reg_end.Matches(searth);
      ends -= mc.Count;

      func += code[id];
      fls.Add(S);

      while (ends > 0) {
        id++;

        if (id >= code.Count) {
          Debag(funcName + " HINT id > code.Count");
          id--;
          ends = 0;
          break;
        }

        coment = code[id];
        coment = coment.Trim();
        S = code[id];
        if (coment.IndexOf("--") > -1) {
          coment = coment.Substring(0, coment.IndexOf("--"));
          if (!with_coments) {
            S = coment;
          }
        }

        searth = "*\n" + coment + "\n*";

        mc = reg_func.Matches(searth);
        ends += mc.Count;

        mc = reg_for.Matches(searth);
        ends += mc.Count;

        mc = reg_then.Matches(searth);
        ends += mc.Count;

        mc = reg_elseif.Matches(searth);
        ends -= mc.Count;

        //Regex reg_while = new Regex(@"([\s]+while[\s]+)");
        //mc = reg_while.Matches(searth);
        //ends += mc.Count;

        mc = reg_end.Matches(searth);
        ends -= mc.Count;

        func += "\n" + code[id];

        if (S.Length > 0)
          fls.Add(S);
      }
      fls.Add(code[id + 1]);

      //try
      //{
      //    string tooltip = "";
      //    hnt.Properties.TryGetValue("tooltip", out tooltip);
      //    hnt.Properties["tooltip"] = tooltip + "\n" + func + "\n";
      //    functions.Add(fls);
      //}
      //catch
      //{
      //    form.Debag("CATCH func\t" + func.ToString());
      //}

      //form.Debag(hnt.name);
      //form.Debag("\t" + code[id]);
      //for (int col = 0; col < mc.Count; col++)
      //{
      //    form.Debag("\t"+mc[col].Value);
      //}
      //form.Debag("*");

      return fls;
    }

    public List<List<string>> getFunctions(List<string> code) {
      //code = code.ToList();
      //code.Insert(0, "fynction start_all()");
      //code.Add("end;");

      List<List<string>> funcs = new List<List<string>>();

      string func = "";
      int id = 0;


      int ends = 0;
      MatchCollection mc;

      //if (id > -1)
      //{
      //    hint[hnt.name] = hnt;
      //}
      //else
      //{
      //    continue;
      //}
      Regex reg_func = new Regex(@"([\s]function[\s]|[\s]function\(|;function[\s])");
      Regex reg_for = new Regex(@"([\s]for[\s]|;for[\s])");
      Regex reg_then = new Regex(@"([\s]then[\s])");
      Regex reg_elseif = new Regex(@"([\s]elseif[\s])");
      Regex reg_end = new Regex(@"([\s]end[\s]|[\s]end;|;end[\s]|;end;|[\s]end,|[\s]end\))");

      int id_start = 0;
      while (id_start < code.Count) {
        List<string> fls = new List<string>();

        string coment;
        coment = code[id_start];
        coment = coment.Trim();
        if (coment.IndexOf("--") > -1) {
          coment = coment.Substring(0, coment.IndexOf("--"));
        }

        string searth = "*\n" + coment + "\n*";

        mc = reg_func.Matches(searth);

        if (mc.Count == 0) {
          id_start++;
          continue;
        }

        //for (int rf = 0; rf < mc.Count; rf++)
        //{
        //    Debag(mc[rf].Value);
        //}

        id = id_start;
        ends += mc.Count;

        mc = reg_for.Matches(searth);
        ends += mc.Count;

        mc = reg_then.Matches(searth);
        ends += mc.Count;

        mc = reg_elseif.Matches(searth);
        ends -= mc.Count;

        //Regex reg_while = new Regex(@"([\s]+while[\s]+)");
        //mc = reg_while.Matches(searth);
        //ends += mc.Count;

        mc = reg_end.Matches(searth);
        ends -= mc.Count;


        func += code[id];
        fls.Add(code[id]);

        while (ends > 0) {
          id++;

          if (id >= code.Count) {
            Debag(" getFunctions id > code.Count");
            id--;
            ends = 0;
            break;
          }

          coment = code[id];
          coment = coment.Trim();
          if (coment.IndexOf("--") > -1) {
            coment = coment.Substring(0, coment.IndexOf("--"));
          }

          searth = "*\n" + coment + "\n*";

          mc = reg_func.Matches(searth);
          ends += mc.Count;

          //for (int rf = 0; rf < mc.Count; rf++)
          //{
          //    Debag(mc[rf].Value);
          //    Debag(mc[rf].);
          //}

          mc = reg_for.Matches(searth);
          ends += mc.Count;

          mc = reg_then.Matches(searth);
          ends += mc.Count;

          mc = reg_elseif.Matches(searth);
          ends -= mc.Count;

          //Regex reg_while = new Regex(@"([\s]+while[\s]+)");
          //mc = reg_while.Matches(searth);
          //ends += mc.Count;

          mc = reg_end.Matches(searth);
          ends -= mc.Count;

          func += "\n" + code[id];
          fls.Add(code[id]);
        }
        funcs.Add(fls);
        id_start += fls.Count;
      }

      //try
      //{
      //    string tooltip = "";
      //    hnt.Properties.TryGetValue("tooltip", out tooltip);
      //    hnt.Properties["tooltip"] = tooltip + "\n" + func + "\n";
      //    functions.Add(fls);
      //}
      //catch
      //{
      //    form.Debag("CATCH func\t" + func.ToString());
      //}

      //form.Debag(hnt.name);
      //form.Debag("\t" + code[id]);
      //for (int col = 0; col < mc.Count; col++)
      //{
      //    form.Debag("\t"+mc[col].Value);
      //}
      //form.Debag("*");

      return funcs;
    }

    private void localFuncCheck() {
      Debag("*** localFuncCheck CHECK >>> ", Color.Green);

      Regex regFunc = new Regex(@"(( )*(function)( )*([\w]+)( )*(\([\w| |,]*\)))");
      Regex regFuncComent = new Regex(@"((?>--)(?>\[\[\.*)*( )*(function)( )*([\w]+)( )*(\([\w| |,]*\)))");
      Regex regLocalFunc = new Regex(@"((local)( )*(function)( )*([\w]+)( )*(\([\w| |,]*\)))");
      Regex regLocalFuncComent = new Regex(@"((?>--)(?>\[\[\.*)*( )*(local)( )*(function)( )*([\w]+)( )*(\([\w| |,]*\)))");

      for (int m = 0; m < modules.Count; m++) {
        List<string> code = modules[m].GetTrigCode("");
        for (int c = 0; c < code.Count; c++) {
          if (regFunc.IsMatch(code[c]) && !regLocalFunc.IsMatch(code[c]) && !regFuncComent.IsMatch(code[c])) {
            Debag("Функция Не Локальная\t" + modules[m].GetName() + "\t строка № " + c + "\n\t" + code[c],
                  Color.Blue);
          }
        }
      }
      Debag("<<< localFuncCheck CHECK *** ", Color.Green);
    }

    private void localVarCheck() {
      Debag("*** localVarCheck CHECK >>> ", Color.Green);

      for (int m = 0; m < modules.Count; m++) {
        Debag(modules[m].GetName());
        List<string> code = modules[m].GetTrigCode("");
        List<List<string>> funcs = getFunctions(code);
        for (int f = 1; f < funcs.Count; f++) {
          Debag("\t" + funcs[f][0]);
        }
      }
      Debag(">>> localVarCheck CHECK *** ", Color.Green);

    }

    private void bbtCheck() {
      string path = repDir + "exe\\assets\\strings.xml";
      if (levelName.EndsWith("ext"))
        path = repDir + "exe\\assets\\strings_ce.xml";
      Debag("*** BBT CHECK >>> " + path, Color.Green);

      List<string> sss = LoadXML(path);
      List<Propobj> strings = Compare_GetProps(sss);
      Debag("COUNT " + strings.Count);
      //for (int i = 0; i < strings.Count; i++)
      //{
      //    Debag(strings[i].Propertie("id"));
      //}
      //for (int i = 0; i < sss.Count; i++)
      //{
      //    Debag(sss[i]);
      //}

      Dictionary<string, bool> id_in_strings = new Dictionary<string, bool>();

      foreach (Propobj prop in strings) {
        string val = prop.Propertie("id");
        if (
          val.StartsWith("bbt_")
          || val.StartsWith("ifo_")
          || val.StartsWith("pop_")
        ) {
          id_in_strings[val] = true;
        }
      }

      Debag("\nmiss INFO >>>", Color.Red);
      for (int i = 0; i < progress_names.Count; i++) {
        if (progress_names[i].StartsWith("win_")) {
          string nm = progress_names[i].Substring(4);
          Propobj ifo = Compare_GetPropByID("ifo_" + nm, strings);
          if (ifo == null) {
            if (GetObj("ho_" + nm) == null)
              Debag("ifo_" + nm);
          }
          else {
            id_in_strings["ifo_" + nm] = false;
          }
        }
      }
      Debag("<<<miss INFO\n", Color.Red);

      List<MyObjClass> ao = GetAllObjs();
      string objs_with_bad_bbt = "";
      string objs_with_bad_pop = "";
      string miss_bbt = "";
      string miss_pop = "";
      string miss_objs = "";
      for (int a = 0; a < ao.Count; a++) {
        MyObjClass o = ao[a];
        bool need_check = false;
        string md = o.GetPropertie("event_mdown");
        List<string> bbt = bbtFind(md);
        if (bbt.Count > 0) {
          for (int b = 0; b < bbt.Count; b++) {
            if (Compare_GetPropByID("bbt_" + bbt[b], strings) == null) {
              //Debag("bbt_" + bbt[b], Color.Red);
              miss_bbt += "\t" + "bbt_" + bbt[b] + "\n";
              need_check = true;
            }
            else {
              string id = "bbt_" + bbt[b];
              id_in_strings[id] = false;
              string val = Compare_GetPropByID("bbt_" + bbt[b], strings).Propertie("val");
              if (val == null)
                val = "";
              val = val.Replace("<![CDATA[", "").Replace("]]>", "");
              if (id.StartsWith("bbt_need") && val == "need " + id.Replace("bbt_need_", "") || id == val) {
                //miss_objs += "\t" + "bbt_" + bbt[b] + " >> " + (o != null ? o.GetName() : "null") + "\n";
                miss_objs += o.GetModule().GetName() + "\t";
                if (o.GetOwnerControl() != null) {
                  miss_objs += o.GetOwnerControl().getNamePrefix() == "zz" ? o.GetOwnerControl().GetName() : "X";
                }
                else {
                  miss_objs += o.GetName() + "XXX";
                }
                miss_objs += "\t\t\t" + "bbt_" + bbt[b];
                miss_objs += "\n";
              }
            }
          }
          if (need_check && bbtBadFinded(md)) {
            //Debag("\t\tbbt_ in   OBJ   " + o.GetName() + "\n\t\t\t" + md, Color.Red);
            objs_with_bad_bbt += "\t" + o.GetName() + "\n";
          }

          //PopUpFind(string md)
        }

        need_check = false;
        md = o.GetPropertie("event_menter");
        List<string> pop = PopUpFind(md);
        if (pop.Count > 0) {
          for (int b = 0; b < pop.Count; b++) {
            if (Compare_GetPropByID(pop[b], strings) == null) {
              //Debag(pop[b], Color.Red);
              miss_pop += "\t" + pop[b] + "\t" + (o.GetMyControl() != null ? o.GetMyControl().GetDefResName() : "null") + "\n";
              need_check = true;
            }
            else {
              id_in_strings[pop[b]] = false;
            }
          }
          if (need_check && PopUpBadFinded(md)) {
            //Debag("\t\tpop_ in   OBJ   " + o.GetName() + "\n\t\t\t" + md, Color.Red);
            objs_with_bad_pop += "\t" + o.GetName() + "\n";
          }

        }

      }

      Debag("\nmiss bbt OBJS >>>", Color.Red);
      Debag(miss_objs);

      Debag("miss ID in strings BBT>>>", Color.Red);
      Debag(miss_bbt);

      Debag("not used ID in strings >>>", Color.Red);
      foreach (KeyValuePair<string, bool> kvp in id_in_strings) {
        if (kvp.Value)
          Debag(kvp.Key);
      }

      Debag("bad BBT objs>>>", Color.Red);
      Debag(objs_with_bad_bbt);
      Debag("miss ID in strings POP>>>", Color.Red);
      Debag(miss_pop);
      Debag("bad POP objs>>>", Color.Red);
      Debag(objs_with_bad_pop);



      for (int m = 0; m < modules.Count; m++) {
        List<string> code = modules[m].GetTrigCode("");
        for (int c = 0; c < code.Count; c++) {
          List<string> bbt = bbtFind(code[c]);
          if (bbt.Count > 0) {
            for (int b = 0; b < bbt.Count; b++) {
              Propobj po = Compare_GetPropByID("bbt_" + bbt[b], strings);
              if (po == null) {
                Debag("\tmiss ID in strings " + "bbt_" + bbt[b], Color.Red);
              }
            }
            if (bbtBadFinded(code[c]))
              Debag("\tbbt_ in   MODULE   " + modules[m].GetName() + " string № " + c + "\n>>>\n" + code[c] + "\n<<<", Color.Red);
          }

          List<string> pop = PopUpFind(code[c]);
          if (pop.Count > 0) {
            for (int b = 0; b < pop.Count; b++) {
              Propobj po = Compare_GetPropByID(pop[b], strings);
              if (po == null) {
                Debag("\tmiss ID in strings " + pop[b], Color.Red);
              }
            }
            if (bbtBadFinded(code[c]))
              Debag("\tpop_ in   MODULE   " + modules[m].GetName() + " string № " + c + "\n>>>\n" + code[c] + "\n<<<", Color.Red);
          }
        }
      }


      //if (po.Propertie("val") == "need " + bbt[b].Replace("_", ""))
      //{
      //    Debag("Заглушка в " + "bbt_" + bbt[b]);
      //}
      Debag("string check >>>");
      Regex rx = new Regex("[а-яА-Я]");
      for (int i = 0; i < strings.Count; i++) {
        Propobj po = strings[i];
        string id = po.Propertie("id");
        string val = po.Propertie("val");
        if (val == null)
          continue;
        val = val.Replace("<![CDATA[", "").Replace("]]>", "");
        //Debag("<<"+id+">>\t<<"+val+">>");
        if (id.StartsWith("bbt_need") && val == "need " + id.Replace("bbt_need_", "")) {
          Debag("\tЗаглушка в bbt_NEED >> \t" + id + " >> \t" + val);
        }
        else if (id.StartsWith("pop_inv_") && val == id.Replace("pop_inv_", "")) {
          Debag("\tЗаглушка в pop_INV >> \t" + id + " >> \t" + val);
        }
        else if (id.StartsWith("pop_") && val == id.Replace("pop_", "")) {
          Debag("\tЗаглушка в pop_RM >> \t" + id + " >> \t" + val);
        }
        else if (rx.IsMatch(val)) {
          Debag("\tРусский текст >> \t" + id + " >> \t" + val);
        }
        else if (id == val) {
          Debag("\tЗаглушка >> \t" + id + " >> \t" + val);
        }
        else if (id.StartsWith("bbt_") && id.Substring(4) == val) {
          Debag("\tЗаглушка >> \t" + id + " >> \t" + val, Color.Red);
        }

      }


      //ДИАЛГИ
      Debag("DLG >>>");
      List<string> MISS_DLG = new List<string>();
      for (int m = 0; m < modules.Count; m++) {
        List<string> code = modules[m].GetTrigCode("");

        List<string> func = getFunction(code, "public.SwitchFrase", false);

        string marker_dlg_name = "dlg_name == \"";
        int id = FindId(func, marker_dlg_name);

        string dlg_name = "";
        string dlg_room = modules[m].GetName().Substring(3);

        while (id > -1) {
          bool answer = false;
          string s = func[id];
          s = s.Substring(s.IndexOf(marker_dlg_name) + marker_dlg_name.Length);
          dlg_name = s.Substring(0, s.IndexOf("\""));


          string count_txt = "0";
          string marker = "count_txt == ";
          int count_txt_id = FindId(func, marker, id);
          while (count_txt_id > -1) {
            s = func[count_txt_id];
            s = s.Substring(s.IndexOf(marker) + marker.Length);
            s = s.Substring(0, s.IndexOf(" "));

            if (Convert.ToInt16(count_txt) >= Convert.ToInt16(s))
              break;

            count_txt = s;

            //Debag(">>> " + dlg_name + " >>> " + dlg_room + " >>> " + count_txt);

            int frase_id = FindId(func, "common_impl.frases", count_txt_id);
            int continue_id = FindId(func, "common_impl.continue_visible", count_txt_id);

            if (frase_id > -1 && FindId(func, marker, count_txt_id + 1) > -1 && frase_id < FindId(func, marker, count_txt_id + 1)) {
              string nums = func[frase_id];
              nums = nums.Substring(nums.IndexOf("{") + 1);
              nums = nums.Trim();
              string n = "";
              while (nums.IndexOf(",") > -1) {
                n = nums.Substring(0, nums.IndexOf(","));
                n = n.Trim();

                MISS_DLG.Add("str_" + dlg_room + "_" + dlg_name + "_question_" + n);
                if (("str_" + dlg_room + "_" + dlg_name + "_question_" + n).IndexOf(" ") > -1)
                  Debag("111\t" + ("str_" + dlg_room + "_" + dlg_name + "_question_" + n));

                nums = nums.Substring(nums.IndexOf(",") + 1);

              }

              n = nums.Substring(0, nums.IndexOf("}"));
              n = n.Trim();
              MISS_DLG.Add("str_" + dlg_room + "_" + dlg_name + "_question_" + n);
              MISS_DLG.Add("str_" + dlg_room + "_" + dlg_name + "_answer_" + n);

              answer = true;

              if (("str_" + dlg_room + "_" + dlg_name + "_question_" + n).IndexOf(" ") > -1)
                Debag("222\t" + ("str_" + dlg_room + "_" + dlg_name + "_question_" + n));

            }
            //else if (continue_id > -1 && FindId(func, marker, count_txt_id + 1) > -1 && continue_id < FindId(func, marker, count_txt_id + 1))
            else if (FindId(func, marker, count_txt_id + 1) > -1 && frase_id < FindId(func, marker, count_txt_id + 1)) {
              if ((FindId(func, marker_dlg_name, id + 1) > -1
                   && FindId(func, marker, count_txt_id + 1) < FindId(func, marker_dlg_name, id + 1))
                  || (FindId(func, marker_dlg_name, id + 1) == -1)
                 ) {
                if (!answer)
                  MISS_DLG.Add("str_" + dlg_room + "_" + dlg_name + "_" + count_txt);
              }
              answer = false;
            }
            count_txt_id = FindId(func, marker, count_txt_id + 1);


          }

          //Debag("str_"+dlg_room +"_"+ dlg_name,Color.Blue);
          //Debag(func);
          id = FindId(func, marker_dlg_name, id + 1);
        }

      }
      for (int i = 0; i < MISS_DLG.Count; i++) {
        Propobj po = Compare_GetPropByID(MISS_DLG[i], strings);
        if (po == null || po.Propertie("val").Length == 0) {
          Debag("\t" + MISS_DLG[i], Color.Red);
        }
      }
      Debag("DLG <<<");



      Debag("<<< BBT CHECK *** " + path, Color.Green);

    }

    bool bbtBadFinded(string md) {
      string marker = "ShowBbt(";
      while (md.IndexOf(marker) > -1) {
        //Debag(o.GetName()+"\t"+md);
        md = md.Substring(md.IndexOf(marker) + marker.Length);
        if (md.IndexOf(")") > -1) {
          string mds = md.Substring(0, md.IndexOf(")"));
          mds = mds.Replace("&quot;", "\"");
          mds = mds.Replace("&apos;", "\"");
          if (mds.IndexOf("\"") > -1) {
            mds = mds.Substring(mds.IndexOf("\"") + 1);
            //Debag("\t" + mds);
            if (mds.StartsWith("bbt_"))
              return true;
          }
        }
      }
      return false;
    }

    List<string> bbtFind(string md) {
      List<string> fs = new List<string>();
      string marker = "ShowBbt(";
      while (md.IndexOf(marker) > -1) {
        //Debag(o.GetName()+"\t"+md);
        md = md.Substring(md.IndexOf(marker) + marker.Length);
        if (md.IndexOf(")") > -1) {
          string mds = md.Substring(0, md.IndexOf(")"));
          mds = mds.Replace("&quot;", "\"");
          mds = mds.Replace("&apos;", "\"");
          mds = mds.Replace("'", "\"");
          if (mds.IndexOf("\"") > -1) {
            mds = mds.Substring(mds.IndexOf("\"") + 1);
            mds = mds.Substring(0, mds.IndexOf("\""));

            //Debag("\t" + mds);
            fs.Add(mds);
          }
        }
      }
      return fs;
    }
    bool PopUpBadFinded(string md) {
      string marker = "PopupShow(";
      while (md.IndexOf(marker) > -1) {
        //Debag(o.GetName()+"\t"+md);
        md = md.Substring(md.IndexOf(marker) + marker.Length);
        if (md.IndexOf(")") > -1) {
          string mds = md.Substring(0, md.IndexOf(")"));
          mds = mds.Replace("&quot;", "\"");
          mds = mds.Replace("&apos;", "\"");
          if (mds.IndexOf("\"") > -1) {
            mds = mds.Substring(mds.IndexOf("\"") + 1);
            //Debag("\t" + mds);
            if (mds.StartsWith("pop_"))
              return true;
          }
        }
      }
      return false;
    }

    List<string> PopUpFind(string md) {
      List<string> fs = new List<string>();
      string marker = "PopupShow(";
      while (md.IndexOf(marker) > -1) {
        //Debag(o.GetName()+"\t"+md);
        md = md.Substring(md.IndexOf(marker) + marker.Length);
        if (md.IndexOf(")") > -1) {
          string mds = md.Substring(0, md.IndexOf(")"));
          mds = mds.Replace("&quot;", "\"");
          mds = mds.Replace("&apos;", "\"");
          if (mds.IndexOf("\"") > -1) {
            mds = mds.Substring(mds.IndexOf("\"") + 1);
            mds = mds.Substring(0, mds.IndexOf("\""));

            //Debag("\t" + mds);
            fs.Add(mds);
          }
        }
      }
      return fs;
    }

    //проверка ресурсов для когтрола
    public void CheckProjectResources(MyControl mc, Dictionary<string, Propobj> objs = null) {
      if (objs == null) {
        objs = new Dictionary<string, Propobj>();
      }
      bool pos_checking = true;


      string propObjString =
        "<obj name=\"default\" res=\"default\" in_obj=\"0\" in_anim=\"0\" in_fx=\"0\" ignored=\"0\" position=\"\"\\>";
      Propobj propObj = new Propobj(propObjString);

      List<MyObjClass> aol = GetAllObjs();
      List<List<string>> animL = new List<List<string>>();
      List<List<string>> fxL = new List<List<string>>();

      Dictionary<string, List<string>> ANM = new Dictionary<string, List<string>>();

      DialogResult mbrz =
        System.Windows.Forms.DialogResult.No; //MessageBox.Show("изменять pos_z для объектов по расположению в POSITION ?","", MessageBoxButtons.YesNo);

      string asets = levelDir.Replace(projectDir, "") + "\\exe\\";

      List<ModuleClass> mod = new List<ModuleClass>();
      try {
        mod.Add(mc.GetOwnerObj().GetModule());
      }
      catch {
        MessageBox.Show("CheckProjectResources >>> Отсутствует контрол");
        return;
      }


      for (int m = 0; m < mod.Count; m++) {
        //if (mod[m].GetName() == levelName + "_inv")
        //    continue;
        //Debag("modules[m].GetName() " + modules[m].GetName());
        //if(modules[m].GetName()!="rm_smallsquare2")
        //    continue;
        List<MyControl> mcl = new List<MyControl>();
        mcl.Add(mc);
        for (int c = 0; c < mcl.Count; c++) {
          List<string> fassets = new List<string>();
          //if (mcl[c].GetName() != "zz_bush")
          //{
          //    //Debag("*" + mcl[c].GetName() + "*");
          //    continue;
          //}
          //Debag("Сканим " + mcl[c].GetName());
          string rmnm = "";
          //MessageBox.Show(mod[m].GetName());
          if (mod[m].GetName() == levelName + "_inv") {
            rmnm = "inv_deploy\\";
          }
          else if (mcl[c].GetName().StartsWith("zz_")) {
            rmnm = mod[m].GetName() + "\\";
          }

          string scanPath = levelDir + "\\" + rmnm + mcl[c].GetName();
          if (ARG_STR.ContainsKey("creation_only_inside_folder")){
            scanPath += ARG_STR["creation_only_inside_folder"];
          }

          string[] files = Directory.GetFiles(scanPath);
          if (Directory.Exists(scanPath + "\\layers")) {
            files = files.Concat(Directory.GetFiles(scanPath + "\\layers")).ToArray();
            string[] subfolders = Directory.GetDirectories(scanPath + "\\layers");
            foreach (var subfolder in subfolders) {
              files = files.Concat(Directory.GetFiles(subfolder)).ToArray();
            }
          }
          if (Directory.Exists(scanPath + "\\anims")) {
            files = files.Concat(Directory.GetFiles(scanPath + "\\anims")).ToArray();
            string[] subfolders = Directory.GetDirectories(scanPath + "\\anims");
            foreach (var subfolder in subfolders) {
              files = files.Concat(Directory.GetFiles(subfolder)).ToArray();
            }
          }
          

          List<string> fl = mStrToList(files, scanPath + "\\");

          //удаляем стандартные файлы
          for (int f = 0; f < fl.Count(); f++) {
            if (fl[f].IndexOf(".") == -1) {
              MessageBox.Show("\t* Отсутствует расширение файла!! \t *" + fl[f] + "*");
              return;
            }
            if (isWrongSimbols(fl[f].Substring(0, fl[f].LastIndexOf(".")))) {
              //MessageBox.Show("\t* неправильные символы в файле \t *" + fl[f] + "*");
            }
            if (fl[f] == "miniback.jpg"
                //| fl[f] == "back.jpg"
                | fl[f].EndsWith(".txt")
                | fl[f].EndsWith(".oggalpha")
                | fl[f].EndsWith(".lua")
                | fl[f].EndsWith(".srt")
                | fl[f].IndexOf("mod_") == 0
                //| fl[f].IndexOf("inv_") == 0 // закомментировать если будут встречаться имена не у инвентарников начинающиеся с inv
                ) {
              //

              //
              //Debag(fl[f]);
              fl.RemoveAt(f);
              f--;
            }
            else {
              string s = ("assets\\levels\\" + levelName + "\\" + rmnm + mcl[c].GetName() + ARG_STR["creation_only_inside_folder"]
                          +"\\" + fl[f]);
              fassets.Add(s.Substring(0, s.IndexOf(".")));

              propObj = new Propobj(propObjString);
              propObj.SetPropertie("name", fl[f]);
              propObj.SetPropertie("res", fassets[fassets.Count - 1]);

              bool bb;
              if (loadedIgnoreBool.TryGetValue(fassets[fassets.Count - 1], out bb)) {
                if (bb)
                  propObj.SetPropertie("ignored", "1");
                else
                  propObj.SetPropertie("ignored", "0");
              }

              objs[fl[f]] = propObj;

              //Debag(objs.Count + " add to " + fl[f] +" " + objs[fl[f]].Propertie("name"));

            }
          }

          Dictionary<string, string> duplicates = new Dictionary<string, string>();

          //сортируем по файлу position
          string[] posf = Directory.GetFiles(levelDir + "\\" + rmnm + mcl[c].GetName() + ARG_STR["creation_only_inside_folder"],
                                             "*.txt");
          List<string> posfl = mStrToList(posf);
          string duplicatesInPosition = "";
          for (int pf = 0; pf < posfl.Count; pf++) {
            if (posfl[pf].IndexOf("position") > -1) {
              List<string> posL = LoadXML(posfl[pf]);
              for (int p = 0; p < posL.Count; p++) {
                string s = posL[p].Replace(",", "");
                if (s.Length < 1)
                  continue;

                if (s.IndexOf(" ") < 0) {
                  MessageBox.Show("В файле " + posfl[pf] + "\n в строке " + p + "\n*" + s +
                                  "*\n неправильный формат данных");
                }
                else {
                  string nm = s.Substring(0, s.IndexOf(" "));
                  if(duplicates.ContainsKey(nm)) {
                    duplicates[nm] += "\n" + posfl[pf];
                    duplicatesInPosition += nm + " >> " + duplicates[nm];
                  }
                  else {
                    duplicates[nm] = posfl[pf];
                  }
                  for (int ff = 0; ff < fl.Count; ff++) {
                    if (fl[ff] == (nm + ".png") || fl[ff] == (nm + ".jpg")) {

                      objs[fl[ff]].SetPropertie("position", objs[fl[ff]].Propertie("position") + posfl[pf] + ";");

                      string flf = fl[ff];
                      fl.RemoveAt(ff);
                      fl.Insert(0, flf);

                      string flfa = fassets[ff];
                      fassets.RemoveAt(ff);
                      fassets.Insert(0, flfa);

                      break;
                    }
                  }
                }
              }
            }
          }
          if(!string.IsNullOrEmpty(duplicatesInPosition))
            MessageBox.Show("Дублирубтся позиции для объектов \n\n" + duplicatesInPosition);


          //List<MyObjClass> ol = mcl[c].GetAllObjs();
          List<MyObjClass> ol = mcl[c].GetOwnerObj().GetModule().AllObjs;


          //проверяем для списка файлов в папке
          for (int f = 0; f < fl.Count(); f++) {

            //Debag(fl[f]);
            bool fused = false; //старший маркер использованности файла
            //проверяем для объектов комнаты
            for (int o = 0; o < ol.Count(); o++) {
              //Debag("*"+ol[o].GetPropertie("res").Replace("/", "\\") + "*   ==   *" + "assets\\levels\\" + levelName + "\\" + mc.GetName() + "\\" + fl[f]+"*");
              string ores = ol[o].GetPropertie("res").Replace("/", "\\");
              string fres = ("assets\\levels\\" + levelName + "\\" + rmnm + mcl[c].GetName() + ARG_STR["creation_only_inside_folder"]
                             + "\\" + fl[f]);
              fres = fres.Substring(0, fres.IndexOf("."));

              //Debag( ol[o].GetName() + " => "+ ores + "___" + fres);
              if (ores == fres) { // || ores == "")
                //Debag("\t res included for " + ol[o].GetName() + " " + fres);
                objs[fl[f]].SetPropertie("in_obj", ol[o].GetName());


                fused = true;
                break;
              }
            }
            if (!fused) {
              //if (fl[f] == "bulb.png")
              //{
              //    Debag("File " + fl[f] + " не найден в объекте комнаты ");
              //    Debag("f " + f + "; c "+c+"; cname "+mcl[c].GetName());
              //}
            }
            else {
              string pict = "";
              if (fl[f].EndsWith(".png")) {
                pict = PositionParser.ClearSubfoldersAndExtension(fl[f]);
              }
              if (pict.Length > 0) {
                string[] txtFiles = Directory.GetFiles(levelDir + "\\" + rmnm + mcl[c].GetName() +
                                                       ARG_STR["creation_only_inside_folder"], "*.txt");
                List<string> txtFL = mStrToList(txtFiles);

                //Debag("подключаем файл " + rmnm + mcl[c].GetName() + "\\" + fl[f]);
                bool spr_created = false;
                for (int txt = 0; txt < txtFL.Count & !spr_created; txt++) {
                  if (txtFL[txt].IndexOf("position") > -1
                      //|| txtFL[txt].IndexOf("position.txt") >-1
                      //|| txtFL[txt].IndexOf("position_") >-1
                      //|| txtFL[txt].IndexOf("_position.txt") >-1
                     ) {
                    List<string> posL = LoadXML(txtFL[txt]);
                    for (int p = 0; p < posL.Count; p++) {


                      string s = posL[p].Replace(",", "");
                      if (s.Length < 3) //Видимо это игнор коротких записей
                        continue;
                      string[] parcedLine = PositionParser.Parse(s);
                      string nm = parcedLine[0];
                      //Debag("p " + p + " txt " +txt + "   " + nm + "   " + fl[f].Substring(0, fl[f].IndexOf(".")));
                      if (nm == PositionParser.ClearSubfoldersAndExtension(fl[f])) {  
                        try {
                          string px = parcedLine[1];
                          string py = parcedLine[2];

                          MyObjClass hobj = GetObj("spr_" + mc.getNamePost() + "_" + pict);
                          //MessageBox.Show("spr_" + mc.getNamePost() + "_" + pict); // проверка имени объекта для сравнения
                          if (hobj != null) {
                            //MessageBox.Show(hobj.GetName() + " * " + hobj.GetPropertie("pos_x") + " * " + hobj.GetPropertie("pos_y") + " * " + px + " * " + py);
                            string opx = hobj.GetPropertie("pos_x");
                            string opy = hobj.GetPropertie("pos_y");
                            opx = opx == "" ? "0" : opx;
                            opy = opy == "" ? "0" : opy;
                            //MessageBox.Show(pict + " " + opx + " " + opy + " " + px + " " + py + " "); // проверка отличаются ли координаты у уже добавленного объекта от позишена
                            if (pos_checking && (opx != px || opy != py)) {
                              string msg = "изменить х, у для  " + hobj.GetName() + "?";
                              string anim_tag;
                              if (hobj.IsTaggedByAnim(out anim_tag)) {
                                msg += "\n\n Объект находится под влиянием anim_tag *" + anim_tag + "*\n";
                              }
                              msg += "\n{ x = " + hobj.GetPropertie("pos_x") + "; y = " + hobj.GetPropertie("pos_y") + " } => { x = " + px + "; y = "
                                     + py + " }";
                              DialogResult mbr = MessageBox.Show(msg, "pos x,y replace", MessageBoxButtons.YesNoCancel);
                              if (mbr == DialogResult.Cancel) {
                                pos_checking = false;
                              }
                              if (mbr == DialogResult.Yes) {
                                Debag(hobj.GetName() + "\tpos_x(" + hobj.GetPropertie("pos_x") + ")=" + px + "\tpos_y(" + hobj.GetPropertie("pos_y") +
                                      ")=" + py);
                                hobj.SetPropertie("pos_x", px);
                                hobj.SetPropertie("pos_y", py);
                                if (ARG_CMD["creation_only"]) {
                                  SaveProject();
                                }
                              }
                            }

                            if (mbrz == DialogResult.Yes) {
                              Debag(hobj.GetName() + "\tpos_z(" + hobj.GetPropertie("pos_z") + ")=" + (posL.Count - p));
                              hobj.SetPropertie("pos_z", (posL.Count - p).ToString());
                            }
                            //hobj.ReAtach();

                          }
                        }
                        catch (System.Exception excep) {
                          MessageBox.Show("не удалось обработать " + posL[p]);
                          MessageBox.Show(excep.Message);
                        }

                        break;
                      }
                    }
                  }
                }
              }

              //Debag(fl[f] + "   найден в объекте комнаты");
              //fl.RemoveAt(f);
              //fassets.RemoveAt(f);
              //f--;
            }
          }

          string text = this.Text;
          int fl_count_max = fl.Count();
          int fl_count_now = 0;

          string xmlScanPath = levelDir + "\\" + rmnm + mcl[c].GetName() + ARG_STR["creation_only_inside_folder"];
          string[] xmlFiles = Directory.GetFiles(xmlScanPath, "*.xml"); //search all xml files in current folder
          if (Directory.Exists(xmlScanPath + "\\anims"))
            xmlFiles = xmlFiles.Concat(Directory.GetFiles(xmlScanPath + "\\anims")).ToArray(); //search all xml files in \\anims folder

          List<string> xmlFL = mStrToList(xmlFiles);
          for (int f = 0; f < fl.Count(); f++) {
            fl_count_now++;
            this.Text = ((fl_count_now * 100) / (fl_count_max)) + " %";
            //проверяем файл для частиц
            for (int x = 0; x < xmlFL.Count; x++) {
              int id = 0;
              List<string> ps = LoadXML(xmlFL[x]);
              id = FindId(ps, "<ps type = \"jan\">");
              while (id > -1) {
                id = FindId(ps, "res = ", id + 1);
                if (id > -1) {
                  string res = ps[id];
                  res = res.Substring(res.IndexOf("\"") + 1);
                  res = res.Substring(0, res.IndexOf("\""));

                  string rf = fl[f].Substring(0, fl[f].IndexOf("."));
                  rf = "assets\\levels\\" + levelName + "\\" + rmnm + mcl[c].GetName() + ARG_STR["creation_only_inside_folder"] + "\\" +
                       rf;
                  if ((res == rf)
                      && (fl[f].EndsWith(".png") ||(fl[f].EndsWith(".jpg")) ) ) {
                    objs[fl[f]].SetPropertie("in_fx", "1");
                    break;
                  }
                }
              }

              id = FindId(ps, "<ps type=\"rnd\"");
              while (id > -1) {
                id = FindId(ps, " res=\"", id + 1);
                if (id > -1) {
                  string res = ps[id].Substring(ps[id].IndexOf(" res=\"") + 1);
                  res = res.Substring(res.IndexOf("\"") + 1);
                  res = res.Substring(0, res.IndexOf("\""));

                  string rf = fl[f].Substring(0, fl[f].IndexOf("."));
                  rf = "assets\\levels\\" + levelName + "\\" + rmnm + mcl[c].GetName() + ARG_STR["creation_only_inside_folder"] + "\\" +
                       rf;
                  Debag(res + " >> " + rf.Substring(rf.LastIndexOf("\\") + 1));
                  if ((res == rf.Substring(rf.LastIndexOf("\\")+1))
                      && (fl[f].EndsWith(".png") || (fl[f].EndsWith(".jpg")))) {
                    objs[fl[f]].SetPropertie("in_fx", "1");
                    break;
                  }
                }
              }
            }

            //проверяем файл для анимаций
            for (int x = 0; x < xmlFL.Count; x++) {
              //Console.WriteLine("\t anm = " + x);
              //Debag("проверяем анимацию файл " + xmlFL[x]);
              int id = 0;

              List<string> ps;// = LoadXML(xmlFL[x]);
              if (!ANM.TryGetValue(xmlFL[x], out ps)) {
                //MessageBox.Show(xmlFL[x]);
                ps = LoadXML(xmlFL[x]);
                if (FindId(ps, "<animation") > -1) {
                  xmlReload(ps, " res=\"");
                  //MessageBox.Show(xmlFL[x]);// + ARG_STR["creation_only_inside_folder"]
                  ANM[xmlFL[x]] = ps;

                  //for (int aaa = 0; aaa < ps.Count; aaa++)
                  //    Console.WriteLine(ps[aaa]);
                }
                else {
                  ps = null;
                }

              }

              if (ps == null)
                continue;
              bool next = true;
              int count = 0;
              while (id > -1 & next & f > -1) {
                //Debag(xmlFL[x] + " " + id);
                id = FindId(ps, " res=\"", count);

                if (id > -1) {
                  string res = ps[id];
                  res = res.Substring(res.IndexOf(" res=\"") + 6);
                  res = res.Substring(0, res.IndexOf("\""));

                  string rf = fl[f];
                  if (fl[f].IndexOf(".") > -1) {
                    rf = fl[f].Substring(0, fl[f].IndexOf("."));
                  }
                  //MessageBox.Show(res + " " + res.Replace(mcl[c].GetDefResName().Replace("\\", "/"), "") + " " + rf.Replace("anims\\", ""));
                  if (( (res == rf) || ( res.Replace(mcl[c].GetDefResName().Replace("\\", "/"), "") == rf.Replace("anims\\", "")))
                      && (fl[f].EndsWith(".png") ||(fl[f].EndsWith(".jpg")) ) ) {
                    objs[fl[f]].SetPropertie("in_anim", "1");

                    next = false;
                    break;
                  }
                  count++;
                }

              }

              //Debag(count + "\t" + xmlFL[x]);

            }
          }
          this.Text = text;



        }
      }

      ObjAddingForm oaf = new ObjAddingForm(this, mc, objs);
      oaf.Show();
      return;

    }

    public void logWrite(string message, int type) {

      /* type:
         0 - серый текст
         1 - черный текст
         2 - синий текст
         3 - красный текст
      */

      richTextBox1.SelectionColor = Color.DarkGray;
      richTextBox1.AppendText("        [ " + DateTime.Now.TimeOfDay.Hours.ToString() + ":" +
                              DateTime.Now.TimeOfDay.Minutes.ToString() + " ]: ");

      Color textColor = Color.Black;
      switch (type) {
        case 0:
          textColor = Color.DarkGray;
          break;
        case 1:
          textColor = Color.Black;
          break;
        case 2:
          textColor = Color.Blue;
          break;
        case 3:
          textColor = Color.Red;
          break;
      }
      richTextBox1.SelectionColor = textColor;
      richTextBox1.AppendText(message + "\n");
      richTextBox1.SelectionStart = richTextBox1.Text.Length;
      richTextBox1.ScrollToCaret();
    }

    private void buttonRestart_Click(object sender, EventArgs e) {
      Application.Restart();
    }

    private void treeView1_MouseEnter(object sender, EventArgs e) {
      SetTreeViewMaxWidth();
    }

    public void SetTreeViewMaxWidth() {
      int wid = 0;
      int cor = 10;
      foreach (TreeNode node in treeView1.Nodes) {
        wid = Math.Max(wid, node.Bounds.Right);
        if (node.Nodes.Count > 0) {
          if (wid < getNodeWidth(node))
            wid = getNodeWidth(node);

        }
      }

      treeView1.Width = wid + cor;
    }

    private int getNodeWidth(TreeNode NODE) {
      int wid = 0;
      int cor = 10;
      foreach (TreeNode node in NODE.Nodes) {
        wid = Math.Max(wid, node.Bounds.Right);
        if (node.Nodes.Count > 0) {
          if (wid + cor < getNodeWidth(node) + cor)
            wid = getNodeWidth(node) + cor;
        }
      }
      return wid;
    }

    private void treeView1_MouseLeave(object sender, EventArgs e) {
      treeView1.Width = 30;
    }

    private void buttonLevLogicBuild_Click(object sender, EventArgs e) {
      if(modules == null || modules.Count==0) {
        MessageBox.Show("Уровень не загружен!");
        return;
      }

      int lvl = 0;
      string lvl_str = "";

      OpenFileDialog ofd = new OpenFileDialog();
      ofd.Filter = "Logic file (.lev)|*.lev";
      ofd.DefaultExt = repDir + "src\\doc\\Logic\\";
      DialogResult mbr = ofd.ShowDialog();

      if (mbr == DialogResult.OK) {
        ProgresBarSet(0, 1, "Загружаю файл логики");

        string s = ofd.FileName;
        //Debag(s);
        s = s.Substring(s.LastIndexOf("\\") + 1);
        //Debag(s);
        char[] ch = s.ToCharArray();
        bool lvl_seted = false;
        for (int i = 0; i < s.Length; i++) {
          if (char.IsDigit(s[i])) {
            lvl = Convert.ToInt16(Convert.ToString(s[i]));
            Debag("Номер уровня -> " + lvl.ToString(), Color.RoyalBlue);
            lvl_seted = true;
            lvl_str = Convert.ToString(s[i]);
            //lvl_str = "";
            break;
          }
        }
        if (!lvl_seted) {
          int pid = s.LastIndexOf("_");
          if (pid > -1) {
            lvl_str = s.Replace(".lev", "").Substring(pid + 1);
            Debag("Имя уровня (будет добавлено к локациям и предметам) -> " + lvl_str,
                  Color.RoyalBlue);
          }

        }
        scheme = new Scheme(ofd.FileName, lvl, lvl_str);
        //return;
      }
      else {
        return;
      }

      mbr = MessageBox.Show("уровень построен?", "", MessageBoxButtons.YesNoCancel);
      if (mbr == DialogResult.Yes) {
        scheme.isLevelBuilded = true;
      }
      else if (mbr == DialogResult.No) {
        scheme.isLevelBuilded = false;
      }
      else {
        return;
      }

      scheme.isExt = false;

      ProgresBarSet(0);

      if (!scheme.isLevelBuilded) {
        schemeCheck(scheme);
      }

      schemeShowNewLocations(scheme);
      schemeShowNewPRG(scheme);

      schemeShowInventary(scheme);

      //scheme.Show();

      if (!scheme.isLevelBuilded)
        schemeBuildLevel(scheme);

      scheme.isLevelBuilded = true;

      if (scheme.isLevelBuilded) {
        schemeBuildLogic(scheme);
      }

      schemeShowText(scheme);

      SetControlsFromConfig();
    }

    void schemeCheck(Scheme scheme) {
      Debag("SchemeCheck", Color.Green);
      int checksCount = 0;
      ProgresBarSet(checksCount, scheme.objectActions.Count, "Проверяю схему");

      foreach (var kvp in scheme.objectActions) {
        checksCount++;
        ProgresBarSet(checksCount, scheme.objectActions.Count, "Проверяю действия в схеме");

        Debag(kvp.Key);
        //try
        //{
        //    if (kvp.Value.actions["use"].Count == 0 && kvp.Value.actions["get"].Count == 0 && kvp.Value.actions["clk"].Count > 1)
        //    {
        //        Debag("Мульти Клик БЛЕАТЬ!!! " + kvp.Key, Color.Red);
        //    }
        //}
        //catch
        //{
        //}
        //Invitem ii = kvp.Value;


        if (GetInvObj("inv_" + kvp.Key) != null) {
          Debag("inv_" + kvp.Key + "\tсуществует");
          Propobj val;
          if (scheme.StartInv.TryGetValue(kvp.Key, out val)) {
            Debag("\tуказан в <start_inventory>", Color.Purple);
          }
          else {
            Debag("\t СОВПАДЕНИЕ ИМЕНИ", Color.Red);
          }
        }
        else {
          //Debag("inv_" + kvp.Key + "\tможет быть создан");
          //Debag(kvp.Key);
          //Debag("\t" + kvp.Value.actions.ContainsKey("get").ToString());
          //if(kvp.Value.actions.ContainsKey("get"))
          //    Debag("\t\t"+kvp.Value.actions["get"].Count);
          //Debag("\t" + kvp.Value.actions.ContainsKey("use").ToString());
          //if (kvp.Value.actions.ContainsKey("use"))
          //    Debag("\t\t" + kvp.Value.actions["use"].Count);
          if ((!kvp.Value.actions.ContainsKey("get")
               || !kvp.Value.actions.ContainsKey("use")) & (!kvp.Value.actions.ContainsKey("clk")
                   && !kvp.Value.actions.ContainsKey("win") && !kvp.Value.actions.ContainsKey("dlg"))) {
            try {
              Propobj inv = scheme.StartInv[kvp.Key];
            }
            catch {
              bool deploy = false;
              for (int i = 0; i < scheme.Blocks.Count; i++) {
                if (scheme.Blocks[i].Type == 4) {
                  //Debag("deploy " + scheme.Blocks[i].ObjName,Color.Purple);
                  if (scheme.Blocks[i].ObjName == kvp.Key)
                    deploy = true;
                }
              }
              if (deploy) {
                Debag("\tdeploy\t" + kvp.Key, Color.Purple);
              }
              else {
                Debag("проверить пару get/use для " + kvp.Key + "\t" + kvp.Value.Name, Color.Red);
              }
            }
          }

          if (!kvp.Value.actions.ContainsKey("get") & !kvp.Value.actions.ContainsKey("use") &
              kvp.Value.actions.ContainsKey("clk")) {
            if (kvp.Value.actions.Count > 1) {
              Debag("Мульти Клик БЛЕАТЬ!!! " + kvp.Key, Color.Red);
            }
          }


        }

      }

      ProgresBarSet(0);
      checksCount = 0;
      for (int b = 0; b < scheme.Blocks.Count; b++) {
        checksCount++;
        ProgresBarSet(checksCount, scheme.objectActions.Count, "Проверяю блоки в схеме");

        Block block = scheme.Blocks[b];
        //Debag("seart for " + block.ObjName);
        string[] prefix = { "zz_", "ho_", "mg_", "rm_" };
        bool bad = false;
        //for (int p = 0; p < prefix.Length; p++)
        //{
        MyControl cntrl = GetControl(block.TypeString + "_" + block.ObjName);
        if (cntrl != null) {
          if (block.OwnerBlock != null) {
            if (cntrl.IsHaveLink(block.OwnerBlock.TypeString + "_" + block.OwnerBlock.ObjName))
              bad = true;
          }
          if (block.ChildBlocks != null) {
            for (int ch = 0; ch < block.ChildBlocks.Count; ch++) {
              if (cntrl.IsHaveLink(block.ChildBlocks[ch].TypeString + "_" + block.ChildBlocks[ch].ObjName))
                bad = true;
            }
          }
        }
        //}
        if (!bad) {
          MyControl mc = GetControl(block.TypeString + "_" + block.ObjName);
          if (mc != null && mc != null && scheme.GetBlockById(scheme.StartBlockID).ObjName != mc.getNamePost()) {

            Debag("повторное имя для " + mc.GetName()
                  + "\n\t указаная стартовая комнат >> " + scheme.GetBlockById(scheme.StartBlockID).ObjName
                  + "\n\t судя по первому прогрессу логики стартовой комнатой должна быть >> "
                  + mc.getNamePost()
                  , Color.Red);
          }
        }
      }
      ProgresBarSet(0);
    }

    void schemeShowInventary(Scheme scheme) {
      Debag("**INVENTARY***");
      for (int a = 0; a < scheme.Actions.Count; a++) {
        string s = "";
        Action act = scheme.Actions[a];
        if (act.TypeString == "get") {
          s += act.Propertie("text") + "\t";
          s += "inv_" + act.ObjName + "\t";
          s += "\t";
          s += "Нет" + "\t";

          for (int b = 0; b < scheme.Blocks.Count; b++) {
            Block block = scheme.Blocks[b];
            if (block.TypeString == "inv" && block.ObjName == act.ObjName)
              s += " DEPLOY ";
          }

          if (act.IsMulGetProj || act.IsMultiGetLev())
            s += " exe\\assets\\levels\\level\\common\\inv ";

          s += "\t";

          for (int aa = 0; aa < scheme.Actions.Count; aa++) {
            Action aact = scheme.Actions[aa];
            if (aact.TypeString == "use" && aact.ObjName == act.ObjName) {
              if (aact.ownerBlock.TypeString == "dlg")
                s += " " + aact.ownerBlock.OwnerBlock.FullName;
              else
                s += aact.ownerBlock.FullName + "; ";

            }
          }

          s += "\t";
          if (act.ownerBlock.TypeString == "dlg") {
            if (act.ownerBlock.OwnerBlock == null)
              MessageBox.Show("у диалога " + act.ownerBlock.FullName +
                              " отсутствует привязка к комнате !!!");
            s += " " + act.ownerBlock.OwnerBlock.FullName;
          }
          else
            s += act.ownerBlock.FullName;

          s += "";
          Debag(s);
        }
      }
      Debag("**INVENTARY***");
    }



    void schemeShowText(Scheme scheme) {
      Debag("***TEXT***");
      //{bbt need}
      Debag("{bbt need}");
      scheme.Actions.Sort(new ActionComareOwner());
      for (int a = 0; a < scheme.Actions.Count; a++) {
        string s = "";
        Action act = scheme.Actions[a];
        if (act.TypeString == "use") {
          s += "bbt_need_" + act.PrgName.Substring(4) + "\t";
          s += "DUMMY " + "need " + act.PrgName.Substring(4).ToLower() + "\t";
          s += "применяем " + act.Propertie("text") + "\t";
          if (act.ownerBlock.TypeString == "zz" || act.ownerBlock.TypeString == "dlg")
            s += act.ownerBlock.OwnerBlock.FullName + " >> " + act.ownerBlock.FullName;
          else
            s += "" + act.ownerBlock.FullName + "";
          Debag(s);
        }
      }
      //{pop room}
      Debag("{pop room}");
      for (int b = 0; b < scheme.Blocks.Count; b++) {
        string s = "";
        Block block = scheme.Blocks[b];
        if (block.TypeString == "rm") {
          s += "pop_" + block.ObjName + "\t";
          s += "DUMMY " + block.ObjName.ToLower() + "\t";
          s += block.Propertie("text") + "\t";
          Debag(s);
        }
      }
      //{pop inv}
      Debag("{pop inv}");
      Dictionary<string, string> inv = new Dictionary<string, string>();
      for (int a = 0; a < scheme.Actions.Count; a++) {
        Action act = scheme.Actions[a];
        if (act.TypeString == "get") {
          MyObjClass get_inv_obj = GetObj("inv_" + act.ObjName + "_back" );

          string res = " # NO OWNER #";
          if (get_inv_obj != null) {
            //res = " res = " + get_inv_obj.GetPropertie("res");
            try {
              res = " " + get_inv_obj.GetPropertie("res").Substring(get_inv_obj.GetPropertie("res").LastIndexOf("/") + 1);
            }
            catch {
              res = " " + get_inv_obj.GetPropertie("res").Substring(get_inv_obj.GetPropertie("res").LastIndexOf("\\") + 1);
            }
          }
          //inv["pop_inv_" + act.ObjName] = "DUMMY " + act.ObjName.ToLower() + res + "\t" + act.Propertie("text");
          inv["pop_inv_" + act.ObjName] = act.Propertie("text") + res + "\t" + act.Propertie("text");

          if(act.IsMultiGetLev() || act.IsMulGetProj)
            inv["pop_inv_" + act.ObjName+"_all"] = act.Propertie("text") + res + "\t" + act.Propertie("text");
        }
      }
      foreach (KeyValuePair<string, string> kvp in inv) {
        Debag(kvp.Key + "\t" + kvp.Value);
      }
      //{ho tsk}
      Debag("{ho tsk}");
      for (int b = 0; b < scheme.Blocks.Count; b++) {
        string s = "";
        Block block = scheme.Blocks[b];
        if (block.TypeString == "ho") {
          s = "";
          s += "tsk_" + block.ObjName + "_" + "aaa" + "\t";
          s += "DUMMY " + "tsk_" + block.ObjName + "_" + "aaa" + "\t";
          Debag(s);
          s = "";
          s += "tsk_" + block.ObjName + "_" + "bbb" + "\t";
          s += "DUMMY " + "tsk_" + block.ObjName + "_" + "bbb" + "\t";
          Debag(s);
          s = "";
          s += "tsk_" + block.ObjName + "_" + "ccc" + "\t";
          s += "DUMMY " + "tsk_" + block.ObjName + "_" + "ccc" + "\t";
          Debag(s);
          s = "";
          s += "tsk_" + block.ObjName + "_" + "ddd" + "\t";
          s += "DUMMY " + "tsk_" + block.ObjName + "_" + "ddd" + "\t";
          Debag(s);
          s = "";
          s += "tsk_" + block.ObjName + "_" + "eee" + "\t";
          s += "DUMMY " + "tsk_" + block.ObjName + "_" + "eee" + "\t";
          Debag(s);
          s = "";
          s += "tsk_" + block.ObjName + "_" + "fff" + "\t";
          s += "DUMMY " + "tsk_" + block.ObjName + "_" + "fff" + "\t";
          Debag(s);
          s = "";
          s += "tsk_" + block.ObjName + "_" + "ggg" + "\t";
          s += "DUMMY " + "tsk_" + block.ObjName + "_" + "ggg" + "\t";
          Debag(s);
          s = "";
          s += "tsk_" + block.ObjName + "_" + "hhh" + "\t";
          s += "DUMMY " + "tsk_" + block.ObjName + "_" + "hhh" + "\t";
          Debag(s);
          s = "";
          s += "tsk_" + block.ObjName + "_" + "iii" + "\t";
          s += "DUMMY " + "tsk_" + block.ObjName + "_" + "iii" + "\t";
          Debag(s);
          s = "";
          s += "tsk_" + block.ObjName + "_" + "jjj" + "\t";
          s += "DUMMY " + "tsk_" + block.ObjName + "_" + "jjj" + "\t";
          Debag(s);
          s = "";
          s += "tsk_" + block.ObjName + "_" + "kkk" + "\t";
          s += "DUMMY " + "tsk_" + block.ObjName + "_" + "kkk" + "\t";
          Debag(s);
          s = "";
          s += "tsk_" + block.ObjName + "_" + "lll" + "\t";
          s += "DUMMY " + "tsk_" + block.ObjName + "_" + "lll" + "\t";
          Debag(s);
        }
      }
      //{info}
      Debag("{info}");
      for (int b = 0; b < scheme.Blocks.Count; b++) {
        string s = "";
        Block block = scheme.Blocks[b];
        if (block.TypeString == "mg") {
          s += "ifo_" + block.ObjName + "\t";
          s += "DUMMY " + "ifo_" + block.ObjName + "\t";
          Debag(s);
        }
        for (int a = 0; a < block.Actions.Count; a++) {
          s = "";
          if (block.Actions[a].TypeString == "win") {
            s += "ifo_" + block.Actions[a].ObjName + "\t";
            s += "DUMMY " + "ifo_" + block.Actions[a].ObjName + "\t";
            Debag(s);
          }
        }
      }
      Debag("***TEXT***");

    }

    void schemeShowSoundScheme(Scheme scheme) {

      Dictionary<Block, string> blockEnv = new Dictionary<Block, string>();

      var addXX = true;

      for (int a = 0; a < scheme.Actions.Count; a++) {
        string env;
        string s = "";
        string xx = "";
        Action act = scheme.Actions[a];
        if ( ( act.TypeString == "use" || ( act.TypeString == "clk" && !act.PrgName.StartsWith("dlg")
                                            && !act.PrgName.StartsWith("mmg") && !act.PrgName.StartsWith("win"))) ) {
          //ОПИСАНИЕ
          if(act.TypeString == "use") {
            xx += "XX по зоне применения ";
            s += "Применяем ";
          }
          else if (act.TypeString == "clk") {
            s += "Клик. ";
          }
          s += act.Text +"\t";
          xx += act.Text + "\t";


          //АУДИО
          s += act.getSFXname() + "\t";
          xx += act.getSFXnameXX() + "\t";

          //СВОДКА
          s += "\t";
          xx += "\t";

          //ЛОКАЦИЯ
          if (!act.ownerBlock.FullName.StartsWith("rm_") && !act.ownerBlock.FullName.StartsWith("inv_")) {
            s += act.ownerBlock.OwnerBlock.FullName + " >> ";
            xx += act.ownerBlock.OwnerBlock.FullName + " >> ";
          }
          s += act.ownerBlock.FullName + "\t";
          xx += act.ownerBlock.FullName + "\t";

          //КОМЕНТ
          string coment = "активирует: ";

          List<Action> ActSets;
          if(scheme.ActSet.TryGetValue(act,out ActSets)) {
            //Debag(act.ProjObjName);
            string uses = "{ применения: ";
            string gets = "{ подборы: ";
            string clicks = "{ клики: ";
            string mmgs = "{ миниигры: ";
            string dlgs = "{ диалоги: ";

            bool uses_finded = false;
            bool gets_finded = false;
            bool clicks_finded = false;
            bool mmgs_finded = false;
            bool dlgs_finded = false;

            for (int j=0; j< ActSets.Count; j++) {

              if (ActSets[j].TypeString=="use") {
                uses_finded = true;
                uses += "[ " + ActSets[j].Text.Trim() + " ]; ";
              }

              if (ActSets[j].TypeString == "get") {
                gets_finded = true;
                gets += "[ " + ActSets[j].Text.Trim() + " ]; ";
              }

              if (ActSets[j].TypeString == "clk" || ActSets[j].TypeString == "dlg" || ActSets[j].TypeString == "win") {
                if (ActSets[j].TypeString == "win") {
                  mmgs_finded = true;
                  mmgs += "[ " + ActSets[j].Text.Trim() + " >> " + ActSets[j].ObjName + " ]; ";
                }
                else if (ActSets[j].TypeString == "dlg") {
                  dlgs_finded = true;
                  dlgs += "[ " + ActSets[j].Text.Trim() + " >> " + ActSets[j].ObjName + " ]; ";
                }
                else {
                  clicks_finded = true;
                  clicks += "[ " + ActSets[j].Text.Trim() + " ]; ";
                }
              }

            }
            uses += " } ;";
            gets += " } ;";
            mmgs += " } ;";
            dlgs += " } ;";
            clicks += " } ;";

            if (uses_finded)
              coment += uses;
            if (gets_finded)
              coment += gets;
            if (clicks_finded)
              coment += clicks;
            if (mmgs_finded)
              coment += mmgs;
            if (dlgs_finded)
              coment += dlgs;
          }

          if (scheme.SimilarActSet.TryGetValue(act, out ActSets)) {
            //Debag(act.ProjObjName);
            string request = "{ зависит от: ";
            bool request_finded = false;
            for (int j = 0; j < ActSets.Count; j++) {
              request_finded = true;
              request+= "[ " + ActSets[j].PrgName + "]; ";
            }
            request += " }; ";

            if (request_finded) {
              //coment = request + coment;
            }
          }

          List<Block> ActBlocksToActivate;
          if (scheme.ActBlocksToActivate.TryGetValue(act, out ActBlocksToActivate)) {
            bool finded = false;
            string gates = "{ переходы: ";
            for (int j = 0; j < ActBlocksToActivate.Count; j++) {
              //if (ActBlocksToActivate[j] == null)
              //    continue;
              finded = true;
              gates += "[ " + ActBlocksToActivate[j].FullName + " >> " + ActBlocksToActivate[j].Propertie("header").Trim() + " ]; ";
            }
            gates += " }; ";
            if (finded)
              coment += gates;
          }

          //if (coment != "активирует: ")
          //    s += coment;

          //if (xx.StartsWith("XX"))
          //    Debag(xx);
          if(act.ownerBlock.TypeString=="rm" && act.ownerBlock.Propertie("text").IndexOf("[OLD]") == -1
              && !blockEnv.TryGetValue(act.ownerBlock,out env)) {
            env = "aud_" + act.ownerBlock.ObjName + "_env";
            blockEnv[act.ownerBlock] = env;
            string env_string = "ENV " + act.ownerBlock.FullName+"\t";
            env_string += env + "\t";
            Debag(env_string);
          }
          else if (act.ownerBlock.OwnerBlock!=null && act.ownerBlock.OwnerBlock.TypeString == "rm"
                   && act.ownerBlock.OwnerBlock.Propertie("text").IndexOf("[OLD]") == -1
                   && !blockEnv.TryGetValue(act.ownerBlock.OwnerBlock, out env)) {
            env = "aud_" + act.ownerBlock.OwnerBlock.ObjName + "_env";
            blockEnv[act.ownerBlock.OwnerBlock] = env;
            string env_string = "ENV " + act.ownerBlock.OwnerBlock.FullName + "\t";
            env_string += env + "\t";
            Debag(env_string);
          }
          {

          }

          Debag(s);
          if(addXX && !string.IsNullOrEmpty(xx)) {
            Debag(xx);
          }
        }
      }
    }

    void schemeShowNewLocations(Scheme scheme) {
      Debag("New Locations", Color.Green);
      List<Block> blocks = scheme.Blocks;

      int checksCount = 0;


      for (int i = 0; i < blocks.Count; i++) {
        checksCount++;
        ProgresBarSet(checksCount, blocks.Count, "Выписываю новые локации в схеме");

        Block b = blocks[i];
        if (GetControl(b.TypeString + "_" + b.ObjName) != null)
          continue;
        if (b.TypeString == "vid")// || b.TypeString == "dlg")
          continue;
        if (b.TypeString == "dlg")// || b.TypeString == "dlg")
          continue;
        //глава
        string s = scheme.Level_str;
        s += "\t";
        //тип
        s += b.TypeString;
        s += "\t";
        //имя
        s += b.ObjName;
        s += "\t";
        //ТЭГ
        if (b.TypeString == "rm") {
          s += b.ObjName;
        }
        else {
          try {
            s += b.OwnerBlock.ObjName;
          }
          catch {
            if (b.Type < 4) {
              Debag(b.TypeString + "_" + b.ObjName + " не имеет родителя ", System.Drawing.Color.Red);
              s += "ALLERT!!!";
            }
            else {
              s += "deploy";
            }
          }
        }
        s += "\t";
        //комната назад
        if (b.TypeString == "rm" & b.OwnerBlock != null) {
          s += b.OwnerBlock.ObjName;
        }
        s += "\t";
        //список звязанных комнат
        int added = 0;
        for (int c = 0; c < b.ChildBlocks.Count; c++) {
          if (b.ChildBlocks[c].TypeString == "rm") {
            if (added > 0) s += ",";
            s += b.ChildBlocks[c].ObjName;
            added++;
          }
        }
        if (new Regex("[а-яА-Я ]").IsMatch(s))
          Debag(s, Color.Red);
        else
          Debag(s);

        MyObjClass moc;
        //if (b.TypeString == "rm")
        //{
        moc = GetObj("zz_" + b.ObjName);
        if (moc != null)
          Debag("!!!\tЧастичное совпадение имени c " + moc.GetName(), Color.Red);
        moc = GetObj("mg_" + b.ObjName);
        if (moc != null)
          Debag("!!!\tЧастичное совпадение имени c " + moc.GetName(), Color.Red);
        moc = GetObj("ho_" + b.ObjName);
        if (moc != null)
          Debag("!!!\tЧастичное совпадение имени c " + moc.GetName(), Color.Red);
        moc = GetObj("rm_" + b.ObjName);
        if (moc != null)
          Debag("!!!\tЧастичное совпадение имени c " + moc.GetName(), Color.Red);
        //}
      }
      Debag("-------------", Color.Green);

      ProgresBarSet(0);

    }
    void schemeShowNewPRG(Scheme scheme) {
      Debag("New Progress", Color.Green);
      int checksCount = 0;
      List<Action> actions = scheme.Actions;
      for (int a = 0; a < actions.Count; a++) {
        checksCount++;
        ProgresBarSet(checksCount, actions.Count, "Выписываю новый прогресс в схеме");

        Action act = actions[a];
        //List<MyObjClass> muses = GetObj(new Regex("gfx_([a-z]+)_" + act.ObjName + "_([a-z]+)_zone"));
        //List<MyObjClass> museso = GetObj(new Regex("gfx_([a-z]+)_" + act.ObjName + "_zone"));
        //List<MyObjClass> mgets = GetObj(new Regex("spr_([a-z]+)_" + act.ObjName + "[\\d]"));

        List<MyObjClass> muses = GetObj(new Regex("gfx_([a-z]+)_" + act.ObjName + "_([a-z]+)_zone"));
        List<MyObjClass> museso = GetObj(new Regex("gfx_([a-z]+)_" + act.ObjName + "_zone"));
        List<MyObjClass> mgets = GetObj(new Regex("spr_([a-z]+)_" + act.ObjName + "[\\d]"));
        for(int mgetsi=0; mgetsi< mgets.Count; mgetsi++) {

        }

        //if (act.ObjName == "dlg" || act.ObjName == "clk")
        //    continue;
        //if (act.ObjName == "dlg")
        //    continue;
        string s = scheme.Level_str;
        //level
        s += "\t";
        //тип
        if (act.ownerBlock.TypeString == "ho")
          s += "win";
        else
          s += act.TypeString;
        s += "\t";

        //имя
        if (act.TypeString == "dlg") {
          if (act.ownerBlock.TypeString == "rm")
            s += act.ownerBlock.ObjName + "_";
          else
            s += act.ownerBlock.OwnerBlock.ObjName + "_";
        }
        //if (act.TypeString == "dlg")
        //    s += act.ownerBlock.ObjName + "_";
        s += act.ObjName;

        int loaded_get_num = 0;
        if (scheme.isLevelBuilded)
          loaded_get_num = 1;
        int mgnum = 0;
        //Debag("\t" + act.ObjName + "\t" + mgets.Count + "\t" + loaded_get_num);
        if (mgets.Count > loaded_get_num) {
          act.IsMulGetProj = true;
        }
        if (act.TypeString == "get" & (act.IsMultiGetLev() | mgets.Count > loaded_get_num)) {
          string nm = act.Propertie("text");

          //Debag(nm, Color.Purple);
          for (int i = nm.Length - 1; i >= 0; i--) {
            if (char.IsDigit(nm[i])) {
              if (nm[i - 1] == '/' && char.IsDigit(nm[i - 2])) {
                s += nm[i - 2].ToString();
                mgnum = Convert.ToInt32(nm[i - 2].ToString());
              }
              else {
                s += nm[i].ToString();
                mgnum = Convert.ToInt32(nm[i].ToString());
              }
              //Debag("\t\t\t" + mgnum, Color.Red);
              break;
            }
          }
          if (mgnum == 0) {
            Debag("нет номера для мульти гета\t" + act.ObjName + "\t" + act.ownerBlock.ObjName, Color.Red);
            act.MulGetNumProj = mgnum;

          }
          else {
            act.MulGetNumProj = mgnum;
            //Debag(mgnum.ToString());
          }
        }

        int loaded_use_num = 0;
        if (scheme.isLevelBuilded)
          loaded_use_num = 1;

        //if (act.TypeString == "use" && (act.IsMultiUseLev() || muses.Count > loaded_use_num || museso.Count > loaded_use_num))
        if (muses.Count + museso.Count > loaded_use_num) {
          act.IsMulUseProj = true;
        }
        if (act.TypeString == "use" & (act.IsMultiUseLev() | (muses.Count + museso.Count > loaded_use_num))) {
          //Debag(act.ObjName + "  MUL_USE");
          //act.MulUseNameProj = act.ownerBlock.ObjName;
          List<Action> acts = act.ownerBlock.Actions;
          int mac = 0;
          for (int aa = 0; aa < acts.Count; aa++) {
            if (acts[aa].ObjName == act.ObjName) {
              mac++;
              //Debag("!!!111\t\t\t" + act.ObjName + "\t" + acts[aa].ObjName + "\t" + mac, Color.SandyBrown);
              //act.MulUseNameProj += mac.ToString();
            }
          }
          if (mac > 0) {
            int macs = 0;
            act.IsMulUseProj = true;
            for (int aa = 0; aa < acts.Count; aa++) {
              if (acts[aa].ObjName == act.ObjName && acts[aa].ownerBlock == act.ownerBlock) {
                macs++;
                //Debag("!!!SET!!!\t\t\t" + act.ObjName + "\t" + acts[aa].ObjName + "\t" + act.ownerBlock.ObjName + mac+"\t" + mac, Color.SandyBrown);
                acts[aa].MulUseNameProj = acts[aa].ownerBlock.ObjName;
                if (mac > 1)
                  acts[aa].MulUseNameProj += macs;

              }
            }
          }
          else {
            act.MulUseNameProj = act.ownerBlock.ObjName;
          }
          s += "_" + act.MulUseNameProj;
        }
        string prgname = s.Substring(s.LastIndexOf("\t") + 1);
        //Debag(prgname);

        int prgid = FindId(progress_names, "\"" + act.PrgName + "\"");
        if (prgid > -1) {
          Debag("повторное имя прогресса " + act.PrgName, Color.Red);
          continue;
        }
        s += "\t";
        //тэг комнаты
        if (act.ownerBlock.TypeString == "rm") {
          s += act.ownerBlock.ObjName;
        }
        else if (act.ownerBlock.OwnerBlock == null) {
          //s += "inv";
          s += act.ownerBlock.ObjName;
        }
        else if (act.ownerBlock.TypeString == "dlg") {
          //s += "dlg"
          //Debag("ACTION " + act.PrgName + " in dialog");
          s += act.ownerBlock.OwnerBlock.ObjName;
        }
        else {
          s += act.ownerBlock.OwnerBlock.ObjName;
        }
        s += "\t";
        //имя зз//мг//хо
        if (act.ownerBlock.TypeString != "rm" & act.ownerBlock.OwnerBlock != null & act.ownerBlock.TypeString != "dlg") {
          s += act.ownerBlock.ObjName;
        }
        s += "\t";
        //
        s += "\t";
        //указатель типа комнаты mg,хо
        if (act.ownerBlock.TypeString == "ho" || act.ownerBlock.TypeString == "mg")
          s += act.ownerBlock.TypeString;
        else if (act.ownerBlock.OwnerBlock == null & act.ownerBlock.ID != scheme.StartBlockID)
          s += "inv";
        s += "\t";
        //multi
        if ((act.TypeString == "get" & act.IsMultiGetLev()) || (act.TypeString == "use" & act.IsMultiUseLev())) {
          s += act.ObjName;
          //Debag(act.ObjName + " multi???", Color.Purple);
        }
        else {

          int multicount = 0;
          if (scheme.isLevelBuilded) {
            multicount = 1;
          }

          if (muses.Count > multicount) {
            s += act.ObjName;
            //act.MulUseNameProj = act.ownerBlock.ObjName;
          }
          else if (museso.Count > multicount) {
            s += act.ObjName;
            //act.MulUseNameProj = act.ownerBlock.ObjName;
          }
          else if (mgets.Count > multicount) {
            s += act.ObjName;
            //act.MulGetNumProj = mgnum;
          }
          else if (scheme.IsStartInv(act.ObjName))
            s += "<start_inventory>";
        }

        if (new Regex("[а-яА-Я]").IsMatch(s))
          Debag(s + " >>Русские буквы<<", Color.Red);
        else
          Debag(s);


        string PRG_TYPE;
        string PRG_NAME;
        string PRG_RM;
        string PRG_HOMGZZ;
        string PRG_HOMGINV_TYPE;
        string PRG_MUL;

        s = s.Substring(2);
        PRG_TYPE = s.Substring(0, s.IndexOf("\t"));
        s = s.Substring(s.IndexOf("\t") + 1);

        PRG_NAME = s.Substring(0, s.IndexOf("\t"));
        s = s.Substring(s.IndexOf("\t") + 1);

        PRG_RM = s.Substring(0, s.IndexOf("\t"));
        s = s.Substring(s.IndexOf("\t") + 1);

        PRG_HOMGZZ = s.Substring(0, s.IndexOf("\t"));
        s = s.Substring(s.IndexOf("\t") + 2);

        PRG_HOMGINV_TYPE = s.Substring(0, s.IndexOf("\t"));
        s = s.Substring(s.IndexOf("\t") + 1);

        PRG_MUL = s;

        //Debag("*" + PRG_TYPE + "*" + PRG_NAME + "*" + PRG_RM + "*" + PRG_HOMGZZ + "*" + PRG_HOMGINV_TYPE + "*" + PRG_MUL + "*");

        //MyControl mc = GetControl("rm_" + PRG_RM);
        //if(mc==null)
        //    PrgCreation(


        //Debag(muses.Count + " " + museso.Count + " " + mgets.Count);
      }
      //Debag("Ordered PRG");
      //for (int a = 0; a < actions.Count; a++)
      //{
      //    Action act = actions[a];
      //    //if (act.TypeString == "dlg")
      //    //    continue;
      //    Debag("  '" + act.PrgName + "',");
      //}
      Debag("-------------", Color.Green);

      ProgresBarSet(0);
    }
    void schemeBuildLevel(Scheme scheme) {
      int checksCount = 0;
      List<Action> ACTIONS = scheme.Actions.OrderBy(act => act.ID).ToList();
      for (int a = 0; a < ACTIONS.Count; a++) {
        checksCount++;
        ProgresBarSet(checksCount, ACTIONS.Count, "Строю действия из схеме");

        Action act = ACTIONS[a];
        Block ob = act.ownerBlock;
        MyControl mc = GetControl(ob.FullName);

        Debag(a + " >>> " + act.ID + " >> " + act.ProjObjName);
        //if (mc == null)
        //{
        //    MyControl mco = GetControl(act.ownerBlock.OwnerBlock.TypeString + "_" + act.ownerBlock.OwnerBlock.ObjName);
        //    if (mco == null)
        //        //MessageBox.Show("ЛАЖА");

        //}
        //MessageBox.Show(a + " " + ob.ObjName + " " + act.PrgName);

        if (ob == null)
          MessageBox.Show("1 ob = null !!! " + act.ObjName);


        List<Block> controls_for_creating = new List<Block>();
        while (mc == null) {
          if (ob.TypeString == "inv") {
            //MessageBox.Show(a + " " + ob.ObjName + " "+act.PrgName);
            mc = GetControl("inv_complex_" + ob.ObjName);
            if (mc == null)
              PrgCreation(null, "complex_" + ob.ObjName, "");
            mc = GetControl("inv_complex_" + ob.ObjName);
            break;
          }

          if (ob.TypeString != "dlg")
            controls_for_creating.Insert(0, ob);


          //MessageBox.Show("1 "+ob.FullName);
          ob = ob.OwnerBlock;


          if (ob == null) {
            MessageBox.Show("у прогресса отсутствует родитель блока !!!\n " +
                            "возможные причины:\n" +
                            "1) отсутствует связь с предидущем часом игры \n" +
                            "2) отсутствует/неправильное английское имя блока" + act.PrgName + "\n" +
                            act.ownerBlock.FullName);
          }

          //MessageBox.Show("2 " + ob.FullName);
          mc = GetControl(ob.FullName);
          //MessageBox.Show("3 " + mc.GetName());
        }
        for (int i = 0; i < controls_for_creating.Count; i++) {
          //MessageBox.Show("4 " + i + " " + controls_for_creating[i] +" "+ mc.GetName());
          string dop = "";
          if (controls_for_creating[i].TypeString == "ho") {
            //dop = "inv_"+controls_for_creating[i].Actions[0].ObjName;
            //MessageBox.Show(dop + " for " + controls_for_creating[i].FullName);
            continue;
          }

          PrgCreation(mc, controls_for_creating[i].FullName, dop);
          mc = GetControl(controls_for_creating[i].FullName);
        }

        string complex = "";
        for (int i = 0; i < scheme.Blocks.Count; i++) {
          if (scheme.Blocks[i].TypeString == "inv" && scheme.Blocks[i].ObjName == act.ObjName)
            complex = "COMPLEX";
        }

        if (act.PrgName.StartsWith("get_") && (act.IsMulGetProj || act.IsMultiGetLev())) {
          if (act.ownerBlock.TypeString == "ho") {
            MessageBox.Show(act.ownerBlock.ObjName +
                            " ХО Содержит нестандартный МУЛЬТИ гет - нужно будет проверить process и подборы этого предмета \n"
                            + act.PrgName + "\n"+ mc.GetName());
            Debag(act.ownerBlock.ObjName +
                  " ХО Содержит нестандартный МУЛЬТИ гет - нужно будет проверить process и подборы этого предмета \n"
                  + act.PrgName + "\n" + mc.GetName() + "\n" + "mul" + complex);
            //PrgCreation(mc, "inv_" + act.ObjName, act.ownerBlock.FullName, "mul" + complex);
            //PrgCreation(mc, act.PrgName, "mul" + complex);+
            string inv = "inv_" + act.PrgName.Substring(4);
            //MessageBox.Show("HO INV >> " + inv);
            Debag("HO INV >> " + inv);

            PrgCreation(mc, inv + "MUL" + complex, act.ownerBlock.FullName);
          }
          else {
            PrgCreation(mc, act.PrgName, "mul" + complex);
          }
        }
        else {
          if (act.ownerBlock.TypeString == "ho") {

            //PrgCreation(mc, "inv_" + act.ObjName, act.ownerBlock.FullName + complex);

            PrgCreation(mc, "inv_" + act.ObjName, act.ownerBlock.FullName + complex);
          }
          else {
            if (act.PrgName.StartsWith("dlg") && mc.getNamePrefix() != "rm") {
              //Debag("DLG!!!   " + act.PrgName);
              PrgCreation(mc.GetOwnerControl(), act.PrgName, "" + complex);
            }
            else
              PrgCreation(mc, act.PrgName, "" + complex);
          }
        }

      }
      ProgresBarSet(0);

      checksCount = 0;
      for (int i = 0; i < scheme.Blocks.Count; i++) {

        checksCount++;
        ProgresBarSet(checksCount, scheme.Blocks.Count, "Строю локации из схеме");

        Block b = scheme.Blocks[i];
        //Debag(b.FullName);
        if (b.FullName.StartsWith("mg_") && GetControl(b.FullName) == null) {
          //Debag(b.OwnerBlock.FullName + "\t" + b.FullName);
          PrgCreation(GetControl(b.OwnerBlock.FullName), b.FullName, "");
        }
        if (b.FullName.StartsWith("ho_") && GetControl(b.FullName) == null) {
          //Debag(b.OwnerBlock.FullName + "\t" + b.FullName);
          PrgCreation(GetControl(b.OwnerBlock.FullName), b.FullName, "inv_" + b.Actions[0].ObjName);
        }

        if (b.TypeString != "inv" && b.TypeString != "dlg" && b.TypeString != "vid" && GetControl(b.FullName) == null) {
          MessageBox.Show("Не создан контрол для " + b.FullName);
        }
      }


      //Debag("NotEditorProject>>");
      //Debag(_notEditorProject.GetProjectString());
      //Debag("<<NotEditorProject");
      ProgresBarSet(0);

    }
    void schemeBuildLogic(Scheme scheme) {
      for (int a = 0; a < scheme.Actions.Count; a++) {
        Action act = scheme.Actions[a];
        string[] rus = { "А", "В", "С" };
        string[] eng = { "A", "B", "C" };
        for (int i = 0; i < rus.Count(); i++) {
          act.IDlocal = act.IDlocal.Replace(rus[i], eng[i]);
        }
      }

      //List<Action> ActIf = new List<Action>();
      Dictionary<Action, List<Action>> SimilarActSet = new Dictionary<Action, List<Action>>();
      Dictionary<Action, List<Action>> ActSet = new Dictionary<Action, List<Action>>();
      int checksCount = 0;
      for (int b = 0; b < scheme.Blocks.Count; b++) {
        checksCount++;
        ProgresBarSet(checksCount, scheme.Blocks.Count, "Строю логику локаций из схемы");

        Block block = scheme.Blocks[b];
        //Debag(block.TypeString + "_" + block.ObjName);
        for (int a = 0; a < block.Actions.Count; a++) {
          Action act = block.Actions[a];

          //Debag("\t" + act.TypeString + "_" + act.ObjName);
          //подвергающиеся зависимости
          if (act.TypeString == "get" || act.TypeString == "use" || act.TypeString == "clk" || act.TypeString == "dlg"
              || act.TypeString == "win") {
            string sobj = "";

            if (act.TypeString == "get") {
              //if(block.TypeString=="dlg")
              //    sobj += "spr_" + block.OwnerBlock.ObjName + "_";
              //else
              sobj += "spr_" + block.ObjName + "_";
            }
            else if (act.TypeString == "use")
              sobj += "gfx_" + block.ObjName + "_";
            else if (act.TypeString == "clk")
              sobj += "gfx_" + block.ObjName + "_clk_";
            else if (act.TypeString == "dlg") {
              if (block.TypeString == "rm")
                sobj += "gfx_" + block.ObjName + "_dlg_" + block.ObjName + "_";
              else
                sobj += "gfx_" + block.OwnerBlock.ObjName + "_dlg_" + block.OwnerBlock.ObjName + "_";
              //Debag("DLG!!!   " + sobj);
              //MessageBox.Show("DLG!!!   " + sobj + act.ObjName);
            }
            else if (act.TypeString == "win")
              sobj += "gfx_" + block.ObjName + "_win_";


            sobj += act.ObjName;

            if (act.TypeString == "get") {

              if (act.IsMulGetProj | act.IsMultiGetLev() | act.MulGetNumProj > 0) {
                sobj += act.MulGetNumProj;
                //Debag("\t\t\t\tmul_get_" + act.ObjName+"\t"+act.MulGetNumProj, Color.Green);
              }
            }
            if (act.TypeString == "use") {
              if (act.IsMulUseProj) {
                //sobj += "_" + act.ownerBlock.ObjName;
                sobj += "_" + act.MulUseNameProj;
                //Debag("mul_use_" + act.ObjName+"\t"+act.MulUseNameProj, Color.Green);

              }

            }

            if (act.TypeString == "use")
              sobj += "_zone";
            else if (act.TypeString == "clk")
              sobj += "_zone";
            else if (act.TypeString == "dlg")
              sobj += "_zone";
            else if (act.TypeString == "win")
              sobj += "_zone";

            //зона
            //Debag(sobj + "\t" + act.IDlocal);

            if (act.IDlocal == "!" || act.IDlocal == "") {
              //Debag("\t default",Color.Gray);
            }

            //влияющие на зависимости
            if (act.TypeString == "use" || act.TypeString == "clk" || act.TypeString == "dlg" || act.TypeString == "win") {

              //ActIf.Add(act);
              ActSet.Add(act, new List<Action>());
              SimilarActSet.Add(act, new List<Action>());

              List<Action> UseActs = new List<Action>();
              List<string> UseObjSets = new List<string>();

              //if (act.IDlocal.Length > 1)
              //{
              //    //OBJSET
              //    Debag("\t" + sobj + "\tvisible = 0;\tinput = 0;", Color.RoyalBlue);

              //    //for (int i = 0; i < block.Actions.Count; i++)
              //    //{
              //    //    Action aact = block.Actions[i];

              //    //    if (aact.ID != act.ID && aact.TypeString == "use")
              //    //    {
              //    //        if (act.IDlocal[1] == aact.IDlocal[0])
              //    //        {
              //    //            //нашли искомый юс
              //    //            UseActs.Add(aact);
              //    //            UseObjSets.Add(sobj);
              //    //        }
              //    //    }
              //    //}

              //}

              for (int i = 0; i < block.Actions.Count; i++) {
                Action aact = block.Actions[i];

                if (aact.ID != act.ID && (aact.TypeString == "use" || aact.TypeString == "clk" || aact.TypeString == "dlg"
                                          || aact.TypeString == "win")) {
                  //однозначимые юсы
                  if (aact.IDlocal[0] == act.IDlocal[0]) {
                    //Debag(aact.ProjObjName, Color.Red);
                    SimilarActSet[act].Add(aact);
                  }
                  if ((aact.IDlocal.Length > 1) && ((act.IDlocal[0] == aact.IDlocal[1]) || (aact.IDlocal.Length > 2
                                                    && act.IDlocal[0] == aact.IDlocal[2]))) {
                    //нашли искомый юс
                    //Debag(aact.ProjObjName, Color.Green);
                    ActSet[act].Add(aact);
                  }
                }
                if (aact.ID != act.ID && aact.TypeString == "get" && aact.IDlocal.Length > 0) {
                  if ((act.IDlocal[0] == aact.IDlocal[0]) || (aact.IDlocal.Length > 1 && act.IDlocal[0] == aact.IDlocal[1])) {
                    //нашли искомый get
                    //Debag(aact.ProjObjName, Color.Blue);
                    ActSet[act].Add(aact);
                  }
                }
              }


            }
          }
        }
      }
      ProgresBarSet(0);
      checksCount = 0;
      foreach (var kvp in ActSet) {
        checksCount++;
        ProgresBarSet(checksCount, ActSet.Count,
                      "выставляю дефолтные значения объектов из схемы");

        Debag(kvp.Key.PrgName + "\t\t" + kvp.Key.Propertie("text") + "\t\t" + kvp.Key.ownerBlock.ObjName + "\t\t" +
              kvp.Key.ownerBlock.Propertie("header"));
        string str = "";
        string tab = "  ";
        string check = "";
        if (SimilarActSet[kvp.Key].Count > 0) {
          //str += tab + "ld.CheckRequirements( {\"";
          check = "  if ld.CheckRequirements( {\"" + kvp.Key.PrgName + "\"";
          for (int i = 0; i < SimilarActSet[kvp.Key].Count; i++) {
            check += ",\"" + SimilarActSet[kvp.Key][i].PrgName + "\"";
          }
          check += "} ) then\n";
          str += check;
          //Debag("\t check \t " + check, Color.Orange);
        }

        //<GATES>
        tab = "  ";
        string text = kvp.Key.ownerBlock.Propertie("text");
        List<string> dopActs = new List<string>();
        int ff = text.IndexOf("[");
        while (ff > -1) {
          text = text.Substring(ff + 1);
          //Debag(text, Color.DarkGoldenrod);
          string dop = text.Substring(0, text.IndexOf("]"));
          if (dop != "OLD" && dop.IndexOf("-GET-")==-1) {
            dopActs.Add(dop);
            //Debag("\t" + text.Substring(0, text.IndexOf("]")), Color.DarkGoldenrod);
          }

          ff = text.IndexOf("[");
        }
        for (int i = 0; i < dopActs.Count; i++) {
          try {
            if (dopActs[i].Length < 3)
              continue;

            string idLocal = dopActs[i].Substring(0, 1);
            string rmOpen = dopActs[i].Substring(2);
            if (scheme.Level_str.Length > 1)
              rmOpen += scheme.Level_str;
            //Debag("\t\t" + idLocal+" "+rmOpen, Color.DarkGoldenrod);



            //MessageBox.Show(rmOpen);
            string gate = "";
            if (kvp.Key.ownerBlock.TypeString == "rm")
              gate = "_" + kvp.Key.ownerBlock.ObjName + "_";
            else
              gate = "_" + kvp.Key.ownerBlock.OwnerBlock.ObjName + "_";
            //Debag("\t\t\t" + gate, Color.DarkGoldenrod);

            gate = "g" + rmOpen.Substring(0, 2) + gate;
            //Debag("\t\t\t" + gate, Color.DarkGoldenrod); ;
            gate += rmOpen.Substring(3);
            //Debag("\t\t\t" + gate, Color.DarkGoldenrod);

            if (kvp.Key.IDlocal.Length > 0 && kvp.Key.IDlocal.Substring(0, 1) == idLocal) {
              MyObjClass GATE = GetObj(gate);
              if (GATE == null) {
                MessageBox.Show("Не найде гейт " + gate + "\nпробуем создать");
                List<string> grm_forward = LoadXML("res\\mg\\gmg_forward.xml");
                MyControl rm = GetControl(kvp.Key.ownerBlock.OwnerBlock.FullName);
                xmlReplace(grm_forward, "##rmowner##", rm.getNamePost());
                xmlReplace(grm_forward, "##rm##", kvp.Key.ownerBlock.ObjName);
                //MessageBox.Show(rm.GetName());
                GATE = rm.GetOwnerObj().ObjsLoader(grm_forward, 0);

              }
              //else
              //{
              //Debag("DISABLE GATE " + gate, Color.DarkGoldenrod);
              GATE.SetPropertie("input", "0");
              GATE.SetPropertie("visible", "0");
              GATE.SetPropertie("active", "0");
              str += tab + "ObjSet( \"" + gate + "\", { visible = 1, input = 1, active = 1 } )\n";
              //}
            }
          }
          catch {
            MessageBox.Show("Исключение для\n" + dopActs[i] + "\n" + kvp.Key.ProjObjName + "\n" +
                            kvp.Key.ownerBlock.Propertie("text"));
          }
        }
        //</GATES>



        for (int i = 0; i < kvp.Value.Count; i++) {
          //этим объектам установить изначально visible = 0; input = 0
          MyObjClass obj = GetObj(kvp.Value[i].ProjObjName);
          if (obj == null) {
            //Debag("не найден объект " + kvp.Value[i].ProjObjName + "\t" + kvp.Value[i].ObjName, Color.Red);
            //Debag("\t" + kvp.Value[i].ProjObjName + " visible, input = 0", Color.DarkGreen);

          }
          else {
            obj.SetPropertie("visible", "0");
            obj.SetPropertie("input", "0");
            obj.SetPropertie("active", "0");
            // Debag("\t" + obj.GetName() + " visible, input, active = 0", Color.LightGreen);
          }
          //Debag("\t"+kvp.Value[i].ProjObjName + " \t set 0", Color.Purple);
          if (check.Length > 0) {
            tab = "    ";
          }
          str += tab + "ObjSet( \"" + kvp.Value[i].ProjObjName + "\", { visible = 1, input = 1, active = 1 } )";
          if ((kvp.Value.Count > 1 & i < kvp.Value.Count - 1) || check.Length > 0)
            str += "\n";
        }
        tab = "  ";
        if (check.Length > 0) {
          str += tab + "end;";
        }

        if (str.Length > 0) {
          MyObjClass obj = GetObj(kvp.Key.ProjObjName);
          if (obj == null) {
            Debag("не найден объект " + kvp.Key.ProjObjName, Color.Red);
          }
          else {

            MyTrigClass trg = obj.GetModule().GetTrig("");
            if (obj.GetModule().GetMainRoomControl() == null) {
              trg = InvMod.GetTrig("");
            }
            //]]


            List<string> code = trg.GetCode();
            bool func_finded = false;

            int id = FindId(code, "local " + kvp.Key.PrgName + "_logic = function()");
            if (id == -1) {
              //Debag("не найденa функция " + "local " + kvp.Key.PrgName + "_logic = function()", Color.Red);
            }
            else {
              func_finded = true;
              //Debag("local " + kvp.Key.PrgName + "_end = function()", Color.Pink);
              List<string> input = StringToList(str);
              id++;
              int iid = FindId(code, "local " + kvp.Key.PrgName + "_", id);
              for (int j = id; j < iid; j++) {
                for (int z = 0; z < input.Count; z++) {
                  if (code[j].IndexOf(input[z]) > -1) {
                    input.RemoveAt(z);
                    break;
                  }
                }
              }


              trg.AddListToCode(input, id);
              //Debag(str, Color.Orange);

            }
            id = FindId(code, "private." + kvp.Key.PrgName + "_logic = function()");
            if (id == -1) {
              //Debag("не найденa функция " + "local " + kvp.Key.PrgName + "_logic = function()", Color.Red);
            }
            else {
              func_finded = true;
              //Debag("private." + kvp.Key.PrgName + "_end = function()", Color.Pink);
              List<string> input = StringToList(str);
              id++;
              int iid = FindId(code, "local " + kvp.Key.PrgName + "_", id);
              for (int j = id; j < iid; j++) {
                for (int z = 0; z < input.Count; z++) {
                  if (code[j].IndexOf(input[z]) > -1) {
                    input.RemoveAt(z);
                    break;
                  }
                }
              }


              trg.AddListToCode(input, id);
              //Debag(str, Color.Orange);

            }
            if (!func_finded) {
              Debag("не найденa функция " + "local/private " + kvp.Key.PrgName + "_logic = function()", Color.Red);
            }

            //]]

            //string searth = "local " + kvp.key.prgname;
            //if (kvp.key.typestring == "use")
            //{
            //    searth += "_end";
            //}
            //searth += " = function()";
            //int id = findid(trg.getcode(), searth);
            //if (id == -1)
            //{
            //    debag("не найденa функция " + "local " + kvp.key.prgname + "_end = function()", color.red);
            //}
            //else
            //{
            //    string logic = "local " + kvp.key.prgname + " = function()\n";
            //    logic+=

            //}
          }
        }
      }
      ProgresBarSet(0);
    }

    public List<string> StringToList(string str) {
      List<string> lst = new List<string>();
      int id = str.IndexOf("\n");
      while (id > -1) {
        lst.Add(str.Substring(0, id));
        //Debag(str.Substring(0, id));
        str = str.Substring(id + 1);
        id = str.IndexOf("\n");
      }
      if (str.Length > 0)
        lst.Add(str);
      //Debag(str);
      return lst;
    }

    public string ListToString(List<string> l) {
      string s = "";
      for (int i = 0; i < l.Count; i++) {
        s += l[i];
        //Program.form.Debag(s);
        if (i < l.Count - 1)
          s += "\n";
      }
      return s;
    }

    private void buttonCompare_Click(object sender, EventArgs e) {

      OpenFileDialog ofd = new OpenFileDialog();
      ofd.Filter = "strings (*.xml)|*.xml";
      ofd.InitialDirectory = repDir + "exe\\assets";
      ofd.Title = "укажите Strings по умолчанию";
      if (ofd.ShowDialog() != DialogResult.OK)
        return;

      string ce = "";

      string adr = levelStartRoomDir.Substring(0, levelStartRoomDir.IndexOf("\\levels\\")) + "\\";
      //Debag(adr);
      //List<string> strs = LoadXML(adr + "strings"+ce+".xml");
      List<string> strs = LoadXML(ofd.FileName);
      {
        //перекраска старых правок
        StreamWriter sw = new StreamWriter(ofd.FileName);
        for (int i = 0; i < strs.Count; i++) {
          strs[i] = strs[i].Replace("color=\"#007FFF\"", "color=\"#AFFFFF\"");
          sw.WriteLine(strs[i]);
        }
        sw.Close();
        sw.Dispose();
      }

      ofd.InitialDirectory = repDir + "exe\\assets";
      ofd.Title = "укажите отредактированные Strings";
      if (ofd.ShowDialog() != DialogResult.OK)
        return;

      List<string> strs_edited = new List<string>();




      List<Propobj> props = Compare_GetProps(strs);


      List<Propobj> props_edited;

      try {
        strs_edited = LoadXML(ofd.FileName);
      }
      catch {
        MessageBox.Show("не найден файл сравнения " + adr + "strings" + ce + "_edited.xml");
        return;
      }

      props_edited = Compare_GetProps(strs_edited);
      bool diferent = false;
      for (int i = 0; i < props_edited.Count; i++) {
        Propobj norm = Compare_GetPropByID(props_edited[i].Propertie("id"), props);
        if (norm != null) {
          if (norm.Propertie("val") != props_edited[i].Propertie("val")
              && props_edited[i].Propertie("val") != props_edited[i].Propertie("id")) {
            Debag(norm.Propertie("id"), Color.Green);
            Debag("\tnow:", Color.DarkRed);
            Debag("\t\t" + norm.Propertie("val"));
            Debag("\tEdit:: ", Color.DarkGreen);
            Debag("\t\t" + props_edited[i].Propertie("val"));

            int fid = FindId(strs, ">" + norm.Propertie("id") + "</id>");
            //MessageBox.Show(fid + "   "+strs[fid]);
            //MessageBox.Show(norm.Propertie("val") + "\n" + strs[fid + 1]);
            //MessageBox.Show(norm.Propertie("val") + "\n" + props_edited[i].Propertie("val"));

            if(props_edited[i].Propertie("val").Length==0) {
              Debag(
                props_edited[i].Propertie("id") + " >> "
                + props_edited[i].Propertie("val")
                + " >> VALUE IN EDITED STRINGS IS EMPTY!!!", Color.Red);
            }

            if (norm.Propertie("val").Length > 0) {

              Debag("\t\t\tReplacing " + strs[fid + 1]
                    + "\n >> " + norm.Propertie("id") + " >> " + norm.Propertie("val")
                    + "\n >> " + props_edited[i].Propertie("id") + " >> " + props_edited[i].Propertie("val"));



              strs[fid + 1] = strs[fid + 1].Replace(norm.Propertie("val"), props_edited[i].Propertie("val"));
              string clr = strs[fid + 1];
              int txt_start = clr.IndexOf("<text");
              if (txt_start > -1) {
                string change = clr.Substring(txt_start, clr.IndexOf(">") - txt_start + 1);
                string new_str = "<text color=\"#007FFF\">";
                strs[fid + 1] = strs[fid + 1].Replace(change, new_str);
              }
            }
            else {
              Debag(norm.Propertie("id") + " >> VALUE IS EMPTY!!!", Color.Red);
            }
            diferent = true;
          }
          if (norm.Propertie("val") != norm.Propertie("val").Trim()) {
            Debag(norm.Propertie("id") + "\t>>\tнепечатные символы");
          }
        }
        else {
          Debag("В EDITED strings содержится id, отсутствующий в NOW strings " +
                props_edited[i].Propertie("id"), Color.Red);
        }
      }
      for (int i = 0; i < props.Count; i++) {
        bool finded = false;
        for (int j = 0; j < props_edited.Count; j++) {
          finded = props[i].Propertie("id") == props_edited[j].Propertie("id");
          if (finded)
            break;
        }
        if (!finded)
          Debag("В NOW strings содержится id, отсутствующий в EDITED strings " +
                props[i].Propertie("id"), Color.Red);
        string idd = props[i].Propertie("id");
        string vall = props[i].Propertie("val");
        if (vall != null && vall.IndexOf(idd) > -1)
          Debag("В NOW strings ЗАГЛУШКА " + props[i].Propertie("id"), Color.Blue);

      }
      if (diferent) {
        StreamWriter sw = new StreamWriter(adr + "strings" + ce + "_auto.xml");
        for (int i = 0; i < strs.Count; i++) {
          sw.WriteLine(strs[i]);
        }
        sw.Close();
      }
      else {
        Debag("Файлы не отличаются", Color.Green);
      }
    }

    Propobj Compare_GetPropByID(string id, List<Propobj> props) {
      for (int i = 0; i < props.Count; i++) {
        if (props[i].Propertie("id") == id)
          return props[i];
      }
      return null;
    }
    List<Propobj> Compare_GetProps(List<string> __strs_edited) {
      List<string> strs_edited = __strs_edited.ToList();

      List<Propobj> props = new List<Propobj>();
      if (strs_edited[1] == "<strings>") {
        for (int i = 0; i < strs_edited.Count; i++) {
          if (strs_edited[i].IndexOf("<row") > -1) {
            int counter = 1;
            string mark_beg = "<id";
            string mark_end = "</id>";

            if (strs_edited[i + counter].IndexOf(mark_beg) > -1) {


              string s = strs_edited[i + counter].Substring(strs_edited[i + counter].IndexOf(">") + 1);

              while (s.IndexOf(mark_end) == -1) {
                counter++;
                s += "\n" + strs_edited[i + counter];
              }

              s = s.Substring(0, s.IndexOf(mark_end));
              //Debag(s);
              string separator = "##^##";

              string id = s;
              //Debag("id "+id);
              string prop = "<cell id=" + separator + id + separator + " ";


              string val = "";
              counter++;
              mark_beg = "<text";
              mark_end = "</text>";
              if (strs_edited[i + counter].IndexOf(mark_beg) > -1) {
                s = strs_edited[i + counter].Substring(strs_edited[i + counter].IndexOf(">") + 1);

                while (s.IndexOf(mark_end) == -1) {
                  //counter++;
                  s += "\n" + strs_edited[i + counter + 1];
                  strs_edited.RemoveAt(i + counter + 1);
                }
                strs_edited[i + counter] = "      " + mark_beg + ">" + s;
                s = s.Substring(0, s.IndexOf(mark_end));

                val = s;
                if (val.StartsWith(" ")) {
                  Debag("\n\t" + id + "\n\t" + val + "\n\tПробел в НАЧАЛЕ строчки", Color.DarkRed);
                }
                if (val.EndsWith(" ")) {
                  Debag("\n\t" + id + "\n\t" + val + "\n\tПробел в КОНЦЕ строчки", Color.DarkRed);
                }
                //Debag(val);
                prop += "val=" + separator + val + separator + " ";


                //{
                //    prop += "val=" + separator + separator + " ";
                //    Debag("no VAL for " + id, Color.Red);
                //}
              }

              prop += " />";

              props.Add(new Propobj(prop, separator));

              //Debag(">>"+id + "<<\t>>" + val+"<<");
              i += counter;
              //}
            }
          }
        }
      }
      else {
        for (int i = 0; i < strs_edited.Count; i++) {
          if (strs_edited[i].IndexOf("<Row") > -1) {
            if (strs_edited[i + 1].IndexOf("<Cell") > -1) {
              string s = strs_edited[i + 1].Substring(strs_edited[i + 1].IndexOf("<Cell") + 1);

              s = s.Substring(s.IndexOf(">") + 1);
              //Debag(s);
              string separator = "##^##";
              if (s.IndexOf("<Data") > -1) {
                s = s.Substring(s.IndexOf(">") + 1);
                string id = s.Substring(0, s.IndexOf("<"));
                //Debag("id "+id);
                string prop = "<cell id=" + separator + id + separator + " ";


                string val = "";
                if (strs_edited[i + 2].IndexOf("<Cell") > -1) {
                  s = strs_edited[i + 2].Substring(strs_edited[i + 2].IndexOf("<Cell") + 1);

                  s = s.Substring(s.IndexOf(">") + 1);
                  //Debag(s);
                  if (s.IndexOf("<Data") > -1) {
                    s = s.Substring(s.IndexOf(">") + 1);

                    int sser = 3;
                    while (s.IndexOf(">") == -1) {
                      s += " " + strs_edited[i + sser];
                      sser++;
                    }

                    val = s.Substring(0, s.IndexOf("<"));
                    if (val.StartsWith(" ")) {
                      Debag("\n\t" + id + "\n\t" + val + "\n\tПробел в НАЧАЛЕ строчки", Color.DarkRed);
                    }
                    if (val.EndsWith(" ")) {
                      Debag("\n\t" + id + "\n\t" + val + "\n\tПробел в КОНЦЕ строчки", Color.DarkRed);
                    }
                    //Debag(val);
                    prop += "val=" + separator + val + separator + " ";


                  }
                  else {
                    prop += "val=" + separator + separator + " ";
                    Debag("no VAL for " + id, Color.Red);
                  }
                }
                else {
                  prop += "val=" + separator + separator + " ";
                }

                prop += " />";

                props.Add(new Propobj(prop, separator));
              }
            }
          }
        }
      }
      return props;
    }

    private void addReplaceToolStripMenuItem_Click(object sender, EventArgs e) {

    }

    private void button1_Click_1(object sender, EventArgs e) {
      string[] postfix = { "preopen", "open", "preclose", "close" };


      List<MyObjClass> rl = GetRooms();
      for (int i = 0; i < rl.Count; i++) {
        Debag(rl[i].GetName(), Color.Green);
        List<string> trg = rl[i].GetModule().GetTrigCode("trg_" + rl[i].GetModule().GetName().Substring(3) + "_init");
        for (int j = 0; j < trg.Count; j++) {
          string func = "function game." + rl[i].GetName().Substring(3) + ".preclose()";
          if (trg[j].IndexOf(func) > -1) {
            //Debag(trg[j]);
            if (trg[j].IndexOf(" end;") > -1) {
              trg[j] = trg[j].Insert(trg[j].IndexOf(func) + func.Length + 1, "\n  ld.hint.HintFxRmSoftClear(ne_params.sender)\n");
              trg[j] = trg[j].Replace(" end", "end");
            }
            else {
              trg[j] = trg[j] + "\n  ld.hint.HintFxRmSoftClear(ne_params.sender)";
            }
            Debag(trg[j]);
            break;
          }
        }
      }

      List<MyObjClass> gl = GetMgs();
      for (int i = 0; i < gl.Count; i++) {
        Debag(gl[i].GetName(), Color.Green);
        List<string> trg = gl[i].GetModule().GetTrigCode("trg_" + gl[i].GetModule().GetName().Substring(3) + "_init");
        for (int j = 0; j < trg.Count; j++) {
          string func = "function game." + gl[i].GetName().Substring(3) + ".preclose()";
          if (trg[j].IndexOf(func) > -1) {
            if (trg[j].IndexOf(" end;") > -1) {
              trg[j] = trg[j].Insert(trg[j].IndexOf(func) + func.Length + 1, "\n  ld.hint.HintFxRmSoftClear(ne_params.sender)\n");
              trg[j] = trg[j].Replace(" end", "end");
            }
            else {
              trg[j] = trg[j] + "\n  ld.hint.HintFxRmSoftClear(ne_params.sender)";
            }
            Debag(trg[j]);
            break;
          }
        }
      }

      List<MyObjClass> zl = GetZooms();
      for (int i = 0; i < zl.Count; i++) {
        Debag(zl[i].GetName(), Color.Green);
        List<string> trg = zl[i].GetModule().GetTrigCode("trg_" + zl[i].GetModule().GetName().Substring(3) + "_init");
        for (int j = 0; j < trg.Count; j++) {
          string func = "function game." + zl[i].GetModule().GetName().Substring(3) + "." + zl[i].GetName().Substring(
                          3) + "_preopen()";
          if (trg[j].IndexOf(func) > -1) {
            if (trg[j].IndexOf(" end;") > -1) {
              trg[j] = trg[j].Insert(trg[j].IndexOf(func) + func.Length + 1, "\n  ld.hint.HintFxRmSoftClear(room_objname)\n");
              trg[j] = trg[j].Replace(" end", "end");
            }
            else {
              trg[j] = trg[j] + "\n  ld.hint.HintFxRmSoftClear(room_objname)";
            }
            Debag(trg[j]);
            break;
          }
        }

        for (int j = 0; j < trg.Count; j++) {
          string func = "function game." + zl[i].GetModule().GetName().Substring(3) + "." + zl[i].GetName().Substring(
                          3) + "_preclose()";
          if (trg[j].IndexOf(func) > -1) {
            if (trg[j].IndexOf(" end;") > -1) {
              trg[j] = trg[j].Insert(trg[j].IndexOf(func) + func.Length + 1, "\n  ld.hint.HintFxZzSoftClear(ne_params.sender)\n");
              trg[j] = trg[j].Replace(" end", "end");
            }
            else {
              trg[j] = trg[j] + "\n  ld.hint.HintFxZzSoftClear(ne_params.sender)";
            }
            Debag(trg[j]);
            break;
          }
        }
      }

      List<MyObjClass> hl = GetHos();
      for (int i = 0; i < hl.Count; i++) {
        Debag(hl[i].GetName(), Color.Green);
        List<string> trg = hl[i].GetModule().GetTrigCode("trg_" + hl[i].GetModule().GetName().Substring(3) + "_init");
        for (int j = 0; j < trg.Count; j++) {
          string func = "function game." + hl[i].GetName().Substring(3) + ".preclose()";
          if (trg[j].IndexOf(func) > -1) {
            if (trg[j].IndexOf(" end;") > -1) {
              trg[j] = trg[j].Insert(trg[j].IndexOf(func) + func.Length + 1, "\n  ld.hint.HintFxHoSoftClear(ne_params.sender)\n");
              trg[j] = trg[j].Replace(" end", "end");
            }
            else {
              trg[j] = trg[j] + "\n  ld.hint.HintFxHoSoftClear(ne_params.sender)";
            }
            Debag(trg[j]);
            break;
          }
        }
      }

    }

    //проверка наличия в модулях информации объектов находящихся в другом модуле
    private void checkObjWrongLocationToolStripMenuItem_Click(object sender, EventArgs e) {
      for (int m = 0; m < modules.Count; m++) {
        Debag(modules[m].GetName(), Color.DarkBlue);
        //try
        //{
        for (int t = 0; t < modules[m].GetTrigsList().Count; t++) {
          if (modules[m].GetTrigsList()[t].Name.EndsWith("_old"))
            continue;
          List<string> trg = modules[m].GetTrigsList()[t].GetCode();
          Debag(modules[m].GetTrigsList()[t].Name, Color.Green);
          for (int i = 0; i < trg.Count; i++) {
            if (!Regex.IsMatch(trg[i], "\"(gmg|grm|gzz|gho|spr|vid|fx|pfx|gfx|obj|anm)_([a-zA-Z]+)_(\\w+)"))
              continue;
            GroupCollection gc = Regex.Match(trg[i], "\"(gmg|grm|gzz|gho|spr|vid|fx|pfx|gfx|obj|anm)_([a-zA-Z]+)_(\\w+)").Groups;
            if (gc.Count > 0) {
              string own = gc[2].Value;
              bool wrong = true;
              List<MyControl> mcl = modules[m].GetMainRoomControl().GetChilds();
              for (int c = 0; c < mcl.Count; c++) {
                if (mcl[c].GetName().StartsWith("zz_")) {
                  if (own == mcl[c].GetName().Substring(3)) {
                    wrong = false;
                    break;
                  }
                }
              }
              //if (gc[2].Value != modules[m].GetName().Substring(3))
              //{
              //    Debag(trg[i]+"\t\tстрока "+i, Color.Orange);
              //    Debag("\t*" + gc[2].Value + "*", Color.Purple);

              //}
              if (wrong && own == modules[m].GetName().Substring(3)) {
                wrong = false;
              }
              if (wrong) {
                Debag(trg[i] + "\t\tстрока " + i, Color.Orange);
                Debag("\t*" + own + "*", Color.Purple);
              }
            }

            //for (int g = 0; g < gc.Count; g++)
            //{
            //    Debag("\t"+gc[g].Value,Color.Purple);
            //}

            //if (Regex.IsMatch(trg[i], "[a-zA-Z]{2,3}_([a-zA-Z]+)_\\w+"))
            //{

            //}
          }
          //break;
        }
        //break;
        //}
        //catch
        //{
        //    Debag(modules[m].GetName());
        //    Debag("&&&&&&&&&&&&&&&&&&&&&&&&&&");
        //}
      }
    }

    private void addfunclogicToolStripMenuItem_Click(object sender, EventArgs e) {
      //string projectDir;
      //string levelDir;
      //string levelStartRoomDir;
      //string levelStartRoom;
      //Debag(projectDir);
      //Debag(levelDir);
      //Debag(levelStartRoom);
      //Debag(levelStartRoomDir);

      for (int i = 0; i < progress_names.Count; i++) {

        string prg = progress_names[i];
        if (!prg.StartsWith("get_") & !prg.StartsWith("use_"))
          continue;
        Debag(prg);

        if (prg.StartsWith("get_")) {
          for (int m = 0; m < modules.Count; m++) {

            ModuleClass mod = modules[m];
            if (!mod.GetName().StartsWith("ho_")) {
              MyTrigClass trg = mod.GetTrig("");
              //int id = FindId(trg.GetCode(), "local " + prg + " = function()");
              //if (id == -1)
              //{
              //    //Debag("не найден " + "local " + prg + " = function()");
              //}
              //else
              //{
              //    string logic = "local " + prg + "_logic = function()\n\n\n\nend;";
              //    trg.AddListToCode(StringToList(logic), id);
              //    id = FindId(trg.GetCode(), "local " + prg + " = function()") + 2;
              //    logic = "  if cmn.IsEventDone(\"" + prg + "\") then " + prg + "_logic() end;";
              //    trg.AddCode(logic, id);
              //    Debag("\t" + prg);
              //    Debag("\t" + mod.GetName());
              //}

              //cmn.CallEventHandler( "get_bonecup" )
              //int id = FindId(trg.GetCode(), "cmn.CallEventHandler( \"" + prg + "\" )");
              //if (id == -1)
              //{
              //    //Debag("не найден " + "local " + prg + " = function()");
              //}
              //else
              //{

              //    string logic = "  " + prg + "_logic();";
              //    trg.AddCode(logic, id+1);

              //}

              int id = FindId(trg.GetCode(), "cmn.AddSubscriber( \"" + prg + "\", " + prg + "_inv");
              if (id == -1) {
                //Debag("не найден " + "local " + prg + " = function()");
              }
              else {

                string logic = "cmn.AddSubscriber( \"" + prg + "\", " + prg + "_logic";
                //id = FindId(trg.GetCode(), logic);
                if (FindId(trg.GetCode(), logic) == -1) {
                  trg.AddCode(logic + " );", id + 1);
                }
                logic = prg + "_logic();";
                id = FindId(trg.GetCode(), logic);
                if (FindId(trg.GetCode(), logic) > -1) {
                  //trg.AddCode(logic, id + 1);
                  trg.GetCode()[id] = trg.GetCode()[id].Replace(logic, "");
                }
                logic = "if cmn.IsEventDone(\"" + prg + "\") then " + prg + "_logic() end;";
                id = FindId(trg.GetCode(), logic);
                if (FindId(trg.GetCode(), logic) > -1) {
                  //trg.AddCode(logic, id + 1);
                  trg.GetCode()[id] = trg.GetCode()[id].Replace(logic, "");
                }
              }
            }
          }
        }
        if (prg.StartsWith("use_")) {
          for (int m = 0; m < modules.Count; m++) {
            ModuleClass mod = modules[m];
            if (!mod.GetName().StartsWith("ho_")) {
              MyTrigClass trg = mod.GetTrig("trg_" + mod.GetName().Substring(3) + "_init_use");
              //int id = FindId(trg.GetCode(), "local " + prg + "_inv = function()");
              //if (id == -1)
              //{
              //    //Debag("не найден " + "local " + prg + "_inv = function()");
              //}
              //else
              //{
              //    string logic = "local " + prg + "_logic = function()\n\n\n\nend;";
              //    trg.AddListToCode(StringToList(logic), id);
              //    id = FindId(trg.GetCode(), "local " + prg + "_inv = function()") + 2;
              //    logic = "  if cmn.IsEventDone(\"" + prg + "\") then " + prg + "_logic() end;";
              //    trg.AddCode(logic, id);
              //    Debag("\t"+prg);
              //    Debag("\t" + mod.GetName());
              //}

              int id = FindId(trg.GetCode(), "cmn.AddSubscriber( \"" + prg + "\", " + prg + "_inv  );");
              if (id == -1) {
                //Debag("не найден " + "local " + prg + " = function()");
              }
              else {

                string logic = "cmn.AddSubscriber( \"" + prg + "\", " + prg + "_logic";
                //id = FindId(trg.GetCode(), logic);
                if (FindId(trg.GetCode(), logic) == -1) {
                  trg.AddCode(logic + " );", id + 1);
                }
                logic = "cmn.AddSubscriber( \"" + prg + "_end\", " + prg + "_logic, private.room_objname";
                //id = FindId(trg.GetCode(),logic);
                if (FindId(trg.GetCode(), logic) == -1) {
                  trg.AddCode(logic + " );", FindId(trg.GetCode(),
                                                    "cmn.AddSubscriber( \"" + prg + "_end\", " + prg + "_end, private.room_objname") + 1);
                }
                logic = prg + "_logic();";
                id = FindId(trg.GetCode(), logic);
                if (FindId(trg.GetCode(), logic) > -1) {
                  //trg.AddCode(logic, id + 1);
                  trg.GetCode()[id] = trg.GetCode()[id].Replace(logic, "");
                }
                logic = "if cmn.IsEventDone(\"" + prg + "\") then " + prg + "_logic() end;";
                id = FindId(trg.GetCode(), logic);
                if (FindId(trg.GetCode(), logic) > -1) {
                  //trg.AddCode(logic, id + 1);
                  trg.GetCode()[id] = trg.GetCode()[id].Replace(logic, "");
                }
              }
            }
          }
        }
      }
    }

    private void gameHintObjActionsToolStripMenuItem_Click(object sender, EventArgs e) {
      #region загружаем game.hint из всех модулей
      Dictionary<string, Dictionary<string, string>> hint = new Dictionary<string, Dictionary<string, string>>();
      for (int m = 0; m < modules.Count; m++) {
        ModuleClass mod = modules[m];
        //Debag(mod.GetName(), Color.Green);
        for (int t = 0; t < mod.GetTrigsList().Count; t++) {
          MyTrigClass trg = mod.GetTrigsList()[t];
          //Debag("\t"+trg.GetName(), Color.LightGreen);
          List<string> trg_code = trg.GetCode();
          string code = string.Join("\n", trg_code);

          Regex reg = new Regex(
            @"game\.hint\[\s*""(\w*)\""\s*]\s*=\s*{");  //(@"(?:game\.hint\[\s*""(\w*)\""\s*])|(?:\s*(\w*)\s*=\s*""(\w*)"")"); //("(?:game\\.hint\\[\\s*\"(\\w*)\"\\s*])|(?:\\s*(\\w*)\\s*=\\s*\"(\\w*)\")");

          while (reg.IsMatch(code)) {
            string hint_name = reg.Match(code).Groups[1].Value;
            //Debag(hint_name, Color.Purple);
            hint[hint_name] = new Dictionary<string, string>();
            code = code.Substring(code.IndexOf(reg.Match(code).Value));
            string hint_string = code.Substring(0, code.IndexOf("}"));

            Regex reg_pars = new Regex(@"\s*(\w+)\s*=\s*""(\w+)""");

            MatchCollection hsm = reg_pars.Matches(hint_string);
            for (int i = 0; i < hsm.Count; i++) {
              //Debag(i+" *"+hsm[i].Groups[1].Value+"* = *"+hsm[i].Groups[2].Value+"*",Color.OrangeRed);
              hint[hint_name][hsm[i].Groups[1].Value] = hsm[i].Groups[2].Value;
            }

            code = code.Substring(hint_string.Length);
            //MatchCollection matCol = reg.Matches(code);
            //for (int i = 0; i < matCol.Count; i++)
            //{
            //    Debag("\t\t"+matCol[i].Value);
            //}
          }
          //break;
        }
        //break;
      }
      #endregion

      Debag("< не найденые game.hint >");
      for (int i = 0; i < progress_names.Count; i++) {
        Dictionary<string, string> dic;
        if (!hint.TryGetValue(progress_names[i], out dic)) {
          Debag("\t" + progress_names[i], Color.Red);
        }
      }
      Debag("</не найденые game.hint >");

      foreach (var kvp in hint) {
        //foreach (var pars in kvp.Value)
        //{

        //}
        string val;

        //Debag(kvp.Key);
        //выключения use_place
        //Debag("выключения use_place");

        #region выключения use_place
        ///*
        if (kvp.Value.TryGetValue("use_place", out val)) {
          Debag("\t" + kvp.Value["use_place"]);
          Regex reg = new Regex(@"\s*(ObjSet\s*\(\s*""" + kvp.Value["use_place"] + @"""\s*,\s*{\s*[\S\s]*input\s*=)");
          for (int m = 0; m < modules.Count; m++) {
            ModuleClass mod = modules[m];
            //Debag(mod.GetName(), Color.Green);
            for (int t = 0; t < mod.GetTrigsList().Count; t++) {
              MyTrigClass trg = mod.GetTrigsList()[t];
              List<string> trg_code = trg.GetCode();

              for (int i = 0; i < trg_code.Count; i++) {
                if (reg.IsMatch(trg_code[i])) {
                  string str = "";
                  int iback = 1;
                  while (trg_code[i - iback].IndexOf("function") < 0) {
                    iback++;
                  }
                  if (trg_code[i - iback].IndexOf("_logic") > -1) {
                    //Debag("\t\t" + trg_code[i - iback], Color.DarkGray);
                    //Debag("\t\t" + trg_code[i]);


                  }
                  else {
                    Debag("\t\t" + trg_code[i - iback], Color.Blue);
                    Debag("\t\t" + trg_code[i]);

                  }
                }
              }

              string code = string.Join("\n", trg_code);
              MatchCollection mc = reg.Matches(code);

            }
          }

          if (!kvp.Value["use_place"].StartsWith("gfx_")) {
            Debag("*\t" + kvp.Key + "\t" + kvp.Value["use_place"], Color.DarkRed);
          }
        }
        //*/
        #endregion выключения use_place

        //выключения zz_gate
        //Debag("выключения zz_gate");

        #region выключения zz_gate
        //*
        Dictionary<string, string> zz_gates = new Dictionary<string, string>();
        if (kvp.Value.TryGetValue("zz_gate", out val)) {
          string aaa;
          if (zz_gates.TryGetValue(val, out aaa))
            continue;

          zz_gates[val] = val;

          Debag("\t" + kvp.Value["zz_gate"]);
          Regex reg = new Regex(@"\s*(ObjSet\s*\(\s*""" + kvp.Value["zz_gate"] + @"""\s*,\s*{\s*[\S\s]*input\s*=)");
          for (int m = 0; m < modules.Count; m++) {
            ModuleClass mod = modules[m];
            //Debag(mod.GetName(), Color.Green);
            for (int t = 0; t < mod.GetTrigsList().Count; t++) {
              MyTrigClass trg = mod.GetTrigsList()[t];
              List<string> trg_code = trg.GetCode();

              for (int i = 0; i < trg_code.Count; i++) {
                if (reg.IsMatch(trg_code[i])) {
                  string str = "";
                  int iback = 1;
                  while (trg_code[i - iback].IndexOf("function") < 0) {
                    iback++;
                  }
                  if (trg_code[i - iback].IndexOf("_logic") > -1) {
                    //Debag("\t\t" + trg_code[i - iback], Color.DarkGray);
                    //Debag("\t\t" + trg_code[i]);


                  }
                  else {
                    Debag("\t\t" + trg_code[i - iback], Color.Blue);
                    Debag("\t\t" + trg_code[i]);

                  }
                }
              }

              string code = string.Join("\n", trg_code);
              MatchCollection mc = reg.Matches(code);

            }
          }
        }
        //*/
        #endregion выключения zz_gate


      }
    }

    private void checkResByModulesToolStripMenuItem_Click(object sender, EventArgs e) {
      return;
      string dir = @"D:\Work\RD2\exe\";
      string[] modPath = Directory.GetFiles(@"D:\Work\RD2\exe\assets\", "mod_*.xml", SearchOption.AllDirectories);
      for (int i = 0; i < 10; i++) {
        string dirF = modPath[i].Substring(0, modPath[i].LastIndexOf(@"\") + 1);
        string[] filesPath = Directory.EnumerateFiles(dirF, "*.*", SearchOption.AllDirectories).Where(s => s.EndsWith(".png")
                             || s.EndsWith(".jpg") || s.EndsWith(".ogg")).ToArray();
        //Console.WriteLine(dirF);
        //Console.WriteLine(modPath[i]);
        Debag(modPath[i]);
        //try
        //{
        //ModuleClass mod = new ModuleClass(LoadXML( fullfilesPath[i]));

        //CheckProjectResources(mod.GetMainRoomControl());

        //}
        //catch (Exception ex)
        //{
        //    //MessageBox.Show(ex.ToString(), "XML файл поврежден.");
        //}

        List<string> objRes = new List<string>();
        List<string> files = new List<string>();

        for (int j = 0; j < filesPath.Count(); j++) {
          string s = filesPath[j].Replace(dir, "");
          s = s.Substring(0, s.Length - 4);
          //Console.WriteLine("\t\t"+s);
          files.Add(s);
        }


        XmlDocument doc = new XmlDocument();
        doc.Load(modPath[i]);

        foreach (XmlNode nodeOrder in doc) {
          //Console.WriteLine(nodeOrder.Name);
          GetXmlRes(nodeOrder, objRes);
        }

        for (int j = 0; j < objRes.Count; j++) {

          for (int z = 1; z < files.Count; z++) {
            if (objRes[j] == files[z]) {
              files.RemoveAt(z);
              break;
            }
          }

        }

        for (int z = 1; z < files.Count; z++) {
          //Console.WriteLine("!!!\t" + files[z]);
          Debag("\t!!!\t" + files[z], Color.Red);
        }

        //XmlNodeList ord = doc.GetElementsByTagName("res");

        //foreach (XmlNode nod in ord)
        //{
        //    Console.WriteLine(nod.Attributes["res"]);
        //}

        //Console.WriteLine(doc.InnerXml);
      }
    }

    void GetXmlRes(XmlNode nodeOrder, List<string> res) {
      foreach (XmlNode node in nodeOrder) {
        //Console.WriteLine(node.Name);
        if (node.Attributes != null) {
          foreach (XmlAttribute att in node.Attributes) {
            if (att.Name == "res") {
              //Console.WriteLine("\t" + att.Value);
              res.Add(att.Value.Replace("/", "\\"));
            }

          }
        }


        if (node.HasChildNodes) {
          GetXmlRes(node, res);
        }
      }
    }

    private void findFolderToolStripMenuItem_Click(object sender, EventArgs e) {
      LoadConfig();
      string dirbuf = "";
      //string dirTemp = null;
      try {
        dirbuf = LoadXML("config.xml")[0];
        dirbuf = dirbuf.Substring(dirbuf.IndexOf("level_dir=\"") + 11);
        dirbuf = dirbuf.Substring(0, dirbuf.IndexOf("\""));
      }
      catch {
        dirbuf = "";
      }

      FolderBrowserDialog DirDialog = new FolderBrowserDialog();
      //try
      //{
      //    //dirTemp = LoadXML("temp.tmp")[0];
      //    //dirTemp = dirbuf;
      //    //File.Delete("temp.tmp");
      //}
      //catch
      //{
      //FolderBrowserDialog DirDialog = new FolderBrowserDialog();
      DirDialog.Description = "Выберите папку стартовой комнаты уровня";
      //DirDialog.SelectedPath = @"D:\Work\RD2\exe\assets\levels\level";
      DirDialog.SelectedPath = dirbuf;
      //}


      if (DirDialog.ShowDialog() == DialogResult.OK) {
        LoadLevel(DirDialog.SelectedPath);
      }
    }

    private void Form1_PreviewKeyDown(object sender, PreviewKeyDownEventArgs e) {
      if (e.Control && e.KeyCode == Keys.L) {
        if (LevelToolStripMenuItem.DropDownItems.Count > 1) {
          LoadLevel(LevelToolStripMenuItem.DropDownItems[1].Text);
        }
        else {
          findFolderToolStripMenuItem_Click(LevelToolStripMenuItem.DropDownItems[0], e);
        }
      }

      Debag(e.KeyValue.ToString());
    }

    bool sizeChanged = false;
    void sizeMin() {
      if (sizeChanged)
        return;

      List<MyControl> acc = GetCreatedControls();
      for (int c = 0; c < acc.Count; c++) {
        acc[c].sizeMin();
      }
      sizeChanged = true;
    }

    void sizeMax() {
      if (!sizeChanged)
        return;

      List<MyControl> acc = GetCreatedControls();
      for (int c = 0; c < acc.Count; c++) {
        acc[c].sizeMax();
      }
      sizeChanged = false;
    }

    protected override bool ProcessCmdKey(ref Message msg, Keys keyData) {
      switch (keyData) {
        case Keys.L | Keys.Control: {
            if (LevelToolStripMenuItem.DropDownItems.Count > 1) {
              LoadLevel(LevelToolStripMenuItem.DropDownItems[1].Text);
            }
            else {
              findFolderToolStripMenuItem_Click(LevelToolStripMenuItem.DropDownItems[0], new EventArgs());
            }
            return true;
          }
        case Keys.Add | Keys.Control: {
            sizeMax();
            return true;

          }
        case Keys.OemMinus | Keys.Control: {
            sizeMin();
            return true;

          }
      }

      //            else if (e.Control && e.KeyCode == Keys.Add)
      //{
      //    sizeMax();
      //}
      //else if (e.Control && e.KeyCode == Keys.OemMinus)
      //{
      //    sizeMin();
      //}

      return base.ProcessCmdKey(ref msg, keyData);
    }

    [DllImport("User32.dll")]
    static extern short GetKeyState(int nVirtKey);

    private void button1_Click_2(object sender, EventArgs e) {
      List<string> sfx = LoadXML("sfx.txt");
      for (int i = 1; i < sfx.Count; i++) {
        if (sfx[i].Length > 0) {
          string s = sfx[i];
          //Debag(s);
          if (s.IndexOf("_env") == -1) {
            string prg = s;
            if (s.IndexOf("_zone_click") > -1) {
              try {
                prg = prg.Replace("_zone_click", "");
                //prg = prg.Replace("aud_", "",);
                prg = prg.Substring(4);
                //Debag("\t"+prg);
                MyObjClass mo = GetObj(gameHint.Hints[prg].Properties["use_place"]);
                //Debag(mo.GetPropertie("event_mdown"));

                Debag(s);

                mo.SetPropertie("event_mdown", mo.GetPropertie("event_mdown") + "&#x0D;&#x0D;SoundSfx( &quot;" + s + "&quot; )");
                //Debag("\n"+mo.GetPropertie("event_mdown"));
              }
              catch {
                Debag("не удалось подключить звук " + s, Color.Red);
              }
            }
            else {
              //try
              //{
              prg = prg.Substring(4);
              Hint hnt = gameHint.Hints[prg];
              List<string> code = hnt.code;
              if (hnt.functions.Count > 0) {
                List<string> func = hnt.functions[hnt.functions.Count - 1];
                //for (int j = 1; j < hnt.functions.Count; j++)
                //{
                //    Debag("***");
                //    Debag(hnt.functions[j]);
                //}
                int id = FindId(code, func, true) + func.Count - 1;
                //Debag(func);
                //Debag(code);
                Debag(s + "\t" + prg + "\t" + id);
                code.Insert(id, "  SoundSfx( &quot;" + s + "&quot; )");
              }
              else {
                Debag(s.Substring(4) + " не удалось подключить звук, отсутствуют функции  " +
                      s, Color.Red);
              }
              //}
              //catch
              //{
              //    Debag(s.Substring(4)+" не удалось подключить звук " + s, Color.Red);
              //}
            }
          }
        }
      }
      //Hint hnt = gameHint.hi
      //FindId(List<string> l, List<string> find, bool identical)
    }

    private void уровеньlevToolStripMenuItem_Click(object sender, EventArgs e) {
      buttonLevLogicBuild_Click(sender, e);
    }

    private void button1_Click_3(object sender, EventArgs e) {

    }

    int textBox1_KeyUp_pressed = 0;
    private void textBox1_KeyUp(object sender, KeyEventArgs e) {
      TextBox tb = (TextBox)sender;
      string s = tb.Text;

      int dx = 0;
      int dy = 0;

      List<MyControl> FC = new List<MyControl>();
      //if (s.Length > 0)
      //{
      List<MyControl> acc = GetCreatedControls();
      for (int c = 0; c < acc.Count; c++) {
        bool finded = false;
        foreach (KeyValuePair<string, Label> kvp in acc[c].HintLabel) {
          //Debag(kvp.Key + " " + kvp.Key.IndexOf(s));
          if (s.Length > 0 && kvp.Key.IndexOf(s) > -1) {
            //acc[c].lab_MouseEnter(kvp.Value, EventArgs.Empty);
            kvp.Value.BackColor = Color.Black;
            kvp.Value.ForeColor = Color.White;
            //kvp.Value.Font.
            finded = true;
          }
          else {
            kvp.Value.ForeColor = Color.Black;
            acc[c].SetHintColor(kvp.Value, kvp.Value.Name);
          }
        }
        if (finded)
          FC.Add(acc[c]);
        else if (acc[c].GetName().IndexOf(s) > -1)
          FC.Add(acc[c]);

      }
      //}

      if (e.KeyCode == Keys.Enter && textBox1_KeyUp_pressed < (FC.Count - 1))
        textBox1_KeyUp_pressed++;
      else
        textBox1_KeyUp_pressed = 0;

      if (FC.Count > 0 && e.KeyCode == Keys.Enter) {
        dx = this.Width / 2 - FC[textBox1_KeyUp_pressed].Location.X + 0;
        dy = this.Height / 2 - FC[textBox1_KeyUp_pressed].Location.Y + 0;
        //FC[textBox1_KeyUp_pressed].BorderStyle = BorderStyle.Fixed3D;

        for (int c = 0; c < acc.Count; c++) {
          Point loc = acc[c].Location;
          acc[c].Location = new Point(loc.X + dx, loc.Y + dy);


        }

        DrawScreen();
        Graphics g = this.CreateGraphics();
        Pen pen = new Pen(Color.Lime, 12);
        Rectangle rect = new Rectangle(FC[textBox1_KeyUp_pressed].Location.X, FC[textBox1_KeyUp_pressed].Location.Y,
                                       FC[textBox1_KeyUp_pressed].Width, FC[textBox1_KeyUp_pressed].Height);
        //Rectangle rect = new Rectangle(0, 0, FC[textBox1_KeyUp_pressed].Width, FC[textBox1_KeyUp_pressed].Height);
        g.DrawRectangle(pen, rect);
        pen = new Pen(Color.Red, 6);
        g.DrawRectangle(pen, rect);
        g.Dispose();

      }


    }

    private bool isWrongSimbols(string s) {
      Regex reg = new Regex("([а-яА-ЯA-Z]|\\W| )");
      //Debag(reg.Matches(s).Count.ToString());
      return reg.Matches(s).Count > 0;
    }

    private string isRussianSymbols(string s) {
      string answer = "";
      Regex reg = new Regex("([а-яА-Я])");
      MatchCollection mc = reg.Matches(s);
      if (mc.Count>0) {
        for(int i =0; i<mc.Count; i++) {
          answer += i +" >> Index " + mc[i].Index + "; Value " + mc[i].Value + ";";
        }
      }
      return answer;
    }

    private void trigersToolStripMenuItem_Click(object sender, EventArgs e) {

    }

    private void cloneObjFinderToolStripMenuItem_Click(object sender, EventArgs e) {
      Debag("*** cloneObjFinder >>>");
      for (int m = 0; m < modules.Count; m++) {
        ModuleClass mod = modules[m];
        List<MyObjClass> aol = mod.GetAllObjs();
        for (int i = 0; i < aol.Count; i++) {
          MyObjClass searthObj = aol[i];
          for (int j = 0; j < aol.Count; j++) {
            if (i != j) {
              MyObjClass checkObj = aol[j];
              if (searthObj.GetName() == checkObj.GetName()) {
                if (searthObj.GetName().StartsWith("inv")) {
                  if (searthObj.objs.Count > 0 && searthObj.objs[0].GetPropertie("__type") == "text"
                      && searthObj.GetPropertie("res") == checkObj.GetPropertie("res")) {
                    Debag("DEL 1 " + searthObj.GetName() + " -> " + checkObj.GetName());
                    searthObj.Delete();
                  }
                  else {
                    Debag("DEL 2 " + checkObj.GetName() + " -> " + searthObj.GetName());
                    checkObj.Delete();
                  }
                  cloneObjFinderToolStripMenuItem_Click(sender, e);
                  return;
                }
                else {
                  if (searthObj.objs.Count > 0 && searthObj.objs[0].GetPropertie("__type") == "text") {
                    Debag("DEL 3 " + searthObj.GetName() + " -> " + checkObj.GetName());
                    searthObj.Delete();
                  }
                  else {
                    Debag("DEL 4 " + checkObj.GetName() + " -> " + searthObj.GetName());
                    checkObj.Delete();
                  }
                  cloneObjFinderToolStripMenuItem_Click(sender, e);
                  return;
                }
              }
            }
          }
        }
      }
      Debag("<<< cloneObjFinder ***");

    }

    private void bBTcheckToolStripMenuItem_Click(object sender, EventArgs e) {
      bbtCheck();
    }

    private void localFuncCheckToolStripMenuItem_Click(object sender, EventArgs e) {
      localFuncCheck();
    }

    private void noSFXfinderToolStripMenuItem_Click(object sender, EventArgs e) {
      Debag(">>>> noSFXfinder >>>>");

      string[] sfxNeeds = new string[] { "AnimPlayFromStatic(", "AnimPlay(" };
      string noSFXfinder = "";
      int count = 0;
      List<MyObjClass> aol = GetAllObjs();
      for (int a = 0; a < aol.Count; a++) {
        MyObjClass o = aol[a];
        string mdown = o.GetPropertie("event_mdown");
        for (int i = 0; i < sfxNeeds.Length; i++) {
          if (mdown.IndexOf(sfxNeeds[i]) > -1 & mdown.IndexOf("SoundSfx(") < 0) {
            count++;
            noSFXfinder += "\n*** " + count + " ***\n*" + o.GetName() + "*\n" + mdown;
          }
        }
      }
      noSFXfinder = noSFXfinder.Replace("&quot;", "\"").Replace("&apos;", "'");
      Debag(noSFXfinder);
      Debag("<<< noSFXfinder <<<<");

      string s = "";
      for (int m = 9; m < modules.Count; m++) {
        //Debag(modules[m].GetName());

        List<List<string>> funcs = getFunctions(modules[m].GetTrigCode(""));
        s += "\n" + modules[m].GetName();
        for (int f = 0; f < funcs.Count; f++) {
          //Debag("\n>>" + funcs[f][0]);
          //s += "\n >> " + funcs[f][0] + " >> " + funcs[f].Count;
          string func = ListToString(funcs[f]);
          for (int i = 0; i < sfxNeeds.Length; i++) {
            if (func.IndexOf(sfxNeeds[i]) > -1 & func.IndexOf("SoundSfx(") < 0) {
              count++;
              s += "\n***" + count + "***\n" + funcs[f][0] + "\n***\n";
            }
          }
        }
        break;
      }
      Debag(s);
    }

    private void Form1_DragDrop(object sender, DragEventArgs e) {
      if (e.Data.GetDataPresent(DataFormats.FileDrop)) {
        string str;
        string[] files = (string[])e.Data.GetData(DataFormats.FileDrop);
        try {
          LoadLevel(files[0]);

        }
        catch (Exception ex) {
          MessageBox.Show(ex.Message);
          return;
        }
      }
    }

    private void Form1_DragEnter(object sender, DragEventArgs e) {
      if (e.Data.GetDataPresent(DataFormats.FileDrop)) {
        string[] files = (string[])e.Data.GetData(DataFormats.FileDrop);
        try {
          if (files.Length > 1)
            return;
          if (Directory.Exists(files[0]))
            e.Effect = DragDropEffects.Link;

        }
        catch (Exception ex) {
          MessageBox.Show(ex.Message);
          return;
        }
      }
    }

    //public string FindInAllTrigs(Regex reg)
    //{
    //    for (int m = 0; m < modules.Count; m++)
    //    {
    //        ModuleClass mod = modules[m];
    //        Debag(mod.GetName(), Color.Green);
    //        for (int t = 0; t < mod.GetTrigsList().Count; t++)
    //        {
    //            MyTrigClass trg = mod.GetTrigsList()[t];
    //            List<string> trg_code = trg.GetCode();
    //            string code = string.Join("\n", trg_code);
    //            if (reg.IsMatch(code))
    //            {
    //                return reg.;
    //            }
    //        }
    //    }
    //    return "";
    //}

    //static public object GetValByString(this Dictionary<string, object> dict, string str)
    //{
    //    object obj;
    //    if (dict.TryGetValue(str, out obj))
    //        return obj;
    //    else
    //        return obj;
    //}

    //static public bool IsExist(this Dictionary<string, bool> dict, string str)
    //{
    //    bool obj;
    //    return dict.TryGetValue(str, out obj);

    //}

    private void SetControlsFromConfig() {
      List<MyControl> all = GetAllControls();
      for (int i = 0; i < all.Count; i++) {
        try {
          //MessageBox.Show(loadedConfig[all[i].GetOwnerObj().GetName()].Propertie("pos_x"));
          all[i].Location = new Point(Convert.ToInt16(loadedConfig[all[i].GetOwnerObj().GetName()].Propertie("pos_x")),
                                      Convert.ToInt16(loadedConfig[all[i].GetOwnerObj().GetName()].Propertie("pos_y")));
        }
        catch {
          //Debag("!!!" + main_control.GetOwnerObj().GetName());
        }
      }
    }

    private void zZDeployToSprGmToolStripMenuItem_Click(object sender, EventArgs e) {
      //List<MyObjClass> zzs =  GetZooms();
      //for(int i = 0;i<zzs.Count;i++)
      //{
      //    zzs[i].SetPropertie("__type", "spr_gm");
      //}

      List<MyControl> zza = GetAllControls();
      for (int i = 0; i < zza.Count; i++) {
        //if (zza[i].GetOwnerObj().getNamePrefix()=="zz" || zza[i].GetOwnerObj().getNamePrefix()=="inv")
        //    zza[i].GetOwnerObj().SetPropertie("__type", "spr_gm");

        if (zza[i].GetOwnerObj().getNamePrefix() == "zz")
          zza[i].GetOwnerObj().SetPropertie("__type", "spr_gm");

        //if (zza[i].GetOwnerObj().getNamePrefix() == "inv")
        //    zza[i].GetOwnerObj().SetPropertie("__type", "obj");
      }
    }

    private void checkChetnostToolStripMenuItem_Click(object sender, EventArgs e) {
      FolderBrowserDialog dialog = new FolderBrowserDialog();

      if (dialog.ShowDialog() == DialogResult.OK) {
        Debag(">>>> Чекер Чётности");
        string[] files = Directory.GetFiles(dialog.SelectedPath, "*.png", SearchOption.AllDirectories);
        List<string> flsfull = mStrToList(files);
        for (int i = 0; i < flsfull.Count; i++) {
          System.Drawing.Image png = System.Drawing.Image.FromFile(flsfull[i]);
          if (png.Width % 2 > 0 || png.Height % 2 > 0)
            Debag("\t" + flsfull[i]);
        }
        Debag("<<<< Чекер Чётности");
      }
    }

    bool Form1_TextChanged_now = false;
    private void Form1_TextChanged(object sender, EventArgs e) {
      //if (!Form1_TextChanged_now)
      //{
      //    Graphics g = this.CreateGraphics();
      //    Double startingPoint = (this.Width / 2) - (g.MeasureString(this.Text.Trim(), this.Font).Width / 2);
      //    Double widthOfASpace = g.MeasureString(" ", this.Font).Width;
      //    String tmp = " ";
      //    Double tmpWidth = 0;
      //    while ((tmpWidth + widthOfASpace) < startingPoint)
      //    {
      //        tmp += " ";
      //        tmpWidth += widthOfASpace;
      //    }
      //    this.Text = tmp + this.Text.Trim();
      //    Form1_TextChanged_now = true;

      //}
      //else
      //{
      //    Form1_TextChanged_now = false;
      //}
    }

    private void button2_Click(object sender, EventArgs e) {
      //using Microsoft.Win32
      Microsoft.Win32.RegistryKey reg = Microsoft.Win32.Registry.CurrentUser;

      //regClear(Microsoft.Win32.Registry.ClassesRoot);
      //regClear(Microsoft.Win32.Registry.CurrentConfig);
      //regClear(Microsoft.Win32.Registry.CurrentUser);
      //regClear(Microsoft.Win32.Registry.LocalMachine);
      //regClear(Microsoft.Win32.Registry.PerformanceData);
      //regClear(Microsoft.Win32.Registry.Users);



      //reg = reg.OpenSubKey("Software");
      //reg = reg.OpenSubKey("Microsoft");
      //reg = reg.OpenSubKey("Windows");
      //reg = reg.OpenSubKey("CurrentVersion");
      //reg = reg.OpenSubKey("Explorer");
      //reg = reg.OpenSubKey("FileExts");
      //reg = reg.OpenSubKey(".png");
      //Microsoft.Win32.RegistryKey rreg = reg.OpenSubKey("OpenWithList", true);

      //string[] valueNames = rreg.GetValueNames();

      ////for (int i = 0; i < valueNames.Length;i++ )
      ////{

      ////}
      //bool finded = false;
      //    foreach (string s in valueNames)
      //    {
      //        //Debag(s);
      //        //MessageBox.Show(s + "\n" + (string)rreg.GetValue(s));
      //        var val = rreg.GetValue(s);

      //        if (val.GetType() == typeof(string) && ((string)rreg.GetValue(s)).IndexOf("logicCase") >-1)
      //        {
      //            rreg.SetValue(s, "\""+Application.ExecutablePath+"\"");
      //            //rreg.DeleteValue(s);
      //            //string list = (string)reg.GetValue("MRUList");
      //            //rreg.SetValue("MRUList", list.Replace(s, ""));
      //            //MessageBox.Show("установлен новый путь" + Application.ExecutablePath + " для списка [открыть с помощью] для .png");
      //            finded = true;
      //        }
      //    }
      //if(!finded)
      //    //MessageBox.Show("LogicCase.exe в списке открыть с помощью для .png не найден");


      regClearLC(Microsoft.Win32.Registry.ClassesRoot);
      regClearLC(Microsoft.Win32.Registry.CurrentConfig);
      regClearLC(Microsoft.Win32.Registry.CurrentUser);
      regClearLC(Microsoft.Win32.Registry.LocalMachine);
      regClearLC(Microsoft.Win32.Registry.PerformanceData);
      regClearLC(Microsoft.Win32.Registry.Users);
    }

    private void regClearLC(Microsoft.Win32.RegistryKey reg) {
      string name = reg.Name;
      try {
        reg = reg.OpenSubKey("Software");
        reg = reg.OpenSubKey("Classes");
        reg = reg.OpenSubKey("Applications", true);
        string[] ApplicationForClear = {
          "logicCase.exe",
          "AnimationToNEA3.exe",
          "StringEditor.exe",
        };
        for (int i = 0; i < ApplicationForClear.Length; i++) {
          try {
            reg.DeleteSubKeyTree(ApplicationForClear[i]);
            MessageBox.Show("Удалена информация в реестре из ветки \n" + name + "\n для " +
                            ApplicationForClear[i]);
          }
          catch {

          }
        }
      }
      catch {

      }
    }

    private void regClear(Microsoft.Win32.RegistryKey reg, Dictionary<Microsoft.Win32.RegistryKey, string> SubDels = null,
                          Dictionary<Microsoft.Win32.RegistryKey, string> ValDels = null) {
      bool main = false;
      try {
        if (SubDels == null) {
          SubDels = new Dictionary<Microsoft.Win32.RegistryKey, string>();
          main = true;
        }

        foreach (string subRegName in reg.GetSubKeyNames()) {
          this.Text = reg.Name + " >>> " + subRegName;

          if (subRegName.IndexOf("LogicCase") > -1) {
            SubDels[reg] = subRegName;
          }
          else {
            try {
              regClear(reg.OpenSubKey(subRegName, true), SubDels);
            }
            catch {
              try {
                regClear(reg.OpenSubKey(subRegName), SubDels);
              }
              catch {
                Debag("не удалось открыть subRegName >> " + subRegName);
              }
            }
          }
        }
        if (main) {
          foreach (KeyValuePair<Microsoft.Win32.RegistryKey, string> kvp in SubDels) {
            try {
              Debag("удаляем DeleteSubKey >> " + kvp.Value);
              kvp.Key.DeleteSubKey(kvp.Value);
            }
            catch {
              Debag("не удалось удалить DeleteSubKey >> " + kvp.Value);

            }
          }
        }

        //SubDels = null;

        if (ValDels == null)
          ValDels = new Dictionary<Microsoft.Win32.RegistryKey, string>();

        foreach (string subKeyName in reg.GetValueNames()) {
          if (reg.GetValue(subKeyName).GetType().ToString() == "System.String") {
            this.Text = reg.Name + " >>> " + subKeyName;
            string s = (string)reg.GetValue(subKeyName);
            if (s.IndexOf("logicCase") > -1) {
              //reg.DeleteValue(subKeyName);
              ValDels[reg] = subKeyName;
            }
          }
        }

        if (main) {
          foreach (KeyValuePair<Microsoft.Win32.RegistryKey, string> kvp in ValDels) {
            try {
              Debag("удаляем subKeyName >> " + kvp.Value);

              kvp.Key.DeleteValue(kvp.Value);
            }
            catch {
              Debag("не удалось удалить subKeyName >> " + kvp.Value);

            }
          }
        }
      }
      catch {
        if (main)
          Debag("CATCH in MAIN!!!");
        else
          Debag("CATCH!!!");

        if (main) {
          if (SubDels != null)
            foreach (KeyValuePair<Microsoft.Win32.RegistryKey, string> kvp in SubDels) {
              try {
                Debag("удаляем DeleteSubKey >> " + kvp.Value);
                kvp.Key.DeleteSubKey(kvp.Value);
              }
              catch {
                Debag("не удалось удалить DeleteSubKey >> " + kvp.Value);

              }
            }

          if (ValDels != null)
            foreach (KeyValuePair<Microsoft.Win32.RegistryKey, string> kvp in ValDels) {
              try {
                Debag("удаляем subKeyName >> " + kvp.Value);

                kvp.Key.DeleteValue(kvp.Value);
              }
              catch {
                Debag("не удалось удалить subKeyName >> " + kvp.Value);

              }
            }
          else {
            Debag("ValDels not inited", Color.Red);
          }
        }
      }
    }

    private void getUsedFontsToolStripMenuItem_Click(object sender, EventArgs e) {
      Debag(">>>> getUsedFonts >>>>");
      foreach (MyObjClass obj in GetAllObjs()) {
        if (obj.GetPropertie("res").StartsWith(@"assets\fonts") || obj.GetPropertie("res").StartsWith(@"assets/fonts")) {
          Debag("\t" + obj.GetPropertie("res").Substring(obj.GetPropertie("res").LastIndexOfAny(new char[] { '\\', '/' })) + "\t"
                + obj.GetName() + "\t" + (obj.GetOwnerControl() == null ? "NULL" : obj.GetOwnerControl().GetDefResName()));
        }
      }
      Debag("<<<< getUsedFonts <<<<");
    }

    private void iNFOToolStripMenuItem_Click(object sender, EventArgs e) {

      ShowInfoMessage();
    }

    public void ShowInfoMessage() {
      MessageBox.Show("AssemblyVersion >> "
                      + System.Reflection.Assembly.GetEntryAssembly().GetName().Version
                      + "\n ProductVersion >> " + Application.ProductVersion
                      + "\n ExecutablePath >> " + Application.ExecutablePath
                      //+ "\n resenderDir >> " + resenderDir
                      + "\n resenderArgs >> " + resenderArgs
                     );
    }

    private bool IncreaseFileVersionBuild() {
      if (System.Diagnostics.Debugger.IsAttached) {
        try {
          var fi = new DirectoryInfo(
            AppDomain.CurrentDomain.BaseDirectory).Parent.Parent.GetDirectories("Properties")[0].GetFiles("AssemblyInfo.cs")[0];
          var ve = System.Diagnostics.FileVersionInfo.GetVersionInfo(System.Reflection.Assembly.GetExecutingAssembly().Location);



          //string ol = ve.FileMajorPart.ToString() + "." + ve.FileMinorPart.ToString() + "." + ve.FileBuildPart.ToString() + "." + ve.FilePrivatePart.ToString();
          //string ne = ve.FileMajorPart.ToString() + "." + ve.FileMinorPart.ToString() + "." + (ve.FileBuildPart + 1).ToString() + "." + ve.FilePrivatePart.ToString();

          //string ol = ve.FileMajorPart.ToString() + "." + ve.FileMinorPart.ToString() + "." + (ve.FileBuildPart + 1).ToString() + "." + date;

          //System.IO.File.WriteAllText(fi.FullName, System.IO.File.ReadAllText(fi.FullName).Replace("[assembly: AssemblyFileVersion(\"" + ol + "\")]", "[assembly: AssemblyFileVersion(\"" + ne + "\")]"));

          var assemblyInfo = LoadXML(fi.FullName);
          var id = FindId(assemblyInfo, "[assembly: AssemblyFileVersion(");

          var current = assemblyInfo[id];
          var place = current.IndexOf("\"");
          current = current.Substring(place+1);

          place = current.IndexOf(".");
          string v1 = current.Substring(0,place);
          current = current.Substring(place+1);

          place = current.IndexOf(".");
          string v2 = current.Substring(0, place);
          current = current.Substring(place + 1);

          place = current.IndexOf(".");
          string v3 = current.Substring(0, place);

          string date = "__"
                        + DateTime.Now.Day.ToString("00")
                        + "." + DateTime.Now.Month.ToString("00")
                        + "." + DateTime.Now.Year.ToString("0000")
                        + "__" + DateTime.Now.Hour.ToString("00")
                        + ":" + DateTime.Now.Minute.ToString("00")
                        ;


          string ne = "[assembly: AssemblyFileVersion(\""
                      + v1
                      + "." + v2
                      + "." + (Convert.ToInt16( v3 ) + 1).ToString("0000")
                      + "." + date
                      + "\")]";


          assemblyInfo[id] = ne;
          SaveXML(assemblyInfo, fi.FullName);

          return true;
        }
        catch {
          return false;
        }
      }
      return false;
    }

    private void bigPngFinderToolStripMenuItem_Click(object sender, EventArgs e) {
      DialogResult mbr = MessageBox.Show("Пересохранять при возможности?", "bigPngFinder",
                                         MessageBoxButtons.YesNoCancel);

      if (mbr == DialogResult.Cancel)
        return;

      var encoderPng = ImageCodecInfo.GetImageEncoders()
                       .First(c => c.FormatID == ImageFormat.Png.Guid);
      var encParamsPng = new EncoderParameters(1);
      encParamsPng.Param[0] = new EncoderParameter(System.Drawing.Imaging.Encoder.Quality, 100L);

      var encoderJpg = ImageCodecInfo.GetImageEncoders()
                       .First(c => c.FormatID == ImageFormat.Jpeg.Guid);
      var encParamsJpg = new EncoderParameters(2);
      encParamsJpg.Param[0] = new EncoderParameter(System.Drawing.Imaging.Encoder.Quality, 100L);
      encParamsJpg.Param[1] = new EncoderParameter(System.Drawing.Imaging.Encoder.RenderMethod,
          (int)EncoderValue.RenderProgressive);

      List<string> saveList = new List<string>();

      GameResChecker grs = new GameResChecker(LogicCaseSettings);

      FileInfo fA = null, fB = null;
      string text = this.Text;
      List<string> pngList = new List<string>();
      List<string> pngListBig = new List<string>();
      List<string> pngListBigVery = new List<string>();
      List<string> pngListOptimal = new List<string>();
      List<string> pngListQualityVery = new List<string>();
      List<string> pngListQuality = new List<string>();
      List<string> BadName = new List<string>();
      Dictionary<string, long> size = new Dictionary<string,long>();
      this.Text = "Getting Files Tree " + repDir + "exe\\";
      getallfile(repDir+ "exe\\", pngList);
      int pow;

      Regex regex = new Regex("[A-Zа-яА-Я ]");

      long OldKb = 0, NewKb = 0;
      long OldKbVery = 0, NewKbVery = 0;

      //System.Drawing.Image objImageTemp;
      Bitmap objImageTemp;
      Bitmap bt;
      Image objImage;

      string imgFileName="";

      for (int i = 0; i < pngList.Count; i++) {
        imgFileName = pngList[i];
        grs.ResAdd(imgFileName);
        try {
          if (regex.IsMatch(pngList[i].Replace(repDir, ""))) {
            //MessageBox.Show("НЕПРАВИЛЬНЫЕ СИМВОЛЫ В ИМЕНИ ФАЙЛА!!!\n"+pngList[i]);
            Debag("НЕПРАВИЛЬНЫЕ СИМВОЛЫ В ИМЕНИ ФАЙЛА!!!\n" + pngList[i], Color.Red);
            BadName.Add(pngList[i]);
          }
          if (!pngList[i].EndsWith(".png") && !pngList[i].EndsWith(".jpg")) {
            pngList.RemoveAt(i);
            i--;
          }
          else {
            objImage = Image.FromFile(pngList[i]);
            {
              if (pngList[i].EndsWith(".png")) {
                try {
                  bt = new Bitmap(objImage);
                  bt.Save(Application.StartupPath + "//bigPngFinderTemp.png", encoderPng, encParamsPng);
                  bt.Dispose();
                  //objImage.Save(Application.StartupPath + "//bigPngFinderTemp.png", encoderPng, encParamsPng);


                  //objImage.Save("bigPngFinderTemp.png", System.Drawing.Imaging.ImageFormat.Png);
                  fA = new FileInfo(pngList[i]);
                  fB = new FileInfo(Application.StartupPath + "//bigPngFinderTemp.png");
                }
                catch (Exception savePNG) {
                  MessageBox.Show("Exception savePNG\n\n"
                                  + Application.StartupPath + "//bigPngFinderTemp.png" + "\n\n"
                                  + imgFileName + "\n\n"
                                  + savePNG.Message+ "\n\n"
                                  + savePNG.StackTrace+"\n\n"
                                 );
                  fA = new FileInfo(pngList[i]);
                  fB = fA;
                }
              }
              else if (pngList[i].EndsWith(".jpg")) {
                try {
                  bt = new Bitmap(objImage);
                  bt.Save(Application.StartupPath + "//bigPngFinderTemp.jpg", encoderJpg, encParamsJpg);
                  bt.Dispose();
                  //objImage.Save(Application.StartupPath + "//bigPngFinderTemp.jpg", encoderJpg, encParamsJpg);
                  fA = new FileInfo(pngList[i]);
                  fB = new FileInfo(Application.StartupPath + "//bigPngFinderTemp.jpg");
                }
                catch (Exception saveJPG) {
                  MessageBox.Show("Exception saveJPG\n\n"
                                  + Application.StartupPath + "//bigPngFinderTemp.jpg" + "\n\n"
                                  + imgFileName + "\n\n"
                                  + saveJPG.Message+ "\n\n"
                                  + saveJPG.StackTrace+"\n\n"
                                 );
                  fA = new FileInfo(pngList[i]);
                  fB = fA;
                }
                //if (mbr == DialogResult.Yes)
                //    objImage.Save(pngList[i], encoder, encParams);

                //objImage.Save("bigPngFinderTemp.jpg", System.Drawing.Imaging.ImageFormat.Jpeg);

              }

              if (fA.Length > (fB.Length * 1.05f) && ((fA.Length - fB.Length) / 1024) > 4) {
                saveList.Add(pngList[i]);
                OldKb += fA.Length / 1024;
                NewKb += fB.Length / 1024;
                pngListQuality.Add(pngList[i] + "\n\tOld: " + fA.Length / 1024 + "kb" + "\n\tNew: " + fB.Length / 1024 + "kb" +
                                   "\n\tWin:" + (fA.Length - fB.Length) / 1024 + "kb");
                //objImage.Save(pngList[i] + "___", System.Drawing.Imaging.ImageFormat.Png);
                //MessageBox.Show(pngList[i] + "___");
                if ((fA.Length - fB.Length) / 1024 > 100) {
                  OldKbVery += fA.Length / 1024;
                  NewKbVery += fB.Length / 1024;
                  pngListQualityVery.Add(pngList[i] + "\n\tOld: " + fA.Length / 1024 + "kb" + "\n\tNew: " + fB.Length / 1024 + "kb" +
                                         "\n\tWin:" + (fA.Length - fB.Length) / 1024 + "kb");
                }
              }

              //string str = "x"+ objImage.Width + " y"+ objImage.Height;
              for (int z = 8; z < 11; z++) {
                pow = (int)Math.Pow(2, (float)z);

                //str += "\t" + pow;


                if (((objImage.Width < (pow + 4) || (objImage.Width < (pow * 1.04))) && (objImage.Width > pow))) {
                  pngListOptimal.Add(pngList[i] + "\n\tWIDTH " + objImage.Width + "\t >> " + pow);
                }

                if (((objImage.Height < (pow + 4) || (objImage.Height < (pow * 1.04))) && (objImage.Height > pow))) {
                  pngListOptimal.Add(pngList[i] + "\n\tHeight " + objImage.Height + "\t >> " + pow);
                }
              }
              //pngListOptimal.Add(pngList[i] +"\t"+ str);

              if (objImage.Width <= 256 & objImage.Height <= 256) {
                pngList.RemoveAt(i);
                i--;
              }
              else {
                //size[pngList[i]] = objImage.Width * objImage.Height;

                if ((objImage.Width > 1024 || objImage.Height > 1024)) {
                  pngListBigVery.Add(pngList[i]);
                  pngList.RemoveAt(i);
                  i--;
                }
                else if ((objImage.Width > 512 || objImage.Height > 512)) {
                  pngListBig.Add(pngList[i]);
                  pngList.RemoveAt(i);
                  i--;
                }
              }
              objImage.Dispose();
            }
          }
        }
        catch(Exception imgException) {
          MessageBox.Show("Exception global for '" + imgFileName +"'\n"
                          + imgException.Message + "\n"
                          + imgException.StackTrace + "\n"
                          + imgException.InnerException + "\n"
                         );
        }
        //this.Text = ((int)( ( (float)i / (float)pngList.Count ) * 10000 ))/(float)100 + "%";
        ProgresBarSet(i, pngList.Count, "BigPngFinger", imgFileName);
      }

      if(mbr == DialogResult.Yes) {
        for(int i =0; i<saveList.Count; i++) {
          ProgresBarSet(i, saveList.Count, "BigPngFinder >> Saving Images");
          objImage = Image.FromFile(saveList[i]);
          //try
          //{
          ImageCodecInfo encoder;
          EncoderParameters encParams;
          if (saveList[i].EndsWith(".png")) {
            encoder = encoderPng;
            encParams = encParamsPng;
          }
          else {
            encoder = encoderJpg;
            encParams = encParamsJpg;
          }

          bt = new Bitmap(objImage);
          bt.Save(saveList[i] + "_cache", encoder, encParams);
          bt.Dispose();

          objImage.Dispose();

          File.Delete(saveList[i]);
          System.IO.File.Move(saveList[i] + "_cache", saveList[i]);
          Debag("Resaved file >> " + saveList[i]);

          //}
          //catch(Exception ee)
          //{
          //    MessageBox.Show(ee.Message);
          //}
        }
      }

      ProgresBarSet(0, 0);
      Debag("\n\nBadName!!!");
      Debag(BadName);

      //Debag("\n\n<=512 and >256");
      //Debag(pngList);

      //Debag("\n\n>512");
      //Debag(pngListBig);

      Debag("\n\n>1024");
      Debag(pngListBigVery);


      Debag("\n\nСпрайт в 5% от оптимального");
      Debag(pngListOptimal);


      Debag("\n\nNotForWEB!!!");
      Debag(pngListQuality);

      Debag("Old size: " + OldKb + "kb");
      Debag("New size: " + NewKb + "kb");
      Debag("Win size: " + ( OldKb - NewKb ) + "kb");

      Debag("\nRealyBadSize\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!",
            Color.Red);
      Debag(pngListQualityVery);
      Debag("OldVery size: " + OldKbVery + "kb");
      Debag("NewVery size: " + NewKbVery + "kb");
      Debag("WinVery size: " + (OldKbVery - NewKbVery) + "kb");

      Debag(
        "\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        + "\n!!!!!!!!!!!!!!!          GameResChecker         !!!!!!!!!!!!!!!"
        + "\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!", Color.Red);

      Debag(grs.MessageGet());

      this.Text = text;
    }

    private void getallfile(string startdirectory, List<string> filess) {
      string[] searchdirectory = Directory.GetDirectories(startdirectory);
      if (searchdirectory.Length > 0) {
        for (int i = 0; i < searchdirectory.Length; i++) {
          getallfile(searchdirectory[i] + @"\", filess);
        }
      }
      string[] filesss = Directory.GetFiles(startdirectory);
      for (int i = 0; i < filesss.Length; i++) {
        filess.Add(filesss[i]);
      }

    }

    private void fXresCheckerToolStripMenuItem_Click(object sender, EventArgs e) {
      Debag(">>>fXresChecker>>>");
      List<MyControl> cc = GetCreatedControls();
      string dir = repDir + "exe\\";
      string dir_fx = repDir + "exe\\assets\\levels\\common\\fx\\";
      Dictionary<string, Image> fx_images = new Dictionary<string, Image>();

      Dictionary<string, int> spr_notfound = new Dictionary<string, int>();
      Dictionary<string, int> spr_notincommon = new Dictionary<string, int>();
      Dictionary<string, int> spr_notincommon_short = new Dictionary<string, int>();
      Dictionary<string, int> spr_diferent = new Dictionary<string, int>();
      Dictionary<string, int> spr_diferent_short = new Dictionary<string, int>();
      Dictionary<string, int> spr_deleted = new Dictionary<string, int>();
      Dictionary<string, int> spr_deleted_short = new Dictionary<string, int>();


      Dictionary<string, int> spr_inanim = new Dictionary<string, int>();

      //чекаем частички в анимациях
      for (int c = 0; c < cc.Count; c++) {
        MyControl mc = cc[c];


        //Debag( gameDir + "exe\\" + mc.GetDefResName());
        string[] xmls = Directory.GetFiles(dir + mc.GetDefResName(), "*.xml");

        for (int x = 0; x < xmls.Length; x++) {
          List<string> xml = LoadXML(xmls[x]);
          if (xml[0].StartsWith( "<animation" ) || xml[1].StartsWith("<ps type=")) {
            bool changed = false;
            for (int j = 0; j < xml.Count; j++) {
              if (xml[j].IndexOf(" res=\"") > -1) {
                string res = xml[j].Substring(xml[j].IndexOf(" res=\"") + 6);
                res = res.Substring(0, res.IndexOf("\""));
                if (File.Exists(dir + mc.GetDefResName() + res + ".png")) {
                  res += ".png";
                }
                else {
                  res += ".jpg";
                }
                if (res.Length > 0) {
                  int count;
                  if (!spr_inanim.TryGetValue(dir + mc.GetDefResName() + res, out count)) {
                    spr_inanim[dir + mc.GetDefResName() + res] = 0;
                  }
                  spr_inanim[dir + mc.GetDefResName() + res]++;
                  //Debag("animation check >> " +dir + mc.GetDefResName() + res + "\t" + spr_inanim[dir + mc.GetDefResName() + res]);
                }
              }
            }
            if (changed) {
              SaveXML(xml, xmls[x]);
            }
          }
        }

      }

      #region Jan FX
      //чекаем яновские частички
      for (int c = 0; c < cc.Count; c++) {
        MyControl mc = cc[c];


        //Debag( gameDir + "exe\\" + mc.GetDefResName());
        string[] xmls = Directory.GetFiles( dir + mc.GetDefResName(), "*.xml");

        for( int x = 0; x<xmls.Length; x++ ) {
          List<string> xml = LoadXML(xmls[x]);
          if(xml[0] == "<ps type = \"jan\">") {
            bool changed = false;
            for(int j = 0; j<xml.Count; j++) {
              if (xml[j].IndexOf("res = ") > -1) {
                string res = xml[j].Substring(xml[j].IndexOf("\"")+1);
                res = res.Substring(0,res.IndexOf("\""));

                if (res.StartsWith("assets\\levels\\common\\fx\\"))
                  continue;

                string res_name = res.Substring(res.LastIndexOf("\\") + 1);
                if (File.Exists(dir + res + ".png")) {
                  res += ".png";
                  res_name += ".png";
                }
                else if (File.Exists(dir + res + ".jpg")) {
                  res += ".jpg";
                  res_name += ".jpg";
                }
                else {
                  //Debag("FILE NOT FOUND\t" + dir + res,Color.Red);
                  //spr_notfound.Add(dir + res);
                  int count;
                  if (!spr_notfound.TryGetValue(dir + res, out count))
                    spr_notfound[dir + res] = 0;
                  spr_notfound[dir + res]++;
                }
                //Debag("\t" + res + "\t" + res_name);
                if(File.Exists(dir_fx+res_name)) {
                  if (File.Exists(dir + res)) {
                    Image fx_common;
                    if (!fx_images.TryGetValue(res_name, out fx_common)) {
                      fx_images[res_name] = Image.FromFile(dir_fx + res_name);
                      fx_common = fx_images[res_name];
                    }
                    Image fx = Image.FromFile(dir + res);

                    if(fx.Size==fx_common.Size) {
                      int count;
                      if (!spr_inanim.TryGetValue(dir + res, out count)) {
                        xml[j] = "\t\tres = \"assets\\levels\\common\\fx\\" + res_name.Substring(0, res_name.Length - 4) + "\"";
                        fx.Dispose();
                        //File.Delete(dir + res);
                        //Debag("\t\t переносим >" + xml[j]);
                        changed = true;

                        if (!spr_deleted.TryGetValue(dir + res, out count))
                          spr_deleted[dir + res] = 0;
                        spr_deleted[dir + res]++;

                        if (!spr_deleted_short.TryGetValue(res_name, out count))
                          spr_deleted_short[res_name] = 0;
                        spr_deleted_short[res_name]++;
                      }
                      else {
                        Debag("in anim \t" + dir + res + "\t" + spr_inanim[dir + res]);
                      }
                    }
                    else {
                      //Debag("\t\t нестандартный спрайт >" + xml[j]);
                      //spr_diferent.Add(dir + res);
                      int count;
                      if (!spr_diferent.TryGetValue(dir + res, out count))
                        spr_diferent[dir + res] = 0;
                      spr_diferent[dir + res]++;

                      if (!spr_diferent_short.TryGetValue(res_name, out count))
                        spr_diferent_short[res_name] = 0;
                      spr_diferent_short[res_name]++;
                    }
                  }
                }
                else {
                  //Debag("\t\t спрайта нет в common >" + res);
                  //spr_notincommon.Add(dir + res);
                  int count;
                  if (!spr_notincommon.TryGetValue(dir + res, out count))
                    spr_notincommon[dir + res] = 0;
                  spr_notincommon[dir + res]++;

                  if (!spr_notincommon_short.TryGetValue(res_name, out count))
                    spr_notincommon_short[res_name] = 0;
                  spr_notincommon_short[res_name]++;
                }
              }
            }
            if(changed) {
              SaveXML(xml, xmls[x]);
            }
          }
        }

      }
      #endregion

      Debag("\t>>>spr_notfound спрайт про.бан");
      foreach(KeyValuePair<string,int> kvp in spr_notfound)
        Debag("\t\t"+kvp.Value+"\t"+kvp.Key);
      Debag("\t<<<spr_notfound");


      Debag("\t>>>spr_notincommon этих спрайтов нет в комон");
      foreach (KeyValuePair<string, int> kvp in spr_notincommon)
        Debag("\t\t" + kvp.Value + "\t" + kvp.Key);
      Debag("\t<<<spr_notincommon");
      Debag("\t>>>spr_notincommon_short этих спрайтов нет в комон ( поименно )");
      foreach (KeyValuePair<string, int> kvp in spr_notincommon_short)
        Debag("\t\t" + kvp.Value + "\t" + kvp.Key);
      Debag("\t<<<spr_notincommon_short");


      Debag("\t>>>spr_diferent - спрайт отличается от комоновского" );
      foreach (KeyValuePair<string, int> kvp in spr_diferent)
        Debag("\t\t" + kvp.Value + "\t" + kvp.Key);
      Debag("\t<<<spr_diferent");
      Debag("\t>>>spr_diferent_short - спрайт отличается от комоновского ( поименно )");
      foreach (KeyValuePair<string, int> kvp in spr_diferent_short)
        Debag("\t\t" + kvp.Value + "\t" + kvp.Key);
      Debag("\t<<<spr_diferent_short");


      Debag("\t>>>spr_deleted удаленые спрайты, которые есть в комон, но дублировались в локации и не использовались в анимации");
      foreach (KeyValuePair<string, int> kvp in spr_deleted) {
        Debag("\t\t" + kvp.Value + "\t" + kvp.Key);
        File.Delete(kvp.Key);
      }
      Debag("\t<<<spr_deleted");
      Debag("\t>>>spr_deleted_short удаленые спрайты, которые есть в комон, но дублировались в локации и не использовались в анимации ( поименно )");
      foreach (KeyValuePair<string, int> kvp in spr_deleted_short) {
        Debag("\t\t" + kvp.Value + "\t" + kvp.Key);
      }
      Debag("\t<<<spr_deleted_short");

      //Debag("\t>>>spr_inanim - спрайт используется в анимации");
      //foreach (KeyValuePair<string, int> kvp in spr_inanim)
      //    Debag("\t\t" + kvp.Value + "\t" + kvp.Key);
      //Debag("\t<<<spr_inanim");
      //Debag("\t>>>spr_inanim - спрайт используется в анимации ( поименно )");
      //foreach (KeyValuePair<string, int> kvp in spr_inanim)
      //    Debag("\t\t" + kvp.Value + "\t" + kvp.Key);
      //Debag("\t<<<spr_inanim");

      Debag(">>>fXresChecker>>>");
    }

    public void addSFX( MyControl mc, string sfx, string prg ) {
      if (prg.StartsWith("XX_")) {
        prg = prg.Substring(3);
        string goname = "gfx_" + mc.getNamePost() + "_" + prg.Replace("use_","") + "_zone";
        MyObjClass go =  GetObj(goname);
        if(go==null) {
          MessageBox.Show("Не удалось найти объект\n" + goname);
        }
        else {
          go.SetPropertie("event_mdown", "SoundSfx( &quot;" + sfx + "&quot; );\n" + go.GetPropertie("event_mdown"));
        }
      }
      else {
        int func_place = FindId(mc.GetOwnerObj().GetModule().GetTrig("").GetCode(), "function public." + prg + "(");
        if (func_place < 0) {
          MessageBox.Show("Не удалось найти функцию\n" + "function public." + prg + "(");
        }
        else {
          mc.GetOwnerObj().GetModule().GetTrig("").AddCode("  SoundSfx( \"" + sfx + "\" )", func_place + 1);
        }
      }
      //mc.GetOwnerObj().GetModule().GetTrig().AddCode
    }

    private void showFunctionsToolStripMenuItem_Click(object sender, EventArgs e) {
      List<string> code = modules[0].GetTrigCode("");
      functionsParser(code);
    }

    private void functionsParser(string code) {
      FuncString funcString = new FuncString(code);
    }

    private void functionsParser(List<string> code ) {
      functionsParser(ListToString(code));
    }

    private void showLevelSoundSchemeToolStripMenuItem_Click(object sender, EventArgs e) {
      int lvl = 0;
      string lvl_str = "";

      OpenFileDialog ofd = new OpenFileDialog();
      ofd.Filter = "Logic file (.lev)|*.lev";
      ofd.DefaultExt = repDir + "src\\doc\\Logic\\";
      DialogResult mbr = ofd.ShowDialog();

      if (mbr == DialogResult.OK) {

        string s = ofd.FileName;
        //Debag(s);
        s = s.Substring(s.LastIndexOf("\\") + 1);
        //Debag(s);
        char[] ch = s.ToCharArray();
        bool lvl_seted = false;
        for (int i = 0; i < s.Length; i++) {
          if (char.IsDigit(s[i])) {
            lvl = Convert.ToInt16(Convert.ToString(s[i]));
            Debag("Номер уровня -> " + lvl.ToString(), Color.RoyalBlue);
            lvl_seted = true;
            lvl_str = Convert.ToString(s[i]);
            //lvl_str = "";
            break;
          }
        }
        if (!lvl_seted) {
          int pid = s.LastIndexOf("_");
          if (pid > -1) {
            lvl_str = s.Replace(".lev", "").Substring(pid + 1);
            //Debag("Имя уровня (будет добавлено к локациям и предметам) -> " + lvl_str, Color.RoyalBlue);
          }

        }

        scheme = new Scheme(ofd.FileName, lvl, lvl_str);


        schemeShowSoundScheme(scheme);
        //return;
      }
      else {
        return;
      }
    }

    private void positionMovecoordinatesToolStripMenuItem_Click(object sender, EventArgs e) {
      PositionTXTchanger ch = new PositionTXTchanger();
      ch.ShowDialog();
    }

    private void animXMLConvertToolStripMenuItem_Click(object sender, EventArgs e) {
      bool needCopy = false;
      //MessageBox.Show(gameDir);
      try {
        var fbd = new FolderBrowserDialog();
        var anmStructurePath = repDir;
        fbd.SelectedPath = anmStructurePath;
        fbd.Description = "Выберите папку для копии структуры анимаций";

        if (needCopy) {
          if (fbd.ShowDialog() == DialogResult.OK) {
            anmStructurePath = fbd.SelectedPath;
          }
          else {
            return;
          }
        }

        string[] anims = Directory.GetFiles(repDir + "exe", "*.xml", SearchOption.AllDirectories);
        for(int i = 0; i<anims.Length; i++) {
          ProgresBarSet(i, anims.Length);
          string fileName = Path.GetFileName(anims[i]);
          //File.Copy(anims[i], gameDir+ @"tool\"+ fileName);
          List<string> anm = LoadXML(anims[i]);
          if (anm[0].IndexOf("<animation type=\"complex\"") > -1 || anm[1].IndexOf("<animation type=\"complex\"") > -1) {
            string newPath = anmStructurePath + anims[i].Replace(repDir, "\\");

            //MessageBox.Show(anims[i]
            //    +"\n"+ anmStructurePath + anims[i].Replace(gameDir, ""));

            if (needCopy) {
              string newDir = Path.GetDirectoryName(newPath);
              Directory.CreateDirectory(newDir);
              File.Copy(anims[i], newPath);
            }

            Debag("Converting >> " + anims[i]);
            ProcessStartInfo psi = new ProcessStartInfo();
            psi.FileName = repDir + @"tool\AnimXMLConvertor\AnimXMLConvertor.exe";
            //psi.Arguments = "-test -log -filedel " + anims[i];
            psi.Arguments = "-test -log -filedel " + anims[i];
            var process = Process.Start(psi);
            process.WaitForExit();
          }
        }
      }
      catch(Exception exc) {
        MessageBox.Show("AnimXMLConvertor not found?\n"+exc.Message);
      }

      ProgresBarSet();
    }

    private string ProgressBarHeadext = "";
    private void ProgresBarSet( int current=0, int max=0, string name="", string after = "") {
      if (current < max) {
        if (string.IsNullOrEmpty(ProgressBarHeadext)) {
          ProgressBarHeadext = Text;
        }
        progressBar1.Enabled = true;
        progressBar1.Visible = true;
        progressBar1.Maximum = max;
        progressBar1.Value = Math.Max( 0, current);
        //float percent = (max - current) * 100f;

        Text = name + " >> " + current + " / " + max + " >> " + ( (float)current * (float)100 /
               (float)max ).ToString("0.00") + "% " + after;
      }
      else {
        progressBar1.Enabled = false;
        progressBar1.Visible = false;
        Text = ProgressBarHeadext;
        ProgressBarHeadext = "";
      }
    }

    private void autoSortControlsToolStripMenuItem_Click(object sender, EventArgs e) {
      RePlace(false);
    }

    private void addPazzlesToolStripMenuItem_Click(object sender, EventArgs e) {
      var ofd = new OpenFileDialog();
      if (ofd.ShowDialog() != DialogResult.OK) return;
      var xml = LoadXML(ofd.FileName);
      foreach(var line in xml) {
        Debag(line);
        var po = new Propobj(line);
        var res = po.Propertie("res");
        Debag(res);
        var name = res.Substring(res.LastIndexOf("/")+1);
        Debag(name);
        res = res.Substring(0, res.LastIndexOf("/"));
        Debag(res);
        var owner = res.Substring(res.LastIndexOf("/")+1);
        Debag(owner);
        //var owner = zz;
        //if (zz.StartsWith("zz")) {

        //}
        //else {
        //  //Debag(res);
        //  //res = res.Substring(0, res.LastIndexOf("/"));
        //  //owner = res.Substring(res.LastIndexOf("/") + 1);
        //  //Debag(owner);
        //}
        var obj = GetObj(owner);
        if(obj == null) {
          MessageBox.Show($"owner({owner}) не найден");
          continue;
        }
        var objInProject = GetObj(po.Propertie("_name"));
        if(objInProject!=null) {
          Debag($"{owner} - {name} - {objInProject.GetOwnerControl().GetName()}");
          if (owner == objInProject.GetOwnerControl().GetName()) {
            MessageBox.Show($"obj({name}) уже создан");
          }
          else {
            MessageBox.Show($"obj({name}) найден в в другом месте({objInProject.GetOwnerControl().GetName()})");
          }
          continue;
        }
        var o = new MyObjClass(new List<string>() {
          line
        }, 0, obj.GetModule());
        obj.objAdd(o);
      }
    }
  }
}


using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Text.RegularExpressions;


namespace logicCase {
  public partial class MyControl : UserControl {
    string dopCMD="";
    static int count = 0;
    static Dictionary<string, List<Label>> PRGlabels = new Dictionary<string,List<Label>>(); //
    public static Form1 FormRef;
    string type;
    string name;
    Point DownPoint;
    bool IsDragMode = false;
    MyObjClass ownerObj;
    MyControl ownerControl =null;
    List<MyControl> childs = new List<MyControl>();
    List<MyControl> allChilds;
    public List<PrgItemClass> PRGlist = new List<PrgItemClass>();
    Point oLoc;
    string creationType = "";
    string creationTypeDop = "";
    string prgCmd = "";
    string prgCmdDop = "";
    bool prgStarted = false;
    static MyControl selectedControl;
    TextBox tbPRG;
    List<GameObj> gobjsGet = new List<GameObj>();
    List<GameObj> gobjsUse = new List<GameObj>();
    GameObj gobj;

    Color ColorGet = Color.LightGreen;
    Color ColorUse = Color.LightCoral;
    Color ColorClk = Color.LightBlue;
    Color ColorWin = Color.MediumPurple;
    Color ColorDef = Color.Gray;
    Color ColorSeted;
    Dictionary<string, Color> HintColor = new Dictionary<string, Color>();
    public Dictionary<string, ToolTip> HintToolTip = new Dictionary<string, ToolTip>();
    public Dictionary<string, Label> HintLabel = new Dictionary<string, Label>();

    Dictionary<string, string> HintToolTipLogicText = new Dictionary<string, string>();

    public static Dictionary<string, Hint> HINT = new Dictionary<string, Hint>();
    public bool IsSubroomType {
      get {
        return ownerObj.IsSubroomType;
      }
    }

    public MyControl(string type, string name, MyObjClass ownerObj) {
      //Debag(" конструктор контрола " + count + "\n" + name + "\n"+type);
      InitializeComponent();
      this.ownerObj = ownerObj;
      this.type = type;
      this.name = name;
      this.Width = 110;
      this.Height = 50;

      HintColor["get"] = ColorGet;
      HintColor["use"] = ColorUse;
      HintColor["clk"] = ColorClk;
      HintColor["def"] = ColorDef;

      this.labelName.Text = name;

      if (name.IndexOf(" ") >= 0) {
        MessageBox.Show("MyControl *" + type + "_" + name + "* содержит недопустимые символы");
      }
      else if (new Regex("[а-яА-Я]").IsMatch(name)) {
        MessageBox.Show("MyControl *" + type + "_" + name + "* содержит недопустимые символы");
      }



      if ( this.Width < ( this.labelName.PreferredWidth + 12 ) ) this.Width =  this.labelName.PreferredWidth + 12;

      //this.Location = new Point(25, 250);
      if (selectedControl == null)

        this.Location = new Point(25 + FormRef.GetRooms().Count * 25, 150 + FormRef.GetRooms().Count * 25);
      else
        this.Location = new Point(selectedControl.Location.X, selectedControl.Location.Y);
      count++;
      oLoc = new Point( Location.X, Location.Y);

      if (name.IndexOf("ho_") == 0) {
        this.BackColor = Color.LightCoral;
      }
      else if (name.IndexOf("mg_") == 0) {
        this.BackColor = Color.Orange;
      }
      else if (name.IndexOf("rm_") == 0) {
        this.BackColor = Color.SlateGray;
      }
      //line = new LineClass(this);

      panelItems.MouseEnter += highLightLabel;
      panelItems.MouseLeave += downLightLabel;
      labelName.MouseEnter += highLightLabel;
      labelName.MouseLeave += downLightLabel;

      //panelItems.AutoSize = false;

      FormRef.allControls.Add(this);

      //this.MaximumSize = new Size(Math.Max(panelItems.Size.Width + 6, labelName.Size.Width + 6), Math.Max(panelItems.Size.Height + 26, labelName.Size.Height + 26));

    }

    void labelName_TextChanged(object sender, EventArgs e) {
      Label lab = sender as Label;
      Debag(lab.Text);
      //Debag("text changing in " + this.GetName() + " to " + this.labelName.Name);
      //throw new NotImplementedException();
    }


    public void ToFront() {
      this.BringToFront();
      FormRef.PanelToFront();
    }

    private void labelName_MouseDown(object sender, MouseEventArgs mevent) {
      this.Focus();
      DownPoint = mevent.Location;
      IsDragMode = true;
      if (mevent.Button == System.Windows.Forms.MouseButtons.Right) {
        allChilds = GetAllChilds();
        MenuStrip();


      }
      ToFront();
    }
    private void labelName_MouseUp(object sender, MouseEventArgs mevent) {
      IsDragMode = false;
      FormRef.DrawScreen();
    }
    private void labelName_MouseMove(object sender, MouseEventArgs mevent) {
      if (IsDragMode ) {

        Point p = mevent.Location;
        Point dp = new Point(p.X - DownPoint.X, p.Y - DownPoint.Y);
        Point oldLoc = Location;
        Location = new Point(Location.X + dp.X, Location.Y + dp.Y);

        this.ToFront();

        //childs mouving
        if (mevent.Button == System.Windows.Forms.MouseButtons.Right) {
          for (int i = 0; i < allChilds.Count; i++) {
            //FormRef.richTextBox1.AppendText("mouse_move " + childs[i].GetName() + "\n");
            allChilds[i].Location = new Point(allChilds[i].Location.X + dp.X, allChilds[i].Location.Y + dp.Y);
            //childs[i].ToFront();
          }
        }
        else if (mevent.Button == System.Windows.Forms.MouseButtons.Left) {
          for (int i = 0; i < childs.Count; i++) {
            //FormRef.richTextBox1.AppendText("mouse_move " + childs[i].GetName() + "\n");
            if (childs[i].GetName().IndexOf("rm_") > -1) continue;
            childs[i].Location = new Point(childs[i].Location.X + dp.X, childs[i].Location.Y + dp.Y);
            childs[i].ToFront();

            for (int j = 0; j < childs[i].childs.Count; j++) {
              //FormRef.richTextBox1.AppendText("mouse_move " + childs[i].GetName() + "\n");
              if (childs[i].childs[j].GetName().IndexOf("rm_") > -1) continue;
              childs[i].childs[j].Location = new Point(childs[i].childs[j].Location.X + dp.X, childs[i].childs[j].Location.Y + dp.Y);
              childs[i].childs[j].ToFront();
            }
          }
        }

        if ((oLoc.X != Location.X | oLoc.Y != Location.Y)) {
          FormRef.DrawScreen();
        }
        oLoc = new Point(Location.X, Location.Y);
        //FormRef.DrawScreen();

      }
    }


    public void BuildLogic( MyControl owner ) {
      MyControl mc = owner;
      List<MyObjClass> ol = mc.GetAllObjs();
      for (int o = 0; o < ol.Count; o++) {
        //Debag(ol[o].GetName());
        List<string> types = new List<string>();
        types.Add("rm");
        types.Add("mg");
        types.Add("ho");
        //types.Add("zz");
        for (int t = 0; t < types.Count; t++) {
          if (ol[o].GetName().IndexOf("g" + types[t] + "_") == 0) {
            string s = ol[o].GetName();
            s = types[t] + "_" + s.Substring(s.LastIndexOf("_") + 1);
            MyControl rm = FormRef.GetControl(s);
            //Debag(s);
            //MyControl nroom =
            if (rm != null & s != owner.GetName() ) {
              rm.AttachTo(mc);
              //mc.ChildAdd(rm);
            }
          }
        }
      }
    }

    public void AttachTo( MyControl ownerControl, string gate = "-X-" ) {

      //FormRef.richTextBox1.AppendText(name + " АТАЧИНГ to " + ownerControl.name + "\n");
      this.ownerControl = ownerControl;
      ownerControl.ChildAdd(this);
      //FormRef.richTextBox1.AppendText(name + " attached to " + ownerControl.name +"\n");
      //System.Windows.Forms.MessageBox.Show(name + " attached to " + ownerControl.name);

      MyControl mc = this;
      //if (mc.GetMyType() != "subroom" && mc.name.IndexOf("mg_") != 0 && mc.name.IndexOf("ho_") != 0)
      if (mc.getNamePrefix() == "rm") {
        List<MyObjClass> ol = mc.GetAllObjs();
        for (int o = 0; o < ol.Count; o++) {
          //Debag(ol[o].GetName());
          List<string> types = new List<string>();
          types.Add("rm");
          types.Add("mg");
          types.Add("ho");
          //types.Add("zz");
          for (int t = 0; t < types.Count; t++) {
            if (ol[o].GetName().IndexOf("g" + types[t] + "_") == 0) {
              string s = ol[o].GetName();
              s = types[t] + "_" + s.Substring(s.LastIndexOf("_") + 1);
              MyControl rm = FormRef.GetControl(s);
              //Debag(s);
              //MyControl nroom =
              if (rm != null & s != ownerControl.GetName()) {
                if (rm.GetOwnerControl() != null & mc.GetOwnerControl() != null) {
                  MessageBox.Show("у контролов уже есть родители\n"+rm.GetName() + " <<< " + mc.GetName() + "\n" + rm.GetOwnerControl().GetName() + " <<< " + mc.GetOwnerControl().GetName() + "\n объект вызвавший закольцовку => \n" + ol[o].GetName() + "\n"+gate);
                }
                else
                  rm.AttachTo(mc, ol[o].GetName());
                //mc.ChildAdd(rm);
              }
            }
          }
        }
      }

    }

    public void ChildAdd(MyControl child) {
      childs.Remove(child);
      childs.Add(child);
    }

    public void DrawAttaching() {
      for (int i = 0; i < childs.Count; i++) {
        childs[i].DrawAttaching();
      }
      //FormRef.ReDrawLines();
    }

    public MyObjClass GetOwnerObj() {
      return ownerObj;
    }

    private void MyControl_MouseDown(object sender, MouseEventArgs e) {


      this.Focus();
      ToFront();
    }

    private void panelItems_MouseDown(object sender, MouseEventArgs e) {
      this.Focus();
      ToFront();
    }

    public string GetName() {
      if (name.IndexOf("deploy_") == 0) {
        return name.Replace("deploy_", "");
      }
      else {
        return name;
      }
    }

    public string getNamePost() {
      if (GetName().StartsWith("inv"))
        return GetName().Substring(GetName().LastIndexOf("_") + 1);
      else
        return GetName().Substring(GetName().IndexOf("_") + 1);
    }

    public string getNamePrefix() {
      return GetName().Substring(0,GetName().IndexOf("_"));
    }

    public MyControl GetOwnerControl() {
      return ownerControl;
    }
    public List<MyControl> GetChilds() {
      return childs;
    }
    public List<MyControl> GetAllChilds() {
      List<MyControl> l = new List<MyControl>();
      GetAllChilds(l,this);
      return l;
    }
    void GetAllChilds( List<MyControl> l, MyControl mc) {
      for (int i = 0; i < mc.childs.Count; i++) {
        l.Add(mc.childs[i]);
        GetAllChilds(l, mc.childs[i]);
      }
    }
    public string GetMyType() {
      return type;
    }

    void MenuStrip() {
      for (int i = 0; i < menuStrip1.Items.Count; i++) {
        menuStrip1.Items[i].Available = true;
      }
      if (getNamePrefix()!="rm") {
        menuStrip1.Items[0].Available = false;
        //menuStrip1.Items[1].Available = false;
        menuStrip1.Items[2].Available = false;
        menuStrip1.Items[3].Available = false;
      }
      else {
        //menuStrip1.Items[0].Available = true;
        //menuStrip1.Items[1].Available = true;
        //menuStrip1.Items[2].Available = true;
        //menuStrip1.Items[3].Available = true;

      }

      if (getNamePrefix() == "mg" || getNamePrefix() == "rm" || getNamePrefix() == "zz")
        menuStrip1.Items[1].Available = true;
      else
        menuStrip1.Items[1].Available = false;

      menuStrip1.Show();
      menuStrip1.Focus();
      menuStrip1.BringToFront();
      //this.MaximumSize = new Size(Math.Max(menuStrip1.Size.Width + 6, labelName.Size.Width + 6), Math.Max(menuStrip1.Size.Height + 6, labelName.Size.Height + 26));

    }
    private void addDlg_Click(object sender, System.EventArgs e) {
      creationType = "dlg_"+getNamePost()+"_";
      menuStrip1.Hide();
      tbInit(creationType);
    }
    private void addWin_Click(object sender, System.EventArgs e) {
      creationType = "win_";
      menuStrip1.Hide();
      tbInit(creationType);
    }
    private void addUse_Click(object sender, System.EventArgs e) {
      creationType = "use_";
      menuStrip1.Hide();
      tbInit(creationType);
    }
    private void addClk_Click(object sender, System.EventArgs e) {
      creationType = "clk_";
      menuStrip1.Hide();
      tbInit(creationType);
    }
    private void addGet_Click(object sender, EventArgs e) {
      creationType = "get_";
      menuStrip1.Hide();
      tbInit(creationType);
    }
    private void addRoom_Click(object sender, EventArgs e) {
      creationType = "rm_";
      menuStrip1.Hide();
      tbInit(creationType);
    }
    private void addZoom_Click(object sender, EventArgs e) {
      creationType = "zz_";
      menuStrip1.Hide();
      tbInit(creationType);
    }
    private void addHO_Click(object sender, EventArgs e) {
      creationType = "ho_";
      menuStrip1.Hide();
      tbInit(creationType);
    }
    private void addMG_Click(object sender, EventArgs e) {
      creationType = "mg_";
      menuStrip1.Hide();
      tbInit(creationType);
    }
    private void AddDeploy_Click(object sender, EventArgs e) {
      creationType = "complex_";
      menuStrip1.Hide();
      tbInit(creationType,"COMPLEX");
    }

    string tbInitStartText = "";
    void tbInit(string creationType, string dop = "") {
      tbInitStartText = creationType;
      selectedControl = this;
      TextBox tb = new TextBox();
      tb.PreviewKeyDown += new PreviewKeyDownEventHandler(tb_PreviewKeyDown);
      tb.KeyUp += new KeyEventHandler(tb_KeyUp);
      tb.LostFocus += new EventHandler(tb_LostFocus);
      tb.Parent = this.labelName;
      //tb.Location = labelName.Location;
      tb.BringToFront();
      tb.Width = labelName.Width+4;
      tb.Height = labelName.Height-4;
      tb.Font = new Font(tb.Font.FontFamily, 8);
      tb.Text = creationType;
      tb.Show();
      tb.Focus();
      tb.SelectionStart = tb.Text.Length;
      tb.SelectionLength = 0;
      dopCMD = dop;
    }

    void tb_LostFocus(object sender, EventArgs e) {
      ((TextBox)sender).Dispose();
      creationType = "";
      creationTypeDop = "";
      prgCmd = "";
      prgStarted = false;
      //throw new NotImplementedException();
    }

    void tb_KeyUp(object sender, KeyEventArgs e) {
      TextBox tb = ((TextBox)sender);

      if (!tb.Text.StartsWith(tbInitStartText)) {
        tb.Text = tbInitStartText;
        tb.SelectionStart = tb.Text.Length;
        return;
      }
      tb.ReadOnly = false;
    }
    void tb_PreviewKeyDown(object sender, PreviewKeyDownEventArgs e) {
      TextBox tb = ((TextBox)sender);
      string keys = e.KeyCode.ToString();


      //FormRef.richTextBox1.AppendText( e.KeyCode.ToString() );
      //SpaceEscape
      if (!tb.Text.StartsWith(tbInitStartText)) {
        tb.Text = tbInitStartText;
        tb.SelectionStart = tb.Text.Length;
        return;
      }
      if (keys == "Escape") {
        tb.Hide();
        tb.Dispose();
      }
      else if (keys == "Return") {
        //MessageBox.Show("*" + tb.Text + "*" + tbInitStartText + "*");

        if (!tb.Text.StartsWith(tbInitStartText)) {
          tb.Text = tbInitStartText;
          tb.SelectionStart = tb.Text.Length;
          return;
        }

        //FormRef.richTextBox1.AppendText(tb.Text.IndexOf(creationType).ToString());
        if (tb.Text.IndexOf(creationType) == -1 & dopCMD.Length == 0) {
          System.Windows.Forms.MessageBox.Show("не указан префикс "+creationType );
          return;
        }
        List<MyControl> l = FormRef.GetAllControls();
        for (int i = 0; i < l.Count; i++) {
          if ( l[i].GetName().Substring(3) == tb.Text.Substring(3) ) {
            System.Windows.Forms.MessageBox.Show("найдено совпадение имени в " + l[i].GetName());
            return;
          }
        }
        //FormRef.richTextBox1.AppendText("ROOM_CREATING "+tb.Text+"\n");
        if (creationType == "ho_" & dopCMD.Length == 0) {
          dopCMD = tb.Text;

          tb.Text = "inv_";
          tbInitStartText = "inv_";
          creationTypeDop = "ho_inv";
          tb.SelectionStart = tb.Text.Length;
          //tb.SelectAll();
        }
        else {

          tb.Hide();
          FormRef.richTextBox1.AppendText( "PRG CREATION "+tb.Text+" owner control "+this.name+"\n" );
          //FormRef.ModuleCreation(this, tb.Text, dopCMD);



          FormRef.PrgCreation(this, tb.Text.Replace("complex_", "get_"), dopCMD, prg_creation_before);

          if (dopCMD == "COMPLEX") {
            FormRef.PrgCreation(null, tb.Text, "");
          }

          prg_creation_before = "";

          tb.Dispose();
          dopCMD = "";
        }

        FormRef.TreeViewBuild();
      }
      else if ((((e.KeyValue >= 65 & e.KeyValue <= 90) | (e.KeyValue >= 48 & e.KeyValue <= 57)) & e.Shift == false) | (e.Shift == true & keys == "OemMinus") | ( keys == "Back" & ( tb.Text.Length>creationType.Length | creationTypeDop == "ho_inv" ) ) | (e.Shift == true & keys == "ShiftKey")) {
        if (!tb.Text.StartsWith(tbInitStartText)) {
          tb.Text = tbInitStartText;
          tb.SelectionStart = tb.Text.Length;
          return;
        }
      }
      else {
        if (e.Control && (e.KeyValue == 86 || e.KeyValue == 118))
          tb.Text = "";
        //FormRef.richTextBox1.AppendText("WRONG SYMBOL " + keys + "\n");
        tb.ReadOnly = true;
        //tb.Text = tb.Text.Substring(0, tb.Text.Length - 1);
      }

    }

    public void menuStrip1_MouseLeave(object sender, EventArgs e) {

      menuStrip1.Hide();

      for (int i = 0; i < menuStrip1.Items.Count; i++) {
        menuStrip1.Items[i].Available = false;
        //ToFront();
        //ToFront();
      }
      //this.AutoSize = false;
      //menuStrip1.AutoSize = false;
      //menuStrip1.MinimumSize = new System.Drawing.Size(1, 1);
      //menuStrip1.Size = new System.Drawing.Size(1, 1);


      //this.MaximumSize = new Size(Math.Max(panelItems.Size.Width + 6, labelName.Size.Width + 6), Math.Max(panelItems.Size.Height + 26, labelName.Size.Height + 26));

      FormRef.DrawScreen();
    }

    //void tbPRGinit()
    //{
    //    if (prgStarted) return;
    //    prgStarted = true;
    //    creationType = "prg_";

    //    tbPRG = new TextBox();
    //    tbPRG.PreviewKeyDown += new PreviewKeyDownEventHandler(tbPRG_PreviewKeyDown);
    //    tbPRG.KeyUp += new KeyEventHandler(tbPRG_KeyUp);
    //    tbPRG.LostFocus += new EventHandler(tb_LostFocus);
    //    tbPRG.Parent = this.panelItems;
    //    //tbPRG.Location = this.panelItems.Location;
    //    tbPRG.BringToFront();
    //    tbPRG.Width = this.panelItems.Width;
    //    tbPRG.Text = "+get, -use, ++,-- multi";

    //    tbPRG.Show();
    //    tbPRG.Focus();
    //    tbPRG.SelectAll();
    //    //tbPRG.SelectionStart = tbPRG.Text.Length;
    //    //tbPRG.SelectionLength = 0;
    //    //tbInit(creationType);
    //}
    private void panelItems_MouseDoubleClick(object sender, MouseEventArgs e) {
      //tbPRGinit();
    }
    void tbPRG_KeyUp(object sender, KeyEventArgs e) {
      ((TextBox)sender).ReadOnly = false;
    }


    //ggghj plklshf
    public List<MyObjClass> GetAllObjs( ) {
      List<MyObjClass> allObjs = new List<MyObjClass>();
      List<MyObjClass> objs = GetOwnerObj().GetObjsList();
      for(int i = 0; i<objs.Count; i++) {
        allObjs.Add( objs[i] );
        objs[i].GetAllObjs( allObjs );
      }
      return allObjs;
    }


    void prgL_MouseDown(object sender, MouseEventArgs e) {
      this.Focus();
    }
    void prgL_MouseClick(object sender, MouseEventArgs e ) {
      Label lab = ((Label)sender);
      //FormRef.richTextBox1.AppendText(lab.Text+"\n");
    }
    void prgL_MouseDoubleClick(object sender, MouseEventArgs e ) {

    }


    int EndNeedCounter(List<string> l, int startId) {
      //FormRef.richTextBox1.AppendText(" start at string " + l[startId] + " \n");

      List<string> stack = new List<string>();
      //stack.Add("func");
      //startId++;
      string s = "";
      while (true) {
        //FormRef.richTextBox1.AppendText(" startId " + startId + " \n");
        try {
          s = l[startId];
        }
        catch {
          break;
        }


        if (s.IndexOf("if ") == 0 | (s.IndexOf("if(") == 0) | s.IndexOf(" if ") >-1 | s.IndexOf( " if(") >-1 | s.IndexOf(" if\n")>-1 | s.IndexOf("if\n")==0 ) {
          stack.Add("if");
          startId++;
          FormRef.richTextBox1.AppendText(" stack add " + stack[stack.Count-1] + " \n");
          continue;
        }
        if (s.IndexOf("for ") == 0 | s.IndexOf(" for ") > -1 | s.IndexOf(" for\n") > -1 | s.IndexOf("for\n") ==0) {
          stack.Add("for");
          startId++;
          FormRef.richTextBox1.AppendText(" stack add " + stack[stack.Count - 1] + " \n");
          continue;
        }
        if (s.IndexOf("function ") == 0 | s.IndexOf(" function ") > -1 ) {
          stack.Add("func");
          startId++;
          FormRef.richTextBox1.AppendText(" stack add " + stack[stack.Count - 1] + " \n");
          continue;
        }
        //FormRef.richTextBox1.AppendText( s+" s.IndexOf('end;') " + s.IndexOf("end;") + " \n");
        if (s.IndexOf("end ") == 0 | (s.IndexOf("end") == 0 & isLastInStr(s, "end")) | (s.IndexOf("end;") == 0) | s.IndexOf(" end ") > -1 | s.IndexOf(" end;") > -1 | isLastInStr(s, " end")) {
          FormRef.richTextBox1.AppendText(" stack remove " + stack[stack.Count - 1] + " \n");
          stack.RemoveAt(stack.Count - 1);
          startId++;
          if (stack.Count == 0) {
            break;
          }
          continue;
        }
        startId++;
      }
      FormRef.richTextBox1.AppendText(" last string " + l[startId-1] + " \n");
      return startId - 1;
    }

    bool isLastInStr(string str, string find) {
      if (str.IndexOf(find) > -1 & str.Length == (str.IndexOf(find) + find.Length)) {
        return true;
      }
      else {
        return false;
      }
    }

    int Matches(string str, string searth) {
      int count = 0;
      int f = str.IndexOf(searth);
      if (f > -1) {
        count++;
      }
      else {
        return 0;
      }
      str = str.Substring(f + searth.Length);
      while (str.IndexOf(searth) > -1) {
        f = str.IndexOf(searth);
        count++;
        str = str.Substring(f + searth.Length);
      }
      return count;
    }

    string ListToString(List<string> l) {
      string s="";
      for (int i = 0; i < l.Count; i++) {
        s += l[i] + "\r\n";
      }
      return s;
    }

    void Debag(string s) {
      FormRef.Debag(s);
    }
    void Debag(int s) {
      FormRef.richTextBox1.AppendText(s.ToString() + "\n");
    }

    void prgL_MouseEnter(object sender, EventArgs e) {
      if (Form.ActiveForm == FormRef) {
        this.Focus();
      }
      Label lab = ((Label)sender);
      string s = lab.Text.Substring(lab.Text.IndexOf("_") + 1);
      int f = s.IndexOf("_");
      if (f > -1) {
        s = s.Substring(0, f);
      }
      //Debag(s);
      for (int i = 0; i < PRGlabels[s].Count; i++) {
        byte A = PRGlabels[s][i].BackColor.A;
        byte R = PRGlabels[s][i].BackColor.R;
        byte G = PRGlabels[s][i].BackColor.G;
        byte B = PRGlabels[s][i].BackColor.B;
        if (A + 50 < 250)
          PRGlabels[s][i].BackColor = Color.FromArgb(A + 100, R, G, B);
      }
    }
    void prgL_MouseLeave(object sender, EventArgs e) {
      if (Form.ActiveForm == FormRef) {
        this.Focus();
      }
      Label lab = ((Label)sender);
      string s = lab.Text.Substring(lab.Text.IndexOf("_") + 1);
      int f = s.IndexOf("_");
      if (f > -1) {
        s = s.Substring(0, f);
      }
      //Debag(s);
      for (int i = 0; i < PRGlabels[s].Count; i++) {
        byte A = PRGlabels[s][i].BackColor.A;
        byte R = PRGlabels[s][i].BackColor.R;
        byte G = PRGlabels[s][i].BackColor.G;
        byte B = PRGlabels[s][i].BackColor.B;
        if (A - 50 > 0)
          PRGlabels[s][i].BackColor = Color.FromArgb(A - 100, R, G, B);
      }
    }

    public void AddPrgItem( GameObj obj, string name, int n) {
      if (GetPrgLabel(name) != null)
        return;
      //if(gobj == null) gobj = obj;
      PrgItemClass prgL = new PrgItemClass(obj,name,n);
      prgL.BringToFront();
      prgL.AutoSize = true;
      prgL.Text = name;
      prgL.Height = 15;
      prgL.MouseDown += new MouseEventHandler(prgL_MouseDown);
      prgL.MouseEnter += new EventHandler(prgL_MouseEnter);
      prgL.MouseLeave += new EventHandler(prgL_MouseLeave);
      //prgL.Width = this.panelItems.Width;
      prgL.Parent = this.panelItems;
      prgL.MouseClick += new MouseEventHandler(prgL_MouseClick);
      prgL.MouseDoubleClick += new MouseEventHandler(prgL_MouseDoubleClick);
      prgL.Location = new Point(0, 17 * PRGlist.Count);

      if (name.IndexOf("get_") == 0) {
        prgL.BackColor = Color.FromArgb(25,Color.Green);
      }
      else if (name.IndexOf("use_") == 0) {
        prgL.BackColor = Color.FromArgb(25, Color.Red);
      }
      else if (name.IndexOf("clk_") == 0) {
        prgL.BackColor = Color.FromArgb(25, Color.Gray);
      }

      string s = prgL.Text.Substring(prgL.Text.IndexOf("_") + 1);
      int f = s.IndexOf("_");
      if (f > -1) {
        s = s.Substring(0, f);
      }

      try {
        PRGlabels[s].Add(prgL);
      }
      catch {
        PRGlabels.Add(s, new List<Label>());
        PRGlabels[s].Add(prgL);
      }


      PRGlist.Add(prgL);
    }


    public Label GetPrgLabel(string name) {
      for (int i = 0; i < PRGlist.Count; i++) {
        if (PRGlist[i].Text == name)
          return PRGlist[i];
      }
      return null;
    }

    int HintItemCount = 0;
    public void AddHintItem(Hint hint) {


      bool finded = false;
      List<string> prg = FormRef.progress_names;

      for (int i = 0; i < prg.Count; i++) {
        if (hint.name == prg[i]) {
          finded = true;
          break;
        }
      }
      if (!finded) {
        FormRef.Debag("отсутствует прогресс с именем " + this.name + " >> " + hint.name, Color.Red);
        //Debag(this.name + " >> " + hint.name);
        //lab.Dispose();
      }
      else {
        Label lab = new Label();
        lab.AutoSize = true;
        lab.Name = hint.name;
        lab.Text = hint.name;
        lab.Location = new Point(1, 1 + 14 * HintItemCount);
        //lab.Width = 200;
        lab.Height = 15;
        lab.Parent = panelItems;
        lab.MouseEnter += highLightLabel;
        lab.MouseLeave += downLightLabel;
        lab.MouseEnter += lab_MouseEnter;
        lab.MouseLeave += lab_MouseLeave;
        lab.MouseDoubleClick += lab_MouseDoubleClick;
        lab.MouseDown += lab_MouseDown;

        ToolTip tooltip = new ToolTip();
        tooltip.AutoPopDelay = 32767;
        tooltip.InitialDelay = 2000;
        HintToolTip[lab.Name] = tooltip;
        tooltip.SetToolTip(lab, lab.Name);

        HintLabel[lab.Name] = lab;

        //Debag(hint.name + " " + HintItemCount);


        string func;
        hint.Properties.TryGetValue("tooltip", out func);
        if (func != null) {
          HintToolTipLogicText[hint.name] = func;
        }
        else {
          HintToolTipLogicText[hint.name] = "NONE";
        }



        //if (hint.name.IndexOf("scissors") > -1)
        //{
        //    foreach (KeyValuePair<string, string> kvp in hint.Properties)
        //    {
        //        FormRef.Debag(kvp.Key + " >>\t" + kvp.Value+"\t<<");
        //    }
        //}

        SetHintColor(lab, hint.name);


        List<Control> labels = new List<Control>();
        GetAllTypedControls(panelItems, labels, typeof(Label));


        if (labels.Count > 0) {
          int l_count = 0;
          for (int i = 0; i < prg.Count; i++) {
            foreach (Label hintLabel in labels) {
              if (hintLabel.Name == prg[i]) {
                hintLabel.Location = new Point(1, 1 + 14 * l_count);
                //tooltip
                l_count++;
                HintToolTip[hintLabel.Name].RemoveAll();
                HintToolTip[hintLabel.Name].SetToolTip(hintLabel, i.ToString() + "\n" + HintToolTipLogicText[hintLabel.Name]);
                //Debag(hintLabel.Name + " " + HintItemCount);
                break;
              }
            }

          }


        }
        HintItemCount++;
        HINT[hint.name] = hint;
      }

      //Debag(panelItems.Size.Width + "\t" + labelName.Size.Width + "\t" + panelItems.Size.Height + "\t" + labelName.Size.Height);

      //panelItems.Size = new Size(Math.Max(panelItems.Size.Width, labelName.Size.Width), Math.Max(panelItems.Size.Height, labelName.Size.Height));
      //this.MaximumSize = new Size(Math.Max(panelItems.Size.Width + 6, labelName.Size.Width + 6), Math.Max(panelItems.Size.Height + 26, labelName.Size.Height + 26));

    }

    void lab_MouseDoubleClick(object sender, MouseEventArgs e) {
      Label lbl = (Label)sender;

      if (lbl.Name.StartsWith("get")) {
        DialogResult drslt = MessageBox.Show("создать комплексный объект?", "inv_complex_" + lbl.Name.Substring(4), MessageBoxButtons.YesNoCancel);
        if (drslt == DialogResult.Yes) {
          FormRef.PrgCreation(null, "complex_" + lbl.Name.Substring(4),"");
          return;
        }
      }

      RichTextBox rtb = new RichTextBox();
      string s = HintToolTipLogicText[lbl.Name];
      System.IO.StreamWriter sw = new System.IO.StreamWriter("temp_progress_functions.lua",false);
      sw.Write(s);

      sw.Close();
      System.Diagnostics.Process.Start("notepad++.exe", "temp_progress_functions.lua");
    }

    string prg_creation_before = "";
    void lab_MouseDown(object sender, MouseEventArgs e) {
      if (e.Button == System.Windows.Forms.MouseButtons.Right) {
        Label nm = (Label)sender;
        prg_creation_before = nm.Text;
        MenuStrip();
      }
    }

    public void SetHintColor(Label lab, string name) {
      name = name.Substring(0,name.IndexOf("_"));
      if (name == "win") {
        ColorSeted = ColorWin;
        lab.BackColor = ColorWin;
      }
      else if (name == "get") {
        ColorSeted = ColorGet;
        lab.BackColor = ColorGet;
      }
      else if (name == "use") {
        ColorSeted = ColorUse;
        lab.BackColor = ColorUse;
      }
      else if (name == "clk") {
        ColorSeted = ColorClk;
        lab.BackColor = ColorClk;
      }
      else {
        ColorSeted = ColorDef;
        lab.BackColor = ColorDef;
      }
      //lab.BackColor = Color.FromArgb(0, 0, 0, 0);
    }

    public void lab_MouseLeave(object sender, EventArgs e) {
      List<MyControl> ac = FormRef.GetAllControls();
      for (int i = 0; i < ac.Count; i++) {
        Panel panel = ac[i].panelItems;
        List<Control> labels = new List<Control>();
        GetAllTypedControls(panel, labels, typeof(Label));
        foreach (Label lab in labels) {
          Label sndr = (Label)sender;
          string s1 = sndr.Name;
          s1 = s1.Substring(s1.IndexOf("_") + 1);
          if (s1.IndexOf("_") > -1)
            s1 = s1.Substring(0, s1.IndexOf("_"));
          s1 = RemoveDigit(s1);
          string s2 = lab.Name;
          s2 = s2.Substring(s2.IndexOf("_") + 1);
          if (s2.IndexOf("_") > -1)
            s2 = s2.Substring(0, s2.IndexOf("_"));
          s2 = RemoveDigit(s2);
          if (s1 == s2) {
            Color clr = lab.BackColor;
            //lab.BackColor = Color.FromArgb(clr.R + 100, clr.G + 100, clr.B + 100);
            SetHintColor(lab, lab.Name);
            lab.ForeColor = Color.Black;
            //lab.BorderStyle = System.Windows.Forms.BorderStyle.None;
          }
        }
      }
    }

    string RemoveDigit(string s) {
      var res = s.ToCharArray().Where(n => !char.IsDigit(n)).ToArray();
      return new string(res);
    }

    public void lab_MouseEnter(object sender, EventArgs e) {
      List<MyControl> ac = FormRef.GetAllControls();
      for (int i = 0; i < ac.Count; i++) {
        Panel panel = ac[i].panelItems;
        List<Control> labels = new List<Control>();
        GetAllTypedControls(panel, labels, typeof(Label));
        foreach (Label lab in labels) {
          Label sndr = (Label)sender;
          string s1 = sndr.Name;
          s1 = s1.Substring(s1.IndexOf("_") + 1);
          if(s1.IndexOf("_")>-1)
            s1 = s1.Substring(0,s1.IndexOf("_"));
          s1 = RemoveDigit(s1);
          string s2 = lab.Name;
          s2 = s2.Substring(s2.IndexOf("_") + 1);
          if (s2.IndexOf("_") > -1)
            s2 = s2.Substring(0, s2.IndexOf("_"));
          s2 = RemoveDigit(s2);
          if (s1 == s2) {
            Color clr = lab.BackColor;
            lab.BackColor = Color.Black;
            lab.ForeColor = Color.White;
            //lab.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
          }
        }
      }
    }

    void GetAllTypedControls( Control ctrl, List<Control> controls, Type type) {
      // Работаем только с элементами искомого типа
      if (ctrl.GetType() == type) {
        controls.Add(ctrl);
      }
      // Проходим через элементы рекурсивно,
      // чтобы не пропустить элементы,
      //которые находятся в контейнерах
      foreach (Control ctrlChild in ctrl.Controls) {
        GetAllTypedControls(ctrlChild, controls, type);
      }
    }

    private void MyControl_DoubleClick(object sender, EventArgs e) {
      FormRef.GetCreatedControls();
      FormRef.CheckProjectResources(this);
    }

    public bool IsHaveLink(string control_name) {
      if (childs != null) {
        for (int c = 0; c < childs.Count; c++) {
          if (childs[c].GetName() == control_name)
            return true;
        }
      }
      if (ownerControl != null && ownerControl.GetName() == control_name)
        return true;
      return false;
    }

    public void Destroy() {
      FormRef.allControls.Remove(this);
      this.Dispose();
    }

    private void MyControl_MouseEnter(object sender, EventArgs e) {
      highLightLabel(sender, e);
    }

    void highLightLabel(object sender, EventArgs e) {
      this.labelName.BackColor = Color.Yellow;
      for (int i = 0; i < childs.Count; i++) {
        if (!childs[i].name.StartsWith("rm_")) {
          childs[i].labelName.BackColor = Color.Yellow;
        }
      }
    }
    void downLightLabel(object sender, EventArgs e) {
      this.labelName.BackColor = Color.LemonChiffon;
      for (int i = 0; i < childs.Count; i++) {
        if (!childs[i].name.StartsWith("rm_")) {
          childs[i].labelName.BackColor = Color.LemonChiffon;
        }
      }
    }

    private void MyControl_MouseLeave(object sender, EventArgs e) {
      downLightLabel(sender, e);
    }

    private void addCheck_Click(object sender, System.EventArgs e) {
      FormRef.GetCreatedControls();
      FormRef.CheckProjectResources(this);
    }

    //public void ReAtachObj(string objName)
    //{
    //    List<MyObjClass> ao = GetAllObjs();
    //    for (int i = 0; i < ao.Count; i++)
    //    {
    //        if (ao[i].GetName() == objName)
    //        {
    //            MyObjClass obj = ao[i];
    //            MyObjClass own = obj.Parent;
    //            break;
    //        }
    //    }
    //}

    public string GetDefResName() {
      string s = FormRef.LevelDir + "\\";
      s = s.Substring(s.LastIndexOf("\\assets")+1);
      if (this.name.StartsWith( "zz_")) {
        if (ownerControl == null) {
          s += "inv_deploy\\";
          s += this.GetName();
        }
        else if (ownerControl.getNamePrefix()=="zz") {
          s += ownerControl.ownerControl.GetName() + "\\";
          s += this.GetName();
        }
        else {
          s += ownerControl.GetName() + "\\";
          s += this.GetName();
        }
      }
      else if (this.name.StartsWith("inv_")) {
        if (ownerControl == null) {
          s += "inv_deploy\\";
          s += this.GetName();
        }
        else {
          s += ownerControl.GetName() + "\\";
          s += this.GetName();
        }
      }
      else {
        s += this.GetName();
      }
      //if (this.type == "spr")
      //{
      //    s += ownerControl.GetName() + "\\";
      //    s += this.GetName();
      //}
      //else
      //{
      //    if (ownerControl == null)
      //    {
      //        Debag(name);
      //        s += "inv_deploy\\";
      //        s += this.GetName();
      //    }
      //    else
      //    {
      //        s += this.GetName();
      //    }
      //}
      return s+"\\";
    }

    public void sizeMin() {
      labelName.Font = new Font("Microsoft Sans Serif", 5);
      foreach (KeyValuePair<string, Label> kvp in HintLabel) {
        kvp.Value.Font = new Font("Microsoft Sans Serif", 4);
        kvp.Value.Location = new Point(kvp.Value.Location.X / 2, kvp.Value.Location.Y / 2);
      }
      Location = new Point(Location.X / 2, Location.Y / 2);
    }

    public void sizeMax() {
      labelName.Font = new Font("Microsoft Sans Serif", 11);
      foreach (KeyValuePair<string, Label> kvp in HintLabel) {
        kvp.Value.Font = new Font("Microsoft Sans Serif", 8);
        kvp.Value.Location = new Point(kvp.Value.Location.X * 2, kvp.Value.Location.Y * 2);
      }
      Location = new Point(Location.X * 2, Location.Y * 2);
    }

    private void addSFXToolStripMenuItem_Click(object sender, EventArgs e) {
      tbInit( "aud_", prg_creation_before);
    }

    private void addXXsfxToolStripMenuItem_Click(object sender, EventArgs e) {
      tbInit("aud_", "XX_"+prg_creation_before);
    }

    public List<MyControl> GetRoomsInChilds() {
      return GetRoomsInChilds(false, null);
    }

    public List<MyControl> GetRoomsInChilds( bool deep) {
      return GetRoomsInChilds(deep, null);
    }

    private List<MyControl> GetRoomsInChilds(bool deep, List<MyControl> answer) {
      if(answer==null) {
        answer = new List<MyControl>();
      }
      foreach (var v in childs) {
        if (v.getNamePrefix() == "rm") {
          answer.Add(v);
        }
      }
      if (deep) {
        foreach (var v in childs) {
          if (v.getNamePrefix() == "rm") {
            v.GetRoomsInChilds(deep, answer);
          }
        }
      }
      return answer;
    }
  }
}

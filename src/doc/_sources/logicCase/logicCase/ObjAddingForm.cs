using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Diagnostics;

using ClassCase;

namespace logicCase {
  public partial class ObjAddingForm : Form {
    Form1 Form;
    MyControl MC;
    Dictionary<string, Propobj> Objs;
    bool outRoot = false;

    Dictionary<string, CheckBox> Create = new Dictionary<string, CheckBox>();
    Dictionary<string, CheckBox> Ignored = new Dictionary<string, CheckBox>();
    Dictionary<string, CheckBox> InAnim = new Dictionary<string, CheckBox>();
    Dictionary<string, CheckBox> InFx = new Dictionary<string, CheckBox>();
    Dictionary<string, CheckBox> InObj = new Dictionary<string, CheckBox>();

    Dictionary<string, ComboBox> Position = new Dictionary<string, ComboBox>();
    Dictionary<string, Label> Res = new Dictionary<string, Label>();
    Dictionary<string, Label> Nom = new Dictionary<string, Label>();
    Dictionary<string, TextBox> Textbox = new Dictionary<string, TextBox>();

    GameResChecker checker;

    private PropObj xmlObj;

    private const int WM_HSCROLL = 0x114;
    private const int WM_VSCROLL = 0x115;
    private const int WM_MOUSEWHEEL = 0x20A;

    public ObjAddingForm(Form1 form, MyControl mc, Dictionary<string, Propobj> objs) {
      Form = form;
      Objs = objs;
      //MessageBox.Show("ObjAddingForm "+Form.ARG_STR["creation_only_inside_folder"]);

      Dictionary<string, Propobj> _objs = new Dictionary<string, Propobj>();
      if (Form.ARG_STR.ContainsKey("creation_only_inside_folder")
          && Form.ARG_STR["creation_only_inside_folder"].Length > 3 ) {
        //MessageBox.Show(Form.ARG_STR["creation_only_inside_folder"]);
        foreach (KeyValuePair<string, Propobj> kvp in Objs) {
          string _obj_name = Form.ARG_STR["creation_only_inside_folder"].Replace("\\","") + "\\" + kvp.Key;
          _objs[_obj_name] = kvp.Value;
        }
        Objs = _objs;
      }

      MC = mc;
      InitializeComponent();
      this.Location = new Point(Cursor.Position.X, Cursor.Position.Y);
      this.Text = Application.StartupPath;
      //MessageBox.Show(Application.StartupPath);

    }

    private void UpdatePictureBoxLocation() {
      //pictureBox1.Location = new Point(pictureBox1.Location.X, 15);
    }

    protected override void OnMouseWheel(MouseEventArgs e) {
      base.OnMouseWheel(e);
      UpdatePictureBoxLocation();
    }

    protected override void WndProc(ref Message m) {
      base.WndProc(ref m);
      if (m.Msg == WM_VSCROLL || m.Msg == WM_HSCROLL || m.Msg == WM_MOUSEWHEEL) {
        UpdatePictureBoxLocation();
      }
    }

    protected override void OnScroll(ScrollEventArgs se) {
      base.OnScroll(se);
      UpdatePictureBoxLocation();
    }

    private int _wxMAX = 0;
    private void ObjAddingForm_Load(object sender, EventArgs e) {
      checker = new GameResChecker(Form.LogicCaseSettings);


      Stopwatch sWatch = new Stopwatch();
      //this.Visible = false;

      this.Width = 175;
      this.Height = 15;
      this.AutoScroll = false;
      this.Visible = true;

      bool haveWarnings = false;
      bool haveNotice = false;

      int COUNT = Objs.Count;

      int count = -1;
      int h = 20;
      Color clr_yes = Color.LightSeaGreen;
      int wwx = 0;
      int positionWX = 0;
      int bw = 2;

      Dictionary<string, Color> FileColors = new Dictionary<string, Color>();
      FileColors["png"] = Color.White;
      FileColors["jpg"] = Color.White;
      FileColors["ogg"] = Color.Pink;
      FileColors["xml"] = Color.LimeGreen;
      FileColors["anm"] = Color.Green;
      FileColors["fx"] = Color.Blue;

      FileColors["WARNING"] = Color.Red;
      FileColors["NOTICE"] = Color.Yellow;

      FileColors["other"] = Color.Gray;

      labelFX.BackColor = FileColors["fx"];
      labelFX.ForeColor = Color.White;
      labelANM.BackColor = FileColors["anm"];
      labelANM.ForeColor = Color.White;
      labelOGG.BackColor = FileColors["ogg"];
      labelOGG.ForeColor = Color.White;

      //sWatch.Start();
      foreach (KeyValuePair<string, Propobj> kvp in Objs) {

        string filePath = Form.LevelDir + "\\" + MC.GetDefResName().Replace("assets\\levels\\" + Form.LevelName + "\\",
                          "") + "\\" + kvp.Key;
        filePath = filePath.Replace("\\\\", "\\");
        checker.ResAdd(filePath);

        count++;
        int wx = 0;
        Propobj o = kvp.Value;
        this.Text = 100 * count / COUNT + "%";

        Label nom = new Label();
        nom.Width = 25;
        nom.Height = h - bw;
        nom.Text = count.ToString();
        nom.Location = new Point(wx, h * count);
        //nom.DoubleClick +=
        wx = nom.Width + bw;
        nom.Parent = this;
        try {
          //MessageBox.Show(kvp.Key.Substring(kvp.Key.IndexOf(".") + 1));
          nom.BackColor = FileColors[kvp.Key.Substring(kvp.Key.IndexOf(".") + 1)];
        }
        catch {
          //MessageBox.Show(kvp.Key.Substring(kvp.Key.IndexOf(".") + 1));
          nom.BackColor = FileColors["other"];
        }
        Nom[kvp.Key] = nom;

        if (checker.isResHaveMessage(filePath)) {
          if (checker.isResHaveWarnings(filePath)) {
            haveWarnings = true;
          }
          else {
            haveNotice = true;
          }

          nom.DoubleClick += (nom_sender, args) => {
            MessageBox.Show(checker.GetResMessage(filePath));
          };
        }

        TextBox textBox = new TextBox();
        textBox.Width = 200;
        textBox.Height = h - bw;
        textBox.Text = kvp.Key;
        textBox.Location = new Point(wx, h * count);
        wx += 200 + bw;
        textBox.Parent = this;
        textBox.BackColor = Color.White;
        textBox.ReadOnly = true;
        textBox.MouseDown += textBox_MouseDown;
        textBox.DoubleClick += textBox_DoubleClick;
        Textbox[kvp.Key] = textBox;



        //string s = kvp.Key+" \t ";
        //s += "in_obj=" + o.Propertie("in_obj") + " \t ";
        //s += "in_anim=" + o.Propertie("in_anim") + " \t ";
        //s += "in_fx=" + o.Propertie("in_fx") + " \t ";
        //s += "ignored=" + o.Propertie("ignored") + " \t ";
        //s += "res=" + o.Propertie("res") + " \t ";
        //s += "position=" + o.Propertie("position") + " \t ";
        //Form.Debag(s);

        CheckBox create = new CheckBox();
        create.MouseUp += CheckBox_MouseUp;
        create.Size = new System.Drawing.Size(75, h - bw);
        //create.AutoSize = true;
        create.Location = new Point(wx, h * count);
        create.Enabled = true;
        create.Parent = this;
        create.Text = "create";
        wx += create.Width + bw;
        create.BackColor = Color.White;
        Create[kvp.Key] = create;

        CheckBox ignored = new CheckBox();
        ignored.MouseUp += CheckBox_MouseUp;
        ignored.Size = new System.Drawing.Size(75, h - bw);
        //ignored.AutoSize = true;
        ignored.Checked = o.Propertie("ignored") == "0" ? false : true;
        ignored.Location = new Point(wx, h * count);
        ignored.Enabled = true;
        ignored.Parent = this;
        ignored.Text = "ignored";
        wx += ignored.Width + bw;
        ignored.BackColor = Color.White;
        Ignored[kvp.Key] = ignored;

        CheckBox in_obj = new CheckBox();
        in_obj.Size = new System.Drawing.Size(75, h - bw);
        //in_obj.AutoSize = true;
        in_obj.Checked = o.Propertie("in_obj") == "0" ? false : true;
        in_obj.Location = new Point(wx, h * count);
        in_obj.Enabled = false;
        in_obj.Parent = this;
        in_obj.Text = "in_obj";
        wx += in_obj.Width + bw;
        in_obj.BackColor = o.Propertie("in_obj") == "0" ? Color.White : clr_yes;
        InObj[kvp.Key] = in_obj;

        CheckBox in_anim = new CheckBox();
        in_anim.Size = new System.Drawing.Size(75, h - bw);
        //in_anim.AutoSize = true;
        in_anim.Checked = o.Propertie("in_anim") == "0" ? false : true;
        in_anim.Location = new Point(wx, h * count);
        in_anim.Enabled = false;
        in_anim.Parent = this;
        in_anim.Text = "in_anim";
        wx += in_anim.Width + bw;
        in_anim.BackColor = o.Propertie("in_anim") == "0" ? Color.White : clr_yes;
        InAnim[kvp.Key] = in_anim;



        CheckBox in_fx = new CheckBox();
        in_fx.Size = new System.Drawing.Size(75, h - bw);
        //in_fx.AutoSize = true;
        in_fx.Checked = o.Propertie("in_fx") == "0" ? false : true;
        in_fx.Location = new Point(wx, h * count);
        in_fx.Parent = this;
        in_fx.Enabled = false;
        in_fx.Text = "in_fx";
        wx += in_fx.Width + bw;
        in_fx.BackColor = o.Propertie("in_fx") == "0" ? Color.White : clr_yes;
        InFx[kvp.Key] = in_fx;

        ComboBox position = new ComboBox();
        string s = "";
        s = o.Propertie("position");

        position.Select(0, 0);
        position.SelectedIndexChanged += select_relase;
        position.SelectionChangeCommitted += select_relase;
        position.SelectedValueChanged += select_relase;

        //try
        //{

        if (textBox.Text.IndexOf(".xml") > -1) {
          in_fx.BackColor = Color.White;
          in_fx.Checked = false;

          string xmlAdr = Form.LevelDir + "\\" + MC.GetDefResName().Replace("assets\\levels\\" + Form.LevelName + "\\",
                          "") + "\\" + textBox.Text;
          xmlAdr = xmlAdr.Replace("\\\\","\\");
          //MessageBox.Show(xmlAdr);
          List<string> funcs = Form.LoadXML(xmlAdr);
          Form.xmlReload(funcs);


          if (Form.FindId(funcs, "<animation") > -1) {

            position.BackColor = Color.Yellow;
            funcs = getFuncs(funcs);

            bool selected = false;
            for (int z = 0; z < funcs.Count; z++) {
              position.Items.Add(funcs[z]);
              if (in_obj.Checked && Form.GetObj(o.Propertie("in_obj")).GetPropertie("animfunc") == funcs[z]) {
                position.SelectedIndex = z;
                selected = true;
              }
            }
            if(!selected && funcs.Count>0)
              position.SelectedIndex = 0;


            nom.BackColor = FileColors["anm"];


          }
          else {

            nom.BackColor = FileColors["fx"];

          }

          if (position.Items.Count < 1)
            position.Enabled = false;
        }
        else {

          while (s.IndexOf(";") > -1) {

            string buf = s.Substring(0, s.IndexOf(";"));

            s = s.Substring(s.IndexOf(";") + 1);
            buf = buf.Substring(buf.LastIndexOf("\\") + 1);

            position.Items.Add(buf);
            position.SelectedIndex = position.Items.Count - 1;
          }
          position.BackColor = Color.White;

          if (position.Items.Count < 2)
            position.Enabled = false;

        }
        //}
        //catch
        //{
        //    position.Text = "CATCH *" + s + "*";
        //}



        //position.AutoSize = true;
        position.Location = new Point(wx, h * count);
        position.Size = new System.Drawing.Size(ComboWidth(position), h - bw);
        //position.Width = ComboWidth(position);
        position.Parent = this;

        //positionWX = Math.Max(position.Width, positionWX);

        if (positionWX < position.Width) {
          positionWX = position.Width;

        }

        wx += positionWX + bw;

        Position[kvp.Key] = position;

        Label res = new Label();
        //res.Parent = this;
        //res.AutoSize = true;
        //res.Text = o.Propertie("res");
        //res.Location = new Point(wx, h * count);
        //wx += res.Width + bw;

        ////nom.Text = wx.ToString();

        //res.BackColor = Color.White;
        Res[kvp.Key] = res;


        create.Checked = !ignored.Checked && (!in_anim.Checked && !in_fx.Checked && !in_obj.Checked);
        create.Enabled = !in_obj.Checked;
        if (in_obj.Checked)
          create.BackColor = Color.LightGray;
        if (create.Checked)
          textBox.BackColor = Color.Orange;
        Console.WriteLine(o.Propertie("name"));

        if (o.Propertie("in_obj").StartsWith("anm_")
            && Form.GetObj("anm_"+MC.getNamePost() + "_" + o.Propertie("name").Substring(0,
                           o.Propertie("name").IndexOf("."))) == null) {
          create.Enabled = true;
          create.Checked = false;
        }


        if (in_obj.Checked)
          ignored.BackColor = Color.LightGray;
        if (in_anim.Checked || in_fx.Checked || in_obj.Checked) {
          ignored.BackColor = Color.LightGray;
          ignored.Enabled = false;
        }
        else if (ignored.Checked)
          ignored.BackColor = clr_yes;

        wwx = Math.Max(wwx, wx);


        //if (!haveWarnings)
        //{
        //    if (in_anim.Checked)
        //        nom.BackColor = FileColors["anm"];
        //    if (in_fx.Checked)
        //        nom.BackColor = FileColors["fx"];
        //}
        //Form.Debag(kvp.Key);ImageWeightMaxDif

        //if (textBox.Text.IndexOf(".") > -1)
        //{
        //    textBox.Text = textBox.Text.Substring(0, textBox.Text.IndexOf("."));
        //}

        if (checker.isResHaveMessage(filePath)) {
          if (checker.isResHaveWarnings(filePath)) {
            nom.BackColor = FileColors["WARNING"];
          }
          else {
            nom.BackColor = FileColors["NOTICE"];
          }
        }
      }

      foreach (KeyValuePair<string, ComboBox> lbls in Position) {
        lbls.Value.Width = positionWX;
        select_relase(lbls.Value, null);

        Res[lbls.Key].Location = new Point(lbls.Value.Location.X + positionWX + bw, lbls.Value.Location.Y);
        //Res[lbls.Key].AutoSize = true;

      }


      if (count < 10) {
        count = 10;
      }

      this.Text = Application.StartupPath + " >>> " + MC.GetName();
      this.Width = wwx + 225;
      this.Height = h * (count + 5);

      this.AutoScroll = true;

      pictureBox1.Location = new Point(wwx, 10);
      pictureBox1.Size = new Size(200, this.Height - 80);

      this.Visible = true;

      Form.BringToFront();
      this.TopMost = true;
      this.BringToFront();
      this.TopMost = false; ;

      panel1.Location = new Point(0, h * (count +1 ));

      //MessageBox.Show(checker.MessageGet());

      buttonWarnings.Enabled = checker.IsHaveMessages();
      if(haveWarnings) {
        buttonWarnings .BackColor = FileColors["WARNING"];

      }
      else if (haveNotice) {
        buttonWarnings.BackColor = FileColors["NOTICE"];

      }
    }

    private void CheckBox_MouseUp(object sender, MouseEventArgs e) {
      if (e.Button == MouseButtons.Middle) {
        CheckBox checkBox = (CheckBox)sender;

        bool check = !checkBox.Checked;
        if (checkBox.Text == "create") {
          foreach (KeyValuePair<string, CheckBox> kvp in Create) {
            if(kvp.Value.Enabled)
              kvp.Value.Checked = check;
          }
        }
        else if (checkBox.Text == "ignored") {
          foreach (KeyValuePair<string, CheckBox> kvp in Ignored) {
            if (kvp.Value.Enabled)
              kvp.Value.Checked = check;
          }
        }

      }
    }

    void textBox_DoubleClick(object sender, EventArgs e) {
      TextBox tb = (TextBox)sender;
      //showRes(tb.Text);

      string file_adr = Form.LevelDir + "\\" + MC.GetDefResName().Replace("assets\\levels\\" + Form.LevelName + "\\",
                        "") + tb.Text;

      if (tb.Text.EndsWith(".png") || tb.Text.EndsWith(".jpg")) {
        System.Diagnostics.Process.Start(
          Environment.GetEnvironmentVariable("windir") + @"\System32\rundll32.exe",
          Environment.GetEnvironmentVariable("windir") + @"\System32\shimgvw.dll,ImageView_Fullscreen " + file_adr);
      }
      else {
        Process p = new Process();
        ProcessStartInfo psi = new ProcessStartInfo();
        psi.FileName = Application.ExecutablePath;
        psi.Arguments = file_adr;
        p.StartInfo = psi;
        p.Start();
      }
    }

    void textBox_MouseDown(object sender, MouseEventArgs e) {
      TextBox tb = (TextBox)sender;
      showRes(tb.Text);
    }

    void select_relase(object sender, EventArgs e) {
      ComboBox tb = (ComboBox)sender;
      tb.Select(0, 0);
    }

    Bitmap bm;
    void showRes(string name) {
      try {
        string res = Objs[name].Propertie("res");
        res = res.Substring(0, res.LastIndexOf("\\"));
        res = Form.repDir + "exe\\" + res + "\\" + name;
        bm = new Bitmap(res);
        pictureBox1.SizeMode = PictureBoxSizeMode.Zoom;
        pictureBox1.Image = bm;
        //bm.Dispose();
      }
      catch {
        pictureBox1.Image = null;
      }
    }



    void CreateObjs(bool to_root) {

      Dictionary<MyObjClass, int> SprByPositionPower = new Dictionary<MyObjClass, int>();

      bool created = false;
      MyObjClass AddingObj;
      if (to_root) {
        AddingObj = Form.GetObj("obj_" + MC.getNamePost() + "_logic_case_creator_root");
        if (AddingObj == null) {
          List<string> xml = Form.LoadXML("res\\objs\\obj.xml");
          Form.xmlReplace(xml, "##zrm##", MC.getNamePost());
          Form.xmlReplace(xml, "##nm##", "logic_case_creator_root");
          AddingObj = new MyObjClass(xml, 0, MC.GetOwnerObj().GetModule());
          MC.GetOwnerObj().objAdd(AddingObj);
        }

      }
      else if (!outRoot) {
        AddingObj = MC.GetOwnerObj();

      }
      else {
        AddingObj = MC.GetOwnerObj().GetModule().GetObjs()[0];
      }
      int count = 0;
      int count_max = Objs.Count;

      #region TagedObjs
      HashSet<string> tagedObj = new HashSet<string>();
      foreach (KeyValuePair<string, Propobj> kvp in Objs) {
        if (kvp.Key.IndexOf(".xml") > -1) {
          string xmlAdr = Form.LevelDir + "\\" + MC.GetDefResName().Replace("assets\\levels\\" + Form.LevelName + "\\",
                          "") + "\\" + kvp.Key;
          xmlAdr = xmlAdr.Replace("\\\\", "\\");
          List<string> xml = Form.LoadXML(xmlAdr);
          xmlObj = new PropObj(xml, null);
          if (xmlObj.Valid && xmlObj._objType == "animation") {
            var objs = xmlObj.GetChild("objs");
            var objsWithAnimtag = objs.GetChilds("obj", "anim_tag", true);
            foreach (var v in objsWithAnimtag) {
              var tag = v.GetPropertie("anim_tag");
              if (tagedObj.Contains(tag)) continue;
              tagedObj.Add(tag);
            }
          }
          //else {
          //  MessageBox.Show(xmlAdr + "\n" + xmlObj.ErrorMessage);
          //}
        }
      }
      #endregion

      foreach (KeyValuePair<string, Propobj> kvp in Objs) {
        count++;
        //Form.ARG_STR["creation_only_inside_folder"]
        //kvp.Key.Replace(".xml", "").Replace("\\","_"))
        //string ObjName = kvp.Key.Replace(".xml", "");


        this.Text = kvp.Value.Propertie("res") + "\t" + (count / count_max);
        bool bb;
        if (Ignored[kvp.Key].Checked) {
          Form.loadedIgnore[kvp.Value.Propertie("res")] = new Propobj("\t<ignore _name=\"" + kvp.Value.Propertie("res") + "\"/>");
          Form.loadedIgnoreBool[kvp.Value.Propertie("res")] = true;
          continue;
        }
        else if (Form.loadedIgnoreBool.TryGetValue(kvp.Value.Propertie("res"), out bb)) {
          Form.loadedIgnoreBool[kvp.Value.Propertie("res")] = false;
        }

        if (!Create[kvp.Key].Checked)
          continue;



        //Debag(fl[f]);
        bool finded = false;
        string on = "";
        Propobj o = kvp.Value;

        string tf = o.Propertie("res");
        string nf = kvp.Key;
        if (kvp.Key.IndexOf(".") > -1) {
          //tf = fassets[f];
        }
        tf = tf.Replace("\\", "/");

        if (!finded) {

          if (kvp.Key.IndexOf(".xml") > -1) {
            string xmlAdr = Form.LevelDir + "\\" + MC.GetDefResName().Replace("assets\\levels\\" + Form.LevelName + "\\",
                            "") + "\\" + kvp.Key;
            xmlAdr = xmlAdr.Replace("\\\\", "\\");
            List<string> xml = Form.LoadXML(xmlAdr);
            Form.xmlReload(xml);
            if (Form.FindId(xml, "<animation") > -1) {

              string met = "<func name=\"";
              string animfunc = xml[Form.FindId(xml, met)];
              animfunc = animfunc.Substring(animfunc.IndexOf(met) + met.Length);
              animfunc = animfunc.Substring(0, animfunc.IndexOf("\""));

              if (Position[kvp.Key].SelectedIndex > -1)
                animfunc = Position[kvp.Key].Items[Position[kvp.Key].SelectedIndex].ToString();

              //string s = "";
              //s += "\n" + kvp.Key;
              //s += "\n" + Position[kvp.Key].SelectedIndex;
              //s += "\n" + Position[kvp.Key].Items[Position[kvp.Key].SelectedIndex];
              //MessageBox.Show(s);

              List<string> anm = Form.LoadXML("res\\objs\\complexanim.xml");
              Form.xmlReplace(anm, "##zrm##", MC.getNamePost());
              Form.xmlReplace(anm, "##nm##", kvp.Key.Replace(".xml", "").Replace("anims\\", "").Replace("\\", "_"));
              Form.xmlReplace(anm, "##fnm##", kvp.Key.Replace(".xml", ""));
              Form.xmlReplace(anm, "##res##", o.Propertie("res"));


              MyObjClass mo = new MyObjClass(anm, 0, AddingObj.ownerModule);
              //mo.SetPropertie("res", o.Propertie("res"));
              mo.SetPropertie("animfunc", animfunc);


              if (MC.getNamePrefix() != "zz" && MC.getNamePrefix() != "inv")
                mo.SetPropertie("pos_x", "-171");

              AddingObj.objAdd(mo);

              Form.Debag("\tсоздана анимация - " + mo.GetName());
              Form.Debag("\tфункция анимации animfunc = " + animfunc);
              created = true;


              xmlObj = new PropObj(xml, null);
              if (xmlObj.Valid && xmlObj._objType == "animation") {
                var objs = xmlObj.GetChild("objs");
                var objsWithAnimtag = objs.GetChilds("obj", "anim_tag", true);
                var animtagsAdded = new HashSet<string>();
                foreach (var v in objsWithAnimtag) {
                  var tag = v.GetPropertie("anim_tag");
                  if (animtagsAdded.Contains(tag)) continue;
                  animtagsAdded.Add(tag);
                }

                if (animtagsAdded.Count > 0) {

                  if (MessageBox.Show(
                        $"в анимации {mo.GetName()} присутствуют анимтаги, создать объекты с анимтагом?",
                        "anim_tag", MessageBoxButtons.YesNo)
                      == DialogResult.Yes) {
                    foreach (var v in animtagsAdded) {

                      var objForTag = Form.GetObj("obj_" + MC.getNamePost() + "_" + v);



                      //mo.objAdd(tagObj);

                      var sprForTag = Form.GetObj("spr_" + MC.getNamePost() + "_" + v);
                      if (sprForTag != null) {
                        if (MessageBox.Show(
                              $"найден объект {sprForTag.GetName()} возможо связанный с анимтагом {v}, создать оbj в анимации {mo.GetName()} и переместить в него?",
                              "anim_tag", MessageBoxButtons.YesNo)
                            == DialogResult.Yes) {
                          sprForTag.Parent.objs.Remove(sprForTag);

                          List<string> obj = Form.LoadXML("res\\objs\\obj.xml");
                          Form.xmlReplace(obj, "##zrm##", MC.getNamePost());
                          Form.xmlReplace(obj, "##nm##", v);
                          MyObjClass tagObj = new MyObjClass(obj, 0, AddingObj.ownerModule);
                          tagObj.SetPropertie("anim_tag", v);
                          tagObj.SetPropertie("input", "1");


                          tagObj.objAdd(sprForTag);
                          mo.objAdd(tagObj);
                          mo.SetPropertie("input", "1");
                          sprForTag.ReAtach();

                          sprForTag.SetPropertie("pos_x", "0");
                          sprForTag.SetPropertie("pos_y", "0");
                          sprForTag.SetPropertie("visible", "1");

                        }
                      }
                      else {
                        var funcs = xmlObj.GetChild("funcs");
                        var tagedFunc = funcs.GetChild("func", "name", v, false);
                        string tagedRes = MC.GetDefResName() + v;

                        if ( mo.GetPropertie("res").Contains(@"\anims\") )
                        {
                            tagedRes = MC.GetDefResName() + @"anims\" + v;
                        }

                        string tagedResFull = Form.exeDir + tagedRes;

                        var resExist = System.IO.File.Exists(tagedResFull + ".png") || System.IO.File.Exists(tagedResFull + ".jpg");
                        if (!resExist && tagedFunc != null &&
                            (MessageBox.Show(
                               $"создать АНИМАЦИЮ с анимтагом '{v}' и поместить в '{mo.GetName()}'?", "anim_tag",
                               MessageBoxButtons.YesNo)
                             == DialogResult.Yes)) {
                          List<string> obj = Form.LoadXML("res\\objs\\complexanim.xml");
                          Form.xmlReplace(obj, "##zrm##", MC.getNamePost());
                          Form.xmlReplace(obj, "##nm##", mo.GetName().Replace("anm_" + MC.getNamePost() + "_", "") + "_" + v);
                          Form.xmlReplace(obj, "##res##", mo.GetPropertie("res"));
                          MyObjClass tagObj = new MyObjClass(obj, 0, AddingObj.ownerModule);
                          tagObj.SetPropertie("anim_tag", v);
                          tagObj.SetPropertie("input", "1");
                          tagObj.SetPropertie("animfunc", v);

                          mo.objAdd(tagObj);
                          mo.SetPropertie("input", "1");
                          tagObj.ReAtach();
                        }
                        else if (resExist
                                 && MessageBox.Show(
                                   $"создать спрайт с анимтагом '{v}' и поместить в '{mo.GetName()}'?", "anim_tag",
                                   MessageBoxButtons.YesNo)
                                 == DialogResult.Yes) {
                          List<string> obj = Form.LoadXML("res\\objs\\spr.xml");
                          Form.xmlReplace(obj, "##zrm##", MC.getNamePost());
                          Form.xmlReplace(obj, "##nm##", v);
                          Form.xmlReplace(obj, "##res##", tagedRes);
                          MyObjClass tagObj = new MyObjClass(obj, 0, AddingObj.ownerModule);
                          tagObj.SetPropertie("anim_tag", v);
                          tagObj.SetPropertie("input", "1");
                          mo.objAdd(tagObj);
                          mo.SetPropertie("input", "1");
                          tagObj.ReAtach();
                        }
                        else if (!resExist) {
                          MessageBox.Show(
                            $"в анимации присутствует таг '{v}' ни к чему не относящийся: \n1) отсутствует функция с таким именем \n2) не найден спрайт с адресом '{tagedRes}'");
                        }
                      }
                    }
                  }
                }
              }
            }
            else if (Form.FindId(xml, "<ps type = \"jan\">") > -1 || xml[1].StartsWith("<ps type=")) {

              string resf = "";
              if (kvp.Key == "pm.xml"
                  || kvp.Key == "pfx.xml"
                  || kvp.Key.Replace(".xml", "").IndexOf("_pm") > -1
                  || kvp.Key.Replace(".xml", "").IndexOf("pm_") > -1
                  || kvp.Key.Replace(".xml", "").IndexOf("pfx_") > -1
                  || kvp.Key.Replace(".xml", "").IndexOf("_pfx") > -1
                 ) {
                resf = "_pm";
              }

              List<string> anm = Form.LoadXML("res\\objs\\partsys" + resf + ".xml");
              Form.xmlReplace(anm, "##zrm##", MC.getNamePost());
              Form.xmlReplace(anm, "##nm##", kvp.Key.Replace(".xml", "").Replace("\\", "_"));
              Form.xmlReplace(anm, "##fnm##", kvp.Key.Replace(".xml", ""));
              Form.xmlReplace(anm, "##res##", o.Propertie("res"));


              MyObjClass mo = new MyObjClass(anm, 0, AddingObj.ownerModule);
              //mo.SetPropertie("res", o.Propertie("res"));
              AddingObj.objAdd(mo);
              created = true;

            }

          }
          else {
            string txtDir = Form.LevelDir + "\\" + MC.GetDefResName().Replace("assets\\levels\\" + Form.LevelName + "\\", "");
            if(kvp.Key.IndexOf("\\")!=-1) {
              txtDir += kvp.Key.Substring(0,kvp.Key.IndexOf("\\"));
              //MessageBox.Show(txtDir);
            }
            txtDir = txtDir.Replace("\\layers", "").Replace("\\anims", "");

            string px = "0";
            string py = "0";
            int pp = 0;
            bool inPos = false;

            string[] txtFiles = System.IO.Directory.GetFiles(txtDir, "*.txt");
            //MessageBox.Show(txtFiles.Length.ToString());
            List<string> txtFL = Form.mStrToList(txtFiles);
            bool spr_created = false;
            //MessageBox.Show("txtDir " + txtDir);
            for (int txt = 0; txt < txtFL.Count & !spr_created; txt++) {
              //MessageBox.Show("2");
              if (txtFL[txt].IndexOf("position") > -1
                  //|| txtFL[txt].IndexOf("position.txt") >-1
                  //|| txtFL[txt].IndexOf("position_") >-1
                  //|| txtFL[txt].IndexOf("_position.txt") >-1
                 ) {
                List<string> posL = Form.LoadXML(txtFL[txt]);
                //MessageBox.Show("3");
                for (int p = posL.Count-1; p >= 0; p--) {
                  //MessageBox.Show("4");

                  string s = posL[p].Replace(",", "");
                  if (s.Length < 3)
                    continue;
                  string[] parcedLine = PositionParser.Parse(s);
                  string nm = parcedLine[0];
                  string txt_obj_name = PositionParser.ClearSubfoldersAndExtension(kvp.Key); //Substring(0, kvp.Key.IndexOf("."));
                  //if (txt_obj_name.IndexOf("\\")>-1) {
                  //  txt_obj_name = txt_obj_name.Substring(txt_obj_name.IndexOf("\\")+1);
                  //  //MessageBox.Show(txt_obj_name);
                  //}
                  ////Debag("p " + p + " txt " +txt + "   " + nm + "   " + fl[f].Substring(0, fl[f].IndexOf(".")));

                  //string replaceSubfolderName = "layers\\";

                  //if (!(parcedLine[3] == null || parcedLine[3] == "")) {
                  //  replaceSubfolderName = parcedLine[3].Replace("layers/", "") + "\\";
                  //}

                  //txt_obj_name = txt_obj_name.Replace(replaceSubfolderName, "").Replace("anims\\", "");
               
                  if (nm == txt_obj_name) {
                    px = parcedLine[1];
                    py = parcedLine[2];
                    pp = p;
                    inPos = true;

                    break;
                  }
                }
              }
            }

            {
              List<string> spr = Form.LoadXML("res\\objs\\spr.xml");
              if (kvp.Key.EndsWith(".ogg")) {
                spr = Form.LoadXML("res\\objs\\vid.xml");
              }
              string nm = kvp.Key.Substring(0, kvp.Key.IndexOf("."));

              string spr_name = PositionParser.ClearSubfoldersAndExtension(kvp.Key);
              //string spr_name = kvp.Key.Replace("layers\\", "").Replace("anims\\", "").Replace("\\", "_");
              //spr_name = spr_name.Substring(0, spr_name.IndexOf("."));

              Form.xmlReplace(spr, "##zrm##", MC.getNamePost());
              Form.xmlReplace(spr, "##nm##", spr_name);
              Form.xmlReplace(spr, "##res##", (MC.GetDefResName() + kvp.Key.Substring(0, kvp.Key.IndexOf("."))).Replace("\\", "/"));

              MyObjClass mon = new MyObjClass(spr, 0, AddingObj.ownerModule);
              mon.SetPropertie("pos_x", px);
              mon.SetPropertie("pos_y", py);
              AddingObj.objAdd(mon);

              if(inPos) {
                SprByPositionPower[mon] = pp;
              }

              Form.Debag("подключаем файл " + o.Propertie("res"));
              Form.Debag("     имя объекта -> " + mon.GetName());
              Form.Debag("     файл с позициеей для файла не найден");
              Form.Debag("     установлены значения pos_x=" + 0 + "; pos_y=" + 0);

              Console.WriteLine("подключаем файл " + o.Propertie("res"));
              Console.WriteLine("     имя объекта -> " + mon.GetName());
              Console.WriteLine("     файл с позициеей для файла не найден");
              Console.WriteLine("     установлены значения pos_x=" + 0 + "; pos_y=" + 0);
              Console.WriteLine("     установлены значения pos_x=" + 0 + "; pos_y=" + 0);

              created = true;
            }
          }
        }
        //else
        //{
        //    //if (fl[f].IndexOf(".ogg") == -1)
        //    //Debag("файл/объект не в своей директории " + on + "  ==>  " + fl[f]);
        //    fl.RemoveAt(f);
        //    fassets.RemoveAt(f);
        //    f--;
        //}
      }

      foreach (KeyValuePair<MyObjClass, int> my_obj in SprByPositionPower.OrderByDescending(key => key.Value)) {
        AddingObj.objAdd(my_obj.Key);
      }

      #region Создание стейтов для деплоя
      if (MC.getNamePrefix()=="inv") {
        var invName = MC.getNamePost().Replace("complex_", "");
        var invObj = Form.GetObj("inv_" + invName);
        string folderPath = Form.LevelDir + "\\" + MC.GetDefResName().Replace("assets\\levels\\" + Form.LevelName + "\\",
                            "") + "\\state";
        folderPath = folderPath.Replace("\\\\", "\\");
        if(System.IO.Directory.Exists(folderPath)) {
          var statesPaths = System.IO.Directory.GetFiles(folderPath);
          var asked = false;
          var needCreate = false;
          if (statesPaths.Length>0) {
            statesPaths = statesPaths.OrderBy((s) => s).ToArray();
            foreach (var path in statesPaths) {
              var fileName = path.Substring(path.LastIndexOf("\\")+1);
              fileName = fileName.Substring(0, fileName.IndexOf("."));
              var stateObjName = "inv_" + invName + "_" + fileName;
              var stateObj = Form.GetObj(stateObjName);
              if(stateObj==null) {
                if(!asked) {
                  asked = true;
                  needCreate = MessageBox.Show($"создать стейты для {invObj.GetName()}", "state",
                                               MessageBoxButtons.YesNo) == DialogResult.Yes;
                  if (!needCreate)
                    break;
                }
                if(needCreate) {
                  List<string> spr = Form.LoadXML("res\\objs\\spr.xml");
                  string nm = fileName;
                  string spr_name = stateObjName;
                  Form.xmlReplace(spr, "##zrm##", "xxx");
                  Form.xmlReplace(spr, "##nm##", "xxx");
                  Form.xmlReplace(spr, "spr_xxx_xxx", stateObjName);
                  var res = path.Substring(path.LastIndexOf("assets\\levels\\"));
                  res = res.Substring(0, res.IndexOf("."));
                  Form.xmlReplace(spr, "##res##", res);
                  MyObjClass mon = new MyObjClass(spr, 0, invObj.ownerModule);
                  mon.SetPropertie("input", "0");
                  mon.SetPropertie("visible", "0");
                  invObj.objAdd(mon);

                }
              }
            }
          }
        }
      }
      #endregion

      Form.TreeViewBuild();

      if (!created && to_root)
        AddingObj.Delete();


      if (Form.ARG_CMD["creation_only"]) {
        Form.SaveProject();
      }
    }

    private void ObjAddingForm_Resize(object sender, EventArgs e) {
      //this.Text = this.Width.ToString();
      //UpdatePictureBoxLocation();
    }

    private int ComboWidth(ComboBox myCombo) {
      int maxWidth = 0, temp = 0;
      foreach (var obj in myCombo.Items) {
        temp = TextRenderer.MeasureText(myCombo.GetItemText(obj), myCombo.Font).Width;
        if (temp > maxWidth) {
          maxWidth = temp;
        }
      }
      return maxWidth + SystemInformation.VerticalScrollBarWidth;
    }

    private List<string> getFuncs(List<string> anim) {
      List<string> funcs = new List<string>();

      int id = 0;
      id = Form.FindId(anim, "<func ");
      while (id > -1) {
        Propobj po = new Propobj(anim[id]);
        funcs.Add(po.Propertie("name"));
        id = Form.FindId(anim, "<func ",id+1);
      }


      return funcs;
    }

    private void ObjAddingForm_FormClosed(object sender, FormClosedEventArgs e) {
      if (Form.ARG_CMD["creation_only"]) {
        Form.Close();
        Form.Dispose();
      }
    }

    private void button1_Click(object sender, EventArgs e) {

      CreateObjs(false);
      this.Close();

    }

    private void button2_Click(object sender, EventArgs e) {
      CreateObjs(false);
      button3.Enabled = false;
      button2.Enabled = false;
      button1.Enabled = false;
    }

    private void button3_Click(object sender, EventArgs e) {
      CreateObjs(true);
      this.Close();
    }

    private void button4_Click(object sender, EventArgs e) {
      outRoot = true;
      CreateObjs(false);
      this.Close();
    }

    private void buttonWarnings_Click(object sender, EventArgs e) {
      MessageBox.Show( checker.MessageGet());
    }

    private void LogicCaseInfo_Click(object sender, EventArgs e) {
      Form.ShowInfoMessage();
    }

    private void ObjAddingForm_Scroll(object sender, ScrollEventArgs e) {
      //Console.WriteLine(e.OldValue + "; " + e.NewValue);
      UpdatePictureBoxLocation();
    }

    private void buttonTagger_Click(object sender, EventArgs e) {

    }
  }
}

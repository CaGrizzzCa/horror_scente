using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Text.RegularExpressions;

namespace logicCase {
  class Action:Propobj {
    int id;
    string id_local;
    public string IDlocal {
      get {
        return id_local;
      }
      set {
        id_local = value;
      }
    }

    bool isMulGetProj = false;
    public bool IsMulGetProj {
      get {
        return isMulGetProj;
      }
      set {
        isMulGetProj = value;
      }
    }
    int mulGetNumProj=0;
    public int
    MulGetNumProj { //{ get { return mulGetNumProj; } set { mulGetNumProj = value; if (value > 0)isMulGetProj = true; } }
      get {
        return mulGetNumProj;
      }
      set {
        mulGetNumProj = value;
        //form.Debag("\t\t\tmulGetNumProj seted to " + mulGetNumProj, System.Drawing.Color.Green);
        if (value == 0) {
          System.Windows.Forms.MessageBox.Show("попытка установить mulGetNumProj для " + this.objName + " " +
                                               this.ownerBlock.ObjName + " 0");
          isMulGetProj = false;
        }
        else if (!isMulUseProj) {
          //System.Windows.Forms.MessageBox.Show("попытка установить mulGetNumProj для " + this.objName + " " + this.ownerBlock.ObjName + " без присвоения isMulGetProj");
          //isMulGetProj = true;
        }
      }
    }

    bool isMulUseProj = false;
    public bool IsMulUseProj {
      get {
        return isMulUseProj;
      }
      set {
        isMulUseProj = value;
      }
    }
    string mulUseNameProj;
    public string MulUseNameProj {
      get {
        return mulUseNameProj;
      }
      set {
        mulUseNameProj = value;
        if (value.Length == 0) {
          System.Windows.Forms.MessageBox.Show("попытка установить mulUseNameProj для " + this.objName + " " +
                                               this.ownerBlock.ObjName + " нулевой длины");
        }
        else if (!isMulUseProj) {
          //System.Windows.Forms.MessageBox.Show("попытка установить mulUseNameProj для " + this.objName + " " + this.ownerBlock.ObjName + " без присвоения isMulUseProj");
          //isMulUseProj = true;
        }
      }
    }

    int type;
    string objName;
    public Scheme scheme;
    public String Text = "NONE";


    public Block ownerBlock;

    string[] typeString = { "use", "get", "clk", "win", "dlg" };

    public Dictionary<string, Invitem> objectActions;

    Scheme _scheme;

    public Action(Scheme scheme, string str, Block ownerBlock, string lvl_str)
    : base(str) {
      try {
        this.ownerBlock = ownerBlock;

        _scheme = scheme;
        objectActions = _scheme.objectActions;

        type = Convert.ToInt16(properties["type"]);
        id = Convert.ToInt16(properties["id"]);
        id_local = properties["id_local"];

        if (type == 2) {
          if (properties["name"].StartsWith("win_")) {
            properties["name"] = properties["name"].Replace("win_", "");
            type = 3;
          }
          else if (properties["name"].StartsWith("mmg_")) {
            properties["name"] = properties["name"].Replace("mmg_", "");
            type = 3;
            //this.ownerBlock = ownerBlock.OwnerBlock;
          }
          else if (properties["name"].StartsWith("dlg_")) {
            properties["name"] = properties["name"].Replace("dlg_", "");
            type = 4;
            //this.ownerBlock = ownerBlock.OwnerBlock;
          }
        }

        string nm = properties["name"];
        Text = properties["text"];

        if (new Regex("[а-яА-Я]").IsMatch(nm)) {
          System.Windows.Forms.MessageBox.Show("Action *" + properties["type"] + "_" + properties["name"] +
                                               "* содержит русские буквы");
        }
        else if(nm.IndexOf(" ")>=0) {
          System.Windows.Forms.MessageBox.Show("Action *" + properties["type"] + "_" + properties["name"] +
                                               "* содержит пробелы");
        }

        Regex rg = new Regex(@"([a-z]*)(_?)(\d?)(.*)");
        //MatchCollection mrg = rg.Matches(nm);
        Match mrg = rg.Match(nm);

        //form.Debag(nm);
        string nnm = "";

        for (int i = 1; i < mrg.Groups.Count; i++) {
          //form.Debag("\t" + i + "\t" + mrg.Groups[i].Value);
          nnm += mrg.Groups[i].Value;
          if (lvl_str.Length > 1) {
            if (i == 1)
              nnm += lvl_str;
          }
        }

        //form.Debag("\t\t"+nnm);

        properties["name"] = nnm;

        objName = properties["name"];

        try {
          objectActions[properties["name"]].AddAction(this);
        }
        catch {
          objectActions.Add(properties["name"], new Invitem(properties["name"]));
          //try
          //{

          objectActions[properties["name"]].AddAction(this);

          //}
          //catch
          //{
          //    form.Debag("SHHHHIIIIIIT!!!");

          //}

          //form.Debag("CATCH!!!");
        }
        if (id_local.Length == 0)
          System.Windows.Forms.MessageBox.Show("id_local not finded for " + ObjName+" "+ID);
      }
      catch {
        form.Debag("wrong action " + str, System.Drawing.Color.Red);
      }
    }

    public int ID {
      get {
        return id;
      }
    }

    public int Type {
      get {
        return type;
      }
    }

    public string TypeString {
      get {
        return typeString[type];
      }
    }
    public string ObjName {
      get {
        return objName;
      }
    }
    public Dictionary<string, Invitem> ObjectActions {
      get {
        return objectActions;
      }
    }

    public bool IsMultiGetLev() {

      int mcount = 1;
      if (scheme.isLevelBuilded && isMulGetProj)
        mcount = 0;
      //form.Debag(objName +"   "+ mcount);
      try {
        List<Action> al = objectActions[this.objName].actions["get"];
        //int c = 0;
        //for (int i = 0; i < al.Count; i++)
        //{
        //    if (al[i].TypeString == "get")
        //        c++;
        //}
        //form.Debag(objName + "\t" + al.Count + "\t" + mcount);
        if (al.Count > mcount)
          return true;
        else
          return false;
      }
      catch {
        return false;
      }
    }
    public bool IsMultiUseLev() {
      int mcount = 1;
      if (scheme.isLevelBuilded && isMulUseProj)
        mcount = 0;
      try {
        List<Action> al = objectActions[this.objName].actions["use"];
        //int c = 0;
        //for (int i = 0; i < al.Count; i++)
        //{
        //    if (al[i].TypeString == "use")
        //        c++;
        //}
        //form.Debag(al.Count.ToString());
        if (al.Count > mcount)
          return true;
        else
          return false;
      }
      catch {
        return false;
      }
    }

    public string PrgName {
      get {
        string prg = TypeString + "_" + ObjName;

        if (TypeString == "get") {
          if (isMulGetProj | ( MulGetNumProj > 0 ) ) {
            //if(MulGetNumProj>1)
            prg += MulGetNumProj;

          }
        }
        else if (TypeString == "use") {
          if (isMulUseProj) {
            prg += "_" + MulUseNameProj;
          }
          else if (IsMultiUseLev()) {
            prg += "_" + ownerBlock.ObjName;
          }
        }
        else if (TypeString == "dlg") {
          if (ownerBlock.TypeString=="rm")
            prg = "dlg_" + ownerBlock.ObjName + "_" + ObjName.Replace("dlg_", "");
          else
            prg = "dlg_" + ownerBlock.OwnerBlock.ObjName + "_" + ObjName.Replace("dlg_", "");

          //prg = "dlg_" + ownerBlock.OwnerBlock.ObjName + "_" + ObjName;
        }
        else if (TypeString == "mmg") {
          if (ownerBlock.TypeString == "rm")
            prg = "mmg_" + ownerBlock.ObjName + "_" + ObjName.Replace("mmg_","");
          else
            prg = "mmg_" + ownerBlock.OwnerBlock.ObjName + "_" + ObjName.Replace("mmg_", "");
        }

        if (prg.StartsWith("clk_clk_"))
          System.Windows.Forms.MessageBox.Show("!!!!!!!!!!! clk_clk_ in " + objName);
        if (prg.StartsWith("clk_mmg_"))
          System.Windows.Forms.MessageBox.Show("!!!!!!!!!!! clk_clk_ in " + objName);

        return prg;
      }
    }

    public string ProjObjName {
      get {
        string name = "";

        if (TypeString == "get") {

          if(ownerBlock.TypeString=="dlg")
            name += "spr_" + ownerBlock.OwnerBlock.ObjName + "_" + objName;
          else
            name += "spr_" + ownerBlock.ObjName + "_" + objName;

          if (isMulGetProj | MulGetNumProj>0) {
            name += MulGetNumProj;
          }
        }
        else if (TypeString == "use") {
          if (ownerBlock.TypeString == "dlg")
            name += "gfx_" + ownerBlock.OwnerBlock.ObjName + "_" + objName;
          else
            name += "gfx_" + ownerBlock.ObjName + "_" + objName;

          //if (ObjName.IndexOf("match") > -1)
          //{
          //    form.Debag("\t\t\t\t"+isMulUseProj + "\t" + MulUseNameProj);
          //}

          if (isMulUseProj) {
            name += "_" + MulUseNameProj;
          }
          name += "_zone";
        }
        else if (TypeString == "clk") {
          if (ownerBlock.TypeString == "dlg")
            name += "gfx_" + ownerBlock.OwnerBlock.ObjName + "_clk_" + objName;
          else
            name += "gfx_" + ownerBlock.ObjName + "_clk_" + objName;

          name += "_zone";
        }
        else if (TypeString == "win") {
          if (ownerBlock.TypeString == "dlg")
            name += "gfx_" + ownerBlock.OwnerBlock.ObjName + "_win_" + objName;
          else
            name += "gfx_" + ownerBlock.ObjName + "_win_" + objName;

          name += "_zone";
        }
        else if (TypeString == "dlg") {
          if (ownerBlock.TypeString == "dlg")
            name += "gfx_" + ownerBlock.OwnerBlock.ObjName + "_dlg_" + ownerBlock.OwnerBlock.ObjName + "_" +objName;
          else if(ownerBlock.TypeString=="rm")
            name += "gfx_" + ownerBlock.ObjName + "_dlg_" + ownerBlock.ObjName + "_" + objName;
          else
            name += "gfx_" + ownerBlock.OwnerBlock.ObjName + "_dlg_" + ownerBlock.OwnerBlock.ObjName + "_" + objName;

          name += "_zone";
        }

        return name;
      }
    }

    public string getSFXname() {
      string sfx = "NONE";
      if (TypeString == "use") {
        if (IsMulUseProj||IsMultiUseLev()) {
          if (PrgName.EndsWith("_" + ownerBlock.ObjName)) {
            var al = objectActions[this.objName].actions["use"].Where((a) => a.ownerBlock.ObjName == objName).ToList();

            if (al.Count > 1) {
              for(int i=0; i<al.Count; i++) {
                if(al[i].PrgName==PrgName) {
                  sfx = "aud_" + PrgName.Replace("_" + ownerBlock.ObjName, "");
                  if (ownerBlock.TypeString == "zz") {
                    sfx += "_" + ownerBlock.OwnerBlock.ObjName;
                  }
                  else {
                    sfx += "_" + ownerBlock.ObjName;
                  }
                  sfx += ( i + 1 ).ToString();
                  break;
                }
              }
            }
            else {
              sfx = "aud_" + PrgName.Replace("_" + ownerBlock.ObjName, "");
              if(ownerBlock.TypeString=="zz") {
                sfx += "_" + ownerBlock.OwnerBlock.ObjName;
              }
              else {
                sfx += "_" + ownerBlock.ObjName;
              }
            }
          }
          else {
            sfx = "aud_" + PrgName;
          }
        }
        else {
          if( ownerBlock.TypeString == "rm" || ownerBlock.TypeString == "inv") {
            sfx = "aud_" + PrgName + "_" + ownerBlock.ObjName;
          }
          else {
            sfx = "aud_" + PrgName + "_" + ownerBlock.OwnerBlock.ObjName;
          }
        }
      }
      else if(TypeString == "clk") {
        if (ownerBlock.TypeString == "rm" || ownerBlock.TypeString == "inv") {
          sfx = "aud_" + PrgName + "_" + ownerBlock.ObjName;
        }
        else {
          sfx = "aud_" + PrgName + "_" + ownerBlock.OwnerBlock.ObjName;
        }
      }
      return sfx;
    }

    public string getSFXnameXX() {
      string sfx = getSFXname();
      if(TypeString=="use") {
        sfx = sfx.Replace("_use_","_xx_");
      }
      return sfx;
    }
  }
}

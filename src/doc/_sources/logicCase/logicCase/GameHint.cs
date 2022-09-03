using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Text.RegularExpressions;

namespace logicCase {
  public class GameHint {
    Form1 form;
    Dictionary<string, Hint> hint = new Dictionary<string, Hint>();

    public Dictionary<string, Hint> Hints {
      get {
        return hint;
      }
    }

    public GameHint( Form1 formRef ) {
      try {
        form = formRef;
        Hint.form = form;
        List<ModuleClass> modules = form.GetModules();
        for (int m = 0; m < modules.Count; m++) {
          ModuleClass mod = modules[m];
          List<MyTrigClass> trigs = mod.GetTrigsList();
          for (int t = 0; t < trigs.Count; t++) {
            MyTrigClass trg = trigs[t];
            List<string> code = trg.GetCode();
            AddHint(code, mod);

          }
        }
      }
      catch (Exception e) {
        System.Windows.Forms.MessageBox.Show(e.Message);
      }
    }

    public List<string> TrimComents( List<string> code ) {

      var blockComments = @"--[[(.*?)--]]";
      var lineComments = @"--(.*?)\r?\n";
      var strings = @"""((\\[^\n]|[^""\n])*)""";
      var verbatimStrings = @"@(""[^""]*"")+";

      string code_in = form.ListToString(code);

      string noComments = Regex.Replace(code_in,
                                        blockComments + "|" + lineComments + "|" + strings + "|" + verbatimStrings,
      me => {
        if (me.Value.StartsWith("--[[") || me.Value.StartsWith("--"))
          return me.Value.StartsWith("--") ? Environment.NewLine : "";
        // Keep the literal strings
        return me.Value;
      },
      RegexOptions.Singleline);

      return form.StringToList(noComments);
    }

    public void AddHint(List<string> code_main, ModuleClass mod) {
      string strLast = "";

      try {
        List<string> code = code_main;// TrimComents(code_main);

        var cBeg = 0;

        SKIP:

        for (int c = cBeg; c < code.Count; c++) {
          strLast = code[c];
          string str = code[c];
          if (str.Trim().IndexOf("common_impl.hint") == 0) {
            string s = "";
            s = str;
            int sc = 0;
            while (s.IndexOf("}") == -1) {
              sc++;
              if((c + sc)>= code.Count) {
                form.Debag(" AddHint - не найдено завершение объявления хинта >>\n\t"+ strLast);
                cBeg = ++c;
                goto SKIP;
              }
              s += code[c + sc];
            }
            //try
            //{
            Hint hnt = null;
            try {
              hnt = new Hint(s, code);
            }
            catch {
              form.Debag("CATCH new Hint");
            }
            Hint trgvh = null;
            try {
              hint.TryGetValue(hnt.name, out trgvh);
            }
            catch {
              form.Debag("CATCH tryGetValue");
            }
            if (trgvh == null) {

              //form.Debag(hint.Count + " " + hnt.name);
              //foreach (KeyValuePair<string, string> kvp in hnt.Properties)
              //{
              //    form.Debag("\t" + kvp.Key + "\t" + kvp.Value);
              //}

              //string trgCode = form.ListToString( trg.GetCode() );
              //form.Debag(trgCode);
              int id;
              //try
              //{
              if (true) { //hnt.Properties["type"]=="use")
                //выдираем функцию
                //string[] searth_functions = { hnt.name + "_logic", hnt.name + "_beg", hnt.name + "_end" };
                List<string> searth_functions = new List<string>();
                searth_functions.Add(hnt.name + "_inv");
                searth_functions.Add(hnt.name + "_logic");
                searth_functions.Add(hnt.name + "_beg");
                searth_functions.Add(hnt.name + "_end");

                //searth_functions.Add("private." + hnt.name + "_inv");
                //searth_functions.Add("private." + hnt.name + "_logic");
                //searth_functions.Add("private." + hnt.name + "_beg");
                //searth_functions.Add("private." + hnt.name + "_end");

                if (mod.GetName() == "level_inv") {
                  searth_functions.Add("public." + hnt.name);
                }
                else {
                  searth_functions.Add("public." + hnt.name);
                }
                List<List<string>> functions = new List<List<string>>();
                for (int sf = 0; sf < searth_functions.Count; sf++) {

                  List<string> fls = new List<string>();

                  string func = "";
                  id = form.FindId(code, searth_functions[sf]);
                  int ends = 0;
                  MatchCollection mc;

                  if (id > -1) {
                    hint[hnt.name] = hnt;
                  }
                  else {
                    continue;
                  }

                  string coment = code[id];
                  coment = coment.Trim();
                  if (coment.IndexOf("--") > -1) {
                    coment = coment.Substring(0, coment.IndexOf("--"));
                  }

                  string searth = "*\n" + coment + "\n*";

                  Regex reg_func = new Regex(@"([\s]function[\s]|[\s]function\(|;function[\s])");
                  mc = reg_func.Matches(searth);
                  ends += mc.Count;

                  Regex reg_for = new Regex(@"([\s]for[\s]|;for[\s])");
                  mc = reg_for.Matches(searth);
                  ends += mc.Count;

                  Regex reg_then = new Regex(@"([\s]then[\s])");
                  mc = reg_then.Matches(searth);
                  ends += mc.Count;

                  Regex reg_elseif = new Regex(@"([\s]elseif[\s])");
                  mc = reg_elseif.Matches(searth);
                  ends -= mc.Count;

                  //Regex reg_while = new Regex(@"([\s]+while[\s]+)");
                  //mc = reg_while.Matches(searth);
                  //ends += mc.Count;

                  Regex reg_end = new Regex(@"([\s]end[\s]|[\s]end;|;end[\s]|;end;|[\s]end,|[\s]end\))");
                  mc = reg_end.Matches(searth);
                  ends -= mc.Count;

                  func += code[id];
                  fls.Add(code[id]);

                  while (ends > 0) {
                    id++;

                    if (id >= code.Count) {
                      form.Debag(hnt.name + " HINT id > code.Count");
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

                  try {
                    string tooltip = "";
                    hnt.Properties.TryGetValue("tooltip", out tooltip);
                    hnt.Properties["tooltip"] = tooltip + "\n" + func + "\n";
                    functions.Add(fls);
                  }
                  catch {
                    form.Debag("CATCH func\t" + func.ToString());
                  }

                  //form.Debag(hnt.name);
                  //form.Debag("\t" + code[id]);
                  //for (int col = 0; col < mc.Count; col++)
                  //{
                  //    form.Debag("\t"+mc[col].Value);
                  //}
                  //form.Debag("*");
                }
                hnt.functions = functions;

              }

              //}
              //catch
              //{
              //    form.Debag("CATCH func_logic finder \t" + hnt.name);
              //}
              string zz = null;
              string room = null;
              string type = null;
              hnt.Properties.TryGetValue("zz", out zz);
              hnt.Properties.TryGetValue("room", out room);
              if (zz != null) {
                MyObjClass go = form.GetObj(zz);
                if (go == null) {
                  //System.Windows.Forms.MessageBox.Show("Хинт " + hnt.name + " ссылается на несуществующую ЗЗ -> " + zz);
                  form.Debag("Хинт " + hnt.name + " ссылается на несуществующую ЗЗ -> " + zz,
                             System.Drawing.Color.Red);
                }
                else {
                  MyControl goc = go.GetMyControl();
                  goc.AddHintItem(hnt);
                  //form.Debag("!!ZZ!!"+hnt.text);
                  //if (go.GetName() == "inv_complex_penal")
                  //{
                  //    form.Debag("\t>>>" + str.Trim() + "<<<");
                  //}
                }
              }
              else if (room != null && !room.StartsWith("int_")) {
                MyObjClass go = form.GetObj(room);
                MyControl goc = go.GetMyControl();
                goc.AddHintItem(hnt);
                //form.Debag("!!RM!!" + hnt.text);
                //if (go.GetName() == "inv_complex_penal")
                //{
                //    form.Debag("\t>>>" + str.Trim() + "<<<");
                //}
              }
              else {
                form.Debag("NOT FINDED OBJ FOR HINT \t" + hnt.name);
              }
            }
            //}
            //catch
            //{
            //    form.Debag("Catch in game.hint \n\t" + str + "\t" + sc);

            //}
            //form.Debag(hint.Count.ToString()+" "+s+"\n");
          }
          //else if(str.IndexOf("common_impl.hint")>0)
          //{
          //    form.Debag(str);
          //}

        }
      }
      catch(Exception e) {
        System.Windows.Forms.MessageBox.Show(
          "Ошибка при добавлении хинта в модуле " + mod.GetName()
          + "\n\n " + strLast
          + "\n\n " + e.Message
          + "\n\n " + e.StackTrace);
      }
    }


  }


  public class Hint {
    public static Form1 form;
    public string text;
    public string name;

    public List<List<string>> functions = new List<List<string>>();

    public List<string> code;

    public Dictionary<string,string> Properties = new Dictionary<string,string>();
    public Hint(string str, List<string> code) {
      try {
        text = str;
        string s = text;
        s = s.Substring(s.IndexOf("\"") + 1);
        name = s.Substring(0, s.IndexOf("\""));
        s = s.Substring(s.IndexOf("{") + 1);
        s = s.Replace(",", "");
        s = s.Replace(";", "");
        s = s.Trim();
        while (s.IndexOf("=")>-1) {
          string k = s.Substring(0, s.IndexOf("="));
          k = k.Trim();
          //form.Debag("*" + k + "*");
          s = s.Substring(s.IndexOf("\"")+1);
          string v = s.Substring(0, s.IndexOf("\""));
          s = s.Substring(s.IndexOf("\"") + 1);
          s = s.Trim();
          Properties[k] = v;
        }
        this.code = code;
        //form.Debag(name);

      }
      catch {
        form.Debag("CATCH\t" + str,System.Drawing.Color.Red);
      }
    }
  }
}

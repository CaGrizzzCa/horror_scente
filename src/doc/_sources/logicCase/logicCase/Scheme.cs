using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace logicCase
{
    class Scheme
    {
        public bool isLevelBuilded = false;
        public bool isExt = false;


        Form1 form = program.form;
        List<string> load;
        List<Link> links = new List<Link>();
        List<Block> blocks = new List<Block>();
        public List<Block> Blocks { get { return blocks; } }
        List<Action> actions = new List<Action>();
        public List<Action> Actions { get { return actions; } }
        Dictionary<string, Invitem> items = new Dictionary<string, Invitem>();
        public Dictionary<string, Invitem> Items { get { return items; } }
        Dictionary<string, Propobj> startinv = new Dictionary<string, Propobj>();
        public Dictionary<string, Propobj> StartInv { get { return startinv; } }
        public int Level;
        public string Level_str = "";
        int startBlockID;
        public int StartBlockID { get { return startBlockID; } }

        public Dictionary<Action, List<Action>> SimilarActSet = new Dictionary<Action, List<Action>>();
        public Dictionary<Action, List<Action>> ActSet = new Dictionary<Action, List<Action>>();
        public Dictionary<Action, List<Block>> ActBlocksToActivate = new Dictionary<Action, List<Block>>();

        public Dictionary<string, Invitem> objectActions;


        public Scheme(string dir, int lvl, string lvl_str)
        {
            objectActions = new Dictionary<string, Invitem>();

            load = form.LoadXML(dir);
            Level = lvl;
            Level_str = lvl_str;
            for (int i = 0; i < load.Count; i++)
            {
                if ( load[i].IndexOf("<startroom id=\"")>-1)
                {
                    Propobj stroom = new Propobj(load[i]);
                    startBlockID = Convert.ToInt16( stroom.Propertie("id") );
                }

                if (load[i].IndexOf("<link ") > -1)
                {
                    Link lnk = new Link(load[i]);
                    lnk.scheme = this;
                    if ( lnk.Type == 0 )
                        links.Add(lnk);
                }

                if (load[i].IndexOf("<block ") > -1)
                {
                    Block block = new Block(load[i], Level_str);
                    block.scheme = this;
                    blocks.Add( block );
                    int ii = i + 1;
                    while (load[ii].IndexOf("<action ") > -1)
                    {
                        Action act = new Action(this, load[ii], block, Level_str);
                        act.scheme = this;
                        actions.Add(act);

                        //form.Debag(act.ObjName + "\t" + act.ProjObjName + "\t" + act.PrgName,System.Drawing.Color.Green);

                        //try
                        //{
                        //    items[act.Propertie("name")] = act.ObjectActions[act.Propertie("name")];
                        //    //items.Add(
                        //}
                        //catch
                        //{

                        //}

                        block.AddAction( act );
                        ii++;
                    }

                    BlockLinker(block);
                }

                if (load[i].IndexOf("<start_inventory>") > -1)
                {
                    int si = 1;
                    while (load[i + si].IndexOf("<element ") > -1)
                    {
                        //System.Windows.Forms.MessageBox.Show(load[i + si]);
                        Propobj el = new Propobj(load[i + si]);
                        startinv[el.Propertie("name")] = el;
                        //program.form.Debag(el.Propertie("name"));
                        si++;
                    }
                }

            }

            //for (int a = 0; a < actions.Count; a++)
            //{
            //    form.Debag(actions[a].ID.ToString());
            //}
            actions = actions.OrderBy(act => act.ID).ToList();
            for (int a = 0; a < actions.Count; a++)
            {
                //form.Debag(actions[a].ID.ToString() + " >>> " + actions[a].ObjName);
            }

            //actions.Sort( new ActionSortByID() );
            //for (int i = 0; i < actions.Count; i++)
            //{
            //    try
            //    {
            //        items[actions[i].Propertie("name")] = actions[i].ObjectActions[actions[i].Propertie("name")];
            //        //items.Add(
            //    }
            //    catch
            //    {

            //    }
            //}
            BlockChilder();

            blocks = blocks.OrderBy(b => b.TypeString).ThenBy(b=>b.ObjName).ToList();

            ConnectLogic();
        }

        public void Show()
        {
            form.Debag("Scheme Show");
            for (int i = 0; i < blocks.Count; i++)
            {
                blocks[i].Show();
            }

            //for (int i = 0; i < actions.Count; i++)
            //{
            //    Action act = actions[i];
            //    form.Debag(act.ID + "\t" + act.ObjName + "\t" + act.TypeString);
            //}

            //foreach (var kvp in items)
            //{
            //    form.Debag(kvp.Key);
            //    foreach (var itm in kvp.Value.actions)
            //    {
            //        List<Action> acts = itm.Value;
            //        for (int a=0; a < acts.Count; a++)
            //        {
            //            form.Debag("\t" + acts[a].ID + "\t" + acts[a].TypeString + "\t" + acts[a].ownerBlock.ObjName);
            //        }
            //    }
            //}

            //

            for (int i = 0; i < blocks.Count; i++)
            {
                Block b = blocks[i];
                //глава
                string s = "";
                s+="\t";
                //тип
                s += b.TypeString;
                s += "\t";
                //имя
                s += b.ObjName;
                s += "\t";
                //ТЭГ
                if (b.TypeString == "rm")
                {
                    s += b.ObjName;
                }
                else
                {
                    try
                    {
                        s += b.OwnerBlock.ObjName;
                    }
                    catch
                    {
                        form.Debag(b.TypeString + "_" + b.ObjName + " не имеет родителя ", System.Drawing.Color.Red);
                        s += "ALLERT!!!";
                    }
                }
                s += "\t";
                //комната назад
                if (b.TypeString == "rm" & b.OwnerBlock != null)
                {
                    s += b.OwnerBlock.ObjName;
                }
                s += "\t";
                //список звязанных комнат


            }
        }

        class ActionSortByID : IComparer<Action>
        {
            public int Compare(Action act1, Action act2)
            {
                return act1.ID.CompareTo(act2.ID);
            }
        }



        public Link GetLinkById(int id)
        {
            for (int i = 0; i < links.Count; i++)
            {
                if (links[i].ID == id)
                    return links[i];
            }
            return null;
        }
        public Link GetLinkById(string id)
        {
            return GetLinkById(Convert.ToString(id));
        }

        public Block GetBlockById(int id)
        {
            for (int i = 0; i < blocks.Count; i++)
            {
                if (blocks[i].ID == id)
                    return blocks[i];
            }
            return null;
        }
        public Block GetBlockById(string id)
        {
            return GetBlockById(Convert.ToString(id));
        }
        public Block GetBlockByFullName(string fullName)
        {
            for (int i = 0; i < blocks.Count; i++)
            {
                if (blocks[i].FullName == fullName)
                    return blocks[i];
            }
            System.Windows.Forms.MessageBox.Show("GetBlockByFullName "+ fullName + " = null");
            return null;
        }

        public Action GetActionById(int id)
        {
            for (int i = 0; i < actions.Count; i++)
            {
                if (actions[i].ID == id)
                    return actions[i];
            }
            return null;
        }
        public Action GetActionById(string id)
        {
            return GetActionById(Convert.ToString(id));
        }
        public Action GetActionByPrgName(string prgName)
        {
            for (int i = 0; i < actions.Count; i++)
            {
                if (actions[i].PrgName == prgName)
                    return actions[i];
            }
            return null;
        }

        //добавляем блокам линки
        void BlockLinker(Block block)
        {
            //form.Debag(block.ObjName + " " + block.ID);
            for (int i = 0; i < links.Count; i++)
            {
                if (links[i].BlockID[0] == block.ID | links[i].BlockID[1] == block.ID)
                {
                    block.AddLink(links[i]);
                    //form.Debag("\t" + links[i].ID + " added to " + block.ObjName, System.Drawing.Color.Red);
                }
                else
                {
                    //form.Debag(i + "\t" + links[i].ID + "\t" + links[i].BlockID[0] + "!=" + block.ID + "\t" + links[i].BlockID[1] + "!=" + block.ID);
                }
                
            }
        }

        //отностительно старт руум добавляем дочернии блоки
        void BlockChilder()
        {
            BlockChilder(GetBlockById(startBlockID), startBlockID);

        }
        void BlockChilder(Block block, int from )
        {
            for (int i = 0; i < block.Links.Count; i++)
            {
                //form.Debag("BlockChilder "+block.ObjName+" " + block.ID + " from "+from);
                Link link = block.Links[i];
                if (link.BlockID[0] == block.ID)
                {
                    if (from != link.BlockID[1])
                    {
                        block.AddChildBlock(GetBlockById(link.BlockID[1]), link.Type == 0);
                        if (GetBlockById(link.BlockID[1]).Type == 0)
                            BlockChilder(GetBlockById(link.BlockID[1]), block.ID);
                    }
                }
                else
                {
                    if (from != link.BlockID[0])
                    {
                        block.AddChildBlock(GetBlockById(link.BlockID[0]), link.Type == 0);
                        if (GetBlockById(link.BlockID[0]).Type == 0)
                            BlockChilder(GetBlockById(link.BlockID[0]), block.ID);
                    }
                }
            }
        }

        public bool IsStartInv(string objName)
        {
            foreach (var kvp in startinv)
            {
                if (kvp.Key == objName)
                    return true;
            }
            return false;
        }

        private void ConnectLogic()
        {
            for (int a = 0; a < Actions.Count; a++)
            {
                Action act = Actions[a];
                string[] rus = { "А", "В", "С" };
                string[] eng = { "A", "B", "C" };
                for (int i = 0; i < rus.Count(); i++)
                {
                    act.IDlocal = act.IDlocal.Replace(rus[i], eng[i]);
                }
            }

            //List<Action> ActIf = new List<Action>();
            

            for (int b = 0; b < Blocks.Count; b++)
            {
                Block block = Blocks[b];
                //Debag(block.TypeString + "_" + block.ObjName);
                for (int a = 0; a < block.Actions.Count; a++)
                {
                    Action act = block.Actions[a];


                    //Debag("\t" + act.TypeString + "_" + act.ObjName);
                    //подвергающиеся зависимости
                    if (act.TypeString == "get" || act.TypeString == "use" || act.TypeString == "clk" || act.TypeString == "dlg" || act.TypeString == "win")
                    {
                        string sobj = "";

                        if (act.TypeString == "get")
                        {
                            //if(block.TypeString=="dlg")
                            //    sobj += "spr_" + block.OwnerBlock.ObjName + "_";
                            //else
                            sobj += "spr_" + block.ObjName + "_";
                        }
                        else if (act.TypeString == "use")
                            sobj += "gfx_" + block.ObjName + "_";
                        else if (act.TypeString == "clk")
                            sobj += "gfx_" + block.ObjName + "_clk_";
                        else if (act.TypeString == "dlg")
                        {
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

                        if (act.TypeString == "get")
                        {

                            if (act.IsMulGetProj | act.IsMultiGetLev() | act.MulGetNumProj > 0)
                            {
                                sobj += act.MulGetNumProj;
                                //Debag("\t\t\t\tmul_get_" + act.ObjName+"\t"+act.MulGetNumProj, Color.Green);
                            }
                        }
                        if (act.TypeString == "use")
                        {
                            if (act.IsMulUseProj)
                            {
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

                        if (act.IDlocal == "!" || act.IDlocal == "")
                        {
                            //Debag("\t default",Color.Gray);
                        }

                        //влияющие на зависимости
                        if (act.TypeString == "use" || act.TypeString == "clk" || act.TypeString == "dlg" || act.TypeString == "win")
                        {

                            //ActIf.Add(act);
                            ActSet.Add(act, new List<Action>());
                            SimilarActSet.Add(act, new List<Action>());

                            //List<Action> UseActs = new List<Action>();
                            //List<string> UseObjSets = new List<string>();

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

                            for (int i = 0; i < block.Actions.Count; i++)
                            {
                                Action aact = block.Actions[i];

                                if (aact.ID != act.ID && (aact.TypeString == "use" || aact.TypeString == "clk" || aact.TypeString == "dlg" || aact.TypeString == "win" || aact.TypeString == "mmg"))
                                {
                                    //однозначимые юсы
                                    if (aact.IDlocal[0] == act.IDlocal[0])
                                    {
                                        //Debag(aact.ProjObjName, Color.Red);
                                        SimilarActSet[act].Add(aact);
                                    }
                                    if ((aact.IDlocal.Length > 1) && ((act.IDlocal[0] == aact.IDlocal[1]) || (aact.IDlocal.Length > 2 && act.IDlocal[0] == aact.IDlocal[2])))
                                    {
                                        //нашли искомый юс
                                        //form.Debag(act.PrgName + " >> " + aact.PrgName);
                                        ActSet[act].Add(aact);
                                    }
                                }
                                if (aact.ID != act.ID && aact.TypeString == "get" && aact.IDlocal.Length > 0)
                                {
                                    if ((act.IDlocal[0] == aact.IDlocal[0]) || (aact.IDlocal.Length > 1 && act.IDlocal[0] == aact.IDlocal[1]))
                                    {
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

            foreach (var kvp in ActSet)
            {
                //Debag(kvp.Key.PrgName + "\t\t" + kvp.Key.Propertie("text") + "\t\t" + kvp.Key.ownerBlock.ObjName + "\t\t" + kvp.Key.ownerBlock.Propertie("header"));
                string str = "";
                string tab = "  ";
                string check = "";
                if (SimilarActSet[kvp.Key].Count > 0)
                {
                    //str += tab + "ld.CheckRequirements( {\"";
                    check = "  if ld.CheckRequirements( {\"" + kvp.Key.PrgName + "\"";
                    for (int i = 0; i < SimilarActSet[kvp.Key].Count; i++)
                    {
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
                while (ff > -1)
                {
                    text = text.Substring(ff + 1);
                    //Debag(text, Color.DarkGoldenrod);
                    string dop = text.Substring(0, text.IndexOf("]"));
                    if (dop != "OLD" && dop.IndexOf("-GET-") == -1 && dop.IndexOf("WIN") == -1)
                    {
                        dopActs.Add(dop);
                        //Debag("\t" + text.Substring(0, text.IndexOf("]")), Color.DarkGoldenrod);
                    }

                    ff = text.IndexOf("[");
                }
                for (int i = 0; i < dopActs.Count; i++)
                {
                    try
                    {
                        if (dopActs[i].Length < 3)
                            continue;

                        string idLocal = dopActs[i].Substring(0, 1);
                        string rmOpen = dopActs[i].Substring(2);
                        if (Level_str.Length > 1)
                            rmOpen += Level_str;

                        if (kvp.Key.IDlocal.Length > 0 && kvp.Key.IDlocal.Substring(0, 1) == idLocal)
                        {
                            List<Block> lb;
                            if (!ActBlocksToActivate.TryGetValue(kvp.Key, out lb))
                            {
                                ActBlocksToActivate[kvp.Key] = new List<Block>();
                            }
                            ActBlocksToActivate[kvp.Key].Add(GetBlockByFullName(rmOpen));
                        }
                    }
                    catch
                    {
                        //MessageBox.Show("Исключение для\n" + dopActs[i] + "\n" + kvp.Key.ProjObjName + "\n" + kvp.Key.ownerBlock.Propertie("text"));
                    }
                }
                //</GATES>

            }
        }
    }
}

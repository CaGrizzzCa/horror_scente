using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Text.RegularExpressions;

namespace logicCase
{
    class Block:Propobj
    {
        int id;
        int type;

        string objName;
        public string ObjName { get { return objName; } }
        public string FullName { get { return TypeString + "_" + ObjName; } }

        public Scheme scheme;



        string[] typeString = { "rm", "zz", "mg", "ho", "inv", "vid", "dlg", "coment" };
        public string TypeString { get { return typeString[type]; } }

        List<Action> actions = new List<Action>();
        public List<Action> Actions { get { return actions; } }
        
        List<Link> links = new List<Link>(); 
        public List<Link> Links { get { return links; } }

        List<Block> childBlocks = new List<Block>();
        public List<Block> ChildBlocks { get { return childBlocks; } }

        Block ownerBlock;
        public Block OwnerBlock { get { return ownerBlock; } }

        public Block(string str, string lvl_str)
            : base(str)
        {
            try
            {
                type = Convert.ToInt16(properties["type"]);
                id = Convert.ToInt16(properties["id"]);

                string nm = properties["objname"];

                if(nm=="")
                {
                    form.Debag("\t\t" + properties["header"] + " >> Нет Английского нимени!", System.Drawing.Color.Red);
                    System.Windows.Forms.MessageBox.Show(properties["header"]+"\n" + properties["text"] + "\n Нет Английского нимени!");
                }

                Regex rg = new Regex(@"([a-z]*)(_?)(\d?)(.*)");
                Match mrg = rg.Match(nm);
                //form.Debag(nm);
                string nnm = "";
                for (int i = 1; i < mrg.Groups.Count; i++)
                {
                    //form.Debag("\t" + i + "\t" + mrg.Groups[i].Value);
                    nnm += mrg.Groups[i].Value;
                    if (lvl_str.Length > 1)
                    {
                        if (i == 1)
                            nnm += lvl_str;
                    }
                }
                //form.Debag("\t\t" + nnm);

                properties["objname"] = nnm;


                objName = properties["objname"];
                //if (type == 4)
                //    form.Debag("\t\t" + objName, System.Drawing.Color.Red);
            }
            catch
            {
                form.Debag("wrong block " + str, System.Drawing.Color.Red);
            }
        }

        
        public int ID
        {
            get
            {
                return id;
            }
        }

        public int Type
        {
            get
            {
                return type;
            }
        }

        public void AddAction( Action act )
        {
            actions.Add(act);
            actions = actions.OrderBy(a => a.ID).ToList();
        }

        public void AddLink(Link link)
        {
            links.Add(link);
        }

        public void AddChildBlock(Block block, bool owner)
        {

            if (block.TypeString == "inv")
            {
                System.Windows.Forms.MessageBox.Show("COMPLEXный БЛОК \n" + block.FullName + "\n имеет родителя!!! \n не будет добавлен");
            }
            else
            {
                if (owner)
                {

                    block.ownerBlock = this;
                }
                //form.Debag("added child " + block.ObjName + " for " + this.ObjName);
                childBlocks.Add(block);
            }
        }

        public override void Show( int tabs )
        {
            string tabler = "\t";
            string tab = "";
            for (int i = 0; i < tabs; i++)
                tab += tabler;

            base.Show( tabs );
            form.Debag("\n" + tab + "ownerBlock", System.Drawing.Color.Green);
            if (ownerBlock != null)
            {

                form.Debag(tab + ownerBlock.ID + "\t" + ownerBlock.TypeString + "\t" + ownerBlock.objName);

            }
            if (childBlocks.Count > 0)
            {
                form.Debag("\n" + tab + "ChildBlocks", System.Drawing.Color.Green);
                for (int i = 0; i < childBlocks.Count; i++)
                {
                    form.Debag(tab + childBlocks[i].ID + "\t" + childBlocks[i].TypeString + "\t" + childBlocks[i].objName);
                    //childBlocks[i].Show(tabs + 1);
                }
            }

            form.Debag("\n" + tab + "Links",System.Drawing.Color.Green);
            for (int i = 0; i < links.Count; i++)
            {
                //form.Debag( tab + links[i].ID);
                //links[i].Show( tabs + 1 );
                if (links[i].BlockID[0] != id)
                {
                    form.Debag(tab + scheme.GetBlockById(links[i].BlockID[0]).TypeString + "\t" + scheme.GetBlockById(links[i].BlockID[0]).ObjName);
                }
                else
                {
                    form.Debag(tab + scheme.GetBlockById(links[i].BlockID[1]).TypeString + "\t" + scheme.GetBlockById(links[i].BlockID[1]).ObjName);
                }
            }
            form.Debag("\n" + tab + "Actions", System.Drawing.Color.Green);
            for (int i = 0; i < actions.Count; i++)
            {
                form.Debag( tab + actions[i].ID + "\t" + actions[i].TypeString + "\t" + actions[i].ObjName );
                //actions[i].Show( tabs + 1 );
            }

        }

        public override void Show()
        {
            Show(0);
        }

        public bool IsHaveMulUseAction()
        {
            for(int i = 0;i< actions.Count;i++)
            {
                if(actions[i].IsMulUseProj || actions[i].IsMultiUseLev())
                {
                    return true;
                }
            }
            if(TypeString == "rm")
            {
                for (int i = 0; i < ChildBlocks.Count; i++)
                {
                    if (ChildBlocks[i].TypeString == "zz" )
                    {
                        if(ChildBlocks[i].IsHaveMulUseAction())
                        {
                            return true;
                        }
                    }
                }
            }
            return false;
        }

        public int ActionObjUses( Action act )
        {
            int count = 0;
            for (int i = 0; i < actions.Count; i++)
            {
                if (actions[i].TypeString == "use" && actions[i].ObjName == act.ObjName)
                {
                    count++;
                }
            }
            return count;
        }

    }
}

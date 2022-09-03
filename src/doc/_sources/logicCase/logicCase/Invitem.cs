using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace logicCase
{
    class Invitem
    {
        string name;
        public Dictionary<string, List<Action>> actions = new Dictionary<string, List<Action>>();

        public Invitem(string name)
        {
            this.name = name;
        }

        public string Name { get { return name; } }

        public void AddAction( Action act )
        {
            try
            {
                actions[act.TypeString].Add(act);
            }
            catch
            {
                //program.form.Debag(act.ObjName);
                actions.Add(act.TypeString, new List<Action>());
                actions[act.TypeString].Add(act);
            }
        }
    }
}

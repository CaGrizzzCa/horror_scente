using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace logicCase
{
    class Link:Propobj
    {
        int id;
        int type;
        public Scheme scheme;

        int[] blockID = new int[2];
            public int[] BlockID { get { return blockID; } }

        public Link(string str)
            : base(str)
        {
            try
            {
                type = Convert.ToInt16(properties["type"]);
                id = Convert.ToInt16(properties["id"]);
                blockID[0] = Convert.ToInt16(properties["source_block"]);
                blockID[1] = Convert.ToInt16(properties["destination_block"]);
                //form.Debag("for link " + id + "\t" + blockID[0] + "," + blockID[1]);
            }
            catch
            {
                form.Debag("wrong link " + str, System.Drawing.Color.Red);
            }
        }

        public int ID
        {
            get{
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

    }
}

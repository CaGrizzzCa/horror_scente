using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace logicCase
{
    class ActionComareOwner:IComparer<Action>
    {
        public int Compare(Action a1, Action a2)
        {
            if (a1.ownerBlock.TypeString == a2.ownerBlock.TypeString && a1.ownerBlock.TypeString == "rm")
            {
                return a1.ownerBlock.FullName.CompareTo(a2.ownerBlock.FullName);
            }
            else if (a1.ownerBlock.TypeString == "rm" && a2.ownerBlock.TypeString != "rm" )
            {
                if (a2.ownerBlock.TypeString == "inv")
                    return -1;
                else
                {
                    if (a1.ownerBlock.FullName.CompareTo(a2.ownerBlock.OwnerBlock.FullName) == 0)
                        return -1;
                    else
                        return a1.ownerBlock.FullName.CompareTo(a2.ownerBlock.OwnerBlock.FullName);
                }
            }
            else if (a1.ownerBlock.TypeString != "rm" && a2.ownerBlock.TypeString == "rm")
            {
                if (a1.ownerBlock.TypeString == "inv")
                    return 1;
                else
                {
                    if (a2.ownerBlock.FullName.CompareTo(a1.ownerBlock.OwnerBlock.FullName) == 0)
                        return 1;
                    else
                        return a1.ownerBlock.OwnerBlock.FullName.CompareTo(a2.ownerBlock.FullName);
                }
            }
            else if (a1.ownerBlock.TypeString != "rm" && a2.ownerBlock.TypeString != "rm") 
            {
                if (a1.ownerBlock.TypeString == "inv" && a2.ownerBlock.TypeString == "inv")
                    return a1.ownerBlock.FullName.CompareTo(a2.ownerBlock.FullName);
                else if (a1.ownerBlock.TypeString == "inv")
                    return 1;
                else if (a2.ownerBlock.TypeString == "inv")
                    return -1;
                else
                    if (a1.ownerBlock.OwnerBlock.FullName.CompareTo(a2.ownerBlock.OwnerBlock.FullName) == 0)
                    {
                        if (a1.ownerBlock.FullName.CompareTo(a2.ownerBlock.FullName) == 0)
                            return a1.ID.CompareTo(a2.ID);
                        else
                            return a1.ownerBlock.FullName.CompareTo(a2.ownerBlock.FullName);
                    }
                    else
                        return a1.ownerBlock.OwnerBlock.FullName.CompareTo(a2.ownerBlock.OwnerBlock.FullName);
            }

            return 0;
        }
    }
}

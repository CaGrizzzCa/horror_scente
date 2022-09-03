using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Drawing;

namespace logicCase
{
    public class LineClass
    {
        public static Form1 FormRef;
        Point locOwner;
        Point locChild;
        Point olocOwner;
        Point olocChild;
        Pen p;
        Pen op;
        MyControl owner;
        MyControl child;

        public LineClass(MyControl owner)
        {
            FormRef.richTextBox1.AppendText(" line constractor " + "\n");
            this.owner = owner;
            this.olocOwner = new Point(owner.Location.X, owner.Location.Y);
            this.olocChild = new Point(owner.Location.X, owner.Location.Y);
            this.locOwner = new Point(owner.Location.X, owner.Location.Y);
            this.locChild = new Point(owner.Location.X, owner.Location.Y);
            op = new Pen(FormRef.BackColor);
            if (child.GetOwnerObj().getNamePrefix() == "zz")
            {
                p = new Pen(Color.LightGray);
                p.Width = 2;
                op.Width = 2;
            }
            else if (child.GetOwnerObj().getNamePrefix() == "rm")
            {
                p = new Pen(Color.LightSlateGray);
                p.Width = 4;
                op.Width = 4;
            }
        }


        public void ReloadLoc()
        {
            if ( owner!=null & child!=null & p!=null)
            {
                //Graphics g = FormRef.CreateGraphics();
                //Point p1 = new Point(this.olocOwner.X + owner.Width / 2, this.olocOwner.Y + owner.Height / 2);
                //Point p2 = new Point(this.olocChild.X + child.Width / 2, this.olocChild.Y + child.Height / 2);
                //g.DrawLine(op, p1, p2);
                this.olocOwner = new Point(this.olocOwner.X + owner.Width / 2, this.olocOwner.Y + owner.Height / 2);
                this.olocChild = new Point(this.olocChild.X + child.Width / 2, this.olocChild.Y + child.Height / 2);
                /*
                this.locOwner = new Point(this.locOwner.X, this.locOwner.Y);
                this.locChild = new Point(this.locChild.X, this.locChild.Y);

                Point p1 = new Point(this.olocOwner.X + owner.Width / 2, this.olocOwner.Y + owner.Height / 2);
                Point p2 = new Point(this.olocChild.X + child.Width / 2, this.olocChild.Y + child.Height / 2);
                this.locOwner = p1;
                this.locChild = p2;
                 * */
                //g.DrawLine(p, p1, p2);

                //FormRef.richTextBox1.AppendText("drawing from " + owner.GetOwnerObj().GetName() + " to " + child.GetOwnerObj().GetName() +"\n");
                //FormRef.richTextBox1.Select();
                //FormRef.richTextBox1.ScrollToCaret();
            }
        }

        public void DrawLine(Graphics g)
        {
            if ( owner != null & child != null & p != null)
            {
                g.DrawLine(op, olocOwner, olocChild);
                Point p1 = new Point(this.owner.Location.X + owner.Width / 2, this.owner.Location.Y + owner.Height / 2);
                Point p2 = new Point(this.child.Location.X + child.Width / 2, this.child.Location.Y + child.Height / 2);
                g.DrawLine(p, p1,p2);
            }
        }

        public void Attaching(MyControl at)
        {
            child = at;
        }
    }
}

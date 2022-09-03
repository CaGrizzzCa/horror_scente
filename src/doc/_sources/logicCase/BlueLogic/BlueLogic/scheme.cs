using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Drawing;

namespace BlueLogic
{
    // Class of a one block of the scheme
    public class schemeBlockClass : Panel
    {
        private string _prefix;
        private string _name;
        private string _Progress;

        private Label lblName = new Label();
        private List<Label> lblProgress = new List<Label>();

        public schemeBlockClass(string prefix, string name, string localProgress)
        {
            int width = 100;
            int height = 100;
            this.Size = new Size(width, height);
            this.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.BackColor = Color.Wheat;
            this.AutoScroll = false;

            _prefix = prefix;
            _name = name;
            _Progress = localProgress;

            lblName.Text = _prefix + "_" + _name;
            lblName.BackColor = Color.White;
            lblName.Font = new Font("Times New Roman", 12, FontStyle.Regular);
            lblName.Width = width - 6;
            lblName.Location = new Point(3, 3);
            this.Controls.Add(lblName);

            int prgNum = -1;
            //foreach (progressItemClass prg in localProgress)
            //{
                prgNum++;
                lblProgress.Add(new Label());

                lblProgress[prgNum].Text = localProgress; //prg.actionType + "_" + prg.actionObject;

                lblProgress[prgNum].BackColor = Color.Wheat;
                lblProgress[prgNum].Font = new Font("Times New Roman", 10, FontStyle.Regular);
                lblProgress[prgNum].AutoSize = true;
                lblProgress[prgNum].Location = new Point(3, 30 + 25*prgNum);
                this.Controls.Add(lblProgress[prgNum]);
            //}       
        }

        public void setLocation(int x, int y)
        {
            this.Location = new Point(x, y);
        }

    }

    // Class of the scheme
    public class schemeClass : Panel
    {
        public List<schemeBlockClass> blocks = new List<schemeBlockClass>();
        gameLogic _logic;

        public schemeClass(gameLogic logic)
        {
            this.Size = new Size(500, 500);
            this.Location = new Point(0, 0);
            this.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.BackColor = Color.White;
            this.AutoScroll = false;

            _logic = logic;
            refresh();
        }

        public void addJunction(int first, int second)
        { 
        
        }

        public void clear()
        {
            foreach (schemeBlockClass block in blocks)
            {
                this.Controls.Remove(block);
            }
            blocks.Clear();
        }

        public void refresh()
        {
            int blockNum = -1;
            foreach (roomClass rm in _logic.rooms.getRooms())
            {
                blockNum++;
                blocks.Add(new schemeBlockClass("rm", rm.name, "+ stuff"));
                this.Controls.Add(blocks[blockNum]);
                blocks[blockNum].setLocation(10 + 110 * blockNum, 10);
            }
        }
    }

}

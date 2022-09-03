using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace logicCase
{
    public partial class PositionTXTchanger : Form
    {
        public PositionTXTchanger()
        {
            InitializeComponent();
        }

        private void buttonChange_Click(object sender, EventArgs e)
        {
            int x, y;
            try
            {
                x = Convert.ToInt16(textBox1.Text);
                y = Convert.ToInt16(textBox2.Text);
            }
            catch
            {
                MessageBox.Show("Не удалось конвертировать данные из TextBox в INT");
                return;
            }
            OpenFileDialog ofd = new OpenFileDialog();
            if(ofd.ShowDialog()==DialogResult.OK)
            {
                PositionTXT ptxt = new PositionTXT(ofd.FileName);
                ptxt.MovePositions(x, y);
                ptxt.Save();
                this.Close();
            }
        }
    }
}

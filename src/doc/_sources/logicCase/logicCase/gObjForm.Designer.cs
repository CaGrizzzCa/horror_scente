namespace logicCase
{
    partial class gObjForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.richTextBoxBeg = new System.Windows.Forms.RichTextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.richTextBoxEnd = new System.Windows.Forms.RichTextBox();
            this.SuspendLayout();
            // 
            // richTextBoxBeg
            // 
            this.richTextBoxBeg.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Left | System.Windows.Forms.AnchorStyles.Right)));
            this.richTextBoxBeg.Location = new System.Drawing.Point(12, 28);
            this.richTextBoxBeg.Name = "richTextBoxBeg";
            this.richTextBoxBeg.ReadOnly = true;
            this.richTextBoxBeg.Size = new System.Drawing.Size(459, 125);
            this.richTextBoxBeg.TabIndex = 0;
            this.richTextBoxBeg.Text = "";
            this.richTextBoxBeg.Click += new System.EventHandler(this.richTextBoxBeg_Click);
            this.richTextBoxBeg.DoubleClick += new System.EventHandler(this.richTextBoxBeg_DoubleClick);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(12, 12);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(28, 13);
            this.label1.TabIndex = 1;
            this.label1.Text = "fbeg";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(9, 170);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(28, 13);
            this.label2.TabIndex = 2;
            this.label2.Text = "fend";
            // 
            // richTextBoxEnd
            // 
            this.richTextBoxEnd.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Left | System.Windows.Forms.AnchorStyles.Right)));
            this.richTextBoxEnd.Location = new System.Drawing.Point(12, 199);
            this.richTextBoxEnd.Name = "richTextBoxEnd";
            this.richTextBoxEnd.ReadOnly = true;
            this.richTextBoxEnd.Size = new System.Drawing.Size(459, 130);
            this.richTextBoxEnd.TabIndex = 3;
            this.richTextBoxEnd.Text = "";
            this.richTextBoxEnd.DoubleClick += new System.EventHandler(this.richTextBoxEnd_DoubleClick);
            // 
            // gObjForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(483, 354);
            this.Controls.Add(this.richTextBoxEnd);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.richTextBoxBeg);
            this.Name = "gObjForm";
            this.Text = "gObjForm";
            this.FormClosed += new System.Windows.Forms.FormClosedEventHandler(this.gObjForm_FormClosed);
            this.Shown += new System.EventHandler(this.gObjForm_Shown);
            this.SizeChanged += new System.EventHandler(this.gObjForm_SizeChanged);
            this.MouseDown += new System.Windows.Forms.MouseEventHandler(this.gObjForm_MouseDown);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.RichTextBox richTextBoxBeg;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.RichTextBox richTextBoxEnd;
    }
}
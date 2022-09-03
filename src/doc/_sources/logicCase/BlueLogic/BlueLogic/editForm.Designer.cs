namespace BlueLogic
{
    partial class editForm
    {
        /// <summary>
        /// Требуется переменная конструктора.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Освободить все используемые ресурсы.
        /// </summary>
        /// <param name="disposing">истинно, если управляемый ресурс должен быть удален; иначе ложно.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Код, автоматически созданный конструктором форм Windows

        /// <summary>
        /// Обязательный метод для поддержки конструктора - не изменяйте
        /// содержимое данного метода при помощи редактора кода.
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(editForm));
            this.openFileDialog = new System.Windows.Forms.OpenFileDialog();
            this.tabControl = new System.Windows.Forms.TabControl();
            this.tabPage1 = new System.Windows.Forms.TabPage();
            this.devider = new System.Windows.Forms.Panel();
            this.label2 = new System.Windows.Forms.Label();
            this.label1 = new System.Windows.Forms.Label();
            this.tabPage3 = new System.Windows.Forms.TabPage();
            this.tabPage2 = new System.Windows.Forms.TabPage();
            this.toolStrip = new System.Windows.Forms.ToolStrip();
            this.btnSave = new System.Windows.Forms.ToolStripButton();
            this.btnOpen = new System.Windows.Forms.ToolStripButton();
            this.btnNew = new System.Windows.Forms.ToolStripButton();
            this.toolStripSeparator1 = new System.Windows.Forms.ToolStripSeparator();
            this.btnExport = new System.Windows.Forms.ToolStripButton();
            this.btnPrint = new System.Windows.Forms.ToolStripButton();
            this.saveFileDialog = new System.Windows.Forms.SaveFileDialog();
            this.richTextBoxLog = new System.Windows.Forms.RichTextBox();
            this.richTextBoxRight1 = new System.Windows.Forms.RichTextBox();
            this.richTextBoxRight2 = new System.Windows.Forms.RichTextBox();
            this.richTextBoxRight3 = new System.Windows.Forms.RichTextBox();
            this.panel1 = new System.Windows.Forms.Panel();
            this.btnClearLog = new System.Windows.Forms.Button();
            this.btnPinLog = new System.Windows.Forms.Button();
            this.tabControl.SuspendLayout();
            this.tabPage1.SuspendLayout();
            this.toolStrip.SuspendLayout();
            this.panel1.SuspendLayout();
            this.SuspendLayout();
            // 
            // openFileDialog
            // 
            this.openFileDialog.FileName = "openFileDialog1";
            this.openFileDialog.RestoreDirectory = true;
            this.openFileDialog.FileOk += new System.ComponentModel.CancelEventHandler(this.openFileDialog_FileOk);
            // 
            // tabControl
            // 
            this.tabControl.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.tabControl.Controls.Add(this.tabPage1);
            this.tabControl.Controls.Add(this.tabPage3);
            this.tabControl.Controls.Add(this.tabPage2);
            this.tabControl.Location = new System.Drawing.Point(2, 28);
            this.tabControl.Name = "tabControl";
            this.tabControl.RightToLeft = System.Windows.Forms.RightToLeft.No;
            this.tabControl.SelectedIndex = 0;
            this.tabControl.Size = new System.Drawing.Size(1126, 650);
            this.tabControl.TabIndex = 12;
            // 
            // tabPage1
            // 
            this.tabPage1.Controls.Add(this.devider);
            this.tabPage1.Controls.Add(this.label2);
            this.tabPage1.Controls.Add(this.label1);
            this.tabPage1.Location = new System.Drawing.Point(4, 22);
            this.tabPage1.Name = "tabPage1";
            this.tabPage1.Padding = new System.Windows.Forms.Padding(3);
            this.tabPage1.Size = new System.Drawing.Size(1118, 624);
            this.tabPage1.TabIndex = 0;
            this.tabPage1.Text = "Списки";
            this.tabPage1.UseVisualStyleBackColor = true;
            // 
            // devider
            // 
            this.devider.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left)));
            this.devider.BackColor = System.Drawing.Color.LightGray;
            this.devider.Location = new System.Drawing.Point(333, 6);
            this.devider.Name = "devider";
            this.devider.Size = new System.Drawing.Size(1, 615);
            this.devider.TabIndex = 10;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(35, 7);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(102, 13);
            this.label2.TabIndex = 9;
            this.label2.Text = "Список предметов";
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(374, 7);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(84, 13);
            this.label1.TabIndex = 8;
            this.label1.Text = "Список комнат";
            // 
            // tabPage3
            // 
            this.tabPage3.Location = new System.Drawing.Point(4, 22);
            this.tabPage3.Name = "tabPage3";
            this.tabPage3.Padding = new System.Windows.Forms.Padding(3);
            this.tabPage3.Size = new System.Drawing.Size(1118, 624);
            this.tabPage3.TabIndex = 2;
            this.tabPage3.Text = "Логика";
            this.tabPage3.UseVisualStyleBackColor = true;
            // 
            // tabPage2
            // 
            this.tabPage2.Location = new System.Drawing.Point(4, 22);
            this.tabPage2.Name = "tabPage2";
            this.tabPage2.Padding = new System.Windows.Forms.Padding(3);
            this.tabPage2.Size = new System.Drawing.Size(1118, 624);
            this.tabPage2.TabIndex = 1;
            this.tabPage2.Text = "Схема";
            this.tabPage2.UseVisualStyleBackColor = true;
            // 
            // toolStrip
            // 
            this.toolStrip.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.btnSave,
            this.btnOpen,
            this.btnNew,
            this.toolStripSeparator1,
            this.btnExport,
            this.btnPrint});
            this.toolStrip.Location = new System.Drawing.Point(0, 0);
            this.toolStrip.Name = "toolStrip";
            this.toolStrip.Size = new System.Drawing.Size(1490, 25);
            this.toolStrip.TabIndex = 15;
            this.toolStrip.Text = "toolStrip";
            // 
            // btnSave
            // 
            this.btnSave.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.btnSave.Image = ((System.Drawing.Image)(resources.GetObject("btnSave.Image")));
            this.btnSave.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.btnSave.Name = "btnSave";
            this.btnSave.Size = new System.Drawing.Size(23, 22);
            this.btnSave.Text = "Сохранить";
            this.btnSave.Click += new System.EventHandler(this.btnSave_Click);
            // 
            // btnOpen
            // 
            this.btnOpen.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.btnOpen.Image = ((System.Drawing.Image)(resources.GetObject("btnOpen.Image")));
            this.btnOpen.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.btnOpen.Name = "btnOpen";
            this.btnOpen.Size = new System.Drawing.Size(23, 22);
            this.btnOpen.Text = "Открыть";
            this.btnOpen.Click += new System.EventHandler(this.btnOpen_Click);
            // 
            // btnNew
            // 
            this.btnNew.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.btnNew.Image = ((System.Drawing.Image)(resources.GetObject("btnNew.Image")));
            this.btnNew.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.btnNew.Name = "btnNew";
            this.btnNew.Size = new System.Drawing.Size(23, 22);
            this.btnNew.Text = "Новый";
            this.btnNew.Click += new System.EventHandler(this.btnNew_Click);
            // 
            // toolStripSeparator1
            // 
            this.toolStripSeparator1.Name = "toolStripSeparator1";
            this.toolStripSeparator1.Size = new System.Drawing.Size(6, 25);
            // 
            // btnExport
            // 
            this.btnExport.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.btnExport.Image = ((System.Drawing.Image)(resources.GetObject("btnExport.Image")));
            this.btnExport.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.btnExport.Name = "btnExport";
            this.btnExport.Size = new System.Drawing.Size(23, 22);
            this.btnExport.Text = "Экспорт в XLS";
            this.btnExport.Click += new System.EventHandler(this.btnExport_Click);
            // 
            // btnPrint
            // 
            this.btnPrint.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.btnPrint.Image = ((System.Drawing.Image)(resources.GetObject("btnPrint.Image")));
            this.btnPrint.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.btnPrint.Name = "btnPrint";
            this.btnPrint.Size = new System.Drawing.Size(23, 22);
            this.btnPrint.Text = "Печатать схему";
            this.btnPrint.Click += new System.EventHandler(this.btnPrint_Click);
            // 
            // saveFileDialog
            // 
            this.saveFileDialog.RestoreDirectory = true;
            this.saveFileDialog.FileOk += new System.ComponentModel.CancelEventHandler(this.saveFileDialog_FileOk);
            // 
            // richTextBoxLog
            // 
            this.richTextBoxLog.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.richTextBoxLog.BackColor = System.Drawing.Color.White;
            this.richTextBoxLog.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.richTextBoxLog.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.richTextBoxLog.ForeColor = System.Drawing.Color.Black;
            this.richTextBoxLog.Location = new System.Drawing.Point(2, 680);
            this.richTextBoxLog.Name = "richTextBoxLog";
            this.richTextBoxLog.ReadOnly = true;
            this.richTextBoxLog.ScrollBars = System.Windows.Forms.RichTextBoxScrollBars.Vertical;
            this.richTextBoxLog.Size = new System.Drawing.Size(1124, 160);
            this.richTextBoxLog.TabIndex = 17;
            this.richTextBoxLog.Text = "";
            // 
            // richTextBoxRight1
            // 
            this.richTextBoxRight1.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.richTextBoxRight1.BackColor = System.Drawing.Color.White;
            this.richTextBoxRight1.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.richTextBoxRight1.Location = new System.Drawing.Point(3, 3);
            this.richTextBoxRight1.Name = "richTextBoxRight1";
            this.richTextBoxRight1.ReadOnly = true;
            this.richTextBoxRight1.Size = new System.Drawing.Size(110, 786);
            this.richTextBoxRight1.TabIndex = 18;
            this.richTextBoxRight1.Text = "";
            this.richTextBoxRight1.WordWrap = false;
            // 
            // richTextBoxRight2
            // 
            this.richTextBoxRight2.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.richTextBoxRight2.BackColor = System.Drawing.Color.White;
            this.richTextBoxRight2.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.richTextBoxRight2.Location = new System.Drawing.Point(119, 3);
            this.richTextBoxRight2.Name = "richTextBoxRight2";
            this.richTextBoxRight2.ReadOnly = true;
            this.richTextBoxRight2.Size = new System.Drawing.Size(110, 786);
            this.richTextBoxRight2.TabIndex = 19;
            this.richTextBoxRight2.Text = "";
            this.richTextBoxRight2.WordWrap = false;
            // 
            // richTextBoxRight3
            // 
            this.richTextBoxRight3.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.richTextBoxRight3.BackColor = System.Drawing.Color.White;
            this.richTextBoxRight3.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.richTextBoxRight3.Location = new System.Drawing.Point(235, 3);
            this.richTextBoxRight3.Name = "richTextBoxRight3";
            this.richTextBoxRight3.ReadOnly = true;
            this.richTextBoxRight3.Size = new System.Drawing.Size(110, 786);
            this.richTextBoxRight3.TabIndex = 21;
            this.richTextBoxRight3.Text = "";
            this.richTextBoxRight3.WordWrap = false;
            // 
            // panel1
            // 
            this.panel1.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.panel1.BackColor = System.Drawing.Color.White;
            this.panel1.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.panel1.Controls.Add(this.richTextBoxRight1);
            this.panel1.Controls.Add(this.richTextBoxRight2);
            this.panel1.Controls.Add(this.richTextBoxRight3);
            this.panel1.Location = new System.Drawing.Point(1130, 48);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(358, 792);
            this.panel1.TabIndex = 24;
            // 
            // btnClearLog
            // 
            this.btnClearLog.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this.btnClearLog.BackColor = System.Drawing.Color.White;
            this.btnClearLog.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("btnClearLog.BackgroundImage")));
            this.btnClearLog.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Center;
            this.btnClearLog.FlatAppearance.BorderColor = System.Drawing.Color.White;
            this.btnClearLog.FlatAppearance.BorderSize = 0;
            this.btnClearLog.FlatAppearance.MouseDownBackColor = System.Drawing.Color.White;
            this.btnClearLog.FlatAppearance.MouseOverBackColor = System.Drawing.Color.White;
            this.btnClearLog.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.btnClearLog.Location = new System.Drawing.Point(6, 685);
            this.btnClearLog.Name = "btnClearLog";
            this.btnClearLog.Size = new System.Drawing.Size(20, 20);
            this.btnClearLog.TabIndex = 23;
            this.btnClearLog.UseVisualStyleBackColor = false;
            this.btnClearLog.Click += new System.EventHandler(this.btnClearLog_Click);
            this.btnClearLog.MouseEnter += new System.EventHandler(this.btnClearLogMouseEnter);
            this.btnClearLog.MouseLeave += new System.EventHandler(this.btnClearLogMouseLeave);
            // 
            // btnPinLog
            // 
            this.btnPinLog.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.btnPinLog.BackgroundImage = ((System.Drawing.Image)(resources.GetObject("btnPinLog.BackgroundImage")));
            this.btnPinLog.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Center;
            this.btnPinLog.FlatAppearance.BorderColor = System.Drawing.Color.White;
            this.btnPinLog.FlatAppearance.MouseDownBackColor = System.Drawing.Color.White;
            this.btnPinLog.FlatAppearance.MouseOverBackColor = System.Drawing.Color.White;
            this.btnPinLog.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.btnPinLog.Location = new System.Drawing.Point(1009, 684);
            this.btnPinLog.Name = "btnPinLog";
            this.btnPinLog.Size = new System.Drawing.Size(24, 25);
            this.btnPinLog.TabIndex = 22;
            this.btnPinLog.UseVisualStyleBackColor = true;
            this.btnPinLog.Visible = false;
            this.btnPinLog.MouseEnter += new System.EventHandler(this.btnPinLogMouseEnter);
            this.btnPinLog.MouseLeave += new System.EventHandler(this.btnPinLogMouseLeave);
            // 
            // editForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.SystemColors.Control;
            this.ClientSize = new System.Drawing.Size(1490, 843);
            this.Controls.Add(this.btnClearLog);
            this.Controls.Add(this.btnPinLog);
            this.Controls.Add(this.toolStrip);
            this.Controls.Add(this.tabControl);
            this.Controls.Add(this.richTextBoxLog);
            this.Controls.Add(this.panel1);
            this.ForeColor = System.Drawing.Color.Black;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.MinimumSize = new System.Drawing.Size(1024, 600);
            this.Name = "editForm";
            this.Text = "HOPA Logic";
            this.WindowState = System.Windows.Forms.FormWindowState.Maximized;
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.editForm_FormClosing);
            this.Shown += new System.EventHandler(this.editForm_Shown);
            this.tabControl.ResumeLayout(false);
            this.tabPage1.ResumeLayout(false);
            this.tabPage1.PerformLayout();
            this.toolStrip.ResumeLayout(false);
            this.toolStrip.PerformLayout();
            this.panel1.ResumeLayout(false);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.OpenFileDialog openFileDialog;
        private System.Windows.Forms.TabControl tabControl;
        private System.Windows.Forms.TabPage tabPage1;
        private System.Windows.Forms.TabPage tabPage2;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.ToolStrip toolStrip;
        private System.Windows.Forms.ToolStripButton btnSave;
        private System.Windows.Forms.ToolStripButton btnOpen;
        private System.Windows.Forms.ToolStripButton btnNew;
        private System.Windows.Forms.ToolStripSeparator toolStripSeparator1;
        private System.Windows.Forms.ToolStripButton btnExport;
        private System.Windows.Forms.ToolStripButton btnPrint;
        private System.Windows.Forms.SaveFileDialog saveFileDialog;
        private System.Windows.Forms.TabPage tabPage3;
        private System.Windows.Forms.RichTextBox richTextBoxLog;
        private System.Windows.Forms.RichTextBox richTextBoxRight1;
        private System.Windows.Forms.RichTextBox richTextBoxRight2;
        private System.Windows.Forms.RichTextBox richTextBoxRight3;
        private System.Windows.Forms.Button btnPinLog;
        private System.Windows.Forms.Button btnClearLog;
        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.Panel devider;
    }
}


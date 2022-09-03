namespace logicCase {
  partial class Form1 {
    /// <summary>
    /// Требуется переменная конструктора.
    /// </summary>
    private System.ComponentModel.IContainer components = null;

    /// <summary>
    /// Освободить все используемые ресурсы.
    /// </summary>
    /// <param name="disposing">истинно, если управляемый ресурс должен быть удален; иначе ложно.</param>
    protected override void Dispose(bool disposing) {
      if (disposing && (components != null)) {
        components.Dispose();
      }
      base.Dispose(disposing);
    }

    #region Код, автоматически созданный конструктором форм Windows

    /// <summary>
    /// Обязательный метод для поддержки конструктора - не изменяйте
    /// содержимое данного метода при помощи редактора кода.
    /// </summary>
    private void InitializeComponent() {
      System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(
            Form1));
      this.richTextBox1 = new System.Windows.Forms.RichTextBox();
      this.buttonDebag = new System.Windows.Forms.Button();
      this.panel1 = new System.Windows.Forms.Panel();
      this.button2 = new System.Windows.Forms.Button();
      this.label1 = new System.Windows.Forms.Label();
      this.textBox1 = new System.Windows.Forms.TextBox();
      this.button1 = new System.Windows.Forms.Button();
      this.buttonCompare = new System.Windows.Forms.Button();
      this.buttonLevLogicBuild = new System.Windows.Forms.Button();
      this.buttonRestart = new System.Windows.Forms.Button();
      this.buttonRessCheck = new System.Windows.Forms.Button();
      this.buttonSave = new System.Windows.Forms.Button();
      this.progressBar1 = new System.Windows.Forms.ProgressBar();
      this.openFileDialogLoadLogic = new System.Windows.Forms.OpenFileDialog();
      this.treeView1 = new System.Windows.Forms.TreeView();
      this.menuStrip1 = new System.Windows.Forms.MenuStrip();
      this.FailToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
      this.LoadToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
      this.LevelToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
      this.findFolderToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
      this.уровеньlevToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
      this.сохранитьToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
      this.iNFOToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
      this.ресурсыToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
      this.checkResByModulesToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
      this.actionsToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
      this.cloneObjFinderToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
      this.trigersToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
      this.addReplaceToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
      this.checkObjWrongLocationToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
      this.addfunclogicToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
      this.gameHintObjActionsToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
      this.bBTcheckToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
      this.localFuncCheckToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
      this.noSFXfinderToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
      this.zZDeployToSprGmToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
      this.checkChetnostToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
      this.getUsedFontsToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
      this.bigPngFinderToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
      this.fXresCheckerToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
      this.showFunctionsToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
      this.showLevelSoundSchemeToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
      this.positionMovecoordinatesToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
      this.animXMLConvertToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
      this.autoSortControlsToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
      this.addPazlesToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
      this.checkBoxUnsafeLoading = new System.Windows.Forms.CheckBox();
      this.panel1.SuspendLayout();
      this.menuStrip1.SuspendLayout();
      this.SuspendLayout();
      //
      // richTextBox1
      //
      this.richTextBox1.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top |
                                  System.Windows.Forms.AnchorStyles.Bottom)
                                  | System.Windows.Forms.AnchorStyles.Left)
                                  | System.Windows.Forms.AnchorStyles.Right)));
      this.richTextBox1.Font = new System.Drawing.Font("Microsoft Sans Serif", 11F, System.Drawing.FontStyle.Regular,
          System.Drawing.GraphicsUnit.Point, ((byte)(204)));
      this.richTextBox1.Location = new System.Drawing.Point(48, 90);
      this.richTextBox1.Name = "richTextBox1";
      this.richTextBox1.ReadOnly = true;
      this.richTextBox1.RightMargin = 999;
      this.richTextBox1.Size = new System.Drawing.Size(1067, 521);
      this.richTextBox1.TabIndex = 0;
      this.richTextBox1.TabStop = false;
      this.richTextBox1.Text = "";
      this.richTextBox1.Visible = false;
      //
      // buttonDebag
      //
      this.buttonDebag.Location = new System.Drawing.Point(64, 3);
      this.buttonDebag.Name = "buttonDebag";
      this.buttonDebag.Size = new System.Drawing.Size(58, 23);
      this.buttonDebag.TabIndex = 1;
      this.buttonDebag.Text = "Log";
      this.buttonDebag.UseVisualStyleBackColor = true;
      this.buttonDebag.Click += new System.EventHandler(this.button1_Click);
      //
      // panel1
      //
      this.panel1.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top |
                            System.Windows.Forms.AnchorStyles.Left)
                            | System.Windows.Forms.AnchorStyles.Right)));
      this.panel1.BackColor = System.Drawing.SystemColors.ScrollBar;
      this.panel1.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
      this.panel1.Controls.Add(this.button2);
      this.panel1.Controls.Add(this.label1);
      this.panel1.Controls.Add(this.textBox1);
      this.panel1.Controls.Add(this.button1);
      this.panel1.Controls.Add(this.buttonCompare);
      this.panel1.Controls.Add(this.buttonLevLogicBuild);
      this.panel1.Controls.Add(this.buttonRestart);
      this.panel1.Controls.Add(this.buttonRessCheck);
      this.panel1.Controls.Add(this.buttonSave);
      this.panel1.Controls.Add(this.progressBar1);
      this.panel1.Controls.Add(this.buttonDebag);
      this.panel1.Location = new System.Drawing.Point(12, 27);
      this.panel1.Name = "panel1";
      this.panel1.Size = new System.Drawing.Size(1103, 63);
      this.panel1.TabIndex = 2;
      this.panel1.Resize += new System.EventHandler(this.panel1_Resize);
      //
      // button2
      //
      this.button2.Location = new System.Drawing.Point(453, 3);
      this.button2.Name = "button2";
      this.button2.Size = new System.Drawing.Size(75, 23);
      this.button2.TabIndex = 15;
      this.button2.Text = "ClearRegistr";
      this.button2.UseVisualStyleBackColor = true;
      this.button2.Click += new System.EventHandler(this.button2_Click);
      //
      // label1
      //
      this.label1.AutoSize = true;
      this.label1.Location = new System.Drawing.Point(143, 35);
      this.label1.Name = "label1";
      this.label1.Size = new System.Drawing.Size(39, 13);
      this.label1.TabIndex = 14;
      this.label1.Text = "Поиск";
      //
      // textBox1
      //
      this.textBox1.Location = new System.Drawing.Point(3, 32);
      this.textBox1.Name = "textBox1";
      this.textBox1.Size = new System.Drawing.Size(134, 20);
      this.textBox1.TabIndex = 13;
      this.textBox1.KeyUp += new System.Windows.Forms.KeyEventHandler(this.textBox1_KeyUp);
      //
      // button1
      //
      this.button1.Location = new System.Drawing.Point(372, 3);
      this.button1.Name = "button1";
      this.button1.Size = new System.Drawing.Size(75, 23);
      this.button1.TabIndex = 12;
      this.button1.Text = "button1";
      this.button1.UseVisualStyleBackColor = true;
      this.button1.Click += new System.EventHandler(this.button1_Click_3);
      //
      // buttonCompare
      //
      this.buttonCompare.Location = new System.Drawing.Point(298, 3);
      this.buttonCompare.Name = "buttonCompare";
      this.buttonCompare.Size = new System.Drawing.Size(67, 23);
      this.buttonCompare.TabIndex = 11;
      this.buttonCompare.Text = "CompareStrings";
      this.buttonCompare.UseVisualStyleBackColor = true;
      this.buttonCompare.Click += new System.EventHandler(this.buttonCompare_Click);
      //
      // buttonLevLogicBuild
      //
      this.buttonLevLogicBuild.Location = new System.Drawing.Point(209, 3);
      this.buttonLevLogicBuild.Name = "buttonLevLogicBuild";
      this.buttonLevLogicBuild.Size = new System.Drawing.Size(83, 23);
      this.buttonLevLogicBuild.TabIndex = 10;
      this.buttonLevLogicBuild.Text = "LevLogicBuild";
      this.buttonLevLogicBuild.UseVisualStyleBackColor = true;
      this.buttonLevLogicBuild.Click += new System.EventHandler(this.buttonLevLogicBuild_Click);
      //
      // buttonRestart
      //
      this.buttonRestart.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top |
                                   System.Windows.Forms.AnchorStyles.Right)));
      this.buttonRestart.Location = new System.Drawing.Point(1021, 3);
      this.buttonRestart.Name = "buttonRestart";
      this.buttonRestart.Size = new System.Drawing.Size(75, 23);
      this.buttonRestart.TabIndex = 9;
      this.buttonRestart.Text = "Restart";
      this.buttonRestart.UseVisualStyleBackColor = true;
      this.buttonRestart.Click += new System.EventHandler(this.buttonRestart_Click);
      //
      // buttonRessCheck
      //
      this.buttonRessCheck.Location = new System.Drawing.Point(128, 3);
      this.buttonRessCheck.Name = "buttonRessCheck";
      this.buttonRessCheck.Size = new System.Drawing.Size(75, 23);
      this.buttonRessCheck.TabIndex = 8;
      this.buttonRessCheck.Text = "RessCheck";
      this.buttonRessCheck.UseVisualStyleBackColor = true;
      this.buttonRessCheck.Click += new System.EventHandler(this.buttonRessCheck_Click);
      //
      // buttonSave
      //
      this.buttonSave.Location = new System.Drawing.Point(3, 3);
      this.buttonSave.Name = "buttonSave";
      this.buttonSave.Size = new System.Drawing.Size(55, 23);
      this.buttonSave.TabIndex = 4;
      this.buttonSave.Text = "Save";
      this.buttonSave.UseVisualStyleBackColor = true;
      this.buttonSave.Click += new System.EventHandler(this.buttonSave_Click);
      //
      // progressBar1
      //
      this.progressBar1.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top |
                                  System.Windows.Forms.AnchorStyles.Bottom)
                                  | System.Windows.Forms.AnchorStyles.Left)
                                  | System.Windows.Forms.AnchorStyles.Right)));
      this.progressBar1.Location = new System.Drawing.Point(3, 32);
      this.progressBar1.MarqueeAnimationSpeed = 500;
      this.progressBar1.Maximum = 20;
      this.progressBar1.Name = "progressBar1";
      this.progressBar1.Size = new System.Drawing.Size(1093, 23);
      this.progressBar1.Step = 1;
      this.progressBar1.TabIndex = 3;
      //
      // openFileDialogLoadLogic
      //
      this.openFileDialogLoadLogic.FileName = "openFileDialog1";
      this.openFileDialogLoadLogic.RestoreDirectory = true;
      this.openFileDialogLoadLogic.FileOk += new System.ComponentModel.CancelEventHandler(
          this.openFileDialogLoadLogic_FileOk);
      //
      // treeView1
      //
      this.treeView1.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top |
                               System.Windows.Forms.AnchorStyles.Bottom)
                               | System.Windows.Forms.AnchorStyles.Left)));
      this.treeView1.FullRowSelect = true;
      this.treeView1.Location = new System.Drawing.Point(12, 90);
      this.treeView1.Name = "treeView1";
      this.treeView1.Size = new System.Drawing.Size(30, 521);
      this.treeView1.TabIndex = 3;
      this.treeView1.TabStop = false;
      this.treeView1.MouseEnter += new System.EventHandler(this.treeView1_MouseEnter);
      this.treeView1.MouseLeave += new System.EventHandler(this.treeView1_MouseLeave);
      //
      // menuStrip1
      //
      this.menuStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
        this.FailToolStripMenuItem,
        this.ресурсыToolStripMenuItem,
        this.actionsToolStripMenuItem
      });
      this.menuStrip1.Location = new System.Drawing.Point(0, 0);
      this.menuStrip1.Name = "menuStrip1";
      this.menuStrip1.Size = new System.Drawing.Size(1127, 24);
      this.menuStrip1.TabIndex = 4;
      this.menuStrip1.Text = "menuStrip1";
      //
      // FailToolStripMenuItem
      //
      this.FailToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
        this.LoadToolStripMenuItem,
        this.сохранитьToolStripMenuItem,
        this.iNFOToolStripMenuItem
      });
      this.FailToolStripMenuItem.Name = "FailToolStripMenuItem";
      this.FailToolStripMenuItem.Size = new System.Drawing.Size(48, 20);
      this.FailToolStripMenuItem.Text = "Файл";
      //
      // LoadToolStripMenuItem
      //
      this.LoadToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
        this.LevelToolStripMenuItem,
        this.уровеньlevToolStripMenuItem
      });
      this.LoadToolStripMenuItem.Name = "LoadToolStripMenuItem";
      this.LoadToolStripMenuItem.Size = new System.Drawing.Size(168, 22);
      this.LoadToolStripMenuItem.Text = "Загрузить Ctrl+L";
      //
      // LevelToolStripMenuItem
      //
      this.LevelToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
        this.findFolderToolStripMenuItem
      });
      this.LevelToolStripMenuItem.Name = "LevelToolStripMenuItem";
      this.LevelToolStripMenuItem.Size = new System.Drawing.Size(151, 22);
      this.LevelToolStripMenuItem.Text = "Уровень игры";
      //
      // findFolderToolStripMenuItem
      //
      this.findFolderToolStripMenuItem.Name = "findFolderToolStripMenuItem";
      this.findFolderToolStripMenuItem.Size = new System.Drawing.Size(130, 22);
      this.findFolderToolStripMenuItem.Text = "FindFolder";
      this.findFolderToolStripMenuItem.Click += new System.EventHandler(this.findFolderToolStripMenuItem_Click);
      //
      // уровеньlevToolStripMenuItem
      //
      this.уровеньlevToolStripMenuItem.Name = "уровеньlevToolStripMenuItem";
      this.уровеньlevToolStripMenuItem.Size = new System.Drawing.Size(151, 22);
      this.уровеньlevToolStripMenuItem.Text = "уровень.lev";
      this.уровеньlevToolStripMenuItem.Click += new System.EventHandler(this.уровеньlevToolStripMenuItem_Click);
      //
      // сохранитьToolStripMenuItem
      //
      this.сохранитьToolStripMenuItem.Name = "сохранитьToolStripMenuItem";
      this.сохранитьToolStripMenuItem.Size = new System.Drawing.Size(168, 22);
      this.сохранитьToolStripMenuItem.Text = "Сохранить Ctrl+S";
      //
      // iNFOToolStripMenuItem
      //
      this.iNFOToolStripMenuItem.Name = "iNFOToolStripMenuItem";
      this.iNFOToolStripMenuItem.Size = new System.Drawing.Size(168, 22);
      this.iNFOToolStripMenuItem.Text = "INFO";
      this.iNFOToolStripMenuItem.Click += new System.EventHandler(this.iNFOToolStripMenuItem_Click);
      //
      // ресурсыToolStripMenuItem
      //
      this.ресурсыToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
        this.checkResByModulesToolStripMenuItem
      });
      this.ресурсыToolStripMenuItem.Enabled = false;
      this.ресурсыToolStripMenuItem.Name = "ресурсыToolStripMenuItem";
      this.ресурсыToolStripMenuItem.Size = new System.Drawing.Size(66, 20);
      this.ресурсыToolStripMenuItem.Text = "Ресурсы";
      //
      // checkResByModulesToolStripMenuItem
      //
      this.checkResByModulesToolStripMenuItem.Name = "checkResByModulesToolStripMenuItem";
      this.checkResByModulesToolStripMenuItem.Size = new System.Drawing.Size(184, 22);
      this.checkResByModulesToolStripMenuItem.Text = "CheckResByModules";
      this.checkResByModulesToolStripMenuItem.Click += new System.EventHandler(this.checkResByModulesToolStripMenuItem_Click);
      //
      // actionsToolStripMenuItem
      //
      this.actionsToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
        this.cloneObjFinderToolStripMenuItem,
        this.trigersToolStripMenuItem,
        this.checkObjWrongLocationToolStripMenuItem,
        this.addfunclogicToolStripMenuItem,
        this.gameHintObjActionsToolStripMenuItem,
        this.bBTcheckToolStripMenuItem,
        this.localFuncCheckToolStripMenuItem,
        this.noSFXfinderToolStripMenuItem,
        this.zZDeployToSprGmToolStripMenuItem,
        this.checkChetnostToolStripMenuItem,
        this.getUsedFontsToolStripMenuItem,
        this.bigPngFinderToolStripMenuItem,
        this.fXresCheckerToolStripMenuItem,
        this.showFunctionsToolStripMenuItem,
        this.showLevelSoundSchemeToolStripMenuItem,
        this.positionMovecoordinatesToolStripMenuItem,
        this.animXMLConvertToolStripMenuItem,
        this.autoSortControlsToolStripMenuItem,
        this.addPazlesToolStripMenuItem
      });
      this.actionsToolStripMenuItem.Name = "actionsToolStripMenuItem";
      this.actionsToolStripMenuItem.Size = new System.Drawing.Size(59, 20);
      this.actionsToolStripMenuItem.Text = "Actions";
      //
      // cloneObjFinderToolStripMenuItem
      //
      this.cloneObjFinderToolStripMenuItem.Name = "cloneObjFinderToolStripMenuItem";
      this.cloneObjFinderToolStripMenuItem.Size = new System.Drawing.Size(219, 22);
      this.cloneObjFinderToolStripMenuItem.Text = "CloneObjFinder";
      this.cloneObjFinderToolStripMenuItem.Click += new System.EventHandler(this.cloneObjFinderToolStripMenuItem_Click);
      //
      // trigersToolStripMenuItem
      //
      this.trigersToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
        this.addReplaceToolStripMenuItem
      });
      this.trigersToolStripMenuItem.Enabled = false;
      this.trigersToolStripMenuItem.Name = "trigersToolStripMenuItem";
      this.trigersToolStripMenuItem.Size = new System.Drawing.Size(219, 22);
      this.trigersToolStripMenuItem.Text = "Trigers";
      this.trigersToolStripMenuItem.Click += new System.EventHandler(this.trigersToolStripMenuItem_Click);
      //
      // addReplaceToolStripMenuItem
      //
      this.addReplaceToolStripMenuItem.Name = "addReplaceToolStripMenuItem";
      this.addReplaceToolStripMenuItem.Size = new System.Drawing.Size(186, 22);
      this.addReplaceToolStripMenuItem.Text = "Add/Replace content";
      this.addReplaceToolStripMenuItem.Click += new System.EventHandler(this.addReplaceToolStripMenuItem_Click);
      //
      // checkObjWrongLocationToolStripMenuItem
      //
      this.checkObjWrongLocationToolStripMenuItem.Enabled = false;
      this.checkObjWrongLocationToolStripMenuItem.Name = "checkObjWrongLocationToolStripMenuItem";
      this.checkObjWrongLocationToolStripMenuItem.Size = new System.Drawing.Size(219, 22);
      this.checkObjWrongLocationToolStripMenuItem.Text = "CheckObjWrongLocation";
      this.checkObjWrongLocationToolStripMenuItem.Click += new System.EventHandler(
            this.checkObjWrongLocationToolStripMenuItem_Click);
      //
      // addfunclogicToolStripMenuItem
      //
      this.addfunclogicToolStripMenuItem.Enabled = false;
      this.addfunclogicToolStripMenuItem.Name = "addfunclogicToolStripMenuItem";
      this.addfunclogicToolStripMenuItem.Size = new System.Drawing.Size(219, 22);
      this.addfunclogicToolStripMenuItem.Text = "Add_func_logic";
      this.addfunclogicToolStripMenuItem.Click += new System.EventHandler(this.addfunclogicToolStripMenuItem_Click);
      //
      // gameHintObjActionsToolStripMenuItem
      //
      this.gameHintObjActionsToolStripMenuItem.Enabled = false;
      this.gameHintObjActionsToolStripMenuItem.Name = "gameHintObjActionsToolStripMenuItem";
      this.gameHintObjActionsToolStripMenuItem.Size = new System.Drawing.Size(219, 22);
      this.gameHintObjActionsToolStripMenuItem.Text = "GameHintObjActions";
      this.gameHintObjActionsToolStripMenuItem.Click += new System.EventHandler(
            this.gameHintObjActionsToolStripMenuItem_Click);
      //
      // bBTcheckToolStripMenuItem
      //
      this.bBTcheckToolStripMenuItem.Name = "bBTcheckToolStripMenuItem";
      this.bBTcheckToolStripMenuItem.Size = new System.Drawing.Size(219, 22);
      this.bBTcheckToolStripMenuItem.Text = "BBTcheck";
      this.bBTcheckToolStripMenuItem.Click += new System.EventHandler(this.bBTcheckToolStripMenuItem_Click);
      //
      // localFuncCheckToolStripMenuItem
      //
      this.localFuncCheckToolStripMenuItem.Name = "localFuncCheckToolStripMenuItem";
      this.localFuncCheckToolStripMenuItem.Size = new System.Drawing.Size(219, 22);
      this.localFuncCheckToolStripMenuItem.Text = "localFuncCheck";
      this.localFuncCheckToolStripMenuItem.Click += new System.EventHandler(this.localFuncCheckToolStripMenuItem_Click);
      //
      // noSFXfinderToolStripMenuItem
      //
      this.noSFXfinderToolStripMenuItem.Name = "noSFXfinderToolStripMenuItem";
      this.noSFXfinderToolStripMenuItem.Size = new System.Drawing.Size(219, 22);
      this.noSFXfinderToolStripMenuItem.Text = "NoSFXfinder";
      this.noSFXfinderToolStripMenuItem.Click += new System.EventHandler(this.noSFXfinderToolStripMenuItem_Click);
      //
      // zZDeployToSprGmToolStripMenuItem
      //
      this.zZDeployToSprGmToolStripMenuItem.Name = "zZDeployToSprGmToolStripMenuItem";
      this.zZDeployToSprGmToolStripMenuItem.Size = new System.Drawing.Size(219, 22);
      this.zZDeployToSprGmToolStripMenuItem.Text = "ZZ_Deploy_ToSprGm";
      this.zZDeployToSprGmToolStripMenuItem.Click += new System.EventHandler(this.zZDeployToSprGmToolStripMenuItem_Click);
      //
      // checkChetnostToolStripMenuItem
      //
      this.checkChetnostToolStripMenuItem.Name = "checkChetnostToolStripMenuItem";
      this.checkChetnostToolStripMenuItem.Size = new System.Drawing.Size(219, 22);
      this.checkChetnostToolStripMenuItem.Text = "CheckChetnost";
      this.checkChetnostToolStripMenuItem.Click += new System.EventHandler(this.checkChetnostToolStripMenuItem_Click);
      //
      // getUsedFontsToolStripMenuItem
      //
      this.getUsedFontsToolStripMenuItem.Name = "getUsedFontsToolStripMenuItem";
      this.getUsedFontsToolStripMenuItem.Size = new System.Drawing.Size(219, 22);
      this.getUsedFontsToolStripMenuItem.Text = "GetUsedFonts";
      this.getUsedFontsToolStripMenuItem.Click += new System.EventHandler(this.getUsedFontsToolStripMenuItem_Click);
      //
      // bigPngFinderToolStripMenuItem
      //
      this.bigPngFinderToolStripMenuItem.Name = "bigPngFinderToolStripMenuItem";
      this.bigPngFinderToolStripMenuItem.Size = new System.Drawing.Size(219, 22);
      this.bigPngFinderToolStripMenuItem.Text = "BigPngFinder";
      this.bigPngFinderToolStripMenuItem.Click += new System.EventHandler(this.bigPngFinderToolStripMenuItem_Click);
      //
      // fXresCheckerToolStripMenuItem
      //
      this.fXresCheckerToolStripMenuItem.Name = "fXresCheckerToolStripMenuItem";
      this.fXresCheckerToolStripMenuItem.Size = new System.Drawing.Size(219, 22);
      this.fXresCheckerToolStripMenuItem.Text = "FXresChecker";
      this.fXresCheckerToolStripMenuItem.Click += new System.EventHandler(this.fXresCheckerToolStripMenuItem_Click);
      //
      // showFunctionsToolStripMenuItem
      //
      this.showFunctionsToolStripMenuItem.Name = "showFunctionsToolStripMenuItem";
      this.showFunctionsToolStripMenuItem.Size = new System.Drawing.Size(219, 22);
      this.showFunctionsToolStripMenuItem.Text = "ShowFunctions";
      this.showFunctionsToolStripMenuItem.Click += new System.EventHandler(this.showFunctionsToolStripMenuItem_Click);
      //
      // showLevelSoundSchemeToolStripMenuItem
      //
      this.showLevelSoundSchemeToolStripMenuItem.Name = "showLevelSoundSchemeToolStripMenuItem";
      this.showLevelSoundSchemeToolStripMenuItem.Size = new System.Drawing.Size(219, 22);
      this.showLevelSoundSchemeToolStripMenuItem.Text = "ShowLevelSoundScheme";
      this.showLevelSoundSchemeToolStripMenuItem.Click += new System.EventHandler(
            this.showLevelSoundSchemeToolStripMenuItem_Click);
      //
      // positionMovecoordinatesToolStripMenuItem
      //
      this.positionMovecoordinatesToolStripMenuItem.Name = "positionMovecoordinatesToolStripMenuItem";
      this.positionMovecoordinatesToolStripMenuItem.Size = new System.Drawing.Size(219, 22);
      this.positionMovecoordinatesToolStripMenuItem.Text = "Position_Move_coordinates";
      this.positionMovecoordinatesToolStripMenuItem.Click += new System.EventHandler(
            this.positionMovecoordinatesToolStripMenuItem_Click);
      //
      // animXMLConvertToolStripMenuItem
      //
      this.animXMLConvertToolStripMenuItem.Name = "animXMLConvertToolStripMenuItem";
      this.animXMLConvertToolStripMenuItem.Size = new System.Drawing.Size(219, 22);
      this.animXMLConvertToolStripMenuItem.Text = "AnimXMLConvert";
      this.animXMLConvertToolStripMenuItem.Click += new System.EventHandler(this.animXMLConvertToolStripMenuItem_Click);
      //
      // autoSortControlsToolStripMenuItem
      //
      this.autoSortControlsToolStripMenuItem.Name = "autoSortControlsToolStripMenuItem";
      this.autoSortControlsToolStripMenuItem.Size = new System.Drawing.Size(219, 22);
      this.autoSortControlsToolStripMenuItem.Text = "AutoSortControls";
      this.autoSortControlsToolStripMenuItem.Click += new System.EventHandler(this.autoSortControlsToolStripMenuItem_Click);
      //
      // addPazlesToolStripMenuItem
      //
      this.addPazlesToolStripMenuItem.Name = "addPazlesToolStripMenuItem";
      this.addPazlesToolStripMenuItem.Size = new System.Drawing.Size(219, 22);
      this.addPazlesToolStripMenuItem.Text = "AddPazzles";
      this.addPazlesToolStripMenuItem.Click += new System.EventHandler(this.addPazzlesToolStripMenuItem_Click);
      //
      // checkBoxUnsafeLoading
      //
      this.checkBoxUnsafeLoading.AutoSize = true;
      this.checkBoxUnsafeLoading.Location = new System.Drawing.Point(188, 4);
      this.checkBoxUnsafeLoading.Name = "checkBoxUnsafeLoading";
      this.checkBoxUnsafeLoading.Size = new System.Drawing.Size(98, 17);
      this.checkBoxUnsafeLoading.TabIndex = 5;
      this.checkBoxUnsafeLoading.Text = "UnsafeLoading";
      this.checkBoxUnsafeLoading.UseVisualStyleBackColor = true;
      //
      // Form1
      //
      this.AllowDrop = true;
      this.AutoScaleDimensions = new System.Drawing.SizeF(96F, 96F);
      this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Dpi;
      this.BackColor = System.Drawing.SystemColors.Window;
      this.ClientSize = new System.Drawing.Size(1127, 620);
      this.Controls.Add(this.checkBoxUnsafeLoading);
      this.Controls.Add(this.treeView1);
      this.Controls.Add(this.panel1);
      this.Controls.Add(this.richTextBox1);
      this.Controls.Add(this.menuStrip1);
      this.DoubleBuffered = true;
      this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
      this.KeyPreview = true;
      this.MainMenuStrip = this.menuStrip1;
      this.Name = "Form1";
      this.StartPosition = System.Windows.Forms.FormStartPosition.WindowsDefaultBounds;
      this.Text = "LogicCase";
      this.WindowState = System.Windows.Forms.FormWindowState.Minimized;
      this.Load += new System.EventHandler(this.Form1_Load);
      this.Shown += new System.EventHandler(this.Form1_Shown);
      this.TextChanged += new System.EventHandler(this.Form1_TextChanged);
      this.DragDrop += new System.Windows.Forms.DragEventHandler(this.Form1_DragDrop);
      this.DragEnter += new System.Windows.Forms.DragEventHandler(this.Form1_DragEnter);
      this.MouseDown += new System.Windows.Forms.MouseEventHandler(this.Form1_MouseDown);
      this.MouseMove += new System.Windows.Forms.MouseEventHandler(this.Form1_MouseMove);
      this.MouseUp += new System.Windows.Forms.MouseEventHandler(this.Form1_MouseUp);
      this.PreviewKeyDown += new System.Windows.Forms.PreviewKeyDownEventHandler(this.Form1_PreviewKeyDown);
      this.panel1.ResumeLayout(false);
      this.panel1.PerformLayout();
      this.menuStrip1.ResumeLayout(false);
      this.menuStrip1.PerformLayout();
      this.ResumeLayout(false);
      this.PerformLayout();

    }

    #endregion

    private System.Windows.Forms.Button buttonDebag;
    private System.Windows.Forms.Panel panel1;
    public System.Windows.Forms.RichTextBox richTextBox1;
    private System.Windows.Forms.ProgressBar progressBar1;
    private System.Windows.Forms.Button buttonSave;
    private System.Windows.Forms.OpenFileDialog openFileDialogLoadLogic;
    private System.Windows.Forms.Button buttonRessCheck;
    private System.Windows.Forms.Button buttonRestart;
    private System.Windows.Forms.TreeView treeView1;
    private System.Windows.Forms.Button buttonLevLogicBuild;
    private System.Windows.Forms.MenuStrip menuStrip1;
    private System.Windows.Forms.ToolStripMenuItem FailToolStripMenuItem;
    private System.Windows.Forms.ToolStripMenuItem LoadToolStripMenuItem;
    private System.Windows.Forms.ToolStripMenuItem LevelToolStripMenuItem;
    private System.Windows.Forms.ToolStripMenuItem уровеньlevToolStripMenuItem;
    private System.Windows.Forms.ToolStripMenuItem сохранитьToolStripMenuItem;
    private System.Windows.Forms.ToolStripMenuItem ресурсыToolStripMenuItem;
    private System.Windows.Forms.Button buttonCompare;
    private System.Windows.Forms.ToolStripMenuItem actionsToolStripMenuItem;
    private System.Windows.Forms.ToolStripMenuItem trigersToolStripMenuItem;
    private System.Windows.Forms.ToolStripMenuItem addReplaceToolStripMenuItem;
    private System.Windows.Forms.ToolStripMenuItem checkObjWrongLocationToolStripMenuItem;
    private System.Windows.Forms.ToolStripMenuItem addfunclogicToolStripMenuItem;
    private System.Windows.Forms.ToolStripMenuItem gameHintObjActionsToolStripMenuItem;
    private System.Windows.Forms.ToolStripMenuItem checkResByModulesToolStripMenuItem;
    private System.Windows.Forms.ToolStripMenuItem findFolderToolStripMenuItem;
    private System.Windows.Forms.Button button1;
    private System.Windows.Forms.TextBox textBox1;
    private System.Windows.Forms.Label label1;
    private System.Windows.Forms.ToolStripMenuItem cloneObjFinderToolStripMenuItem;
    private System.Windows.Forms.ToolStripMenuItem bBTcheckToolStripMenuItem;
    private System.Windows.Forms.ToolStripMenuItem localFuncCheckToolStripMenuItem;
    private System.Windows.Forms.ToolStripMenuItem noSFXfinderToolStripMenuItem;
    private System.Windows.Forms.ToolStripMenuItem zZDeployToSprGmToolStripMenuItem;
    private System.Windows.Forms.ToolStripMenuItem checkChetnostToolStripMenuItem;
    private System.Windows.Forms.Button button2;
    private System.Windows.Forms.ToolStripMenuItem getUsedFontsToolStripMenuItem;
    private System.Windows.Forms.ToolStripMenuItem iNFOToolStripMenuItem;
    private System.Windows.Forms.ToolStripMenuItem bigPngFinderToolStripMenuItem;
    private System.Windows.Forms.CheckBox checkBoxUnsafeLoading;
    private System.Windows.Forms.ToolStripMenuItem fXresCheckerToolStripMenuItem;
    private System.Windows.Forms.ToolStripMenuItem showFunctionsToolStripMenuItem;
    private System.Windows.Forms.ToolStripMenuItem showLevelSoundSchemeToolStripMenuItem;
    private System.Windows.Forms.ToolStripMenuItem positionMovecoordinatesToolStripMenuItem;
    private System.Windows.Forms.ToolStripMenuItem animXMLConvertToolStripMenuItem;
    private System.Windows.Forms.ToolStripMenuItem autoSortControlsToolStripMenuItem;
    private System.Windows.Forms.ToolStripMenuItem addPazlesToolStripMenuItem;
  }
}


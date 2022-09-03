using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.IO;
using System.Text.RegularExpressions;
using TemplateHOG.templates;
using System.Reflection;

namespace TemplateHOG
{

    public partial class MainForm : Form
    {
        public enum DataType { all, rooms, minigames, ho, zzs_current, progress, progress_get, progress_use, progress_clk, progress_win, progress_opn, progress_dlg, progress_current }
       
        public static class Global
        {
            public static string prgPrefix;
            public static string mainPath;
            public static string levelPath;
            public static string levelName;
            private static string _levelText, _moduleCode;
            private static string[] _rooms, _rooms_rm, _rooms_mg, _rooms_ho, _zzs_current;
            private static string[] _progress, _progress_get, _progress_use, _progress_win, _progress_clk, _progress_opn, _progress_dlg, _progress_current;
            public static string ModuleCode
            {
                get
                {
                    return _moduleCode;
                }
                set
                {
                    _moduleCode = value;
                    _zzs_current = Regex.Matches(value, @"(?<=subroom\.Define.*)\bzz_\w+\b(?=.*\))")
                        .Cast<Match>()
                        .Select(m => m.Value)
                        .ToArray();

                    _progress_current = Regex.Matches(value, @"(?<=common_impl\.hint.*\[\W*""\W*)\b\w+_\w+\b(?=\W*""\W*\]\W*=)")
                        .Cast<Match>()
                        .Select(m => m.Value)
                        .ToArray();
                }
            }
            public static string LevelText
            {
                private get
                {
                    return _levelText;
                }
                set
                {
                    _levelText = value;
                    string array1 = Regex.Match(value, @"(?<=game\.room_names[^{]*{)([^}]*)").Value;
                    _rooms = Regex.Matches(array1, @"(?<="")\w+(?="")")
                        .Cast<Match>()
                        .Select(m => m.Value)
                        .ToArray();
                    _rooms_rm = _rooms.Where(m => Regex.IsMatch(m, @"^rm_.*")).ToArray();
                    _rooms_mg = _rooms.Where(m => Regex.IsMatch(m, @"^mg_.*")).ToArray();
                    _rooms_ho = _rooms.Where(m => Regex.IsMatch(m, @"^ho_.*")).ToArray();
                    string array2 = Regex.Match(value, @"(?<=game\.progress_names[^{]*{)([^}]*)").Value;
                    _progress = Regex.Matches(array2, @"(?<="")\w+(?="")")
                        .Cast<Match>()
                        .Select(m => m.Value)
                        .ToArray();
                    _progress_get = _progress.Where(m => Regex.IsMatch(m, @"^get_.*")).ToArray();
                    _progress_use = _progress.Where(m => Regex.IsMatch(m, @"^use_.*")).ToArray();
                    _progress_clk = _progress.Where(m => Regex.IsMatch(m, @"^clk_.*")).ToArray();
                    _progress_win = _progress.Where(m => Regex.IsMatch(m, @"^win_.*")).ToArray();
                    _progress_opn = _progress.Where(m => Regex.IsMatch(m, @"^opn_.*")).ToArray();
                    _progress_dlg = _progress.Where(m => Regex.IsMatch(m, @"^dlg_.*")).ToArray();
                }
            }
            public static string[] GetData(DataType dt)
            {
                switch (dt)
                {
                    case DataType.all:
                        return _rooms;
                    case DataType.rooms:
                        return _rooms_rm;
                    case DataType.minigames:
                        return _rooms_mg;
                    case DataType.ho:
                        return _rooms_ho;
                    case DataType.zzs_current:
                        return _zzs_current;
                    case DataType.progress:
                        return _progress;
                    case DataType.progress_get:
                        return _progress_get;
                    case DataType.progress_use:
                        return _progress_use;
                    case DataType.progress_clk:
                        return _progress_clk;
                    case DataType.progress_win:
                        return _progress_win;
                    case DataType.progress_opn:
                        return _progress_opn;
                    case DataType.progress_dlg:
                        return _progress_dlg;
                    case DataType.progress_current:
                      return _progress_current;
                    default:
                        return null;
                }

            }

        }
 
        public MainForm()
        {
            InitializeComponent();
            mhoListBox.SetItemChecked(1, true);
        }

        private void MainForm_Load(object sender, EventArgs e)
        {

            string savedLastProject = Properties.Settings.Default.lastProject;
            int projectIndex = 0;

            DirectoryInfo obj = new DirectoryInfo(Properties.Settings.Default.workPath);
            DirectoryInfo[] folders = obj.GetDirectories();
            projectSelector.DataSource = folders;
            
            for (int i = 0; i < folders.Length; i++) {
                if (folders[i].Name == savedLastProject) {
                    projectIndex = i;
                    break;
                }
            }
            
            projectSelector.SelectedIndex = projectIndex;
            
            progressSelector.SelectedIndex = 0;        //Defailt progress 0 - std, 1 - ext
            selectTypeOfData.DataSource = Enum.GetValues(typeof(DataType));
            selectTypeOfData.SelectedIndex = selectTypeOfData.Items.Count - 1;
        }

        private void UpdateCode()
        {

            string module = (string)roomsBox.SelectedValue;
            if (module != null) {
                string module_clear = Regex.Replace(module, "^.._", "");
                string modulePath = Global.mainPath + "\\" + module + "\\" + "mod_" + module_clear + ".lua";
                if (File.Exists(modulePath)) {

                    Global.ModuleCode = File.ReadAllText(modulePath);
                    codeBox.Text = Global.ModuleCode;

                    zzBox.ResetText();
                    zzBox.DataSource = Global.GetData(DataType.zzs_current);

                    prgBox.ResetText();
                    prgBox.DataSource = Global.GetData(DataType.progress_current);

                    UpdateData();
                    //TODO make list of ZZs
                    //TODO make list of Progresses

                }
            } else {
                codeBox.Text = "Can't read modules, rooms checkBox is empty?";
            }
        }

        private void UpdateData() {
            dataView.Lines = Global.GetData((DataType)selectTypeOfData.SelectedIndex);
        }
        
        private void pathBox_setPath()
        {
            string projectPath = ((DirectoryInfo)projectSelector.SelectedItem).FullName;
            string additionalPath = "\\exe\\assets\\levels\\level";
            if (progressSelector.SelectedItem != null)
            {
                additionalPath = additionalPath + Global.prgPrefix;
            }
            Global.mainPath = projectPath + additionalPath;
            Global.levelPath = Global.mainPath + Global.levelName;
            pathBox.Text = Global.levelPath;
        }

        private void projectSelector_SelectedIndexChanged(object sender, EventArgs e)
        {
            pathBox_setPath();
            Properties.Settings.Default.lastProject = projectSelector.Text;
            Properties.Settings.Default.Save();
        }

        private void pathBox_TextChanged(object sender, EventArgs e)
        {
            if (File.Exists(Global.levelPath))
            {
                Global.LevelText = File.ReadAllText(Global.levelPath);
                roomsBox.DataSource = Global.GetData(DataType.rooms);
                zzBox.DataSource = Global.GetData(DataType.zzs_current);
                prgBox.DataSource = Global.GetData(DataType.progress_current);
                UpdateCode();
            }
            else
            {
                Global.LevelText = "";
                codeBox.Lines = null;
                roomsBox.DataSource = null;
                zzBox.DataSource = null;
                prgBox.DataSource = null;
            }
        }


        private void prg_SelectedIndexChanged(object sender, EventArgs e)
        {
            Global.prgPrefix = (progressSelector.SelectedItem.ToString() == "std") ? "" : progressSelector.SelectedItem.ToString();
            Global.levelName = "\\mod_level" + Global.prgPrefix + ".lua";
            pathBox_setPath();
        }

        
        private void room_SelectedIndexChanged(object sender, EventArgs e)
        {
            UpdateCode();
        }

        private void selectTypeOfData_SelectedIndexChanged(object sender, EventArgs e)
        {
            UpdateData();
        }

        private void GenerateMMG() {
            string zzname = zzBox.Text;
            string mmgname = (string)prgBox.Text;
            string rmname = (string)roomsBox.Text;
            string prg_start_arr = mmg_prg_start_arrBox.Text;
            bool deploy = mmgListBox.GetItemChecked(0);
            bool zoom = mmgListBox.GetItemChecked(1);
            bool swapper = mmgListBox.GetItemChecked(2);

            mmg temp = new mmg(zzname, mmgname, rmname, prg_start_arr, deploy, zoom, swapper);
            codeBox.Text = temp.TransformText();
        }

        private void GenerateMHO() {
            string zzname = (string)zzBox.Text;
            string mhoname = (string)prgBox.Text;
            string rmname = (string)roomsBox.Text;
            string winitem = mhoWinItemBox.Text;
            string prg_start_arr = mho_prg_start_arrBox.Text;
            string prg = progressSelector.Text;
            bool zoom = mhoListBox.GetItemChecked(0);
            bool task = mhoListBox.GetItemChecked(1);
            bool silhouetteSerial = mhoListBox.GetItemChecked(2);

            mho temp = new mho(zzname, mhoname, rmname, winitem, prg_start_arr, prg, zoom, task, silhouetteSerial);
            codeBox.Text = temp.TransformText();
        }

        private void GenerateDLG() {
            string rmname = (string)roomsBox.Text;
            string dlgname = (string)prgBox.Text;
            string path = dlgPathBox.Text;
            string item = dlgitemBox.Text;
            string itemfuncget = dlgFuncGetBox.Text;
            string itemfunchand = dlgFuncHandBox.Text;
            string count = dlgCountBox.Text;
            string prg = progressSelector.Text;

            dlg temp = new dlg(rmname, dlgname, path, item, itemfuncget, itemfunchand, count, prg);
            codeBox.Text = temp.TransformText();
        }

        private void GenerateCustom() {
            string project = projectSelector.Text;
            string progress = progressSelector.Text;
            string path = pathBox.Text;
            string room = (string)roomsBox.Text;
            string zz = (string)zzBox.Text;
            string prg = (string)prgBox.Text;
            custom temp = new custom(project, progress, path, room, zz, prg);
            codeBox.Text = temp.TransformText();
        }

        private void generate_Click(object sender, EventArgs e) {

            string templateType = ((Button)sender).Parent.Text;
            switch (templateType) {
                case "mmg":
                    try {
                        GenerateMMG();
                    } catch (Exception) {
                        MessageBox.Show("can't GenerateMMG ");
                    }
                    break;
                case "mho":
                    try {
                        GenerateMHO();
                    } catch (Exception) {
                        MessageBox.Show("can't GenerateMHO ");
                    }
                    break;
                case "dlg":
                    try {
                        GenerateDLG();
                    } catch (Exception) {
                        MessageBox.Show("can't GenerateDLG ");
                    }
                    break;
                case "custom":
                    try {
                        GenerateCustom();
                    } catch (Exception) {
                        MessageBox.Show("can't GenerateCustom ");
                    }
                    break;
                default:
                    MessageBox.Show("can't find template type: " + templateType);
                    break;
            }
        }

        private void about_Click(object sender, EventArgs e) {
            MessageBox.Show("Разработано для Elephant Games\nРазработчик: Закиев Марат, 2022г\n" + "Version: "+typeof(MainForm).Assembly.GetName().Version);
        }
    }
}

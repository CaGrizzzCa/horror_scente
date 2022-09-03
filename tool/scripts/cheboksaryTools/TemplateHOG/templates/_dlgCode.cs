using System.Text.RegularExpressions;

namespace TemplateHOG.templates {
    partial class dlg {
        string rmname;
        string dlgname;
        string path;
        string item;
        string itemfuncget;
        string itemfunchand;
        int count;
        string prg;
        public dlg(string rmname, string dlgname, string path, 
            string item, string itemfuncget, string itemfunchand, 
            string count, string prg) {

            this.rmname = Regex.Replace(Validate.isRm(rmname), "rm_", "");
            this.dlgname = Regex.Replace(Validate.isDlg(dlgname), "dlg_[^_]*_", "");
            this.path = Regex.Replace(Regex.Replace(path, @"\\", "/"), "//", "/");
            this.item = item == ""?"":Regex.Replace(Validate.isGet(item), "get_", "");
            this.itemfuncget = itemfuncget;
            this.itemfunchand = itemfunchand;
            this.count = Validate.isInt(count);
            this.prg = Validate.isPrg(prg);
        }

    }
}
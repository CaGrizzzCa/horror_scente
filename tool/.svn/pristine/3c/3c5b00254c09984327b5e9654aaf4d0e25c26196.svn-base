using System.Linq;
using System.Text.RegularExpressions;

namespace TemplateHOG.templates {
    partial class mho {
        string zzname;
        string mhoname;
        string rmname;
        string winitem;
        string[] prg_start_arr;
        string prg;
        bool zoom;
        bool task;
        bool silhouetteSerial;
        public mho(string zzname, string mhoname, string rmname, 
            string winitem, string prg_start_arr, string prg, 
            bool zoom, bool task, bool silhouetteSerial) {

            this.zzname = Regex.Replace(Validate.isZZ(zzname), "zz_", "");
            this.mhoname = Regex.Replace(Validate.isWin(mhoname), "win_", "");
            this.rmname = Regex.Replace(Validate.isRm(rmname), "rm_", "");
            this.winitem = Regex.Replace(Validate.isGet(winitem), "get_", "");
            this.prg_start_arr = Regex.Matches(prg_start_arr, @"\w+")
                        .Cast<Match>()
                        .Select(m => m.Value)
                        .ToArray();
            this.prg = Validate.isPrg(prg);
            this.zoom = zoom;
            this.task = task;
            this.silhouetteSerial = silhouetteSerial;

        }

    }
}
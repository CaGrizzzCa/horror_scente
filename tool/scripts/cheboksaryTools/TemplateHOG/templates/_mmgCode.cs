using System.Linq;
using System.Text.RegularExpressions;

namespace TemplateHOG.templates {
    partial class mmg {
        string zzname;
        string mmgname;
        string rmname;
        string[] prg_start_arr;
        bool deploy;
        bool zoom;
        bool swapper;

        public mmg(string zzname, string mmgname, 
            string rmname, string prg_start_arr,
            bool deploy, bool zoom, bool swapper) {

            this.zzname = Regex.Replace(Validate.isZZ(zzname), "zz_", "");
            this.mmgname = Regex.Replace(Validate.isWin(mmgname), "win_", "");
            this.rmname = Regex.Replace(Validate.isRm(rmname), "rm_", "");
            
            this.prg_start_arr = Regex.Matches(prg_start_arr, @"\w+")
                        .Cast<Match>()
                        .Select(m => m.Value)
                        .ToArray();

            this.deploy = deploy;
            this.zoom = zoom;
            this.swapper = swapper;
        }

    }
}
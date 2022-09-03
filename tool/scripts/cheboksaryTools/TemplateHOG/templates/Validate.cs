using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Text.RegularExpressions;

namespace TemplateHOG.templates {
    static class Validate {
        static void Warning(string message) {
            MessageBox.Show(message);
        }
        public static string isZZ(string str) {
            try {
                if (!Regex.IsMatch(str, "zz_.+"))
                    throw new Exception();
            } catch (Exception) {
                MessageBox.Show("can't read zz name");
                return "[warning_zz]";
            }
            return str;
        }
        public static string isWin(string str) {
            try {
                if (!Regex.IsMatch(str, "win_.+"))
                    throw new Exception();
            } catch (Exception) {
                MessageBox.Show("can't read prg name");
                return "[warning_win]";
            }
            return str;
        }

        public static string isGet(string str) {
            try {
                if (!Regex.IsMatch(str, "get_.+"))
                    throw new Exception();
            } catch (Exception) {
                MessageBox.Show("can't read winitem name");
                return "[warning_get]";
            }
            return str;
        }

        public static string isDlg(string str) {
            try {
                if (!Regex.IsMatch(str, "dlg_.+"))
                    throw new Exception();
            } catch (Exception) {
                MessageBox.Show("can't read dlg name");
                return "[warning_dlg]";
            }
            return str;
        }

        public static string isRm(string str) {
            try {
                if (!Regex.IsMatch(str, "rm_.+"))
                    throw new Exception();
            } catch (Exception) {
                MessageBox.Show("can't read room name");
                return "[warning_room]";
            }
            return str;
        }
        public static string isPrg(string str) {
            try {
                if (str != "std" && str != "ext")
                    throw new Exception();
            } catch (Exception) {
                MessageBox.Show("can't read prg type");
                return "[warning_prg]";
            }
            return str;
        }

        public static int isInt(string str) {
            try {
                Int32.Parse(str);
            } catch (Exception) {
                MessageBox.Show("can't read count type");
                return 0;
            }
            return Int32.Parse(str);
        }
    }
}

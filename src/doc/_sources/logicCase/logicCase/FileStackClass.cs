using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

namespace logicCase
{
    public class FileStackClass
    {
        List<int> Level = new List<int>();
        List<string> pFrom = new List<string>();
        List<string> pTo = new List<string>();
        List<List<List<string>>> fileStack = new List<List<List<string>>>();
        int maxPrioritet=0;
        int minPrioritet=999;
        List<string> FolderStack = new List<string>();

        List<int> Levell = new List<int>();
        List<List<string>> pFroml = new List<List<string>>();
        List<string> pTol = new List<string>();
        int maxPrioritetl = 0;
        int minPrioritetl = 999;

        Dictionary <string,string> instack = new Dictionary<string,string>();
        Dictionary<int, Dictionary<string, string>> stack = new Dictionary<int, Dictionary<string, string>>();

        public void Copy(string from, string to, bool replace = true )
        {
            //System.Windows.Forms.MessageBox.Show("FROM "+from+" TO " + to);

            FileInfo fi = new FileInfo(to);
            if (!replace & fi.Exists)
                return;

            string folder = to.Substring(0, to.LastIndexOf("\\"));
            var di = new DirectoryInfo(folder);
            if(!di.Exists)
            {
                FolderCreate(folder);
            }

            for (int i = 0; i < pTo.Count; i++)
            {
                if (pTo[i] == to)
                {
                    pTo.RemoveAt(i);
                    pFrom.RemoveAt(i);
                    Level.RemoveAt(i);
                    i--;
                }
            }

                string buf = to;
                int prioritet = 0;
                while (buf.IndexOf("\\") > -1)
                {
                    buf = buf.Substring(buf.IndexOf("\\") + 1);
                    prioritet++;
                }
                if (prioritet > maxPrioritet) maxPrioritet = prioritet;
                if (prioritet < minPrioritet) minPrioritet = prioritet;
                Level.Add(prioritet);
                pFrom.Add(from);
                pTo.Add(to);
        }

        public void Copy(List<string> list, string to)
        {

            for (int i = 0; i < pTol.Count; i++)
            {
                if (pTol[i] == to)
                {
                    pTol.RemoveAt(i);
                    pFroml.RemoveAt(i);
                    Levell.RemoveAt(i);
                    i--;
                }
            }

            string folder = to.Substring(0, to.LastIndexOf("\\"));
            var di = new DirectoryInfo(folder);
            if (!di.Exists)
            {
                FolderCreate(folder);
            }

            string buf = to;
            int prioritetl = 0;
            while (buf.IndexOf("\\") > -1)
            {
                buf = buf.Substring(buf.IndexOf("\\") + 1);
                prioritetl++;
            }
            if (prioritetl > maxPrioritetl) maxPrioritetl = prioritetl;
            if (prioritetl < minPrioritetl) minPrioritetl = prioritetl;
            Levell.Add(prioritetl);
            pFroml.Add(list);
            pTol.Add(to);
        }
        public void Save()
        {

            if (maxPrioritet == 0 | minPrioritet == 0) return;
            for (int i = 0; i < FolderStack.Count; i++)
            {
                try
                {
                    Directory.CreateDirectory(FolderStack[i]);
                    Console.WriteLine("FolderStack " + FolderStack[i]);
                }
                catch
                {
                    System.Windows.Forms.MessageBox.Show("не удалось создать папку " + FolderStack[i]);

                }
            }
            for (int i = minPrioritet; i <= maxPrioritet; i++)
            {
                for(int j =0;j<Level.Count;j++)
                {
                    if (Level[j] == i)
                    {
                        CopyTry(pFrom[j], pTo[j]);
                        Console.WriteLine(pTo[j]);
                    }
                }
            }
            for (int i = minPrioritetl; i <= maxPrioritetl; i++)
            {
                for (int j = 0; j < Levell.Count; j++)
                {
                    if (Levell[j] == i)
                    {
                        CopyTry(pFroml[j], pTol[j]);
                        Console.WriteLine(pTo[j]);
                    }
                }
            }

            maxPrioritet = 0;
            minPrioritet = 999;
            Level = new List<int>();
            pFrom = new List<string>();
            pTo = new List<string>();

            maxPrioritetl = 0;
            minPrioritetl = 999;
            Levell = new List<int>();
            pFroml = new List<List<string>>();
            pTol = new List<string>();
        }

        void CopyTry(string from, string to)
        {
            try
            {
                if(!File.Exists(to))
                    File.Copy(from, to);
            }
            catch (DirectoryNotFoundException e)
            {
                try
                {
                    Directory.CreateDirectory(to);
                    try
                    {
                        if(!File.Exists(to))
                            File.Copy(from, to);
                    }
                    catch
                    {

                    }
                }
                catch
                {
                    System.Windows.Forms.MessageBox.Show("не удалось создать папку " + to);

                }
            }
            catch (IOException e)
            {
                //System.Windows.Forms.MessageBox.Show("файл уже существует" + to);
                
            }
            catch
            {
                System.Windows.Forms.MessageBox.Show("не удалось скопировать " + from + "  -->  " +to);
            }
        }

        void CopyTry(List<string> from, string to)
        {
            try
            {
                //File.Copy(from, to);
                StreamWriter f = new StreamWriter(to);
                for (int i = 0; i < from.Count; i++)
                {
                    f.WriteLine(from[i]);
                }
                f.Close();
            }
            catch (DirectoryNotFoundException e)
            {
                try
                {
                    Directory.CreateDirectory(to);
                    try
                    {
                        CopyTry(from, to);
                    }
                    catch
                    {

                    }
                }
                catch
                {
                    System.Windows.Forms.MessageBox.Show("LIST не удалось создать папку " + to);

                }
            }
            catch (IOException e)
            {
                //System.Windows.Forms.MessageBox.Show("файл уже существует" + to);

            }
            catch
            {
                System.Windows.Forms.MessageBox.Show("LIST не удалось скопировать " + from + "  -->  " + to);
            }
        }

        public void FolderCreate(string path)
        {
            FolderStack.Add(path);
        }

        

    }
}

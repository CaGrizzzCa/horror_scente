using System;
using System.Collections;
using System.Text;

namespace CSharpLua.Structs
{
    // ????? ?? ???, ????? ?? ????????????. ??? ???????????? ??? ??????????? ? ?????????? ????????? ?? lua. ????? ????? ????? ???.
    public class AttrLuaFunc : Attribute
    {
        private String FunctionName;
        private String FunctionDoc;
        private String[] FunctionParameters = null;

        public AttrLuaFunc(String strFuncName, String strFuncDoc, params String[] strParamDocs)
        {
            FunctionName = strFuncName;
            FunctionDoc = strFuncDoc;
            FunctionParameters = strParamDocs;
        }

        public AttrLuaFunc(String strFuncName, String strFuncDoc)
        {
            FunctionName = strFuncName;
            FunctionDoc = strFuncDoc;
        }

        public String getFuncName()
        {
            return FunctionName;
        }

        public String getFuncDoc()
        {
            return FunctionDoc;
        }

        public String[] getFuncParams()
        {
            return FunctionParameters;
        }
    }

    public class LuaFuncDescriptor
    {
        private String FunctionName;
        private String FunctionDoc;
        private ArrayList FunctionParameters;
        private ArrayList FunctionParamDocs;
        private String FunctionDocString;

        public LuaFuncDescriptor(String strFuncName, String strFuncDoc, ArrayList strParams, ArrayList strParamDocs)
        {
            FunctionName = strFuncName;
            FunctionDoc = strFuncDoc;
            FunctionParameters = strParams;
            FunctionParamDocs = strParamDocs;

            String strFuncHeader = strFuncName + "(%params%) - " + strFuncDoc;
            String strFuncBody = "\n\n";
            String strFuncParams = "";

            Boolean bFirst = true;
            
            for (int i = 0; i < strParams.Count; i++)
            {
                if (!bFirst)
                    strFuncParams += ", ";

                strFuncParams += strParams[i];
                strFuncBody += "\t" + strParams[i] + "\t\t" + strParamDocs[i] + "\n";

                bFirst = false;
            }

            strFuncBody = strFuncBody.Substring(0, strFuncBody.Length - 1);
            if (bFirst)
                strFuncBody = strFuncBody.Substring(0, strFuncBody.Length - 1);

            FunctionDocString = strFuncHeader.Replace("%params%", strFuncParams) + strFuncBody;
        }

        public String getFuncName()
        {
            return FunctionName;
        }

        public String getFuncDoc()
        {
            return FunctionDoc;
        }

        public ArrayList getFuncParams()
        {
            return FunctionParameters;
        }

        public ArrayList getFuncParamDocs()
        {
            return FunctionParamDocs;
        }

        public String getFuncHeader()
        {
            if (FunctionDocString.IndexOf("\n") == -1)
                return FunctionDocString;

            return FunctionDocString.Substring(0, FunctionDocString.IndexOf("\n"));
        }

        public String getFuncFullDoc()
        {
            return FunctionDocString;
        }
    }

    public class LuaPackageDescriptor
    {
        public String PackageName;
        public String PackageDoc;
        public Hashtable PackageFuncs;

        public LuaPackageDescriptor(String strName, String strDoc)
        {
            PackageName = strName;
            PackageDoc = strDoc;
        }

        public void AddFunc(LuaFuncDescriptor pFunc)
        {
            if (PackageFuncs == null)
                PackageFuncs = new Hashtable();

            PackageFuncs.Add(pFunc.getFuncName(), pFunc);
        }

        public String getPackageName()
        {
            return PackageName;
        }

        public String getPackageDoc()
        {
            return PackageDoc;
        }

        public void WriteHelp()
        {
            Console.WriteLine("Available commands on " + PackageName + ": ");
            Console.WriteLine();

            IDictionaryEnumerator Funcs = PackageFuncs.GetEnumerator();
            while (Funcs.MoveNext())
            {
                Console.WriteLine(((LuaFuncDescriptor)Funcs.Value).getFuncHeader());
            }
        }

        public void WriteHelp(String strCmd)
        {
            LuaFuncDescriptor pDesc = (LuaFuncDescriptor)PackageFuncs[strCmd];
            Console.WriteLine(pDesc.getFuncFullDoc());
            return;
        }

        public bool HasFunc(String strFunc)
        {
            return PackageFuncs.ContainsKey(strFunc);
        }
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using ClassCase;

namespace logicCase
{
    class NotEditorProject
    {
        PropObj _po;
        string _projectPath;

        public NotEditorProject(string projectPath)
        {
            _projectPath = projectPath;
            _po = new PropObj(new FileList(projectPath));
            //Console.WriteLine("NotEditorProject(string projectPath)>>");
            //Console.WriteLine(_po.ObjString());
            //Console.WriteLine("<<NotEditorProject(string projectPath)");
        }

        public NotEditorProject(Form1 logicCaseForm)
        {
            _projectPath = logicCaseForm.repDir + "src//doc//project_1.4.xml";

            _po = new PropObj(new FileList(_projectPath));
            //Console.WriteLine("NotEditorProject(Form1 logicCaseForm)>>");
            //Console.WriteLine(_po.ObjString());
            //Console.WriteLine("<<NotEditorProject(Form1 logicCaseForm)");
        }

        public void AddModuleIfNotExist(string groupName, string modPath, bool needSort = true)
        {
            Console.WriteLine("AddModuleIfNotExist >> " + groupName + " >> " + modPath);



            PropObj group = _po.FirstObjInChildsByName(groupName);
            if (group == null)
            {
                _po.AddChild(new PropObj("group", new Dictionary<string, string>() {
                    { "name", groupName }
                }));
                group = _po.FirstObjInChildsByName(groupName);
            }
            if (group.FirstObjInChildsByPropertieValue("path", modPath) == null)
            {
                group.AddChild(new PropObj("mod", new Dictionary<string, string>() {
                    { "path", modPath }
                }));
            }
            if (needSort)
            {
                group.SortChildsByPropertyAndSlashCount("path");
            }
        }

        public void AddModuleIfNotExist(ModuleClass moduleClass, Form1 logicCaseForm, bool needSort = true)
        {
            string groupName = "level";
            if( logicCaseForm.LevelName.Replace("level", "").Length>0)
            {
                groupName += "_" + logicCaseForm.LevelName.Replace("level", "");
            }
            else
            {
                groupName += "_std";
            }
            string modPath = "assets/levels/" + logicCaseForm.LevelName;

            if (moduleClass.GetMainRoomControl() != null)
            {
                modPath += "/" + moduleClass.GetMainRoomControl().GetName();
                modPath += "/mod_" + moduleClass.GetMainRoomControl().getNamePost();
            }
            else
            {
                modPath += "/mod_" + moduleClass.GetName();
            }
            AddModuleIfNotExist(groupName, modPath, needSort);

        }

        public void Save()
        {
            Save(_projectPath);
        }

        public void Save(string path)
        {
            _po.Save(path);
        }

        public string GetProjectString()
        {
            return _po.ObjString();
        }

    }
}

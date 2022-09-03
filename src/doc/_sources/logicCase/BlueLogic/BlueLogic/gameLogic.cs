using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Formatters.Binary;
using System.IO;
using System.Windows.Forms;

namespace BlueLogic
{
    [Serializable]
    public class gameLogic
    {
        public progressClass progress = new progressClass();
        public stuffClass stuff;
        public roomsClass rooms;

        public gameLogic()
        { 
            stuff = new stuffClass(progress);
            rooms = new roomsClass(progress);            
        }

        // serialization, deserialization
        public bool save(string fileName)
        {
            FileStream fs = new FileStream(fileName, FileMode.Create);
            BinaryFormatter formatter = new BinaryFormatter();

            try
            {
                formatter.Serialize(fs, this);
            }
            catch (SerializationException ex)
            {
                MessageBox.Show("Ошибка сериализации. Причина:" + ex.Message, "Game Logic: public bool save(string fileName)");
                return false;
            }
            finally
            {
                fs.Close();
            }
            return true;
        }

        public bool load(string fileName)
        {
            FileStream fs = new FileStream(fileName, FileMode.Open);
            BinaryFormatter formatter = new BinaryFormatter();

            try
            {
                gameLogic temp = (gameLogic)formatter.Deserialize(fs);
                this.rooms = temp.rooms;
                this.stuff = temp.stuff;
                this.progress = temp.progress;
            }
            catch (SerializationException ex)
            {
                MessageBox.Show("Ошибка десериализации. Причина:" + ex.Message, "Game Logic: public bool load(string fileName)");
                return false;
            }
            finally
            {
                fs.Close();
            }
            return true;
        }

        public void clearAll()
        {
            stuff.clear();
            rooms.clear();
            progress.clear();
        }

        //Сортировка списка по алфавиту

        //Сортировка комнат и подкомнат


        public void ActionType(int rowNum, string type)
        {
            progress.list[rowNum].actionType = type;        
        }
        public void ActionObject(int rowNum, string name)
        {
            if (progress.list[rowNum].actionObject != "" && stuff.contains(progress.list[rowNum].actionObject) && stuff.getType(progress.list[rowNum].actionObject) == "multiget")
            {                 
                stuff.removeOneMulti(progress.list[rowNum].actionObject);
                progress.list[rowNum].actionObjectMulti = 0;
                // Пройтись по прогрессу и назначить мультипредметам новые индексы
                int newMultiIndex = 0;
                for (int i=0; i < progress.list.Count(); i++)
                {
                    if (progress.list[i].actionObject == progress.list[rowNum].actionObject && i != rowNum)
                    {
                        newMultiIndex++;
                        progress.list[i].actionObjectMulti = newMultiIndex;
                    }
                }
            }
            if (stuff.contains(name) && stuff.getType(name) == "multiget")
            {
                stuff.addOneMulti(name);
                progress.list[rowNum].actionObjectMulti = stuff.getMultiStuffCount(name);
            }
            progress.list[rowNum].actionObject = name;
        }
        public void ActionRoom(int rowNum, string room)
        {
        
        }        
        public void ActionSubRoom(int rowNum, string subRoom)
        {
        
        }
        public void toActivate(int rowNum, string toActivate)
        {
            progress.list[rowNum].toActivate.Add(toActivate);
        }
    }

    /// <summary>
    /// Класс списка предметов
    /// </summary>
    [Serializable]
    public class stuffClass
   {        
        // { [0] = имя, [1] = тип }
        private List<string[]> _stuff = new List<string[]>();
        // { [key] = предмет, [value] = кол-во использований }
        //private Dictionary<string, int> _multi = new Dictionary<string, int>();
        private Dictionary<string, int> _multiGet = new Dictionary<string, int>();
        private Dictionary<string, bool> _multiUse = new Dictionary<string, bool>();

        //Конструктор
        //Ссылка на объект таблицы прогресса
        private progressClass _progress = new progressClass();
        public stuffClass(progressClass progress)
        {
            _progress = progress;
        }  

        /// <summary>
        /// Возвращает массив строк допустимых типов предметов
        /// </summary>
        public string[] allowedTypes
        {
            get { return new string[] { "regular", "multiuse", "multiget" }; }
        }
        /// <summary>
        /// Очищает весь список предметов
        /// </summary>
        public void clear()
        {
            _stuff.Clear();
            //_multi.Clear();
            _multiGet.Clear();
            _multiUse.Clear();
        }
        /// <summary>
        /// Добавляет предмет по имени и типу
        /// </summary>
        /// <param name="name">Имя предмета</param>
        /// <param name="type">Тип предмета</param>
        public bool add(string name, string type)
        {
            bool result = false;            
            if (!this.contains(name) && allowedTypes.Contains(type))
            {
                _stuff.Add(new string[] { name, type });
                program.form.logWrite("Добавлен новый предмет '" + name + "'.", 2);
                if (type == "multiget")
                {
                    // создаем запись в Dictionary (по умолчанию 0 гет/юз)
                    _multiGet.Add(name, 0);
                
                }
                if (type == "multiuse")
                {
                    _multiUse.Add(name, true);
                }
                else if (type != "regular")
                {
                }
                result = true;
            }
            else if (allowedTypes.Contains(type))
            {
                program.form.logWrite("Уже существует предмет с именем '" + name + "', нельзя добавить новый с таким же именем.", 3);
                //MessageBox.Show("Предмет с именем '" + name + "' уже существует, нельзя добавить новый с таким же именем.", "Game Logic: public void add(string name, string type)");                
            }
            else
            {
                program.form.logWrite("Неизвестный тип предмета '" + type + "'.", 3);
                //MessageBox.Show("Неизвестный тип предмета " + type + ".", "Game Logic: public void add(string name, string type)");            
            }
            return result;
        }
        /// <summary>
        /// Возвращает имена всех предметов без префиксов и постфиксов
        /// </summary>
        /// <returns></returns>
        public List<string> getAllNames()
        {
            List<string> result = new List<string>();
            foreach (string[] str in _stuff)
            {
                result.Add(str[0]);
            }
            return result;
        }
        /// <summary>
        /// Возвращает все имена предметов с постфиксами ("_1", "_2", ...) 
        /// </summary>
        /// <returns></returns>
        public List<string> getGameStuff()
        {
            List<string> result = new List<string>();
            foreach (string[] str in _stuff)
            {
                if (str[1] == "regular" || str[1] == "multiuse")
                {
                    result.Add(str[0]);
                }
                else if (str[1] == "multiget")
                {
                    int count;
                    _multiGet.TryGetValue(str[0], out count);
                    if (count > 0)
                        for (int i = 1; i <= count; i++)
                        {
                            result.Add(str[0] + "_" + i);
                        }
                    else
                        result.Add(str[0] + "_0");
                    result.Add(str[0]);
                }
            }
            return result;
        }
        /// <summary>
        /// Возвращает все имена для мультипредмета (с постфиксами "_1", "_2", ... ; но без префиксов "get_", "use_")
        /// </summary>
        /// <param name="name">Имя предмета без префиксов и без постфиксов</param>
        /// <returns></returns>
        public List<string> getMultiNames(string name)
        {
            List<string> result = new List<string>();
            if (_multiGet.ContainsKey(name))
            {               
                int count = 0;
                _multiGet.TryGetValue(name, out count);
                if (count > 0)
                    for (int i = 1; i <= count; i++)
                    {
                        result.Add(name + "_" + string.Format("{0}", i));
                    }
                else
                    result.Add(name + "_0");                    
            }
            else
            {
                program.form.logWrite("Не найден мультиобъект '" + name +"'.", 3);
                //MessageBox.Show("Не найдет заданный мультиобъект " + name + ".", "Game Logic: public string[] getMultiNames(string name)");
            }
            return result;
        }
        /// <summary>
        /// Возвращает количество предметов (мультиюзы и мультигеты считает за один)
        /// </summary>
        /// <returns></returns>
        public int getCount()
        {
            return _stuff.Count();
        }
        /// <summary>
        /// Возвращает имя предмета по номеру (первый предмет имеет номер 0)
        /// </summary>
        /// <param name="num">Номер предмета</param>
        /// <returns></returns>
        public string getName(int num)
        {
            if (num <= this.getCount() - 1 && num >= 0)
            {
                return _stuff[num][0];
            }
            else
            {
                program.form.logWrite("Не найден предмет с номером '" + num + "'.", 3);
                //MessageBox.Show("Предмет с номером " + num + " не найден.", "Game Logic: public string getName(int num)");
                return "";
            }
        }
        /// <summary>
        /// Возвращает тип предмета (regular, multiuse, multiget) по номеру (первый предмет имеет номер 0)
        /// </summary>
        /// <param name="num">Номер предмета</param>
        /// <returns></returns>
        public string getType(int num)
        {
            if (num <= this.getCount() - 1 && num >= 0)
            {
                return _stuff[num][1];
            }
            else
            {
                program.form.logWrite("Не найден предмет с номером '" + num + "'.", 3);
                //MessageBox.Show("Предмет с номером '" + num + "' не найден.", "Game Logic: public string getType(int num)");
                return "";
            }
        }
        /// <summary>
        /// Возвращает тип предмета (regular, multiuse, multiget) по имени
        /// </summary>
        /// <param name="name">Имя предмета без префиксов и постфиксов</param>
        /// <returns></returns>
        public string getType(string name)
        {
            string result = "";
            foreach (string[] str in _stuff)
            {
                if (str[0] == name)
                {
                    result = str[1];
                    return result;
                }
            }
            if (result == "")
            {
                program.form.logWrite("Не найден предмет с именем '" + name + "'.", 3);
                //MessageBox.Show("Предмет с именем " + name + " не найден.", "Game Logic: public string getType(string name)");
            }
            return result;
        }
        /// <summary>
        /// Возвращает количество мультигетов указанного мультипредмета
        /// </summary>
        /// <param name="name"></param>
        /// <returns></returns>
        public int getMultiStuffCount(string name)
        { 
            int result = -1;
            int id = getIndex(name);
            if (getType(name) == "multiget" && id > -1)
                result = _multiGet[_stuff[id][0]];
            return result;
        }

        /// <summary>
        /// Возвращает номер предмета по имени, если предмет не найден, то возвращает -1
        /// </summary>
        /// <param name="name">Имя предмета</param>
        /// <returns>Номер предмета или -1, если предмет не найден</returns>
        public int getIndex(string name)
        {
            if (this.contains(name))
            {
                for (int i = 0; i <= this.getCount() - 1; i++)
                {
                    if (_stuff[i][0] == name)
                    {
                        return i;
                    }
                }
            }
            return -1;
        }
        /// <summary>
        /// Добавляет один мультигет для мульти-предмета
        /// </summary>
        /// <param name="name"></param>
        public void addOneMulti(string name)
        {
            if (_multiGet.ContainsKey(name))
            {
                _multiGet[name]++;
                program.form.logWrite("Мультипредмет используется '" + name + "': " + _multiGet[name] + " раз.", 0);
            }
            else
            {
                program.form.logWrite("Не найден мультипредмет '" + name + "'.", 3);
                //MessageBox.Show("Не найдет мультипредмет " + name + ".", "Game Logic: public void addOneMulti(string name)");
            }
        }
        /// <summary>
        /// Удаляет один мультигет для мульти-предмета
        /// </summary>
        /// <param name="name"></param>
        public void removeOneMulti(string name)
        {
            if (_multiGet.ContainsKey(name))
            {
                _multiGet[name]--;
                program.form.logWrite("Мультипредмет используется '" + name + "': " + _multiGet[name] + " раз.", 0);
            }
            else
            {
                program.form.logWrite("Не найден мультипредмет '" + name + "'.", 3);
                //MessageBox.Show("Не найдет мультипредмет " + name + ".", "Game Logic: public void removeOneMulti(string name)");
            }
        }
        /// <summary>
        /// Удаляет предмет из предметов по имени, если предмета с таким именем нет - ничего не делает
        /// </summary>
        /// <param name="name">Имя предмета без префиксов и без постфиксов</param>
        public void remove(string name)
        {
            foreach (string[] str in _stuff)
            {
                if (str[0] == name)
                {
                    if (_multiGet.ContainsKey(name))
                    {
                        program.form.logWrite("Удален мультигет '" + name + "' (" + _multiGet[name] + ")", 2);
                        _multiGet.Remove(name);
                    }
                    else if (_multiUse.ContainsKey(name))
                    {
                        program.form.logWrite("Удален мультиюз '" + name, 2);
                        _multiUse.Remove(name);
                    }
                    else
                    {
                        program.form.logWrite("Удален предмет '" + name + "'.", 2);
                    }
                    _stuff.Remove(str);
                    break;
                }
            }
        }
        /// <summary>
        /// Проверяет, существует ли уже предмет с заданным именем
        /// </summary>
        /// <param name="name">Имя для проверки</param>
        /// <returns></returns>
        public bool contains(string name)
        {
            foreach (string[] str in _stuff)
            {
                if (str[0] == name)
                {
                    return true;
                }
            }
            return false;
        }

        /// <summary>
        /// Изменяет имя предмета
        /// </summary>
        /// <param name="oldName">Старое имя предмета</param>
        /// <param name="newName">Новое имя предмета</param>
        /// <returns>Если успешно изменено - возвращает true</returns>
        public bool changeName(string oldName, string newName)
        {
            bool result = false;
            int index = this.getIndex(oldName);
            if (index > -1)
            {
                if (!this.contains(newName))
                {
                    if (oldName != newName)
                    {
                        _stuff[index][0] = newName;
                        program.form.logWrite("Переименован предмет '" + oldName + "' -> '" + newName + "'.", 3);
                    }
                    result = true;
                }
                else
                {
                    program.form.logWrite("Невозможно переименовать '" + oldName + "'. Уже есть предмет с именем '" + newName + "'.", 3);
                    //MessageBox.Show("Невозможно переименовать предмет, т.к. уже есть предмет с именем '" + newName + "'.", "Game Logic: public void changeName(string oldName, string newName)");
                }
            }
            else
            {
                program.form.logWrite("Не найден предмет '" + oldName + "' для изменения имени.", 3);
                //MessageBox.Show("Не найден предмет '" + oldName + "' для изменения имени.", "Game Logic: public void change(string oldName, string newName)");
            }
            return result;
        }
        /// <summary>
        /// Изменяет тип предмета, если тип предмета такой же как новый, то ничего не делает
        /// </summary>
        /// <param name="name">Имя предмета без префиксов и постфиксов</param>
        /// <param name="newType">Тип предмета</param>
        /// <returns>Возвращает количество удаленных мультигетов из списка, если предмет был regula или multiuse, тогда 0 возвращает. Если задан несуществующий тип, то возвращает -1. Если не найден предмет, то возвращает -2.</returns>
        public int changeType(string name, string newType)
        {
            int result = 0;
            int index = this.getIndex(name);
            if (index > -1)
            {
                if (_stuff[index][1] != newType)
                {
                    if (newType == "regular")
                    {
                        string type = getType(name);
                        if (type == "multiGet")
                        {
                            result = _multiGet[name];
                            _multiGet.Remove(name);
                        }
                        else if (type == "multiUse")
                            _multiUse.Remove(name);
                        program.form.logWrite("Изменен тип предмета '" + name + "' на '" + newType + "'.", 2);
                    }
                    else if (newType == "multiget")
                    {
                        _multiGet.Add(name, 0);
                        program.form.logWrite("Изменен тип предмета '" + name + "' на '" + newType + "'.", 2);
                    }
                    else if (newType == "multiuse")
                    {
                        _multiUse.Add(name, true);
                        program.form.logWrite("Изменен тип предмета '" + name + "' на '" + newType + "'.", 2);                    
                    }
                    else
                    {
                        program.form.logWrite("Нельзя задать тип предмета '" + name + "'. Такого типа не существует.", 3);
                        //MessageBox.Show("Нельзя задать тип предмета " + name + ". Такого типа не существует.", "Game Logic: public void changeType(string name, string newType)");
                        return -1;
                    }
                    _stuff[index][1] = newType;
                }
            }
            else
            {
                program.form.logWrite("Не найден предмет '" + name + "' для изменения типа.", 3);
                //MessageBox.Show("Не найден предмет " + name + " для изменения типа.", "Game Logic: public void changeType(string name, string newType)");
                result = -2;
            }
            return result;
        }
    }
    /// <summary>
    /// Класс одной комнаты с её подкомнатами
    /// </summary>
    [Serializable]
    public class roomClass
    {
        //имя комнаты
        public string type = "rm";
        public string name;
        public string[] allowedTypes
        {
            get { return new string[] { "zz", "mg", "ho" }; }
        }
        //подкомнаты
        private List<subRoomClass> _subRooms = new List<subRoomClass>();
        //переходы
        private List<roomClass> _junctions = new List<roomClass>();
        //конструктор
        public roomClass()
        {
            name = "";
        }
        public roomClass(string name)
        {
            this.name = name;
        }
        /// <summary>
        /// Проверяет, существует ли подкомната с заданным именем в данной комнате
        /// </summary>
        /// <param name="subRoomName"></param>
        /// <returns></returns>
        public bool isSubRoomExist(string subRoomName)
        {
            bool result = false;
            foreach (subRoomClass sr in _subRooms)
            {
                if (sr.name == subRoomName)
                {
                    result = true;
                    break;
                }
            }
            return result;
        }
        /// <summary>
        /// Добавить подкомнату
        /// </summary>
        /// <param name="type"></param>
        /// <param name="name"></param>
        public void addSubRoom(string type, string name)
        {
            if (!isSubRoomExist(name))
            {
                _subRooms.Add(new subRoomClass(type, name));
            }
            else
            {
                program.form.logWrite("Уже существует подкомната с именем '" + name + "'.", 3);
                //MessageBox.Show("Подкомната с именем " + name + " уже существует.", "Game Logic: public void addSubRoom(string type, string name)");
            }
        }
        /// <summary>
        /// Возвращает список подкомнат
        /// </summary>
        /// <returns></returns>
        public List<subRoomClass> getSubRooms()
        {
            return _subRooms;
        }
        /// <summary>
        /// Удаляет подкомнату из комнаты по имени. Если подкомнаты с таким именем не существует, то ничего не делает.
        /// </summary>
        /// <param name="subRoomName"></param>
        public void delSubRoom(string subRoomName)
        {
            foreach (subRoomClass sr in _subRooms)
            {
                if (sr.name == subRoomName)
                {
                    _subRooms.Remove(sr);
                    break;
                }
            }
        }
        /// <summary>
        /// Проверяет, существует ли в текущей комнате переход с заданным именем
        /// </summary>
        /// <param name="junctionName"></param>
        /// <returns></returns>
        public bool isJunctionExist(string junctionName)
        {
            bool result = false;
            foreach (roomClass jnct in _junctions)
            {
                if (jnct.name == junctionName)
                {
                    result = true;
                    break;
                }
            }
            return result;
        }
        /// <summary>
        /// Добавляет переход, если переход с таким именем в текущей комнате уже существует - выводит сообщение.
        /// </summary>
        /// <param name="roomName"></param>
        public void addJunction(roomClass roomName)
        {
            if (!isJunctionExist(roomName.name))
            {
                _junctions.Add(roomName);
            }
            else
            {
                program.form.logWrite("Уже существует переход '" + roomName + "' в комнате '" + this.name + "'.", 3);
                //MessageBox.Show("Переход '" + roomName + "' в комнате " + this.name + " уже существует.", "Game Logic: public void addJunction(room roomName)");
            }
        }
        /// <summary>
        /// Удаляет существующий переход, если переход не существует, тогда ничего не делает.
        /// Взаимный переход не удаляет.
        /// </summary>
        /// <param name="junctionName"></param>
        public void delJunction(roomClass junctionName)
        {
            foreach (roomClass jnct in _junctions)
            {
                if (jnct.name == junctionName.name)
                {
                    _junctions.Remove(jnct);
                    break;
                }
            }
        }
        /// <summary>
        /// Возвращает список всех переходов
        /// </summary>
        /// <returns></returns>
        public List<roomClass> getJunctions()
        {
            return _junctions;
        }
        /// <summary>
        /// Изменяет имя подкомнаты
        /// </summary>
        /// <param name="oldSubRoomName"></param>
        /// <param name="newSubRoomName"></param>
        public void changeSubRoomName(string oldSubRoomName, string newSubRoomName)
        {
            if (isSubRoomExist(oldSubRoomName))
            {
                if (!isSubRoomExist(newSubRoomName))
                {
                    foreach (subRoomClass sr in _subRooms)
                    {
                        if (sr.name == oldSubRoomName)
                        {
                            sr.name = newSubRoomName;
                            break;
                        }
                    }
                }
                else
                {
                    program.form.logWrite("Не удалось переименовать подкомнату " + oldSubRoomName + " в подкомнату " + newSubRoomName + ". Подкомната с таким именем уже существует в комнате " + this.name + ".", 3);
                    //MessageBox.Show("Нельзя переименовать подкомнату " + oldSubRoomName + " в подкомнату " + newSubRoomName + " т.к. подкомната с таким именем уже существует в комнате " + this.name + ".", "Game Logic: public void changeSubRoomName(string oldSubRoomName, string newSubRoomName)");
                }
            }
            else
            {
                program.form.logWrite("Не удалось переименовать подкомнату '" + oldSubRoomName + "', она не существует в комнате '" + this.name + "'.", 3);
                //MessageBox.Show("Невозможно переименовать подкомнату " + oldSubRoomName + ", она не существует в комнате " + this.name + ".", "Game Logic: public void changeSubRoomName(string oldSubRoomName, string newSubRoomName)");
            }
        }
        /// <summary>
        /// Задает новый тип подкомнате, не зависимо от того, каким был тип подкомнаты до этого.
        /// </summary>
        /// <param name="subRoomName">Имя подкомнаты</param>
        /// <param name="subRoomNewType">"zz", "ho", "mg"</param>
        public void changeSubRoomType(string subRoomName, string subRoomNewType)
        {
            if (allowedTypes.Contains(subRoomNewType))
            {
                if (isSubRoomExist(subRoomName))
                {
                    foreach (subRoomClass sr in _subRooms)
                    {
                        if (sr.name == subRoomName)
                        {
                            sr.type = subRoomNewType;
                            break;
                        }
                    }
                }
                else
                {
                    program.form.logWrite("Не удалось изменить тип подкомнаты '" + subRoomName + "'. Подкомната не существует.", 3);
                    //MessageBox.Show("Подкомната " + subRoomName + " не существует.", "Game Logic: public void changeSubRoomType(string subRoomName, string subRoomNewType)");
                }
            }
            else
            {
                string str = "'";
                foreach (string substr in allowedTypes)
                    str = str + " '" + substr + "'";
                program.form.logWrite("Неверно задан тип подкомнаты: '" + subRoomNewType + "'. Тип подкомнаты может быть" + str + ".", 3);
                //MessageBox.Show("Неверно задан тип подкомнаты: '" + subRoomNewType + "'. Тип подкомнаты может быть 'zz', 'mg' или 'ho'.", "Game Logic: public void changeSubRoomType(string subRoomName, string subRoomNewType)");
            }
        }

        public subRoomClass getSubRoom(string name)
        {
            subRoomClass result = new subRoomClass();
            foreach (subRoomClass sr in _subRooms)
            {
                if (sr.name == name)
                {
                    result = sr;
                    break;
                }
            }
            return result;
        }

    }
    /// <summary>
    /// Класс одной подкомнаты
    /// </summary>
    [Serializable]
    public class subRoomClass
    {
        public string type;
        public string name;

        public subRoomClass()
        {
            type = "";
            name = "";
        }
        public subRoomClass(string type, string name)
        {
            this.type = type;
            this.name = name;
        }
    }
    /// <summary>
    /// Класс списка комнат и подкомнат
    /// </summary>
    [Serializable]
    public class roomsClass
    {
        //Конструктор
        //Ссылка на объект таблицы прогресса
        private progressClass _progress = new progressClass();
        public roomsClass(progressClass progress)
        {
            _progress = progress;
        }

        //список комнат
        private List<roomClass> _rooms = new List<roomClass>();
        /// <summary>
        /// Очистить список комнат
        /// </summary>
        public void clear()
        {
            _rooms.Clear();
        }
        /// <summary>
        /// Находит комнату, возвращает номер в листе _rooms. Если комната не найдена - возвращает -1.
        /// </summary>
        /// <param name="roomName">Имя комнаты</param>
        /// <returns>возвращает -1, если комната не найдена. Либо номер в листе _rooms, если комната найдена</returns>
        private int findRoom(string roomName)
        {
            int result = -1;
            for (int i = 0; i <= _rooms.Count() - 1; i++)
            {
                if (_rooms[i].name == roomName)
                {
                    result = i;
                }
            }
            return result;
        }
        /// <summary>
        /// Находит подкомнату, возвращает номер комнаты в листе _rooms, которой принадлежит подкомната. Если подкомната не найдена - возвращает -1.
        /// </summary>
        /// <param name="subRoomName">Имя подкомнаты</param>
        /// <returns>Возвращает -1, если подкомната не найдена. Либо номер комнаты в листе _rooms, которой принадлежит комната.</returns>
        private int findSubRoom(string subRoomName)
        {
            int result = -1;
            int i = 0;
            foreach (roomClass rm in _rooms)
            {
                if (rm.isSubRoomExist(subRoomName))
                {
                    result = i;
                    break;
                }
                i++;
            }
            return result;
        }
        /// <summary>
        /// Вовзращает список комнат
        /// </summary>
        /// <returns></returns>
        public List<roomClass> getRooms()
        {
            return _rooms;
        }
        /// <summary>
        /// Добавляет комнату, если комната уже сущесвтует - выводит мессадж и ничего не делает
        /// </summary>
        /// <param name="name">Имя комнаты</param>
        public bool addRoom(string name)
        {
            bool result = false;
            if (findRoom(name) == -1)
            {
                _rooms.Add(new roomClass(name));
                result = true;
                program.form.logWrite("Добавлена комната '" + name + "'.", 2);
            }
            else
            {
                program.form.logWrite("Не удалось добавить комнату '" + name + "'. Комната уже существует.", 3);
                //MessageBox.Show("Комната " + name + " уже существует.", "Game Logic: public void addRoom(string name)");
            }
            return result;
        }
        /// <summary>
        /// Удаляет уомнату с указанным именем. Если комната с таким именем не существует, то ничего не делает.
        /// </summary>
        /// <param name="roomName"></param>
        public void delRoom(string roomName)
        {
            int rm = findRoom(roomName);
            if (rm > -1)
            {
                _rooms.RemoveAt(rm);
                program.form.logWrite("Удалена комната '" + roomName + "'.", 2);
            }
        }
        /// <summary>
        /// Переименовывает комнату
        /// </summary>
        /// <param name="oldRoomName">Текущее имя комнаты</param>
        /// <param name="newRoomName">Новое имя для комнаты</param>
        public void changeRoomName(string oldRoomName, string newRoomName)
        {
            int oldRN = findRoom(oldRoomName);
            int newRN = findRoom(newRoomName);
            if (newRN == -1)
            {
                if (oldRN > -1)
                {
                    _rooms[oldRN].name = newRoomName;
                    program.form.logWrite("Переименована комната '" + oldRoomName + "' -> '" + newRoomName + ".", 2);
                }
                else
                {
                    program.form.logWrite("Не найдена комната '" + oldRoomName + "' для переименования.", 3);
                    //MessageBox.Show("Не найдена комната " + oldRoomName + " для переименования.", "Game Logic: public void changeRoomName(string oldRoomName, string newRoomName)");
                }
            }
            else
            {
                program.form.logWrite("Не удалось переименовать комнату " + oldRoomName + " в комнату с именем " + newRoomName + ". Комната с таким именем у же существует.", 3);
                //MessageBox.Show("Нельзя переименовать комнату " + oldRoomName + " в комнату с именем " + newRoomName + " т.к. комната с таким именем у же существует.", "Game Logic: public void changeRoomName(string oldRoomName, string newRoomName)");
            }
        }
        /// <summary>
        /// Проверяет, существует ли подкомната с таким именем. Ищет по всем существующим комнатам.
        /// </summary>
        /// <param name="subRoomName"></param>
        /// <returns></returns>
        public bool isSubRoomExist(string subRoomName)
        {
            bool result = false;
            foreach (roomClass _room in _rooms)
            {
                if (_room.isSubRoomExist(subRoomName))
                {
                    result = true;
                    break;
                }
            }
            return result;
        }
        /// <summary>
        /// Добавляет подкомнату к комнате. Если комната не найдена, выводит мессадж и ничего не делает
        /// </summary>
        /// <param name="parentRoom">Имя комнаты к которой добавить подкомнату</param>
        /// <param name="subRoomType">Тип добавляемой подкомнаты</param>
        /// <param name="subRoomName">Имя добавляемой подкомнаты</param>
        public bool addSubRoom(string parentRoom, string subRoomType, string subRoomName)
        {
            bool result = false;
            int roomNum = findRoom(parentRoom);
            if (roomNum > -1)
            {
                if (!isSubRoomExist(subRoomName))
                {
                    _rooms[roomNum].addSubRoom(subRoomType, subRoomName);
                    result = true;
                    program.form.logWrite("Добавлена подкомната '" + subRoomType + "_" + subRoomName + "'.", 2);
                }
                else
                {
                    program.form.logWrite("Не удалось добавить подкомнату '" + subRoomName + "'. Подкомната с таким именем уже существует.", 3);
                    //MessageBox.Show("Подкомната с именем " + subRoomName + " уже существует.", "Game Logic: public void addSubRoom(string parentRoom, string subRoomType, string subRoomName)");
                }
            }
            else
            {
                program.form.logWrite("Не удалось добавить подкомнату '" + subRoomName + "'. Не найдена комната '" + parentRoom + "' для добавления в неё.", 3);
                //MessageBox.Show("Не найдена комната " + parentRoom + ".", "Game Logic: public void addSubRoom(string parentRoom, string subRoomType, string subRoomName)");
            }
            return result;
        }
        /// <summary>
        /// Удаляет подкомнату, если подкомната не сущесвтует - ничего не делает
        /// </summary>
        /// <param name="subRoomName"></param>
        public void delSubRoom(string subRoomName)
        {
            int rm = findSubRoom(subRoomName);
            if (rm > -1)
            {
                _rooms[rm].delSubRoom(subRoomName);
                program.form.logWrite("Удалена подкомната '" + subRoomName + "'.", 2);
            }
        }
        /// <summary>
        /// Возвращает список подкомнат для заданной комнаты
        /// </summary>
        /// <param name="roomName">Имя комнаты</param>
        /// <returns></returns>
        public List<subRoomClass> getSubRooms(string roomName)
        {
            List<subRoomClass> result = new List<subRoomClass>();
            int rm = findRoom(roomName);
            if (rm > -1)
            {
                result = _rooms[rm].getSubRooms();
            }
            else
            {
                program.form.logWrite("Не удалось возвратить подкомнаты  '" + roomName + "'. Комната не существует.", 3);
                //MessageBox.Show("Комната " + roomName + " не существует. Нельзя возвратить подкомнаты.", "Game Logic: public List<subRoom> getSubRooms(string roomName)");
            }
            return result;
        }
        /// <summary>
        /// Изменяет имя подкомнаты
        /// </summary>
        /// <param name="oldSubRoomName">Старое имя подкомнаты</param>
        /// <param name="newSubRoomName">Новое имя подкомнаты</param>
        public void changeSubRoomName(string oldSubRoomName, string newSubRoomName)
        {
            int rm = findSubRoom(oldSubRoomName);
            int sr = findSubRoom(newSubRoomName);
            if (rm > -1)
            {
                if (sr == -1)
                {
                    _rooms[rm].changeSubRoomName(oldSubRoomName, newSubRoomName);
                    program.form.logWrite("Переименована подкомната '" + oldSubRoomName + "' -> '" + newSubRoomName + "'.", 2);
                }
                else
                {
                    program.form.logWrite("Не удалось переименовать подкомнату '" + oldSubRoomName + "' в '" + newSubRoomName + "'. Подкомната с таким именем уже существует.", 3);
                    //MessageBox.Show("Нельзя переименовать подкомнату " + oldSubRoomName + " в " + newSubRoomName + " т.к. подкомната с таким именем уже существует.", "Game Logoc: public void changeSubRoomName(string oldSubRoomName, string newSubRoomName)");
                }
            }
            else
            {
                program.form.logWrite("Не удалось переименовать подкомнату '" + oldSubRoomName + "'. Такой подкомнаты не существует.", 3);
                //MessageBox.Show("Невозможно переименовать подкомнату" + oldSubRoomName + ", т.к. такой подкомнаты не существует.", "Game Logic: public void changeSubRoomName(string oldSubRoomName, string newSubRoomName)");
            }
        }
        /// <summary>
        /// Задает новый тип подкомнате, не зависимо от того, каким был тип подкомнаты до этого.
        /// </summary>
        /// <param name="subRoomName">Имя подкомнаты</param>
        /// <param name="subRoomNewType">"zz", "ho", "mg"</param>
        public void changeSubRoomType(string subRoomName, string subRoomNewType)
        {
            int rm = findSubRoom(subRoomName);
            if (rm > -1)
            {
                _rooms[rm].changeSubRoomType(subRoomName, subRoomNewType);
                program.form.logWrite("Изменен тип подкомнаты  '" + subRoomName + "' на '" + subRoomNewType + "'.", 2);
            }
            else
            {
                program.form.logWrite("Не удалось изменить тип подкомнаты '" + subRoomName + "'. Подкомната не существует.", 3);
                //MessageBox.Show("Невозможно изменить тип подкомнаты " + subRoomName + ". Подкомната не существует.", "Game Logic: public void changeSubRoomType(string subRoomName, string subRoomNewType)");
            }
        }
        /// <summary>
        /// Возвращает имя комнаты, которой принадлежит подкомната
        /// </summary>
        /// <param name="subRoomName">Имя подкомнаты</param>
        /// <returns>Возвращает имя комнаты или пустую строку, если заданной подкомнаты не существует</returns>
        public string getParentRoom(string subRoomName)
        {
            string result = "";
            foreach (roomClass rm in _rooms)
            {
                if (rm.isSubRoomExist(subRoomName))
                {
                    result = rm.name;
                    break;
                }
            }
            if (result == "")
            {
                program.form.logWrite("Невозможно найти родительскую комнату для подкомнаты '" + subRoomName + "'.", 3);
                //MessageBox.Show("Невозможно найти родительскую комнату для подкомнаты " + subRoomName + ".", "Game Logic: public string getParentRoom(string subRoomName)");
            }
            return result;
        }
        /// <summary>
        /// Добавляет переход к комнате и переход к взаимной комнате. Если переходы уже есть, ничего не делает. Если комнат нет - выдает сообщение.
        /// </summary>
        /// <param name="roomName">Имя комнаты, которой добавить переход</param>
        /// <param name="junctionName">Имя комнаты, в котороую переход</param>
        public bool addJunction(string roomName, string junctionName)
        {
            int firstRoom = findRoom(roomName);
            int secondRoom = findRoom(junctionName);
            bool result = false;

            //Если обекомнаты существуют
            if (firstRoom > -1 && secondRoom > -1)
            {
                //Если не существует переход из первой комнаты во вторую
                if (!_rooms[firstRoom].isJunctionExist(junctionName))
                {
                    _rooms[firstRoom].addJunction(_rooms[secondRoom]);
                    program.form.logWrite("Добавлен переход '" + roomName + "' -> '" + junctionName + "'.", 2);
                }
                //Если не сущесвтвует переход из второй комнаты в первую
                if (!_rooms[secondRoom].isJunctionExist(roomName))
                {
                    _rooms[secondRoom].addJunction(_rooms[firstRoom]);
                    program.form.logWrite("Добавлен переход '" + junctionName + "' -> '" + roomName +"'.", 2);
                }
                result = true;
            }
            //Если ода из комнат не сущесвтует
            else
            {
                if (firstRoom == -1)
                {
                    program.form.logWrite("Не существует комната " + roomName + ". Невозможно добавить к ней переход.", 3);
                    //MessageBox.Show("Комната " + roomName + " не сущесвтует. Невозможно добавить к ней переход.", "Game Logic: public void addJunctions(string roomName, string junctionName)");
                }
                if (secondRoom == -1)
                {
                    program.form.logWrite("Не существует комната " + roomName + ". Невозможно использовать это имя в качестве перехода.", 3);
                    //MessageBox.Show("Комната " + junctionName + " не существует. Невозможно использовать это имя в качестве перехода.", "Game Logic: public void addJunctions(string roomName, string junctionName)");
                }
            }
            return result;
        }
        /// <summary>
        /// Удаляет переход из комнаты и взаимный переход. Если переход не существует - ничего не делает.
        /// </summary>
        /// <param name="roomName">Имя комнаты из которой удалить переход</param>
        /// <param name="junctionName">Имя комнаты в которую переход</param>
        public bool delJunction(string roomName, string junctionName)
        {
            bool result = false;
            int firstRoom = findRoom(roomName);
            int secondRoom = findRoom(junctionName);
            if (firstRoom > -1)
            {
                if (secondRoom > -1)
                {
                    _rooms[firstRoom].delJunction(_rooms[secondRoom]);
                    _rooms[secondRoom].delJunction(_rooms[firstRoom]);
                    program.form.logWrite("Удален переход '" + roomName + "' <-> '" + junctionName + "'.", 3);
                    result = true;
                }
                else
                {
                    program.form.logWrite("Не удалось удалить переход " + junctionName + " из комнаты " + roomName + ". Переход не найдена.", 3);
                }
            }
            else
            {
                program.form.logWrite("Не удалось удалить переход из комнаты " + roomName + ". Комната не найдена.", 3);
                //MessageBox.Show("Невозможно удалить переход из комнаты " + roomName + " поскольку она не сущесвтует.", "Game Logic: public void delJunction(string roomName, string junctionName)");
            }
            return result;
        }
        /// <summary>
        /// Возвращает количество переходов в комнате
        /// </summary>
        /// <param name="roomName">Имя комнаты</param>
        /// <returns></returns>
        public int getJunctionsCount(string roomName)
        {
            return getJunctions(roomName).Count;
        }
        /// <summary>
        /// Возвращает список всех переходов комнаты
        /// </summary>
        /// <param name="roomName">Имя комнаты</param>
        /// <returns></returns>
        public List<roomClass> getJunctions(string roomName)
        {
            int rm = findRoom(roomName);
            if (rm > -1)
            {
                return _rooms[rm].getJunctions();
            }
            else
            {
                program.form.logWrite("Не удалось взять переходы для комнаты '" + roomName + "'. Комната на найдена.", 3);
                //MessageBox.Show("Нельзя взять переходы для комнаты " + roomName + " т.к. комната на найдена.", "Game Logic: public List<roomClass> getJunctions(string roomName)");
                return new List<roomClass>();
            }
        }

        public roomClass getRoom(string name)
        {
            roomClass result = new roomClass();
            int id = findRoom(name);
            if (id > -1)
                result = _rooms[id];
            return result;
        }
        public subRoomClass getSubRoom(string name)
        {
            subRoomClass result = new subRoomClass();
            int id = findSubRoom(name);
            if (id > -1)
                result = _rooms[id].getSubRoom(name);
            return result;
        }

        /// <summary>
        /// Возвращает список комнат и подкомнат
        /// </summary>
        /// <returns></returns>
        public List<string> getGameRooms()
        {
            List<string> result = new List<string>();
            foreach (roomClass rm in _rooms)
            {
                result.Add("rm_" + rm.name);
                List<subRoomClass> sbrm = new List<subRoomClass>();
                sbrm = rm.getSubRooms();
                for (int i=0; i<sbrm.Count(); i++)
                {
                    result.Add(sbrm[i].type + "_" + sbrm[i].name);
                }
            }
            return result;
        }
    }
    /// <summary>
    /// Класс одного элемента прогресса
    /// </summary>
    [Serializable]
    public class progressItemClass
    {

        public progressItemClass()
        {
            _actionType = "";
            _actionObject = "";
            _room = new roomClass();
            _subRoom = new subRoomClass();
            toActivate = new List<string>();       
        }

        private string[] actionTypeRange = new string[] { "get", "use", "clk", "win HO", "win MG" };
        private string _actionType;
        public string actionType
        {
            get { return _actionType; }
            set
            {
                if (actionTypeRange.Contains(value))
                {
                    _actionType = value;
                }
                else
                {
                    MessageBox.Show("Задано недопустимое значение для ectionType: " + value + ".", "Game Logic: public string ectionType");
                }
            }
        }
        // объект действия (игровой предмет). Поле может быть пустым.
        private string _actionObject;      
        public string actionObject
        {
            get { return _actionObject; }
            set 
            {
                _actionObject = value;             
            }

        }
        private int _actionObjectMulti = 0;
        public int actionObjectMulti
        {
            get { return _actionObjectMulti; }
            set { _actionObjectMulti = value; }
        }
        // комната, где происходит действие
        private roomClass _room;
        public roomClass room
        {
            get { return _room; }
            set { _room = value; }
        }
        // подкомната, где происходит действие. Поле может быть пустым
        private subRoomClass _subRoom;
        public subRoomClass subRoom
        {
            get { return _subRoom; }
            set { _subRoom = value; }
        }
        // список для активации после действия
        public List<string> toActivate;
    }
    /// <summary>
    /// Класс для прогресса
    /// </summary>
    [Serializable]
    public class progressClass
    {
        public List<progressItemClass> list = new List<progressItemClass>();

        public void clear()
        {
            list.Clear();
        }
        /// <summary>
        /// Добавляет пустую строку прогресса в конец списка
        /// </summary>
        public void addNew()
        {
            list.Add(new progressItemClass());
        }
        /// <summary>
        /// Удаляет строку из списка прогресса по номеру строки. Если строки с таким номером нет, то ничего не делает
        /// </summary>
        /// <param name="rowNumber">Номер строки прогресса</param>
        public bool delete(int rowNumber)
        {
            bool result = false;
            if ((rowNumber < list.Count()) && (rowNumber >= 0))
            {
                list.Remove(list[rowNumber]);
                result = true;
            }
            else
            {
                program.form.logWrite("Не удалось удалить строку прогресса " + (rowNumber-1).ToString() + " (индекс: " + rowNumber + "). Строка с таким номером не найдена.",3);
            }
            return result;
        }

        public List<string> getGameProgress()
        {
            List<string> result = new List<string>();
            foreach (progressItemClass prg in list)
            {
                if (prg.actionType == "get" || prg.actionType == "use" || prg.actionType == "clk")
                    result.Add(prg.actionType + "_" + prg.actionObject);
                else if (prg.actionType == "win HO" || prg.actionType == "win MG")
                    result.Add("win_" + prg.subRoom.name);
            }
            return result;
        }
    }
}

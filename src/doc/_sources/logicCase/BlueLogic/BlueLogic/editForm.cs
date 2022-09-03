using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Diagnostics;
using System.Xml;
using System.IO;

namespace BlueLogic
{
    public partial class editForm : Form
    {
        public editForm()
        {
            InitializeComponent();
        }

        //флаг "все изменения сохранены"
        public bool allIsSaved = true;
        public void changesDetected()
        {
            allIsSaved = false;
            rightBoxRefresh();
            scheme.refresh();
        }

        //Проверка на изменения и запрос на сохранение, если были изменения
        private DialogResult toSaveChanges()
        {
            DialogResult result;
            if (!allIsSaved)
            {
                result = MessageBox.Show("Сохранить изменения?", "Не все изменения были сохранены", MessageBoxButtons.YesNoCancel);
                if (result == DialogResult.Yes)
                {
                    btnSave_Click(null, null);
                }
            }
            else
            {
                return DialogResult.No;
            }
            return result;
        }

        private void editForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            DialogResult result = toSaveChanges();
            if (result == DialogResult.Cancel)
            {
                e.Cancel = true;
            }
        }

        // СОХРАНЕНИЕ
        private void btnSave_Click(object sender, EventArgs e)
        {
            saveFileDialog.Filter = "Файлы BlueLogic (*.logic)|*.logic";
            saveFileDialog.ShowDialog();
        }
        private void saveFileDialog_FileOk(object sender, CancelEventArgs e)
        {
            saveFile(saveFileDialog.FileName);
        }
        public void saveFile(string fileName)
        {
            allIsSaved = program.logic.save(fileName);
        }

        // ОТКРЫТИЕ
        private void btnOpen_Click(object sender, EventArgs e)
        {
            DialogResult result = toSaveChanges();
            if (result == DialogResult.Cancel)
            {
                return;
            }            
            openFileDialog.Filter = "Файлы BlueLogic (*.logic)|*.logic";
            openFileDialog.ShowDialog();
        }
        private void openFileDialog_FileOk(object sender, CancelEventArgs e)
        {
            openFile(openFileDialog.FileName);
        }
        public void openFile(string fileName)
        {
            clearForm();
            //десериализуем файл
            if (program.logic.load(fileName))
            {
                stuffTableForm.logicLoad(program.logic);
                roomsTableForm.logicLoad(program.logic);
                progressTableForm.logicLoad(program.logic);
                changesDetected();
                allIsSaved = true;
            }
            else
            {
                MessageBox.Show("Ошибка открытия файла", "Game Logic: public void openFile(string fileName)");
            }
        }

        private void clearForm()
        {
            stuffTableForm.clearTableForm();
            roomsTableForm.clearTableForm();
            progressTableForm.clearTableForm();
            program.logic.clearAll();
            stuffTableForm.loadFromObject();
            roomsTableForm.loadFromObject();
            progressTableForm.loadFromObject();

            scheme.clear();

            richTextBoxLog.Clear();
            richTextBoxRight1.Clear();
            richTextBoxRight2.Clear();
            richTextBoxRight3.Clear();
        }

        // НОВЫЙ
        private void btnNew_Click(object sender, EventArgs e)
        {
            DialogResult result = toSaveChanges();
            if (result == DialogResult.Cancel)
            {
                return;
            }
            else if (result == DialogResult.No)
            {
                clearForm();
                allIsSaved = true;   
            }            
        }

        // ЭКСПОРТ, ПЕЧАТЬ
        private void btnExport_Click(object sender, EventArgs e)
        {
            FileStream stream = new FileStream("HOPA Logic.xls", FileMode.OpenOrCreate);
            xlsWriter writer = new xlsWriter(stream);
            writer.BeginWrite();

            writer.WriteCell(1, 0, "Export not avaliable");
            writer.WriteCell(1, 5, "HOPA Logic");
            
            writer.WriteCell(2, 0, "Sorry");

            writer.EndWrite();
            stream.Close();

            program.form.logWrite("Сгенерирован 'HOPA Logic.xls' (функция работает в тестовом режиме)", 2);
        }

        private void btnPrint_Click(object sender, EventArgs e)
        {
            program.form.logWrite("Функция печати схемы еще не реализована", 3);
        }        

        /// <summary>
        /// Отправляет сообщение в лог
        /// </summary>
        /// <param name="message">Текст сообщения</param>
        /// <param name="type">тип сообщения</param>
        public void logWrite(string message, int type)
        {
            /* type:
             * 0 - серый текст
             * 1 - черный текст
             * 2 - синий текст
             * 3 - красный текст
             */
            
            richTextBoxLog.SelectionColor = Color.DarkGray;
            richTextBoxLog.AppendText("        [ " + DateTime.Now.TimeOfDay.Hours.ToString() + ":" + DateTime.Now.TimeOfDay.Minutes.ToString() + " ]: ");

            Color textColor = Color.Black;
            switch (type)
            { 
                case 0:
                    textColor = Color.DarkGray;
                    break;
                case 1:
                    textColor = Color.Black;
                    break;
                case 2:
                    textColor = Color.Blue;
                    break;
                case 3:
                    textColor = Color.Red;    
                    break;
            }
            richTextBoxLog.SelectionColor = textColor;
            richTextBoxLog.AppendText(message + "\n");
            richTextBoxLog.SelectionStart = richTextBoxLog.Text.Length;
            richTextBoxLog.ScrollToCaret();
        }
        
        public stuffTableFormClass stuffTableForm = new stuffTableFormClass(program.logic);
        public roomsTableFormClass roomsTableForm = new roomsTableFormClass(program.logic);
        public progressTabeFormClass progressTableForm = new progressTabeFormClass(program.logic);
        private schemeClass scheme = new schemeClass(program.logic);                

        private void editForm_Shown(object sender, EventArgs e)
        {
            this.tabPage1.Controls.Add(stuffTableForm);
            this.tabPage1.Controls.Add(roomsTableForm);
            this.tabPage3.Controls.Add(progressTableForm);

            this.tabPage2.Controls.Add(scheme);
            //logWrite("Привет и добро пожаловать в BlueLogic! С помощью BlueLogic можно быстро создать или изменить логику HOPA-игры. А загрузив полученные данные в программу LogicCase в несколько кликов собрать уровни игры с готовой логикой. Приятного пользования! По всем вопросам обращайся в скайп: grishaandrianov.", 0);
            //logWrite("Григорий Андрианов, Elephant Games, Чебоксары, 2013.", 0);            
        }

        private void rightBoxRefresh()
        {
            richTextBoxRight1.Clear();            
            richTextBoxRight1.AppendText("Прогресс:" + "\n");
            int i = 0;
            foreach (progressItemClass prg in program.logic.progress.list)
            {
                richTextBoxRight1.SelectionBackColor = Color.White;
                i++;
                richTextBoxRight1.AppendText("\n " + i + "\n");
                richTextBoxRight1.SelectionBackColor = Color.Wheat;
                if (prg.actionType == "get" || prg.actionType == "use" || prg.actionType == "clk")
                {
                    richTextBoxRight1.AppendText(prg.actionType + "_" + prg.actionObject + "\n");
                    richTextBoxRight1.SelectionBackColor = Color.White;
                    richTextBoxRight1.AppendText("rm_" + prg.room.name + "\n");
                    richTextBoxRight1.AppendText(prg.subRoom.type + "_" + prg.subRoom.name + "\n");
                }
                else if (prg.actionType == "win HO" || prg.actionType == "win MG")
                {
                    richTextBoxRight1.AppendText("win_" + prg.subRoom.name + "\n");
                    richTextBoxRight1.SelectionBackColor = Color.White;
                    richTextBoxRight1.AppendText("rm_" + prg.room.name + "\n");
                }
                foreach (string str in prg.toActivate)
                    richTextBoxRight1.AppendText("=" + str + "\n");
            }
            //richTextBoxRight1.AppendText("\n\n");           
            //foreach (string str in program.logic.progress.getGameProgress())
            //{
            //    richTextBoxRight1.SelectionBackColor = Color.Wheat;
            //    richTextBoxRight1.AppendText(str + "\n");
            //}

            richTextBoxRight2.Clear();
            richTextBoxRight2.AppendText("Локации:" + "\n\n");
            foreach (string str in program.logic.rooms.getGameRooms())
            {
                if (str[0] == 'r' && str[1] == 'm')
                    richTextBoxRight2.SelectionBackColor = Color.Wheat;
                else if ((str[0] == 'm' || str[0] == 'h') && (str[1] == 'g' || str[1] == 'o'))
                    richTextBoxRight2.SelectionBackColor = Color.FromArgb(208, 255, 229);
                else
                    richTextBoxRight2.SelectionBackColor = Color.White;
                richTextBoxRight2.AppendText(str + "\n");
            }
            richTextBoxRight2.AppendText("\n");
            richTextBoxRight2.AppendText("Переходы:" + "\n");
            foreach (roomClass rm in program.logic.rooms.getRooms())
            {                
                richTextBoxRight2.SelectionBackColor = Color.Wheat;
                richTextBoxRight2.AppendText("\n" + rm.name + "\n");
                richTextBoxRight2.SelectionBackColor = Color.White;
                foreach (roomClass jnct in rm.getJunctions())
                    richTextBoxRight2.AppendText("-> " + jnct.name + "\n");
            }

            richTextBoxRight3.Clear();
            richTextBoxRight3.AppendText("Предметы:" + "\n\n");
            foreach (string str in program.logic.stuff.getGameStuff())
                richTextBoxRight3.AppendText(str + "\n");
        }

        private void btnClearLogMouseLeave(object sender, EventArgs e)
        {
            btnClearLog.BackgroundImage = Image.FromFile("img\\broom2.png");
        }

        private void btnClearLogMouseEnter(object sender, EventArgs e)
        {
            btnClearLog.BackgroundImage = Image.FromFile("img\\broom.png");
        }

        private void btnPinLogMouseEnter(object sender, EventArgs e)
        {
            btnPinLog.BackgroundImage = Image.FromFile("img\\pin.png");    
        }

        private void btnPinLogMouseLeave(object sender, EventArgs e)
        {
            btnPinLog.BackgroundImage = Image.FromFile("img\\pin2.png");
        }

        private void btnClearLog_Click(object sender, EventArgs e)
        {
            richTextBoxLog.Clear();
        }

    }

    /// <summary>
    /// Класс формы таблицы предметов
    /// </summary>
    public class stuffTableFormClass : Panel
    {
        private stuffClass _stuff;
        private string[] typeCmbRange = new string[] { "regular", "multiget", "multiuse" };  // брать из класса stuffClass
        private string typeDefault = "regular";
        private string nameDefault = "Имя нового предмета";

        TextBox newName = new TextBox();
        ComboBox newType = new ComboBox();
        Button submit = new Button();

        /// <summary>
        /// Конструтор
        /// </summary>
        public stuffTableFormClass(gameLogic logic)
        {
            _stuff = logic.stuff;

            this.Size = new Size(330, 815);
            this.Anchor = (AnchorStyles.Top | AnchorStyles.Left | AnchorStyles.Bottom);
            this.Location = new Point(2, 22);
            this.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.BackColor = Color.White;

            this.AutoScroll = true;

            addFirstRow();
            loadFromObject();
        }

        private List<Label> _numLbl = new List<Label>();
        private List<TextBox> _nameTxb = new List<TextBox>();
        private List<ComboBox> _typeCmb = new List<ComboBox>();
        private List<Button> _delBtn = new List<Button>(); 

        /// <summary>
        /// Вовзращает координаты строки таблицы по Y
        /// </summary>
        /// <param name="rowNum"></param>
        /// <returns></returns>
        private int rowY(int rowNum)
        {
            return 8 + 25 * rowNum + 25;
        }

        public void logicLoad(gameLogic logic)
        {
            _stuff = logic.stuff;
            loadFromObject();
        }

        public void clearTableForm()
        {
            for (int i = 0; i < _numLbl.Count(); i++)
            {
                this.Controls.Remove(_numLbl[i]);
                this.Controls.Remove(_nameTxb[i]);
                this.Controls.Remove(_typeCmb[i]);
                this.Controls.Remove(_delBtn[i]);
            }

            _numLbl.Clear();
            _nameTxb.Clear();
            _typeCmb.Clear();
            _delBtn.Clear();
        }

        public void loadFromObject()
        {
            clearTableForm();
            for (int i = 0; i < _stuff.getCount(); i++)
            {
                addRow(_stuff.getName(i), _stuff.getType(i));  
            }
        }

        /// <summary>
        /// Добавить первую строку таблицы, через которую добавляем элементы
        /// </summary>
        private void addFirstRow()
        {
            newName.Text = nameDefault;
            newName.ForeColor = Color.Gray;
            submit.Text = "OK";

            newName.Name = "newName_0";
            newType.Name = "newType_0";
            submit.Name = "submit_0";

            newName.Location = new Point(30, rowY(0) - 25);
            newType.Location = new Point(190, rowY(0) - 25);
            submit.Location = new Point(260, rowY(0) - 25 - 1);

            newName.Width = 150;
            newType.Width = 60;
            submit.Width = 40;

            this.Controls.Add(newName);
            this.Controls.Add(newType);
            this.Controls.Add(submit);

            newName.Enter += new EventHandler(enter);
            newName.TextChanged += new EventHandler(textChanged);
            newName.KeyDown += new KeyEventHandler(keyDown);
            newName.Leave += new EventHandler(focusLeave);

            newType.Enter += new EventHandler(enter);
            newType.TextChanged += new EventHandler(textChanged);
            newType.KeyDown += new KeyEventHandler(keyDown);
            newType.Leave += new EventHandler(focusLeave);

            newType.Items.AddRange(typeCmbRange);
            newType.AutoCompleteMode = AutoCompleteMode.Append;
            newType.AutoCompleteSource = AutoCompleteSource.ListItems;

            newType.Text = typeDefault;

            submit.Click += new EventHandler(submitClick);
            submit.KeyDown += new KeyEventHandler(submitKeyDown);
        }

        /// <summary>
        /// Добавляет строку в конец таблицы предметов
        /// </summary>
        private void addRow(string name, string type)
        {
            // Add to Lists
            _numLbl.Add(new Label());
            _nameTxb.Add(new TextBox());
            _typeCmb.Add(new ComboBox());
            _delBtn.Add(new Button());
            
            // Row №
            int rowNum = _numLbl.Count() - 1;
            this._numLbl[rowNum].Text = (rowNum + 1).ToString();

            _delBtn[rowNum].Text = "X";

            // Names
            this._numLbl[rowNum].Name = string.Format("num_{0}", rowNum);
            this._nameTxb[rowNum].Name = string.Format("name_{0}", rowNum);
            this._typeCmb[rowNum].Name = string.Format("type_{0}", rowNum);
            this._delBtn[rowNum].Name = string.Format("del_{0}", rowNum);

            _nameTxb[rowNum].Text = name;
            _typeCmb[rowNum].Text = type;

            // Location
            if (rowNum == 0)
            {
                this._numLbl[rowNum].Location = new Point(2, rowY(rowNum) - 1);
                this._nameTxb[rowNum].Location = new Point(30, rowY(rowNum));
                this._typeCmb[rowNum].Location = new Point(190, rowY(rowNum));
                this._delBtn[rowNum].Location = new Point(260, rowY(rowNum) - 1);
            }
            else
            {
                this._numLbl[rowNum].Location = new Point(2, this._numLbl[rowNum - 1].Location.Y + 25);
                this._nameTxb[rowNum].Location = new Point(30, this._nameTxb[rowNum - 1].Location.Y + 25);
                this._typeCmb[rowNum].Location = new Point(190, this._typeCmb[rowNum - 1].Location.Y + 25);
                this._delBtn[rowNum].Location = new Point(260, this._delBtn[rowNum - 1].Location.Y + 25);
            }

            // Size
            this._numLbl[rowNum].Width = 25;
            this._nameTxb[rowNum].Width = 150;
            this._typeCmb[rowNum].Width = 60;
            this._delBtn[rowNum].Width = 30;

            // Add to Controls
            this.Controls.Add(_numLbl[rowNum]);
            this.Controls.Add(_nameTxb[rowNum]);
            this.Controls.Add(_typeCmb[rowNum]);
            this.Controls.Add(_delBtn[rowNum]);

            // Events                        
            _nameTxb[rowNum].Enter += new EventHandler(enter);
            _nameTxb[rowNum].TextChanged += new EventHandler(textChanged);
            _nameTxb[rowNum].KeyDown += new KeyEventHandler(keyDown);
            _nameTxb[rowNum].Leave += new EventHandler(focusLeave);
            _delBtn[rowNum].Click += new EventHandler(delClick);

            _typeCmb[rowNum].Enter += new EventHandler(enter);
            _typeCmb[rowNum].TextChanged += new EventHandler(textChanged);
            _typeCmb[rowNum].KeyDown += new KeyEventHandler(keyDown);
            _typeCmb[rowNum].Leave += new EventHandler(focusLeave);

            // comboBox range
            _typeCmb[rowNum].Items.AddRange(typeCmbRange);
            _typeCmb[rowNum].AutoCompleteMode = AutoCompleteMode.Append;
            _typeCmb[rowNum].AutoCompleteSource = AutoCompleteSource.ListItems;

            // Align
            _numLbl[rowNum].TextAlign = ContentAlignment.MiddleRight;            

        }

        bool isTextChanged = false;
        string oldValue = "";
        string newValue = "";

        #region Event functions
        /// <summary>
        /// Возвращает имя текущего поля таблицы предметов ("name", "type"), его содержимое и номер строки в таблице
        /// </summary>
        /// <param name="sender">object sender</param>
        /// <returns>Массив строк</returns>
        private string[] getNameAndValue(object sender)
        {
            string rowNum = "";
            string fieldName = "";
            string fieldValue = "";

            if (sender is TextBox)
            {
                TextBox snd = sender as TextBox;
                fieldName = snd.Name;
                fieldValue = snd.Text;
            }
            else if (sender is ComboBox)
            {
                ComboBox snd = sender as ComboBox;
                fieldName = snd.Name;
                fieldValue = snd.Text;
            }

            if (fieldName != "")
            {
                char separator = '_';
                string[] fieldNameSplit = fieldName.Split(separator);
                fieldName = fieldNameSplit[0];
                rowNum = fieldNameSplit[1];
            }
            else
            {
                program.form.logWrite("Не найдено имя поля формы таблицы предметов", 3);
                //MessageBox.Show("Не найдено имя поля формы таблицы предметов", "edidForm: private string[] getNameAndValue(object sender)");
            }

            string[] result = { fieldName, fieldValue, rowNum };
            return result;
        }
        /// <summary>
        /// Функция на событие: focus enter
        /// </summary>
        private void enter(object sender, EventArgs e)
        {
            string[] nameValue = getNameAndValue(sender);
            string name = nameValue[0];
            oldValue = nameValue[1];
            int rowNum = Convert.ToInt32(nameValue[2]);

            isTextChanged = false;

            if (name == "newName" && oldValue == nameDefault)
            {
                newName.Text = "";
                newName.ForeColor = Color.Black;
            }
        }
        /// <summary>
        /// Функция на событие: text changed
        /// </summary>
        private void textChanged(object sender, EventArgs e)
        {
            isTextChanged = true;
            //program.form.changesDetected(); 
        }
        /// <summary>
        /// Фунция на событие: keyDown
        /// </summary>
        private void keyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
            {
                string[] nameValue = getNameAndValue(sender);
                string name = nameValue[0];
                string value = nameValue[1];
                int rowNum = Convert.ToInt32(nameValue[2]);

                if (name == "newName" && value != "" && isTextChanged)
                {
                    newType.Focus();
                }
                else if (name == "newType")
                {
                    submit.Focus();
                }
                else if (name == "name")
                {
                    _typeCmb[rowNum].Focus();
                }
                else if (rowNum < _numLbl.Count() - 1 && name == "type")
                {
                    _nameTxb[rowNum + 1].Focus();
                }
            }
        }
        /// <summary>
        /// Фунция на событие: focus leave
        /// </summary>
        private void focusLeave(object sender, EventArgs e)
        {            
            string[] nameValue = getNameAndValue(sender);
            string name = nameValue[0];
            string value = nameValue[1];
            int rowNum = Convert.ToInt32(nameValue[2]);

            int lastRowNum = _numLbl.Count() - 1;
            newValue = value;

            // Если изменили имя предмета
            if (name == "name" && value != "" && isTextChanged && oldValue != newValue)
            {
                if (!_stuff.changeName(oldValue, newValue))
                {
                    _nameTxb[rowNum].Text = oldValue;
                }
            }
            // Если новое имя предмета - пустая строка, тогда вернуть старое значение
            else if (value == "" && isTextChanged)
            {
                if (name == "name" || name == "type")
                {
                    _nameTxb[rowNum].Text = oldValue;
                }
                else if (name == "newName")
                {
                    newName.Text = oldValue;
                    if (oldValue == nameDefault)
                    {
                        newName.ForeColor = Color.Gray;
                    }
                }
            }
            // Если изменили типа предмета
            else if (name == "type" && isTextChanged && oldValue != newValue)
            {
                int result = _stuff.changeType(_nameTxb[rowNum].Text, newValue);
                if (result == -1 || result == -2)
                {
                    _typeCmb[rowNum].Text = oldValue;
                }
            }
            else if (name == "newType" && isTextChanged && oldValue != newValue)
            {
                bool allright = false;
                foreach (string str in typeCmbRange)
                {
                    if (str == newType.Text)
                    {
                        allright = true;
                        break;
                    }
                }
                if (!allright)
                {
                    newType.BackColor = Color.LightCoral;
                    //сообщение в лог
                }
                else
                {
                    newType.BackColor = Color.White;
                }
            }
            else if (name == "newName" && isTextChanged && oldValue != newValue)
            {
                string translateResult = Translator.TranslateRuEn(newName.Text);
                if (translateResult != "")
                    newName.Text = translateResult;
                else
                {
                    // Если имя предмета указано некорректно - подсветить и строку в лог
                    
                }                
            }
        }
        /// <summary>
        /// Нажатие Enter
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void submitKeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
            {
                submitNewStuff(newName.Text, newType.Text);            
            }
        }
        /// <summary>
        /// Клик по кнопке OK
        /// </summary>
        private void submitClick(object sender, EventArgs e)
        {
            submitNewStuff(newName.Text, newType.Text);
        }

        public void submitNewStuff(string name, string type)
        {
            if (newName.Text != nameDefault)
            {
                if (_stuff.add(name, type))
                {
                    addRow(newName.Text, newType.Text);
                    newName.Text = nameDefault;
                    newName.BackColor = Color.White;
                    newName.Focus();
                }
                else
                {
                    newName.Focus();
                    newName.BackColor = Color.LightCoral;
                    // Сообщение в лог
                }
            }
        }

        public void delClick(object sender, EventArgs e)
        {
            Button btn = sender as Button;
            int rowNumToDel = Convert.ToInt32(btn.Name.Split('_')[1]);

            // Скрытваем контролы
            this.Controls.Remove(_numLbl[rowNumToDel]);
            this.Controls.Remove(_nameTxb[rowNumToDel]);
            this.Controls.Remove(_typeCmb[rowNumToDel]);
            this.Controls.Remove(_delBtn[rowNumToDel]);
            // удаляем предмет из объекта игровых предметов
            _stuff.remove(_nameTxb[rowNumToDel].Text);
            // Удаляем контролы             
            _numLbl.Remove(_numLbl[rowNumToDel]);
            _nameTxb.Remove(_nameTxb[rowNumToDel]);
            _typeCmb.Remove(_typeCmb[rowNumToDel]);
            _delBtn.Remove(_delBtn[rowNumToDel]);
            // Переименовываем контролы и изменяем их координаты
            int count = _numLbl.Count();
            for (int rowNum = 0; rowNum < count; rowNum++)
            {
                this._numLbl[rowNum].Text = (rowNum + 1).ToString();

                // Names
                this._numLbl[rowNum].Name = string.Format("num_{0}", rowNum);
                this._nameTxb[rowNum].Name = string.Format("name_{0}", rowNum);
                this._typeCmb[rowNum].Name = string.Format("type_{0}", rowNum);
                this._delBtn[rowNum].Name = string.Format("del_{0}", rowNum);

                // Location
                if (rowNum == 0)
                {
                    this._numLbl[rowNum].Location = new Point(2, rowY(rowNum) - 1);
                    this._nameTxb[rowNum].Location = new Point(30, rowY(rowNum));
                    this._typeCmb[rowNum].Location = new Point(190, rowY(rowNum));
                    this._delBtn[rowNum].Location = new Point(260, rowY(rowNum) - 1);
                }
                else
                {
                    this._numLbl[rowNum].Location = new Point(2, this._numLbl[rowNum - 1].Location.Y + 25);
                    this._nameTxb[rowNum].Location = new Point(30, this._nameTxb[rowNum - 1].Location.Y + 25);
                    this._typeCmb[rowNum].Location = new Point(190, this._typeCmb[rowNum - 1].Location.Y + 25);
                    this._delBtn[rowNum].Location = new Point(260, this._delBtn[rowNum - 1].Location.Y + 25);
                }
            }
        }
        #endregion
    }

    public class roomsTableFormClass : Panel
    {
        private roomsClass _rooms;
        private string[] subRoomTypeRange = new string[] { "zz", "mg", "ho" }; // брать из класса roomsClass
        private string subRoomTypeDefault = "zz";
        private string roomNameDefault = "Имя новой комнаты";
        private string subRoomNameDefault = "Имя новой подкомнаты";
        private string junctionDefaultText = "Переход в комнату";

        /// <summary>
        /// Конструктор
        /// </summary>
        public roomsTableFormClass(gameLogic logic)
        {
            _rooms = logic.rooms;

            this.Size = new Size(1148, 815);
            this.Anchor = (AnchorStyles.Top | AnchorStyles.Right | AnchorStyles.Bottom | AnchorStyles.Left);
            this.Location = new Point(335, 22);
            this.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.BackColor = Color.White;

            this.AutoScroll = true;

            addFirstRow();
            loadFromObject();
        }

        public void logicLoad(gameLogic logic)
        {
            _rooms = logic.rooms;
            loadFromObject();
        }

        private int rowY(int rowNum)
        {
            return 8 + 25 * rowNum + 30;
        }

        // Коордианты строк по Y. В каждом списке первая координата - для строки комнаты, следующие для строк подкомнат
        private List<List<int>> _yCoords = new List<List<int>>();

        /// <summary>
        /// Контролы для добавления комнат
        /// </summary>
        TextBox _newRoomName = new TextBox();
        Button _submitRoom = new Button();

        /// <summary>
        /// Списки контролов для комнат
        /// </summary>
        private List<Label> _numRoom = new List<Label>();
        private List<Button> _delRoom = new List<Button>();
        private List<TextBox> _nameRoom = new List<TextBox>();
        private List<List<ComboBoxExtended>> _junctionsCombo = new List<List<ComboBoxExtended>>();
        /// <summary>
        /// Списки контролов для добавления подкомнат
        /// </summary>
        private List<TextBoxExtended> _newSubRoomName = new List<TextBoxExtended>();
        private List<ComboBoxExtended> _newSubRoomType = new List<ComboBoxExtended>();
        private List<ButtonExtended> _submitSubRoom = new List<ButtonExtended>();

        /// <summary>
        /// Списки контролов для подкомнат
        /// </summary>
        private List<List<ComboBoxExtended>> _subRoomType = new List<List<ComboBoxExtended>>();
        private List<List<TextBoxExtended>> _subRoomName = new List<List<TextBoxExtended>>();
        private List<List<ButtonExtended>> _delSubRoom = new List<List<ButtonExtended>>();


        /// <summary>
        /// Добавляет первую строку контролов, которая для к=добавления комнат
        /// </summary>
        private void addFirstRow()
        {
            _newRoomName.Text = roomNameDefault;
            _newRoomName.ForeColor = Color.Gray;
            _submitRoom.Text = "OK";

            _newRoomName.Name = "newRoomName";
            _submitRoom.Name = "submitRoom";

            _newRoomName.Width = 150;
            _submitRoom.Width = 40;

            _newRoomName.Location = new Point(30, rowY(0) - 30);
            _submitRoom.Location = new Point(190, rowY(0) - 30 - 2);

            this.Controls.Add(_newRoomName);
            this.Controls.Add(_submitRoom);

            _newRoomName.Enter += new EventHandler(newRoomNameEnter);
            _newRoomName.TextChanged += new EventHandler(newRoomNameTextChanched);
            _newRoomName.KeyDown += new KeyEventHandler(newRoomNameKeyDown);
            _newRoomName.Leave += new EventHandler(newRoomNameLeave);

            _submitRoom.Click += new EventHandler(submitRoomClick);
            _submitRoom.KeyDown += new KeyEventHandler(submitRoomKeyDown);
        }
        /// <summary>
        /// Добавляет строку контролов новой комнаты
        /// </summary>
        /// <param name="roomName"></param>
        private void addRoomRow(string roomName)
        {
            // контролы комнаты
            _delRoom.Add(new Button());
            _numRoom.Add(new Label());            
            _nameRoom.Add(new TextBox());
            _junctionsCombo.Add(new List<ComboBoxExtended>());
            _yCoords.Add(new List<int>());
            
            int roomNum = _numRoom.Count() - 1;
            _numRoom[roomNum].Text = (roomNum + 1).ToString();
            _delRoom[roomNum].Text = "X";
            _nameRoom[roomNum].Text = roomName;

            _junctionsCombo[roomNum].Add(new ComboBoxExtended());            
            _junctionsCombo[roomNum][0].ForeColor = Color.Gray;
            _junctionsCombo[roomNum][0].Text = junctionDefaultText;
            _junctionsCombo[roomNum][0].Sorted = true;

            _delRoom[roomNum].Width = 30;
            _numRoom[roomNum].Width = 25;
            _nameRoom[roomNum].Width = 150;
            _junctionsCombo[roomNum][0].Width = 150;

            _yCoords[roomNum].Add(new int());
            int rowNumInRoom = _yCoords[roomNum].Count() - 1;            
            if (roomNum == 0)
                _yCoords[roomNum][rowNumInRoom] = rowY(roomNum);
            else
                _yCoords[roomNum][rowNumInRoom] = _yCoords[roomNum - 1][_yCoords[roomNum - 1].Count()-1] + 35;
            _delRoom[roomNum].Location = new Point(12, _yCoords[roomNum][rowNumInRoom] - 2);
            _numRoom[roomNum].Location = new Point(40, _yCoords[roomNum][rowNumInRoom]);
            _nameRoom[roomNum].Location = new Point(65, _yCoords[roomNum][rowNumInRoom]);
            _junctionsCombo[roomNum][0].Location = new Point(225, _yCoords[roomNum][rowNumInRoom]);

            this.Controls.Add(_delRoom[roomNum]);
            this.Controls.Add(_numRoom[roomNum]);
            this.Controls.Add(_nameRoom[roomNum]);
            this.Controls.Add(_junctionsCombo[roomNum][0]);

            _numRoom[roomNum].TextAlign = ContentAlignment.MiddleRight;

            // контролы дла добавления подкомнат
            _newSubRoomName.Add(new TextBoxExtended());
            _newSubRoomType.Add(new ComboBoxExtended());
            _submitSubRoom.Add(new ButtonExtended());

            _newSubRoomName[roomNum].Text = subRoomNameDefault;
            _newSubRoomName[roomNum].ForeColor = Color.Gray;
            _newSubRoomType[roomNum].Items.AddRange( subRoomTypeRange );
            _newSubRoomType[roomNum].Text = subRoomTypeDefault;
            _submitSubRoom[roomNum].Text = "OK";

            _newSubRoomName[roomNum].parentRoomNum = roomNum;
            _newSubRoomType[roomNum].parentRoomNum = roomNum;
            _submitSubRoom[roomNum].parentRoomNum = roomNum;
            _newSubRoomName[roomNum].parentRoomName = roomName;
            _newSubRoomType[roomNum].parentRoomName = roomName;
            _submitSubRoom[roomNum].parentRoomName = roomName;

            _junctionsCombo[roomNum][0].parentRoomNum = roomNum;
            _junctionsCombo[roomNum][0].parentRoomName = roomName;
            _junctionsCombo[roomNum][0].colNum = 0;

            _newSubRoomName[roomNum].Width = 150;
            _newSubRoomType[roomNum].Width = 60;
            _submitSubRoom[roomNum].Width = 30;

            _yCoords[roomNum].Add(_yCoords[roomNum][rowNumInRoom] + 25);
            rowNumInRoom = _yCoords[roomNum].Count() - 1;

            _newSubRoomName[roomNum].Location = new Point(90, _yCoords[roomNum][rowNumInRoom]);
            _newSubRoomType[roomNum].Location = new Point(250, _yCoords[roomNum][rowNumInRoom]);
            _submitSubRoom[roomNum].Location = new Point(320, _yCoords[roomNum][rowNumInRoom]);

            this.Controls.Add(_newSubRoomName[roomNum]);
            this.Controls.Add(_newSubRoomType[roomNum]);
            this.Controls.Add(_submitSubRoom[roomNum]);

            _newSubRoomName[roomNum].Enter += new EventHandler(newSubRoomNameEnter);
            _newSubRoomName[roomNum].TextChanged += new EventHandler(newSubRoomNameTextChanged);
            _newSubRoomName[roomNum].KeyDown += new KeyEventHandler(newSubRoomNameKeyDown);
            _newSubRoomName[roomNum].Leave += new EventHandler(newSubRoomNameLeave);

            _newSubRoomType[roomNum].Enter += new EventHandler(newSubRoomTypeEnter);
            _newSubRoomType[roomNum].TextChanged += new EventHandler(newSubRoomTypeTextChanged);
            _newSubRoomType[roomNum].KeyDown += new KeyEventHandler(newSubRoomTypeKeyDown);
            _newSubRoomType[roomNum].Leave += new EventHandler(newSubRoomTypeLeave);

            _submitSubRoom[roomNum].Click += new EventHandler(submitSubRoomClick);
            _submitSubRoom[roomNum].KeyDown += new KeyEventHandler(submitSubRoomKeyDown);

            _junctionsCombo[roomNum][0].Enter += new EventHandler(junctionsComboEnter);
            _junctionsCombo[roomNum][0].TextChanged += new EventHandler(junctionsComboTextChanged);
            _junctionsCombo[roomNum][0].KeyDown += new KeyEventHandler(junctionsComboKeyDown);
            _junctionsCombo[roomNum][0].Leave += new EventHandler(junctionsComboLeave);

            // Списки для контролов для комнат
            _subRoomType.Add(new List<ComboBoxExtended>());
            _subRoomName.Add(new List<TextBoxExtended>());
            _delSubRoom.Add(new List<ButtonExtended>());
        }
        /// <summary>
        /// Добавляет строку контролов новой подкомнаты
        /// </summary>
        /// <param name="roomNum"></param>
        private void addSubRoomRow(int roomNum, string type, string subRoomName)
        {
            // добавить контролы подкомнаты
            _subRoomType[roomNum].Add(new ComboBoxExtended());
            _subRoomName[roomNum].Add(new TextBoxExtended());
            _delSubRoom[roomNum].Add(new ButtonExtended());

            int rowNumInRoom = _yCoords[roomNum].Count() - 1;
            _yCoords[roomNum].Add(_yCoords[roomNum][rowNumInRoom] + 25);
            rowNumInRoom = _yCoords[roomNum].Count() - 1;
            
            int subRoomNum = rowNumInRoom - 2;
            _delSubRoom[roomNum][subRoomNum].Text = "X";
            _subRoomType[roomNum][subRoomNum].Text = type;
            _subRoomName[roomNum][subRoomNum].Text = subRoomName;

            _delSubRoom[roomNum][subRoomNum].parentRoomNum = roomNum;
            _subRoomType[roomNum][subRoomNum].parentRoomNum = roomNum;
            _subRoomName[roomNum][subRoomNum].parentRoomNum = roomNum;
            _delSubRoom[roomNum][subRoomNum].parentRoomName = subRoomName;
            _subRoomType[roomNum][subRoomNum].parentRoomName = subRoomName;
            _subRoomName[roomNum][subRoomNum].parentRoomName = subRoomName;

            _subRoomType[roomNum][subRoomNum].Width = 60;
            _subRoomName[roomNum][subRoomNum].Width = 150;
            _delSubRoom[roomNum][subRoomNum].Width = 30;

            _subRoomType[roomNum][subRoomNum].Location = new Point(90, _yCoords[roomNum][rowNumInRoom]);
            _subRoomName[roomNum][subRoomNum].Location = new Point(160, _yCoords[roomNum][rowNumInRoom]);
            _delSubRoom[roomNum][subRoomNum].Location = new Point(320, _yCoords[roomNum][rowNumInRoom] - 2);

            this.Controls.Add(_subRoomType[roomNum][subRoomNum]);
            this.Controls.Add(_subRoomName[roomNum][subRoomNum]);
            this.Controls.Add(_delSubRoom[roomNum][subRoomNum]);
            
            //обновить координаты контролов 
            //*
            int roomCount = _numRoom.Count() - 1;
            int subRoomCount;
            for (int i = roomNum + 1; i <= roomCount; i++)
            {

                _yCoords[i][0] = _yCoords[i][0] + 25;

                _delRoom[i].Location = new Point(_delRoom[i].Location.X, _delRoom[i].Location.Y + 25);
                _numRoom[i].Location = new Point(_numRoom[i].Location.X, _numRoom[i].Location.Y + 25);
                _nameRoom[i].Location = new Point(_nameRoom[i].Location.X, _nameRoom[i].Location.Y + 25);
                _junctionsCombo[i][0].Location = new Point(_junctionsCombo[i][0].Location.X, _junctionsCombo[i][0].Location.Y + 25);

                _yCoords[i][1] = _yCoords[i][1] + 25;
                _newSubRoomName[i].Location = new Point(_newSubRoomName[i].Location.X, _newSubRoomName[i].Location.Y + 25);
                _newSubRoomType[i].Location = new Point(_newSubRoomType[i].Location.X, _newSubRoomType[i].Location.Y + 25);
                _submitSubRoom[i].Location = new Point(_submitSubRoom[i].Location.X, _submitSubRoom[i].Location.Y + 25);

                subRoomCount = _subRoomName[i].Count() - 1;      
                
                for (int j = 0; j <= subRoomCount; j++)
                {
                    _yCoords[i][j + 2] = _yCoords[i][j + 2] + 25;
                    _subRoomType[i][j].Location = new Point(_subRoomType[i][j].Location.X, _subRoomType[i][j].Location.Y + 25);
                    _subRoomName[i][j].Location = new Point(_subRoomName[i][j].Location.X, _subRoomName[i][j].Location.Y + 25);
                    _delSubRoom[i][j].Location = new Point(_delSubRoom[i][j].Location.X, _delSubRoom[i][j].Location.Y + 25);
                }
            }
            // */
        }

        private void addJunctionCombo(int roomNum, string roomName, string junctionText)
        {
            int newJunctNum = _junctionsCombo[roomNum].Count();
            _junctionsCombo[roomNum][newJunctNum-1].Text = junctionText;
            _junctionsCombo[roomNum][newJunctNum-1].ForeColor = Color.Black;

            _junctionsCombo[roomNum].Add(new ComboBoxExtended());
            _junctionsCombo[roomNum][newJunctNum].ForeColor = Color.Gray;
            _junctionsCombo[roomNum][newJunctNum].Text = junctionDefaultText;
            _junctionsCombo[roomNum][newJunctNum].Sorted = true;

            _junctionsCombo[roomNum][newJunctNum].Width = 150;

            _junctionsCombo[roomNum][newJunctNum].Location = new Point(225 + 160 * newJunctNum, _yCoords[roomNum][0]);

            this.Controls.Add(_junctionsCombo[roomNum][newJunctNum]);

            _junctionsCombo[roomNum][newJunctNum].parentRoomNum = roomNum;
            _junctionsCombo[roomNum][newJunctNum].parentRoomName = roomName;
            _junctionsCombo[roomNum][newJunctNum].colNum = newJunctNum;

            _junctionsCombo[roomNum][newJunctNum].Enter += new EventHandler(junctionsComboEnter);
            _junctionsCombo[roomNum][newJunctNum].TextChanged += new EventHandler(junctionsComboTextChanged);
            _junctionsCombo[roomNum][newJunctNum].KeyDown += new KeyEventHandler(junctionsComboKeyDown);
            _junctionsCombo[roomNum][newJunctNum].Leave += new EventHandler(junctionsComboLeave);        
        }

        /// <summary>
        /// Отчищает все списки контролов
        /// </summary>
        public void clearTableForm()
        {
            for (int i = 0; i < _numRoom.Count(); i++)
            {
                this.Controls.Remove(_numRoom[i]);
                this.Controls.Remove(_delRoom[i]);
                this.Controls.Remove(_nameRoom[i]);
                for (int k = 0; k < _junctionsCombo[i].Count(); k++)
                {
                    this.Controls.Remove(_junctionsCombo[i][k]);
                }
                this.Controls.Remove(_newSubRoomName[i]);
                this.Controls.Remove(_newSubRoomType[i]);
                this.Controls.Remove(_submitSubRoom[i]);
                for (int j = 0; j < _subRoomName[i].Count(); j++)
                {
                    this.Controls.Remove(_subRoomName[i][j]);
                    this.Controls.Remove(_subRoomType[i][j]);
                    this.Controls.Remove(_delSubRoom[i][j]);
                }
            }
            
            _yCoords.Clear();

            _numRoom.Clear();
            _delRoom.Clear();
            _nameRoom.Clear();
            _junctionsCombo.Clear();

            _newSubRoomName.Clear();
            _newSubRoomType.Clear();
            _submitSubRoom.Clear();

            _subRoomType.Clear();
            _subRoomName.Clear();
            _delSubRoom.Clear();           
        }
        /// <summary>
        /// Загружает таблицу комнат из объекта комнат
        /// </summary>
        public void loadFromObject()
        {
            clearTableForm();
            //Проход по полям объекта и загрузка таблицы            
            int roomNum = 0;
            foreach (roomClass rm in _rooms.getRooms())
            {
                addRoomRow(rm.name);
                foreach (roomClass junct in rm.getJunctions())
                    addJunctionCombo(roomNum, rm.name, junct.name);
                foreach (subRoomClass sbrm in rm.getSubRooms())
                    addSubRoomRow(roomNum, sbrm.type, sbrm.name);                    
                roomNum++;
            }
        }

        private bool isTextChanged = false;
        private string oldValue = "";
        private string newValue = "";
        // ДОБАВЛЕНИЕ КОМНАТЫ
        //События поля нового имени комнаты
        private void newRoomNameEnter(object sender, EventArgs e)
        {
            isTextChanged = false;
            oldValue = _newRoomName.Text;

            if (_newRoomName.Text == roomNameDefault)
            {
                _newRoomName.Text = "";
                _newRoomName.ForeColor = Color.Black;
            }
        }
        private void newRoomNameTextChanched(object sender, EventArgs e)
        {
            isTextChanged = true;
            newValue = _newRoomName.Text;
            program.form.changesDetected();            
        }            
        private void newRoomNameKeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
            {
                _submitRoom.Focus();
            }
        }
        private void newRoomNameLeave(object sender, EventArgs e)
        {
            if (_newRoomName.Text == "")
            {
                _newRoomName.Text = roomNameDefault;
                _newRoomName.ForeColor = Color.Gray;
            }
            if (_newRoomName.Text != roomNameDefault && _newRoomName.Text != "" && isTextChanged && oldValue != newValue)
            {
                string translateResult = Translator.TranslateRuEn(_newRoomName.Text);
                if (translateResult != "")
                    _newRoomName.Text = translateResult;
                else
                {

                }
            }
        }
        //События кнопки добавления новой комнаты
        private void submitRoomClick(object sender, EventArgs e)
        {
            submitRoomDo(_newRoomName.Text);
        }
        private void submitRoomKeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
                submitRoomDo(_newRoomName.Text);
        }
        private void submitRoomDo(string name)
        {
            if (name != roomNameDefault)
            {
                if (_rooms.addRoom(name))
                {                    
                    loadFromObject();

                    _newRoomName.Text = roomNameDefault;
                    _newRoomName.ForeColor = Color.Gray;
                    _newRoomName.BackColor = Color.White;
                    _newRoomName.Focus();
                }
                else
                {
                    _newRoomName.Focus();
                    _newRoomName.BackColor = Color.LightCoral;
                }
            }
        }

        // ДОБАВЛЕНИЕ ПОДКОМНАТЫ
        //События поля нового имени подкомнаты
        private void newSubRoomNameEnter(object sender, EventArgs e)
        {
            isTextChanged = false;
            TextBoxExtended txb = sender as TextBoxExtended;
            oldValue = txb.Text;
            
            if (txb.Text == subRoomNameDefault)
            {
                txb.Text = "";
                txb.ForeColor = Color.Black;
            }
        }
        private void newSubRoomNameTextChanged(object sender, EventArgs e)
        {
            isTextChanged = true;
            TextBoxExtended txb = sender as TextBoxExtended;
            newValue = txb.Text;
            program.form.changesDetected();
        }
        private void newSubRoomNameKeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
            {
                TextBoxExtended txb = sender as TextBoxExtended;
                _newSubRoomType[txb.parentRoomNum].Focus();           
            }
        }
        private void newSubRoomNameLeave(object sender, EventArgs e)
        {
            TextBoxExtended txb = sender as TextBoxExtended;
            if (txb.Text == "")
            {
                txb.Text = subRoomNameDefault;
                txb.ForeColor = Color.Gray;
            }
            if (txb.Text != subRoomNameDefault && txb.Text != "" && isTextChanged && oldValue != newValue)
            {
                string translateResult = Translator.TranslateRuEn(txb.Text);
                if (translateResult != "")
                    txb.Text = translateResult;
                else
                {

                }
            }
        }
        //События поля типа новой подкомнаты
        private void newSubRoomTypeEnter(object sender, EventArgs e)
        {
            isTextChanged = false;
            ComboBox cmb = sender as ComboBox;
            oldValue = cmb.Text;
        }
        private void newSubRoomTypeTextChanged(object sender, EventArgs e)
        {
            isTextChanged = true;
            ComboBox cmb = sender as ComboBox;
            newValue = cmb.Text;
            program.form.changesDetected();
        }
        private void newSubRoomTypeKeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
            {
                ComboBoxExtended cmb = sender as ComboBoxExtended;
                _submitSubRoom[cmb.parentRoomNum].Focus();
            }
        }
        private void newSubRoomTypeLeave(object sender, EventArgs e)
        {
            ComboBoxExtended cmb = sender as ComboBoxExtended;
            bool result = false;
            foreach (string type in subRoomTypeRange)
            {
                if (cmb.Text == type)
                    result = true;
            }
            if (!result)
            {
                cmb.BackColor = Color.LightCoral;
            }
            else
            {
                cmb.BackColor = Color.White;
            }
        }
        //События кнопки добавления новой подкомнаты
        private void submitSubRoomClick(object sender, EventArgs e)
        {
            ButtonExtended btn = sender as ButtonExtended;
            submitSubRoomDo(_newSubRoomName[btn.parentRoomNum].Text, _newSubRoomType[btn.parentRoomNum].Text, _nameRoom[btn.parentRoomNum].Text, btn.parentRoomNum);
        }
        private void submitSubRoomKeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
            {
                ButtonExtended btn = sender as ButtonExtended;
                submitSubRoomDo(_newSubRoomName[btn.parentRoomNum].Text, _newSubRoomType[btn.parentRoomNum].Text, _nameRoom[btn.parentRoomNum].Text, btn.parentRoomNum);
            }
        }
        private void submitSubRoomDo(string subRoomName, string type, string roomName, int roomNum)
        {
            if (subRoomName != subRoomNameDefault)
            {
                if (_rooms.addSubRoom(roomName, type, subRoomName))
                {
                    loadFromObject();

                    _newSubRoomName[roomNum].Text = subRoomNameDefault;
                    _newSubRoomName[roomNum].ForeColor = Color.Gray;
                    _newSubRoomName[roomNum].BackColor = Color.White;                   
                    _newSubRoomName[roomNum].Focus();
                }
            }
        }

        //ПЕРЕИМЕНОВАНИЕ И УДАЛЕНИЕ КОМНАТ
        /*
        private List<Label> _numRoom = new List<Label>();
        private List<Button> _delRoom = new List<Button>();
        private List<TextBox> _nameRoom = new List<TextBox>();
        */

        //ПЕРЕИМЕНОВАНИЕ И УДАЛЕНИЕ ПОДКОМНАТ
        /*
        private List<List<ComboBoxSubRoom>> _subRoomType = new List<List<ComboBoxSubRoom>>();
        private List<List<TextBoxSubRoom>> _subRoomName = new List<List<TextBoxSubRoom>>();
        private List<List<ButtonSubRoom>> _delSubRoom = new List<List<ButtonSubRoom>>();
        */

        //ДОБАВЛЕНИЕ, ПЕРЕИМЕНОВАНИЕ И УДАЛЕНИЕ ПЕРЕХОДОВ
        private void junctionsComboEnter(object sender, EventArgs e)
        {
            isTextChanged = false;
            ComboBoxExtended cmb = sender as ComboBoxExtended;
            oldValue = cmb.Text;

            if (cmb.Text == junctionDefaultText)
            {
                cmb.Text = "";
                cmb.ForeColor = Color.Black;
            }


            //Формируем выпадающий список
            List<roomClass> existedJuncts = _rooms.getJunctions(cmb.parentRoomName);
            List<string> possibleJuncts = new List<string>();
            foreach (roomClass rm in _rooms.getRooms())
            {
                if (rm.name != cmb.parentRoomName && !existedJuncts.Contains(rm))
                {

                    possibleJuncts.Add(rm.name);
                }
            }
            cmb.Items.Clear();
            cmb.Items.AddRange(possibleJuncts.ToArray());          
        }
        private void junctionsComboTextChanged(object sender, EventArgs e)
        {
            isTextChanged = true;
            ComboBoxExtended cmb = sender as ComboBoxExtended;
            newValue = cmb.Text;
            program.form.changesDetected();
        }
        private void junctionsComboKeyDown(object sender, KeyEventArgs e)
        { 

        }
        private void junctionsComboLeave(object sender, EventArgs e)
        {            
            ComboBoxExtended cmb = sender as ComboBoxExtended;
            if (cmb.Text == "")
            {
                cmb.Text = junctionDefaultText;
                cmb.ForeColor = Color.Gray;
                if (oldValue != junctionDefaultText && _rooms.getJunctions(cmb.parentRoomName).Contains(_rooms.getRoom(oldValue)))
                {
                    program.form.logWrite("#",3);
                    _rooms.delJunction(cmb.parentRoomName, oldValue);
                    loadFromObject();
                }
            }
            else if (isTextChanged && oldValue == junctionDefaultText && oldValue != newValue && newValue != "")
            {
                if (_rooms.addJunction(cmb.parentRoomName, cmb.Text))
                {
                    cmb.BackColor = Color.White;
                    loadFromObject();
                }
                else
                {
                    cmb.BackColor = Color.LightCoral;
                }
            }
            else if (isTextChanged && oldValue != junctionDefaultText && oldValue != newValue && newValue != "")
            {
                if (_rooms.addJunction(cmb.parentRoomName, cmb.Text))
                {
                    cmb.BackColor = Color.White;
                    _rooms.delJunction(cmb.parentRoomName, oldValue);
                    loadFromObject();
                }
            }
        }
    }

    /// <summary>
    /// Класс формы таблицы прогресса
    /// </summary>
    public class progressTabeFormClass : Panel
    {
        private progressClass _progress;
        private stuffClass _stuff;
        private roomsClass _rooms;
        private gameLogic _logic;

        private string[] actionTypeRange = new string[] { "get", "use", "clk", "win HO", "win MG" }; // Взять, Применить, Кликнуть, Пройти ХО, Пройти МИ
        private string defaultActionType = "Действие";
        private string defaultActionObject = "Предмет действия";
        private string defaultActionRoom = "Комната действия";
        private string defaultActionSubRoom = "Подкомната действия";
        private string defaultToActivate = "Что активировать";

        public progressTabeFormClass(gameLogic logic)
        {
            _progress = logic.progress;
            _stuff = logic.stuff;
            _rooms = logic.rooms;

            this.Size = new Size(1478, 830);
            this.Anchor = (AnchorStyles.Top | AnchorStyles.Right | AnchorStyles.Bottom | AnchorStyles.Left);
            this.Location = new Point(5, 5);
            this.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.BackColor = Color.White;
            this.AutoScroll = true;
            
            loadFromObject();
        }

        public void logicLoad(gameLogic logic)
        {
            _progress = logic.progress;
            _stuff = logic.stuff;
            _rooms = logic.rooms;
            _logic = logic;
            loadFromObject();
        }

        private int rowY(int rowNum)
        {
            return 8 + 25 * rowNum;
        }

        private List<ButtonExtended> _delRow = new List<ButtonExtended>();
        private List<TextBoxExtended> _rowNum = new List<TextBoxExtended>();
        private List<ComboBoxExtended> _actionType = new List<ComboBoxExtended>();
        private List<ComboBoxExtended> _actionObject = new List<ComboBoxExtended>();
        private List<ComboBoxExtended> _actionRoom = new List<ComboBoxExtended>();
        private List<ComboBoxExtended> _actionSubRoom = new List<ComboBoxExtended>();
        private List<List<ComboBoxExtended>> _toActivate = new List<List<ComboBoxExtended>>();

        private int AddRowCommon()
        {
            _delRow.Add(new ButtonExtended());
            _rowNum.Add(new TextBoxExtended());
            _actionType.Add(new ComboBoxExtended());
            _actionObject.Add(new ComboBoxExtended());
            _actionRoom.Add(new ComboBoxExtended());
            _actionSubRoom.Add(new ComboBoxExtended());
            _toActivate.Add(new List<ComboBoxExtended>());

            int rowNum = _rowNum.Count() - 1;
            _toActivate[rowNum].Add(new ComboBoxExtended());

            _delRow[rowNum].rowNum = rowNum;
            _rowNum[rowNum].rowNum = rowNum;
            _actionType[rowNum].rowNum = rowNum;
            _actionObject[rowNum].rowNum = rowNum;
            _actionRoom[rowNum].rowNum = rowNum;
            _actionSubRoom[rowNum].rowNum = rowNum;
            _toActivate[rowNum][0].rowNum = rowNum;
            _toActivate[rowNum][0].colNum = 0;

            _delRow[rowNum].Text = "X";
            _rowNum[rowNum].Text = (rowNum + 1).ToString();
            _rowNum[rowNum].TextAlign = HorizontalAlignment.Right;
            _actionType[rowNum].Items.AddRange(actionTypeRange);

            _delRow[rowNum].Width = 30;
            _rowNum[rowNum].Width = 30;
            _actionType[rowNum].Width = 80;
            _actionObject[rowNum].Width = 150;
            _actionRoom[rowNum].Width = 150;
            _actionSubRoom[rowNum].Width = 150;
            _toActivate[rowNum][0].Width = 150;

            int Y;
            if (rowNum == 0)
                Y = rowY(rowNum);
            else
                Y = _rowNum[rowNum - 1].Location.Y + 25;

            _delRow[rowNum].Location = new Point(10, Y - 2);
            _rowNum[rowNum].Location = new Point(50, Y);
            _actionType[rowNum].Location = new Point(90, Y);
            _actionObject[rowNum].Location = new Point(180, Y);
            _actionRoom[rowNum].Location = new Point(340, Y);
            _actionSubRoom[rowNum].Location = new Point(500, Y);
            _toActivate[rowNum][0].Location = new Point(660, Y);

            this.Controls.Add(_delRow[rowNum]);
            this.Controls.Add(_rowNum[rowNum]);
            this.Controls.Add(_actionType[rowNum]);

            _delRow[rowNum].Click += new EventHandler(delRowClick);

            _actionType[rowNum].Enter += new EventHandler(ectionTypeEnter);
            _actionType[rowNum].TextChanged += new EventHandler(ectionTypeTextChanged);
            _actionType[rowNum].KeyDown += new KeyEventHandler(ectionTypeKeyDown);
            _actionType[rowNum].Leave += new EventHandler(ectionTypeLeave);

            _actionObject[rowNum].Enter += new EventHandler(ectionObjectEnter);
            _actionObject[rowNum].TextChanged += new EventHandler(ectionObjectTextChanged);
            _actionObject[rowNum].KeyDown += new KeyEventHandler(ectionObjectKeyDown);
            _actionObject[rowNum].Leave += new EventHandler(ectionObjectLeave);

            _actionRoom[rowNum].Enter += new EventHandler(ectionRoomEnter);
            _actionRoom[rowNum].TextChanged += new EventHandler(ectionRoomTextChanged);
            _actionRoom[rowNum].KeyDown += new KeyEventHandler(ectionRoomKeyDown);
            _actionRoom[rowNum].Leave += new EventHandler(ectionRoomLeave);

            _actionSubRoom[rowNum].Enter += new EventHandler(ectionSubRoomEnter);
            _actionSubRoom[rowNum].TextChanged += new EventHandler(ectionSubRoomTextChanged);
            _actionSubRoom[rowNum].KeyDown += new KeyEventHandler(ectionSubRoomKeyDown);
            _actionSubRoom[rowNum].Leave += new EventHandler(ectionSubRoomLeave);

            _toActivate[rowNum][0].Enter += new EventHandler(toActivateEnter);
            _toActivate[rowNum][0].TextChanged += new EventHandler(toActivateTextChanged);
            _toActivate[rowNum][0].KeyDown += new KeyEventHandler(toActivateKeyDown);
            _toActivate[rowNum][0].Leave += new EventHandler(toActivateLeave);    

            return rowNum;
        }

        private void addRow()
        {
            int rowNum = AddRowCommon();

            _actionType[rowNum].Text = defaultActionType;
            _actionType[rowNum].ForeColor = Color.Gray;
            _actionObject[rowNum].Text = defaultActionObject;
            _actionObject[rowNum].ForeColor = Color.Gray;
            _actionRoom[rowNum].Text = defaultActionRoom;
            _actionRoom[rowNum].ForeColor = Color.Gray;
            _actionSubRoom[rowNum].Text = defaultActionSubRoom;
            _actionSubRoom[rowNum].ForeColor = Color.Gray;
            _toActivate[rowNum][0].Text = defaultToActivate;
            _toActivate[rowNum][0].ForeColor = Color.Gray;    
        }

        private void addRow(progressItemClass prg)
        {
            int rowNum = AddRowCommon();

            //СДЕЛАТЬ если что-то с дефолтным текстом - тогда текст серый

            _actionType[rowNum].Text = prg.actionType;
            _actionType[rowNum].ForeColor = Color.Black;

            if (prg.actionType != "win HO" && prg.actionType != "win MG")
            { 
                _actionObject[rowNum].Text = prg.actionObject;
                _actionObject[rowNum].ForeColor = Color.Black;
                this.Controls.Add(_actionObject[rowNum]);
            }
            else if (prg.actionType == "win HO" || prg.actionType == "win MG")
            {
                _actionRoom[rowNum].Location = new Point(180, _actionRoom[rowNum].Location.Y);
                _actionSubRoom[rowNum].Location = new Point(340, _actionSubRoom[rowNum].Location.Y);
                _toActivate[rowNum][0].Location = new Point(500, _toActivate[rowNum][0].Location.Y);
            }
            this.Controls.Add(_actionRoom[rowNum]);
            this.Controls.Add(_actionSubRoom[rowNum]);
            this.Controls.Add(_toActivate[rowNum][0]);

            _actionRoom[rowNum].Text = prg.room.name;
            _actionRoom[rowNum].ForeColor = Color.Black;
            _actionSubRoom[rowNum].Text = prg.subRoom.name;
            _actionSubRoom[rowNum].ForeColor = Color.Black;
            _toActivate[rowNum][0].Text = prg.toActivate[0];
            _toActivate[rowNum][0].ForeColor = Color.Black;

            for (int i = 1; i < prg.toActivate.Count() - 1; i++)
            {
                addExtrToActivate(rowNum, prg);                    
            }

        }

        private int addExtrToActivateCommon(int rowNum)
        {
            _toActivate[rowNum].Add(new ComboBoxExtended());
            int colNum = _toActivate[rowNum].Count() - 1;

            _toActivate[rowNum][colNum].rowNum = rowNum;
            _toActivate[rowNum][colNum].colNum = colNum;
            _toActivate[rowNum][colNum].Width = 150;
            _toActivate[rowNum][colNum].Location = new Point(_toActivate[rowNum][colNum - 1].Location.X + 160, _toActivate[rowNum][colNum - 1].Location.Y);

            this.Controls.Add(_toActivate[rowNum][colNum]);

            _toActivate[rowNum][colNum].Enter += new EventHandler(toActivateEnter);
            _toActivate[rowNum][colNum].TextChanged += new EventHandler(toActivateTextChanged);
            _toActivate[rowNum][colNum].KeyDown += new KeyEventHandler(toActivateKeyDown);
            _toActivate[rowNum][colNum].Leave += new EventHandler(toActivateLeave);

            return colNum;
        }

        private void addExtrToActivate(int rowNum)
        {
            int colNum = addExtrToActivateCommon(rowNum);

            _toActivate[rowNum][colNum].Text = defaultToActivate;
            _toActivate[rowNum][colNum].ForeColor = Color.Gray;
        }

        private void addExtrToActivate(int rowNum, progressItemClass prg)
        {
            int colNum = addExtrToActivateCommon(rowNum);
            _toActivate[rowNum][colNum].Text = prg.toActivate[colNum];
            _toActivate[rowNum][colNum].ForeColor = Color.Black;
        }

        public void clearTableForm()
        {
            for (int i = 0; i < _rowNum.Count(); i++)
            {
                this.Controls.Remove(_delRow[i]);
                this.Controls.Remove(_rowNum[i]);
                this.Controls.Remove(_actionType[i]);
                this.Controls.Remove(_actionObject[i]);
                this.Controls.Remove(_actionRoom[i]);
                this.Controls.Remove(_actionSubRoom[i]);
                for (int j = 0; j < _toActivate[i].Count(); j++ )
                    this.Controls.Remove(_toActivate[i][j]);
            }

            _delRow.Clear();
            _rowNum.Clear();
            _actionType.Clear();
            _actionObject.Clear();
            _actionRoom.Clear();
            _actionSubRoom.Clear();
            _toActivate.Clear();
        }

        public void loadFromObject()
        {
            clearTableForm();

            foreach (progressItemClass prg in _progress.list)
                addRow(prg);

            addRow();
        }

        private bool isTextChanged = false;
        private string oldValue = "";
        private string newValue = "";
        private bool nextControlAdded = false;

        private void delRowClick(object sender, EventArgs e)
        {
            ButtonExtended btn = sender as ButtonExtended;
            if (_progress.delete(btn.rowNum))
            {
                loadFromObject();
            }
        }

        private void ectionTypeEnter(object sender, EventArgs e)
        {           
            nextControlAdded = false;
        }
        private void ectionTypeTextChanged(object sender, EventArgs e)
        {
            ComboBoxExtended snd = sender as ComboBoxExtended;
            snd.ForeColor = Color.Black;
            //program.form.changesDetected(); 
        }
        private void ectionTypeKeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
            { 
                ComboBoxExtended snd = sender as ComboBoxExtended;
                if (actionTypeRange.Contains(snd.Text))
                {
                    nextControlAdded = true;
                    ectionTypeAccept(snd);
                }
                else
                {

                }

            }
        }
        private void ectionTypeLeave(object sender, EventArgs e)
        {
            ComboBoxExtended snd = sender as ComboBoxExtended;
            if (snd.Text == "")
            {
                snd.Text = defaultActionType;
                snd.ForeColor = Color.Gray;
            }
            else if (!nextControlAdded && actionTypeRange.Contains(snd.Text))
            {
                ectionTypeAccept(snd);
            }
        }
        private void ectionTypeAccept(ComboBoxExtended snd)
        {
            _progress.addNew();
            _progress.list[snd.rowNum].actionType = snd.Text;
            if (snd.Text == "get" || snd.Text == "use" || snd.Text == "clk")
            {
                this.Controls.Add(_actionObject[snd.rowNum]);
                _actionObject[snd.rowNum].Focus();

                _actionRoom[snd.rowNum].Location = new Point(340, _actionRoom[snd.rowNum].Location.Y);
                _actionSubRoom[snd.rowNum].Location = new Point(500, _actionSubRoom[snd.rowNum].Location.Y);
                _toActivate[snd.rowNum][0].Location = new Point(660, _toActivate[snd.rowNum][0].Location.Y);
            }
            else if (snd.Text == "win HO" || snd.Text == "win MG")
            {
                this.Controls.Add(_actionRoom[snd.rowNum]);
                _actionRoom[snd.rowNum].Focus();

                _actionRoom[snd.rowNum].Location = new Point(180, _actionRoom[snd.rowNum].Location.Y);
                _actionSubRoom[snd.rowNum].Location = new Point(340, _actionSubRoom[snd.rowNum].Location.Y);
                _toActivate[snd.rowNum][0].Location = new Point(500, _toActivate[snd.rowNum][0].Location.Y);
            }        
        }

        private void ectionObjectEnter(object sender, EventArgs e)
        {
            ComboBoxExtended snd = sender as ComboBoxExtended;
            oldValue = snd.Text;
            isTextChanged = false;            

            snd.Items.Clear();
            snd.Items.AddRange(_stuff.getAllNames().ToArray());

            nextControlAdded = false;
        }
        private void ectionObjectTextChanged(object sender, EventArgs e)
        {
            ComboBoxExtended snd = sender as ComboBoxExtended;
            newValue = snd.Text;
            isTextChanged = true;
            snd.ForeColor = Color.Black;
            //program.form.changesDetected(); 
        }
        private void ectionObjectKeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
            {
                ComboBoxExtended snd = sender as ComboBoxExtended;
                if (isTextChanged && newValue != oldValue && newValue != defaultActionObject)
                {
                    nextControlAdded = true;
                    this.Controls.Add(_actionRoom[snd.rowNum]);                    
                    _actionRoom[snd.rowNum].Focus();
                }
            }
        }
        private void ectionObjectLeave(object sender, EventArgs e)
        {
            ComboBoxExtended snd = sender as ComboBoxExtended;
            if (newValue == "")
            {
                snd.ForeColor = Color.Gray;
                snd.Text = defaultActionObject;
            }
            else if (!nextControlAdded && isTextChanged && newValue != oldValue && newValue != defaultActionObject)
            {
                this.Controls.Add(_actionRoom[snd.rowNum]);                                
            }

            if (isTextChanged && newValue != oldValue && newValue != defaultActionObject)
            {                
                _logic.ActionObject(snd.rowNum, snd.Text);                                
            }
        }

        private void ectionRoomEnter(object sender, EventArgs e)
        {
            ComboBoxExtended snd = sender as ComboBoxExtended;            
            oldValue = snd.Text;
            isTextChanged = false;

            snd.Items.Clear();
            List<string> rmNames = new List<string>();
            foreach (roomClass rm in _rooms.getRooms())
                rmNames.Add(rm.name);
            snd.Items.AddRange(rmNames.ToArray());

            nextControlAdded = false;
        }
        private void ectionRoomTextChanged(object sender, EventArgs e)
        {
            ComboBoxExtended snd = sender as ComboBoxExtended;
            isTextChanged = true;
            newValue = snd.Text;
            snd.ForeColor = Color.Black;
            //program.form.changesDetected(); 
        }
        private void ectionRoomKeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
            {
                ComboBoxExtended snd = sender as ComboBoxExtended;
                if (isTextChanged && newValue != oldValue && newValue != defaultActionRoom)
                {                    
                    nextControlAdded = true;
                    this.Controls.Add(_actionSubRoom[snd.rowNum]);
                    this.Controls.Add(_toActivate[snd.rowNum][0]);
                    _actionSubRoom[snd.rowNum].Focus();
                    addRow();
                }
            }
        }
        private void ectionRoomLeave(object sender, EventArgs e)
        {
            ComboBoxExtended snd = sender as ComboBoxExtended;
            if (newValue == "")
            {
                snd.ForeColor = Color.Gray;
                snd.Text = defaultActionRoom;
            }
            else if (!nextControlAdded && isTextChanged && newValue != oldValue && newValue != defaultActionRoom)
            {
                this.Controls.Add(_actionSubRoom[snd.rowNum]);
                this.Controls.Add(_toActivate[snd.rowNum][0]);
                addRow();
            }        

            if (isTextChanged && newValue != oldValue && newValue != defaultActionRoom)
                _progress.list[snd.rowNum].room = _rooms.getRoom(snd.Text);
        }

        private void ectionSubRoomEnter(object sender, EventArgs e)
        {
            ComboBoxExtended snd = sender as ComboBoxExtended;
            oldValue = snd.Text;
            isTextChanged = false;

            snd.Items.Clear();
            List<string> sbrmNames = new List<string>();
            foreach (subRoomClass sbrm in _rooms.getSubRooms(_actionRoom[snd.rowNum].Text))
                sbrmNames.Add(sbrm.name);
            snd.Items.AddRange(sbrmNames.ToArray());
        }
        private void ectionSubRoomTextChanged(object sender, EventArgs e)
        {
            ComboBoxExtended snd = sender as ComboBoxExtended;
            newValue = snd.Text;
            isTextChanged = true;
            snd.ForeColor = Color.Black;
            //program.form.changesDetected(); 
        }
        private void ectionSubRoomKeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
            {
                ComboBoxExtended snd = sender as ComboBoxExtended;
                _toActivate[snd.rowNum][0].Focus();
            }
        }
        private void ectionSubRoomLeave(object sender, EventArgs e)
        {
            ComboBoxExtended snd = sender as ComboBoxExtended;
            if (isTextChanged && newValue != oldValue && newValue != defaultActionSubRoom)
                _progress.list[snd.rowNum].subRoom = _rooms.getSubRoom(snd.Text);
        }

        private void toActivateEnter(object sender, EventArgs e)
        {
            ComboBoxExtended snd = sender as ComboBoxExtended;
            oldValue = snd.Text;
            isTextChanged = false;

            snd.Items.Clear();
            List<string> toAct = new List<string>();
            toAct.AddRange(_progress.getGameProgress());
            toAct.AddRange(_rooms.getGameRooms());
            snd.Items.AddRange(toAct.ToArray());
        }
        private void toActivateTextChanged(object sender, EventArgs e)
        {
            ComboBoxExtended snd = sender as ComboBoxExtended;
            newValue = snd.Text;
            isTextChanged = true;
            snd.ForeColor = Color.Black;
            //program.form.changesDetected(); 
        }
        private void toActivateKeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
            {
                ComboBoxExtended snd = sender as ComboBoxExtended;
                if (isTextChanged && newValue != oldValue && newValue != defaultToActivate)
                {
                    _logic.toActivate(snd.rowNum, snd.Text);
                    addExtrToActivate(snd.rowNum);
                    _toActivate[snd.rowNum][snd.colNum + 1].Focus();
                }
            }
        }
        private void toActivateLeave(object sender, EventArgs e)
        {
            ComboBoxExtended snd = sender as ComboBoxExtended;
        }
    }

    public class TextBoxExtended : TextBox
    {
        public int parentRoomNum;
        public string parentRoomName;
        public int rowNum;
    }
    public class ComboBoxExtended : ComboBox
    {
        public int parentRoomNum;
        public string parentRoomName;
        public int colNum;
        public int rowNum;
    }
    public class ButtonExtended : Button
    {
        public int parentRoomNum;
        public string parentRoomName;
        public int rowNum;
    }
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Text.RegularExpressions;
using System.Drawing;
using System.IO;
using System.Windows.Forms;
using System.Drawing.Imaging;

using ClassCase;

namespace logicCase {
  enum ResCheckGroupe {
    Main,
    FileName,
    Parity,
    Weight,
    WidthHeight,
    Advice,
    Mobile,
    Animation,
    PNG,
  }

  class GameResCheckerStatus {
    public string Res;
    public bool IsPng => Res.ToLower().EndsWith(".png");
    public bool IsJpg => Res.ToLower().EndsWith(".jpg");

    public string FileName;
    public bool IsValidFileName;
    public bool IsFileExists;

    public bool IsWarnings;

    public bool IsSprite => IsPng || IsJpg;
    public int Width;
    public int Height;
    public long WeightCurrent;
    public long WeightBest;

    public bool IsAnimation;

    private static bool initialized;

    private static ImageCodecInfo encoderPng;
    private static EncoderParameters encParamsPng;

    private static ImageCodecInfo encoderJpg;
    private static EncoderParameters encParamsJpg;

    private Dictionary<ResCheckGroupe, string> Messages;

    public GameResCheckerStatus() {
      if (!initialized) {
        encoderPng = ImageCodecInfo.GetImageEncoders()
                     .First(c => c.FormatID == ImageFormat.Png.Guid);
        encParamsPng = new EncoderParameters(1);
        encParamsPng.Param[0] = new EncoderParameter(System.Drawing.Imaging.Encoder.Quality, 100L);
        //encParamsPng.Param[1] = new EncoderParameter(System.Drawing.Imaging.Encoder.RenderMethod, (int)EncoderValue.RenderProgressive);

        encoderJpg = ImageCodecInfo.GetImageEncoders()
                     .First(c => c.FormatID == ImageFormat.Jpeg.Guid);
        encParamsJpg = new EncoderParameters(2);
        encParamsJpg.Param[0] = new EncoderParameter(System.Drawing.Imaging.Encoder.Quality, 100L);
        encParamsJpg.Param[1] = new EncoderParameter(System.Drawing.Imaging.Encoder.RenderMethod,
            (int)EncoderValue.RenderProgressive);

        initialized = true;
      }

      Messages = new Dictionary<ResCheckGroupe, string>();
      foreach (var v in Enum.GetValues(typeof(ResCheckGroupe))) {
        Messages[(ResCheckGroupe)v] = "";// v.ToString();
      }
    }


    public void Init( string res,
                      float ImageWeightMaxDif,
                      float ImageWidthHeightOptimizationScale,
                      int imageWeightDifWarning) {

      //Console.WriteLine($"Init {res} ImageWeightMaxDif={ImageWeightMaxDif}");

      Res = res;

      FileName="";
      IsValidFileName=false;
      IsFileExists=false;

      IsWarnings = false;

      Width=0;
      Height=0;
      WeightCurrent = 0;
      WeightBest = 0;


      GameResCheckerStatus gameRes = this;

      if (File.Exists(gameRes.Res)) {
        gameRes.IsFileExists = true;
        gameRes.FileName = gameRes.Res.Substring(gameRes.Res.LastIndexOf("\\") + 1);

        string short_res = Res.Substring(Res.IndexOf("\\exe\\") + 1);
        short_res = short_res.Substring(short_res.IndexOf("\\") + 1);
        short_res = short_res.Substring(short_res.IndexOf("\\") + 1);
        short_res = short_res.Substring(short_res.IndexOf("\\") + 1);
        MessageAdd("Main", short_res, ResCheckGroupe.Main);


        Regex regex = new Regex("[а-яА-ЯA-Z- ]");
        Regex regex_rus = new Regex("[а-яА-Я]");
        Regex regex_big = new Regex("[A-Z]");
        Regex regex_wrong = new Regex("[A-Z]");
        //MessageBox.Show(gameRes.FileName+"\n"+gameRes.FileName.Substring(0,gameRes.FileName.IndexOf(".")));
        string fileNameDot = gameRes.FileName.Substring(0, gameRes.FileName.IndexOf("."));
        gameRes.IsValidFileName = !regex.IsMatch(fileNameDot);
        if (!gameRes.IsValidFileName) {
          gameRes.MessageAdd("ERROR", "некорректные символы в имени файла",ResCheckGroupe.FileName);
          if(regex_rus.IsMatch(fileNameDot)) {
            gameRes.MessageAdd("ERROR", "русские буквы в имени файла(" + regex_rus.Matches(
                                 fileNameDot)[0].Value + ")", ResCheckGroupe.FileName);
          }
          if (regex_big.IsMatch(fileNameDot)) {
            gameRes.MessageAdd("ERROR", "большие буквы в имени файла(" + regex_big.Matches(
                                 fileNameDot)[0].Value + ")", ResCheckGroupe.FileName);
          }
          if (regex_wrong.IsMatch(fileNameDot)) {
            gameRes.MessageAdd("ERROR", "запрещённые символы в имени файла(" + regex_wrong.Matches(
                                 fileNameDot)[0].Value + ")", ResCheckGroupe.FileName);
          }
        }



        if(gameRes.IsSprite) {
          Image image = Image.FromFile(gameRes.Res);
          gameRes.Width = image.Width;
          gameRes.Height = image.Height;

          if (gameRes.IsPng && image.PixelFormat != PixelFormat.Format32bppArgb) {
            gameRes.MessageAdd("ERROR", "Png должны сохраняться в 32 битном формате",
                               ResCheckGroupe.PNG);
          }

          if (gameRes.Width % 2 == 1 || gameRes.Height % 2 == 1) {
            if (gameRes.Width % 2 == 1 && gameRes.Height % 2 == 1)
              gameRes.MessageAdd("ERROR", "ширина и высота > нечётные (" + gameRes.Width + "*" + gameRes.Height +
                                 ")", ResCheckGroupe.Parity);
            else if (gameRes.Width % 2 == 1)
              gameRes.MessageAdd("ERROR", "ширина нечётная (" + gameRes.Width + "*" + gameRes.Height + ")",
                                 ResCheckGroupe.Parity);
            else
              gameRes.MessageAdd("ERROR", "высота нечётная (" + gameRes.Width + "*" + gameRes.Height + ")",
                                 ResCheckGroupe.Parity);
          }

          if ((gameRes.Width == 1366 && gameRes.Height == 768)
              && gameRes.Res.EndsWith("back.jpg")
             ) {
            //back
          }
          else if (gameRes.Width > 512 || gameRes.Height > 512) {
            if (gameRes.Width > 512 && gameRes.Height > 512)
              gameRes.MessageAdd("WARNING", "ширина и высота > 512 пикселей (" + gameRes.Width + "*" +
                                 gameRes.Height + ")",ResCheckGroupe.WidthHeight);
            {
              if ((gameRes.Width <= 1024 && gameRes.Height <= 256)
                  || (gameRes.Height <= 1024 && gameRes.Width <= 256)) {
                //"приемлимые" размеры
              }
              else {
                if (gameRes.Width > 512)
                  gameRes.MessageAdd("WARNING", "ширина > 512 пикселей (" + gameRes.Width + "*" + gameRes.Height + ")",
                                     ResCheckGroupe.WidthHeight);
                else
                  gameRes.MessageAdd("WARNING", "высота > 512 пикселей (" + gameRes.Width + "*" + gameRes.Height + ")",
                                     ResCheckGroupe.WidthHeight);
              }
            }
          }
          string exe_path = Application.ExecutablePath;
          exe_path = exe_path.Substring(0, exe_path.LastIndexOf("\\"));

          string resCHeckerPath = "";
          Bitmap tempImage;
          tempImage = new Bitmap(image);
          if (gameRes.Res.ToLower().EndsWith(".png")) {
            resCHeckerPath = exe_path + "\\GameResChecker.png";
            tempImage.Save(resCHeckerPath, encoderPng, encParamsPng);
          }
          else {
            resCHeckerPath = exe_path + "\\GameResChecker.jpg";
            tempImage.Save(resCHeckerPath, encoderJpg, encParamsJpg);
          }


          FileInfo fA = new FileInfo(gameRes.Res);
          FileInfo fB = new FileInfo(resCHeckerPath);

          WeightCurrent = fA.Length;
          WeightBest = fB.Length;

          if (fA.Length > (fB.Length * ImageWeightMaxDif) && ((fA.Length - fB.Length) / 1024) >= imageWeightDifWarning) {
            gameRes.MessageAdd("WARNING", "спрайт весит слишком много, сейчас: " + (fA.Length / 1024)
                               + "Kb >> оптимально: " + (fB.Length / 1024)
                               + "Kb >> выигрыш: " + ((fA.Length / 1024) - (fB.Length / 1024)) + "Kb"
                               ,ResCheckGroupe.Weight);
          }

          for (int z = 8; z < 11; z++) {
            int pow = (int)Math.Pow(2, (float)z);
            if (((gameRes.Width < (pow + 4) || (gameRes.Width < (pow * ImageWidthHeightOptimizationScale)))
                 && (gameRes.Width > pow))) {
              gameRes.MessageAdd("Advice", "можно попробывать уменьшить ширину до " + pow +
                                 " пикселей (" + gameRes.Width + "*" + gameRes.Height + ")",ResCheckGroupe.Advice);
            }

            if (((gameRes.Height < (pow + 4) || (gameRes.Height < (pow * ImageWidthHeightOptimizationScale)))
                 && (gameRes.Height > pow))) {
              gameRes.MessageAdd("Advice", "можно попробовать уменьшить высоту до " + pow +
                                 " пикселей (" + gameRes.Width + "*" + gameRes.Height + ")", ResCheckGroupe.Advice);
            }
          }

          image.Dispose();
          tempImage.Dispose();
          image = null;
          tempImage = null;
        }
        else {
          InitAnimation(gameRes.Res);
        }

      }
      else {
        gameRes.MessageAdd("ERROR", "Файл не существует!!!", ResCheckGroupe.Main);
      }

      //Console.WriteLine($"Init END");

    }

    private void InitAnimation(string res) {
      Image image = null;
      //Console.WriteLine("InitAnimation " + res);
      HashSet<string> checkedImages = new HashSet<string>();
      try {
        PropObj po = new PropObj(new FileList(res));
        if (po._objType == "animation") {
          IsAnimation = true;
          CheckAnimationSprites(po.GetChilds("obj", true), res, po);
          CheckAnimationSprites(po.GetChilds("emit", true), res);
        }
      }
      catch (Exception e) {
        Console.WriteLine("InitAnimation Catch 2 " + e.Message + " " + res);

      }
    }

    private void CheckAnimationSprites(List<PropObj> objs, string res, PropObj anim = null) {
      foreach (var obj in objs) {
        if(obj.GetPropertie("res")=="") {
          continue;
        }
        if (obj.GetPropertie("res").Contains("/")) {
          MessageAdd("NOTICE", "анимация использует вложенный ресурс >> " +
                     obj.GetPropertie("name") + " >> " + obj.GetPropertie("res"), ResCheckGroupe.Animation);
          //Console.WriteLine("ANIM вложенные спрайты >> " + res + " >> " + obj.GetPropertie("res"));
        }
        string imgRes = Path.GetDirectoryName(res) + "\\" + obj.GetPropertie("res").Replace("/", "\\") + ".png";
        FileInfo fi = new FileInfo(imgRes);
        if (!fi.Exists) {
          imgRes = Path.GetDirectoryName(res) + "\\" + obj.GetPropertie("res").Replace("/", "\\") + ".jpg";
          fi = new FileInfo(imgRes);
          if (!fi.Exists) {
            var funcString = "FuncName >> ";
            var objName = obj.GetPropertie("name");
            if (anim!=null) {
              var funcs = anim.GetChild("funcs");
              foreach(var func in funcs._childs) {
                if (func.FirstObjInChildsByName(objName)!=null) {
                  funcString = func.GetPropertie("name");
                  break;
                }
              }
            }
            MessageAdd("WARNING", "анимация использует отсутствующий ресурс >> " + funcString +
                       "  >> " + objName + " >> " + obj.GetPropertie("res"), ResCheckGroupe.Animation);
            continue;
          }
        }

      }
    }

    bool IsPowerOfTwo(int x) {
      return (x != 0) && ((x & (x - 1)) == 0);
    }

    public void MessageAdd( string groupe, string s, ResCheckGroupe rcg ) {
      if (s.Length > 0) {

        Messages[rcg] += Messages[rcg].Length > 0 ? "\n\t\t" + s : s;
        //message += "\n\t\t" + s;

        if (groupe == "WARNING" || groupe == "ERROR") {
          IsWarnings = true;
        }
      }
    }

    public string MessageGet() {
      //return message.Length>0 ? message+"\n" : message;
      string answer = "";

      string buf = "";

      int count = 1;
      while (Enum.IsDefined(typeof(ResCheckGroupe), count)) {
        if (!string.IsNullOrEmpty(buf = MessageGet((ResCheckGroupe)count)))
          answer += "\n\t\t" + buf;
        count++;
      }

      if(!string.IsNullOrEmpty(answer))
        answer = "\n" + Messages[ResCheckGroupe.Main] + answer;

      return answer;
    }

    public string MessageGet(ResCheckGroupe rcg) {
      return Messages[rcg];
    }
  }

  class GameResChecker {
    private float ImageWeightMaxDif = 1.1f;
    private float ImageWidthHeightOptimizationScale = 1.04f;
    Dictionary<string, GameResCheckerStatus> GameRes = new Dictionary<string, GameResCheckerStatus>();

    private int imageWeightDifWarning = 10;

    public GameResChecker( Propobj rules ) {
      Propobj cache = null;
      if ((cache = rules.GetChildOfType("ImageWeightDifWarning")) != null)
        imageWeightDifWarning = Convert.ToInt16(cache.Propertie("value"));

      if ((cache = rules.GetChildOfType("ImageWeightMaxDif")) != null)
        ImageWeightMaxDif = (100f+Convert.ToInt16(cache.Propertie("value")))/100f;
    }

    public void ResAdd(string filePath) {
      if (GameRes.ContainsKey(filePath))
        return;

      GameResCheckerStatus gameRes = new GameResCheckerStatus();
      gameRes.Init(filePath, ImageWeightMaxDif, ImageWidthHeightOptimizationScale, imageWeightDifWarning);

      GameRes[filePath] = gameRes;
    }

    public string GetResMessage(string filePath) {
      ResAdd(filePath);
      return GameRes[filePath].MessageGet();
    }

    public string MessageGet() {
      string s = "";

      var myList = GameRes.ToList();
      myList.Sort(
        (pair1, pair2) =>
        (pair1.Value.WeightCurrent - pair1.Value.WeightBest)
        .CompareTo(pair2.Value.WeightCurrent - pair2.Value.WeightBest));


      int count = 1;
      while (Enum.IsDefined(typeof(ResCheckGroupe), count)) {
        string ss = "";
        string buf = "";
        for (int i = 0; i < myList.Count; i++) {
          if (!string.IsNullOrEmpty(buf = myList[i].Value.MessageGet((ResCheckGroupe)count))) {
            ss += "\n" + myList[i].Value.MessageGet(ResCheckGroupe.Main)
                  + "\n\t\t" + buf;
          }


        }
        if (!string.IsNullOrEmpty(ss)) {
          s += "\n\n\n-----------------"
               + ((ResCheckGroupe)count).ToString()
               + "-----------------";
        }
        s += ss;
        count++;
      }



      return s;
    }

    public bool IsHaveMessages() {
      return MessageGet().Length > 0;
    }

    public bool isResHaveMessage( string filePath ) {
      ResAdd(filePath);
      return GameRes[filePath].MessageGet().Length > 0;
    }

    public bool isResHaveWarnings(string filePath) {
      ResAdd(filePath);
      return GameRes[filePath].IsWarnings;
    }

  }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using System.Net;
using System.IO;
using System.Windows.Forms;
using System.Text.RegularExpressions;

namespace BlueLogic
{
    // http://habrahabr.ru/post/168101/

    public static class Translator
    {
        /// <summary>
        /// Возвращает перевод строки на английский язык. Пробелы удаляет, все символы делает строчными.
        /// </summary>
        /// <param name="text"></param>
        /// <returns>Возвращает пустую строку в случае ошибки перевода</returns>
        public static string TranslateRuEn(string text)
        {                        
            string result = "";

            text = text.ToLower();
            string RegExText = "";
            foreach (Match m in Regex.Matches(text, @"[а-яa-z ]"))
            {
                RegExText = RegExText + m.Value;
            }

            try
            {
                string translateResult = "";
                foreach (XmlNode xmlText in Translator.YandexTranslate(RegExText, "en"))
                    translateResult = translateResult + xmlText.InnerText;
                string[] splitedText = translateResult.Split(' ');
                translateResult = "";
                foreach (string str in splitedText)
                    translateResult = translateResult + str;
                result = translateResult;
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Yandex translator error");
            }
            result = result.ToLower();

            result = result.Replace("а", "a");
            result = result.Replace("б", "b");
            result = result.Replace("в", "v");
            result = result.Replace("г", "g");
            result = result.Replace("д", "d");
            result = result.Replace("е", "e");
            result = result.Replace("ё", "yo");
            result = result.Replace("ж", "zh");
            result = result.Replace("з", "z");
            result = result.Replace("и", "i");
            result = result.Replace("й", "j");
            result = result.Replace("к", "k");
            result = result.Replace("л", "l");
            result = result.Replace("м", "m");
            result = result.Replace("н", "n");
            result = result.Replace("о", "o");
            result = result.Replace("п", "p");
            result = result.Replace("р", "r");
            result = result.Replace("с", "s");
            result = result.Replace("т", "t");
            result = result.Replace("у", "u");
            result = result.Replace("ф", "f");
            result = result.Replace("х", "h");
            result = result.Replace("ц", "c");
            result = result.Replace("ч", "ch");
            result = result.Replace("ш", "sh");
            result = result.Replace("щ", "sch");
            result = result.Replace("ъ", "j");
            result = result.Replace("ы", "i");
            result = result.Replace("ь", "j");
            result = result.Replace("э", "e");
            result = result.Replace("ю", "yu");
            result = result.Replace("я", "ya");

            program.form.logWrite("Переведено: '" + text + "' -> '" + result + "'.", 1);

            return result;
        }

        private static XmlNodeList YandexTranslate(string text, string lang)
        {
            string key = "trnsl.1.1.20130604T173727Z.f0048be184f27c45.8cdeb45c80018cc1f41918d49ae26e04e369917d";
            string hhtps = "https://translate.yandex.net/api/v1.5/tr/translate";
            WebRequest request = WebRequest.Create(hhtps + "?key=" + key + "&lang=" + lang + "&text=" + text);
            WebResponse response = request.GetResponse();

            using (StreamReader sr = new StreamReader(response.GetResponseStream()))
            {
                var fetchedXml = sr.ReadToEnd();

                XmlDocument d = new XmlDocument();
                d.LoadXml(fetchedXml);

                XmlNodeList textNodes = d.GetElementsByTagName("text");

                return textNodes;
            }
        }
    }
}

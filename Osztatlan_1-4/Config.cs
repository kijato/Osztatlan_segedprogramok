/*
 * Created by SharpDevelop.
 * User: KJT
 * Date: 2014.09.09.
 * Time: 8:50
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 */
using System;
using System.Configuration;

namespace Osztatlan
{
	/// <summary>
	/// Description of Config.
	/// </summary>
	public sealed class Config : ConfigurationSection
	{
		public string MunkaKönyvtár { set; get; }
		public string Szűrő { set; get; }
		
		public readonly string MegyeNév;
		public readonly char ElválasztóJel;
		
		public readonly int KörzetSorszám;
		public readonly int HónapSorszám;
		public readonly int TípusSorszám;

		public readonly string Fejléc;
		
		public readonly string OS;

		public Config()
		{	
			// A "ConfigurationManager" csak a "System.Configuration" referencia hozzáadása után érhető el!
			MunkaKönyvtár = ConfigurationManager.AppSettings["MunkaKönyvtár"];
			Szűrő = ConfigurationManager.AppSettings["Szűrő"];
			
			MegyeNév = ConfigurationManager.AppSettings["MegyeNév"];
			ElválasztóJel = ConfigurationManager.AppSettings["ElválasztóJel"][0];
			
			int.TryParse(ConfigurationManager.AppSettings["KörzetSorszám"],out KörzetSorszám);
			int.TryParse(ConfigurationManager.AppSettings["HónapSorszám"],out HónapSorszám);
			int.TryParse(ConfigurationManager.AppSettings["TípusSorszám"],out TípusSorszám);

			Fejléc = ConfigurationManager.AppSettings["Fejléc"];
			
			OS = Environment.OSVersion.ToString();
			
		} // konstruktor
		
		public void Update(string kulcs, string érték)
		{
			try
            {
                /*
                // Ez, az egyszerűbbnek tűnő megoldás nem működik:
 				ConfigurationManager.AppSettings.Set(kulcs,érték);
 				*/

 				var configFile = ConfigurationManager.OpenExeConfiguration(ConfigurationUserLevel.None);
                var settings = configFile.AppSettings.Settings;
                if (settings[kulcs] == null)
                {
                    settings.Add(kulcs, érték);
                }
                else
                {
                    settings[kulcs].Value = érték;
                }
                configFile.Save(ConfigurationSaveMode.Modified);
                ConfigurationManager.RefreshSection(configFile.AppSettings.SectionInformation.Name);

            }
            catch (Exception e)
            {
                throw new Exception("Hiba történt a konfigurációs adatok mentése során! ("+e.Message+")");
            }
		} // Update
		
	} //class
	
} //namespace

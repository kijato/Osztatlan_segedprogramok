/*
 * Created by SharpDevelop.
 * User: KJT
 * Date: 2014.09.08.
 * Time: 10:15
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 */
using System;
using System.IO;
using System.Text;

namespace Osztatlan
{
	/// <summary>
	/// Description of DataFile.
	/// </summary>
	public class DataFile
	{
		
		public string Megye { private set; get; }
		public string Név { private set; get; }
		public string Körzet { private set; get; }
		public string Hónap { private set; get; }
		public string Típus { private set; get; }
		public string Fejléc { private set; get; }
		public StringBuilder EgészFájl { private set; get; }
		public static int példányokSzáma = 0;
		public readonly int sorokSzáma = 0;
		//public readonly int[] státuszok = new int[5];
		//public readonly int[] státuszok = new int[4] {0, 0, 0, 0, 0};
		public readonly int[] sorDarabszámok = { 0, 0, 0, 0, 0 }; 
		
		public DataFile(Config c, string fajlnev)
		{
			Megye = c.MegyeNév;
			Név = fajlnev;
			fajlnev = Path.GetFileNameWithoutExtension(fajlnev);
			
			string[] split = fajlnev.Split( new Char [] {c.ElválasztóJel} );
			
			if (split.Length < 4)
			{
				throw new Exception("A(z) '"+Név+"' fájl jelen beállításokkal sajnos nem dolgozható fel...!");
			}
			
			Körzet = split[c.KörzetSorszám];
			Hónap = split[c.HónapSorszám];
			Típus = split[c.TípusSorszám];
			
			EgészFájl = new StringBuilder();
			EgészFájl.Capacity = (int) ( new FileInfo(Név) ).Length;
			
			példányokSzáma++;
			
			/*foreach (string s in split) { if ( s.Trim() != "" ) Console.WriteLine(s); }*/

			try
			{
				using (StreamReader sr = new StreamReader(Név, Encoding.GetEncoding("iso-8859-2"), false))
				{
					string aktuálisSor;
					sorokSzáma=0;
					while( ( aktuálisSor = sr.ReadLine()) != null )
					{
						sorokSzáma++;
							
						if(sorokSzáma.Equals(1))
						{
							Fejléc = aktuálisSor;
							
							if(!Fejléc.Equals(c.Fejléc))
							{
								throw new Exception("Talán ez nem is egy osztatlanos fájl...?");
							}
							
							continue;
						}

						//aktuálisSor.Trim(new char[] {' ', '\n'});
						if(aktuálisSor.Length.Equals(0) || !aktuálisSor.Contains(";"))
						{
							continue;
						}
						else
						{
							sorDarabszámok[0]++;

							EgészFájl.Append(aktuálisSor+"\n");
							
							for (int i=1; i<sorDarabszámok.Length; i++)
							{
								// if(aktuálisSor.EndsWith((i.ToString())) sorDarabszámok[i]++;
								string [] aktuálisSorTömbje = aktuálisSor.Split(new char[] {';'});
								if ( aktuálisSorTömbje[aktuálisSorTömbje.Length-3].Equals( i.ToString() ) ) sorDarabszámok[i]++;
							}
						}

					} // while
				} // using
			} // try
			catch (Exception ex)
			{
				throw new Exception(@"Olvasási hiba...!",ex);
			} // catch
			finally
			{
				/*if (fs != null) 
				fs.Close();*/
			} // finally
			
		} // konstruktor

	} // class
	
} //namespace

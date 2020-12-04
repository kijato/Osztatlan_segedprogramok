/*
 * Created by SharpDevelop.
 * User: KJT
 * Date: 2014.09.08.
 * Time: 9:50
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 */
using System;
using System.IO;
using System.Text;

namespace Osztatlan
{
	/// <summary>
	/// Description of FileBuffer.
	/// </summary>
	public class FileBuffer
	{
		
		public string Fajlnev { private set; get; }
		MemoryStream ms;
		StreamWriter sw;
		FileStream fs;

		public FileBuffer(string fajlnev)
		{
			Fajlnev = fajlnev;
			//File.Exists(Fajlnev)
			ms = new MemoryStream();
			sw = new StreamWriter(ms,Encoding.GetEncoding("iso-8859-2"));
		}
		
		~FileBuffer()
		{
			sw.Close();
			fs.Close();
			ms.Close();
		}
		
		public void Add(string sor)
		{
			sw.Write(sor);
		}
		
		public void Write()
		{
			sw.Flush();
			fs = new FileStream(Fajlnev,FileMode.Create);
			//fs = new FileStream(Fajlnev,FileMode.CreateNew);
			//fs = new FileStream(Fajlnev,FileMode.Append);
			ms.WriteTo(fs);
			sw.Dispose();
			fs.Dispose();
			ms.Dispose();		
		}
		
	}
}

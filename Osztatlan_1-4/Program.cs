/*
 * Created by SharpDevelop.
 * User: KJT
 * Date: 2014.09.08.
 * Time: 9:29
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 */
using System;
using System.Windows.Forms;
using System.IO;
using System.Runtime.InteropServices;

namespace Osztatlan
{
	/// <summary>
	/// Class with program entry point.
	/// </summary>
	internal sealed class Program
	{
		// http://www.csharp411.com/console-output-from-winforms-application/
		[DllImport( "kernel32.dll" )]
        static extern bool AttachConsole( int dwProcessId );
        private const int ATTACH_PARENT_PROCESS = -1;
        
		/// <summary>
		/// Program entry point.
		/// </summary>
		[STAThread]
		private static void Main(string[] args)
		{
			
			Config c = new Config();
			
			if (!args.Length.Equals(0))
		    {

				AttachConsole( ATTACH_PARENT_PROCESS );
				
				string[] files = new string[args.Length];

				if (c.OS.ToLower().Contains("windows"))
				{
					string szuro = args[0];
					files = Directory.GetFiles(Environment.CurrentDirectory, szuro);
				}
	
				if (c.OS.ToLower().Contains("unix"))
				{
					files = args;
				}

				Console.WriteLine("Szűrő: {0}",args[0]);
				Array.Sort(files);
				foreach (var file in files)
				{
					DataFile d = new DataFile(c, file);
					//foreach(var t in new string[]{"1","2","4","3"})
					//{
						//if (t.Equals(d.Típus))
						    Console.WriteLine("{0}\t{1}\t{2}\t{3}\t{4}\t{5}\t{6}",
						    	              d.Típus, d.Körzet, d.sorokSzáma
						    	              , d.sorDarabszámok[1], d.sorDarabszámok[2], d.sorDarabszámok[3], d.sorDarabszámok[4]);
					//}
					
				}
				
		    }
			else
			{
				Application.EnableVisualStyles();
				Application.SetCompatibleTextRenderingDefault(false);
				Application.Run(new MainForm(c));
			}
			
		}
		
	}
}

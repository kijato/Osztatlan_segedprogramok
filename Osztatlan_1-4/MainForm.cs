/*
 * Created by SharpDevelop.
 * User: KJT
 * Date: 2014.09.08.
 * Time: 9:29
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 */
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Windows.Forms;
using System.IO;
using System.Linq;

namespace Osztatlan
{
	/// <summary>
	/// Description of MainForm.
	/// </summary>
	public partial class MainForm : Form
	{

		protected Config c;
		protected List<DataFile> dataFiles;
		protected int[] státuszKódok = new int[] { 1, 2, 4, 3 };
		protected int[] darabKódok = new int[] { 0, 1, 2, 4, 3 };
		// a "0"-s sorszámú elem tartalmazza az összes darabszámot.  

#region Kódok
/*				// Típusok:
				[1] A földhivatal által megkezdett és befejezendő eljárások (földrészletek)
				[2] Soron kívül kérelem alapján megosztott földrészletek
				[3] NKP NKft. közreműködésével normál eljárás alapján megosztantó földrészletek
				[4] NKP NKft. közreműködésével a II. fejezet alapján megosztandó földrészletek
				// Státuszok:
				(1)	el nem indított eljárások (földrészletek)
				(2)	folyamatban lévő eljárások (földrészletek)
				(4)	megszűnt eljárások (földrészletek)
				(3)	befejezett eljárások (földrészletek)
*/				
#endregion			
		
		public MainForm(Config c)
		{
			//
			// The InitializeComponent() call is required for Windows Forms designer support.
			//
			InitializeComponent();
			
			//
			// TODO: Add constructor code after the InitializeComponent() call.
			//
			
			this.c = c;
			
			toolStripStatusLabel1.Text="A betöltött konfigurációs adatok: "+c.MegyeNév+" "+c.ElválasztóJel+" "+c.KörzetSorszám+" "+c.HónapSorszám+" "+c.TípusSorszám;

			MunkakönyvtárTextBox.Text = c.MunkaKönyvtár;
			if( MunkakönyvtárTextBox.Text.Equals("") || !Directory.Exists(MunkakönyvtárTextBox.Text) )
				MunkakönyvtárTextBox.Text = Directory.GetCurrentDirectory();

			SzűrőfeltételTextBox.Text = c.Szűrő;
			if( SzűrőfeltételTextBox.Text.Equals("") )
				SzűrőfeltételTextBox.Text = "*.csv";
			
			listView1.View = View.Details;
			listView1.GridLines = true;
			listView1.FullRowSelect = true;
			listView1.CheckBoxes = true;

			listView1.Clear();
			listView1.Columns.Add("Fájl", "Fájl neve");
			listView1.Columns.Add("Járás", "Járás neve");
			listView1.Columns.Add("Hónap", "Hónap kódja");
			listView1.Columns.Add("Típus", "Típus kódja");
			listView1.Columns.Add("Típus", "Típus összesen");
		  	listView1.Columns.Add("el nem indított", "el nem indított \n(1)");
		  	listView1.Columns.Add("folyamatban", "folyamatban \n(2)");
		  	listView1.Columns.Add("megszűnt", "megszűnt \n(4)");
		  	listView1.Columns.Add("befejezett", "befejezett \n(3)");
			
			dataGridView1.ReadOnly=true;
			dataGridView1.DefaultCellStyle.Font = new Font("Arrial Narrow",8);
			dataGridView1.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.AllCells;
   			dataGridView1.AutoSizeRowsMode = DataGridViewAutoSizeRowsMode.AllCells;

			dataGridView1.Columns.Clear();
   			dataGridView1.Columns.Add("Járás", "Járás neve");
			dataGridView1.Columns.Add("Hónap", "Hónap kódja");
			for(int i=1; i<=státuszKódok.Length; i++)
			{
				dataGridView1.Columns.Add("Típus", "Típus ["+i+"] összes (1-4)");
			  	dataGridView1.Columns.Add("el nem indított", "el nem indított (1)");
			  	dataGridView1.Columns.Add("folyamatban", "folyamatban (2)");
			  	dataGridView1.Columns.Add("megszűnt", "megszűnt (4)");
			  	dataGridView1.Columns.Add("befejezett", "befejezett (3)");
			}
			
			Feltöltés();

		}
		
		/// <summary>
		/// 
		/// </summary>
		void Feltöltés()
		{

		  	if(!Directory.Exists(MunkakönyvtárTextBox.Text))
		  	{
		  		toolStripStatusLabel1.Text = "A(z) '"+MunkakönyvtárTextBox.Text+"' könyvtár nem létezik!";
		  		return;
		  	}
		  	
		  	string[] files = Directory.GetFiles(MunkakönyvtárTextBox.Text,SzűrőfeltételTextBox.Text);
			
		  	dataFiles = new List<DataFile>();

		  	foreach ( string file in files )
			{
		  		if(!File.Exists(file))
				{
					return;
				}
		  		
				try
				{
					DataFile df = new DataFile(c,file);
					dataFiles.Add(df);
					toolStripStatusLabel1.Text = "A(z) '"+file+"' fájl sikeresen feltöltve!";
				}
				catch (Exception ex)
				{
					toolStripStatusLabel1.Text = ex.Message;
				}
				finally
				{
				}
			}
		  	
		  	listView1.Items.Clear();
		  	foreach(DataFile df in dataFiles)
		  	{
				List<string> egysor = new List<string>();
				egysor.Add(Path.GetFileName(df.Név));
				egysor.Add(df.Körzet);
				egysor.Add(df.Hónap);
				egysor.Add(df.Típus);
				foreach(int i in darabKódok)
				{
					egysor.Add(df.sorDarabszámok[i].ToString());
				}
				
				listView1.Items.Add( new ListViewItem( egysor.ToArray() ) );
		  	}
			listView1.AutoResizeColumns(ColumnHeaderAutoResizeStyle.ColumnContent);
			listView1.AutoResizeColumns(ColumnHeaderAutoResizeStyle.HeaderSize);
			//listView1.Sort();
		  	
			try
			{
				Összesítés();
			}
			catch (Exception ex)
			{
				MessageBox.Show(ex.Message);
			}
			
		}

		/// <summary>
		/// 
		/// </summary>
		void Összesítés()
		{
			List<string> körzetek = new List<string>();
			List<string> hónapok = new List<string>();
			List<string> egysor;
			
			foreach(DataFile df in dataFiles)
			{
				körzetek.Add(df.Körzet);
				hónapok.Add(df.Hónap);
			}
			
			dataGridView1.Rows.Clear();
			
			foreach(string k in körzetek.Distinct())
			{
				foreach(string h in hónapok.Distinct())
				{
					egysor = new List<string>();
					egysor.Add(k);
					egysor.Add(h);
					for(int i=1; i<=státuszKódok.Length; i++)
					{
						foreach(DataFile df in dataFiles)
						{
							if(df.Körzet.Equals(k) && df.Hónap.Equals(h) && df.Típus.Equals(i.ToString()))
							{
								foreach(int j in darabKódok)
								{
									egysor.Add(df.sorDarabszámok[j].ToString());
								}
							}
				  		}
					}
					dataGridView1.Rows.Add( egysor.ToArray() );
				}
			}
			dataGridView1.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.AllCells;
			dataGridView1.AutoSizeRowsMode = DataGridViewAutoSizeRowsMode.AllCells;
			dataGridView1.AutoResizeColumns();
			dataGridView1.AutoResizeRows();
			
		}

		void KilépésToolStripMenuItemClick(object sender, EventArgs e)
		{
			Application.Exit();
		}
		
		void TörlésToolStripMenuItemClick(object sender, EventArgs e)
		{
			foreach (DataGridViewRow row in dataGridView1.SelectedRows)
			{
			    if(!row.IsNewRow)
			       dataGridView1.Rows.Remove(row);
			}			
		}

		void MunkakönyvtárTextBoxDoubleClick(object sender, EventArgs e)
		{
			FolderBrowserDialog folderBrowserDialog = new FolderBrowserDialog();
			folderBrowserDialog.SelectedPath = c.MunkaKönyvtár;
			if (folderBrowserDialog.ShowDialog() == DialogResult.OK)
		    {
				MunkakönyvtárTextBox.Text = folderBrowserDialog.SelectedPath;
		    }
			Feltöltés();
		}
		
		void MunkakönyvtárTextBoxKeyUp(object sender, System.Windows.Forms.KeyEventArgs e)
		{
			c.Update("MunkaKönyvtár",MunkakönyvtárTextBox.Text);
			Feltöltés();
		}
		
		void SzűrőfeltételTextBoxKeyUp(object sender, System.Windows.Forms.KeyEventArgs e)
		{
			c.Update("Szűrő",SzűrőfeltételTextBox.Text);
			Feltöltés();
		}

		
		void FájlokMentéseToolStripMenuItemClick(object sender, EventArgs e)
		{
			FileBuffer[] fb = new FileBuffer[státuszKódok.Length+1];
			for(int i=1; i<=státuszKódok.Length; i++)
			{
				fb[i] = new FileBuffer(c.MegyeNév+"_"+i.ToString()+".csv");
				fb[i].Add(c.Fejléc+"\n");
			}
			foreach(DataFile df in dataFiles)
			{
				fb[Int32.Parse(df.Típus)].Add(df.EgészFájl.ToString());
			}
			for(int i=1; i<=státuszKódok.Length; i++)
			{
				fb[i].Write();
			}
		}
		
		void ToolStripMenuItem2Click(object sender, EventArgs e)
		{
			MessageBox.Show("Itt lesz a Súgó, ha lesz időm elkészíteni...\nEgyenlőre a program mellett lennie kellene egy szöveges fájlnak...\nOlvasd el!");
		}
		
		void NévjegyToolStripMenuItemClick(object sender, EventArgs e)
		{
			MessageBox.Show("Kérdés esetén keress meg e-mail-ben:\n\nkijato@gmail.com");
		}

	} // class

} // namespace

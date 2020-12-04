/*
 * Created by SharpDevelop.
 * User: KJT
 * Date: 2014.09.08.
 * Time: 9:29
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 */
namespace Osztatlan
{
	partial class MainForm
	{
		/// <summary>
		/// Designer variable used to keep track of non-visual components.
		/// </summary>
		private System.ComponentModel.IContainer components = null;
		
		/// <summary>
		/// Disposes resources used by the form.
		/// </summary>
		/// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
		protected override void Dispose(bool disposing)
		{
			if (disposing) {
				if (components != null) {
					components.Dispose();
				}
			}
			base.Dispose(disposing);
		}
		
		/// <summary>
		/// This method is required for Windows Forms designer support.
		/// Do not change the method contents inside the source code editor. The Forms designer might
		/// not be able to load this method if it was changed manually.
		/// </summary>
		private void InitializeComponent()
		{
			this.components = new System.ComponentModel.Container();
			System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle1 = new System.Windows.Forms.DataGridViewCellStyle();
			this.statusStrip1 = new System.Windows.Forms.StatusStrip();
			this.toolStripStatusLabel1 = new System.Windows.Forms.ToolStripStatusLabel();
			this.SzűrőfeltételTextBox = new System.Windows.Forms.TextBox();
			this.SzűrőfeltételLabel = new System.Windows.Forms.Label();
			this.MűveletekToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
			this.toolStripMenuItem1 = new System.Windows.Forms.ToolStripMenuItem();
			this.fájlokMentéseToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
			this.toolStripSeparator3 = new System.Windows.Forms.ToolStripSeparator();
			this.KilépésToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
			this.FőMenuStrip = new System.Windows.Forms.MenuStrip();
			this.SúgóToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
			this.toolStripMenuItem2 = new System.Windows.Forms.ToolStripMenuItem();
			this.NévjegyToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
			this.dataGridView1 = new System.Windows.Forms.DataGridView();
			this.dataGridViewContextMenuStrip = new System.Windows.Forms.ContextMenuStrip(this.components);
			this.TörlésToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
			this.splitContainer1 = new System.Windows.Forms.SplitContainer();
			this.listView1 = new System.Windows.Forms.ListView();
			this.MunkakönyvtárLabel = new System.Windows.Forms.Label();
			this.MunkakönyvtárTextBox = new System.Windows.Forms.TextBox();
			this.statusStrip1.SuspendLayout();
			this.FőMenuStrip.SuspendLayout();
			((System.ComponentModel.ISupportInitialize)(this.dataGridView1)).BeginInit();
			this.dataGridViewContextMenuStrip.SuspendLayout();
			((System.ComponentModel.ISupportInitialize)(this.splitContainer1)).BeginInit();
			this.splitContainer1.Panel1.SuspendLayout();
			this.splitContainer1.Panel2.SuspendLayout();
			this.splitContainer1.SuspendLayout();
			this.SuspendLayout();
			// 
			// statusStrip1
			// 
			this.statusStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
									this.toolStripStatusLabel1});
			this.statusStrip1.Location = new System.Drawing.Point(0, 451);
			this.statusStrip1.Name = "statusStrip1";
			this.statusStrip1.Size = new System.Drawing.Size(592, 22);
			this.statusStrip1.TabIndex = 0;
			this.statusStrip1.Text = "statusStrip1";
			// 
			// toolStripStatusLabel1
			// 
			this.toolStripStatusLabel1.Name = "toolStripStatusLabel1";
			this.toolStripStatusLabel1.Size = new System.Drawing.Size(10, 17);
			this.toolStripStatusLabel1.Text = "-";
			// 
			// SzűrőfeltételTextBox
			// 
			this.SzűrőfeltételTextBox.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
									| System.Windows.Forms.AnchorStyles.Left) 
									| System.Windows.Forms.AnchorStyles.Right)));
			this.SzűrőfeltételTextBox.Location = new System.Drawing.Point(112, 53);
			this.SzűrőfeltételTextBox.Name = "SzűrőfeltételTextBox";
			this.SzűrőfeltételTextBox.Size = new System.Drawing.Size(468, 20);
			this.SzűrőfeltételTextBox.TabIndex = 4;
			this.SzűrőfeltételTextBox.KeyUp += new System.Windows.Forms.KeyEventHandler(this.SzűrőfeltételTextBoxKeyUp);
			// 
			// SzűrőfeltételLabel
			// 
			this.SzűrőfeltételLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(238)));
			this.SzűrőfeltételLabel.Location = new System.Drawing.Point(6, 53);
			this.SzűrőfeltételLabel.Name = "SzűrőfeltételLabel";
			this.SzűrőfeltételLabel.Padding = new System.Windows.Forms.Padding(0, 3, 0, 0);
			this.SzűrőfeltételLabel.Size = new System.Drawing.Size(100, 20);
			this.SzűrőfeltételLabel.TabIndex = 5;
			this.SzűrőfeltételLabel.Text = "Szűrőfeltétel:";
			// 
			// MűveletekToolStripMenuItem
			// 
			this.MűveletekToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
									this.toolStripMenuItem1,
									this.fájlokMentéseToolStripMenuItem,
									this.toolStripSeparator3,
									this.KilépésToolStripMenuItem});
			this.MűveletekToolStripMenuItem.Name = "MűveletekToolStripMenuItem";
			this.MűveletekToolStripMenuItem.Size = new System.Drawing.Size(69, 20);
			this.MűveletekToolStripMenuItem.Text = "&Műveletek";
			// 
			// toolStripMenuItem1
			// 
			this.toolStripMenuItem1.Name = "toolStripMenuItem1";
			this.toolStripMenuItem1.Size = new System.Drawing.Size(179, 22);
			this.toolStripMenuItem1.Text = "M&unkakönyvtár váltás";
			this.toolStripMenuItem1.Click += new System.EventHandler(this.MunkakönyvtárTextBoxDoubleClick);
			// 
			// fájlokMentéseToolStripMenuItem
			// 
			this.fájlokMentéseToolStripMenuItem.Name = "fájlokMentéseToolStripMenuItem";
			this.fájlokMentéseToolStripMenuItem.Size = new System.Drawing.Size(179, 22);
			this.fájlokMentéseToolStripMenuItem.Text = "&Fájlok mentése";
			this.fájlokMentéseToolStripMenuItem.Click += new System.EventHandler(this.FájlokMentéseToolStripMenuItemClick);
			// 
			// toolStripSeparator3
			// 
			this.toolStripSeparator3.Name = "toolStripSeparator3";
			this.toolStripSeparator3.Size = new System.Drawing.Size(176, 6);
			// 
			// KilépésToolStripMenuItem
			// 
			this.KilépésToolStripMenuItem.Name = "KilépésToolStripMenuItem";
			this.KilépésToolStripMenuItem.Size = new System.Drawing.Size(179, 22);
			this.KilépésToolStripMenuItem.Text = "&Kilépés";
			this.KilépésToolStripMenuItem.Click += new System.EventHandler(this.KilépésToolStripMenuItemClick);
			// 
			// FőMenuStrip
			// 
			this.FőMenuStrip.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
									this.MűveletekToolStripMenuItem,
									this.SúgóToolStripMenuItem});
			this.FőMenuStrip.Location = new System.Drawing.Point(0, 0);
			this.FőMenuStrip.Name = "FőMenuStrip";
			this.FőMenuStrip.Padding = new System.Windows.Forms.Padding(0, 2, 0, 2);
			this.FőMenuStrip.Size = new System.Drawing.Size(592, 24);
			this.FőMenuStrip.TabIndex = 1;
			this.FőMenuStrip.Text = "FőMenuStrip";
			// 
			// SúgóToolStripMenuItem
			// 
			this.SúgóToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
									this.toolStripMenuItem2,
									this.NévjegyToolStripMenuItem});
			this.SúgóToolStripMenuItem.Name = "SúgóToolStripMenuItem";
			this.SúgóToolStripMenuItem.Size = new System.Drawing.Size(44, 20);
			this.SúgóToolStripMenuItem.Text = "&Súgó";
			// 
			// toolStripMenuItem2
			// 
			this.toolStripMenuItem2.Name = "toolStripMenuItem2";
			this.toolStripMenuItem2.Size = new System.Drawing.Size(152, 22);
			this.toolStripMenuItem2.Text = "S&egítség";
			this.toolStripMenuItem2.Click += new System.EventHandler(this.ToolStripMenuItem2Click);
			// 
			// NévjegyToolStripMenuItem
			// 
			this.NévjegyToolStripMenuItem.Name = "NévjegyToolStripMenuItem";
			this.NévjegyToolStripMenuItem.Size = new System.Drawing.Size(152, 22);
			this.NévjegyToolStripMenuItem.Text = "&Névjegy";
			this.NévjegyToolStripMenuItem.Click += new System.EventHandler(this.NévjegyToolStripMenuItemClick);
			// 
			// dataGridView1
			// 
			this.dataGridView1.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
			this.dataGridView1.ContextMenuStrip = this.dataGridViewContextMenuStrip;
			this.dataGridView1.Dock = System.Windows.Forms.DockStyle.Fill;
			this.dataGridView1.Location = new System.Drawing.Point(0, 0);
			this.dataGridView1.Name = "dataGridView1";
			dataGridViewCellStyle1.Font = new System.Drawing.Font("Arial", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(238)));
			this.dataGridView1.RowsDefaultCellStyle = dataGridViewCellStyle1;
			this.dataGridView1.Size = new System.Drawing.Size(570, 180);
			this.dataGridView1.TabIndex = 6;
			// 
			// dataGridViewContextMenuStrip
			// 
			this.dataGridViewContextMenuStrip.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
									this.TörlésToolStripMenuItem});
			this.dataGridViewContextMenuStrip.Name = "dataGridViewContextMenuStrip";
			this.dataGridViewContextMenuStrip.Size = new System.Drawing.Size(104, 26);
			// 
			// TörlésToolStripMenuItem
			// 
			this.TörlésToolStripMenuItem.Name = "TörlésToolStripMenuItem";
			this.TörlésToolStripMenuItem.Size = new System.Drawing.Size(103, 22);
			this.TörlésToolStripMenuItem.Text = "&Törlés";
			this.TörlésToolStripMenuItem.Click += new System.EventHandler(this.TörlésToolStripMenuItemClick);
			// 
			// splitContainer1
			// 
			this.splitContainer1.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
									| System.Windows.Forms.AnchorStyles.Left) 
									| System.Windows.Forms.AnchorStyles.Right)));
			this.splitContainer1.Location = new System.Drawing.Point(10, 79);
			this.splitContainer1.Name = "splitContainer1";
			this.splitContainer1.Orientation = System.Windows.Forms.Orientation.Horizontal;
			// 
			// splitContainer1.Panel1
			// 
			this.splitContainer1.Panel1.Controls.Add(this.listView1);
			// 
			// splitContainer1.Panel2
			// 
			this.splitContainer1.Panel2.Controls.Add(this.dataGridView1);
			this.splitContainer1.Size = new System.Drawing.Size(570, 368);
			this.splitContainer1.SplitterDistance = 184;
			this.splitContainer1.TabIndex = 7;
			// 
			// listView1
			// 
			this.listView1.Dock = System.Windows.Forms.DockStyle.Fill;
			this.listView1.Location = new System.Drawing.Point(0, 0);
			this.listView1.Name = "listView1";
			this.listView1.Size = new System.Drawing.Size(570, 184);
			this.listView1.TabIndex = 0;
			this.listView1.UseCompatibleStateImageBehavior = false;
			// 
			// MunkakönyvtárLabel
			// 
			this.MunkakönyvtárLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(238)));
			this.MunkakönyvtárLabel.Location = new System.Drawing.Point(6, 27);
			this.MunkakönyvtárLabel.Name = "MunkakönyvtárLabel";
			this.MunkakönyvtárLabel.Padding = new System.Windows.Forms.Padding(0, 3, 0, 0);
			this.MunkakönyvtárLabel.Size = new System.Drawing.Size(100, 20);
			this.MunkakönyvtárLabel.TabIndex = 10;
			this.MunkakönyvtárLabel.Text = "Munkakönyvtár:";
			// 
			// MunkakönyvtárTextBox
			// 
			this.MunkakönyvtárTextBox.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
									| System.Windows.Forms.AnchorStyles.Left) 
									| System.Windows.Forms.AnchorStyles.Right)));
			this.MunkakönyvtárTextBox.Location = new System.Drawing.Point(112, 27);
			this.MunkakönyvtárTextBox.Name = "MunkakönyvtárTextBox";
			this.MunkakönyvtárTextBox.Size = new System.Drawing.Size(468, 20);
			this.MunkakönyvtárTextBox.TabIndex = 9;
			this.MunkakönyvtárTextBox.DoubleClick += new System.EventHandler(this.MunkakönyvtárTextBoxDoubleClick);
			this.MunkakönyvtárTextBox.KeyUp += new System.Windows.Forms.KeyEventHandler(this.MunkakönyvtárTextBoxKeyUp);
			// 
			// MainForm
			// 
			this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
			this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			this.ClientSize = new System.Drawing.Size(592, 473);
			this.Controls.Add(this.splitContainer1);
			this.Controls.Add(this.statusStrip1);
			this.Controls.Add(this.FőMenuStrip);
			this.Controls.Add(this.MunkakönyvtárLabel);
			this.Controls.Add(this.SzűrőfeltételTextBox);
			this.Controls.Add(this.MunkakönyvtárTextBox);
			this.Controls.Add(this.SzűrőfeltételLabel);
			this.MainMenuStrip = this.FőMenuStrip;
			this.Name = "MainForm";
			this.Text = "\"Osztatlan\" statisztika";
			this.statusStrip1.ResumeLayout(false);
			this.statusStrip1.PerformLayout();
			this.FőMenuStrip.ResumeLayout(false);
			this.FőMenuStrip.PerformLayout();
			((System.ComponentModel.ISupportInitialize)(this.dataGridView1)).EndInit();
			this.dataGridViewContextMenuStrip.ResumeLayout(false);
			this.splitContainer1.Panel1.ResumeLayout(false);
			this.splitContainer1.Panel2.ResumeLayout(false);
			((System.ComponentModel.ISupportInitialize)(this.splitContainer1)).EndInit();
			this.splitContainer1.ResumeLayout(false);
			this.ResumeLayout(false);
			this.PerformLayout();
		}
		private System.Windows.Forms.ToolStripMenuItem fájlokMentéseToolStripMenuItem;
		private System.Windows.Forms.ListView listView1;
		private System.Windows.Forms.ToolStripMenuItem NévjegyToolStripMenuItem;
		private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem2;
		private System.Windows.Forms.ToolStripMenuItem SúgóToolStripMenuItem;
		private System.Windows.Forms.ToolStripSeparator toolStripSeparator3;
		private System.Windows.Forms.ToolStripMenuItem toolStripMenuItem1;
		private System.Windows.Forms.ToolStripMenuItem TörlésToolStripMenuItem;
		private System.Windows.Forms.ContextMenuStrip dataGridViewContextMenuStrip;
		private System.Windows.Forms.TextBox MunkakönyvtárTextBox;
		private System.Windows.Forms.Label MunkakönyvtárLabel;
		private System.Windows.Forms.ToolStripMenuItem KilépésToolStripMenuItem;
		private System.Windows.Forms.SplitContainer splitContainer1;
		private System.Windows.Forms.DataGridView dataGridView1;
		private System.Windows.Forms.Label SzűrőfeltételLabel;
		private System.Windows.Forms.TextBox SzűrőfeltételTextBox;
		private System.Windows.Forms.ToolStripStatusLabel toolStripStatusLabel1;
		private System.Windows.Forms.ToolStripMenuItem MűveletekToolStripMenuItem;
		private System.Windows.Forms.MenuStrip FőMenuStrip;
		private System.Windows.Forms.StatusStrip statusStrip1;

	}
}

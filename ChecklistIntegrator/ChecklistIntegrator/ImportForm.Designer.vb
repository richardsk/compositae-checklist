<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ImportForm
    Inherits System.Windows.Forms.Form

    'Form overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        If disposing AndAlso components IsNot Nothing Then
            components.Dispose()
        End If
        MyBase.Dispose(disposing)
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Me.Label1 = New System.Windows.Forms.Label
        Me.ProviderCombo = New System.Windows.Forms.ComboBox
        Me.AddButton = New System.Windows.Forms.Button
        Me.Label2 = New System.Windows.Forms.Label
        Me.FileText = New System.Windows.Forms.TextBox
        Me.BrowseButton = New System.Windows.Forms.Button
        Me.Label3 = New System.Windows.Forms.Label
        Me.ProgressBar1 = New System.Windows.Forms.ProgressBar
        Me.Label4 = New System.Windows.Forms.Label
        Me.MessagesText = New System.Windows.Forms.TextBox
        Me.CloseButton = New System.Windows.Forms.Button
        Me.ImportTypeCombo = New System.Windows.Forms.ComboBox
        Me.Label5 = New System.Windows.Forms.Label
        Me.ImportButton = New System.Windows.Forms.Button
        Me.Label6 = New System.Windows.Forms.Label
        Me.notesText = New System.Windows.Forms.TextBox
        Me.IntegrationButton = New System.Windows.Forms.Button
        Me.DataToImportCombo = New System.Windows.Forms.ComboBox
        Me.Label7 = New System.Windows.Forms.Label
        Me.Label8 = New System.Windows.Forms.Label
        Me.TreatNullsChecklist = New System.Windows.Forms.CheckedListBox
        Me.SuspendLayout()
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(12, 63)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(46, 13)
        Me.Label1.TabIndex = 0
        Me.Label1.Text = "Provider"
        '
        'ProviderCombo
        '
        Me.ProviderCombo.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ProviderCombo.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.ProviderCombo.FormattingEnabled = True
        Me.ProviderCombo.Location = New System.Drawing.Point(94, 60)
        Me.ProviderCombo.Name = "ProviderCombo"
        Me.ProviderCombo.Size = New System.Drawing.Size(360, 21)
        Me.ProviderCombo.TabIndex = 2
        '
        'AddButton
        '
        Me.AddButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.AddButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.AddButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.AddButton.ForeColor = System.Drawing.Color.Black
        Me.AddButton.Location = New System.Drawing.Point(460, 60)
        Me.AddButton.Name = "AddButton"
        Me.AddButton.Size = New System.Drawing.Size(75, 22)
        Me.AddButton.TabIndex = 3
        Me.AddButton.Text = "Add..."
        Me.AddButton.UseVisualStyleBackColor = False
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(12, 90)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(23, 13)
        Me.Label2.TabIndex = 3
        Me.Label2.Text = "File"
        '
        'FileText
        '
        Me.FileText.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.FileText.Location = New System.Drawing.Point(94, 87)
        Me.FileText.Name = "FileText"
        Me.FileText.Size = New System.Drawing.Size(360, 20)
        Me.FileText.TabIndex = 4
        '
        'BrowseButton
        '
        Me.BrowseButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.BrowseButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.BrowseButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.BrowseButton.ForeColor = System.Drawing.Color.Black
        Me.BrowseButton.Location = New System.Drawing.Point(460, 87)
        Me.BrowseButton.Name = "BrowseButton"
        Me.BrowseButton.Size = New System.Drawing.Size(75, 22)
        Me.BrowseButton.TabIndex = 5
        Me.BrowseButton.Text = "Browse..."
        Me.BrowseButton.UseVisualStyleBackColor = False
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Location = New System.Drawing.Point(12, 280)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(48, 13)
        Me.Label3.TabIndex = 6
        Me.Label3.Text = "Progress"
        '
        'ProgressBar1
        '
        Me.ProgressBar1.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ProgressBar1.Location = New System.Drawing.Point(94, 280)
        Me.ProgressBar1.Name = "ProgressBar1"
        Me.ProgressBar1.Size = New System.Drawing.Size(414, 23)
        Me.ProgressBar1.TabIndex = 8
        '
        'Label4
        '
        Me.Label4.AutoSize = True
        Me.Label4.Location = New System.Drawing.Point(12, 333)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(55, 13)
        Me.Label4.TabIndex = 8
        Me.Label4.Text = "Messages"
        '
        'MessagesText
        '
        Me.MessagesText.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.MessagesText.Location = New System.Drawing.Point(94, 309)
        Me.MessagesText.Multiline = True
        Me.MessagesText.Name = "MessagesText"
        Me.MessagesText.ReadOnly = True
        Me.MessagesText.ScrollBars = System.Windows.Forms.ScrollBars.Both
        Me.MessagesText.Size = New System.Drawing.Size(414, 103)
        Me.MessagesText.TabIndex = 9
        '
        'CloseButton
        '
        Me.CloseButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CloseButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.CloseButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.CloseButton.ForeColor = System.Drawing.Color.Black
        Me.CloseButton.Location = New System.Drawing.Point(460, 418)
        Me.CloseButton.Name = "CloseButton"
        Me.CloseButton.Size = New System.Drawing.Size(75, 22)
        Me.CloseButton.TabIndex = 11
        Me.CloseButton.Text = "Close"
        Me.CloseButton.UseVisualStyleBackColor = False
        '
        'ImportTypeCombo
        '
        Me.ImportTypeCombo.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ImportTypeCombo.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.ImportTypeCombo.FormattingEnabled = True
        Me.ImportTypeCombo.Location = New System.Drawing.Point(94, 33)
        Me.ImportTypeCombo.Name = "ImportTypeCombo"
        Me.ImportTypeCombo.Size = New System.Drawing.Size(360, 21)
        Me.ImportTypeCombo.TabIndex = 1
        '
        'Label5
        '
        Me.Label5.AutoSize = True
        Me.Label5.Location = New System.Drawing.Point(12, 36)
        Me.Label5.Name = "Label5"
        Me.Label5.Size = New System.Drawing.Size(31, 13)
        Me.Label5.TabIndex = 11
        Me.Label5.Text = "Type"
        '
        'ImportButton
        '
        Me.ImportButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ImportButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.ImportButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.ImportButton.ForeColor = System.Drawing.Color.Black
        Me.ImportButton.Location = New System.Drawing.Point(460, 252)
        Me.ImportButton.Name = "ImportButton"
        Me.ImportButton.Size = New System.Drawing.Size(75, 22)
        Me.ImportButton.TabIndex = 7
        Me.ImportButton.Text = "Import"
        Me.ImportButton.UseVisualStyleBackColor = False
        '
        'Label6
        '
        Me.Label6.AutoSize = True
        Me.Label6.Location = New System.Drawing.Point(12, 117)
        Me.Label6.Name = "Label6"
        Me.Label6.Size = New System.Drawing.Size(35, 13)
        Me.Label6.TabIndex = 13
        Me.Label6.Text = "Notes"
        '
        'notesText
        '
        Me.notesText.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.notesText.Location = New System.Drawing.Point(94, 113)
        Me.notesText.Multiline = True
        Me.notesText.Name = "notesText"
        Me.notesText.Size = New System.Drawing.Size(360, 48)
        Me.notesText.TabIndex = 6
        '
        'IntegrationButton
        '
        Me.IntegrationButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.IntegrationButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.IntegrationButton.Enabled = False
        Me.IntegrationButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.IntegrationButton.ForeColor = System.Drawing.Color.Black
        Me.IntegrationButton.Location = New System.Drawing.Point(316, 418)
        Me.IntegrationButton.Name = "IntegrationButton"
        Me.IntegrationButton.Size = New System.Drawing.Size(128, 22)
        Me.IntegrationButton.TabIndex = 10
        Me.IntegrationButton.Text = "Run Integration"
        Me.IntegrationButton.UseVisualStyleBackColor = False
        '
        'DataToImportCombo
        '
        Me.DataToImportCombo.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.DataToImportCombo.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.DataToImportCombo.FormattingEnabled = True
        Me.DataToImportCombo.Location = New System.Drawing.Point(94, 6)
        Me.DataToImportCombo.Name = "DataToImportCombo"
        Me.DataToImportCombo.Size = New System.Drawing.Size(360, 21)
        Me.DataToImportCombo.TabIndex = 0
        '
        'Label7
        '
        Me.Label7.AutoSize = True
        Me.Label7.Location = New System.Drawing.Point(12, 9)
        Me.Label7.Name = "Label7"
        Me.Label7.Size = New System.Drawing.Size(76, 13)
        Me.Label7.TabIndex = 15
        Me.Label7.Text = "Data for import"
        '
        'Label8
        '
        Me.Label8.AutoSize = True
        Me.Label8.Location = New System.Drawing.Point(12, 168)
        Me.Label8.Name = "Label8"
        Me.Label8.Size = New System.Drawing.Size(113, 13)
        Me.Label8.TabIndex = 16
        Me.Label8.Text = "Treat False as Null for:"
        '
        'TreatNullsChecklist
        '
        Me.TreatNullsChecklist.FormattingEnabled = True
        Me.TreatNullsChecklist.Items.AddRange(New Object() {"Name Invalid", "Name Illegitimate", "Name Misapplied", "Name Pro Parte", "Name In Citation"})
        Me.TreatNullsChecklist.Location = New System.Drawing.Point(131, 167)
        Me.TreatNullsChecklist.Name = "TreatNullsChecklist"
        Me.TreatNullsChecklist.Size = New System.Drawing.Size(323, 79)
        Me.TreatNullsChecklist.TabIndex = 17
        '
        'ImportForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(548, 454)
        Me.Controls.Add(Me.TreatNullsChecklist)
        Me.Controls.Add(Me.Label8)
        Me.Controls.Add(Me.DataToImportCombo)
        Me.Controls.Add(Me.Label7)
        Me.Controls.Add(Me.IntegrationButton)
        Me.Controls.Add(Me.notesText)
        Me.Controls.Add(Me.Label6)
        Me.Controls.Add(Me.ImportButton)
        Me.Controls.Add(Me.ImportTypeCombo)
        Me.Controls.Add(Me.Label5)
        Me.Controls.Add(Me.CloseButton)
        Me.Controls.Add(Me.MessagesText)
        Me.Controls.Add(Me.Label4)
        Me.Controls.Add(Me.ProgressBar1)
        Me.Controls.Add(Me.Label3)
        Me.Controls.Add(Me.BrowseButton)
        Me.Controls.Add(Me.FileText)
        Me.Controls.Add(Me.Label2)
        Me.Controls.Add(Me.AddButton)
        Me.Controls.Add(Me.ProviderCombo)
        Me.Controls.Add(Me.Label1)
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "ImportForm"
        Me.Text = "Import Provider Data"
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents ProviderCombo As System.Windows.Forms.ComboBox
    Friend WithEvents AddButton As System.Windows.Forms.Button
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents FileText As System.Windows.Forms.TextBox
    Friend WithEvents BrowseButton As System.Windows.Forms.Button
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents ProgressBar1 As System.Windows.Forms.ProgressBar
    Friend WithEvents Label4 As System.Windows.Forms.Label
    Friend WithEvents MessagesText As System.Windows.Forms.TextBox
    Friend WithEvents CloseButton As System.Windows.Forms.Button
    Friend WithEvents ImportTypeCombo As System.Windows.Forms.ComboBox
    Friend WithEvents Label5 As System.Windows.Forms.Label
    Friend WithEvents ImportButton As System.Windows.Forms.Button
    Friend WithEvents Label6 As System.Windows.Forms.Label
    Friend WithEvents notesText As System.Windows.Forms.TextBox
    Friend WithEvents IntegrationButton As System.Windows.Forms.Button
    Friend WithEvents DataToImportCombo As System.Windows.Forms.ComboBox
    Friend WithEvents Label7 As System.Windows.Forms.Label
    Friend WithEvents Label8 As System.Windows.Forms.Label
    Friend WithEvents TreatNullsChecklist As System.Windows.Forms.CheckedListBox
End Class

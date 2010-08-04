<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ImportAnnotationForm
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
        Me.BrowseButton = New System.Windows.Forms.Button
        Me.FileText = New System.Windows.Forms.TextBox
        Me.Label2 = New System.Windows.Forms.Label
        Me.UserCombo = New System.Windows.Forms.ComboBox
        Me.Label1 = New System.Windows.Forms.Label
        Me.importButton = New System.Windows.Forms.Button
        Me.closeButton = New System.Windows.Forms.Button
        Me.SuspendLayout()
        '
        'BrowseButton
        '
        Me.BrowseButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.BrowseButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.BrowseButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.BrowseButton.ForeColor = System.Drawing.Color.Black
        Me.BrowseButton.Location = New System.Drawing.Point(493, 15)
        Me.BrowseButton.Name = "BrowseButton"
        Me.BrowseButton.Size = New System.Drawing.Size(75, 22)
        Me.BrowseButton.TabIndex = 8
        Me.BrowseButton.Text = "Browse..."
        Me.BrowseButton.UseVisualStyleBackColor = False
        '
        'FileText
        '
        Me.FileText.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.FileText.Location = New System.Drawing.Point(80, 15)
        Me.FileText.Name = "FileText"
        Me.FileText.Size = New System.Drawing.Size(407, 20)
        Me.FileText.TabIndex = 7
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(12, 18)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(23, 13)
        Me.Label2.TabIndex = 6
        Me.Label2.Text = "File"
        '
        'UserCombo
        '
        Me.UserCombo.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.UserCombo.FormattingEnabled = True
        Me.UserCombo.Location = New System.Drawing.Point(80, 41)
        Me.UserCombo.Name = "UserCombo"
        Me.UserCombo.Size = New System.Drawing.Size(407, 21)
        Me.UserCombo.TabIndex = 10
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(12, 44)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(58, 13)
        Me.Label1.TabIndex = 9
        Me.Label1.Text = "User name"
        '
        'importButton
        '
        Me.importButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.importButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.importButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.importButton.ForeColor = System.Drawing.Color.Black
        Me.importButton.Location = New System.Drawing.Point(412, 68)
        Me.importButton.Name = "importButton"
        Me.importButton.Size = New System.Drawing.Size(75, 22)
        Me.importButton.TabIndex = 11
        Me.importButton.Text = "Import"
        Me.importButton.UseVisualStyleBackColor = False
        '
        'closeButton
        '
        Me.closeButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.closeButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.closeButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.closeButton.ForeColor = System.Drawing.Color.Black
        Me.closeButton.Location = New System.Drawing.Point(493, 116)
        Me.closeButton.Name = "closeButton"
        Me.closeButton.Size = New System.Drawing.Size(75, 22)
        Me.closeButton.TabIndex = 12
        Me.closeButton.Text = "Close"
        Me.closeButton.UseVisualStyleBackColor = False
        '
        'ImportAnnotationForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(580, 145)
        Me.Controls.Add(Me.closeButton)
        Me.Controls.Add(Me.importButton)
        Me.Controls.Add(Me.UserCombo)
        Me.Controls.Add(Me.Label1)
        Me.Controls.Add(Me.BrowseButton)
        Me.Controls.Add(Me.FileText)
        Me.Controls.Add(Me.Label2)
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "ImportAnnotationForm"
        Me.Text = "Import Annotation"
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents BrowseButton As System.Windows.Forms.Button
    Friend WithEvents FileText As System.Windows.Forms.TextBox
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents UserCombo As System.Windows.Forms.ComboBox
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents importButton As System.Windows.Forms.Button
    Friend WithEvents closeButton As System.Windows.Forms.Button
End Class

<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ProviderForm
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
        Me.ProviderNameText = New System.Windows.Forms.TextBox
        Me.UrlText = New System.Windows.Forms.TextBox
        Me.Label2 = New System.Windows.Forms.Label
        Me.ProjectUrlText = New System.Windows.Forms.TextBox
        Me.Label3 = New System.Windows.Forms.Label
        Me.ContactNameText = New System.Windows.Forms.TextBox
        Me.Label4 = New System.Windows.Forms.Label
        Me.ContactPhoneText = New System.Windows.Forms.TextBox
        Me.Label5 = New System.Windows.Forms.Label
        Me.ContactEmailText = New System.Windows.Forms.TextBox
        Me.Label6 = New System.Windows.Forms.Label
        Me.ContactAddressText = New System.Windows.Forms.TextBox
        Me.Label7 = New System.Windows.Forms.Label
        Me.FullNameText = New System.Windows.Forms.TextBox
        Me.Label8 = New System.Windows.Forms.Label
        Me.StatementText = New System.Windows.Forms.TextBox
        Me.Label9 = New System.Windows.Forms.Label
        Me.CnclButton = New System.Windows.Forms.Button
        Me.SaveButton = New System.Windows.Forms.Button
        Me.UseForParentageCheck = New System.Windows.Forms.CheckBox
        Me.Label10 = New System.Windows.Forms.Label
        Me.prefConcRanking = New System.Windows.Forms.NumericUpDown
        CType(Me.prefConcRanking, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(12, 9)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(77, 13)
        Me.Label1.TabIndex = 0
        Me.Label1.Text = "Provider Name"
        '
        'ProviderNameText
        '
        Me.ProviderNameText.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ProviderNameText.Location = New System.Drawing.Point(106, 6)
        Me.ProviderNameText.Name = "ProviderNameText"
        Me.ProviderNameText.Size = New System.Drawing.Size(371, 20)
        Me.ProviderNameText.TabIndex = 0
        '
        'UrlText
        '
        Me.UrlText.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.UrlText.Location = New System.Drawing.Point(106, 58)
        Me.UrlText.Name = "UrlText"
        Me.UrlText.Size = New System.Drawing.Size(371, 20)
        Me.UrlText.TabIndex = 2
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(12, 61)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(51, 13)
        Me.Label2.TabIndex = 2
        Me.Label2.Text = "Web Site"
        '
        'ProjectUrlText
        '
        Me.ProjectUrlText.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ProjectUrlText.Location = New System.Drawing.Point(106, 84)
        Me.ProjectUrlText.Name = "ProjectUrlText"
        Me.ProjectUrlText.Size = New System.Drawing.Size(371, 20)
        Me.ProjectUrlText.TabIndex = 3
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Location = New System.Drawing.Point(12, 87)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(87, 13)
        Me.Label3.TabIndex = 4
        Me.Label3.Text = "Project Web Site"
        '
        'ContactNameText
        '
        Me.ContactNameText.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ContactNameText.Location = New System.Drawing.Point(106, 110)
        Me.ContactNameText.Name = "ContactNameText"
        Me.ContactNameText.Size = New System.Drawing.Size(371, 20)
        Me.ContactNameText.TabIndex = 4
        '
        'Label4
        '
        Me.Label4.AutoSize = True
        Me.Label4.Location = New System.Drawing.Point(12, 113)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(75, 13)
        Me.Label4.TabIndex = 6
        Me.Label4.Text = "Contact Name"
        '
        'ContactPhoneText
        '
        Me.ContactPhoneText.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ContactPhoneText.Location = New System.Drawing.Point(106, 136)
        Me.ContactPhoneText.Name = "ContactPhoneText"
        Me.ContactPhoneText.Size = New System.Drawing.Size(371, 20)
        Me.ContactPhoneText.TabIndex = 5
        '
        'Label5
        '
        Me.Label5.AutoSize = True
        Me.Label5.Location = New System.Drawing.Point(12, 139)
        Me.Label5.Name = "Label5"
        Me.Label5.Size = New System.Drawing.Size(78, 13)
        Me.Label5.TabIndex = 8
        Me.Label5.Text = "Contact Phone"
        '
        'ContactEmailText
        '
        Me.ContactEmailText.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ContactEmailText.Location = New System.Drawing.Point(106, 162)
        Me.ContactEmailText.Name = "ContactEmailText"
        Me.ContactEmailText.Size = New System.Drawing.Size(371, 20)
        Me.ContactEmailText.TabIndex = 6
        '
        'Label6
        '
        Me.Label6.AutoSize = True
        Me.Label6.Location = New System.Drawing.Point(12, 165)
        Me.Label6.Name = "Label6"
        Me.Label6.Size = New System.Drawing.Size(72, 13)
        Me.Label6.TabIndex = 10
        Me.Label6.Text = "Contact Email"
        '
        'ContactAddressText
        '
        Me.ContactAddressText.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ContactAddressText.Location = New System.Drawing.Point(106, 188)
        Me.ContactAddressText.Multiline = True
        Me.ContactAddressText.Name = "ContactAddressText"
        Me.ContactAddressText.Size = New System.Drawing.Size(371, 65)
        Me.ContactAddressText.TabIndex = 7
        '
        'Label7
        '
        Me.Label7.AutoSize = True
        Me.Label7.Location = New System.Drawing.Point(12, 191)
        Me.Label7.Name = "Label7"
        Me.Label7.Size = New System.Drawing.Size(85, 13)
        Me.Label7.TabIndex = 12
        Me.Label7.Text = "Contact Address"
        '
        'FullNameText
        '
        Me.FullNameText.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.FullNameText.Location = New System.Drawing.Point(106, 32)
        Me.FullNameText.Name = "FullNameText"
        Me.FullNameText.Size = New System.Drawing.Size(371, 20)
        Me.FullNameText.TabIndex = 1
        '
        'Label8
        '
        Me.Label8.AutoSize = True
        Me.Label8.Location = New System.Drawing.Point(12, 35)
        Me.Label8.Name = "Label8"
        Me.Label8.Size = New System.Drawing.Size(54, 13)
        Me.Label8.TabIndex = 14
        Me.Label8.Text = "Full Name"
        '
        'StatementText
        '
        Me.StatementText.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.StatementText.Location = New System.Drawing.Point(106, 261)
        Me.StatementText.Multiline = True
        Me.StatementText.Name = "StatementText"
        Me.StatementText.Size = New System.Drawing.Size(371, 56)
        Me.StatementText.TabIndex = 8
        '
        'Label9
        '
        Me.Label9.AutoSize = True
        Me.Label9.Location = New System.Drawing.Point(12, 264)
        Me.Label9.Name = "Label9"
        Me.Label9.Size = New System.Drawing.Size(55, 13)
        Me.Label9.TabIndex = 16
        Me.Label9.Text = "Statement"
        '
        'CnclButton
        '
        Me.CnclButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CnclButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.CnclButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.CnclButton.Location = New System.Drawing.Point(397, 390)
        Me.CnclButton.Name = "CnclButton"
        Me.CnclButton.Size = New System.Drawing.Size(80, 23)
        Me.CnclButton.TabIndex = 10
        Me.CnclButton.Text = "Cancel"
        Me.CnclButton.UseVisualStyleBackColor = False
        '
        'SaveButton
        '
        Me.SaveButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.SaveButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.SaveButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.SaveButton.Location = New System.Drawing.Point(311, 390)
        Me.SaveButton.Name = "SaveButton"
        Me.SaveButton.Size = New System.Drawing.Size(80, 23)
        Me.SaveButton.TabIndex = 9
        Me.SaveButton.Text = "Save"
        Me.SaveButton.UseVisualStyleBackColor = False
        '
        'UseForParentageCheck
        '
        Me.UseForParentageCheck.AutoSize = True
        Me.UseForParentageCheck.Location = New System.Drawing.Point(106, 323)
        Me.UseForParentageCheck.Name = "UseForParentageCheck"
        Me.UseForParentageCheck.Size = New System.Drawing.Size(159, 17)
        Me.UseForParentageCheck.TabIndex = 17
        Me.UseForParentageCheck.Text = "Preferred for parentage links"
        Me.UseForParentageCheck.UseVisualStyleBackColor = True
        '
        'Label10
        '
        Me.Label10.AutoSize = True
        Me.Label10.Location = New System.Drawing.Point(12, 348)
        Me.Label10.Name = "Label10"
        Me.Label10.Size = New System.Drawing.Size(130, 13)
        Me.Label10.TabIndex = 18
        Me.Label10.Text = "Preferred concept ranking"
        '
        'prefConcRanking
        '
        Me.prefConcRanking.Location = New System.Drawing.Point(148, 346)
        Me.prefConcRanking.Name = "prefConcRanking"
        Me.prefConcRanking.Size = New System.Drawing.Size(117, 20)
        Me.prefConcRanking.TabIndex = 19
        '
        'ProviderForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(489, 418)
        Me.Controls.Add(Me.prefConcRanking)
        Me.Controls.Add(Me.Label10)
        Me.Controls.Add(Me.UseForParentageCheck)
        Me.Controls.Add(Me.SaveButton)
        Me.Controls.Add(Me.CnclButton)
        Me.Controls.Add(Me.StatementText)
        Me.Controls.Add(Me.Label9)
        Me.Controls.Add(Me.FullNameText)
        Me.Controls.Add(Me.Label8)
        Me.Controls.Add(Me.ContactAddressText)
        Me.Controls.Add(Me.Label7)
        Me.Controls.Add(Me.ContactEmailText)
        Me.Controls.Add(Me.Label6)
        Me.Controls.Add(Me.ContactPhoneText)
        Me.Controls.Add(Me.Label5)
        Me.Controls.Add(Me.ContactNameText)
        Me.Controls.Add(Me.Label4)
        Me.Controls.Add(Me.ProjectUrlText)
        Me.Controls.Add(Me.Label3)
        Me.Controls.Add(Me.UrlText)
        Me.Controls.Add(Me.Label2)
        Me.Controls.Add(Me.ProviderNameText)
        Me.Controls.Add(Me.Label1)
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "ProviderForm"
        Me.Text = "Provider"
        CType(Me.prefConcRanking, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents ProviderNameText As System.Windows.Forms.TextBox
    Friend WithEvents UrlText As System.Windows.Forms.TextBox
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents ProjectUrlText As System.Windows.Forms.TextBox
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents ContactNameText As System.Windows.Forms.TextBox
    Friend WithEvents Label4 As System.Windows.Forms.Label
    Friend WithEvents ContactPhoneText As System.Windows.Forms.TextBox
    Friend WithEvents Label5 As System.Windows.Forms.Label
    Friend WithEvents ContactEmailText As System.Windows.Forms.TextBox
    Friend WithEvents Label6 As System.Windows.Forms.Label
    Friend WithEvents ContactAddressText As System.Windows.Forms.TextBox
    Friend WithEvents Label7 As System.Windows.Forms.Label
    Friend WithEvents FullNameText As System.Windows.Forms.TextBox
    Friend WithEvents Label8 As System.Windows.Forms.Label
    Friend WithEvents StatementText As System.Windows.Forms.TextBox
    Friend WithEvents Label9 As System.Windows.Forms.Label
    Friend WithEvents CnclButton As System.Windows.Forms.Button
    Friend WithEvents SaveButton As System.Windows.Forms.Button
    Friend WithEvents UseForParentageCheck As System.Windows.Forms.CheckBox
    Friend WithEvents Label10 As System.Windows.Forms.Label
    Friend WithEvents prefConcRanking As System.Windows.Forms.NumericUpDown
End Class

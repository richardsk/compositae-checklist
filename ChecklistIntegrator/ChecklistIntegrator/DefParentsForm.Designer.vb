<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class DefParentsForm
    Inherits System.Windows.Forms.Form

    'Form overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        Try
            If disposing AndAlso components IsNot Nothing Then
                components.Dispose()
            End If
        Finally
            MyBase.Dispose(disposing)
        End Try
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Me.CncButton = New System.Windows.Forms.Button
        Me.OkButton = New System.Windows.Forms.Button
        Me.genNameLink = New System.Windows.Forms.LinkLabel
        Me.Label8 = New System.Windows.Forms.Label
        Me.Label9 = New System.Windows.Forms.Label
        Me.DefGenParNameType = New System.Windows.Forms.ComboBox
        Me.Label10 = New System.Windows.Forms.Label
        Me.nameLink = New System.Windows.Forms.LinkLabel
        Me.Label7 = New System.Windows.Forms.Label
        Me.Label6 = New System.Windows.Forms.Label
        Me.DefParNameType = New System.Windows.Forms.ComboBox
        Me.Label5 = New System.Windows.Forms.Label
        Me.SuspendLayout()
        '
        'CncButton
        '
        Me.CncButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CncButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.CncButton.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.CncButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.CncButton.Location = New System.Drawing.Point(606, 81)
        Me.CncButton.Name = "CncButton"
        Me.CncButton.Size = New System.Drawing.Size(80, 23)
        Me.CncButton.TabIndex = 5
        Me.CncButton.Text = "Cancel"
        Me.CncButton.UseVisualStyleBackColor = False
        '
        'OkButton
        '
        Me.OkButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OkButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.OkButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.OkButton.Location = New System.Drawing.Point(520, 81)
        Me.OkButton.Name = "OkButton"
        Me.OkButton.Size = New System.Drawing.Size(80, 23)
        Me.OkButton.TabIndex = 4
        Me.OkButton.Text = "Ok"
        Me.OkButton.UseVisualStyleBackColor = False
        '
        'genNameLink
        '
        Me.genNameLink.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.genNameLink.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.genNameLink.Location = New System.Drawing.Point(379, 36)
        Me.genNameLink.Name = "genNameLink"
        Me.genNameLink.Size = New System.Drawing.Size(307, 18)
        Me.genNameLink.TabIndex = 32
        Me.genNameLink.TabStop = True
        Me.genNameLink.Text = "LinkLabel1"
        '
        'Label8
        '
        Me.Label8.AutoSize = True
        Me.Label8.Location = New System.Drawing.Point(337, 37)
        Me.Label8.Name = "Label8"
        Me.Label8.Size = New System.Drawing.Size(36, 13)
        Me.Label8.TabIndex = 31
        Me.Label8.Text = "name:"
        '
        'Label9
        '
        Me.Label9.AutoSize = True
        Me.Label9.Location = New System.Drawing.Point(135, 36)
        Me.Label9.Name = "Label9"
        Me.Label9.Size = New System.Drawing.Size(30, 13)
        Me.Label9.TabIndex = 30
        Me.Label9.Text = "type:"
        '
        'DefGenParNameType
        '
        Me.DefGenParNameType.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.DefGenParNameType.FormattingEnabled = True
        Me.DefGenParNameType.Items.AddRange(New Object() {"Consensus Name", "Provider Name"})
        Me.DefGenParNameType.Location = New System.Drawing.Point(171, 33)
        Me.DefGenParNameType.Name = "DefGenParNameType"
        Me.DefGenParNameType.Size = New System.Drawing.Size(151, 21)
        Me.DefGenParNameType.TabIndex = 29
        '
        'Label10
        '
        Me.Label10.AutoSize = True
        Me.Label10.Location = New System.Drawing.Point(12, 36)
        Me.Label10.Name = "Label10"
        Me.Label10.Size = New System.Drawing.Size(106, 13)
        Me.Label10.TabIndex = 28
        Me.Label10.Text = "Default genus parent"
        '
        'nameLink
        '
        Me.nameLink.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.nameLink.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.nameLink.Location = New System.Drawing.Point(379, 9)
        Me.nameLink.Name = "nameLink"
        Me.nameLink.Size = New System.Drawing.Size(307, 18)
        Me.nameLink.TabIndex = 27
        Me.nameLink.TabStop = True
        Me.nameLink.Text = "LinkLabel1"
        '
        'Label7
        '
        Me.Label7.AutoSize = True
        Me.Label7.Location = New System.Drawing.Point(337, 10)
        Me.Label7.Name = "Label7"
        Me.Label7.Size = New System.Drawing.Size(36, 13)
        Me.Label7.TabIndex = 26
        Me.Label7.Text = "name:"
        '
        'Label6
        '
        Me.Label6.AutoSize = True
        Me.Label6.Location = New System.Drawing.Point(135, 9)
        Me.Label6.Name = "Label6"
        Me.Label6.Size = New System.Drawing.Size(30, 13)
        Me.Label6.TabIndex = 25
        Me.Label6.Text = "type:"
        '
        'DefParNameType
        '
        Me.DefParNameType.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.DefParNameType.FormattingEnabled = True
        Me.DefParNameType.Items.AddRange(New Object() {"Consensus Name", "Provider Name"})
        Me.DefParNameType.Location = New System.Drawing.Point(171, 6)
        Me.DefParNameType.Name = "DefParNameType"
        Me.DefParNameType.Size = New System.Drawing.Size(151, 21)
        Me.DefParNameType.TabIndex = 24
        '
        'Label5
        '
        Me.Label5.AutoSize = True
        Me.Label5.Location = New System.Drawing.Point(12, 9)
        Me.Label5.Name = "Label5"
        Me.Label5.Size = New System.Drawing.Size(100, 13)
        Me.Label5.TabIndex = 23
        Me.Label5.Text = "Default higer parent"
        '
        'DefParentsForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(698, 116)
        Me.Controls.Add(Me.genNameLink)
        Me.Controls.Add(Me.Label8)
        Me.Controls.Add(Me.Label9)
        Me.Controls.Add(Me.DefGenParNameType)
        Me.Controls.Add(Me.Label10)
        Me.Controls.Add(Me.nameLink)
        Me.Controls.Add(Me.Label7)
        Me.Controls.Add(Me.Label6)
        Me.Controls.Add(Me.DefParNameType)
        Me.Controls.Add(Me.Label5)
        Me.Controls.Add(Me.CncButton)
        Me.Controls.Add(Me.OkButton)
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "DefParentsForm"
        Me.Text = "Select Default Parent Names For Import"
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents CncButton As System.Windows.Forms.Button
    Friend WithEvents OkButton As System.Windows.Forms.Button
    Friend WithEvents genNameLink As System.Windows.Forms.LinkLabel
    Friend WithEvents Label8 As System.Windows.Forms.Label
    Friend WithEvents Label9 As System.Windows.Forms.Label
    Friend WithEvents DefGenParNameType As System.Windows.Forms.ComboBox
    Friend WithEvents Label10 As System.Windows.Forms.Label
    Friend WithEvents nameLink As System.Windows.Forms.LinkLabel
    Friend WithEvents Label7 As System.Windows.Forms.Label
    Friend WithEvents Label6 As System.Windows.Forms.Label
    Friend WithEvents DefParNameType As System.Windows.Forms.ComboBox
    Friend WithEvents Label5 As System.Windows.Forms.Label
End Class

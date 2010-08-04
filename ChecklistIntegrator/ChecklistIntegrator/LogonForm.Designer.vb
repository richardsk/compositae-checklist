<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class LogonForm
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
        Me.PassText = New System.Windows.Forms.TextBox
        Me.Label2 = New System.Windows.Forms.Label
        Me.LoginButton = New System.Windows.Forms.Button
        Me.CncButton = New System.Windows.Forms.Button
        Me.UserCombo = New System.Windows.Forms.ComboBox
        Me.SuspendLayout()
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(12, 9)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(58, 13)
        Me.Label1.TabIndex = 0
        Me.Label1.Text = "User name"
        '
        'PassText
        '
        Me.PassText.Location = New System.Drawing.Point(76, 32)
        Me.PassText.Name = "PassText"
        Me.PassText.PasswordChar = Global.Microsoft.VisualBasic.ChrW(42)
        Me.PassText.Size = New System.Drawing.Size(237, 20)
        Me.PassText.TabIndex = 1
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(12, 35)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(53, 13)
        Me.Label2.TabIndex = 2
        Me.Label2.Text = "Password"
        '
        'LoginButton
        '
        Me.LoginButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.LoginButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.LoginButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.LoginButton.Location = New System.Drawing.Point(166, 63)
        Me.LoginButton.Name = "LoginButton"
        Me.LoginButton.Size = New System.Drawing.Size(70, 23)
        Me.LoginButton.TabIndex = 2
        Me.LoginButton.Text = "Login"
        Me.LoginButton.UseVisualStyleBackColor = False
        '
        'CncButton
        '
        Me.CncButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.CncButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.CncButton.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.CncButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.CncButton.Location = New System.Drawing.Point(242, 63)
        Me.CncButton.Name = "CncButton"
        Me.CncButton.Size = New System.Drawing.Size(71, 23)
        Me.CncButton.TabIndex = 3
        Me.CncButton.Text = "Cancel"
        Me.CncButton.UseVisualStyleBackColor = False
        '
        'UserCombo
        '
        Me.UserCombo.FormattingEnabled = True
        Me.UserCombo.Location = New System.Drawing.Point(76, 5)
        Me.UserCombo.Name = "UserCombo"
        Me.UserCombo.Size = New System.Drawing.Size(237, 21)
        Me.UserCombo.TabIndex = 0
        '
        'LogonForm
        '
        Me.AcceptButton = Me.LoginButton
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.CancelButton = Me.CncButton
        Me.ClientSize = New System.Drawing.Size(325, 98)
        Me.Controls.Add(Me.UserCombo)
        Me.Controls.Add(Me.CncButton)
        Me.Controls.Add(Me.LoginButton)
        Me.Controls.Add(Me.PassText)
        Me.Controls.Add(Me.Label2)
        Me.Controls.Add(Me.Label1)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "LogonForm"
        Me.Text = "Logon"
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents PassText As System.Windows.Forms.TextBox
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents LoginButton As System.Windows.Forms.Button
    Friend WithEvents CncButton As System.Windows.Forms.Button
    Friend WithEvents UserCombo As System.Windows.Forms.ComboBox
End Class

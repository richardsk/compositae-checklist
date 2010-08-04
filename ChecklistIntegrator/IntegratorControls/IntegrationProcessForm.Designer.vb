<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class IntegrationProcessForm
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
        Me.RunButton = New System.Windows.Forms.Button
        Me.MessagesText = New System.Windows.Forms.TextBox
        Me.CloseButton = New System.Windows.Forms.Button
        Me.Label2 = New System.Windows.Forms.Label
        Me.ProgressBar1 = New System.Windows.Forms.ProgressBar
        Me.Label3 = New System.Windows.Forms.Label
        Me.TypeCombo = New System.Windows.Forms.ComboBox
        Me.ViewRecordsButton = New System.Windows.Forms.Button
        Me.ErrLogButton = New System.Windows.Forms.Button
        Me.ResultsButton = New System.Windows.Forms.Button
        Me.ProviderCombo = New System.Windows.Forms.ComboBox
        Me.Label4 = New System.Windows.Forms.Label
        Me.rankCombo = New System.Windows.Forms.ComboBox
        Me.Label5 = New System.Windows.Forms.Label
        Me.inclOtherDataCheck = New System.Windows.Forms.CheckBox
        Me.SuspendLayout()
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(12, 182)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(55, 13)
        Me.Label1.TabIndex = 6
        Me.Label1.Text = "Messages"
        '
        'RunButton
        '
        Me.RunButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.RunButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.RunButton.Location = New System.Drawing.Point(12, 117)
        Me.RunButton.Name = "RunButton"
        Me.RunButton.Size = New System.Drawing.Size(162, 23)
        Me.RunButton.TabIndex = 4
        Me.RunButton.Text = "Run Integration Process"
        Me.RunButton.UseVisualStyleBackColor = False
        '
        'MessagesText
        '
        Me.MessagesText.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.MessagesText.Location = New System.Drawing.Point(12, 198)
        Me.MessagesText.Multiline = True
        Me.MessagesText.Name = "MessagesText"
        Me.MessagesText.ReadOnly = True
        Me.MessagesText.ScrollBars = System.Windows.Forms.ScrollBars.Both
        Me.MessagesText.Size = New System.Drawing.Size(602, 193)
        Me.MessagesText.TabIndex = 6
        '
        'CloseButton
        '
        Me.CloseButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CloseButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.CloseButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.CloseButton.Location = New System.Drawing.Point(537, 401)
        Me.CloseButton.Name = "CloseButton"
        Me.CloseButton.Size = New System.Drawing.Size(77, 23)
        Me.CloseButton.TabIndex = 9
        Me.CloseButton.Text = "Close"
        Me.CloseButton.UseVisualStyleBackColor = False
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(12, 154)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(48, 13)
        Me.Label2.TabIndex = 4
        Me.Label2.Text = "Progress"
        '
        'ProgressBar1
        '
        Me.ProgressBar1.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ProgressBar1.Location = New System.Drawing.Point(66, 150)
        Me.ProgressBar1.Name = "ProgressBar1"
        Me.ProgressBar1.Size = New System.Drawing.Size(548, 23)
        Me.ProgressBar1.TabIndex = 5
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Location = New System.Drawing.Point(12, 9)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(84, 13)
        Me.Label3.TabIndex = 0
        Me.Label3.Text = "Integration Type"
        '
        'TypeCombo
        '
        Me.TypeCombo.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.TypeCombo.FormattingEnabled = True
        Me.TypeCombo.Items.AddRange(New Object() {"All", "References", "Names", "Concepts", "OtherData"})
        Me.TypeCombo.Location = New System.Drawing.Point(132, 6)
        Me.TypeCombo.Name = "TypeCombo"
        Me.TypeCombo.Size = New System.Drawing.Size(297, 21)
        Me.TypeCombo.TabIndex = 0
        '
        'ViewRecordsButton
        '
        Me.ViewRecordsButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ViewRecordsButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.ViewRecordsButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.ViewRecordsButton.Location = New System.Drawing.Point(501, 6)
        Me.ViewRecordsButton.Name = "ViewRecordsButton"
        Me.ViewRecordsButton.Size = New System.Drawing.Size(113, 23)
        Me.ViewRecordsButton.TabIndex = 1
        Me.ViewRecordsButton.Text = "View Records"
        Me.ViewRecordsButton.UseVisualStyleBackColor = False
        '
        'ErrLogButton
        '
        Me.ErrLogButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.ErrLogButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.ErrLogButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.ErrLogButton.Location = New System.Drawing.Point(12, 397)
        Me.ErrLogButton.Name = "ErrLogButton"
        Me.ErrLogButton.Size = New System.Drawing.Size(97, 23)
        Me.ErrLogButton.TabIndex = 7
        Me.ErrLogButton.Text = "View Error Log"
        Me.ErrLogButton.UseVisualStyleBackColor = False
        '
        'ResultsButton
        '
        Me.ResultsButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ResultsButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.ResultsButton.Enabled = False
        Me.ResultsButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.ResultsButton.Location = New System.Drawing.Point(434, 401)
        Me.ResultsButton.Name = "ResultsButton"
        Me.ResultsButton.Size = New System.Drawing.Size(97, 23)
        Me.ResultsButton.TabIndex = 8
        Me.ResultsButton.Text = "View Results"
        Me.ResultsButton.UseVisualStyleBackColor = False
        '
        'ProviderCombo
        '
        Me.ProviderCombo.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.ProviderCombo.FormattingEnabled = True
        Me.ProviderCombo.Location = New System.Drawing.Point(132, 33)
        Me.ProviderCombo.Name = "ProviderCombo"
        Me.ProviderCombo.Size = New System.Drawing.Size(297, 21)
        Me.ProviderCombo.TabIndex = 2
        '
        'Label4
        '
        Me.Label4.AutoSize = True
        Me.Label4.Location = New System.Drawing.Point(12, 36)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(46, 13)
        Me.Label4.TabIndex = 11
        Me.Label4.Text = "Provider"
        '
        'rankCombo
        '
        Me.rankCombo.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.rankCombo.FormattingEnabled = True
        Me.rankCombo.Location = New System.Drawing.Point(132, 60)
        Me.rankCombo.Name = "rankCombo"
        Me.rankCombo.Size = New System.Drawing.Size(297, 21)
        Me.rankCombo.TabIndex = 3
        '
        'Label5
        '
        Me.Label5.AutoSize = True
        Me.Label5.Location = New System.Drawing.Point(12, 63)
        Me.Label5.Name = "Label5"
        Me.Label5.Size = New System.Drawing.Size(114, 13)
        Me.Label5.TabIndex = 13
        Me.Label5.Text = "Integrate down to rank"
        '
        'inclOtherDataCheck
        '
        Me.inclOtherDataCheck.AutoSize = True
        Me.inclOtherDataCheck.Location = New System.Drawing.Point(132, 87)
        Me.inclOtherDataCheck.Name = "inclOtherDataCheck"
        Me.inclOtherDataCheck.Size = New System.Drawing.Size(116, 17)
        Me.inclOtherDataCheck.TabIndex = 14
        Me.inclOtherDataCheck.Text = "Include Other Data"
        Me.inclOtherDataCheck.UseVisualStyleBackColor = True
        '
        'IntegrationProcessForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(626, 436)
        Me.Controls.Add(Me.inclOtherDataCheck)
        Me.Controls.Add(Me.rankCombo)
        Me.Controls.Add(Me.Label5)
        Me.Controls.Add(Me.ProviderCombo)
        Me.Controls.Add(Me.Label4)
        Me.Controls.Add(Me.ResultsButton)
        Me.Controls.Add(Me.ErrLogButton)
        Me.Controls.Add(Me.ViewRecordsButton)
        Me.Controls.Add(Me.TypeCombo)
        Me.Controls.Add(Me.Label3)
        Me.Controls.Add(Me.ProgressBar1)
        Me.Controls.Add(Me.Label2)
        Me.Controls.Add(Me.CloseButton)
        Me.Controls.Add(Me.MessagesText)
        Me.Controls.Add(Me.RunButton)
        Me.Controls.Add(Me.Label1)
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "IntegrationProcessForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Integration Process"
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents RunButton As System.Windows.Forms.Button
    Friend WithEvents MessagesText As System.Windows.Forms.TextBox
    Friend WithEvents CloseButton As System.Windows.Forms.Button
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents ProgressBar1 As System.Windows.Forms.ProgressBar
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents TypeCombo As System.Windows.Forms.ComboBox
    Friend WithEvents ViewRecordsButton As System.Windows.Forms.Button
    Friend WithEvents ErrLogButton As System.Windows.Forms.Button
    Friend WithEvents ResultsButton As System.Windows.Forms.Button
    Friend WithEvents ProviderCombo As System.Windows.Forms.ComboBox
    Friend WithEvents Label4 As System.Windows.Forms.Label
    Friend WithEvents rankCombo As System.Windows.Forms.ComboBox
    Friend WithEvents Label5 As System.Windows.Forms.Label
    Friend WithEvents inclOtherDataCheck As System.Windows.Forms.CheckBox
End Class

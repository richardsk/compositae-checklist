<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class MergeUnknownsForm
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
        Me.FieldsList = New System.Windows.Forms.CheckedListBox
        Me.MatchOptionCombo = New System.Windows.Forms.ComboBox
        Me.Label2 = New System.Windows.Forms.Label
        Me.PercentMatchLabel = New System.Windows.Forms.Label
        Me.PercentMatchText = New System.Windows.Forms.TextBox
        Me.CloseButton = New System.Windows.Forms.Button
        Me.RunButton = New System.Windows.Forms.Button
        Me.ProgressBar1 = New System.Windows.Forms.ProgressBar
        Me.MessageText = New System.Windows.Forms.TextBox
        Me.SuspendLayout()
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(12, 9)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(133, 13)
        Me.Label1.TabIndex = 0
        Me.Label1.Text = "Fields to compare in merge"
        '
        'FieldsList
        '
        Me.FieldsList.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.FieldsList.CheckOnClick = True
        Me.FieldsList.FormattingEnabled = True
        Me.FieldsList.Location = New System.Drawing.Point(15, 25)
        Me.FieldsList.Name = "FieldsList"
        Me.FieldsList.Size = New System.Drawing.Size(350, 154)
        Me.FieldsList.TabIndex = 0
        '
        'MatchOptionCombo
        '
        Me.MatchOptionCombo.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.MatchOptionCombo.FormattingEnabled = True
        Me.MatchOptionCombo.Items.AddRange(New Object() {"Exact", "Levenshtein"})
        Me.MatchOptionCombo.Location = New System.Drawing.Point(87, 185)
        Me.MatchOptionCombo.Name = "MatchOptionCombo"
        Me.MatchOptionCombo.Size = New System.Drawing.Size(204, 21)
        Me.MatchOptionCombo.TabIndex = 1
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(12, 188)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(69, 13)
        Me.Label2.TabIndex = 3
        Me.Label2.Text = "Match option"
        '
        'PercentMatchLabel
        '
        Me.PercentMatchLabel.AutoSize = True
        Me.PercentMatchLabel.Enabled = False
        Me.PercentMatchLabel.Location = New System.Drawing.Point(84, 214)
        Me.PercentMatchLabel.Name = "PercentMatchLabel"
        Me.PercentMatchLabel.Size = New System.Drawing.Size(76, 13)
        Me.PercentMatchLabel.TabIndex = 4
        Me.PercentMatchLabel.Text = "Percent match"
        '
        'PercentMatchText
        '
        Me.PercentMatchText.Enabled = False
        Me.PercentMatchText.Location = New System.Drawing.Point(166, 211)
        Me.PercentMatchText.Name = "PercentMatchText"
        Me.PercentMatchText.Size = New System.Drawing.Size(125, 20)
        Me.PercentMatchText.TabIndex = 2
        '
        'CloseButton
        '
        Me.CloseButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CloseButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.CloseButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.CloseButton.Location = New System.Drawing.Point(277, 375)
        Me.CloseButton.Name = "CloseButton"
        Me.CloseButton.Size = New System.Drawing.Size(88, 23)
        Me.CloseButton.TabIndex = 6
        Me.CloseButton.Text = "Close"
        Me.CloseButton.UseVisualStyleBackColor = False
        '
        'RunButton
        '
        Me.RunButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.RunButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.RunButton.Location = New System.Drawing.Point(12, 251)
        Me.RunButton.Name = "RunButton"
        Me.RunButton.Size = New System.Drawing.Size(69, 23)
        Me.RunButton.TabIndex = 4
        Me.RunButton.Text = "Run"
        Me.RunButton.UseVisualStyleBackColor = False
        '
        'ProgressBar1
        '
        Me.ProgressBar1.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ProgressBar1.Location = New System.Drawing.Point(12, 280)
        Me.ProgressBar1.Name = "ProgressBar1"
        Me.ProgressBar1.Size = New System.Drawing.Size(353, 23)
        Me.ProgressBar1.TabIndex = 5
        '
        'MessageText
        '
        Me.MessageText.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.MessageText.Location = New System.Drawing.Point(12, 309)
        Me.MessageText.Multiline = True
        Me.MessageText.Name = "MessageText"
        Me.MessageText.ReadOnly = True
        Me.MessageText.Size = New System.Drawing.Size(353, 60)
        Me.MessageText.TabIndex = 7
        '
        'MergeUnknownsForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(377, 410)
        Me.Controls.Add(Me.MessageText)
        Me.Controls.Add(Me.ProgressBar1)
        Me.Controls.Add(Me.RunButton)
        Me.Controls.Add(Me.CloseButton)
        Me.Controls.Add(Me.PercentMatchText)
        Me.Controls.Add(Me.PercentMatchLabel)
        Me.Controls.Add(Me.Label2)
        Me.Controls.Add(Me.MatchOptionCombo)
        Me.Controls.Add(Me.FieldsList)
        Me.Controls.Add(Me.Label1)
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "MergeUnknownsForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Merge Unknown Names"
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents FieldsList As System.Windows.Forms.CheckedListBox
    Friend WithEvents MatchOptionCombo As System.Windows.Forms.ComboBox
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents PercentMatchLabel As System.Windows.Forms.Label
    Friend WithEvents PercentMatchText As System.Windows.Forms.TextBox
    Friend WithEvents CloseButton As System.Windows.Forms.Button
    Friend WithEvents RunButton As System.Windows.Forms.Button
    Friend WithEvents ProgressBar1 As System.Windows.Forms.ProgressBar
    Friend WithEvents MessageText As System.Windows.Forms.TextBox
End Class

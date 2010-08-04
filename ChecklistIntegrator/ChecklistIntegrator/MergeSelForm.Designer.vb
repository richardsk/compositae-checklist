<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class MergeSelForm
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
        Me.AToBButton = New System.Windows.Forms.Button
        Me.BToAButton = New System.Windows.Forms.Button
        Me.DontMergeButton = New System.Windows.Forms.Button
        Me.CncButton = New System.Windows.Forms.Button
        Me.Label2 = New System.Windows.Forms.Label
        Me.NameAText = New System.Windows.Forms.TextBox
        Me.NameBText = New System.Windows.Forms.TextBox
        Me.viewItem1 = New System.Windows.Forms.LinkLabel
        Me.viewItem2 = New System.Windows.Forms.LinkLabel
        Me.SuspendLayout()
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(12, 9)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(37, 13)
        Me.Label1.TabIndex = 0
        Me.Label1.Text = "Item A"
        '
        'AToBButton
        '
        Me.AToBButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.AToBButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.AToBButton.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.AToBButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.AToBButton.ForeColor = System.Drawing.SystemColors.ControlText
        Me.AToBButton.Location = New System.Drawing.Point(115, 91)
        Me.AToBButton.Name = "AToBButton"
        Me.AToBButton.Size = New System.Drawing.Size(84, 22)
        Me.AToBButton.TabIndex = 2
        Me.AToBButton.Text = "Merge A -> B"
        Me.AToBButton.UseVisualStyleBackColor = False
        '
        'BToAButton
        '
        Me.BToAButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.BToAButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.BToAButton.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.BToAButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.BToAButton.ForeColor = System.Drawing.SystemColors.ControlText
        Me.BToAButton.Location = New System.Drawing.Point(205, 91)
        Me.BToAButton.Name = "BToAButton"
        Me.BToAButton.Size = New System.Drawing.Size(84, 22)
        Me.BToAButton.TabIndex = 3
        Me.BToAButton.Text = "Merge B -> A"
        Me.BToAButton.UseVisualStyleBackColor = False
        '
        'DontMergeButton
        '
        Me.DontMergeButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.DontMergeButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.DontMergeButton.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.DontMergeButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.DontMergeButton.ForeColor = System.Drawing.SystemColors.ControlText
        Me.DontMergeButton.Location = New System.Drawing.Point(295, 91)
        Me.DontMergeButton.Name = "DontMergeButton"
        Me.DontMergeButton.Size = New System.Drawing.Size(81, 22)
        Me.DontMergeButton.TabIndex = 4
        Me.DontMergeButton.Text = "Dont Merge"
        Me.DontMergeButton.UseVisualStyleBackColor = False
        '
        'CncButton
        '
        Me.CncButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CncButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.CncButton.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.CncButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.CncButton.ForeColor = System.Drawing.SystemColors.ControlText
        Me.CncButton.Location = New System.Drawing.Point(382, 91)
        Me.CncButton.Name = "CncButton"
        Me.CncButton.Size = New System.Drawing.Size(63, 22)
        Me.CncButton.TabIndex = 5
        Me.CncButton.Text = "Cancel"
        Me.CncButton.UseVisualStyleBackColor = False
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(12, 46)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(37, 13)
        Me.Label2.TabIndex = 26
        Me.Label2.Text = "Item B"
        '
        'NameAText
        '
        Me.NameAText.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.NameAText.Location = New System.Drawing.Point(63, 6)
        Me.NameAText.Multiline = True
        Me.NameAText.Name = "NameAText"
        Me.NameAText.ReadOnly = True
        Me.NameAText.Size = New System.Drawing.Size(347, 34)
        Me.NameAText.TabIndex = 0
        '
        'NameBText
        '
        Me.NameBText.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.NameBText.Location = New System.Drawing.Point(63, 46)
        Me.NameBText.Multiline = True
        Me.NameBText.Name = "NameBText"
        Me.NameBText.ReadOnly = True
        Me.NameBText.Size = New System.Drawing.Size(347, 34)
        Me.NameBText.TabIndex = 1
        '
        'viewItem1
        '
        Me.viewItem1.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.viewItem1.AutoSize = True
        Me.viewItem1.Location = New System.Drawing.Point(416, 27)
        Me.viewItem1.Name = "viewItem1"
        Me.viewItem1.Size = New System.Drawing.Size(29, 13)
        Me.viewItem1.TabIndex = 27
        Me.viewItem1.TabStop = True
        Me.viewItem1.Text = "view"
        '
        'viewItem2
        '
        Me.viewItem2.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.viewItem2.AutoSize = True
        Me.viewItem2.Location = New System.Drawing.Point(416, 67)
        Me.viewItem2.Name = "viewItem2"
        Me.viewItem2.Size = New System.Drawing.Size(29, 13)
        Me.viewItem2.TabIndex = 28
        Me.viewItem2.TabStop = True
        Me.viewItem2.Text = "view"
        '
        'MergeSelForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(457, 125)
        Me.Controls.Add(Me.viewItem2)
        Me.Controls.Add(Me.viewItem1)
        Me.Controls.Add(Me.NameBText)
        Me.Controls.Add(Me.NameAText)
        Me.Controls.Add(Me.Label2)
        Me.Controls.Add(Me.CncButton)
        Me.Controls.Add(Me.DontMergeButton)
        Me.Controls.Add(Me.BToAButton)
        Me.Controls.Add(Me.AToBButton)
        Me.Controls.Add(Me.Label1)
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "MergeSelForm"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Possible Merge Found"
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents AToBButton As System.Windows.Forms.Button
    Friend WithEvents BToAButton As System.Windows.Forms.Button
    Friend WithEvents DontMergeButton As System.Windows.Forms.Button
    Friend WithEvents CncButton As System.Windows.Forms.Button
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents NameAText As System.Windows.Forms.TextBox
    Friend WithEvents NameBText As System.Windows.Forms.TextBox
    Friend WithEvents viewItem1 As System.Windows.Forms.LinkLabel
    Friend WithEvents viewItem2 As System.Windows.Forms.LinkLabel
End Class

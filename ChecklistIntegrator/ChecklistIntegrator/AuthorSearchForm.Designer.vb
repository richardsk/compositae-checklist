<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class AuthorSearchForm
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
        Me.SelectButton = New System.Windows.Forms.Button
        Me.CnclButton = New System.Windows.Forms.Button
        Me.AuthorSearch1 = New ChecklistIntegrator.AuthorSearch
        Me.SuspendLayout()
        '
        'SelectButton
        '
        Me.SelectButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.SelectButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.SelectButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.SelectButton.Location = New System.Drawing.Point(408, 425)
        Me.SelectButton.Name = "SelectButton"
        Me.SelectButton.Size = New System.Drawing.Size(80, 23)
        Me.SelectButton.TabIndex = 21
        Me.SelectButton.Text = "Select"
        Me.SelectButton.UseVisualStyleBackColor = False
        '
        'CnclButton
        '
        Me.CnclButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.CnclButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.CnclButton.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.CnclButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.CnclButton.Location = New System.Drawing.Point(494, 425)
        Me.CnclButton.Name = "CnclButton"
        Me.CnclButton.Size = New System.Drawing.Size(80, 23)
        Me.CnclButton.TabIndex = 22
        Me.CnclButton.Text = "Cancel"
        Me.CnclButton.UseVisualStyleBackColor = False
        '
        'AuthorSearch1
        '
        Me.AuthorSearch1.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.AuthorSearch1.Location = New System.Drawing.Point(12, 12)
        Me.AuthorSearch1.Name = "AuthorSearch1"
        Me.AuthorSearch1.Size = New System.Drawing.Size(562, 407)
        Me.AuthorSearch1.TabIndex = 0
        '
        'AuthorSearchForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(586, 460)
        Me.Controls.Add(Me.CnclButton)
        Me.Controls.Add(Me.SelectButton)
        Me.Controls.Add(Me.AuthorSearch1)
        Me.Name = "AuthorSearchForm"
        Me.Text = "AuthorSearchForm"
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents AuthorSearch1 As ChecklistIntegrator.AuthorSearch
    Friend WithEvents SelectButton As System.Windows.Forms.Button
    Friend WithEvents Button1 As System.Windows.Forms.Button
    Friend WithEvents CnclButton As System.Windows.Forms.Button
End Class

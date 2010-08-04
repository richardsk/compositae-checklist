<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ImportTransformationForm
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
        Me.Label1 = New System.Windows.Forms.Label
        Me.TransNameText = New System.Windows.Forms.TextBox
        Me.DescriptionText = New System.Windows.Forms.TextBox
        Me.Label2 = New System.Windows.Forms.Label
        Me.xsltText = New System.Windows.Forms.TextBox
        Me.Label3 = New System.Windows.Forms.Label
        Me.btnImportTrans = New System.Windows.Forms.Button
        Me.okButton = New System.Windows.Forms.Button
        Me.cncButton = New System.Windows.Forms.Button
        Me.SuspendLayout()
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(12, 9)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(35, 13)
        Me.Label1.TabIndex = 0
        Me.Label1.Text = "Name"
        '
        'TransNameText
        '
        Me.TransNameText.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.TransNameText.Location = New System.Drawing.Point(78, 6)
        Me.TransNameText.Name = "TransNameText"
        Me.TransNameText.Size = New System.Drawing.Size(415, 20)
        Me.TransNameText.TabIndex = 1
        '
        'DescriptionText
        '
        Me.DescriptionText.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.DescriptionText.Location = New System.Drawing.Point(78, 32)
        Me.DescriptionText.Multiline = True
        Me.DescriptionText.Name = "DescriptionText"
        Me.DescriptionText.Size = New System.Drawing.Size(415, 53)
        Me.DescriptionText.TabIndex = 3
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(12, 35)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(60, 13)
        Me.Label2.TabIndex = 2
        Me.Label2.Text = "Description"
        '
        'xsltText
        '
        Me.xsltText.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.xsltText.Location = New System.Drawing.Point(78, 91)
        Me.xsltText.Multiline = True
        Me.xsltText.Name = "xsltText"
        Me.xsltText.ReadOnly = True
        Me.xsltText.ScrollBars = System.Windows.Forms.ScrollBars.Both
        Me.xsltText.Size = New System.Drawing.Size(415, 179)
        Me.xsltText.TabIndex = 5
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Location = New System.Drawing.Point(12, 94)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(24, 13)
        Me.Label3.TabIndex = 4
        Me.Label3.Text = "Xslt"
        '
        'btnImportTrans
        '
        Me.btnImportTrans.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnImportTrans.BackColor = System.Drawing.Color.WhiteSmoke
        Me.btnImportTrans.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.btnImportTrans.Location = New System.Drawing.Point(499, 94)
        Me.btnImportTrans.Name = "btnImportTrans"
        Me.btnImportTrans.Size = New System.Drawing.Size(80, 23)
        Me.btnImportTrans.TabIndex = 6
        Me.btnImportTrans.Text = "Load ..."
        Me.btnImportTrans.UseVisualStyleBackColor = False
        '
        'okButton
        '
        Me.okButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.okButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.okButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.okButton.Location = New System.Drawing.Point(413, 306)
        Me.okButton.Name = "okButton"
        Me.okButton.Size = New System.Drawing.Size(80, 23)
        Me.okButton.TabIndex = 7
        Me.okButton.Text = "Ok"
        Me.okButton.UseVisualStyleBackColor = False
        '
        'cncButton
        '
        Me.cncButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.cncButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.cncButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.cncButton.Location = New System.Drawing.Point(499, 306)
        Me.cncButton.Name = "cncButton"
        Me.cncButton.Size = New System.Drawing.Size(80, 23)
        Me.cncButton.TabIndex = 8
        Me.cncButton.Text = "Cancel"
        Me.cncButton.UseVisualStyleBackColor = False
        '
        'ImportTransformationForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(594, 341)
        Me.Controls.Add(Me.cncButton)
        Me.Controls.Add(Me.okButton)
        Me.Controls.Add(Me.btnImportTrans)
        Me.Controls.Add(Me.xsltText)
        Me.Controls.Add(Me.Label3)
        Me.Controls.Add(Me.DescriptionText)
        Me.Controls.Add(Me.Label2)
        Me.Controls.Add(Me.TransNameText)
        Me.Controls.Add(Me.Label1)
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "ImportTransformationForm"
        Me.Text = "Import Transformation"
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents TransNameText As System.Windows.Forms.TextBox
    Friend WithEvents DescriptionText As System.Windows.Forms.TextBox
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents xsltText As System.Windows.Forms.TextBox
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents btnImportTrans As System.Windows.Forms.Button
    Friend WithEvents okButton As System.Windows.Forms.Button
    Friend WithEvents cncButton As System.Windows.Forms.Button
End Class

<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ReferenceSearch
    Inherits System.Windows.Forms.UserControl

    'UserControl overrides dispose to clean up the component list.
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
        Me.SearchText = New System.Windows.Forms.TextBox
        Me.SearchButton = New System.Windows.Forms.Button
        Me.ResultsListBox = New System.Windows.Forms.ListBox
        Me.SuspendLayout()
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(0, 0)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(56, 13)
        Me.Label1.TabIndex = 0
        Me.Label1.Text = "Search for"
        '
        'SearchText
        '
        Me.SearchText.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.SearchText.Location = New System.Drawing.Point(3, 16)
        Me.SearchText.Name = "SearchText"
        Me.SearchText.Size = New System.Drawing.Size(259, 20)
        Me.SearchText.TabIndex = 0
        '
        'SearchButton
        '
        Me.SearchButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.SearchButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.SearchButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.SearchButton.Location = New System.Drawing.Point(174, 42)
        Me.SearchButton.Name = "SearchButton"
        Me.SearchButton.Size = New System.Drawing.Size(88, 23)
        Me.SearchButton.TabIndex = 1
        Me.SearchButton.Text = "Search"
        Me.SearchButton.UseVisualStyleBackColor = False
        '
        'ResultsListBox
        '
        Me.ResultsListBox.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ResultsListBox.FormattingEnabled = True
        Me.ResultsListBox.Location = New System.Drawing.Point(3, 71)
        Me.ResultsListBox.Name = "ResultsListBox"
        Me.ResultsListBox.Size = New System.Drawing.Size(259, 329)
        Me.ResultsListBox.TabIndex = 2
        '
        'ReferenceSearch
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.ResultsListBox)
        Me.Controls.Add(Me.SearchButton)
        Me.Controls.Add(Me.SearchText)
        Me.Controls.Add(Me.Label1)
        Me.Name = "ReferenceSearch"
        Me.Size = New System.Drawing.Size(265, 401)
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents SearchText As System.Windows.Forms.TextBox
    Friend WithEvents SearchButton As System.Windows.Forms.Button
    Friend WithEvents ResultsListBox As System.Windows.Forms.ListBox

End Class

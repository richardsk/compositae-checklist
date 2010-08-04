<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ProviderRefRecords
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
        Me.ProviderCombo = New System.Windows.Forms.ComboBox
        Me.FilterCombo = New System.Windows.Forms.ComboBox
        Me.Label2 = New System.Windows.Forms.Label
        Me.Label3 = New System.Windows.Forms.Label
        Me.FilterText = New System.Windows.Forms.TextBox
        Me.ListButton = New System.Windows.Forms.Button
        Me.Label4 = New System.Windows.Forms.Label
        Me.ResultsGrid = New System.Windows.Forms.DataGridView
        Me.MaxCombo = New System.Windows.Forms.ComboBox
        Me.Label5 = New System.Windows.Forms.Label
        Me.LinkButton = New System.Windows.Forms.Button
        CType(Me.ResultsGrid, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(3, 11)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(46, 13)
        Me.Label1.TabIndex = 0
        Me.Label1.Text = "Provider"
        '
        'ProviderCombo
        '
        Me.ProviderCombo.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ProviderCombo.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.ProviderCombo.FormattingEnabled = True
        Me.ProviderCombo.Location = New System.Drawing.Point(77, 8)
        Me.ProviderCombo.Name = "ProviderCombo"
        Me.ProviderCombo.Size = New System.Drawing.Size(469, 21)
        Me.ProviderCombo.TabIndex = 1
        '
        'FilterCombo
        '
        Me.FilterCombo.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.FilterCombo.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.FilterCombo.FormattingEnabled = True
        Me.FilterCombo.Location = New System.Drawing.Point(77, 35)
        Me.FilterCombo.Name = "FilterCombo"
        Me.FilterCombo.Size = New System.Drawing.Size(469, 21)
        Me.FilterCombo.TabIndex = 3
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(3, 38)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(29, 13)
        Me.Label2.TabIndex = 2
        Me.Label2.Text = "Filter"
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Location = New System.Drawing.Point(3, 65)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(50, 13)
        Me.Label3.TabIndex = 4
        Me.Label3.Text = "Text filter"
        '
        'FilterText
        '
        Me.FilterText.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.FilterText.Location = New System.Drawing.Point(77, 62)
        Me.FilterText.Name = "FilterText"
        Me.FilterText.Size = New System.Drawing.Size(469, 20)
        Me.FilterText.TabIndex = 5
        '
        'ListButton
        '
        Me.ListButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ListButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.ListButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.ListButton.Location = New System.Drawing.Point(458, 108)
        Me.ListButton.Name = "ListButton"
        Me.ListButton.Size = New System.Drawing.Size(88, 23)
        Me.ListButton.TabIndex = 33
        Me.ListButton.Text = "List Records"
        Me.ListButton.UseVisualStyleBackColor = False
        '
        'Label4
        '
        Me.Label4.AutoSize = True
        Me.Label4.Location = New System.Drawing.Point(3, 141)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(50, 13)
        Me.Label4.TabIndex = 34
        Me.Label4.Text = "Records:"
        '
        'ResultsGrid
        '
        Me.ResultsGrid.AllowUserToAddRows = False
        Me.ResultsGrid.AllowUserToDeleteRows = False
        Me.ResultsGrid.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ResultsGrid.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.ResultsGrid.Location = New System.Drawing.Point(6, 157)
        Me.ResultsGrid.MultiSelect = False
        Me.ResultsGrid.Name = "ResultsGrid"
        Me.ResultsGrid.ReadOnly = True
        Me.ResultsGrid.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect
        Me.ResultsGrid.Size = New System.Drawing.Size(626, 352)
        Me.ResultsGrid.TabIndex = 35
        '
        'MaxCombo
        '
        Me.MaxCombo.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.MaxCombo.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.MaxCombo.FormattingEnabled = True
        Me.MaxCombo.Location = New System.Drawing.Point(77, 90)
        Me.MaxCombo.Name = "MaxCombo"
        Me.MaxCombo.Size = New System.Drawing.Size(274, 21)
        Me.MaxCombo.TabIndex = 37
        '
        'Label5
        '
        Me.Label5.AutoSize = True
        Me.Label5.Location = New System.Drawing.Point(3, 93)
        Me.Label5.Name = "Label5"
        Me.Label5.Size = New System.Drawing.Size(65, 13)
        Me.Label5.TabIndex = 36
        Me.Label5.Text = "Max records"
        '
        'LinkButton
        '
        Me.LinkButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.LinkButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.LinkButton.Enabled = False
        Me.LinkButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.LinkButton.Location = New System.Drawing.Point(500, 515)
        Me.LinkButton.Name = "LinkButton"
        Me.LinkButton.Size = New System.Drawing.Size(132, 23)
        Me.LinkButton.TabIndex = 38
        Me.LinkButton.Text = "Link Selected Record"
        Me.LinkButton.UseVisualStyleBackColor = False
        '
        'ProviderRefRecords
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.LinkButton)
        Me.Controls.Add(Me.MaxCombo)
        Me.Controls.Add(Me.Label5)
        Me.Controls.Add(Me.ResultsGrid)
        Me.Controls.Add(Me.Label4)
        Me.Controls.Add(Me.ListButton)
        Me.Controls.Add(Me.FilterText)
        Me.Controls.Add(Me.Label3)
        Me.Controls.Add(Me.FilterCombo)
        Me.Controls.Add(Me.Label2)
        Me.Controls.Add(Me.ProviderCombo)
        Me.Controls.Add(Me.Label1)
        Me.Name = "ProviderRefRecords"
        Me.Size = New System.Drawing.Size(635, 541)
        CType(Me.ResultsGrid, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents ProviderCombo As System.Windows.Forms.ComboBox
    Friend WithEvents FilterCombo As System.Windows.Forms.ComboBox
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents FilterText As System.Windows.Forms.TextBox
    Friend WithEvents Label4 As System.Windows.Forms.Label
    Friend WithEvents ResultsGrid As System.Windows.Forms.DataGridView
    Friend WithEvents MaxCombo As System.Windows.Forms.ComboBox
    Friend WithEvents Label5 As System.Windows.Forms.Label
    Friend WithEvents LinkButton As System.Windows.Forms.Button
    Public WithEvents ListButton As System.Windows.Forms.Button

End Class

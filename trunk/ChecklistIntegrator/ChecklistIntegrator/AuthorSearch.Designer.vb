<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class AuthorSearch
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
        Me.Label2 = New System.Windows.Forms.Label
        Me.ResultsGrid = New System.Windows.Forms.DataGridView
        Me.AuthorPk = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.Abbreviation = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.Forename = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.Surname = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.CorrectAuthor = New System.Windows.Forms.DataGridViewTextBoxColumn
        Me.SearchButton = New System.Windows.Forms.Button
        Me.searchText = New System.Windows.Forms.TextBox
        Me.Label1 = New System.Windows.Forms.Label
        Me.AnywhereCheck = New System.Windows.Forms.CheckBox
        CType(Me.ResultsGrid, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(3, 49)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(42, 13)
        Me.Label2.TabIndex = 22
        Me.Label2.Text = "Results"
        '
        'ResultsGrid
        '
        Me.ResultsGrid.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ResultsGrid.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.ResultsGrid.Columns.AddRange(New System.Windows.Forms.DataGridViewColumn() {Me.AuthorPk, Me.Abbreviation, Me.Forename, Me.Surname, Me.CorrectAuthor})
        Me.ResultsGrid.Location = New System.Drawing.Point(3, 65)
        Me.ResultsGrid.Name = "ResultsGrid"
        Me.ResultsGrid.ReadOnly = True
        Me.ResultsGrid.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect
        Me.ResultsGrid.Size = New System.Drawing.Size(550, 459)
        Me.ResultsGrid.TabIndex = 21
        '
        'AuthorPk
        '
        Me.AuthorPk.DataPropertyName = "AuthorPk"
        Me.AuthorPk.HeaderText = "Id"
        Me.AuthorPk.Name = "AuthorPk"
        Me.AuthorPk.ReadOnly = True
        Me.AuthorPk.Resizable = System.Windows.Forms.DataGridViewTriState.[True]
        '
        'Abbreviation
        '
        Me.Abbreviation.DataPropertyName = "Abbreviation"
        Me.Abbreviation.HeaderText = "Abbreviation"
        Me.Abbreviation.Name = "Abbreviation"
        Me.Abbreviation.ReadOnly = True
        '
        'Forename
        '
        Me.Forename.DataPropertyName = "Forename"
        Me.Forename.HeaderText = "Forename"
        Me.Forename.Name = "Forename"
        Me.Forename.ReadOnly = True
        '
        'Surname
        '
        Me.Surname.DataPropertyName = "Surname"
        Me.Surname.HeaderText = "Surname"
        Me.Surname.Name = "Surname"
        Me.Surname.ReadOnly = True
        '
        'CorrectAuthor
        '
        Me.CorrectAuthor.DataPropertyName = "CorrectAuthor"
        Me.CorrectAuthor.HeaderText = "Correct Author"
        Me.CorrectAuthor.Name = "CorrectAuthor"
        Me.CorrectAuthor.ReadOnly = True
        Me.CorrectAuthor.Resizable = System.Windows.Forms.DataGridViewTriState.[True]
        Me.CorrectAuthor.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.NotSortable
        '
        'SearchButton
        '
        Me.SearchButton.BackColor = System.Drawing.Color.WhiteSmoke
        Me.SearchButton.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.SearchButton.Location = New System.Drawing.Point(418, 0)
        Me.SearchButton.Name = "SearchButton"
        Me.SearchButton.Size = New System.Drawing.Size(80, 23)
        Me.SearchButton.TabIndex = 20
        Me.SearchButton.Text = "Search"
        Me.SearchButton.UseVisualStyleBackColor = False
        '
        'searchText
        '
        Me.searchText.Location = New System.Drawing.Point(50, 2)
        Me.searchText.Name = "searchText"
        Me.searchText.Size = New System.Drawing.Size(362, 20)
        Me.searchText.TabIndex = 19
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(3, 5)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(27, 13)
        Me.Label1.TabIndex = 18
        Me.Label1.Text = "Find"
        '
        'AnywhereCheck
        '
        Me.AnywhereCheck.AutoSize = True
        Me.AnywhereCheck.Location = New System.Drawing.Point(50, 28)
        Me.AnywhereCheck.Name = "AnywhereCheck"
        Me.AnywhereCheck.Size = New System.Drawing.Size(104, 17)
        Me.AnywhereCheck.TabIndex = 23
        Me.AnywhereCheck.Text = "Anywhere in text"
        Me.AnywhereCheck.UseVisualStyleBackColor = True
        '
        'AuthorSearch
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.AnywhereCheck)
        Me.Controls.Add(Me.Label2)
        Me.Controls.Add(Me.ResultsGrid)
        Me.Controls.Add(Me.SearchButton)
        Me.Controls.Add(Me.searchText)
        Me.Controls.Add(Me.Label1)
        Me.Name = "AuthorSearch"
        Me.Size = New System.Drawing.Size(556, 527)
        CType(Me.ResultsGrid, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents ResultsGrid As System.Windows.Forms.DataGridView
    Friend WithEvents SearchButton As System.Windows.Forms.Button
    Friend WithEvents searchText As System.Windows.Forms.TextBox
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents AuthorPk As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents Abbreviation As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents Forename As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents Surname As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents CorrectAuthor As System.Windows.Forms.DataGridViewTextBoxColumn
    Friend WithEvents AnywhereCheck As System.Windows.Forms.CheckBox

End Class

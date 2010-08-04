Imports System.Windows.Forms
Imports System.Drawing
Imports ChecklistObjects


Public Class Search
    Inherits System.Windows.Forms.UserControl

#Region " Windows Form Designer generated code "

    Public Sub New()
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call
        mUtility = New LcUtility()
        Me.mUserSettingsEnabled = False
    End Sub

    'UserControl overrides dispose to clean up the component list.
    Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
        If disposing Then
            If Not (components Is Nothing) Then
                components.Dispose()
            End If
        End If
        MyBase.Dispose(disposing)
    End Sub
    Friend WithEvents colName As System.Windows.Forms.ColumnHeader
    Friend WithEvents colParent As System.Windows.Forms.ColumnHeader
            Friend WithEvents lvwResults As System.Windows.Forms.ListView
    Friend WithEvents mDsName As DataSet
    Friend WithEvents imgResults As System.Windows.Forms.ImageList
    Friend WithEvents imlTaxTreeImages As System.Windows.Forms.ImageList
    Friend WithEvents colYearOf As System.Windows.Forms.ColumnHeader
    Friend WithEvents colYearOn As System.Windows.Forms.ColumnHeader
    Friend WithEvents colAuthors As System.Windows.Forms.ColumnHeader
    Friend WithEvents colBasionym As System.Windows.Forms.ColumnHeader
    'Friend WithEvents colBasionymDate As System.Windows.Forms.ColumnHeader
    Friend WithEvents colRank As System.Windows.Forms.ColumnHeader
    Friend WithEvents colRankSort As System.Windows.Forms.ColumnHeader
    Friend WithEvents colKey As System.Windows.Forms.ColumnHeader
    Friend WithEvents colLSID As System.Windows.Forms.ColumnHeader
    Friend WithEvents Splitter1 As System.Windows.Forms.Splitter
    Friend WithEvents panSearchSettings As System.Windows.Forms.Panel
    Friend WithEvents Panel1 As System.Windows.Forms.Panel
    Friend WithEvents rbnOr As System.Windows.Forms.RadioButton
    Friend WithEvents cmdSearch As System.Windows.Forms.Button
    Friend WithEvents rbnAnd As System.Windows.Forms.RadioButton
    Friend WithEvents cbxAnywhere1 As System.Windows.Forms.CheckBox
    Friend WithEvents cmbField1 As System.Windows.Forms.ComboBox
    Friend WithEvents cmbSearchText1 As System.Windows.Forms.ComboBox
    Friend WithEvents cbxWholeWord1 As System.Windows.Forms.CheckBox
    Friend WithEvents lblField1 As System.Windows.Forms.Label
    Friend WithEvents lblField2 As System.Windows.Forms.Label
    Friend WithEvents cbxAnywhere2 As System.Windows.Forms.CheckBox
    Friend WithEvents cmbSearchText2 As System.Windows.Forms.ComboBox
    Friend WithEvents cbxWholeWord2 As System.Windows.Forms.CheckBox
    Friend WithEvents cmbField2 As System.Windows.Forms.ComboBox
    Friend WithEvents cbxMisappliedOnly As System.Windows.Forms.CheckBox
    Friend WithEvents cbxHybridsOnly As System.Windows.Forms.CheckBox
    Friend WithEvents colFullName As System.Windows.Forms.ColumnHeader
    Private components As System.ComponentModel.IContainer

    'Required by the Windows Form Designer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    Friend WithEvents cbxCurrentNamesOnly As System.Windows.Forms.CheckBox
    Friend WithEvents lblCount As System.Windows.Forms.Label
    Friend WithEvents txtYearStart As System.Windows.Forms.TextBox
    Friend WithEvents txtYearEnd As System.Windows.Forms.TextBox
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents cmdClearFields As System.Windows.Forms.Button
    Friend WithEvents ToolTip1 As System.Windows.Forms.ToolTip
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container
        Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(Search))
        Me.cbxHybridsOnly = New System.Windows.Forms.CheckBox
        Me.mDsName = New DataSet
        Me.Panel1 = New System.Windows.Forms.Panel
        Me.lblCount = New System.Windows.Forms.Label
        Me.Label3 = New System.Windows.Forms.Label
        Me.rbnOr = New System.Windows.Forms.RadioButton
        Me.cmdSearch = New System.Windows.Forms.Button
        Me.rbnAnd = New System.Windows.Forms.RadioButton
        Me.cmdClearFields = New System.Windows.Forms.Button
        Me.cbxAnywhere1 = New System.Windows.Forms.CheckBox
        Me.cbxAnywhere2 = New System.Windows.Forms.CheckBox
        Me.colName = New System.Windows.Forms.ColumnHeader
        Me.colRankSort = New System.Windows.Forms.ColumnHeader
        Me.colRank = New System.Windows.Forms.ColumnHeader
        'Me.colBasionymDate = New System.Windows.Forms.ColumnHeader
        Me.cbxWholeWord2 = New System.Windows.Forms.CheckBox
        Me.cmbField1 = New System.Windows.Forms.ComboBox
        Me.cmbField2 = New System.Windows.Forms.ComboBox
        Me.colParent = New System.Windows.Forms.ColumnHeader
        Me.lblField1 = New System.Windows.Forms.Label
        Me.imgResults = New System.Windows.Forms.ImageList(Me.components)
        Me.cbxMisappliedOnly = New System.Windows.Forms.CheckBox
        Me.cmbSearchText2 = New System.Windows.Forms.ComboBox
        Me.cbxWholeWord1 = New System.Windows.Forms.CheckBox
        Me.colAuthors = New System.Windows.Forms.ColumnHeader
        Me.lblField2 = New System.Windows.Forms.Label
        Me.colFullName = New System.Windows.Forms.ColumnHeader
        Me.colKey = New System.Windows.Forms.ColumnHeader
        Me.colLSID = New System.Windows.Forms.ColumnHeader
        Me.lvwResults = New System.Windows.Forms.ListView
        Me.colYearOf = New System.Windows.Forms.ColumnHeader
        Me.colYearOn = New System.Windows.Forms.ColumnHeader
        Me.colBasionym = New System.Windows.Forms.ColumnHeader
        Me.imlTaxTreeImages = New System.Windows.Forms.ImageList(Me.components)
        Me.cmbSearchText1 = New System.Windows.Forms.ComboBox
        Me.panSearchSettings = New System.Windows.Forms.Panel
        Me.txtYearStart = New System.Windows.Forms.TextBox
        Me.Label2 = New System.Windows.Forms.Label
        Me.Label1 = New System.Windows.Forms.Label
        Me.txtYearEnd = New System.Windows.Forms.TextBox
        Me.cbxCurrentNamesOnly = New System.Windows.Forms.CheckBox
        Me.Splitter1 = New System.Windows.Forms.Splitter
        Me.ToolTip1 = New System.Windows.Forms.ToolTip(Me.components)
        CType(Me.mDsName, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.Panel1.SuspendLayout()
        Me.panSearchSettings.SuspendLayout()
        Me.SuspendLayout()
        '
        'cbxHybridsOnly
        '
        Me.cbxHybridsOnly.Location = New System.Drawing.Point(208, 184)
        Me.cbxHybridsOnly.Name = "cbxHybridsOnly"
        Me.cbxHybridsOnly.TabIndex = 12
        Me.cbxHybridsOnly.Text = "Hybrids Only"
        Me.ToolTip1.SetToolTip(Me.cbxHybridsOnly, "Filter search result for Hybrid Names only")
        '
        'mDsName
        '
        Me.mDsName.DataSetName = "DsName"
        Me.mDsName.Locale = New System.Globalization.CultureInfo("en-US")
        '
        'Panel1
        '
        Me.Panel1.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.Panel1.BackColor = System.Drawing.Color.LightSkyBlue
        Me.Panel1.Controls.Add(Me.lblCount)
        Me.Panel1.Controls.Add(Me.Label3)
        Me.Panel1.Controls.Add(Me.rbnOr)
        Me.Panel1.Controls.Add(Me.cmdSearch)
        Me.Panel1.Controls.Add(Me.rbnAnd)
        Me.Panel1.Controls.Add(Me.cmdClearFields)
        Me.Panel1.Location = New System.Drawing.Point(128, 0)
        Me.Panel1.Name = "Panel1"
        Me.Panel1.Size = New System.Drawing.Size(72, 116)
        Me.Panel1.TabIndex = 6
        '
        'lblCount
        '
        Me.lblCount.Location = New System.Drawing.Point(4, 96)
        Me.lblCount.Name = "lblCount"
        Me.lblCount.Size = New System.Drawing.Size(64, 16)
        Me.lblCount.TabIndex = 6
        '
        'Label3
        '
        Me.Label3.Location = New System.Drawing.Point(4, 80)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(64, 16)
        Me.Label3.TabIndex = 7
        Me.Label3.Text = "# of Results"
        '
        'rbnOr
        '
        Me.rbnOr.Location = New System.Drawing.Point(8, 56)
        Me.rbnOr.Name = "rbnOr"
        Me.rbnOr.Size = New System.Drawing.Size(48, 24)
        Me.rbnOr.TabIndex = 2
        Me.rbnOr.Text = "Or"
        Me.ToolTip1.SetToolTip(Me.rbnOr, "Return Union of First and Second Search")
        '
        'cmdSearch
        '
        Me.cmdSearch.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.cmdSearch.Location = New System.Drawing.Point(8, 8)
        Me.cmdSearch.Name = "cmdSearch"
        Me.cmdSearch.Size = New System.Drawing.Size(56, 23)
        Me.cmdSearch.TabIndex = 5
        Me.cmdSearch.Text = "Search"
        Me.ToolTip1.SetToolTip(Me.cmdSearch, "Begin Search")
        '
        'rbnAnd
        '
        Me.rbnAnd.Location = New System.Drawing.Point(8, 32)
        Me.rbnAnd.Name = "rbnAnd"
        Me.rbnAnd.Size = New System.Drawing.Size(48, 24)
        Me.rbnAnd.TabIndex = 0
        Me.rbnAnd.Text = "And"
        Me.ToolTip1.SetToolTip(Me.rbnAnd, "Return Intersection of First and Second Search")
        '
        'cmdClearFields
        '
        Me.cmdClearFields.FlatStyle = System.Windows.Forms.FlatStyle.Flat
        Me.cmdClearFields.Location = New System.Drawing.Point(8, 132)
        Me.cmdClearFields.Name = "cmdClearFields"
        Me.cmdClearFields.Size = New System.Drawing.Size(56, 23)
        Me.cmdClearFields.TabIndex = 16
        Me.cmdClearFields.Text = "Clear"
        Me.ToolTip1.SetToolTip(Me.cmdClearFields, "Clear All Fields")
        '
        'cbxAnywhere1
        '
        Me.cbxAnywhere1.Location = New System.Drawing.Point(8, 72)
        Me.cbxAnywhere1.Name = "cbxAnywhere1"
        Me.cbxAnywhere1.Size = New System.Drawing.Size(112, 16)
        Me.cbxAnywhere1.TabIndex = 2
        Me.cbxAnywhere1.Text = "Anywhere in text"
        Me.ToolTip1.SetToolTip(Me.cbxAnywhere1, "Allow the Text to be matched any where in the first search field")
        '
        'cbxAnywhere2
        '
        Me.cbxAnywhere2.Location = New System.Drawing.Point(208, 72)
        Me.cbxAnywhere2.Name = "cbxAnywhere2"
        Me.cbxAnywhere2.Size = New System.Drawing.Size(112, 16)
        Me.cbxAnywhere2.TabIndex = 6
        Me.cbxAnywhere2.Text = "Anywhere in text"
        Me.ToolTip1.SetToolTip(Me.cbxAnywhere2, "Allow the Text to be matched any where in the second search field")
        '
        'colName
        '
        Me.colName.Text = "Canonical Name"
        Me.colName.Width = 132
        '
        'colRankSort
        '
        Me.colRankSort.Text = "Rank"
        Me.colRankSort.Width = 47
        '
        'colRank
        '
        Me.colRank.Text = "Rank Name"
        Me.colRank.Width = 74
        '
        'colBasionymDate
        '
        'Me.colBasionymDate.Text = "Basionym Date"
        'Me.colBasionymDate.Width = 84
        '
        'cbxWholeWord2
        '
        Me.cbxWholeWord2.Location = New System.Drawing.Point(208, 96)
        Me.cbxWholeWord2.Name = "cbxWholeWord2"
        Me.cbxWholeWord2.Size = New System.Drawing.Size(112, 16)
        Me.cbxWholeWord2.TabIndex = 7
        Me.cbxWholeWord2.Text = "Whole word"
        Me.ToolTip1.SetToolTip(Me.cbxWholeWord2, "Match the second search text to Whole Words only")
        '
        'cmbField1
        '
        Me.cmbField1.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cmbField1.DropDownWidth = 200
        Me.cmbField1.Items.AddRange(New Object() {"NameFull", "NameGuid", "NameCanonical", "NameFull", "TaxonRankName", "NameAuthors", "NameYearOfPublication", "NameYearOnPublication"})
        Me.cmbField1.Location = New System.Drawing.Point(8, 48)
        Me.cmbField1.Name = "cmbField1"
        Me.cmbField1.Size = New System.Drawing.Size(112, 21)
        Me.cmbField1.TabIndex = 1
        Me.ToolTip1.SetToolTip(Me.cmbField1, "First Field to search")
        '
        'cmbField2
        '
        Me.cmbField2.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cmbField2.DropDownWidth = 200
        Me.cmbField2.Items.AddRange(New Object() {"NameFull", "NameGuid", "NameCanonical", "NameFull", "TaxonRankName", "NameAuthors", "NameYearOfPublication", "NameYearOnPublication"})
        Me.cmbField2.Location = New System.Drawing.Point(208, 48)
        Me.cmbField2.Name = "cmbField2"
        Me.cmbField2.Size = New System.Drawing.Size(112, 21)
        Me.cmbField2.TabIndex = 5
        Me.ToolTip1.SetToolTip(Me.cmbField2, "Second Field to search")
        '
        'colParent
        '
        Me.colParent.Text = "Parent"
        Me.colParent.Width = 102
        '
        'lblField1
        '
        Me.lblField1.Location = New System.Drawing.Point(8, 8)
        Me.lblField1.Name = "lblField1"
        Me.lblField1.Size = New System.Drawing.Size(48, 16)
        Me.lblField1.TabIndex = 7
        Me.lblField1.Text = "Field 1"
        '
        'imgResults
        '
        Me.imgResults.ImageSize = New System.Drawing.Size(16, 16)
        Me.imgResults.ImageStream = CType(resources.GetObject("imgResults.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.imgResults.TransparentColor = System.Drawing.Color.Transparent
        '
        'cbxMisappliedOnly
        '
        Me.cbxMisappliedOnly.Location = New System.Drawing.Point(208, 160)
        Me.cbxMisappliedOnly.Name = "cbxMisappliedOnly"
        Me.cbxMisappliedOnly.TabIndex = 11
        Me.cbxMisappliedOnly.Text = "Misapplied Only"
        Me.ToolTip1.SetToolTip(Me.cbxMisappliedOnly, "Filter search result for Misapplied Names only")
        '
        'cmbSearchText2
        '
        Me.cmbSearchText2.DropDownWidth = 200
        Me.cmbSearchText2.Location = New System.Drawing.Point(208, 24)
        Me.cmbSearchText2.Name = "cmbSearchText2"
        Me.cmbSearchText2.Size = New System.Drawing.Size(112, 21)
        Me.cmbSearchText2.TabIndex = 4
        Me.ToolTip1.SetToolTip(Me.cmbSearchText2, "Second Text to search for")
        '
        'cbxWholeWord1
        '
        Me.cbxWholeWord1.Location = New System.Drawing.Point(8, 96)
        Me.cbxWholeWord1.Name = "cbxWholeWord1"
        Me.cbxWholeWord1.Size = New System.Drawing.Size(112, 16)
        Me.cbxWholeWord1.TabIndex = 3
        Me.cbxWholeWord1.Text = "Whole word"
        Me.ToolTip1.SetToolTip(Me.cbxWholeWord1, "Match the first search text to Whole Words only")
        '
        'colAuthors
        '
        Me.colAuthors.Text = "Authors"
        Me.colAuthors.Width = 89
        '
        'lblField2
        '
        Me.lblField2.Location = New System.Drawing.Point(208, 8)
        Me.lblField2.Name = "lblField2"
        Me.lblField2.Size = New System.Drawing.Size(48, 16)
        Me.lblField2.TabIndex = 7
        Me.lblField2.Text = "Field 2"
        '
        'colFullName
        '
        Me.colFullName.Text = "Full Name"
        Me.colFullName.Width = 150
        '
        'colKey
        '
        Me.colKey.Text = "Key"
        Me.colKey.Width = 44

        Me.colLSID.Text = "LSID"
        Me.colLSID.Width = 44
        '
        'lvwResults
        '
        Me.lvwResults.AllowColumnReorder = True
        Me.lvwResults.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.colFullName, Me.colParent, Me.colName, Me.colYearOf, Me.colYearOn, Me.colAuthors, Me.colBasionym, Me.colRank, Me.colRankSort, Me.colKey, Me.colLSID})
        Me.lvwResults.Dock = System.Windows.Forms.DockStyle.Fill
        Me.lvwResults.FullRowSelect = True
        Me.lvwResults.Location = New System.Drawing.Point(0, 122)
        Me.lvwResults.MultiSelect = False
        Me.lvwResults.Name = "lvwResults"
        Me.lvwResults.Size = New System.Drawing.Size(872, 182)
        Me.lvwResults.SmallImageList = Me.imlTaxTreeImages
        Me.lvwResults.TabIndex = 1
        Me.lvwResults.View = System.Windows.Forms.View.Details
        '
        'colYearOf
        '
        Me.colYearOf.Text = "Year Of"
        Me.colYearOf.Width = 52
        '
        'colYearOn
        '
        Me.colYearOn.Text = "Year On"
        Me.colYearOn.Width = 53
        '
        'colBasionym
        '
        Me.colBasionym.Text = "Basionym"
        Me.colBasionym.Width = 102
        '
        'imlTaxTreeImages
        '
        Me.imlTaxTreeImages.ImageSize = New System.Drawing.Size(16, 16)
        Me.imlTaxTreeImages.ImageStream = CType(resources.GetObject("imlTaxTreeImages.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.imlTaxTreeImages.TransparentColor = System.Drawing.Color.Transparent
        '
        'cmbSearchText1
        '
        Me.cmbSearchText1.DropDownWidth = 200
        Me.cmbSearchText1.Location = New System.Drawing.Point(8, 24)
        Me.cmbSearchText1.Name = "cmbSearchText1"
        Me.cmbSearchText1.Size = New System.Drawing.Size(112, 21)
        Me.cmbSearchText1.TabIndex = 0
        Me.ToolTip1.SetToolTip(Me.cmbSearchText1, "First text to search for")
        '
        'panSearchSettings
        '
        Me.panSearchSettings.BackColor = System.Drawing.Color.WhiteSmoke
        Me.panSearchSettings.Controls.Add(Me.txtYearStart)
        Me.panSearchSettings.Controls.Add(Me.Label2)
        Me.panSearchSettings.Controls.Add(Me.Label1)
        Me.panSearchSettings.Controls.Add(Me.txtYearEnd)
        Me.panSearchSettings.Controls.Add(Me.cbxHybridsOnly)
        Me.panSearchSettings.Controls.Add(Me.cbxMisappliedOnly)
        Me.panSearchSettings.Controls.Add(Me.cbxAnywhere2)
        Me.panSearchSettings.Controls.Add(Me.lblField2)
        Me.panSearchSettings.Controls.Add(Me.lblField1)
        Me.panSearchSettings.Controls.Add(Me.Panel1)
        Me.panSearchSettings.Controls.Add(Me.cbxAnywhere1)
        Me.panSearchSettings.Controls.Add(Me.cmbField1)
        Me.panSearchSettings.Controls.Add(Me.cmbSearchText1)
        Me.panSearchSettings.Controls.Add(Me.cbxWholeWord1)
        Me.panSearchSettings.Controls.Add(Me.cmbSearchText2)
        Me.panSearchSettings.Controls.Add(Me.cbxWholeWord2)
        Me.panSearchSettings.Controls.Add(Me.cmbField2)
        Me.panSearchSettings.Controls.Add(Me.cbxCurrentNamesOnly)
        Me.panSearchSettings.Dock = System.Windows.Forms.DockStyle.Top
        Me.panSearchSettings.Location = New System.Drawing.Point(0, 0)
        Me.panSearchSettings.Name = "panSearchSettings"
        Me.panSearchSettings.Size = New System.Drawing.Size(872, 116)
        Me.panSearchSettings.TabIndex = 0
        '
        'txtYearStart
        '
        Me.txtYearStart.Location = New System.Drawing.Point(8, 160)
        Me.txtYearStart.MaxLength = 4
        Me.txtYearStart.Name = "txtYearStart"
        Me.txtYearStart.Size = New System.Drawing.Size(32, 20)
        Me.txtYearStart.TabIndex = 8
        Me.txtYearStart.Text = ""
        Me.ToolTip1.SetToolTip(Me.txtYearStart, "Start Year. If this is blank, there is no start restriction")
        '
        'Label2
        '
        Me.Label2.Location = New System.Drawing.Point(8, 140)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(100, 12)
        Me.Label2.TabIndex = 15
        Me.Label2.Text = "Restrict Years"
        '
        'Label1
        '
        Me.Label1.Location = New System.Drawing.Point(40, 164)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(16, 16)
        Me.Label1.TabIndex = 14
        Me.Label1.Text = "to"
        '
        'txtYearEnd
        '
        Me.txtYearEnd.Location = New System.Drawing.Point(56, 160)
        Me.txtYearEnd.MaxLength = 4
        Me.txtYearEnd.Name = "txtYearEnd"
        Me.txtYearEnd.Size = New System.Drawing.Size(32, 20)
        Me.txtYearEnd.TabIndex = 9
        Me.txtYearEnd.Text = ""
        Me.ToolTip1.SetToolTip(Me.txtYearEnd, "End Year. If this is blank, there is no end restriction")
        '
        'cbxCurrentNamesOnly
        '
        Me.cbxCurrentNamesOnly.Location = New System.Drawing.Point(208, 136)
        Me.cbxCurrentNamesOnly.Name = "cbxCurrentNamesOnly"
        Me.cbxCurrentNamesOnly.Size = New System.Drawing.Size(140, 24)
        Me.cbxCurrentNamesOnly.TabIndex = 10
        Me.cbxCurrentNamesOnly.Text = "Preferred Names Only"
        Me.ToolTip1.SetToolTip(Me.cbxCurrentNamesOnly, "Filter search result for Preferred Names only")
        '
        'Splitter1
        '
        Me.Splitter1.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.Splitter1.Dock = System.Windows.Forms.DockStyle.Top
        Me.Splitter1.Location = New System.Drawing.Point(0, 116)
        Me.Splitter1.Name = "Splitter1"
        Me.Splitter1.Size = New System.Drawing.Size(872, 6)
        Me.Splitter1.TabIndex = 3
        Me.Splitter1.TabStop = False
        '
        'Search
        '
        Me.Controls.Add(Me.lvwResults)
        Me.Controls.Add(Me.Splitter1)
        Me.Controls.Add(Me.panSearchSettings)
        Me.Name = "Search"
        Me.Size = New System.Drawing.Size(872, 304)
        CType(Me.mDsName, System.ComponentModel.ISupportInitialize).EndInit()
        Me.Panel1.ResumeLayout(False)
        Me.panSearchSettings.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

#Region "Constants"

    Private Const MAX_SEARCH_HISTORY As Long = 20
    Private Const COLUMN_COUNT As Long = 11

    'Result list
    Private Const SEARCH_FORM_STR As String = "SearchControl"
    Private Const RESULTS_CONTROL_STR As String = "lvwResults"

    Private Const FULL_NAME_COLUMN_WIDTH_STR As String = "FullNameColumnWidth"
    Private Const NAME_COLUMN_WIDTH_STR As String = "NameColumnWidth"
    Private Const PARENT_COLUMN_WIDTH_STR As String = "ParentColumnWidth"
    Private Const YEAROF_COLUMN_WIDTH_STR As String = "YearOfColumnWidth"
    Private Const YEARON_COLUMN_WIDTH_STR As String = "YearOnColumnWidth"
    Private Const AUTHORS_COLUMN_WIDTH_STR As String = "AuthorsColumnWidth"
    Private Const BASIONYM_COLUMN_WIDTH_STR As String = "BasionymColumnWidth"
    'Private Const BDATE_COLUMN_WIDTH_STR As String = "BasionymDateColumnWidth"
    Private Const RANK_NAME_COLUMN_WIDTH_STR As String = "RankNameColumnWidth"
    Private Const RANK_COLUMN_WIDTH_STR As String = "RankColumnWidth"
    Private Const KEY_COLUMN_WIDTH_STR As String = "KeyColumnWidth"

    'Search parameters
    Private Const SEARCH_PARAMETERS_CONTROL_STR As String = "SearchParameters"

    Private Const SEARCH_TEXT1_COUNT_STR As String = "SearchTextCount1"
    Private Const SEARCH_TEXT1_STR As String = "SearchText1_H"
    Private Const SEARCH_FIELD1_STR As String = "SearchField1"
    Private Const SEARCH_ANYWHERE1_STR As String = "SearchAnywhere1"
    Private Const SEARCH_WHOLEWORD1_STR As String = "SearchWholeWord1"

    Private Const SEARCH_TEXT2_COUNT_STR As String = "SearchTextCount2"
    Private Const SEARCH_TEXT2_STR As String = "SearchText2_H"
    Private Const SEARCH_FIELD2_STR As String = "SearchField2"
    Private Const SEARCH_ANYWHERE2_STR As String = "SearchAnywhere2"
    Private Const SEARCH_WHOLEWORD2_STR As String = "SearchWholeWord2"

    Private Const SEARCH_OR_STR As String = "SearchOr"

    'Splitter
    Private Const SEARCH_SPLITTER_STR As String = "SearchSplitter"


#End Region

#Region "Member Variables"

    Private mUtility As LcUtility
    Private mrgSortAscending(COLUMN_COUNT) As Boolean
    Private mComparer As SearchResultCompare
    Private mUserSettingsEnabled As Boolean
    Private mUserKey As Long
    Private mSearchFields As String()


#End Region

#Region "Events"

    Public Event Selected(ByVal sender As System.Object, ByVal e As System.EventArgs)

    Private Sub Search_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load
        InitialiseSort()
        cmbField1.SelectedIndex = 0
        cmbField2.SelectedIndex = 3

        SetupSearchFields()

        cmbSearchText1.Focus()
    End Sub

    Private Sub SetupSearchFields()
        If mSearchFields IsNot Nothing Then
            cmbField1.Items.Clear()
            cmbField2.Items.Clear()

            For Each s As String In mSearchFields
                cmbField1.Items.Add(s)
                cmbField2.Items.Add(s)
            Next

            If mSearchFields.Length > 0 Then
                cmbField1.SelectedIndex = 0
                cmbField2.SelectedIndex = 0
            End If
        End If
    End Sub


    Private Sub lvwResults_ColumnClick(ByVal sender As Object, ByVal e As System.Windows.Forms.ColumnClickEventArgs) Handles lvwResults.ColumnClick


        Dim ColumnIndex As Long = e.Column
        If ColumnIndex = mComparer.ColumnIndex Then
            mComparer.Ascending = ToggleSortOrder(ColumnIndex)
        Else
            mComparer.Ascending = True
        End If

        mComparer.ColumnIndex = ColumnIndex
        mComparer.SortingOn = True
        lvwResults.Sort()

    End Sub

    Private Sub cmdSearch_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdSearch.Click
        Search()
    End Sub

    Private Sub txtSearchText_Enter(ByVal sender As System.Object, ByVal e As System.Windows.Forms.KeyPressEventArgs) Handles cmbSearchText1.KeyPress
        Dim key As Char = e.KeyChar
        If key.Equals(Chr(13)) Then
            Search()
        End If
    End Sub

    Private Sub lvwResults_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles lvwResults.SelectedIndexChanged
        RaiseEvent Selected(sender, e)
    End Sub

    Private Sub lvwResults_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles lvwResults.GotFocus
        RaiseEvent Selected(sender, e)
    End Sub

    Public Event SearchDoubleClick(ByVal NameGuid As String, ByVal NameFull As String, ByVal NameLSID As String)

    Private Sub lvwResults_DoubleClick(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles lvwResults.DoubleClick
        'RaiseEvent Selected(sender, e)

        If lvwResults.SelectedItems.Count > 0 Then
            Dim item As ListViewItem = lvwResults.SelectedItems(0)
            Dim Key As String = item.Tag
            Dim NameFull As String = item.SubItems(SearchResultCompare.enumColumn.FullName).Text
            Dim lsid As String = item.SubItems(SearchResultCompare.enumColumn.LSID).Text
            RaiseEvent SearchDoubleClick(Key, NameFull, lsid)
        End If

    End Sub

    Private Sub Splitter1_MouseHover(ByVal sender As System.Object, ByVal e As EventArgs) Handles Splitter1.MouseEnter
        Splitter1.BackColor = Color.DeepSkyBlue
    End Sub

    Private Sub Splitter1_MouseLeave(ByVal sender As System.Object, ByVal e As EventArgs) Handles Splitter1.MouseLeave
        Splitter1.BackColor = System.Drawing.SystemColors.Control
    End Sub

#End Region

#Region "Properties"

    Public Property UserSettingsEnabled() As Boolean
        Get
            Return mUserSettingsEnabled
        End Get
        Set(ByVal Value As Boolean)
            mUserSettingsEnabled = Value
        End Set
    End Property

    Public Property SearchFields() As String()
        Get
            Return mSearchFields
        End Get
        Set(ByVal value As String())
            mSearchFields = value
            SetupSearchFields()
        End Set
    End Property
#End Region

#Region "Private Functions and Subs"

    Private Sub ClearFields()

        Me.lblCount.Text = ""

        Me.rbnAnd.Checked = True

        Me.cmbSearchText1.Text = ""
        Me.cmbSearchText2.Text = ""

        Me.cbxAnywhere1.Checked = False
        Me.cbxAnywhere2.Checked = False

        Me.cbxWholeWord1.Checked = False
        Me.cbxWholeWord2.Checked = False

        Me.cmbField1.SelectedIndex = 0
        Me.cmbField2.SelectedIndex = 5

        Me.cbxMisappliedOnly.Checked = False
        Me.cbxCurrentNamesOnly.Checked = False
        Me.cbxHybridsOnly.Checked = False

        Me.txtYearStart.Text = ""

        Me.txtYearEnd.Text = ""

    End Sub

    Private Function ToggleSortOrder(ByVal Column As Long) As Boolean
        mrgSortAscending(Column) = Not mrgSortAscending(Column)
        Return mrgSortAscending(Column)
    End Function

    Private Sub InitialiseSort()
        mComparer = New SearchResultCompare
        lvwResults.ListViewItemSorter = mComparer
        Dim index As Long
        For index = 0 To COLUMN_COUNT
            mrgSortAscending(index) = True
        Next
        mComparer.ColumnIndex = 0
    End Sub

    Private Sub AddRowToList(ByVal row As DataRow)

        Dim Parent As String = ""
        If Not row.IsNull("ParentName") Then
            Parent = row("ParentName")
        End If

        Dim YearOf As String = ""
        If row.IsNull("NameYearOfPublication") = False Then
            YearOf = row("NameYearOfPublication")
        End If

        Dim YearOn As String = ""
        If row.IsNull("NameYearOnPublication") = False Then
            YearOn = row("NameYearOnPublication")
        End If

        Dim Author As String = ""
        If row.IsNull("NameAuthors") = False Then
            Author = row("NameAuthors")
        End If

        Dim Basionym As String = ""
        If row.IsNull("basionymName") = False Then
            Basionym = row("basionymName")
        End If

        'Dim BasionymDate As String = False
        'If row.IsBasionymDateNull = False Then
        '    BasionymDate = row.BasionymDate
        'End If

        Dim TaxonRankSort As Long = -1
        If row.IsNull("TaxonRankSort") = False Then
            TaxonRankSort = row("TaxonRankSort")
        End If

        Dim TaxonRankName As String = ""
        If row.IsNull("TaxonRankName") = False Then
            TaxonRankName = row("TaxonRankName")
        End If

        Dim FullName As String = ""
        If row.IsNull("NameFull") = False Then
            FullName = row("NameFull")
        End If

        AddToList(row("NameGuid"), row("NameCanonical"), Parent, YearOf, YearOn, Author, Basionym, TaxonRankName, TaxonRankSort, FullName, row("NameTaxonRankFk"), row("NameLSID"))
    End Sub

    Private Sub AddToList(ByVal Key As String, ByVal Name As String, ByVal Parent As String, ByVal YearOf As String, ByVal YearOn As String, ByVal Author As String, ByVal Basionym As String, ByVal RankName As String, ByVal RankSort As Long, ByVal FullName As String, ByVal RankKey As Long, ByVal LSID As String, Optional ByVal ItemSelected As Boolean = False)

        Dim ImageIndex As Integer = 0
        If RankKey >= 0 Then
            ImageIndex = mUtility.GetImageIndex(RankKey)
        End If

        Dim item As ListViewItem
        item = lvwResults.Items.Add(FullName, ImageIndex)

        item.Tag = Key

        item.SubItems.Add(New ListViewItem.ListViewSubItem(item, Parent))
        item.SubItems.Add(New ListViewItem.ListViewSubItem(item, Name))
        item.SubItems.Add(New ListViewItem.ListViewSubItem(item, YearOf))
        item.SubItems.Add(New ListViewItem.ListViewSubItem(item, YearOn))
        item.SubItems.Add(New ListViewItem.ListViewSubItem(item, Author))
        item.SubItems.Add(New ListViewItem.ListViewSubItem(item, Basionym))
        'item.SubItems.Add(New ListViewItem.ListViewSubItem(item, BasionymDate))
        item.SubItems.Add(New ListViewItem.ListViewSubItem(item, RankName))
        item.SubItems.Add(New ListViewItem.ListViewSubItem(item, RankSort))
        item.SubItems.Add(New ListViewItem.ListViewSubItem(item, Key))
        item.SubItems.Add(New ListViewItem.ListViewSubItem(item, LSID))

        If ItemSelected = True Then
            item.Selected = True
        End If

    End Sub

    Private Sub Search()
        Me.Cursor.Current = System.Windows.Forms.Cursors.WaitCursor
        Dim CancelId As Guid = Guid.NewGuid

        Dim TitleText As String = "Searching for " & cmbSearchText1.Text
        LcUtility.StartCancelDialog(CancelId, False, True, TitleText)

        LoadSearchDs(CancelId)

        AddSearchToList(Me.cmbSearchText1)
        AddSearchToList(Me.cmbSearchText2)

        lvwResults.Items.Clear()
        lvwResults.Sorting = SortOrder.None
        mComparer.SortingOn = False

        Dim table As DataTable = mDsName.Tables(0)
        Dim count As Long = table.Rows.Count
        lblCount.Text = count

        lvwResults.BeginUpdate()

        For Each row As DataRow In table.Rows
            If LcUtility.CancelRequested = True Then
                Exit For
            End If

            Dim Namekey As String = row("NameGuid")
            If LcUtility.KeyNotSet(Namekey) = False Then
                AddRowToList(row)
            End If
        Next
        lvwResults.EndUpdate()

        LcUtility.EndCancelForm()

        mDsName.Clear()
        Me.Cursor.Current = System.Windows.Forms.Cursors.Default
    End Sub

    Private Sub LoadSearchDs(ByVal CancelId As Guid)

        If Trim(cmbField1.Text) = "" Then
            MessageBox.Show("A Field must be selected", "Field 1", MessageBoxButtons.OK, MessageBoxIcon.Exclamation)
            Exit Sub
        End If
        If Trim(cmbField2.Text) = "" And Trim(cmbSearchText2.Text) <> "" Then
            MessageBox.Show("A Field must be selected", "Field 2", MessageBoxButtons.OK, MessageBoxIcon.Exclamation)
            Exit Sub
        End If

        Dim UseOr As Boolean = rbnOr.Checked

        Dim Search1 As SearchStruct = New SearchStruct
        Dim Search2 As SearchStruct = New SearchStruct

        Search1.SearchText = Trim(cmbSearchText1.Text)
        Search1.Field = cmbField1.Text
        Search1.AnywhereInText = cbxAnywhere1.Checked
        Search1.WholeWord = cbxWholeWord1.Checked

        Search1.MisappliedOnly = cbxMisappliedOnly.Checked
        Search1.HybridOnly = cbxHybridsOnly.Checked
        Search1.CurrentNamesOnly = cbxCurrentNamesOnly.Checked

        If IsNumeric(txtYearStart.Text) Then
            Search1.YearStart = txtYearStart.Text
        Else
            Search1.YearStart = 0
        End If

        If IsNumeric(txtYearEnd.Text) Then
            Search1.YearEnd = txtYearEnd.Text
        Else
            Search1.YearEnd = 0
        End If

        Search1.CancelId = CancelId

        Search2.SearchText = Trim(cmbSearchText2.Text)
        Search2.Field = cmbField2.Text
        Search2.AnywhereInText = cbxAnywhere2.Checked
        Search2.WholeWord = cbxWholeWord2.Checked

        mDsName.Clear()

        mDsName = ChecklistDataAccess.Search.SelectSearchResults(1, Search1, UseOr, Search2)

    End Sub

    'Private Sub LoadSearchHistory(ByRef objCombo As ComboBox, ByVal strParameter As String, ByVal CountText As String)
    '    objCombo.Items.Clear() '
    '    Dim count As Long = 0
    '    Dim strValue As String = mUtility.GetUserSetting(mUserKey, SEARCH_FORM_STR, SEARCH_PARAMETERS_CONTROL_STR, CountText)
    '    If IsNumeric(strValue) Then
    '        count = strValue
    '    End If

    '    Dim index As Long
    '    For index = 0 To count - 1
    '        Dim ParameterTag As String = strParameter & index
    '        strValue = mUtility.GetUserSetting(mUserKey, SEARCH_FORM_STR, SEARCH_PARAMETERS_CONTROL_STR, ParameterTag)
    '        If strValue <> "" Then
    '            objCombo.Items.Add(strValue)
    '        End If
    '    Next

    'End Sub

    'Private Sub SaveSearchHistory(ByRef objCombo As ComboBox, ByVal strParameter As String, ByVal CountText As String)
    '    Dim count As Long = objCombo.Items.Count
    '    Dim index As Long
    '    For index = 0 To count - 1
    '        Dim text As String = objCombo.Items(index)
    '        Dim ParameterTag As String = strParameter & index
    '        mUtility.UpdateUserSetting(mUserKey, SEARCH_FORM_STR, SEARCH_PARAMETERS_CONTROL_STR, ParameterTag, text)
    '    Next
    '    mUtility.UpdateUserSetting(mUserKey, SEARCH_FORM_STR, SEARCH_PARAMETERS_CONTROL_STR, CountText, count)
    'End Sub

    'Private Sub SaveField(ByRef objCombo As ComboBox, ByVal strParameter As String)
    '    mUtility.UpdateUserSetting(mUserKey, SEARCH_FORM_STR, SEARCH_PARAMETERS_CONTROL_STR, strParameter, objCombo.Text)
    'End Sub

    'Private Sub LoadField(ByRef objCombo As ComboBox, ByVal strParameter As String)
    '    Dim text As String = mUtility.GetUserSetting(mUserKey, SEARCH_FORM_STR, SEARCH_PARAMETERS_CONTROL_STR, strParameter)
    '    objCombo.Text = text
    'End Sub

    'Private Sub SaveCheckBox(ByRef objCheckBox As CheckBox, ByVal strParameter As String)
    '    Dim EnumState As Long
    '    If objCheckBox.Checked Then
    '        EnumState = 1
    '    Else
    '        EnumState = 0
    '    End If

    '    mUtility.UpdateUserSetting(mUserKey, SEARCH_FORM_STR, SEARCH_PARAMETERS_CONTROL_STR, strParameter, EnumState)
    'End Sub

    'Private Sub LoadCheckBox(ByRef objCheckBox As CheckBox, ByVal strParameter As String)
    '    Dim EnumState As Long = 0
    '    Dim strValue As String
    '    strValue = mUtility.GetUserSetting(mUserKey, SEARCH_FORM_STR, SEARCH_PARAMETERS_CONTROL_STR, strParameter)
    '    If IsNumeric(strValue) Then
    '        EnumState = strValue
    '    End If

    '    If EnumState = 0 Then
    '        objCheckBox.Checked = False
    '    Else
    '        objCheckBox.Checked = True
    '    End If
    'End Sub

    'Private Sub SaveRadioButton(ByRef objRadio As RadioButton)
    '    Dim EnumState As Long
    '    If objRadio.Checked Then
    '        EnumState = 1
    '    Else
    '        EnumState = 0
    '    End If

    '    mUtility.UpdateUserSetting(mUserKey, SEARCH_FORM_STR, SEARCH_PARAMETERS_CONTROL_STR, SEARCH_OR_STR, EnumState)
    'End Sub

    'Private Sub LoadRadioButton(ByRef objRadio As RadioButton)
    '    Dim EnumState As Long = 0
    '    Dim strValue As String
    '    strValue = mUtility.GetUserSetting(mUserKey, SEARCH_FORM_STR, SEARCH_PARAMETERS_CONTROL_STR, SEARCH_OR_STR)
    '    If IsNumeric(strValue) Then
    '        EnumState = strValue
    '    End If

    '    If EnumState = 0 Then
    '        objRadio.Checked = False
    '    Else
    '        objRadio.Checked = True
    '    End If
    'End Sub

    Private Sub AddSearchToList(ByRef objCombo As ComboBox)
        Dim text As String
        text = objCombo.Text

        'if string is empty do not palce in list
        If text.Length = 0 Then
            Exit Sub
        End If

        'if in list already do not put in list
        Dim ItemText As String
        For Each ItemText In objCombo.Items
            If ItemText = text Then
                Exit Sub
            End If
        Next

        objCombo.Items.Insert(0, text)

        If objCombo.Items.Count > MAX_SEARCH_HISTORY Then
            'take oldest entry in list
            objCombo.Items.RemoveAt(objCombo.Items.Count - 1)
        End If

    End Sub


    'Private Sub SaveSplitter()

    '    mUtility.UpdateUserSetting(mUserKey, SEARCH_FORM_STR, SEARCH_PARAMETERS_CONTROL_STR, SEARCH_SPLITTER_STR, panSearchSettings.Size.Height)
    'End Sub

    'Private Sub LoadSplitter()
    '    Dim strValue As String
    '    strValue = mUtility.GetUserSetting(mUserKey, SEARCH_FORM_STR, SEARCH_PARAMETERS_CONTROL_STR, SEARCH_SPLITTER_STR)
    '    If IsNumeric(strValue) Then
    '        Dim s As Size = panSearchSettings.Size
    '        s.Height = strValue
    '        panSearchSettings.Size = s
    '    End If
    'End Sub




#End Region

#Region "Public Functions and Subs"

    Public Sub SearchSuggestedName(ByVal Name As String)
        cmbSearchText1.Text = Name
        cmbSearchText2.Text = ""
        cmbField1.Text = "NameCanonical"
        cbxAnywhere1.Checked = False
        cbxWholeWord1.Checked = False
        Search()

        If lvwResults.Items.Count > 0 Then
            lvwResults.Items(0).Selected = True
        End If

    End Sub

    'Public Sub LoadUserSearchSettings(ByVal UserKey As Long)
    '    mUserKey = UserKey
    '    LoadSearchHistory(Me.cmbSearchText1, SEARCH_TEXT1_STR, SEARCH_TEXT1_COUNT_STR)
    '    LoadSearchHistory(Me.cmbSearchText2, SEARCH_TEXT2_STR, SEARCH_TEXT2_COUNT_STR)
    '    LoadField(Me.cmbField1, SEARCH_FIELD1_STR)
    '    LoadField(Me.cmbField2, SEARCH_FIELD2_STR)
    '    LoadCheckBox(Me.cbxAnywhere1, SEARCH_ANYWHERE1_STR)
    '    LoadCheckBox(Me.cbxAnywhere2, SEARCH_ANYWHERE2_STR)
    '    LoadCheckBox(Me.cbxWholeWord1, SEARCH_WHOLEWORD1_STR)
    '    LoadCheckBox(Me.cbxWholeWord2, SEARCH_WHOLEWORD2_STR)
    '    LoadRadioButton(Me.rbnOr)
    'End Sub

    'Public Sub SaveUserSearchSettings(ByVal UserKey As Long)
    '    mUserKey = UserKey
    '    SaveSearchHistory(Me.cmbSearchText1, SEARCH_TEXT1_STR, SEARCH_TEXT1_COUNT_STR)
    '    SaveSearchHistory(Me.cmbSearchText2, SEARCH_TEXT2_STR, SEARCH_TEXT2_COUNT_STR)
    '    SaveField(Me.cmbField1, SEARCH_FIELD1_STR)
    '    SaveField(Me.cmbField2, SEARCH_FIELD2_STR)
    '    SaveCheckBox(Me.cbxAnywhere1, SEARCH_ANYWHERE1_STR)
    '    SaveCheckBox(Me.cbxAnywhere2, SEARCH_ANYWHERE2_STR)
    '    SaveCheckBox(Me.cbxWholeWord1, SEARCH_WHOLEWORD1_STR)
    '    SaveCheckBox(Me.cbxWholeWord2, SEARCH_WHOLEWORD2_STR)
    '    SaveRadioButton(Me.rbnOr)
    'End Sub

    'SEARCH_FORM_STR
    'RESULTS_CONTROL_STR
    'NAME_COLUMN_WIDTH_STR 
    'PARENT_COLUMN_WIDTH_STR 
    'YEAROF_COLUMN_WIDTH_STR 
    'YEARON_COLUMN_WIDTH_STR 
    'AUTHORS_COLUMN_WIDTH_STR 
    'BASIONYM_COLUMN_WIDTH_STR 
    'BDATE_COLUMN_WIDTH_STR
    'RANK_NAME_COLUMN_WIDTH_STR
    'RANK_COLUMN_WIDTH_STR 
    'KEY_COLUMN_WIDTH_STR 

    'Public Sub SaveControlSettings(ByVal UserKey As Long)
    '    SaveResultsListSettings(UserKey)
    '    SaveUserSearchSettings(UserKey)
    '    SaveSplitter()
    'End Sub

    'Public Sub SaveResultsListSettings(ByVal UserKey As Long)

    '    mUtility.UpdateUserSetting(UserKey, SEARCH_FORM_STR, RESULTS_CONTROL_STR, NAME_COLUMN_WIDTH_STR, colName.Width)
    '    mUtility.UpdateUserSetting(UserKey, SEARCH_FORM_STR, RESULTS_CONTROL_STR, PARENT_COLUMN_WIDTH_STR, colParent.Width)
    '    mUtility.UpdateUserSetting(UserKey, SEARCH_FORM_STR, RESULTS_CONTROL_STR, YEAROF_COLUMN_WIDTH_STR, colYearOf.Width)
    '    mUtility.UpdateUserSetting(UserKey, SEARCH_FORM_STR, RESULTS_CONTROL_STR, YEARON_COLUMN_WIDTH_STR, colYearOn.Width)
    '    mUtility.UpdateUserSetting(UserKey, SEARCH_FORM_STR, RESULTS_CONTROL_STR, AUTHORS_COLUMN_WIDTH_STR, colAuthors.Width)
    '    mUtility.UpdateUserSetting(UserKey, SEARCH_FORM_STR, RESULTS_CONTROL_STR, BASIONYM_COLUMN_WIDTH_STR, colBasionym.Width)
    '    'mUtility.UpdateUserSetting(UserKey, SEARCH_FORM_STR, RESULTS_CONTROL_STR, BDATE_COLUMN_WIDTH_STR, colBasionymDate.Width)
    '    mUtility.UpdateUserSetting(UserKey, SEARCH_FORM_STR, RESULTS_CONTROL_STR, RANK_NAME_COLUMN_WIDTH_STR, colRank.Width)
    '    mUtility.UpdateUserSetting(UserKey, SEARCH_FORM_STR, RESULTS_CONTROL_STR, RANK_COLUMN_WIDTH_STR, colRankSort.Width)
    '    mUtility.UpdateUserSetting(UserKey, SEARCH_FORM_STR, RESULTS_CONTROL_STR, KEY_COLUMN_WIDTH_STR, colKey.Width)
    'End Sub

    'Public Sub LoadControlSettings(ByVal UserKey As Long)
    '    LoadResultsListSettings(UserKey)
    '    LoadUserSearchSettings(UserKey)
    '    LoadSplitter()
    'End Sub

    'Public Sub LoadResultsListSettings(ByVal UserKey As Long)

    '    Dim strValue As String
    '    strValue = mUtility.GetUserSetting(UserKey, SEARCH_FORM_STR, RESULTS_CONTROL_STR, NAME_COLUMN_WIDTH_STR)
    '    If IsNumeric(strValue) Then
    '        colName.Width = strValue
    '    End If
    '    strValue = mUtility.GetUserSetting(UserKey, SEARCH_FORM_STR, RESULTS_CONTROL_STR, PARENT_COLUMN_WIDTH_STR)
    '    If IsNumeric(strValue) Then
    '        colParent.Width = strValue
    '    End If
    '    strValue = mUtility.GetUserSetting(UserKey, SEARCH_FORM_STR, RESULTS_CONTROL_STR, YEAROF_COLUMN_WIDTH_STR)
    '    If IsNumeric(strValue) Then
    '        colYearOf.Width = strValue
    '    End If
    '    strValue = mUtility.GetUserSetting(UserKey, SEARCH_FORM_STR, RESULTS_CONTROL_STR, YEARON_COLUMN_WIDTH_STR)
    '    If IsNumeric(strValue) Then
    '        colYearOn.Width = strValue
    '    End If
    '    strValue = mUtility.GetUserSetting(UserKey, SEARCH_FORM_STR, RESULTS_CONTROL_STR, AUTHORS_COLUMN_WIDTH_STR)
    '    If IsNumeric(strValue) Then
    '        colAuthors.Width = strValue
    '    End If
    '    strValue = mUtility.GetUserSetting(UserKey, SEARCH_FORM_STR, RESULTS_CONTROL_STR, BASIONYM_COLUMN_WIDTH_STR)
    '    If IsNumeric(strValue) Then
    '        colBasionym.Width = strValue
    '    End If
    '    'strValue = mUtility.GetUserSetting(UserKey, SEARCH_FORM_STR, RESULTS_CONTROL_STR, BDATE_COLUMN_WIDTH_STR)
    '    'If IsNumeric(strValue) Then
    '    '    colBasionymDate.Width = strValue
    '    'End If
    '    strValue = mUtility.GetUserSetting(UserKey, SEARCH_FORM_STR, RESULTS_CONTROL_STR, RANK_NAME_COLUMN_WIDTH_STR)
    '    If IsNumeric(strValue) Then
    '        colRank.Width = strValue
    '    End If
    '    strValue = mUtility.GetUserSetting(UserKey, SEARCH_FORM_STR, RESULTS_CONTROL_STR, RANK_COLUMN_WIDTH_STR)
    '    If IsNumeric(strValue) Then
    '        colRankSort.Width = strValue
    '    End If
    '    strValue = mUtility.GetUserSetting(UserKey, SEARCH_FORM_STR, RESULTS_CONTROL_STR, KEY_COLUMN_WIDTH_STR)
    '    If IsNumeric(strValue) Then
    '        colKey.Width = strValue
    '    End If
    '    colLSID.Width = 0

    'End Sub

#End Region



    Private Sub txtYearStart_Validating(ByVal sender As Object, ByVal e As System.ComponentModel.CancelEventArgs) Handles txtYearStart.Validating
        Dim Cancel As Boolean = False

        If IsInt(txtYearStart.Text) = False Then
            Cancel = True
        End If

        If txtYearStart.Text = "" Then
            Cancel = False
        End If

        e.Cancel = Cancel
    End Sub

    Private Sub txtYearEnd_Validating(ByVal sender As Object, ByVal e As System.ComponentModel.CancelEventArgs) Handles txtYearEnd.Validating
        Dim Cancel As Boolean = False

        If IsInt(txtYearEnd.Text) = False Then
            Cancel = True
        End If

        If txtYearEnd.Text = "" Then
            Cancel = False
        End If

        e.Cancel = Cancel
    End Sub

    Private Function IsInt(ByVal text As String) As Boolean
        If IsNumeric(text) = False Then
            Return False
        End If
        Dim dblNumber As Double = text
        If Math.Floor(dblNumber) <> dblNumber Then
            Return False
        End If

        Return True
    End Function

    Private Sub cmdClearFields_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdClearFields.Click
        ClearFields()
    End Sub


End Class

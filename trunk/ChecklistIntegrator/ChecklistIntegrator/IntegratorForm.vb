Imports System.Collections.Specialized

Imports ChecklistObjects
Imports ChecklistBusinessRules
Imports ChecklistDataAccess
Imports IntegratorControls

Imports C1.Win.C1FlexGrid

Public Class IntegratorForm

    'names
    Private CurrentName As DataRow
    Private NameDetailsTable As New DataTable
    Private FieldStatusDs As DataSet
    Private ProviderNameRecords As DataSet
    Private ConceptRelRecords As DataSet
    Private ConceptDetailsTable As New DataTable
    Private ProviderConceptRelRecords As DataSet
    Private OtherDataDs As DataTable
    Private MergeName As DataRow
    Private MergeToName As DataRow
    Private PartialSave As Boolean = False
    Private FinishingEdit As Boolean = False
    Private BrowseId As Guid = Guid.NewGuid
    Private ClearId As Guid = Guid.NewGuid
    Private NameBrowseHistory As New List(Of String)

    Private NameHistory As New ListDictionary 'of ListDictionary
    Private ReferenceHistory As New ListDictionary 'of ListDictionary

    'references
    Private CurrentReference As DataRow
    Private CurrentReferenceRIS As DataTable
    Private ProviderRefRecords As DataSet
    Private ProviderRISRecords As DataSet
    Private RefChanged As Boolean = False

    'providers
    Private ProviderDs As DataSet
    Private CurrentProvider As DataRow

    'general
    Private EditMode As Boolean = False
    Private TreeInvalid As Boolean = False

    Private LinkToName As String = ""
    Private LinkToRef As String = ""
    Private LinkToProviderName As String = ""

    'concept relationship types (must be Pks as in DB table tblRelationshipType)
    Private Shared ParentRelationshipFk As Integer = 6
    Private Shared PreferredRelationshipFk As Integer = 15

    Private EditableNameColumns As List(Of String) = New List(Of String)(New String() { _
        "NameCanonical", "NameCombinationAuthors", "NameBasionymAuthors", _
        "NamePublishedIn", "NameYear", "NameMicroReference", "NameTypeVoucher", _
        "NameOrthography", "NameInCitation", "NameInvalid", "NameIllegitimate", "NameMisapplied", "NameProParte", _
        "NameGeographyText", "NameGeographyCodes", "NameClimate", "NameLifeform", _
        "NameIUCN", "NameStatusNotes", "NameNomNotes", "NameNotes", "NameRankFk"})

    Private LinkableNameColumns As List(Of String) = New List(Of String)(New String() { _
        "NameTypeName", "NameBasionym", "NameBasedOn", "NameConservedAgainst", _
        "NameHomonymOf", "NameReplacementFor", "NameParent", "NamePreferred", "NameBlocking"})

    Private LinkableNameRefColumns As List(Of String) = New List(Of String)(New String() {"NamePublishedIn"})

    Private HiddenNameColumns As List(Of String) = New List(Of String)(New String() { _
        "NameRank", "NameTypeNameFk", "NameBasionymFk", "NameBasedOnFk", "NameConservedAgainstFk", _
        "NameHomonymOfFk", "NameReplacementForFk", "NameReferenceFk", "NameParentFk", "NamePreferredFk", "NameBlockingFk", _
        "NameFullFormatted", "NamePreferredFormatted", "NameTypeNameFormatted", "NameBasionymFormatted", "NameBasedOnFormatted", _
        "NameConservedAgainstFormatted", "NameHomonymOfFormatted", "NameReplacementForFormatted", "NameBlockingFormatted"})

    Private HiddenRefColumns As List(Of String) = New List(Of String)(New String() { _
        ""})

    Private LinkableRefColumns As List(Of String) = New List(Of String)(New String() { _
        ""})

    Private EditableRefColumns As List(Of String) = New List(Of String)(New String() { _
        "RISType", "RISTitle", "RISAuthors", "RISDate", "RISNotes", "RISKeywords", "RISStartPage", _
        "RISEndPage", "RISJournalName", "RISStandardAbbreviation", "RISVolume", "RISIssue", _
        "RISCityOfPublication", "RISPublisher", "RISSNNumber", "RISWebUrl", "RISTitle2", "RISTitle3", _
        "RISAuthors2", "RISAuthors3", "RISPk"})

    Public Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        'NameLiteratureBusinessRules.BRNameDetails.s_ConnectionString = Configuration.ConfigurationManager.ConnectionStrings.Item("compositae").ConnectionString
        'LcClasses.LcNameLiteratureInterface.IsWebService = False
        'LcClasses.LcNameLiteratureInterface.EnableConnect = True

    End Sub

#Region "Load / Close / Save"

    Private Sub IntegratorForm_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        ChecklistGlobal.Init()

        'login
        Dim login As New LogonForm
        If login.ShowDialog = Windows.Forms.DialogResult.OK Then
            SessionState.CurrentUser = login.TheUser

            ReferenceHistory.Add(ClearId.ToString, "Clear")
            ReferenceHistory.Add(BrowseId.ToString, "Browse...")

            NameSelector1.SetSearchFields(New String() {"NameFull", "NameCanonical", "NameAuthors", "NameRank", "NameParent", "NamePreferred", "ProviderNameFull", "ProviderNameAuthors"})

            OtherDataCtrl1.Initialise()

            'resize to screen
            Me.Size = New Size(My.Computer.Screen.Bounds.Width - 30, My.Computer.Screen.Bounds.Height - 50)
            Me.CenterToScreen()

            SaveButton.Enabled = False
            saveWithAttButton.Enabled = False
            CncButton.Enabled = False
            SaveEditsToolStripMenuItem.Enabled = False


            NameSelector1.Select()

            'Dim pn As ProviderName = NameData.GetProviderName(710412)

            'BrProviderNames.MatchAndUpdateProviderName(pn)

        Else
            Me.Close()
        End If
    End Sub

    Private Sub IntegratorForm_Shown(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Shown
        Windows.Forms.Cursor.Current = Cursors.WaitCursor

        IntegratorControls.FormSettings.Settings = IntegratorControls.FormSettings.Settings.LoadSettings()
        If IntegratorControls.FormSettings.Settings Is Nothing Then IntegratorControls.FormSettings.Settings = New IntegratorControls.UserSetting

        Refresh()

        'load chached variables?
        RankData.GetRanks()
        Dim tmp As List(Of NameMapping) = BrProviderNames.NameMappings

        Windows.Forms.Cursor.Current = Cursors.Default
    End Sub

    Private Sub IntegratorForm_FormClosing(ByVal sender As Object, ByVal e As System.Windows.Forms.FormClosingEventArgs) Handles Me.FormClosing
        If Not Save(True) Then
            If PartialSave Then
                MsgBox("Failed to completely save the changes.  The current details have been reloaded.  The consensus data may need refreshing.")

                Windows.Forms.Cursor.Current = Cursors.WaitCursor
                If CurrentName IsNot Nothing Then RefreshNameScreen(CurrentName("NameGuid").ToString, False)
                If CurrentReference IsNot Nothing Then RefreshRefScreen(CurrentReference("ReferenceGuid").ToString)
                OtherDataCtrl1.Initialise()
                GetProviders()
                Windows.Forms.Cursor.Current = Cursors.Default
            Else
                MsgBox("Failed to save data")
            End If
            e.Cancel = True
        Else
            If IntegratorControls.FormSettings.Settings IsNot Nothing Then IntegratorControls.FormSettings.Settings.SaveSettings()
        End If
    End Sub

    Private Sub ExitButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExitButton.Click
        If Save(True) Then
            Me.Close()
        Else
            If PartialSave Then
                MsgBox("Failed to completely save the changes.  The current details have been reloaded.  The consensus data may need refreshing.")

                Windows.Forms.Cursor.Current = Cursors.WaitCursor
                If CurrentName IsNot Nothing Then RefreshNameScreen(CurrentName("NameGuid").ToString, False)
                If CurrentReference IsNot Nothing Then RefreshRefScreen(CurrentReference("ReferenceGuid").ToString)
                OtherDataCtrl1.Initialise()
                GetProviders()
                Windows.Forms.Cursor.Current = Cursors.Default
            Else
                MsgBox("Failed to save data")
            End If
        End If
    End Sub

    Private Function Save(ByVal prompt As Boolean) As Boolean
        Dim ok As Boolean = True

        'save?
        If HasChanges() Then
            Dim res As MsgBoxResult = MsgBoxResult.Yes
            If prompt Then res = MsgBox("Do you want to save your changes?", MsgBoxStyle.YesNoCancel, "Save")
            If res = MsgBoxResult.Yes Then
                Windows.Forms.Cursor.Current = Cursors.WaitCursor
                If TabControl1.SelectedIndex = 0 Then
                    ok = SaveName()
                ElseIf TabControl1.SelectedIndex = 1 Then
                    ok = SaveReference()
                ElseIf TabControl1.SelectedIndex = 2 Then
                    ok = OtherDataCtrl1.DoSave(False)
                ElseIf TabControl1.SelectedIndex = 3 Then
                    ok = SaveProviders()
                End If
                SaveButton.Enabled = Not ok
                saveWithAttButton.Enabled = Not ok
                CncButton.Enabled = Not ok
                SaveEditsToolStripMenuItem.Enabled = Not ok
                RefChanged = False
                Windows.Forms.Cursor.Current = Cursors.Default
            ElseIf res = MsgBoxResult.Cancel Then
                ok = False
            Else
                SaveButton.Enabled = Not ok
                saveWithAttButton.Enabled = Not ok
                CncButton.Enabled = Not ok
                SaveEditsToolStripMenuItem.Enabled = Not ok
                SetNoChanges()
            End If
        End If

        Return ok
    End Function

    Private Sub SetNoChanges()
        If TabControl1.SelectedIndex = 0 Then
            Dim dv As DataView = NameDetailsGrid.DataSource
            If dv IsNot Nothing Then
                Dim dt As DataTable = dv.Table
                dt.RejectChanges()
            End If
            ConceptDetailsTable.RejectChanges()
        ElseIf TabControl1.SelectedIndex = 1 Then
            Dim dv As DataView = RefDetailsGrid.DataSource
            If dv IsNot Nothing Then
                Dim dt As DataTable = dv.Table
                dt.RejectChanges()
            End If
            RefChanged = False
        ElseIf TabControl1.SelectedIndex = 2 Then
            OtherDataCtrl1.Initialise()
        ElseIf TabControl1.SelectedIndex = 3 Then
            GetProviders()
        End If

    End Sub
    Private Function HasChanges() As Boolean
        Try
            If TabControl1.SelectedIndex = 0 Then
                'end edits
                NameDetailsGrid.FinishEditing()
                ConceptsGrid.FinishEditing()
                Dim row As Integer = NameDetailsGrid.Row
                Dim col As Integer = NameDetailsGrid.Col
                Dim concRow As Integer = ConceptsGrid.Row
                Dim concCol As Integer = ConceptsGrid.Col
                If NameDetailsGrid.Cols.Count > 0 AndAlso NameDetailsGrid.Rows.Count > 0 Then
                    NameDetailsGrid.Col = 0 'force update
                    If NameDetailsGrid.Rows.Count > 1 Then NameDetailsGrid.Row = 1
                End If
                If ConceptsGrid.Cols.Count > 0 AndAlso ConceptsGrid.Rows.Count > 0 Then
                    ConceptsGrid.Col = 0 'force update
                    If ConceptsGrid.Rows.Count > 1 Then ConceptsGrid.Row = 1
                End If

                'get changes
                Dim dv As DataView = NameDetailsGrid.DataSource
                If dv Is Nothing Then Return False
                Dim changes As DataTable = dv.Table.GetChanges()

                Dim ch As DataTable = ConceptDetailsTable.GetChanges()

                'return to row/col
                If row >= 0 AndAlso col >= 0 Then
                    NameDetailsGrid.Row = row
                    NameDetailsGrid.Col = col
                End If

                If concRow >= 0 AndAlso concCol >= 0 Then
                    ConceptsGrid.Row = concRow
                    ConceptsGrid.Col = concCol
                End If

                Dim hnc As Boolean = (changes IsNot Nothing AndAlso changes.Rows.Count > 0)
                Dim hcc As Boolean = (ch IsNot Nothing AndAlso ch.Rows.Count > 0)

                Dim othCh As DataTable = Nothing
                If OtherDataDs IsNot Nothing Then othCh = OtherDataDs.GetChanges

                'name details change or concept change
                Return (hnc Or hcc Or othCh IsNot Nothing)
            ElseIf TabControl1.SelectedIndex = 1 Then
                'force update
                RefDetailsGrid.FinishEditing()
                Dim refRow As Integer = RefDetailsGrid.Row
                Dim refCol As Integer = RefDetailsGrid.Col
                If RefDetailsGrid.Cols.Count > 0 Then
                    RefDetailsGrid.Col = 0
                End If
                If RefDetailsGrid.Rows.Count > 1 Then
                    If refRow = 1 And RefDetailsGrid.Rows.Count > 2 Then
                        RefDetailsGrid.Row = 2
                    Else
                        RefDetailsGrid.Row = 1
                    End If
                End If

                Dim dv As DataView = RefDetailsGrid.DataSource
                If dv Is Nothing Then Return False
                Dim dt As DataTable = dv.Table

                Dim changes As DataTable = dt.GetChanges()

                If refRow >= 0 AndAlso refCol >= 0 Then
                    RefDetailsGrid.Select(refRow, refCol)
                End If


                Return ((changes IsNot Nothing AndAlso changes.Rows.Count > 0) Or RefChanged)
            ElseIf TabControl1.SelectedIndex = 2 Then

                Return OtherDataCtrl1.IsDirty
            ElseIf TabControl1.SelectedIndex = 3 Then

                Return (ProviderDs.GetChanges IsNot Nothing)
            End If

        Catch ex As Exception
            ChecklistException.LogError(ex)
        End Try

        Return False
    End Function

    Private Function SaveProviders() As Boolean
        Dim ok As Boolean = True

        Try
            Dim ch As DataSet = ProviderDs.GetChanges
            If ch IsNot Nothing AndAlso ch.Tables.Count > 0 Then
                For Each row As DataRow In ch.Tables(0).Rows
                    If row.RowState = DataRowState.Deleted Then
                        If Not row("ProviderPk", DataRowVersion.Original) Is DBNull.Value Then
                            Dim pk As Integer = row("ProviderPk", DataRowVersion.Original)
                            If pk > 0 Then
                                ChecklistDataAccess.ProviderData.DeleteProvider(pk)
                            End If
                        End If
                    Else
                        If row.IsNull("ProviderPk") Then row("ProviderPk") = -1
                        Dim p As New Provider(row)
                        ChecklistDataAccess.ProviderData.InsertUpdateProvider(p, SessionState.CurrentUser.Login)
                    End If
                Next
            End If

        Catch ex As Exception
            ChecklistException.LogError(ex)
            ok = False
        End Try

        Return ok
    End Function

    Private Function SaveName() As Boolean
        Dim ok As Boolean = True
        PartialSave = False
        If NameDetailsGrid.DataSource IsNot Nothing Then
            Try
                'insert/update system edit provider name
                Dim dv As DataView = NameDetailsGrid.DataSource
                Dim changes As DataTable = dv.Table.GetChanges()

                Dim upi As ProviderImport = BrUser.GetSystemProviderImport()
                Dim pn As ProviderName
                If changes IsNot Nothing Then
                    For Each pnRow As DataRow In ProviderNameRecords.Tables(0).Rows
                        If pnRow("ProviderIsEditor").ToString = Boolean.TrueString AndAlso pnRow("ProviderPk") = upi.ProviderImportProviderFk Then
                            pn = New ProviderName(pnRow, pnRow("PNPk").ToString, True)
                            Exit For
                        End If
                    Next

                    If pn Is Nothing Then
                        pn = New ProviderName
                        pn.PNNameId = Guid.NewGuid.ToString
                    End If

                    'remove <null>,<none> values
                    For Each r As DataRow In changes.Rows
                        If r("Value").ToString = "<null>" Or r("Value").ToString = "<none>" Then r("Value") = DBNull.Value
                    Next

                    If pn IsNot Nothing Then pn.UpdateFieldsFromTable(changes, BrProviderNames.NameMappings)

                    BrProviderNames.InsertUpdateSystemProviderName(CurrentName("NameGuid").ToString, pn)

                    PartialSave = True

                    'update field status, parent and preferred
                    For Each r As DataRow In changes.Rows
                        Dim field As String = NameMapping.SourceColumnNameOfDest(BrProviderNames.NameMappings, r("Field").ToString)
                        If r("Field").ToString = "NameLSID" Then field = "PNPk"
                        If r("Field").ToString = "NameParent" Then field = "PNParent"
                        If r("Field").ToString = "NamePreferred" Then field = "PNPreferred"
                        Dim statRow As DataRow = FieldStatusData.GetProviderNameFieldStatus(FieldStatusDs, field)
                        Dim st As Integer = -1
                        If Not r.IsNull("Status") Then st = r("Status")
                        If statRow IsNot Nothing Then
                            NameData.InsertUpdateFieldStatus(pn.Id, statRow("FieldStatusIdentifierFk"), st, SessionState.CurrentUser.Login)
                        Else
                            NameData.InsertFieldStatus(pn.Id, "tblProviderName", field, st, SessionState.CurrentUser.Login)
                        End If

                        If r("Field").ToString = "NameRankFk" Then TreeInvalid = True

                        'special case for parent and preferred, as they are concepts
                        If r("Field").ToString = "NameParent" Then
                            TreeInvalid = True
                            BrProviderConcepts.InsertUpdateSystemProviderConcept(CurrentName("NameGuid").ToString, GetNameGridValue("NameParentFk").ToString, ParentRelationshipFk, Nothing)
                        End If
                        If r("Field").ToString = "NamePreferred" Then
                            BrProviderConcepts.InsertUpdateSystemProviderConcept(CurrentName("NameGuid").ToString, GetNameGridValue("NamePreferredFk").ToString, PreferredRelationshipFk, Nothing)
                            BrNames.UpdateNamesWithSameBasionym(CurrentName("NameGuid"), GetNameGridValue("NamePreferredFk").ToString, Nothing)
                        End If
                    Next
                End If

                'insert provider concepts?
                Dim cc As DataTable = ConceptDetailsTable.GetChanges()
                If cc IsNot Nothing Then
                    For Each r As DataRow In cc.Rows
                        'compare to original row and update system record with changed vals

                        If r("ConceptToName1Fk") Is Nothing Then
                            MsgBox("ConceptNameTo must be set")
                            Return False
                        End If
                        If r("ConceptRelationshipRelationshipFk") Is Nothing Then
                            MsgBox("ConceptRelationship must be set")
                            Return False
                        End If

                        'get existing system concept?
                        Dim accToFk As String
                        If Not r.IsNull("ConceptAccordingToFk") Then accToFk = r("ConceptAccordingToFk").ToString
                        Dim pc As ProviderConcept = ConceptData.GetSystemProviderConcept(upi.IdAsInt, r("ConceptName1Fk").ToString(), accToFk)

                        If pc Is Nothing Then
                            pc = New ProviderConcept
                            pc.PCConceptId = Guid.NewGuid.ToString()
                            pc.PCLinkStatus = LinkStatus.Inserted.ToString
                        End If

                        Dim existingCRGuid As string = r("ConceptRelationshipGuid").ToString
                        If r("ConceptRelationshipGuid") Is Nothing Or r("ConceptRelationshipGuid") Is DBNull.Value Then r("ConceptRelationshipGuid") = Guid.NewGuid.ToString()

                        'get existing system conceptTo
                        Dim pcTo As ProviderConcept = ConceptData.GetSystemProviderConcept(upi.IdAsInt, r("ConceptToName1Fk").ToString(), accToFk)

                        If pcTo Is Nothing Then
                            pcTo = New ProviderConcept
                            pcTo.PCConceptId = Guid.NewGuid.ToString()
                            pcTo.PCLinkStatus = LinkStatus.Inserted.ToString
                        End If

                        pc.PCName1 = r("ConceptName1").ToString
                        pcTo.PCName1 = r("ConceptToName1").ToString
                        pc.PCAccordingTo = r("ConceptAccordingTo").ToString
                        pcTo.PCAccordingTo = r("ConceptAccordingTo").ToString

                        'get existing system conceptRel
                        Dim pcr As ProviderConceptRelationship = ConceptData.GetSystemProviderConceptRelationship _
                            (upi.IdAsInt, pc.PCConceptId, pcTo.PCConceptId, r("ConceptRelationshipRelationshipFk"))

                        If pcr Is Nothing Then
                            pcr = New ProviderConceptRelationship
                            pcr.PCRConcept1Id = pc.PCConceptId
                            pcr.PCRConcept2Id = pcTo.PCConceptId
                            pcr.PCRLinkStatus = LinkStatus.Inserted.ToString()
                            pcr.PCRProviderImportFk = upi.IdAsInt
                        End If

                        pcr.PCRRelationshipFk = r("ConceptRelationshipRelationshipFk") 'new editors provider concept must be set to this type of relationship
                        pcr.PCRRelationship = r("ConceptRelationshipRelationship").ToString


                        'update values if different
                        Dim originalRow As DataRow = GetConceptRow(ConceptRelRecords.Tables(0), r("ConceptRelationshipGuid").ToString())
                        If originalRow IsNot Nothing Then
                            If Not (r.IsNull("ConceptRelationshipHybridOrder") AndAlso originalRow.IsNull("ConceptRelationshipHybridOrder")) Then
                                If (Not r.IsNull("ConceptRelationshipHybridOrder") AndAlso originalRow.IsNull("ConceptRelationshipHybridOrder")) OrElse _
                                    (Not originalRow.IsNull("ConceptRelationshipHybridOrder") AndAlso r.IsNull("ConceptRelationshipHybridOrder")) OrElse _
                                    (originalRow("ConceptRelationshipHybridOrder") <> r("ConceptRelationshipHybridOrder")) Then
                                    pcr.PCRHybridOrder = r("ConceptRelationshipHybridOrder").ToString
                                End If
                            End If
                        End If

                        If pn Is Nothing Then pn = NameData.GetSystemProviderNameForName(r("ConceptName1Fk").ToString)

                        Dim pn2 As ProviderName
                        If r("ConceptToName1Fk").ToString = r("ConceptName1Fk").ToString Then
                            pn2 = pn
                        Else
                            pn2 = NameData.GetSystemProviderNameForName(r("ConceptToName1Fk").ToString)
                        End If
                        Dim pr As ProviderReference = ReferenceData.GetSystemProviderRefForRef(r("ConceptAccordingToFk").ToString)


                        BrProviderConcepts.InsertUpdateSystemProviderConcept(existingCRGuid, pc, pcTo, pcr, CurrentName("NameGuid"), pn, r("ConceptToName1Fk").ToString, pn2, r("ConceptAccordingToFk").ToString, pr)

                        If pcr.PCRRelationshipFk = ParentRelationshipFk Then TreeInvalid = True
                        If pcr.PCRRelationshipFk = PreferredRelationshipFk Then BrNames.UpdateNamesWithSameBasionym(CurrentName("NameGuid"), r("ConceptToName1Fk"), r("ConceptAccordingToFk"))
                    Next
                End If

                If OtherDataDs IsNot Nothing Then
                    Dim ch As DataTable = OtherDataDs.GetChanges
                    If ch IsNot Nothing Then
                        BrOtherData.UpdateOtherDataStandrdOutput(ch)
                        For Each row As DataRow In ch.Rows
                            OtherData.UpdateStandardOutputUseForConsensus(row, SessionState.CurrentUser.Login)
                        Next
                    End If
                End If

                PartialSave = False
            Catch ex As Exception
                ChecklistException.LogError(ex)
                ok = False
            End Try
        End If
        Return ok
    End Function

    Private Function GetConceptRow(ByVal table As DataTable, ByVal conceptRelGuid As String) As DataRow
        For Each r As DataRow In table.Rows
            If r("ConceptRelationshipGuid").ToString = conceptRelGuid Then
                Return r
            End If
        Next
        Return Nothing
    End Function

    Private Function SaveReference() As Boolean
        Dim ok As Boolean = True
        PartialSave = False
        If RefDetailsGrid.DataSource IsNot Nothing Then
            Try

                'insert/update system edit provider name
                Dim dv As DataView = RefDetailsGrid.DataSource
                Dim changes As DataTable = dv.Table.GetChanges()

                Dim pr As ProviderReference
                Dim ris As ProviderRIS
                Dim doUpdate As Boolean = False

                Dim upi As ProviderImport = BrUser.GetSystemProviderImport()
                For Each prRow As DataRow In ProviderRefRecords.Tables(0).Rows
                    If prRow("ProviderIsEditor").ToString = Boolean.TrueString AndAlso prRow("ProviderPk") = upi.ProviderImportProviderFk Then

                        pr = New ProviderReference(prRow, prRow("PRPk").ToString)
                        Exit For
                    End If
                Next

                If pr Is Nothing Then
                    pr = New ProviderReference
                    pr.PRReferenceId = Guid.NewGuid.ToString
                End If

                If changes IsNot Nothing AndAlso CurrentReferenceRIS IsNot Nothing Then
                    doUpdate = True

                    'remove <null>,<none> values 
                    For Each r As DataRow In changes.Rows
                        If r("Value").ToString = "<null>" Or r("Value").ToString = "<none>" Then r("Value") = DBNull.Value
                    Next

                    ris = New ProviderRIS
                    'get existing system RIS
                    For Each risRow As DataRow In ProviderRISRecords.Tables(0).Rows
                        If risRow("ProviderIsEditor").ToString = Boolean.TrueString AndAlso risRow("ProviderPk") = upi.ProviderImportProviderFk Then
                            ris = New ProviderRIS(risRow, risRow("PRISPk"))
                            'ris.PRISProviderReferencefk = -1 'reset so new prov ref is used for id
                            Exit For
                        End If
                    Next

                    ris.UpdateFieldsFromTable(changes, BrProviderReferences.RISMappings)
                Else

                    'update ref citation?
                    If (pr.PRCitation Is Nothing OrElse pr.PRCitation.ToLower <> RefCitationText.Text.ToLower) Or _
                        (pr.PRFullCitation Is Nothing OrElse pr.PRFullCitation.ToLower <> FullCitationText.Text.ToLower) Then
                        If RefChanged Then
                            pr.PRCitation = RefCitationText.Text
                            pr.PRFullCitation = FullCitationText.Text
                            doUpdate = True
                        End If
                    End If
                End If

                If doUpdate Then

                    BrProviderReferences.InsertUpdateSystemProviderReference(CurrentReference("ReferenceGuid").ToString, pr, ris)

                    PartialSave = True

                    'update field status
                    If ris IsNot Nothing Then
                        For Each r As DataRow In changes.Rows
                            Dim field As String = RISMapping.SourceColumnNameOfDest(BrProviderReferences.RISMappings, r("Field").ToString)
                            If r("Field").ToString = "RISPk" Then field = "PRISPk"
                            Dim statRow As DataRow = FieldStatusData.GetProviderReferenceFieldStatus(FieldStatusDs, field)
                            Dim st As Integer = -1
                            If Not r.IsNull("Status") Then st = r("Status")
                            If statRow IsNot Nothing Then
                                NameData.InsertUpdateFieldStatus(ris.Id, statRow("FieldStatusIdentifierFk"), st, SessionState.CurrentUser.Login)
                            Else
                                NameData.InsertFieldStatus(ris.Id, "tblProviderRIS", field, st, SessionState.CurrentUser.Login)
                            End If
                        Next
                    End If

                End If

                PartialSave = False
            Catch ex As Exception
                ok = False
            End Try
        End If

        Return ok
    End Function

    Private Sub ClearNameDetails()
        NameDetailsGrid.DataSource = Nothing
        ProviderNameGrid.DataSource = Nothing
        ProvConceptGrid.DataSource = Nothing
        ConceptsGrid.DataSource = Nothing
        OtherDataGrid.DataSource = Nothing
        CurrentName = Nothing
        OtherDataDs = Nothing
        FieldStatusDs = Nothing
        PartialSave = False
        SaveButton.Enabled = False
        saveWithAttButton.Enabled = False
        CncButton.Enabled = False
        SaveEditsToolStripMenuItem.Enabled = False
    End Sub

    Private Sub RefreshNameScreen(ByVal selNameId As String, ByVal refreshTree As Boolean)
        Dim row As Integer = NameDetailsGrid.Row
        Dim col As Integer = NameDetailsGrid.Col

        ClearNameDetails()
        If refreshTree Or TreeInvalid Then
            TreeInvalid = False
            NameSelector1.RefreshTree()
            If selNameId IsNot Nothing AndAlso selNameId.Length > 0 Then
                Try
                    NameSelector1.SelectNode(selNameId)
                Catch ex As Exception
                    ChecklistException.LogError(ex)
                End Try
            Else
                CurrentName = Nothing
                OtherDataDs = Nothing
            End If
        ElseIf selNameId IsNot Nothing Then
            GetName(selNameId)
            DisplayName(selNameId)
            NameSelector1.SelectedNameNode.Text = CurrentName("NameCanonical").ToString

            If row >= 0 AndAlso col >= 0 Then
                NameDetailsGrid.Row = row
                NameDetailsGrid.Col = col
            End If
        End If
    End Sub

    Private Sub ClearRefDetails()
        RefDetailsGrid.DataSource = Nothing
        ProviderRISGrid.DataSource = Nothing
        RefProviderGrid.DataSource = Nothing
        CurrentReference = Nothing
        CurrentReferenceRIS = Nothing
        FieldStatusDs = Nothing
        PartialSave = False
        SaveButton.Enabled = False
        SaveButton.Enabled = False
        CncButton.Enabled = False
        SaveEditsToolStripMenuItem.Enabled = False
        RefChanged = False
    End Sub

    Private Sub RefreshRefScreen(ByVal selRefId As String)
        Dim row As Integer = RefDetailsGrid.Row
        Dim col As Integer = RefDetailsGrid.Col

        ClearRefDetails()
        If selRefId IsNot Nothing Then
            GetReference(selRefId)
            DisplayReference(selRefId)
            RefChanged = False
            ReferenceSearch1.SelectReference(selRefId)

            If row >= 0 AndAlso col >= 0 Then
                RefDetailsGrid.Row = row
                RefDetailsGrid.Col = col
            End If
        End If
    End Sub
#End Region

#Region "Event Handlers"

    Private Sub IntegratorForm_KeyUp(ByVal sender As Object, ByVal e As System.Windows.Forms.KeyEventArgs) Handles MyBase.KeyUp
        If e.KeyCode = Keys.F3 Then
            SearchDockControl.Select()
        End If
    End Sub

    Private Sub IntegratorForm_KeyPress(ByVal sender As Object, ByVal e As System.Windows.Forms.KeyPressEventArgs) Handles Me.KeyPress
        Dim c As Char = e.KeyChar
    End Sub

    Private Sub SaveButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SaveButton.Click
        If Save(False) Then
            Windows.Forms.Cursor.Current = Cursors.WaitCursor
            If CurrentName IsNot Nothing Then RefreshNameScreen(CurrentName("NameGuid").ToString, False)
            If CurrentReference IsNot Nothing Then RefreshRefScreen(CurrentReference("ReferenceGuid").ToString)
            OtherDataCtrl1.Initialise()
            GetProviders()
            Windows.Forms.Cursor.Current = Cursors.Default
        Else
            If PartialSave Then
                MsgBox("Failed to completely save the changes.  The current details have been reloaded.  The consensus data may need refreshing.")

                Windows.Forms.Cursor.Current = Cursors.WaitCursor
                If CurrentName IsNot Nothing Then RefreshNameScreen(CurrentName("NameGuid").ToString, False)
                If CurrentReference IsNot Nothing Then RefreshRefScreen(CurrentReference("ReferenceGuid").ToString)
                OtherDataCtrl1.Initialise()
                GetProviders()
                Windows.Forms.Cursor.Current = Cursors.Default
            Else
                MsgBox("Failed to save data")
            End If
        End If
    End Sub

    Private Sub SaveEditsToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SaveEditsToolStripMenuItem.Click
        If Save(False) Then
            Windows.Forms.Cursor.Current = Cursors.WaitCursor
            If CurrentName IsNot Nothing Then RefreshNameScreen(CurrentName("NameGuid").ToString, False)
            If CurrentReference IsNot Nothing Then RefreshRefScreen(CurrentReference("ReferenceGuid").ToString)
            OtherDataCtrl1.Initialise()
            GetProviders()
            Windows.Forms.Cursor.Current = Cursors.Default
        Else
            If PartialSave Then
                MsgBox("Failed to completely save the changes.  The current details have been reloaded.  The consensus data may need refreshing.")

                Windows.Forms.Cursor.Current = Cursors.WaitCursor
                If CurrentName IsNot Nothing Then RefreshNameScreen(CurrentName("NameGuid").ToString, False)
                If CurrentReference IsNot Nothing Then RefreshRefScreen(CurrentReference("ReferenceGuid").ToString)
                OtherDataCtrl1.Initialise()
                GetProviders()
                Windows.Forms.Cursor.Current = Cursors.Default
            Else
                MsgBox("Failed to save data")
            End If
        End If
    End Sub

    Private Sub CncButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CncButton.Click
        If CurrentName IsNot Nothing Then RefreshNameScreen(CurrentName("NameGuid").ToString, False)
        If CurrentReference IsNot Nothing Then RefreshRefScreen(CurrentReference("ReferenceGuid").ToString)
        OtherDataCtrl1.Initialise()
        GetProviders()
    End Sub

    '-------------------------
    'Menus
    Private Sub ExitToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExitToolStripMenuItem.Click
        If Save(True) Then
            Me.Close()
        Else
            If PartialSave Then
                MsgBox("Failed to completely save the changes.  The current details have been reloaded.  The consensus data may need refreshing.")

                Windows.Forms.Cursor.Current = Cursors.WaitCursor
                If CurrentName IsNot Nothing Then RefreshNameScreen(CurrentName("NameGuid").ToString, False)
                If CurrentReference IsNot Nothing Then RefreshRefScreen(CurrentReference("ReferenceGuid").ToString)
                OtherDataCtrl1.Initialise()
                GetProviders()
                Windows.Forms.Cursor.Current = Cursors.Default
            Else
                MsgBox("Failed to save data")
            End If
        End If
    End Sub

    Private Sub ImportToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ImportToolStripMenuItem.Click
        If Save(True) Then
            Dim impForm As New ImportForm
            impForm.ShowDialog()

            Windows.Forms.Cursor.Current = Cursors.WaitCursor
            If CurrentName IsNot Nothing Then RefreshNameScreen(CurrentName("NameGuid").ToString, False)
            If CurrentReference IsNot Nothing Then RefreshRefScreen(CurrentReference("ReferenceGuid").ToString)
            OtherDataCtrl1.Initialise()
            GetProviders()
            Windows.Forms.Cursor.Current = Cursors.Default
        Else
            If PartialSave Then
                MsgBox("Failed to completely save the changes.  The current details have been reloaded.  The consensus data may need refreshing.")

                Windows.Forms.Cursor.Current = Cursors.WaitCursor
                If CurrentName IsNot Nothing Then RefreshNameScreen(CurrentName("NameGuid").ToString, False)
                If CurrentReference IsNot Nothing Then RefreshRefScreen(CurrentReference("ReferenceGuid").ToString)
                OtherDataCtrl1.Initialise()
                GetProviders()
                Windows.Forms.Cursor.Current = Cursors.Default
            Else
                MsgBox("Failed to save data")
            End If
        End If
    End Sub

    Private Sub RunIntegrationToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RunIntegrationToolStripMenuItem.Click
        If Save(True) Then
            Dim ipf As New IntegratorControls.IntegrationProcessForm
            ipf.ShowDialog()

            Windows.Forms.Cursor.Current = Cursors.WaitCursor
            If CurrentName IsNot Nothing Then RefreshNameScreen(CurrentName("NameGuid").ToString, False)
            If CurrentReference IsNot Nothing Then RefreshRefScreen(CurrentReference("ReferenceGuid").ToString)
            OtherDataCtrl1.Initialise()
            GetProviders()
            Windows.Forms.Cursor.Current = Cursors.Default
        Else
            If PartialSave Then
                MsgBox("Failed to completely save the changes.  The current details have been reloaded.  The consensus data may need refreshing.")

                Windows.Forms.Cursor.Current = Cursors.WaitCursor
                If CurrentName IsNot Nothing Then RefreshNameScreen(CurrentName("NameGuid").ToString, False)
                If CurrentReference IsNot Nothing Then RefreshRefScreen(CurrentReference("ReferenceGuid").ToString)
                OtherDataCtrl1.Initialise()
                GetProviders()
                Windows.Forms.Cursor.Current = Cursors.Default
            Else
                MsgBox("Failed to save data")
            End If
        End If
    End Sub

    Private Sub ViewLogToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ViewLogToolStripMenuItem.Click
        Try
            Process.Start("eventvwr.exe")
        Catch ex As Exception
            ChecklistException.LogError(ex)
            MsgBox("Failed to lauch Event Log Viewer")
        End Try
    End Sub


    '----------------------
    'Tab control
    Private Sub TabControl1_Deselecting(ByVal sender As Object, ByVal e As System.Windows.Forms.TabControlCancelEventArgs) Handles TabControl1.Deselecting
        If Not Save(True) Then
            If PartialSave Then
                MsgBox("Failed to completely save the changes.  The current details have been reloaded.  The consensus data may need refreshing.")

                Windows.Forms.Cursor.Current = Cursors.WaitCursor
                If CurrentName IsNot Nothing Then RefreshNameScreen(CurrentName("NameGuid").ToString, False)
                If CurrentReference IsNot Nothing Then RefreshRefScreen(CurrentReference("ReferenceGuid").ToString)
                OtherDataCtrl1.Initialise()
                GetProviders()
                Windows.Forms.Cursor.Current = Cursors.Default
            Else
                MsgBox("Failed to save data")
            End If
            e.Cancel = True
        End If

    End Sub

    Private Sub TabControl1_KeyUp(ByVal sender As Object, ByVal e As System.Windows.Forms.KeyEventArgs) Handles TabControl1.KeyUp
        If e.KeyCode = Keys.F3 Then
            SearchDockControl.Select()
        ElseIf e.KeyCode = Keys.F4 Then
            RefDetailsDockControl.Select()
        ElseIf e.KeyCode = Keys.F5 Then
            ProvNameDockControl.Select()
        ElseIf e.KeyCode = Keys.F6 Then
            ConceptsDockControl.Select()
        ElseIf e.KeyCode = Keys.F7 Then
            ProvConceptsDockControl.Select()
        ElseIf e.KeyCode = Keys.S AndAlso e.Control Then
            If NameDetailsGrid.Focused Then
                ProviderNameGrid.Focus() 'force update
                NameDetailsGrid.Focus()
            ElseIf ConceptsGrid.Focused Then
                ProvConceptGrid.Focus()
                ConceptsGrid.Focus()
            End If
        End If
    End Sub

    Private Sub TabControl1_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles TabControl1.SelectedIndexChanged
        If TabControl1.SelectedIndex = 0 Then
            NameSelector1.Select()
            If LinkToName.Length > 0 Then
                NameSelector1.SelectNode(LinkToName)
                LinkToName = ""
            End If
        ElseIf TabControl1.SelectedIndex = 1 Then
            ReferenceSearch1.Focus()
            If LinkToRef.Length > 0 Then
                ReferenceSearch1.SelectReference(LinkToRef)
                LinkToRef = ""
            End If
        ElseIf TabControl1.SelectedIndex = 4 Then
            ReportsControl1.Focus()
        End If

    End Sub

    '--------------
    'Names
    Private Sub NameSelector1_selected(ByVal NameGuid As String, ByVal NameLSID As String) Handles NameSelector1.selected
        If Save(True) Then
            Try
                ClearNameDetails()
                GetName(NameGuid)
                DisplayName(NameGuid)
                NameBrowseHistory.Add(NameGuid)
            Catch ex As Exception
                ChecklistException.LogError(ex)
            End Try
        Else
            If PartialSave Then
                MsgBox("Failed to completely save the changes.  The current name details have been reloaded.  The consensus name may need refreshing.")

                If CurrentName IsNot Nothing Then RefreshNameScreen(CurrentName("NameGuid").ToString, False)
            Else
                MsgBox("Failed to save name")
                If CurrentName IsNot Nothing Then
                    NameSelector1.SelectNode(CurrentName("NameGuid").ToString, False)
                End If
            End If
        End If
    End Sub

    Private Sub NamesHideBlankCheckbox_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles NamesHideBlankFields.CheckedChanged
        If CurrentName IsNot Nothing Then
            Dim dv As DataView = NameDetailsGrid.DataSource
            If HideBlankFields() Then
                dv.RowFilter = "Value is not null"
            Else
                dv.RowFilter = ""
            End If
            SetNameDetailsGridFormatting()
        End If
    End Sub

    Private Sub NameDetailsGrid_CellButtonClick(ByVal sender As Object, ByVal e As C1.Win.C1FlexGrid.RowColEventArgs) Handles NameDetailsGrid.CellButtonClick
        If EditMode AndAlso NameDetailsGrid.Cols(NameDetailsGrid.Col).Name = "Value" Then 'value is clicked
            Dim r As Row = NameDetailsGrid.Rows(NameDetailsGrid.Row)
            If LinkableNameColumns.IndexOf(r("Field").ToString) <> -1 Then
                'has name link
                SelectNamePopup(r)

            ElseIf LinkableNameRefColumns.IndexOf(r("Field").ToString) <> -1 Then
                'reference link
                SelectReferencePopup(r)
            End If
        End If
    End Sub

    Private Sub NameDetailsGrid_Click(ByVal sender As Object, ByVal e As EventArgs) Handles NameDetailsGrid.Click
        If FinishingEdit Then
            FinishingEdit = False
        ElseIf NameDetailsGrid.Col > 0 AndAlso NameDetailsGrid.Cols(NameDetailsGrid.Col).Name = "Value" Then 'value is clicked
            Dim r As Row = NameDetailsGrid.Rows(NameDetailsGrid.Row)
            If LinkableNameColumns.IndexOf(r("Field").ToString) <> -1 Then
                'has name link
                If EditMode Then
                    SelectNamePopup(r)
                Else
                    GotoLink(NameDetailsGrid.Rows(NameDetailsGrid.Row)("LinkFk").ToString)
                End If

            ElseIf LinkableNameRefColumns.IndexOf(r("Field").ToString) <> -1 Then
                'reference link
                If EditMode Then
                    SelectReferencePopup(r)
                Else
                    GotoLink(NameDetailsGrid.Rows(NameDetailsGrid.Row)("LinkFk").ToString)
                End If
            End If

        End If
    End Sub

    Private Sub NameDetailsGrid_BeforeEdit(ByVal sender As Object, ByVal e As RowColEventArgs) Handles NameDetailsGrid.BeforeEdit
        If EditMode Then
            Try

                If (NameDetailsGrid.Cols(e.Col).Name <> "Value" And NameDetailsGrid.Cols(e.Col).Name <> "Status") OrElse _
                    (NameDetailsGrid.Rows(e.Row)("Field") IsNot Nothing AndAlso _
                    EditableNameColumns.IndexOf(NameDetailsGrid.Rows(e.Row)("Field").ToString) = -1 AndAlso _
                    LinkableNameColumns.IndexOf(NameDetailsGrid.Rows(e.Row)("Field").ToString) = -1) Then

                    'allow edit on namefull, nameauthors and namelsid for Status column only

                    If NameDetailsGrid.Rows(e.Row)("Field") Is Nothing Then
                        e.Cancel = True
                    ElseIf (NameDetailsGrid.Rows(e.Row)("Field").ToString <> "NameFull" And _
                        NameDetailsGrid.Rows(e.Row)("Field").ToString <> "NameLSID" And _
                        NameDetailsGrid.Rows(e.Row)("Field").ToString <> "NameAuthors") Or _
                        NameDetailsGrid.Cols(e.Col).Name <> "Status" Then

                        e.Cancel = True
                    End If

                End If
            Catch ex As Exception
                ChecklistException.LogError(ex)
            End Try
        End If
    End Sub

    Private Sub NameDetailsGrid_ChangeEdit(ByVal sender As Object, ByVal e As System.EventArgs) Handles NameDetailsGrid.ChangeEdit
        SaveButton.Enabled = True
        saveWithAttButton.Enabled = True
        CncButton.Enabled = True
        SaveEditsToolStripMenuItem.Enabled = True
    End Sub

    Private Sub NameDetailsGrid_AfterEdit(ByVal sender As Object, ByVal e As C1.Win.C1FlexGrid.RowColEventArgs) Handles NameDetailsGrid.AfterEdit
        If NameDetailsGrid.Cols(e.Col).Name = "Value" Then
            Dim name As String = NameDetailsGrid.Cols("Field")(e.Row)
            Dim link As String = ""
            Dim l As Object = NameDetailsGrid.Cols("LinkFk")(e.Row)
            If l IsNot Nothing Then link = l.ToString()

            If name = "NameRankFk" Then
                Dim rankPk As String = NameDetailsGrid.Cols("Value")(e.Row)
                If rankPk Is Nothing Then
                    NameDetailsGrid.Cols("Value")(e.Row) = DBNull.Value
                    UpdateNameGridValue("NameRank", DBNull.Value)
                Else
                    Try
                        Dim rnk As Rank = RankData.RankByPk(Integer.Parse(rankPk))
                        NameDetailsGrid.Cols("Value")(e.Row) = rnk.IdAsInt
                        UpdateNameGridValue("NameRank", rnk.Name)
                    Catch ex As Exception
                    End Try
                End If
            ElseIf name = "NamePublishedIn" Then
                Dim id As String = NameDetailsGrid.Rows(e.Row)("Value").ToString

                If id = BrowseId.ToString Then
                    If Not SelectReferencePopup(NameDetailsGrid.Rows(e.Row)) Then
                        'revert
                        Dim oldId As String = GetNameGridValue("NameReferenceFk").ToString
                        If oldId = Guid.Empty.ToString Then
                            NameDetailsGrid.Rows(e.Row)("Value") = "<none>"
                        ElseIf oldId.Length > 0 Then
                            NameDetailsGrid.Rows(e.Row)("Value") = ReferenceHistory(oldId).ToString
                        Else
                            NameDetailsGrid.Rows(e.Row)("Value") = "<null>"
                        End If
                    End If
                ElseIf id = ClearId.ToString Then
                    NameDetailsGrid.Rows(e.Row)("Value") = "<null>"
                    NameDetailsGrid.Rows(e.Row)("LinkFk") = Nothing
                    UpdateNameGridValue("NameReferenceFk", Nothing)
                Else
                    'set fk to id and value to name
                    UpdateNameGridValue("NameReferenceFk", id)

                    If id = Guid.Empty.ToString Then
                        NameDetailsGrid.Rows(e.Row)("Value") = "<none>"
                    ElseIf id.Length > 0 Then
                        NameDetailsGrid.Rows(e.Row)("Value") = ReferenceHistory(id).ToString
                    Else
                        NameDetailsGrid.Rows(e.Row)("Value") = "<null>"
                    End If
                End If
            ElseIf LinkableNameColumns.IndexOf(NameDetailsGrid.Rows(e.Row)("Field").ToString) <> -1 Then
                Dim id As String = NameDetailsGrid.Rows(e.Row)("Value").ToString

                If id = BrowseId.ToString Then
                    If Not SelectNamePopup(NameDetailsGrid.Rows(e.Row)) Then
                        Dim oldId As String = GetNameGridValue(name + "Fk").ToString
                        If oldId = Guid.Empty.ToString Then
                            NameDetailsGrid.Rows(e.Row)("Value") = "<none>"
                            NameDetailsGrid.Rows(e.Row)("LinkFk") = Nothing
                        ElseIf oldId.Length > 0 Then
                            Dim hName As String = NameDetailsGrid.Rows(e.Row)("Field").ToString + "History"
                            Dim hist As ListDictionary = NameHistory(hName)
                            NameDetailsGrid.Rows(e.Row)("Value") = hist(oldId).ToString
                            NameDetailsGrid.Rows(e.Row)("LinkFk") = "SelectName=" + oldId
                        Else
                            NameDetailsGrid.Rows(e.Row)("Value") = "<null>"
                            NameDetailsGrid.Rows(e.Row)("LinkFk") = Nothing
                        End If
                    End If
                ElseIf id = ClearId.ToString Then 'clear
                    NameDetailsGrid.Rows(e.Row)("Value") = "<null>"
                    NameDetailsGrid.Rows(e.Row)("LinkFk") = Nothing
                    UpdateNameGridValue(NameDetailsGrid.Rows(e.Row)("Field").ToString + "Fk", Nothing)
                ElseIf (id <> "<null>" AndAlso id <> "<none>") Then
                    'set fk to id and value to name
                    UpdateNameGridValue(NameDetailsGrid.Rows(e.Row)("Field").ToString + "Fk", id)

                    If id = Guid.Empty.ToString Then
                        NameDetailsGrid.Rows(e.Row)("Value") = "<none>"
                        NameDetailsGrid.Rows(e.Row)("LinkFk") = Nothing
                    ElseIf id.Length > 0 Then
                        Dim hName As String = NameDetailsGrid.Rows(e.Row)("Field").ToString + "History"
                        Dim hist As ListDictionary = NameHistory(hName)
                        NameDetailsGrid.Rows(e.Row)("Value") = hist(id).ToString
                        NameDetailsGrid.Rows(e.Row)("LinkFk") = "SelectName=" + id
                    Else
                        NameDetailsGrid.Rows(e.Row)("Value") = "<null>"
                        NameDetailsGrid.Rows(e.Row)("LinkFk") = Nothing
                    End If
                End If

            End If

            If name = "NameHomonymOf" Then
                Dim hoVal As String = GetNameGridValue(name + "Fk").ToString
                If hoVal.Length > 0 Then
                    UpdateNameGridValue("NameIllegitimate", True)
                End If
            End If

            SaveButton.Enabled = True
            saveWithAttButton.Enabled = True
            CncButton.Enabled = True
            SaveEditsToolStripMenuItem.Enabled = True
        End If
    End Sub

    Private Sub NameDetailsGrid_KeyDown(ByVal sender As Object, ByVal e As System.Windows.Forms.KeyEventArgs) Handles NameDetailsGrid.KeyDown
        If e.Control AndAlso e.KeyCode = Keys.C Then
            Clipboard.SetDataObject(NameDetailsGrid.Rows(NameDetailsGrid.Row)(NameDetailsGrid.Col).ToString)
        End If

        If EditMode And CurrentName IsNot Nothing Then
            If EditableNameColumns.IndexOf(NameDetailsGrid.Rows(NameDetailsGrid.Row)("Field").ToString) <> -1 Or _
                LinkableNameColumns.IndexOf(NameDetailsGrid.Rows(NameDetailsGrid.Row)("Field").ToString) <> -1 Then
                If e.Alt And e.KeyCode = Keys.D1 Then
                    NameDetailsGrid.Rows(NameDetailsGrid.Row)("Status") = 1
                    e.SuppressKeyPress = True
                    NameDetailsGrid.Focus()
                ElseIf e.Alt And e.KeyCode = Keys.D2 Then
                    NameDetailsGrid.Rows(NameDetailsGrid.Row)("Status") = 2
                    e.SuppressKeyPress = True
                    NameDetailsGrid.Focus()
                ElseIf e.Alt And e.KeyCode = Keys.D3 Then
                    NameDetailsGrid.Rows(NameDetailsGrid.Row)("Status") = 3
                    e.SuppressKeyPress = True
                    NameDetailsGrid.Focus()
                ElseIf e.Alt And e.KeyCode = Keys.D4 Then
                    NameDetailsGrid.Rows(NameDetailsGrid.Row)("Status") = 4
                    e.SuppressKeyPress = True
                    NameDetailsGrid.Focus()
                End If

                If e.SuppressKeyPress Then 'have handled tyhe key action, then we must have edited the data
                    SaveButton.Enabled = True
                    saveWithAttButton.Enabled = True
                    CncButton.Enabled = True
                    SaveEditsToolStripMenuItem.Enabled = True
                End If
            End If
        End If
    End Sub

    Private Sub NameDetailsGrid_ComboCloseUp(ByVal sender As Object, ByVal e As C1.Win.C1FlexGrid.RowColEventArgs) Handles NameDetailsGrid.ComboCloseUp
        FinishingEdit = True 'fudge to stop cell content click firing
    End Sub

    Private Sub NameDetailsGrid_RowColChange(ByVal sender As Object, ByVal e As System.EventArgs) Handles NameDetailsGrid.RowColChange
        If NameDetailsGrid.Row > 0 Then
            Try
                Dim link As String = NameDetailsGrid.Rows(NameDetailsGrid.Row)("LinkFk").ToString
                If link.StartsWith("SelectName") Then
                    Dim id As String = link.Substring(link.IndexOf("=") + 1)
                    Dim name As String = NameDetailsGrid.Rows(NameDetailsGrid.Row)("Value").ToString
                    If id.Length > 0 Then
                        Dim hName As String = NameDetailsGrid.Rows(NameDetailsGrid.Row)("Field").ToString + "History"
                        Dim hist As ListDictionary = NameHistory(hName)
                        If Not hist.Contains(id) Then hist.Add(id, name)
                    End If
                End If
            Catch ex As Exception
            End Try
        End If
    End Sub

    Private Sub ConceptsGrid_AfterAddRow(ByVal sender As Object, ByVal e As C1.Win.C1FlexGrid.RowColEventArgs) Handles ConceptsGrid.AfterAddRow
        If CurrentName IsNot Nothing Then
            ConceptsGrid.Rows(e.Row)("ConceptName1Fk") = CurrentName("NameGuid").ToString
            ConceptsGrid.Rows(e.Row)("ConceptName1") = CurrentName("NameFull").ToString
        End If
        UpdateNewConceptRowStyle()
    End Sub

    Private Sub RefreshTreeLink_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles RefreshTreeLink.LinkClicked
        If CurrentName IsNot Nothing Then
            RefreshNameScreen(CurrentName("NameGuid").ToString, True)
        Else
            RefreshNameScreen(Nothing, True)
        End If
    End Sub

    Private Sub ConceptsGrid_CellButtonClick(ByVal sender As Object, ByVal e As C1.Win.C1FlexGrid.RowColEventArgs) Handles ConceptsGrid.CellButtonClick
        If EditMode Then
            Dim r As Row = ConceptsGrid.Rows(ConceptsGrid.Row)
            If ConceptsGrid.Col = 9 Then
                'name link
                SelectConceptNamePopup(r)

            ElseIf ConceptsGrid.Col = 11 Then
                'reference link

            End If
        End If
    End Sub

    Private Sub ConceptsGrid_Click(ByVal sender As Object, ByVal e As EventArgs) Handles ConceptsGrid.Click
        If FinishingEdit Then
            FinishingEdit = False
        ElseIf ConceptsGrid.Col = 9 Then
            If EditMode Then
                SelectConceptNamePopup(ConceptsGrid.Rows(ConceptsGrid.Row))
            Else
                If ConceptsGrid.Rows(ConceptsGrid.Row)("ConceptToName1Fk") IsNot Nothing Then
                    GotoLink("SelectName=" + ConceptsGrid.Rows(ConceptsGrid.Row)("ConceptToName1Fk").ToString)
                End If
            End If

        ElseIf ConceptsGrid.Col = 11 Then
            'reference link
            If EditMode Then
                SelectConceptRefPopup(ConceptsGrid.Rows(ConceptsGrid.Row))
            Else
                If ConceptsGrid.Rows(ConceptsGrid.Row)("ConceptAccordingToFk") IsNot Nothing Then
                    GotoLink("SelectReference=" + ConceptsGrid.Rows(ConceptsGrid.Row)("ConceptAccordingToFk").ToString)
                End If
            End If
        End If

    End Sub

    Private Sub ConceptsGrid_BeforeEdit(ByVal sender As Object, ByVal e As RowColEventArgs) Handles ConceptsGrid.BeforeEdit
        If EditMode Then
            If e.Col <> 5 And e.Col <> 9 And e.Col <> 11 And e.Col <> 15 Then
                e.Cancel = True
            End If
            If ConceptsGrid.DataSource IsNot Nothing Then
                If e.Col = 5 And _
                    (ConceptsGrid.Rows(e.Row)("ConceptRelationshipGuid") IsNot Nothing And ConceptsGrid.Rows(e.Row)("ConceptRelationshipGuid") IsNot DBNull.Value) Then
                    e.Cancel = True
                End If
            End If
        End If
    End Sub

    Private Sub ConceptsGrid_ChangeEdit(ByVal sender As Object, ByVal e As System.EventArgs) Handles ConceptsGrid.ChangeEdit
        SaveButton.Enabled = True
        saveWithAttButton.Enabled = True
        CncButton.Enabled = True
        SaveEditsToolStripMenuItem.Enabled = True
    End Sub

    Private Sub ConceptsGrid_AfterEdit(ByVal sender As Object, ByVal e As C1.Win.C1FlexGrid.RowColEventArgs) Handles ConceptsGrid.AfterEdit
        If e.Col = 9 Then
            Dim id As String = ConceptsGrid.Rows(e.Row)("ConceptToName1").ToString

            If id = BrowseId.ToString Then
                If Not SelectConceptNamePopup(ConceptsGrid.Rows(e.Row)) Then
                    'revert
                    If ConceptsGrid.Rows(e.Row)("ConceptToName1Fk") IsNot Nothing Then
                        Dim hist As ListDictionary = NameHistory("ConceptName2History")
                        ConceptsGrid.Rows(e.Row)("ConceptToName1") = hist(ConceptsGrid.Rows(e.Row)("ConceptToName1Fk")).ToString
                    End If
                End If
            ElseIf id = ClearId.ToString Then 'clear
                ConceptsGrid.Rows(e.Row)("ConceptToName1") = "<null>"
                ConceptsGrid.Rows(e.Row)("ConceptToName1Fk") = Nothing
            ElseIf (id <> "<null>" AndAlso id <> "<none>") Then
                'set fk to id and value to name
                ConceptsGrid.Rows(e.Row)("ConceptToName1Fk") = id

                If id = Guid.Empty.ToString Then
                    ConceptsGrid.Rows(e.Row)("ConceptToName1") = "<none>"
                ElseIf id.Length > 0 Then
                    Dim hist As ListDictionary = NameHistory("ConceptName2History")
                    ConceptsGrid.Rows(e.Row)("ConceptToName1") = hist(id).ToString
                Else
                    ConceptsGrid.Rows(e.Row)("ConceptToName1") = "<null>"
                End If
            End If
        ElseIf e.Col = 5 Then
            Dim relPk As String = ConceptsGrid.Rows(e.Row)("ConceptRelationshipRelationship")
            If relPk Is Nothing Then
                ConceptsGrid.Rows(e.Row)("ConceptRelationshipRelationship") = DBNull.Value
                ConceptsGrid.Rows(e.Row)("ConceptRelationshipRelationshipFk") = DBNull.Value
            Else
                Try
                    Dim relSt As CellStyle = ConceptsGrid.Styles("RelStyle")
                    Dim fk As Integer = Integer.Parse(ConceptsGrid.Rows(e.Row)("ConceptRelationshipRelationship"))
                    ConceptsGrid.Rows(e.Row)("ConceptRelationshipRelationshipFk") = fk
                    ConceptsGrid.Rows(e.Row)("ConceptRelationshipRelationship") = relSt.DataMap.Item(fk)
                Catch ex As Exception
                End Try
            End If
        ElseIf e.Col = 11 Then
            Dim id As String = ConceptsGrid.Rows(e.Row)("ConceptAccordingTo").ToString

            If id = BrowseId.ToString Then
                If Not SelectConceptRefPopup(ConceptsGrid.Rows(e.Row)) Then
                    'revert
                    Dim oldId As String = ConceptsGrid.Rows(e.Row)("ConceptAccordingToFk").ToString
                    If oldId = Guid.Empty.ToString Then
                        ConceptsGrid.Rows(e.Row)("ConceptAccordingTo") = "<none>"
                    ElseIf oldId.Length > 0 Then
                        ConceptsGrid.Rows(e.Row)("ConceptAccordingto") = ReferenceHistory(oldId).ToString
                    Else
                        ConceptsGrid.Rows(e.Row)("ConceptAccordingTo") = "<null>"
                    End If
                End If
            ElseIf id = ClearId.ToString Then
                ConceptsGrid.Rows(e.Row)("ConceptAccordingTo") = "<null>"
                ConceptsGrid.Rows(e.Row)("ConceptAccordingToFk") = Nothing
            Else
                'set fk to id and value to name
                ConceptsGrid.Rows(e.Row)("ConceptAccordingToFk") = id

                If id = Guid.Empty.ToString Then
                    ConceptsGrid.Rows(e.Row)("ConceptAccordingTo") = "<none>"
                ElseIf id.Length > 0 Then
                    ConceptsGrid.Rows(e.Row)("ConceptAccordingto") = ReferenceHistory(id).ToString
                Else
                    ConceptsGrid.Rows(e.Row)("ConceptAccordingTo") = "<null>"
                End If
            End If
        End If
    End Sub

    Private Sub ConceptsGrid_KeyDown(ByVal sender As Object, ByVal e As System.Windows.Forms.KeyEventArgs) Handles ConceptsGrid.KeyDown
        If e.Control AndAlso e.KeyCode = Keys.C Then
            Clipboard.SetDataObject(ConceptsGrid.Rows(ConceptsGrid.Row)(ConceptsGrid.Col).ToString)
        End If
    End Sub

    Private Sub ConceptsGrid_ComboCloseUp(ByVal sender As Object, ByVal e As C1.Win.C1FlexGrid.RowColEventArgs) Handles ConceptsGrid.ComboCloseUp
        FinishingEdit = True 'fudge to stop cell content click firing
    End Sub

    Private Sub ConceptsGrid_RowColChange(ByVal sender As Object, ByVal e As System.EventArgs) Handles ConceptsGrid.RowColChange
        If ConceptsGrid.Row > 0 Then
            Try
                Dim id As String = ConceptsGrid.Rows(ConceptsGrid.Row)("ConceptToName1Fk").ToString
                Dim name As String = ConceptsGrid.Rows(ConceptsGrid.Row)("ConceptToName1").ToString
                If id.Length > 0 Then
                    Dim hist As ListDictionary = NameHistory("ConceptName2History")
                    If Not hist.Contains(id) Then hist.Add(id, name)
                End If

                id = ConceptsGrid.Rows(ConceptsGrid.Row)("ConceptAccordingToFk").ToString
                name = ConceptsGrid.Rows(ConceptsGrid.Row)("ConceptAccordingTo").ToString
                If id.Length > 0 Then
                    If Not ReferenceHistory.Contains(id) Then ReferenceHistory.Add(id, name)
                End If
            Catch ex As Exception
            End Try
        End If
    End Sub


    Private Sub ProvConceptGrid_CellContentClick(ByVal sender As Object, ByVal e As System.Windows.Forms.DataGridViewCellEventArgs) Handles ProvConceptGrid.CellContentClick
        'If e.ColumnIndex = 0 Then
        '    If Not Save(True) Then
        '        MsgBox("Failed to save name")
        '    Else
        '        DeprecateCurrentPrviderConcept(e.RowIndex)
        '    End If
        'End If
    End Sub

    Private Sub NamesProviderGrid_CellContentClick(ByVal sender As System.Object, ByVal e As System.Windows.Forms.DataGridViewCellEventArgs) Handles ProviderNameGrid.CellContentClick
        If e.ColumnIndex = 0 Then
            If Not Save(True) Then
                If PartialSave Then
                    MsgBox("Failed to completely save the changes.  The current name details have been reloaded.  The consensus name may need refreshing.")

                    If CurrentName IsNot Nothing Then RefreshNameScreen(CurrentName("NameGuid").ToString, False)
                Else
                    MsgBox("Failed to save name")
                End If
            Else
                SplitCurrentProviderName(e.RowIndex)
            End If
        ElseIf e.ColumnIndex = 1 Then
            If e.RowIndex > -1 AndAlso ProviderNameGrid.Rows(e.RowIndex).Cells("PNPk").Value IsNot Nothing Then
                Dim pnForm As New ProviderNameForm
                pnForm.PNPk = ProviderNameGrid.Rows(e.RowIndex).Cells("PNPk").Value
                pnForm.ShowDialog()
            End If
        End If
    End Sub

    Private Sub BackButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles BackButton.Click
        If NameBrowseHistory.Count > 1 Then 'go back to the one before the current name
            Dim nameId As String = NameBrowseHistory(NameBrowseHistory.Count - 2)
            NameBrowseHistory.RemoveRange(NameBrowseHistory.Count - 2, 2)
            NameSelector1.SelectNode(nameId)
        End If
    End Sub

    Private Sub MergeButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MergeButton.Click
        If CurrentName IsNot Nothing Then
            Dim selName As New SelectNameForm
            selName.InitialNameId = CurrentName("NameGuid").ToString
            selName.Title = "Select name to merge with"
            If selName.ShowDialog = Windows.Forms.DialogResult.OK Then

                If selName.InitialNameId = selName.SelectedNameId Then
                    MsgBox("Cannot merge a name with itself")
                    Exit Sub
                End If

                Windows.Forms.Cursor.Current = Cursors.WaitCursor

                Try
                    Dim oldName1 As DataRow = NameData.GetNameDs(Nothing, CurrentName("NameGuid").ToString).Tables(0).Rows(0)
                    Dim oldName2 As DataRow = NameData.GetNameDs(Nothing, selName.SelectedNameId).Tables(0).Rows(0)

                    MergeToName = BrNames.MergeNames(selName.SelectedNameId, selName.InitialNameId)
                    MergeName = CurrentName.Table.Copy().Rows(0)

                    Dim mDs As New DataTable
                    mDs.Columns.Add("Field")
                    mDs.Columns.Add("OldValue1")
                    mDs.Columns.Add("OldValue2")
                    mDs.Columns.Add("Value")
                    mDs.Columns.Add("OtherValues", GetType(List(Of Object)))

                    Dim newName As DataRow = NameData.GetNameDs(Nothing, selName.SelectedNameId).Tables(0).Rows(0)

                    For Each col As DataColumn In oldName1.Table.Columns
                        If col.ColumnName <> "NameGuid" And col.ColumnName <> "NameCounter" And col.ColumnName <> "NameParent" And Not col.ColumnName.EndsWith("Fk") Then
                            mDs.Rows.Add(New Object() {col.ColumnName, oldName1(col.ColumnName), oldName2(col.ColumnName), newName(col.ColumnName), Nothing})
                        End If
                    Next

                    mDs.AcceptChanges()

                    Dim mForm As New MergeForm
                    mForm.MergeData = mDs
                    If mForm.ShowDialog() = Windows.Forms.DialogResult.OK Then
                        Dim ch As DataTable = mForm.MergeData.GetChanges()
                        If ch IsNot Nothing AndAlso ch.Rows.Count > 0 Then
                            'insert editor prov name?

                            'get system prov name
                            Dim pn As ProviderName = NameData.GetSystemProviderNameForName(selName.SelectedNameId)

                            If pn Is Nothing Then
                                pn = New ProviderName
                                pn.PNNameId = Guid.NewGuid.ToString
                            End If

                            pn.UpdateFieldsFromTable(ch, BrProviderNames.NameMappings)

                            BrProviderNames.InsertUpdateSystemProviderName(selName.SelectedNameId, pn)

                        End If
                    End If
                Catch ex As Exception
                    MsgBox("Failed to merge name")
                    ChecklistException.LogError(ex)
                End Try

                'refresh screen
                RefreshNameScreen(selName.SelectedNameId, True)
                MergeToName = Nothing
                MergeName = Nothing

                Windows.Forms.Cursor.Current = Cursors.Default
            End If
        End If
    End Sub

    'Private Sub DeleteButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DeleteButton.Click
    '    If CurrentName IsNot Nothing Then
    '        If MsgBox("This may result in unlinked provider names.  Are you sure?", MsgBoxStyle.YesNo, "Delete Name") = MsgBoxResult.Yes Then
    '            Windows.Forms.Cursor.Current = Cursors.WaitCursor

    '            Dim pn As String = CurrentName("NameParentNameFk")

    '            Try
    '                BrNames.DeleteName(CurrentName("NameGuid").ToString)
    '            Catch ex As Exception
    '                MsgBox("Failed to delete name")
    '                ChecklistException.LogError(ex)
    '            End Try

    '            'refresh screen
    '            RefreshNameScreen(pn, True)
    '            'expand parent node, so we can still see the names that were there before
    '            NameSelector1.SelectedNameNode.Expand()
    '            Try
    '                NameSelector1.SelectNode(pn)
    '            Catch ex As Exception
    '                ChecklistException.LogError(ex)
    '            End Try

    '            Windows.Forms.Cursor.Current = Cursors.Default
    '        End If
    '    End If
    'End Sub

    Private Sub LinkButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles LinkButton.Click
        If CurrentName IsNot Nothing Then
            Dim pnForm As New ProviderNameRecordsForm
            pnForm.SelectMode = RecordSelectMode.SelectRecord
            If pnForm.ShowDialog = Windows.Forms.DialogResult.OK Then

                Windows.Forms.Cursor.Current = Cursors.WaitCursor

                Try
                    BrProviderNames.UpdateProviderNameLink(pnForm.SelectedRecord, CurrentName("NameGuid").ToString)
                Catch ex As Exception
                    MsgBox("Failed to relink name")
                    ChecklistException.LogError(ex)
                End Try

                RefreshNameScreen(CurrentName("NameGuid").ToString, True)

                Windows.Forms.Cursor.Current = Cursors.WaitCursor
            End If
        End If
    End Sub

    'Private Sub DelProvNameButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DelProvNameButton.Click
    '    If CurrentName IsNot Nothing AndAlso ProviderNameGrid.SelectedCells.Count > 0 Then
    '        Dim prov As String = ProviderNameGrid.CurrentRow.Cells("ProviderName").Value.ToString
    '        If ProviderNameGrid.CurrentRow.Cells("ProviderIsEditor").Value.ToString = Boolean.TrueString Then prov = "SYSTEM"
    '        Dim pk As Integer = ProviderNameGrid.CurrentRow.Cells("PNPk").Value
    '        Dim msg As String = "Delete Provider Name record (Id = " + pk.ToString + ", Provider = " + prov + ").  Are you sure?"
    '        If MsgBox(msg, MsgBoxStyle.YesNo, "Delete Provider Name") = MsgBoxResult.Yes Then
    '            Try
    '                BrProviderNames.DeleteProviderName(pk, SessionState.CurrentUser.Login)
    '                RefreshNameScreen(CurrentName("NameGuid").ToString, False)
    '            Catch ex As Exception
    '                MsgBox("Failed to delete Provider Name record")
    '                ChecklistException.LogError(ex)
    '            End Try
    '        End If
    '    End If
    'End Sub

    Private Sub SetEditMode(ByVal canEdit As Boolean)
        Dim onButton1 As Button = EditButton
        Dim offButton1 As Button = BrowseButton
        Dim onButton2 As Button = RefEditButton
        Dim offButton2 As Button = RefBrowseButton

        If Not canEdit Then
            onButton1 = BrowseButton
            offButton1 = EditButton
            onButton2 = RefBrowseButton
            offButton2 = RefEditButton
        End If

        offButton1.ForeColor = SystemColors.ControlDark
        offButton1.BackColor = SystemColors.ButtonFace
        onButton1.ForeColor = SystemColors.ControlText
        onButton1.BackColor = Color.WhiteSmoke

        offButton2.ForeColor = SystemColors.ControlDark
        offButton2.BackColor = SystemColors.ButtonFace
        onButton2.ForeColor = SystemColors.ControlText
        onButton2.BackColor = Color.WhiteSmoke

        EditMode = canEdit
        NameDetailsGrid.AllowEditing = canEdit
        ConceptsGrid.AllowEditing = canEdit
        ConceptsGrid.AllowAddNew = canEdit
        RefDetailsGrid.AllowEditing = canEdit
        RefCitationText.ReadOnly = Not canEdit

        FullCitationText.ReadOnly = True
        If CurrentReferenceRIS Is Nothing OrElse CurrentReferenceRIS.Rows.Count = 0 Then
            FullCitationText.ReadOnly = Not canEdit
        End If

        UpdateNameEditStyles()
        UpdateNewConceptRowStyle()
        UpdateRefEditStyles()
    End Sub

    Private Sub EditButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles EditButton.Click
        If BrUser.GetReadWriteMode = BrUser.ReadWriteMode.Edit Then
            SetEditMode(True)
        End If
    End Sub

    Private Sub BrowseButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles BrowseButton.Click
        If EditMode Then
            SetEditMode(False)
        End If
    End Sub

    Private Sub MergeMultipleButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MergeMultipleButton.Click
        Dim nForm As New NameRecordsForm
        nForm.ShowDialog()
        Dim id As String
        If CurrentName IsNot Nothing Then id = CurrentName("NameGuid").ToString
        RefreshNameScreen(id, True)
    End Sub

    Private Sub NewNameButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles NewNameButton.Click
        Try
            Dim n As New Name
            n.Id = Guid.NewGuid.ToString
            n.NameLSID = ChecklistObjects.Name.CreateLSID(n.Id)
            n = NameData.InsertName(n, SessionState.CurrentUser.Login)

            AddNameLinks(n, True)

            RefreshNameScreen(n.Id, True)
        Catch ex As Exception
            MsgBox("Failed to create name")
            ChecklistException.LogError(ex)
        End Try
    End Sub

    Private Sub RefreshNameLink_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles RefreshNameLink.LinkClicked
        If CurrentName IsNot Nothing Then
            Try
                If Save(True) Then
                    Windows.Forms.Cursor.Current = Cursors.WaitCursor

                    BrNames.RefreshNameData(CurrentName("NameGuid").ToString, True) 'XXX false here as we have a set of concepts - no need to hit DB again

                    'If ConceptDetailsTable IsNot Nothing Then
                    '    For Each row As DataRow In ConceptDetailsTable.Rows
                    '        BrConcepts.RefreshConceptData(row("ConceptRelationshipConcept1Fk").ToString)
                    '    Next
                    'End If

                    'if ConceptRelRecords IsNot Nothing AndAlso ConceptRelRecords.Tables.Count > 0 Then
                    '    For Each row As DataRow In ConceptRelRecords.Tables(0).Rows
                    '        BrConcepts.RefreshConceptRelationshipData(row("ConceptRelationshipGuid").ToString())
                    '    Next
                    'End If

                    'relationships
                    NameData.RefreshNameRelationData(CurrentName("NameGuid").ToString, SessionState.CurrentUser.Login)

                    'same basionym consideration
                    If Not CurrentName.IsNull("NameBasionym") AndAlso CurrentName("NameBasionym").ToString.Length > 0 AndAlso _
                        Not CurrentName.IsNull("NamePreferred") AndAlso CurrentName("NamePreferred").ToString.Length > 0 Then

                        For Each row As DataRow In ConceptRelRecords.Tables(0).Rows
                            If row("ConceptRelationshipRelationshipFk") = ChecklistObjects.RelationshipType.RelationshipTypePreferred Then
                                Dim accTofk As String = Nothing
                                If Not row.IsNull("ConceptAccordingToFk") Then accTofk = row("ConceptAccordingToFk").ToString
                                BrNames.UpdateNamesWithSameBasionym(CurrentName("NameGuid").ToString, CurrentName("NamePreferredFk").ToString, accTofk)
                                Exit For
                            End If
                        Next
                    End If

                    RefreshNameScreen(CurrentName("NameGuid").ToString, True)

                    Windows.Forms.Cursor.Current = Cursors.WaitCursor
                Else
                    If PartialSave Then
                        MsgBox("Failed to completely save the changes.  The current name details have been reloaded.  The consensus name may need refreshing.")

                        If CurrentName IsNot Nothing Then RefreshNameScreen(CurrentName("NameGuid").ToString, False)
                    Else
                        MsgBox("Failed to save name")
                    End If
                End If
            Catch ex As Exception
                Windows.Forms.Cursor.Current = Cursors.WaitCursor
                MsgBox("Failed to refresh Name")
                ChecklistException.LogError(ex)
            End Try
        End If
    End Sub

    Private Sub ExportDatabaseToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExportDatabaseToolStripMenuItem.Click
        Dim transForm As New ExportDBForm
        transForm.ShowDialog()

    End Sub

    Private Sub CleanDatabaseToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CleanDatabaseToolStripMenuItem.Click
        Windows.Forms.Cursor.Current = Cursors.WaitCursor

        Try
            DBData.CleanDatabase()

            MsgBox("Database clean complete")

        Catch ex As Exception
            MsgBox("Failed to clean database")
            ChecklistException.LogError(ex)
        End Try

        Windows.Forms.Cursor.Current = Cursors.Default
    End Sub

    Private Sub RefreshAllNamesToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RefreshAllNamesToolStripMenuItem.Click
        Try
            Dim refreshFrom As New RefreshNamesForm
            refreshFrom.ShowDialog()
        Catch ex As Exception
            ChecklistException.LogError(ex)
            MsgBox("Failed to update names")
        End Try
    End Sub

    Private Sub RefreshChildrenLink_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles RefreshChildrenLink.LinkClicked
        Windows.Forms.Cursor.Current = Cursors.WaitCursor
        Try
            If CurrentName IsNot Nothing Then
                BrNames.RefreshChildNames(CurrentName("NameGuid").ToString)
            End If
            Windows.Forms.Cursor.Current = Cursors.Default
        Catch ex As Exception
            Windows.Forms.Cursor.Current = Cursors.Default
            ChecklistException.LogError(ex)
            MsgBox("Failed to update names")
        End Try
    End Sub

    Private Sub DeduplicateChildrenToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DeduplicateChildrenToolStripMenuItem.Click
        If CurrentName IsNot Nothing Then
            If Save(True) Then
                Dim ddForm As New DeduplicationForm
                ddForm.ParentName = CurrentName
                ddForm.ShowDialog()

                RefreshNameScreen(CurrentName("NameGuid").ToString, True)
            End If
        End If
    End Sub

    Private Sub MoveChildrenOfSelectedToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MoveChildrenOfSelectedToolStripMenuItem.Click
        If CurrentName IsNot Nothing Then
            If Save(True) Then
                Dim selForm As New SelectNameForm
                selForm.InitialNameId = CurrentName("NameGuid").ToString
                selForm.ShowNoneOption = False
                selForm.Title = "Select name to move children to"
                If selForm.ShowDialog = Windows.Forms.DialogResult.OK Then
                    Windows.Forms.Cursor.Current = Cursors.WaitCursor
                    Try
                        BrNames.MoveNameChildren(CurrentName("NameGuid").ToString, selForm.SelectedNameId, SessionState.CurrentUser.Login)
                        RefreshNameScreen(CurrentName("NameGuid").ToString, True)
                        Windows.Forms.Cursor.Current = Cursors.Default
                    Catch ex As Exception
                        Windows.Forms.Cursor.Current = Cursors.Default
                        ChecklistException.LogError(ex)
                        MsgBox("Error moving names")
                    End Try
                End If
            End If
        End If
    End Sub

    Private Sub DeduplicateReferencesToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DeduplicateReferencesToolStripMenuItem.Click
        If CurrentName IsNot Nothing Then
            If Save(True) Then
                Dim ddForm As New ReferenceCleanupForm
                ddForm.ParentName = CurrentName
                ddForm.ShowDialog()

                RefreshNameScreen(CurrentName("NameGuid").ToString, True)
            End If
        End If
    End Sub

    Private Sub MergeUnknownNamesToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MergeUnknownNamesToolStripMenuItem.Click
        If Save(True) Then
            Dim ddForm As New MergeUnknownsForm
            ddForm.ShowDialog()

            If CurrentName IsNot Nothing Then RefreshNameScreen(CurrentName("NameGuid").ToString, True)
        End If
    End Sub


    '-----------------------
    'References

    Private Sub RefEditButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RefEditButton.Click
        If BrUser.GetReadWriteMode = BrUser.ReadWriteMode.Edit Then
            SetEditMode(True)
        End If
    End Sub

    Private Sub RefBrowseButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RefBrowseButton.Click
        If EditMode Then SetEditMode(False)
    End Sub

    Private Sub ReferenceSearch1_ReferenceSelected(ByVal item As IntegratorControls.ResultItem) Handles ReferenceSearch1.ReferenceSelected
        If Save(True) Then
            Windows.Forms.Cursor.Current = Cursors.WaitCursor

            Try
                ClearRefDetails()
                GetReference(item.Id)
                DisplayReference(item.Id)
                RefChanged = False
            Catch ex As Exception
                ChecklistException.LogError(ex)
            End Try

            Windows.Forms.Cursor.Current = Cursors.Default
        Else
            If PartialSave Then
                MsgBox("Failed to completely save the changes.  The current reference details have been reloaded.  The consensus reference may need refreshing.")

                If CurrentReference IsNot Nothing Then RefreshRefScreen(CurrentReference("ReferenceGuid").ToString)
            Else
                MsgBox("Failed to save reference")
            End If
        End If
    End Sub

    Private Sub RefMergeButton_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles RefMergeButton.Click
        If CurrentReference IsNot Nothing Then
            Dim selRef As New SelectReferenceForm
            selRef.Title = "Select reference to merge with"
            If selRef.ShowDialog = Windows.Forms.DialogResult.OK Then
                Windows.Forms.Cursor.Current = Cursors.WaitCursor

                Try
                    Dim refDs As DataSet = ReferenceData.GetReferenceRISByReferenceDs(selRef.SelectedReferenceId)
                    Dim oldRIS2 As DataRow
                    If refDs IsNot Nothing AndAlso refDs.Tables(0).Rows.Count > 0 Then
                        oldRIS2 = refDs.Tables(0).Rows(0)
                    End If

                    If CurrentReferenceRIS IsNot Nothing Or oldRIS2 IsNot Nothing Then
                        Dim oldRIS1 As DataRow
                        If CurrentReferenceRIS IsNot Nothing Then oldRIS1 = ReferenceData.GetReferenceRISByReferenceDs(CurrentReference("ReferenceGuid").ToString).Tables(0).Rows(0)

                        BrReferences.MergeReferences(selRef.SelectedReferenceId, CurrentReference("ReferenceGuid").ToString)

                        Dim mDs As New DataTable
                        mDs.Columns.Add("Field")
                        mDs.Columns.Add("OldValue1")
                        mDs.Columns.Add("OldValue2")
                        mDs.Columns.Add("Value")
                        mDs.Columns.Add("OtherValues", GetType(List(Of Object)))

                        Dim newRef As DataRow = ReferenceData.GetReferenceRISByReferenceDs(CurrentReference("ReferenceGuid").ToString).Tables(0).Rows(0)

                        Dim tbl As DataTable
                        If oldRIS1 IsNot Nothing Then tbl = oldRIS1.Table
                        If oldRIS2 IsNot Nothing Then tbl = oldRIS2.Table
                        For Each col As DataColumn In tbl.Columns
                            If col.ColumnName <> "RISPk" And col.ColumnName <> "RISReferenceFk" Then
                                Dim val1 As Object = DBNull.Value
                                Dim val2 As Object = DBNull.Value
                                If oldRIS1 IsNot Nothing Then val1 = oldRIS1(col.ColumnName)
                                If oldRIS2 IsNot Nothing Then val2 = oldRIS2(col.ColumnName)
                                mDs.Rows.Add(New Object() {col.ColumnName, val1, val2, newRef(col.ColumnName), Nothing})
                            End If
                        Next

                        mDs.AcceptChanges()

                        Dim mForm As New MergeForm
                        mForm.MergeData = mDs
                        If mForm.ShowDialog() = Windows.Forms.DialogResult.OK Then

                            Dim ch As DataTable = mForm.MergeData.GetChanges()
                            If ch IsNot Nothing AndAlso ch.Rows.Count > 0 Then
                                'insert editor ref?

                                'get system prov ref
                                Dim pr As ProviderReference = ReferenceData.GetSystemProviderRefForRef(CurrentReference("ReferenceGuid").ToString)

                                If pr Is Nothing Then
                                    pr = New ProviderReference
                                    pr.PRReferenceId = Guid.NewGuid.ToString
                                End If

                                'get existing system RIS
                                Dim ris As ProviderRIS = ReferenceData.GetProviderRISByReference(pr.Id)
                                If ris Is Nothing Then ris = New ProviderRIS

                                ris.UpdateFieldsFromTable(ch, BrProviderReferences.RISMappings)

                                BrProviderReferences.InsertUpdateSystemProviderReference(CurrentReference("ReferenceGuid").ToString, pr, ris)

                            End If
                        End If
                    Else
                        'only ref data
                        Dim oldRef1 As DataRow = ReferenceData.GetReferenceDs(CurrentReference("ReferenceGuid").ToString).Tables(0).Rows(0)
                        Dim oldRef2 As DataRow = ReferenceData.GetReferenceDs(selRef.SelectedReferenceId).Tables(0).Rows(0)

                        BrReferences.MergeReferences(selRef.SelectedReferenceId, CurrentReference("ReferenceGuid").ToString)

                        Dim mDs As New DataTable
                        mDs.Columns.Add("Field")
                        mDs.Columns.Add("OldValue1")
                        mDs.Columns.Add("OldValue2")
                        mDs.Columns.Add("Value")
                        mDs.Columns.Add("OtherValues", GetType(List(Of Object)))

                        Dim newRef As DataRow = ReferenceData.GetReferenceDs(CurrentReference("ReferenceGuid").ToString).Tables(0).Rows(0)

                        mDs.Rows.Add(New Object() {"ReferenceCitation", oldRef1("ReferenceCitation"), oldRef2("ReferenceCitation"), newRef("ReferenceCitation"), Nothing})
                        mDs.Rows.Add(New Object() {"ReferenceFullCitation", oldRef1("ReferenceFullCitation"), oldRef2("ReferenceFullCitation"), newRef("ReferenceFullCitation"), Nothing})

                        mDs.AcceptChanges()

                        Dim mForm As New MergeForm
                        mForm.MergeData = mDs
                        If mForm.ShowDialog() = Windows.Forms.DialogResult.OK Then

                            Dim ch As DataTable = mForm.MergeData.GetChanges()
                            If ch IsNot Nothing AndAlso ch.Rows.Count > 0 Then
                                'insert editor ref?

                                'get system prov ref
                                Dim pr As ProviderReference = ReferenceData.GetSystemProviderRefForRef(CurrentReference("ReferenceGuid").ToString)

                                If pr Is Nothing Then
                                    pr = New ProviderReference
                                    pr.PRReferenceId = Guid.NewGuid.ToString
                                End If

                                For Each r As DataRow In ch.Rows
                                    If r("Field").ToString = "ReferenceCitation" Then pr.PRCitation = r("Value").ToString
                                    If r("Field").ToString = "ReferenceFullCitation" Then pr.PRFullCitation = r("Value").ToString
                                Next

                                BrProviderReferences.InsertUpdateSystemProviderReference(CurrentReference("ReferenceGuid").ToString, pr, Nothing)

                            End If
                        End If
                    End If
                Catch ex As Exception
                    MsgBox("Failed to merge reference")
                    ChecklistException.LogError(ex)
                End Try

                'refresh screen
                RefreshRefScreen(CurrentReference("ReferenceGuid").ToString)

                Windows.Forms.Cursor.Current = Cursors.Default
            End If
        End If
    End Sub

    Private Sub RefLinkButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RefLinkButton.Click
        If CurrentReference IsNot Nothing Then
            Dim prForm As New ProviderRefRecordsForm
            prForm.SelectMode = RecordSelectMode.SelectRecord
            If prForm.ShowDialog = Windows.Forms.DialogResult.OK Then

                Windows.Forms.Cursor.Current = Cursors.WaitCursor

                Try
                    BrProviderReferences.UpdateProviderReferenceLink(prForm.SelectedRecord, CurrentReference("ReferenceGuid").ToString)
                Catch ex As Exception
                    MsgBox("Failed to relink reference")
                    ChecklistException.LogError(ex)
                End Try

                RefreshRefScreen(CurrentReference("ReferenceGuid").ToString)

                Windows.Forms.Cursor.Current = Cursors.WaitCursor
            End If
        End If
    End Sub

    Private Sub RefDetailsGrid_ChangeEdit(ByVal sender As Object, ByVal e As System.EventArgs) Handles RefDetailsGrid.ChangeEdit
        SaveButton.Enabled = True
        saveWithAttButton.Enabled = True
        CncButton.Enabled = True
        SaveEditsToolStripMenuItem.Enabled = True
    End Sub


    Private Sub RefHideBlankFields_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RefHideBlankFields.CheckedChanged
        If Not CurrentReference Is Nothing Then
            Dim dv As DataView = RefDetailsGrid.DataSource
            If HideBlankFields() Then
                dv.RowFilter = "Value is not null"
            Else
                dv.RowFilter = ""
            End If

            SetRefGridFormatting()
        End If
    End Sub

    Private Sub RefDetailsGrid_BeforeEdit(ByVal sender As Object, ByVal e As C1.Win.C1FlexGrid.RowColEventArgs) Handles RefDetailsGrid.BeforeEdit
        If EditMode Then
            If (RefDetailsGrid.Cols(e.Col).Name <> "Value" And RefDetailsGrid.Cols(e.Col).Name <> "Status") OrElse _
                (RefDetailsGrid.Rows(e.Row)("Field") IsNot Nothing AndAlso _
                EditableRefColumns.IndexOf(RefDetailsGrid.Rows(e.Row)("Field").ToString) = -1 AndAlso _
                LinkableRefColumns.IndexOf(RefDetailsGrid.Rows(e.Row)("Field").ToString) = -1) Then
                e.Cancel = True
            End If
        End If
    End Sub

    Private Sub RefCitationText_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles RefCitationText.TextChanged
        RefChanged = True
        SaveButton.Enabled = True
        saveWithAttButton.Enabled = True
        CncButton.Enabled = True
        SaveEditsToolStripMenuItem.Enabled = True
    End Sub

    Private Sub FullCitationText_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles FullCitationText.TextChanged
        RefChanged = True
        SaveButton.Enabled = True
        saveWithAttButton.Enabled = True
        CncButton.Enabled = True
        SaveEditsToolStripMenuItem.Enabled = True
    End Sub

    Private Sub RefProviderGrid_CellContentClick(ByVal sender As Object, ByVal e As System.Windows.Forms.DataGridViewCellEventArgs) Handles RefProviderGrid.CellContentClick
        If e.ColumnIndex = 0 Then
            If Not Save(True) Then
                If PartialSave Then
                    MsgBox("Failed to completely save the changes.  The current reference details have been reloaded.  The consensus reference may need refreshing.")

                    If CurrentReference IsNot Nothing Then RefreshRefScreen(CurrentReference("ReferenceGuid").ToString)
                Else
                    MsgBox("Failed to save reference")
                End If
            Else
                SplitCurrentProviderReference(e.RowIndex)
            End If
        End If
    End Sub

    Private Sub NewRefButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles NewRefButton.Click
        Try
            Dim pr As New ProviderReference
            pr.PRReferenceId = Guid.NewGuid.ToString

            Dim gb As New GrabTextForm
            gb.Title = "Enter citation for reference"
            If gb.ShowDialog = Windows.Forms.DialogResult.OK Then
                pr.PRCitation = gb.TextValue

                Dim pris As New ProviderRIS
                pris.PRISProviderReferencefk = pr.IdAsInt

                Dim newRef As Reference = ReferenceData.InsertReferenceFromProviderReference(pr, SessionState.CurrentUser.Login)

                BrProviderReferences.InsertUpdateSystemProviderReference(newRef.Id, pr, pris)

                RefreshRefScreen(newRef.Id)
            End If
        Catch ex As Exception
            MsgBox("Failed to create reference")
            ChecklistException.LogError(ex)
        End Try
    End Sub

    Private Sub AuthorsToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles AuthorsToolStripMenuItem.Click
        Dim authEdit As New AuthorsForm
        If authEdit.ShowDialog() = Windows.Forms.DialogResult.OK Then
            Dim id As String
            If CurrentName IsNot Nothing Then id = CurrentName("NameGuid").ToString
            RefreshNameScreen(id, False)
        End If
    End Sub

#End Region

#Region "Name Details"

    Private Function GetNameGridValue(ByVal fieldName As String) As Object
        Dim val As Object = DBNull.Value
        For Each r As Row In NameDetailsGrid.Rows
            If r("Field").ToString = fieldName Then
                val = r("Value")
                Exit For
            End If
        Next
        Return val
    End Function

    Private Sub UpdateNameGridValue(ByVal fieldName As String, ByVal value As Object)
        For Each r As Row In NameDetailsGrid.Rows
            If r("Field").ToString = fieldName Then
                r("Value") = value
                Exit For
            End If
        Next
    End Sub

    Private Sub GetName(ByVal nameGuid As String)
        Dim ds As DataSet = NameData.GetNameDs(Nothing, nameGuid)
        If Not ds Is Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
            CurrentName = ds.Tables(0).Rows(0)
        End If

        ProviderNameRecords = NameData.GetProviderNameRecords(nameGuid)
        Dim pn As ProviderName = NameData.GetSystemProviderNameForName(nameGuid)
        If pn IsNot Nothing Then
            FieldStatusDs = ChecklistDataAccess.FieldStatusData.LoadStatus(pn.Id, "tblProviderName")
        End If

        ConceptRelRecords = ConceptData.GetNameConceptRelationshipRecordsDs(nameGuid, False)
        ProviderConceptRelRecords = ConceptData.GetProviderConceptRelationshipRecords(nameGuid, False)

        OtherDataDs = OtherData.GetProviderNameOtherData(nameGuid).Tables(0)
    End Sub

    Private Function GetNameDsValFromGridCoords(ByVal row As Integer, ByVal col As Integer) As Object
        Dim colName As String = ProviderNameGrid.Rows(row).Cells(col).OwningColumn.HeaderText
        Return ProviderNameRecords.Tables(0).Rows(row)(colName)
    End Function

    Private Sub SetNameDsValFromGridCoords(ByVal row As Integer, ByVal col As Integer, ByVal val As Object)
        Dim colName As String = ProviderNameGrid.Rows(row).Cells(col).OwningColumn.HeaderText
        ProviderNameRecords.Tables(0).Rows(row)(colName) = val
    End Sub

    Private Function HideBlankFields() As Boolean
        If TabControl1.SelectedIndex = 0 Then Return NamesHideBlankFields.Checked
        If TabControl1.SelectedIndex = 1 Then Return RefHideBlankFields.Checked
    End Function

    Private Sub GotoLink(ByVal linkUrl As String)
        If linkUrl.StartsWith("SelectReference") Then
            Dim pos As Integer = linkUrl.IndexOf("=") + 1
            If linkUrl.Length > pos Then
                If TabControl1.SelectedIndex = 1 Then
                    ReferenceSearch1.SelectReference(linkUrl.Substring(pos))
                Else
                    LinkToRef = linkUrl.Substring(pos)
                    TabControl1.SelectedIndex = 1
                End If
            End If
        ElseIf linkUrl.StartsWith("SelectName") Then
            Dim pos As Integer = linkUrl.IndexOf("=") + 1
            If linkUrl.Length > pos Then
                If TabControl1.SelectedIndex <> 0 Then TabControl1.SelectedIndex = 0
                Dim nameId As String = linkUrl.Substring(pos)
                Dim id As String = ""
                If CurrentName IsNot Nothing Then id = CurrentName("NameGuid").ToString()
                If nameId <> id AndAlso nameId <> Guid.Empty.ToString Then
                    Try
                        NameSelector1.SelectNode(nameId)
                    Catch ex As Exception
                        MsgBox("Failed to navigate to name")
                        ChecklistException.LogError(ex)
                    End Try
                End If
            End If
        End If
    End Sub

    Private Sub AddTextRow(ByVal dt As DataTable, ByVal fieldName As String, ByVal val As Object, ByVal status As Integer)
        Dim newRow(3) As Object
        newRow(0) = fieldName
        newRow(1) = val
        If status <> -1 Then newRow(2) = status
        dt.Rows.Add(newRow)
    End Sub

    Private Sub AddLinkRow(ByVal dt As DataTable, ByVal fieldName As String, ByVal text As Object, ByVal status As Integer, ByVal url As String)
        Dim newRow(3) As Object
        newRow(0) = fieldName
        newRow(1) = text
        If status <> -1 Then newRow(2) = status
        newRow(3) = url
        dt.Rows.Add(newRow)
    End Sub

    Private Sub DisplayName(ByVal nameGuid As String)
        If CurrentName IsNot Nothing Then
            NameDetailsTable = New DataTable
            NameDetailsTable.Columns.Add("Field")
            NameDetailsTable.Columns.Add("Value", GetType(Object))
            NameDetailsTable.Columns.Add("Status", GetType(Integer))
            NameDetailsTable.Columns.Add("LinkFk")

            For Each col As DataColumn In CurrentName.Table.Columns
                Dim field As String = NameMapping.SourceColumnNameOfDest(BrProviderNames.NameMappings, col.ColumnName)
                If col.ColumnName = "NameLSID" Then field = "PNPk"
                If col.ColumnName = "NameParent" Then field = "PNParent"
                If col.ColumnName = "NamePreferred" Then field = "PNPreferred"
                Dim sr As DataRow
                If FieldStatusDs IsNot Nothing Then sr = FieldStatusData.GetProviderNameFieldStatus(FieldStatusDs, field)
                Dim stat As Integer = -1
                If sr IsNot Nothing AndAlso Not sr.IsNull("FieldStatusLevelFk") Then stat = sr("FieldStatusLevelFk")

                If LinkableNameColumns.IndexOf(col.ColumnName) <> -1 Then

                    Dim val As String = ""
                    Dim fk As String = CurrentName(col.ColumnName + "Fk").ToString
                    Dim link As String = "SelectName=" + fk
                    If fk = Guid.Empty.ToString Then
                        val = "<none>"
                    Else
                        val = CurrentName(col.ColumnName).ToString
                        If val.Length = 0 Then val = "<null>" 'AndAlso EditMode 
                    End If
                    AddLinkRow(NameDetailsTable, col.ColumnName, val, stat, link)
                ElseIf LinkableNameRefColumns.IndexOf(col.ColumnName) <> -1 Then
                    Dim fname As String = col.ColumnName
                    If fname = "NamePublishedIn" Then
                        fname = "NameReferenceFk"
                    Else
                        fname += "Fk"
                    End If

                    Dim val As String = ""
                    Dim fk As String = CurrentName(fname).ToString
                    Dim link As String = "SelectReference=" + fk
                    If fk = Guid.Empty.ToString Then
                        val = "<none>"
                    Else
                        val = CurrentName(col.ColumnName).ToString
                        If val.Length = 0 Then val = "<null>" 'AndAlso EditMode 
                    End If
                    AddLinkRow(NameDetailsTable, col.ColumnName, val, stat, link)
                Else
                    AddTextRow(NameDetailsTable, col.ColumnName, CurrentName(col.ColumnName), stat)
                End If

            Next

            NameDetailsTable.AcceptChanges()

            If HideBlankFields() Then NameDetailsTable.DefaultView.RowFilter = "Value is not null"

            NameDetailsGrid.Clear(ClearFlags.All)
            NameDetailsGrid.DataSource = NameDetailsTable.DefaultView


            'provider records
            If ProviderNameRecords IsNot Nothing AndAlso ProviderNameRecords.Tables.Count > 0 Then
                ProviderNameGrid.DataSource = ProviderNameRecords
                ProviderNameGrid.DataMember = ProviderNameRecords.Tables(0).TableName
            End If


            'concepts
            If ConceptRelRecords IsNot Nothing Then
                ConceptDetailsTable = New DataTable()
                ConceptDetailsTable.Columns.Add("Index")
                ConceptDetailsTable.Merge(ConceptRelRecords.Tables(0).Copy)

                Dim i As Integer = 1
                For Each row As DataRow In ConceptDetailsTable.Rows
                    row("Index") = i.ToString()
                    i += 1
                Next

                ConceptDetailsTable.AcceptChanges()

                ConceptsGrid.Clear(ClearFlags.All)

                ConceptsGrid.DataSource = ConceptDetailsTable

                ConceptsGrid.Cols("ConceptRelationshipConcept1Fk").Visible = False
                ConceptsGrid.Cols("ConceptRelationshipConcept2Fk").Visible = False
                ConceptsGrid.Cols("ConceptRelationshipGuid").Visible = False
                ConceptsGrid.Cols("ConceptRelationshipLSID").Visible = False
                ConceptsGrid.Cols("ConceptName1").Visible = False
                ConceptsGrid.Cols("ConceptName1Fk").Visible = False
                ConceptsGrid.Cols("ConceptToName1Fk").Visible = False
                ConceptsGrid.Cols("ConceptRelationshipRelationshipFk").Visible = False
                ConceptsGrid.Cols("ConceptAccordingToFk").Visible = False
                ConceptsGrid.Cols("ConceptToAccordingTo").Visible = False
                ConceptsGrid.Cols("ConceptToAccordingToFk").Visible = False

                ConceptsGrid.Cols("ConceptToName1").Caption = "To Name"
                ConceptsGrid.Cols("ConceptAccordingTo").Caption = "According To"
                ConceptsGrid.Cols("ConceptRelationshipRelationship").Caption = "Relationship"
                ConceptsGrid.Cols("ConceptRelationshipHybridOrder").Caption = "Hybrid Order"
            End If

            'prov concepts
            If ProviderConceptRelRecords IsNot Nothing Then
                Dim dst As DataTable = New DataTable()
                dst.Columns.Add("Concept Index")
                dst.Merge(ProviderConceptRelRecords.Tables(0))

                For Each row As DataRow In dst.Rows
                    Dim rows As DataRow() = ConceptDetailsTable.Select("ConceptRelationshipGuid = '" + row("PCRConceptRelationshipFk").ToString() + "'")
                    If rows.Length > 0 Then
                        Dim i As String = rows(0)("Index").ToString()
                        row("Concept Index") = i
                    End If
                Next

                dst.AcceptChanges()

                ProvConceptGrid.DataSource = dst

                ProvConceptGrid.Columns("Concept Index").Width = 110
            End If

            'other data
            OtherDataDs.AcceptChanges()
            OtherDataGrid.DataSource = OtherDataDs

            UpdateProviderGridColours()
            SetNameDetailsGridFormatting()


            OtherDataGrid.ClearSelection()
            ProviderNameGrid.ClearSelection()
            ProvConceptGrid.ClearSelection()
        End If
    End Sub

    Private Sub SetNameDetailsGridFormatting()
        NameDetailsGrid.Rows.DefaultSize = 20

        NameDetailsGrid.ShowButtons = ShowButtonsEnum.Always

        NameDetailsGrid.Cols("Value").TextAlign = TextAlignEnum.LeftCenter
        NameDetailsGrid.Cols("Status").TextAlign = TextAlignEnum.LeftCenter

        'hide row header
        NameDetailsGrid.Cols(0).Visible = False

        NameDetailsGrid.Cols(1).Name = "Field"
        NameDetailsGrid.Cols(2).Name = "Value"
        NameDetailsGrid.Cols(3).Name = "Status"

        NameDetailsGrid.Cols("Field").Width = 190
        NameDetailsGrid.Cols("Value").Width = 350
        NameDetailsGrid.Cols("Status").Width = 150
        NameDetailsGrid.Cols("LinkFk").Visible = False

        NameDetailsGrid.Cols("Field").StyleNew.BackColor = Color.LightGray

        ConceptsGrid.Cols(0).Visible = False
        ConceptsGrid.Cols("ConceptToName1").Width = 180
        ConceptsGrid.Cols("ConceptRelationshipRelationship").Width = 140
        ConceptsGrid.Cols("ConceptAccordingTo").Width = 185

        ConceptsGrid.ShowButtons = ShowButtonsEnum.Always

        'do row formatting
        UpdateNameEditStyles()
        UpdateNewConceptRowStyle()

        EditButton.Enabled = (BrUser.GetReadWriteMode = BrUser.ReadWriteMode.Edit)
        NameDetailsGrid.AllowEditing = EditMode
        ConceptsGrid.AllowEditing = EditMode
        ConceptsGrid.AllowAddNew = EditMode
    End Sub

    Private Sub UpdateNameEditStyles()
        Dim rankstyle As CellStyle = NameDetailsGrid.Styles("RankStyle")
        If rankstyle Is Nothing Then
            rankstyle = NameDetailsGrid.Styles.Add("RankStyle", "Normal")
            Dim dt As New ListDictionary
            For Each r As Rank In RankData.GetRanks
                dt.Add(r.IdAsInt, r.Name)
            Next
            rankstyle.DataMap = dt
        End If

        Dim refStyle As CellStyle = NameDetailsGrid.Styles("RefStyle")
        If refStyle Is Nothing Then
            refStyle = NameDetailsGrid.Styles.Add("RefStyle", "Normal")
            refStyle.ForeColor = Color.Blue
            refStyle.Font = New Font(NameDetailsGrid.Font.FontFamily, NameDetailsGrid.Font.Size, FontStyle.Underline)
            refStyle.DataMap = ReferenceHistory
        End If

        Dim linkStyle As CellStyle = NameDetailsGrid.Styles("LinkStyle")
        If linkStyle Is Nothing Then
            linkStyle = NameDetailsGrid.Styles.Add("LinkStyle", "Normal")
            linkStyle.ForeColor = Color.Blue
            linkStyle.Font = New Font(NameDetailsGrid.Font.FontFamily, NameDetailsGrid.Font.Size, FontStyle.Underline)
        End If

        Dim statStyle As CellStyle = NameDetailsGrid.Styles("StatusStyle")
        If statStyle Is Nothing Then
            statStyle = NameDetailsGrid.Styles.Add("StatusStyle", "Normal")
            Dim sdt As New ListDictionary
            For Each s As DataRow In FieldStatusData.AuxFieldStatusData.Tables("tblFieldStatusLevel").Rows
                sdt.Add(s("FieldStatusLevelCounterPk"), s("FieldStatusLevelText"))
            Next
            sdt.Add(-1, "<Clear>")
            statStyle.DataMap = sdt
        End If

        Dim boolStyle As CellStyle = NameDetailsGrid.Styles("BoolStyle")
        If boolStyle Is Nothing Then
            boolStyle = NameDetailsGrid.Styles.Add("BoolStyle", "Normal")
            boolStyle.DataType = GetType(Boolean)
        End If

        For Each r As Row In NameDetailsGrid.Rows
            If r.Index = 0 Then Continue For

            'validation levels
            NameDetailsGrid.SetCellStyle(r.Index, 3, statStyle)

            'links
            If r("LinkFk").ToString.Length > 0 Then 'has link

                If r("LinkFk").ToString.StartsWith("SelectName") Then

                    'name style - has history of names selected for this particular field
                    Dim hName As String = r("Field").ToString + "History"
                    Dim hist As ListDictionary = NameHistory(hName)
                    If hist Is Nothing Then
                        hist = New ListDictionary
                        hist.Add(ClearId.ToString, "Clear")
                        hist.Add(BrowseId.ToString, "Browse...")
                        NameHistory.Add(hName, hist)
                    End If

                    Dim nameStyle As CellStyle = NameDetailsGrid.Styles(hName)
                    If nameStyle Is Nothing Then
                        nameStyle = NameDetailsGrid.Styles.Add(hName, "Normal")
                        nameStyle.ForeColor = Color.Blue
                        nameStyle.Font = New Font(NameDetailsGrid.Font.FontFamily, NameDetailsGrid.Font.Size, FontStyle.Underline)
                        nameStyle.DataMap = hist
                    End If

                    If EditMode Then
                        NameDetailsGrid.SetCellStyle(r.Index, 2, nameStyle)
                        'If r("Value").ToString.Length = 0 Then r("Value") = "<null>"
                    Else
                        NameDetailsGrid.SetCellStyle(r.Index, 2, linkStyle)
                        'If r("Value").ToString = "<null>" Then r("Value") = DBNull.Value
                    End If
                Else
                    If EditMode Then
                        NameDetailsGrid.SetCellStyle(r.Index, 2, refStyle)
                    Else
                        NameDetailsGrid.SetCellStyle(r.Index, 2, linkStyle)
                    End If
                End If
            End If

            'rank style/combo
            If r("Field").ToString = "NameRankFk" Then
                NameDetailsGrid.SetCellStyle(r.Index, 2, rankstyle)
            End If

            'booleans
            If r("Field").ToString = "NameInCitation" Or _
                r("Field").ToString = "NameInvalid" Or _
                r("Field").ToString = "NameIllegitimate" Or _
                r("Field").ToString = "NameMisapplied" Or _
                r("Field").ToString = "NameProParte" Then
                NameDetailsGrid.SetCellStyle(r.Index, 2, boolStyle)
            End If


            'hidden fields
            If HiddenNameColumns.IndexOf(r("Field").ToString) <> -1 Then
                r.Visible = False
            End If
        Next

        'if we have just merged a name then set the changed field names to red to indicate change
        If MergeToName IsNot Nothing Then
            Dim hliteStyle As CellStyle = NameDetailsGrid.Styles("HiliteStyle")
            If hliteStyle Is Nothing Then
                hliteStyle = NameDetailsGrid.Styles.Add("HiliteStyle", "Normal")
                hliteStyle.ForeColor = Color.OrangeRed
            End If

            For Each r As Row In NameDetailsGrid.Rows
                Dim f As String = r("Field").ToString
                If MergeToName.Table.Columns.Contains(f) Then
                    Dim oldval As String = MergeToName(f).ToString
                    If oldval <> r("Value").ToString Then
                        NameDetailsGrid.SetCellStyle(r.Index, 1, hliteStyle)
                    End If
                End If
            Next
        End If

        'concepts
        Dim chist As ListDictionary = NameHistory("ConceptName2History")
        If chist Is Nothing Then
            chist = New ListDictionary
            chist.Add(ClearId.ToString, "Clear")
            chist.Add(BrowseId.ToString, "Browse...")
            NameHistory.Add("ConceptName2History", chist)
        End If

        Dim nst As CellStyle = NameDetailsGrid.Styles("ConceptName2History")
        If nst Is Nothing Then
            nst = NameDetailsGrid.Styles.Add("ConceptName2History", "Normal")
            nst.ForeColor = Color.Blue
            nst.Font = New Font(NameDetailsGrid.Font.FontFamily, NameDetailsGrid.Font.Size, FontStyle.Underline)
            nst.DataMap = chist
        End If

        Dim rst As CellStyle = ConceptsGrid.Styles("RefStyle")
        If rst Is Nothing Then
            rst = ConceptsGrid.Styles.Add("RefStyle", refStyle)
        End If
        Dim lst As CellStyle = ConceptsGrid.Styles("LinkStyle")
        If lst Is Nothing Then lst = ConceptsGrid.Styles.Add("LinkStyle", linkStyle)
        Dim relSt As CellStyle = ConceptsGrid.Styles("RelStyle")
        If relSt Is Nothing Then
            relSt = ConceptsGrid.Styles.Add("RelStyle", "Normal")

            Dim map As New ListDictionary
            Dim rels As List(Of RelationshipType) = ConceptData.GetRelationshipTypes()
            For Each rel As RelationshipType In rels
                map.Add(rel.IdAsInt, rel.RelationshipTypeName)
            Next
            relSt.DataMap = map
        End If

        If ConceptsGrid.DataSource IsNot Nothing Then
            For Each r As Row In ConceptsGrid.Rows
                If r.Index > 0 Then
                    If EditMode Then
                        ConceptsGrid.SetCellStyle(r.Index, 9, nst)
                        ConceptsGrid.SetCellStyle(r.Index, 11, rst)
                        'ConceptsGrid.SetCellStyle(r.Index, 5, relSt)
                    Else
                        ConceptsGrid.SetCellStyle(r.Index, 9, lst)
                        ConceptsGrid.SetCellStyle(r.Index, 11, lst)
                    End If
                End If
            Next
        End If
    End Sub

    Private Sub UpdateNewConceptRowStyle()

        If EditMode Then
            Dim chist As ListDictionary = NameHistory("ConceptName2History")
            If chist Is Nothing Then
                chist = New ListDictionary
                chist.Add(ClearId.ToString, "Clear")
                chist.Add(BrowseId.ToString, "Browse...")
                NameHistory.Add("ConceptName2History", chist)
            End If

            Dim nst As CellStyle = NameDetailsGrid.Styles("ConceptName2History")
            If nst Is Nothing Then
                nst = NameDetailsGrid.Styles.Add("ConceptName2History", "Normal")
                nst.ForeColor = Color.Blue
                nst.Font = New Font(NameDetailsGrid.Font.FontFamily, NameDetailsGrid.Font.Size, FontStyle.Underline)
                nst.DataMap = chist
            End If

            Dim rst As CellStyle = ConceptsGrid.Styles("RefStyle")
            Dim relSt As CellStyle = ConceptsGrid.Styles("RelStyle")
            If relSt Is Nothing Then
                relSt = ConceptsGrid.Styles.Add("RelStyle", "Normal")

                Dim map As New ListDictionary
                Dim rels As List(Of RelationshipType) = ConceptData.GetRelationshipTypes()
                For Each rel As RelationshipType In rels
                    map.Add(rel.IdAsInt, rel.RelationshipTypeName)
                Next
                relSt.DataMap = map
            End If

            If ConceptsGrid.DataSource IsNot Nothing Then
                For Each r As Row In ConceptsGrid.Rows
                    If r("ConceptRelationshipGuid") Is Nothing Or r("ConceptRelationshipGuid") Is DBNull.Value Then 'new
                        ConceptsGrid.SetCellStyle(r.Index, 9, nst)
                        ConceptsGrid.SetCellStyle(r.Index, 5, relSt)
                        ConceptsGrid.SetCellStyle(r.Index, 11, rst)
                    End If
                Next
            End If
        End If
    End Sub

    Private Sub UpdateProviderGridColours()
        Dim hasEd As Boolean = False
        For Each dgvr As DataGridViewRow In ProviderNameGrid.Rows
            If dgvr.Cells("ProviderIsEditor").Value.ToString = Boolean.TrueString Then
                hasEd = True
                For Each c As DataGridViewCell In dgvr.Cells
                    If c.ColumnIndex <> 0 Then
                        c.Style.ForeColor = Color.OrangeRed
                    End If
                    c.Style.BackColor = Color.Gainsboro
                Next
            Else
                dgvr.DefaultCellStyle.BackColor = Color.Gainsboro
            End If
        Next

        If Not hasEd Then
            'show conflicting data
            For Each dgvr As DataGridViewRow In ProviderNameGrid.Rows
                For Each c As DataGridViewCell In dgvr.Cells

                    If c.ColumnIndex > 1 Then
                        Dim val As String = c.Value.ToString
                        Dim colName As String = ProviderNameGrid.Columns(c.ColumnIndex).HeaderText.ToString
                        Try
                            Dim consVal As String = CurrentName(NameMapping.MappingWithSourceCol(BrProviderNames.NameMappings, colName).NameMappingDestCol).ToString

                            If val <> consVal Then
                                c.Style.ForeColor = Color.IndianRed
                            End If

                        Catch ex As Exception
                            'catch errors for column names that dont match a Name column
                        End Try
                    End If
                Next
            Next
        End If

        For Each dgvr As DataGridViewRow In ProvConceptGrid.Rows
            If dgvr.Cells("ProviderIsEditor").Value.ToString = Boolean.TrueString Then
                dgvr.DefaultCellStyle.ForeColor = Color.OrangeRed
                dgvr.DefaultCellStyle.BackColor = Color.Gainsboro
            Else
                dgvr.DefaultCellStyle.BackColor = Color.Gainsboro
            End If
        Next

        For Each dgr As DataGridViewRow In OtherDataGrid.Rows
            dgr.DefaultCellStyle.BackColor = Color.Gainsboro
        Next
        OtherDataGrid.Columns(6).DefaultCellStyle.Font = New Font(OtherDataGrid.Font.FontFamily, OtherDataGrid.Font.Size, FontStyle.Underline)
        OtherDataGrid.Columns(6).DefaultCellStyle.ForeColor = Color.Blue
        OtherDataGrid.Columns(6).DefaultCellStyle.NullValue = "Generate..."

    End Sub

    Private Function SelectNamePopup(ByVal r As Row) As Boolean
        Dim fName As String = r("Field").ToString
        Dim sel As New SelectNameForm
        sel.ShowNoneOption = True
        Dim fk As String = GetNameGridValue(fName + "Fk").ToString
        If fk = "" Or fk = Guid.Empty.ToString Then fk = CurrentName("NameGuid").ToString
        sel.InitialNameId = fk
        If sel.ShowDialog = Windows.Forms.DialogResult.OK Then
            If sel.SelectedNameId Is Nothing Then 'clear
                r("Value") = Nothing
                r("LinkFk") = Nothing
                UpdateNameGridValue(fName + "Fk", Nothing)
            Else
                Dim val As String = sel.SelectedNameText
                If sel.SelectedNameId = Guid.Empty.ToString Then
                    val = "<none>"
                Else
                    Dim hName As String = r("Field").ToString + "History"
                    Dim hist As ListDictionary = NameHistory(hName)
                    If Not hist.Contains(sel.SelectedNameId) Then hist.Add(sel.SelectedNameId, sel.SelectedNameText)
                End If
                r("Value") = val
                r("LinkFk") = "SelectName=" + sel.SelectedNameId
                UpdateNameGridValue(fName + "Fk", sel.SelectedNameId)
            End If
            SaveButton.Enabled = True
            saveWithAttButton.Enabled = True
            CncButton.Enabled = True
            SaveEditsToolStripMenuItem.Enabled = True

            Return True
        End If

        Return False
    End Function

    Private Function SelectReferencePopup(ByVal r As Row) As Boolean
        Dim fName As String = r("Field").ToString
        If fName = "NamePublishedIn" Then
            fName = "NameReferenceFk"
        Else
            fName += "Fk"
        End If

        Dim sel As New SelectReferenceForm
        sel.ShowNoneOption = True
        If sel.ShowDialog = Windows.Forms.DialogResult.OK Then
            If sel.SelectedReferenceId Is Nothing Then 'clear
                r("Value") = Nothing
                r("LinkFk") = Nothing
                UpdateNameGridValue(fName, Nothing)
            Else
                Dim val As String = sel.SelectedReferenceText
                If sel.SelectedReferenceId = Guid.Empty.ToString Then
                    val = "<none>"
                Else
                    If Not ReferenceHistory.Contains(sel.SelectedReferenceId) Then ReferenceHistory.Add(sel.SelectedReferenceId, sel.SelectedReferenceText)
                End If
                r("Value") = val
                r("LinkFk") = "SelectReference=" + sel.SelectedReferenceId
                UpdateNameGridValue(fName, sel.SelectedReferenceId)
            End If
            SaveButton.Enabled = True
            saveWithAttButton.Enabled = True
            CncButton.Enabled = True
            SaveEditsToolStripMenuItem.Enabled = True

            Return True
        End If

        Return False
    End Function

    Private Function SelectConceptNamePopup(ByVal r As Row) As Boolean
        Dim sel As New SelectNameForm
        sel.ShowNoneOption = True
        Dim fk As String = ""
        If r("ConceptToName1Fk") IsNot Nothing Then r("ConceptToName1Fk").ToString()
        If fk = "" Or fk = Guid.Empty.ToString Then fk = CurrentName("NameGuid").ToString
        sel.InitialNameId = fk
        If sel.ShowDialog = Windows.Forms.DialogResult.OK Then
            If sel.SelectedNameId Is Nothing Then 'clear
                r("ConceptToName1Fk") = Nothing
                r("ConceptToName1") = Nothing
            Else
                Dim val As String = sel.SelectedNameText
                If sel.SelectedNameId = Guid.Empty.ToString Then
                    val = "<none>"
                Else
                    Dim hist As ListDictionary = NameHistory("ConceptName2History")
                    If Not hist.Contains(sel.SelectedNameId) Then hist.Add(sel.SelectedNameId, sel.SelectedNameText)
                End If
                r("ConceptToName1") = val
                r("ConceptToName1Fk") = sel.SelectedNameId
            End If
            SaveButton.Enabled = True
            saveWithAttButton.Enabled = True
            CncButton.Enabled = True
            SaveEditsToolStripMenuItem.Enabled = True

            Return True
        End If

        Return False
    End Function

    Private Function SelectConceptRefPopup(ByVal r As Row) As Boolean
        Dim sel As New SelectReferenceForm
        sel.ShowNoneOption = True
        'Dim fk As String = r("ConceptAccordingToFk").ToString
        If sel.ShowDialog = Windows.Forms.DialogResult.OK Then
            If sel.SelectedReferenceId Is Nothing Then 'clear
                r("ConceptAccordingToFk") = Nothing
                r("ConceptAccordingTo") = Nothing
            Else
                Dim val As String = sel.SelectedReferenceText
                If sel.SelectedReferenceId = Guid.Empty.ToString Then
                    val = "<none>"
                Else
                    If Not ReferenceHistory.Contains(sel.SelectedReferenceId) Then ReferenceHistory.Add(sel.SelectedReferenceId, sel.SelectedReferenceText)
                End If
                r("ConceptAccordingTo") = val
                r("ConceptAccordingToFk") = sel.SelectedReferenceId
            End If
            SaveButton.Enabled = True
            saveWithAttButton.Enabled = True
            CncButton.Enabled = True
            SaveEditsToolStripMenuItem.Enabled = True

            Return True
        End If

        Return False
    End Function

    Private Sub DeprecateCurrentPrviderConcept(ByVal rowIndex As Integer)
        If MsgBox("Are you sure you want to deprecate this provider concept?", MsgBoxStyle.YesNo, "Deprecate Provider Concept") = MsgBoxResult.Yes Then
            Windows.Forms.Cursor.Current = Cursors.WaitCursor

            Try
                Dim id As Integer = Integer.Parse(ProvConceptGrid.Rows(rowIndex).Cells("PCPk").Value.ToString)
                BrProviderConcepts.DeprecateProviderConcept(id)
            Catch ex As Exception
                MsgBox("Failed to deprecate concept")
                ChecklistException.LogError(ex)
            End Try

            RefreshNameScreen(CurrentName("NameGuid").ToString, False)

            Windows.Forms.Cursor.Current = Cursors.Default
        End If
    End Sub

    Private Sub SplitCurrentProviderName(ByVal rowIndex As Integer)

        Dim split As New SplitForm
        If split.ShowDialog = Windows.Forms.DialogResult.OK Then
            Dim newId As String = ""
            Windows.Forms.Cursor.Current = Cursors.WaitCursor

            Dim refresh As Boolean = True

            Try
                Dim id As Integer = Integer.Parse(ProviderNameGrid.Rows(rowIndex).Cells("PNPk").Value.ToString)

                If split.SelectedSplitType = SplitType.CreateNew Then
                    Dim newName As Name = BrProviderNames.SplitOffProviderName(id)
                    newId = newName.Id

                    'link up to parent, rank etc?
                    AddNameLinks(newName, True)
                ElseIf split.SelectedSplitType = SplitType.SelectExisting Then
                    Dim selForm As New SelectNameForm
                    selForm.InitialNameId = CurrentName("NameGuid").ToString
                    selForm.Title = "Select name to link to"
                    If selForm.ShowDialog = Windows.Forms.DialogResult.OK Then
                        BrProviderNames.SplitOffProviderName(id, selForm.SelectedNameId)
                        newId = selForm.SelectedNameId
                    Else
                        refresh = False
                    End If
                ElseIf split.SelectedSplitType = SplitType.Unlink Then
                    Dim ok As Boolean = True
                    If ProviderNameGrid.Rows.Count = 1 Then
                        Dim cn As List(Of Name) = NameData.GetNameChildren(Nothing, CurrentName("NameGuid").ToString)
                        If cn.Count > 0 Then
                            MsgBox("Cannot unlink the last provider name because child names are attached to this name.")
                            ok = False
                            refresh = False
                        Else
                            If MsgBox("Splitting off the last provider name will deprecate the consensus name resulting in a loss of the name LSID.  A better option is to merge this name with the name appropriate for this provider name.  Continue?", MsgBoxStyle.YesNo, "Split") = MsgBoxResult.No Then
                                ok = False
                                refresh = False
                            Else
                                newId = CurrentName("NameParentFk").ToString
                            End If
                        End If
                    Else
                        newId = CurrentName("NameGuid").ToString
                    End If

                    If ok Then
                        BrProviderNames.SplitOffProviderName(id, Nothing)
                    End If
                Else
                    'discard
                    Dim res As DialogResult = MessageBox.Show("The data for this provider record will be permanently deleted from the database.  Are you sure you want to proceed?", "Discard provider record", MessageBoxButtons.YesNo, MessageBoxIcon.Warning)
                    If res = Windows.Forms.DialogResult.No Then
                        refresh = False
                    Else
                        Dim ok As Boolean = True
                        If ProviderNameGrid.Rows.Count = 1 Then
                            Dim cn As List(Of Name) = NameData.GetNameChildren(Nothing, CurrentName("NameGuid").ToString)
                            If cn.Count > 0 Then
                                MsgBox("Cannot discard the last provider name because child names are attached to this name.")
                                ok = False
                                refresh = False
                            Else
                                If MsgBox("Discarding the last provider name will deprecate the consensus name resulting in a loss of the name LSID.  A better option is to merge this name with the name appropriate for this provider name.  Continue?", MsgBoxStyle.YesNo, "Split") = MsgBoxResult.No Then
                                    ok = False
                                    refresh = False
                                Else
                                    newId = CurrentName("NameParentFk").ToString
                                End If
                            End If
                        Else
                            newId = CurrentName("NameGuid").ToString
                        End If

                        If ok Then
                            BrProviderNames.DiscardProviderName(id)
                        End If
                    End If
                End If
            Catch ex As Exception
                MsgBox("Failed to split provider name")
                ChecklistException.LogError(ex)
            End Try

            'refresh screen
            If refresh Then RefreshNameScreen(newId, True)

            Windows.Forms.Cursor.Current = Cursors.Default
        End If
    End Sub

    Private Sub AddNameLinks(ByVal n As Name, ByVal addSysName As Boolean)
        'add the essential name links if they are missing

        Dim addSysParent As Boolean = False

        'parent?
        If n.NameParentFk Is Nothing OrElse n.NameParentFk.ToLower = NameData.GetUknownTaxaGuid().ToLower Then
            Dim selForm As New SelectNameForm
            Dim pid As String
            If CurrentName IsNot Nothing Then pid = CurrentName("NameParentFk").ToString
            selForm.InitialNameId = pid
            selForm.Title = "Select parent name for the new name"
            If selForm.ShowDialog = Windows.Forms.DialogResult.OK Then
                n.NameParentFk = selForm.SelectedNameId
                n.NameParent = selForm.SelectedNameText

                addSysParent = True
            End If
        End If

        'rank?
        If n.NameRankFk = -1 Then
            Dim rnkForm As New SelectRankForm
            If rnkForm.ShowDialog = Windows.Forms.DialogResult.OK Then
                n.NameRankFk = rnkForm.SelectedRank.IdAsInt
                n.NameRank = rnkForm.SelectedRank.Name
            End If
        End If

        'canonical
        If n.NameCanonical Is Nothing OrElse n.NameCanonical.Length = 0 Then
            Dim grab As New GrabTextForm
            grab.Title = "Enter canonical for new name"
            If grab.ShowDialog = Windows.Forms.DialogResult.OK Then
                n.NameCanonical = grab.TextValue
            End If
        End If

        NameData.UpdateName(n, SessionState.CurrentUser.Login)

        If addSysName Then
            'add system provider name for this name

            Dim pn As New ProviderName
            pn.PNNameId = Guid.NewGuid.ToString
            pn.PNNameFk = n.Id
            pn.PNNameFull = n.NameFull
            pn.PNNameCanonical = n.NameCanonical
            pn.PNNameRank = n.NameRank
            pn.PNNameRankFk = n.NameRankFk

            BrProviderNames.InsertUpdateSystemProviderName(n.Id, pn)

            If addSysParent Then
                Dim parPN As ProviderName = NameData.GetSystemProviderNameForName(n.NameParentFk)
                If parPN Is Nothing Then
                    parPN = New ProviderName
                    parPN.PNNameFk = n.NameParentFk
                    parPN.PNNameId = Guid.NewGuid.ToString

                    BrProviderNames.InsertUpdateSystemProviderName(n.NameParentFk, parPN)
                End If

                BrProviderConcepts.InsertUpdateSystemProviderConcept(n.Id, n.NameParentFk, RelationshipType.RelationshipTypeParent, Nothing)
            End If
        End If
    End Sub

#End Region

#Region "Reference Details"

    Private Sub GetReference(ByVal refId As String)
        Dim ds As DataSet = ReferenceData.GetReferenceDs(refId)
        If Not ds Is Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then
            CurrentReference = ds.Tables(0).Rows(0)
        End If

        ds = ReferenceData.GetReferenceRISByReferenceDs(refId)
        If ds IsNot Nothing AndAlso ds.Tables.Count > 0 AndAlso ds.Tables(0).Rows.Count > 0 Then CurrentReferenceRIS = ds.Tables(0)

        Dim pr As ProviderReference = ReferenceData.GetSystemProviderRefForRef(refId)
        Dim pris As ProviderRIS
        If pr IsNot Nothing Then pris = ReferenceData.GetProviderRISByReference(pr.Id)
        If pris IsNot Nothing Then
            FieldStatusDs = ChecklistDataAccess.FieldStatusData.LoadStatus(pris.Id, "tblProviderRIS")
        End If

        ProviderRefRecords = ReferenceData.GetProviderReferenceRecords(refId)
        ProviderRISRecords = ReferenceData.GetProviderRISByReferenceGuidDs(refId)
    End Sub

    Private Sub DisplayReference(ByVal referenceGuid As String)
        If CurrentReference IsNot Nothing Then
            RefLSIDText.Text = CurrentReference("ReferenceLSID").ToString
            RefCitationText.Text = CurrentReference("ReferenceCitation").ToString
            FullCitationText.Text = CurrentReference("ReferenceFullCitation").ToString

            Dim dt As New DataTable
            dt.Columns.Add("Field")
            dt.Columns.Add("Value", GetType(Object))
            dt.Columns.Add("Status", GetType(Integer))
            dt.Columns.Add("LinkFk")

            If CurrentReferenceRIS IsNot Nothing AndAlso CurrentReferenceRIS.Rows.Count > 0 Then
                For Each col As DataColumn In CurrentReferenceRIS.Columns
                    Dim field As String = RISMapping.SourceColumnNameOfDest(BrProviderReferences.RISMappings, col.ColumnName)
                    If col.ColumnName = "RISPk" Then field = "PRISPk"
                    Dim sr As DataRow
                    If FieldStatusDs IsNot Nothing Then sr = FieldStatusData.GetProviderReferenceFieldStatus(FieldStatusDs, field)
                    Dim stat As Integer = -1
                    If sr IsNot Nothing AndAlso Not sr.IsNull("FieldStatusLevelFk") Then stat = sr("FieldStatusLevelFk")

                    AddTextRow(dt, col.ColumnName, CurrentReferenceRIS.Rows(0)(col.ColumnName).ToString, stat)
                Next

                'RefCitationText.ReadOnly = True
                FullCitationText.ReadOnly = True
            Else
                'no RIS, so ref is editable
                'RefCitationText.ReadOnly = False
                FullCitationText.ReadOnly = Not EditMode
            End If

            dt.AcceptChanges()

            RefDetailsGrid.DataSource = dt.DefaultView


            'provider records
            If ProviderRISRecords IsNot Nothing Then
                ProviderRISGrid.DataSource = ProviderRISRecords
                ProviderRISGrid.DataMember = ProviderRISRecords.Tables(0).TableName
            End If
            If ProviderRefRecords IsNot Nothing AndAlso ProviderRefRecords.Tables.Count > 0 Then
                RefProviderGrid.DataSource = ProviderRefRecords
                RefProviderGrid.DataMember = ProviderRefRecords.Tables(0).TableName
            End If

            SetRefGridFormatting()

            RefProviderGrid.ClearSelection()
        End If
    End Sub

    Private Sub SetRefGridFormatting()

        RefDetailsGrid.Cols("LinkFk").Visible = False
        RefDetailsGrid.Rows.DefaultSize = 20

        RefDetailsGrid.ShowButtons = ShowButtonsEnum.Always

        RefDetailsGrid.Cols("Value").TextAlign = TextAlignEnum.LeftCenter
        RefDetailsGrid.Cols("Status").TextAlign = TextAlignEnum.LeftCenter

        RefDetailsGrid.Cols("Field").Width = 190
        RefDetailsGrid.Cols("Value").Width = 350
        RefDetailsGrid.Cols("Status").Width = 150
        RefDetailsGrid.Cols("LinkFk").Visible = False

        RefDetailsGrid.Cols("Field").StyleNew.BackColor = Color.LightGray

        UpdateRefEditStyles()
        UpdateProviderRefGridColours()

        RefDetailsGrid.AllowEditing = EditMode
    End Sub

    Private Sub UpdateRefEditStyles()
        Dim statStyle As CellStyle = RefDetailsGrid.Styles("StatusStyle")
        If statStyle Is Nothing Then
            statStyle = RefDetailsGrid.Styles.Add("StatusStyle", "Normal")
            Dim sdt As New ListDictionary
            For Each s As DataRow In FieldStatusData.AuxFieldStatusData.Tables("tblFieldStatusLevel").Rows
                sdt.Add(s("FieldStatusLevelCounterPk"), s("FieldStatusLevelText"))
            Next
            sdt.Add(-1, "<Clear>")
            statStyle.DataMap = sdt
        End If

        Dim dtStyle As CellStyle = RefDetailsGrid.Styles("DateStyle")
        If dtStyle Is Nothing Then
            dtStyle = RefDetailsGrid.Styles.Add("DateStyle", "Normal")
            dtStyle.DataType = GetType(DateTime)
        End If

        Dim typeStyle As CellStyle = RefDetailsGrid.Styles("TypeStyle")
        If typeStyle Is Nothing Then
            typeStyle = RefDetailsGrid.Styles.Add("TypeStyle", "Normal")
            Dim ts As New ListDictionary
            Dim ds As DataSet = ReferenceData.ListRISTypes()
            For Each r As DataRow In ds.Tables(0).Rows
                ts.Add(r("RISTypeName"), r("RISTypeName"))
            Next
            typeStyle.DataMap = ts
        End If

        For Each r As Row In RefDetailsGrid.Rows
            If r.Index = 0 Then Continue For

            'validation levels
            RefDetailsGrid.SetCellStyle(r.Index, 2, statStyle)

            'date?
            'If r("Field").ToString = "RISDate" Then
            '    RefDetailsGrid.SetCellStyle(r.Index, 1, dtStyle)
            'End If

            If r("Field").ToString = "RISType" Then
                RefDetailsGrid.SetCellStyle(r.Index, 1, typeStyle)
            End If

            'hidden fields
            If HiddenRefColumns.IndexOf(r("Field").ToString) <> -1 Then
                r.Visible = False
            End If
        Next
    End Sub

    Private Sub UpdateProviderRefGridColours()
        For Each dgvr As DataGridViewRow In RefProviderGrid.Rows
            If dgvr.Cells("ProviderIsEditor").Value.ToString = Boolean.TrueString Then
                For Each c As DataGridViewCell In dgvr.Cells
                    If c.ColumnIndex <> 0 Then
                        c.Style.ForeColor = Color.OrangeRed
                    End If
                    c.Style.BackColor = Color.Gainsboro
                Next
            Else
                dgvr.DefaultCellStyle.BackColor = Color.Gainsboro
            End If
        Next

        For Each dgvr As DataGridViewRow In ProviderRISGrid.Rows
            If dgvr.Cells("ProviderIsEditor").Value.ToString = Boolean.TrueString Then
                For Each c As DataGridViewCell In dgvr.Cells
                    If c.ColumnIndex <> 0 Then
                        c.Style.ForeColor = Color.OrangeRed
                    End If
                    c.Style.BackColor = Color.Gainsboro
                Next
            Else
                dgvr.DefaultCellStyle.BackColor = Color.Gainsboro
            End If
        Next
    End Sub

    Private Sub SplitCurrentProviderReference(ByVal rowIndex As Integer)

        Dim split As New SplitForm
        If split.ShowDialog = Windows.Forms.DialogResult.OK Then
            Dim newId As String = ""
            Windows.Forms.Cursor.Current = Cursors.WaitCursor

            Dim refresh As Boolean = True

            Try
                Dim id As Integer = Integer.Parse(RefProviderGrid.Rows(rowIndex).Cells("PRPk").Value.ToString)

                If split.SelectedSplitType = SplitType.CreateNew Then
                    Dim newRef As Reference = BrProviderReferences.SplitOffProviderReference(id)
                    newId = newRef.Id
                ElseIf split.SelectedSplitType = SplitType.SelectExisting Then
                    Dim selForm As New SelectReferenceForm
                    selForm.Title = "Select reference to link to"
                    If selForm.ShowDialog = Windows.Forms.DialogResult.OK Then
                        BrProviderReferences.SplitOffProviderReference(id, selForm.SelectedReferenceId)
                        newId = selForm.SelectedReferenceId
                    Else
                        refresh = False
                    End If
                Else
                    BrProviderReferences.SplitOffProviderReference(id, Nothing)
                    newId = CurrentReference("ReferenceGuid").ToString 'leave screen on this name
                End If
            Catch ex As Exception
                MsgBox("Failed to split provider reference")
                ChecklistException.LogError(ex)
            End Try

            'refresh screen
            If refresh Then RefreshRefScreen(newId)

            Windows.Forms.Cursor.Current = Cursors.Default
        End If
    End Sub

#End Region

#Region "Provider Details"

    Private Sub GetProviders()
        ProviderDs = ProviderData.GetProvidersDs()
        ProvidersGrid.DataSource = ProviderDs.Tables(0)
    End Sub

    Private Sub TabPageProviders_Enter(ByVal sender As Object, ByVal e As System.EventArgs) Handles TabPageProviders.Enter
        If ProviderDs Is Nothing Then GetProviders()
    End Sub

    Private Sub ViewProvNamesButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ViewProvNamesButton.Click
        If CurrentProvider IsNot Nothing Then
            Try
                Dim pnform As New ProviderNameRecordsForm
                pnform.ProviderPk = CurrentProvider("ProviderPk")
                Dim res As DialogResult = pnform.ShowDialog()
                If res = Windows.Forms.DialogResult.OK Then
                    Dim id As String
                    If CurrentName IsNot Nothing Then id = CurrentName("NameGuid").ToString
                    RefreshNameScreen(id, True)
                ElseIf res = Windows.Forms.DialogResult.Yes Then
                    ClearNameDetails()
                    GotoLink("SelectName=" + pnform.SelectedRecord.PNNameFk)
                End If
            Catch ex As Exception
                ChecklistException.LogError(ex)
            End Try
        End If
    End Sub

    Private Sub ProvidersGrid_CellEndEdit(ByVal sender As Object, ByVal e As System.Windows.Forms.DataGridViewCellEventArgs) Handles ProvidersGrid.CellEndEdit
        SaveButton.Enabled = True
        saveWithAttButton.Enabled = True
        CncButton.Enabled = True
        SaveEditsToolStripMenuItem.Enabled = True
    End Sub

    Private Sub ProvidersGrid_RowEnter(ByVal sender As Object, ByVal e As System.Windows.Forms.DataGridViewCellEventArgs) Handles ProvidersGrid.RowEnter
        CurrentProvider = Nothing
        Try
            CurrentProvider = ProviderDs.Tables(0).Rows(e.RowIndex)
        Catch ex As Exception
        End Try
    End Sub

    Private Sub AddProviderButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles AddProviderButton.Click
        Dim pf As New ProviderForm
        pf.AllProviders = ProviderDs
        If pf.ShowDialog() = Windows.Forms.DialogResult.OK Then
            Try
                ChecklistDataAccess.ProviderData.InsertUpdateProvider(pf.TheProvider, SessionState.CurrentUser.Login)
                GetProviders()
            Catch ex As Exception
                MsgBox("Failed to create provider")
                ChecklistException.LogError(ex)
            End Try
        End If
    End Sub

    Private Sub EditProviderButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles EditProviderButton.Click
        If CurrentProvider IsNot Nothing Then
            Dim pf As New ProviderForm
            pf.AllProviders = ProviderDs
            pf.TheProvider = New Provider(CurrentProvider)
            If pf.ShowDialog() = Windows.Forms.DialogResult.OK Then
                Try
                    ChecklistDataAccess.ProviderData.InsertUpdateProvider(pf.TheProvider, SessionState.CurrentUser.Login)
                    GetProviders()
                Catch ex As Exception
                    MsgBox("Failed to create provider")
                    ChecklistException.LogError(ex)
                End Try
            End If
        End If
    End Sub

    Private Sub ProvRefButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ProvRefButton.Click
        If CurrentProvider IsNot Nothing Then
            Try
                Dim pnform As New ProviderRefRecordsForm
                pnform.ProviderPk = CurrentProvider("ProviderPk")
                Dim res As DialogResult = pnform.ShowDialog()
                If res = Windows.Forms.DialogResult.OK Then
                    Dim id As String
                    If CurrentReference IsNot Nothing Then id = CurrentReference("ReferenceGuid").ToString
                    RefreshRefScreen(id)
                ElseIf res = Windows.Forms.DialogResult.Yes Then
                    ClearRefDetails()
                    GotoLink("SelectReference=" + pnform.SelectedRecord.PRReferenceFk)
                End If
            Catch ex As Exception
                ChecklistException.LogError(ex)
            End Try
        End If
    End Sub

#End Region

#Region "Reports"

    Private Sub ReportsControl_BeforeBrowse(ByVal e As System.Windows.Forms.WebBrowserNavigatingEventArgs, ByVal rep As Report) Handles ReportsControl1.BeforeBrowse, ReportsControlOnNames.BeforeBrowse
        If e.Url.PathAndQuery.ToLower.IndexOf("&action=goto") <> -1 Then
            If e.Url.PathAndQuery.ToLower.IndexOf("&type=providername") <> -1 Then
                Try
                    Dim pkStr As String = e.Url.PathAndQuery.Substring(e.Url.PathAndQuery.ToLower.IndexOf("&recordid=") + 10)
                    Dim pos As Integer = pkStr.IndexOf("&")
                    If pos <> -1 Then pkStr = pkStr.Substring(0, pos)

                    Dim pk As Integer = Integer.Parse(pkStr)

                    Dim pForm As New ProviderNameForm
                    pForm.PNPk = pk
                    If pForm.ShowDialog() = Windows.Forms.DialogResult.Yes Then
                        If pForm.NameFk IsNot Nothing Then
                            If TabControl1.SelectedIndex <> 0 Then
                                LinkToName = pForm.NameFk
                                TabControl1.SelectedIndex = 0
                            Else
                                NameSelector1.SelectNode(pForm.NameFk)
                            End If
                        End If
                    End If
                Catch ex As Exception
                    ChecklistException.LogError(ex)
                End Try
            ElseIf e.Url.PathAndQuery.ToLower.IndexOf("&type=name") <> -1 Then
                Dim pkStr As String = e.Url.PathAndQuery.Substring(e.Url.PathAndQuery.ToLower.IndexOf("&recordid=") + 10)
                Dim pos As Integer = pkStr.IndexOf("&")
                If pos <> -1 Then pkStr = pkStr.Substring(0, pos)

                LinkToName = pkStr
                TabControl1.SelectedIndex = 0
            ElseIf e.Url.PathAndQuery.ToLower.IndexOf("&type=providerreference") <> -1 Then
                Try
                    Dim pkStr As String = e.Url.PathAndQuery.Substring(e.Url.PathAndQuery.ToLower.IndexOf("&recordid=") + 10)
                    Dim pos As Integer = pkStr.IndexOf("&")
                    If pos <> -1 Then pkStr = pkStr.Substring(0, pos)

                    Dim pk As Integer = Integer.Parse(pkStr)

                    Dim pForm As New ProviderReferenceForm
                    pForm.PRPk = pk
                    pForm.ShowDialog()
                Catch ex As Exception
                    ChecklistException.LogError(ex)
                End Try

            ElseIf e.Url.PathAndQuery.ToLower.IndexOf("&type=providerconcept") <> -1 Then
                Try
                    Dim pkStr As String = e.Url.PathAndQuery.Substring(e.Url.PathAndQuery.ToLower.IndexOf("&recordid=") + 10)
                    Dim pos As Integer = pkStr.IndexOf("&")
                    If pos <> -1 Then pkStr = pkStr.Substring(0, pos)

                    Dim pk As Integer = Integer.Parse(pkStr)

                    Dim pc As DataSet = ConceptData.GetProviderConceptRelationshipDs(pk)
                    Dim pn As ProviderName = NameData.GetProviderName(pc.Tables(0).Rows(0)("ProviderPk"), pc.Tables(0).Rows(0)("PCName1Id").ToString)

                    Dim pForm As New ProviderNameForm
                    pForm.PNPk = pn.IdAsInt
                    If pForm.ShowDialog() = Windows.Forms.DialogResult.Yes Then
                        If pn.PNNameFk IsNot Nothing Then
                            If TabControl1.SelectedIndex <> 0 Then
                                LinkToName = pn.PNNameFk
                                TabControl1.SelectedIndex = 0
                            Else
                                NameSelector1.SelectNode(pn.PNNameFk)
                            End If
                        End If
                    End If
                Catch ex As Exception
                    ChecklistException.LogError(ex)
                End Try
            End If

            e.Cancel = True

        ElseIf e.Url.PathAndQuery.ToLower.IndexOf("&action=multiplematch") <> -1 Then
            Try
                Dim pkStr As String = e.Url.PathAndQuery.Substring(e.Url.PathAndQuery.ToLower.IndexOf("&recordid=") + 10)
                Dim pos As Integer = pkStr.IndexOf("&")
                If pos <> -1 Then pkStr = pkStr.Substring(0, pos)

                Dim pk As Integer = Integer.Parse(pkStr)

                Dim mmf As New MultipleMatchesForm
                mmf.RecordId = pk

                mmf.ShowDialog()
            Catch ex As Exception
                ChecklistException.LogError(ex)
            End Try

            e.Cancel = True

        ElseIf e.Url.PathAndQuery.ToLower.IndexOf("&action=ignore") <> -1 Then
            Dim ok As Boolean = False
            Try
                Dim pkStr As String = e.Url.PathAndQuery.Substring(e.Url.PathAndQuery.ToLower.IndexOf("&recordid=") + 10)
                Dim pos As Integer = pkStr.IndexOf("&")
                If pos <> -1 Then pkStr = pkStr.Substring(0, pos)

                Dim tblName As String = ""
                If e.Url.PathAndQuery.ToLower.IndexOf("&type=providername") <> -1 Then tblName = "tblProviderName"
                If e.Url.PathAndQuery.ToLower.IndexOf("&type=providerreference") <> -1 Then tblName = "tblProviderReference"
                If e.Url.PathAndQuery.ToLower.IndexOf("&type=providerconcept") <> -1 Then tblName = "tblProviderConcept"
                If e.Url.PathAndQuery.ToLower.IndexOf("&type=name") <> -1 Then tblName = "tblName"

                BrReports.IgnoreReportError(rep, pkStr, tblName)

                ok = True
            Catch ex As Exception
                ChecklistException.LogError(ex)
            End Try

            If ok Then
                MsgBox("Error status set to Ignore")
            Else
                MsgBox("Failed to set error status")
            End If

            e.Cancel = True
        ElseIf e.Url.PathAndQuery.ToLower.IndexOf("&action=refreshname") <> -1 Then
            Dim ok As Boolean = False
            Windows.Forms.Cursor.Current = Cursors.WaitCursor
            Try
                Dim id As String = e.Url.PathAndQuery.Substring(e.Url.PathAndQuery.ToLower.IndexOf("&recordid=") + 10)
                id = id.Remove(id.IndexOf("&"))

                BrNames.RefreshNameData(id, True)

                ok = True
            Catch ex As Exception

                Windows.Forms.Cursor.Current = Cursors.Default
                ChecklistException.LogError(ex)
            End Try
            Windows.Forms.Cursor.Current = Cursors.Default

            If Not ok Then
                MsgBox("Failed to refresh name")
            End If

            e.Cancel = True

        ElseIf e.Url.PathAndQuery.ToLower.IndexOf("&action=deletename") <> -1 Then
            Dim ok As Boolean = False

            Dim msg As DialogResult = MsgBox("Are you sure?", MsgBoxStyle.YesNo, "Delete name")
            If msg = Windows.Forms.DialogResult.Yes Then
                Windows.Forms.Cursor.Current = Cursors.WaitCursor
                Try
                    Dim id As String = e.Url.PathAndQuery.Substring(e.Url.PathAndQuery.ToLower.IndexOf("&recordid=") + 10)
                    id = id.Remove(id.IndexOf("&"))

                    NameData.DeleteNameRecord(Nothing, "urn:lsid:compositae.org:names:" + id, "unlinked", SessionState.CurrentUser.Login)

                    ok = True
                Catch ex As Exception

                    Windows.Forms.Cursor.Current = Cursors.Default
                    ChecklistException.LogError(ex)
                End Try
                Windows.Forms.Cursor.Current = Cursors.Default

                If Not ok Then
                    MsgBox("Failed to refresh name")
                End If
            End If

            e.Cancel = True

        ElseIf e.Url.PathAndQuery.ToLower.IndexOf("&action=linkparent") <> -1 Then
            Dim ok As Boolean = False

            Try
                Dim id As String = e.Url.PathAndQuery.Substring(e.Url.PathAndQuery.ToLower.IndexOf("&recordid=") + 10)
                Dim pos As Integer = id.IndexOf("&")
                If pos <> -1 Then id = id.Substring(0, pos)

                Dim n As Name = NameData.GetName(Nothing, id)

                Dim selForm As New SelectNameForm
                selForm.InitialNameId = id
                If selForm.ShowDialog() = Windows.Forms.DialogResult.OK Then
                    Windows.Forms.Cursor.Current = Cursors.WaitCursor

                    Dim pn As ProviderName = NameData.GetSystemProviderNameForName(id)
                    If pn Is Nothing Then
                        pn = New ProviderName
                        pn.PNNameId = Guid.NewGuid.ToString
                        pn.PNNameFk = id
                        pn.PNLinkStatus = LinkStatus.Inserted.ToString
                    End If

                    BrProviderNames.InsertUpdateSystemProviderName(id, pn)

                    BrProviderConcepts.InsertUpdateSystemProviderConcept(id, selForm.SelectedNameId, ParentRelationshipFk, Nothing)

                    BrNames.RefreshNameData(id, True)

                    Windows.Forms.Cursor.Current = Cursors.Default
                End If

                ok = True
            Catch ex As Exception
                Windows.Forms.Cursor.Current = Cursors.Default
                ChecklistException.LogError(ex)
            End Try

            If Not ok Then
                MsgBox("Failed to link parent")
            End If

            e.Cancel = True
            End If
    End Sub

#End Region

    Private Sub AboutToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles AboutToolStripMenuItem.Click
        Dim abDlg As New AboutForm
        abDlg.ShowDialog()
    End Sub

    Private Sub RefNamesInRefLink_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles RefNamesInRefLink.LinkClicked
        Try
            Dim refNames As New RefreshNamesForm
            Dim names As ArrayList = BrNames.GetNamesInReference(CurrentReference("ReferenceGuid").ToString)
            refNames.NamesList = names
            refNames.ShowDialog()
        Catch ex As Exception
            MsgBox("Failed to refresh reference")
            ChecklistException.LogError(ex)
        End Try
    End Sub

    Private Sub RefRefLink_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles RefRefLink.LinkClicked
        Cursor.Current = Cursors.WaitCursor
        Try
            BrReferences.RefreshReferenceData(CurrentReference("ReferenceGuid").ToString)
            RefreshRefScreen(CurrentReference("ReferenceGuid").ToString)
        Catch ex As Exception
            MsgBox("Failed to refresh reference")
            ChecklistException.LogError(ex)
        End Try
        Cursor.Current = Cursors.Default
    End Sub

#Region "Other Data"

#End Region

    Private Sub OtherDataCtrl1_OtherDataEdited() Handles OtherDataCtrl1.OtherDataEdited
        SaveButton.Enabled = True
        saveWithAttButton.Enabled = True
        CncButton.Enabled = True
        SaveEditsToolStripMenuItem.Enabled = True
    End Sub

    Private Sub OtherDataGrid_CellBeginEdit(ByVal sender As Object, ByVal e As System.Windows.Forms.DataGridViewCellCancelEventArgs) Handles OtherDataGrid.CellBeginEdit
        If Not EditMode Or e.ColumnIndex <> 0 Then
            e.Cancel = True
        Else
            If OtherDataGrid.Item("OutputTypeFk", e.RowIndex).Value.ToString = "" Then
                MsgBox("This record cannot be edited because there is no mapping defined for the output transformation.  Edit this in the Other Data screen first.")
                e.Cancel = True
            Else
                SaveButton.Enabled = True
                saveWithAttButton.Enabled = True
                CncButton.Enabled = True
                SaveEditsToolStripMenuItem.Enabled = True
            End If
        End If
    End Sub

    Private Sub OtherDataGrid_CellContentClick(ByVal sender As Object, ByVal e As System.Windows.Forms.DataGridViewCellEventArgs) Handles OtherDataGrid.CellContentClick
        If e.ColumnIndex = 6 And e.RowIndex >= 0 Then
            'display xml
            Try
                Dim xml As String = OtherDataGrid.Item(e.ColumnIndex, e.RowIndex).Value.ToString
                If xml = "" Then 'null
                    If OtherDataGrid.Item("OutputTypeFk", e.RowIndex).Value.ToString = "" Then
                        MsgBox("This record cannot be edited because there is no mapping defined for the output transformation.  Edit this in the Other Data screen first.")
                        Return
                    End If

                    BrOtherData.UpdateOtherDataStandrdOutput(OtherDataDs)
                    xml = OtherDataGrid.Item(e.ColumnIndex, e.RowIndex).Value.ToString
                End If

                Dim dispFm As New ViewXmlForm
                dispFm.Xml = xml
                Dim consXml As String = BrOtherData.GetConsensusXml(CurrentName("NameGuid").ToString, OtherDataGrid.Item("OutputTypeFk", e.RowIndex).Value)
                Dim webXslt As String = OtherDataGrid.Item("WebXslt", e.RowIndex).Value.ToString()
                dispFm.WebHtml = Utility.XsltTranslate(consXml, webXslt)
                dispFm.ShowDialog()
            Catch ex As Exception
            End Try
        End If
    End Sub

    Private Sub MoveNamesWithDiffPrefParentToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MoveNamesWithDiffPrefParentToolStripMenuItem.Click
        Try
            Dim mvFm As New MoveDiffParentsForm
            mvFm.ShowDialog()
        Catch ex As Exception
            ChecklistException.LogError(ex)
            MsgBox("Failed to update names")
        End Try
    End Sub

    Private Sub ImportMergeFileToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ImportMergeFileToolStripMenuItem.Click
        Dim mergeForm As New ImportMergeForm
        mergeForm.ShowDialog()

    End Sub

    Private Sub saveWithAttButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles saveWithAttButton.Click
        Dim dlg As New SelectUserForm
        If dlg.ShowDialog = Windows.Forms.DialogResult.OK Then
            Dim oldUser As User = SessionState.CurrentUser

            SessionState.CurrentUser = dlg.SelectedUser

            If Save(False) Then
                Windows.Forms.Cursor.Current = Cursors.WaitCursor
                If CurrentName IsNot Nothing Then RefreshNameScreen(CurrentName("NameGuid").ToString, False)
                If CurrentReference IsNot Nothing Then RefreshRefScreen(CurrentReference("ReferenceGuid").ToString)
                OtherDataCtrl1.Initialise()
                GetProviders()
                Windows.Forms.Cursor.Current = Cursors.Default
            Else
                If PartialSave Then
                    MsgBox("Failed to completely save the changes.  The current details have been reloaded.  The consensus data may need refreshing.")

                    Windows.Forms.Cursor.Current = Cursors.WaitCursor
                    If CurrentName IsNot Nothing Then RefreshNameScreen(CurrentName("NameGuid").ToString, False)
                    If CurrentReference IsNot Nothing Then RefreshRefScreen(CurrentReference("ReferenceGuid").ToString)
                    OtherDataCtrl1.Initialise()
                    GetProviders()
                    Windows.Forms.Cursor.Current = Cursors.Default
                Else
                    MsgBox("Failed to save data")
                End If
            End If

            SessionState.CurrentUser = oldUser
        End If
    End Sub

    Private Sub ImportAnnotationsToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ImportAnnotationsToolStripMenuItem.Click
        Dim annForm As New ImportAnnotationForm
        annForm.ShowDialog()
    End Sub
End Class

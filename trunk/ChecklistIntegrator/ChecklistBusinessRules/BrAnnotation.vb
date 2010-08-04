Imports ChecklistDataAccess
Imports ChecklistObjects

Public Enum AnnotationEditType
    None
    UpdateDetails
    UpdateAcceptedName
    UpdateParentName
    DataError
End Enum

Public Class AnnotationEdit
    Private _NameID As String = ""
    Private _FullName As String = ""
    Private _Comment As String = ""
    Private _UpdateType As AnnotationEditType = AnnotationEditType.None

    Public Property NameID() As String
        Get
            Return _NameID
        End Get
        Set(ByVal value As String)
            _NameID = value
        End Set
    End Property

    Public Property FullName() As String
        Get
            Return _FullName
        End Get
        Set(ByVal value As String)
            _FullName = value
        End Set
    End Property

    Public Property Comment() As String
        Get
            Return _Comment
        End Get
        Set(ByVal value As String)
            _Comment = value
        End Set
    End Property

    Public Property UpdateType() As AnnotationEditType
        Get
            Return _UpdateType
        End Get
        Set(ByVal value As AnnotationEditType)
            _UpdateType = value
        End Set
    End Property
End Class


Public Class BrAnnotation

    Public Shared Function ImportAnnotations(ByVal updateUser As User, ByVal filename As String) As List(Of AnnotationEdit)
        Dim edits As New List(Of AnnotationEdit)

        Try

            Dim ds As DataSet = GetFileDs(filename)

            For Each row As DataRow In ds.Tables(0).Rows
                Dim ae As New AnnotationEdit
                Try
                    If row("NeedsUpdating").ToString.Length > 0 Then
                        Dim nameId As String = row("NameGuid").ToString.ToUpper

                        ae.NameID = nameId
                        ae.FullName = row("NameFull").ToString

                        Dim hasChanges As Boolean = False
                        Dim hasConceptChange As Boolean = False
                        Dim nm As DataRow = NameData.GetNameDs(Nothing, nameId).Tables(0).Rows(0)

                        Dim pn As New ProviderName
                        pn.PNNameFk = nameId

                        For i As Integer = 2 To ds.Tables(0).Columns.Count - 1
                            Dim col As String = ds.Tables(0).Columns(i).ColumnName
                            If col = "NameRank" Then
                                If row(i) <> nm("NameRank") Then
                                    Dim rnk As Rank = RankData.RankByName(row(i))
                                    If rnk IsNot Nothing Then
                                        pn.PNNameRank = row(i)
                                        pn.PNNameRankFk = rnk.IdAsInt
                                        hasChanges = True
                                    Else
                                        ae.UpdateType = AnnotationEditType.DataError
                                        ae.Comment = "Rank cannot be determined"
                                        edits.Add(ae)

                                        ae = New AnnotationEdit
                                        ae.NameID = nameId
                                        ae.FullName = row("NameFull").ToString
                                    End If
                                End If
                            ElseIf col = "NameParent" Then
                                If row(i) <> nm("NameParent") Then
                                    Dim ss As New SearchStruct
                                    ss.AnywhereInText = False
                                    ss.Field = "NameFull"
                                    ss.SearchText = row(i)
                                    Dim ss2 As New SearchStruct
                                    Dim npDs As DataSet = Search.SelectSearchResults(1, ss, False, ss2)
                                    If npDs Is Nothing OrElse npDs.Tables(0).Rows.Count <> 1 Then
                                        ae.UpdateType = AnnotationEditType.DataError
                                        ae.Comment = "Exact Parent Name cannot be determined (" + row(i).ToString + ")"
                                        edits.Add(ae)

                                        ae = New AnnotationEdit
                                        ae.NameID = nameId
                                        ae.FullName = row("NameFull").ToString
                                    Else
                                        Dim parId As String = npDs.Tables(0).Rows(0)("NameGuid").ToString.ToUpper

                                        SaveNameConcept(updateUser, nameId, RelationshipType.RelationshipTypeParent, parId)

                                        hasConceptChange = True
                                        ae.UpdateType = AnnotationEditType.UpdateParentName
                                        edits.Add(ae)
                                    End If
                                End If
                            ElseIf col = "NamePreferred" Then
                                If row(i) <> nm("NamePreferred") Then
                                    Dim ss As New SearchStruct
                                    ss.AnywhereInText = False
                                    ss.Field = "NameFull"
                                    ss.SearchText = row(i)
                                    Dim ss2 As New SearchStruct
                                    Dim npDs As DataSet = Search.SelectSearchResults(1, ss, False, ss2)
                                    If npDs Is Nothing OrElse npDs.Tables(0).Rows.Count <> 1 Then
                                        ae.UpdateType = AnnotationEditType.DataError
                                        ae.Comment = "Exact Accepted Name cannot be determined (" + row(i).ToString + ")"
                                        edits.Add(ae)

                                        ae = New AnnotationEdit
                                        ae.NameID = nameId
                                        ae.FullName = row("NameFull").ToString
                                    Else
                                        Dim prefId As String = npDs.Tables(0).Rows(0)("NameGuid").ToString.ToUpper

                                        SaveNameConcept(updateUser, nameId, RelationshipType.RelationshipTypePreferred, prefId)

                                        hasConceptChange = True
                                        ae.UpdateType = AnnotationEditType.UpdateAcceptedName
                                        edits.Add(ae)
                                    End If
                                End If
                            Else

                                Dim map As NameMapping = NameMapping.MappingWithDestinationCol(BrProviderNames.NameMappings, col)
                                If map IsNot Nothing Then
                                    Dim field As Reflection.FieldInfo = pn.GetType().GetField(map.NameMappingSourceCol)
                                    Dim val As Object = DBNull.Value
                                    If field.FieldType Is GetType(Boolean) Or field.FieldType Is GetType(SqlTypes.SqlBoolean) Then
                                        val = SqlTypes.SqlBoolean.Parse(row(i).ToString)
                                    Else
                                        val = row(i)
                                    End If

                                    If val.ToString <> nm(col).ToString Then
                                        hasChanges = True

                                        field.SetValue(pn, val)
                                    End If
                                End If
                            End If
                        Next


                        If hasChanges Then
                            SaveName(updateUser, pn)
                            ae.UpdateType = AnnotationEditType.UpdateDetails
                            edits.Add(ae)
                        End If
                    End If
                Catch ex As Exception
                    ae.UpdateType = AnnotationEditType.DataError
                    ae.Comment = ex.Message
                    edits.Add(ae)
                End Try
            Next
        Catch ex As Exception
            ChecklistException.LogError(ex)
        End Try

        Return edits
    End Function

    Private Shared Function GetFileDs(ByVal filename As String) As DataSet
        Dim sr As New IO.StreamReader(filename)
        Dim header As String = sr.ReadLine()

        Dim ds As New DataSet
        Dim dt As DataTable = ds.Tables.Add("Name")

        If header IsNot Nothing Then
            Dim columns As String() = header.Split(Chr(9))
            For Each col As String In columns
                dt.Columns.Add(col)
            Next

            Dim vals As String = sr.ReadLine

            While vals IsNot Nothing
                dt.Rows.Add(vals.Split(Chr(9)))
                vals = sr.ReadLine
            End While

        End If

        sr.Close()

        Return ds
    End Function


    Private Shared Sub SaveName(ByVal updateUser As User, ByVal newPn As ProviderName)
        'insert/update system edit provider name

        Dim upi As ProviderImport = BrUser.GetSystemProviderImport()
        Dim pn As ProviderName = NameData.GetSystemProviderNameForName(newPn.PNNameFk)

        If pn Is Nothing Then
            pn = New ProviderName
            pn.PNNameId = Guid.NewGuid.ToString
        End If

        If pn IsNot Nothing Then pn.UpdateFieldsFromProviderName(newPn)

        Dim oldUser As User = SessionState.CurrentUser
        SessionState.CurrentUser = updateUser

        BrProviderNames.InsertUpdateSystemProviderName(pn.PNNameFk, pn)

        SessionState.CurrentUser = oldUser
    End Sub

    Private Shared Sub SaveNameConcept(ByVal updateUser As User, ByVal nameId As String, ByVal conceptType As Integer, ByVal toNameId As String)
        'get existing system concept?
        Dim oldUser As User = SessionState.CurrentUser
        SessionState.CurrentUser = updateUser

        BrProviderConcepts.InsertUpdateSystemProviderConcept(nameId, toNameId, conceptType, Nothing)

        SessionState.CurrentUser = oldUser
    End Sub


End Class

Imports ChecklistDataAccess
Imports ChecklistObjects

Module DataTransferServer

    Sub Main()
        'check if any files have been uploaded to the server since last update
        ChecklistException.LogMessage("Checking for new data transfer files")
        Log.LogMessage("Checking for new data transfer files")
        Try
            Dim dateStr As String = System.Configuration.ConfigurationManager.AppSettings.Get("LastTransferDate")
            Dim dt As DateTime = DateTime.MinValue
            If dateStr.Length > 0 Then
                dt = DateTime.Parse(dt)
            End If

            Dim loc As String = Configuration.ConfigurationManager.AppSettings.Get("DataTransferLocation")
            Dim doneLoc As String = Configuration.ConfigurationManager.AppSettings.Get("DataTransferCompleteLocation")
            Dim files As String() = IO.Directory.GetFiles(loc, "*.xml")
            files = SortFiles(New ArrayList(files))
            For Each f As String In files
                Log.LogMessage("Processing file : " + f)

                'If IO.Directory.GetLastWriteTime(f) >= dt.Date AndAlso _ - issue with time zones making file modified times not easily comparable
                If IO.Path.GetExtension(f).ToLower = ".xml" Then
                    'import this file

                    Log.LogMessage("Importing data")

                    Dim ds As New DataSet
                    ds.ReadXml(f)

                    For Each t As DataTable In ds.Tables
                        For Each r As DataRow In t.Rows

                            For tries As Integer = 0 To 3
                                Dim timeout As Boolean = False
                                Try
                                    ImportDataRow(t.TableName, r)
                                Catch ex As Exception
                                    If ex.Message.StartsWith("Timeout expired") Then
                                        timeout = True
                                        If tries = 3 Then Throw ex
                                    Else
                                        Throw ex
                                    End If
                                End Try
                                If Not timeout Then Exit For
                            Next

                        Next
                    Next

                    'ChecklistException.LogMessage("Successfully transferred data from file " + f)
                    Log.LogMessage("Successfully transferred data from file " + f)
                End If

                IO.File.Move(f, doneLoc + "\" + IO.Path.GetFileName(f))

                Log.LogMessage("Finished processing file : " + f)
            Next

            Dim config As New AMS.Profile.Config
            config.GroupName = Nothing
            config.SetValue("appSettings", "LastTransferDate", DateTime.Now)
        Catch ex As Exception
            Log.LogError(ex)
            'ChecklistException.LogError(ex)
        End Try
    End Sub

    Private Function SortFiles(ByVal files As ArrayList) As String()
        Dim sortedFiles As New ArrayList

        For i As Integer = 1 To files.Count
            Dim nextFile As String = ""
            Dim dt As DateTime = DateTime.MinValue

            For Each f As String In files
                Dim fDate As DateTime = System.IO.Directory.GetLastWriteTime(f)
                If dt = DateTime.MinValue Or dt > fDate Then
                    dt = fDate
                    nextFile = f
                End If
            Next

            sortedFiles.Add(nextFile)
            files.Remove(nextFile)
        Next

        Return sortedFiles.ToArray(GetType(String))
    End Function

    Private Sub ImportDataRow(ByVal tableName As String, ByVal row As DataRow)
        If tableName.ToLower = "tblauthors" Then
            DataTransferData.InsertUpdateAuthor(row)
        End If
        If tableName.ToLower = "tblnameauthors" Then
            DataTransferData.InsertUpdateNameAuthor(row)
        End If
        If tableName.ToLower = "tblprovidernameauthors" Then
            DataTransferData.InsertUpdateProviderNameAuthor(row)
        End If
        If tableName.ToLower = "tblconcept" Then
            DataTransferData.InsertUpdateConcept(row)
        End If
        If tableName.ToLower = "tblconceptrelationship" Then
            DataTransferData.InsertUpdateConceptRelationship(row)
        End If
        If tableName.ToLower = "tbldeprecated" Then
            DataTransferData.InsertUpdateDeprecated(row)
        End If
        If tableName.ToLower = "tblfieldstatus" Then
            DataTransferData.InsertUpdateFieldStatus(row)
        End If
        If tableName.ToLower = "tblname" Then
            DataTransferData.InsertUpdateName(row)
        End If
        If tableName.ToLower = "tblprovider" Then
            DataTransferData.InsertUpdateProvider(row)
        End If
        If tableName.ToLower = "tblproviderconcept" Then
            DataTransferData.InsertUpdateProviderConcept(row)
        End If
        If tableName.ToLower = "tblproviderconceptrelationship" Then
            DataTransferData.InsertUpdateProviderConceptRelationship(row)
        End If
        If tableName.ToLower = "tblproviderconcept_change" Then
            DataTransferData.InsertUpdateProviderConceptChange(row)
        End If
        If tableName.ToLower = "tblproviderconceptrelationship_change" Then
            DataTransferData.InsertUpdateProviderConceptRelationshipChange(row)
        End If
        If tableName.ToLower = "tblproviderimport" Then
            DataTransferData.InsertUpdateProviderImport(row)
        End If
        If tableName.ToLower = "tblprovidername" Then
            DataTransferData.InsertUpdateProviderName(row)
        End If
        If tableName.ToLower = "tblprovidername_change" Then
            DataTransferData.InsertUpdateProviderNameChange(row)
        End If
        If tableName.ToLower = "tblproviderotherdata" Then
            DataTransferData.InsertUpdateProviderOtherData(row)
        End If
        If tableName.ToLower = "tblproviderreference" Then
            DataTransferData.InsertUpdateProviderReference(row)
        End If
        If tableName.ToLower = "tblproviderreference_change" Then
            DataTransferData.InsertUpdateProviderReferenceChange(row)
        End If
        If tableName.ToLower = "tblproviderris" Then
            DataTransferData.InsertUpdateProviderRIS(row)
        End If
        If tableName.ToLower = "tblproviderris_change" Then
            DataTransferData.InsertUpdateProviderRISChange(row)
        End If
        If tableName.ToLower = "tblreference" Then
            DataTransferData.InsertUpdateReference(row)
        End If
        If tableName.ToLower = "tblreferenceris" Then
            DataTransferData.InsertUpdateReferenceRIS(row)
        End If
        If tableName.ToLower = "tblotherdata" Then
            DataTransferData.InsertUpdateOtherData(row)
        End If
        If tableName.ToLower = "tblstandardoutput" Then
            DataTransferData.InsertUpdateStandardOutput(row)
        End If
        If tableName.ToLower = "tbltransformation" Then
            DataTransferData.InsertUpdateTransformation(row)
        End If
        If tableName.ToLower = "tblotherdatatransformation" Then
            DataTransferData.InsertUpdateOtherDataTransformation(row)
        End If
        If tableName.ToLower = "tblotherdatatype" Then
            DataTransferData.InsertUpdateOtherDataType(row)
        End If

    End Sub

End Module

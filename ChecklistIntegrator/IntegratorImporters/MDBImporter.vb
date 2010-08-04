Imports System.Data
Imports System.Data.OleDb

Imports ChecklistObjects

Public Class MDBImporter
    Inherits BaseImporter

    Public Overrides Sub ImportFile()

        If ImportType.FileType = ImportType.FileTypeMDB Then
            Dim cnn As OleDbConnection
            Try
                'status message for imoprt file, 2 perc complete = started
                PercentComplete = 2
                PostStatusMessage(PercentComplete, "Importing file " + ProvImport.ProviderImportFileName)

                'load data from mdb
                cnn = New OleDbConnection("Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + ProvImport.ProviderImportFileName + ";")
                cnn.Open()

                Dim cmd As New OleDbCommand()
                cmd.Connection = cnn

                Dim ds As New DataSet
                Dim da As New OleDbDataAdapter(cmd)

                If ImportType.ObjectType = ImportType.ObjectTypeName Then
                    cmd.CommandText = "select * from tblProviderName"
                    da.Fill(ds)
                    ds.Tables(0).TableName = "tblProviderName"

                    cmd.CommandText = "select * from tblProviderConcept"
                    da.Fill(ds)
                    ds.Tables(1).TableName = "tblProviderConcept"

                    cmd.CommandText = "select * from tblProviderConceptRelationship"
                    da.Fill(ds)
                    ds.Tables(2).TableName = "tblProviderConceptRelationship"
                ElseIf ImportType.ObjectType = ImportType.ObjectTypeReference Then
                    cmd.CommandText = "select * from tblProviderReference"
                    da.Fill(ds)
                    ds.Tables(0).TableName = "tblProviderReference"

                    cmd.CommandText = "select * from tblProviderRIS"
                    da.Fill(ds)
                    ds.Tables(1).TableName = "tblProviderRIS"
                ElseIf ImportType.ObjectType = ImportType.ObjectTypeOtherData Then
                    cmd.CommandText = "select * from tblProviderOtherData"
                    da.Fill(ds)
                    ds.Tables(0).TableName = "tblProviderOtherData"
                ElseIf ImportType.ObjectType = ImportType.ObjectTypeAll Then
                    cmd.CommandText = "select * from tblProviderName"
                    da.Fill(ds)
                    ds.Tables(0).TableName = "tblProviderName"

                    cmd.CommandText = "select * from tblProviderConcept"
                    da.Fill(ds)
                    ds.Tables(1).TableName = "tblProviderConcept"

                    cmd.CommandText = "select * from tblProviderConceptRelationship"
                    da.Fill(ds)
                    ds.Tables(2).TableName = "tblProviderConceptRelationship"

                    cmd.CommandText = "select * from tblProviderReference"
                    da.Fill(ds)
                    ds.Tables(3).TableName = "tblProviderReference"

                    cmd.CommandText = "select * from tblProviderRIS"
                    da.Fill(ds)
                    ds.Tables(4).TableName = "tblProviderRIS"

                    cmd.CommandText = "select * from tblProviderOtherData"
                    da.Fill(ds)
                    ds.Tables(5).TableName = "tblProviderOtherData"
                End If


                If Cancel Then
                    PercentComplete = 100
                    Success = False
                    PostStatusMessage(PercentComplete, "Cancelled")
                Else
                    'loading takes a portion of the time so now roughly 10 percent complete
                    PercentComplete = 10
                    PostStatusMessage(PercentComplete, "Saving to checklist database")

                    'save to database
                    SaveImportedDataset(ds)
                End If

            Catch ex As Exception
                ChecklistException.LogError(ex)
                PercentComplete = 100
                Success = False
                PostStatusMessage(PercentComplete, "ERROR : " + ex.Message)
            Finally
                If Not cnn Is Nothing Then cnn.Close()
            End Try
        Else
            PercentComplete = 100
            PostStatusMessage(PercentComplete, "ERROR: Incorrect file type for importer")
        End If

    End Sub

End Class

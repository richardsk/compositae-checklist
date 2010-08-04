Imports System.Xml
Imports System.Xml.Xsl
Imports ChecklistObjects

Public Class BrOtherData

    Public Delegate Sub StatusDelegate(ByVal percComplete As Integer, ByVal msg As String)

    Public Shared StatusCallback As StatusDelegate
    Public Shared Cancel As Boolean = False

    Public Shared Function UpdateOtherDataStandrdOutput(ByVal records As DataTable) As Boolean
        Dim ok As Boolean = True

        Dim transform As XslCompiledTransform = Nothing
        Dim xsl As String = ""
        Dim xslFk As Integer = 0
        Dim pos As Integer = 0
        Dim count As Integer = records.Rows.Count

        For Each row As DataRow In records.Rows
            Dim msg As String = ""

            If Cancel Then Exit For

            pos += 1

            Dim xml As String = ""

            If row("UseDataXml").ToString = Boolean.TrueString Then
                xml = row("POtherDataXml").ToString()
            Else
                xml = row("POtherDataData").ToString()
            End If

            If xml.Length > 0 Then
                If row("AddRoot").ToString = Boolean.TrueString Then
                    xml = "<DataSet>" + xml + "</DataSet>"
                End If

                Try
                    If row("TransformationFk") <> xslFk Then
                        Dim trRow As DataRow = ChecklistDataAccess.OtherData.GetTransformation(row("TransformationFk"))
                        Dim newXsl As String = trRow("xslt").ToString

                        transform = New XslCompiledTransform
                        transform.Load(New XmlTextReader(New IO.StringReader(newXsl)))

                        xslFk = row("TransformationFk")
                    End If

                    Dim ms As New IO.MemoryStream()
                    Dim writer As New XmlTextWriter(ms, Text.UTF8Encoding.UTF8)
                    transform.Transform(New XmlTextReader(New IO.StringReader(xml)), writer)
                    writer.Flush()

                    ms.Position = 0
                    Dim transXml As String = New IO.StreamReader(ms).ReadToEnd()

                    If transXml.Length > 0 Then
                        Dim pk As Integer = -1
                        If Not row.IsNull("StandardOutputPk") Then pk = row("StandardOutputPk")
                        pk = ChecklistDataAccess.OtherData.InsertUpdateStandardOutput(pk, row("POtherDataTextPk"), row("OutputTypeFk"), transXml, DateTime.Now, True, row("OtherDataFk").ToString, ChecklistObjects.SessionState.CurrentUser.Login)
                        row("StandardXml") = transXml
                    End If

                Catch ex As Exception
                    ChecklistObjects.ChecklistException.LogError(ex)
                    msg = "Error with record POtherDataTextPk=" + row("POtherDataTextPk").ToString + " : " + ex.Message
                    ok = False
                End Try
            End If

            If StatusCallback IsNot Nothing Then
                Dim perc As Integer = (pos * 100 / count)
                StatusCallback.Invoke(perc, msg)
            End If
        Next

        If StatusCallback IsNot Nothing Then StatusCallback.Invoke(100, "")

        Return ok
    End Function

    Public Shared Sub RefreshNameOtherData(ByVal nameGuid As String)
        Dim ds As DataSet = ChecklistDataAccess.OtherData.GetProviderNameOtherData(nameGuid)
        Dim lastType As String = ""
        For Each row As DataRow In ds.Tables(0).Rows
            If Not row.IsNull("POtherDataType") Then
                If row("POtherDataType").ToString <> lastType And Not row.IsNull("OutputTypeFk") Then
                    UpdateConsensusOtherData(nameGuid, CInt(row("OutputTypeFk")), row("OtherDataFk").ToString)
                End If
            End If
        Next
    End Sub

    Public Shared Function GetConsensusXml(ByVal nameGuid As String, ByVal dataTypeFk As Integer) As String
        Dim consXml As String = ChecklistDataAccess.OtherData.GetStandardXmlForConsensus(nameGuid, dataTypeFk)
        Dim xslt As String = ChecklistDataAccess.OtherData.GetConsensusXslt(dataTypeFk)
        If consXml <> "" And xslt <> "" Then
            consXml = Utility.XsltTranslate(consXml, xslt)
        Else
            consXml = ""
        End If
        Return consXml
    End Function

    Public Shared Function UpdateConsensusOtherData(ByVal nameGuid As String, ByVal dataTypeFk As Integer, ByVal consOtherDataPk As String) As MatchResult
        Dim res As New MatchResult

        Dim consXml As String = GetConsensusXml(nameGuid, dataTypeFk)
        res.MatchedOtherData = ChecklistDataAccess.OtherData.InsertUpdateOtherData(nameGuid, consXml, consOtherDataPk, dataTypeFk, SessionState.CurrentUser.Login)

        If consOtherDataPk IsNot Nothing AndAlso consOtherDataPk.Length > 0 Then
            res.Status = LinkStatus.Matched
        Else
            res.Status = LinkStatus.Inserted
        End If

        Return res
    End Function

End Class

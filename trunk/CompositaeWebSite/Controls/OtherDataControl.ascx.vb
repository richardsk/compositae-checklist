Imports ChecklistDataAccess
Imports ChecklistObjects
Imports DataAccess

Imports System.Data

Partial Class Controls_OtherDataControl
    Inherits System.Web.UI.UserControl

    Public Sub Display()

        Dim SelName As Name = NameData.GetName(Nothing, DataAccess.Utility.NameID(Request))
        Dim tab As String = Request.QueryString("TabNum")

        Dim OtherDataDs As DataSet = OtherData.GetNameOtherData(SelName.Id)

        Dim ctrl As New HtmlGenericControl

        If OtherDataDs IsNot Nothing AndAlso OtherDataDs.Tables.Count > 0 Then
            Dim html As String = ""

            'go through each data type in their web sequence
            Dim types As DataSet = ChecklistDataAccess.OtherData.GetOtherDataTypes()
            types.Tables(0).DefaultView.Sort = "DisplayTab, WebSequence"

            For Each trv As DataRowView In types.Tables(0).DefaultView

                Dim odHtml As String = "<span style='color:Black'>"
                Dim hasData As Boolean = False

                For Each row As DataRow In OtherDataDs.Tables(0).Rows
                    If row("OtherDataTypeFk").ToString = trv.Row("OtherDataTypePk").ToString Then
                        Try
                            'If [Enum].Parse(GetType(EDisplayTab), row("DisplayTab").ToString) = tab Then
                            If odHtml.Length > 0 Then odHtml += "<br/><br/>"

                            odHtml += Global.Resources.Resource.Other_Data_Type + " <strong>" + row("Name").ToString + "</strong><br/><br/>"

                            Dim xslt As String = row("WebXslt").ToString
                            Dim val As String = ChecklistObjects.Utility.XsltTranslate(row("OtherDataXml").ToString, xslt)
                            If val.Length > 0 Then
                                val = val.Replace("<html>", "")
                                val = val.Replace("</html>", "")
                                odHtml += val
                            Else
                                odHtml += "No Other Data"
                            End If
                            'End If

                        Catch ex As Exception

                        End Try
                    End If
                Next

                odHtml += "</span>"

                html += odHtml
            Next

            ctrl.InnerHtml = html
        End If

        PlaceHolder1.Controls.Add(ctrl)
    End Sub


End Class

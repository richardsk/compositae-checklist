Imports Microsoft.VisualBasic
Imports System.Collections.Generic

Imports System.Data.SqlClient

Public Enum TDWGGeoLevel
    TDWG1
    TDWG2
    TDWG3
    TDWG4
End Enum

Public Enum GeoStatus
    Present
    Indigenous
    Endemic
    Exotic
End Enum

Public Class TDWGGeo
    Implements IComparable

    Public Code As String = ""
    Public Name As String = ""
    Public ISOCode As String = ""
    Public Level As TDWGGeoLevel
    Public Status As GeoStatus

    Public Overrides Function ToString() As String
        Return Name
    End Function

    Public Function CompareTo(ByVal obj As Object) As Integer Implements System.IComparable.CompareTo
        Dim g2 As TDWGGeo = CType(obj, TDWGGeo)
        Return String.Compare(Me.Name, g2.Name)
    End Function

End Class

Public Class GazetteerItem
    Public Level1Code As String = ""
    Public Level2Code As String = ""
    Public Level3Code As String = ""
    Public Level4Code As String = ""
    Public Name As String = ""
End Class

Public Class Gazetteer
    Dim Items As New List(Of GazetteerItem)

    Public Sub Load(ByVal filename As String)
        Items.Clear()

        Dim lines As String() = IO.File.ReadAllLines(filename, Text.Encoding.Default)
        Dim first As Boolean = True
        For Each line As String In lines
            If first Then
                first = False
                Continue For
            End If
            Dim vals As String() = line.Split("*")
            Dim g As New GazetteerItem
            g.Level1Code = vals(2)
            g.Level2Code = vals(3)
            g.Level3Code = vals(4)
            g.Level4Code = vals(5)
            g.Name = vals(1)

            If Not ContainsItem(g) Then
                Items.Add(g)
            End If

        Next

    End Sub

    Public Function GetItemByName(ByVal name As String) As GazetteerItem
        Dim gi As GazetteerItem = Nothing
        For Each g As GazetteerItem In Items
            If g.Name = name Then
                gi = g
                Exit For
            End If
        Next
        Return gi
    End Function

    Public Function ContainsItem(ByVal tg As GazetteerItem) As Boolean
        For Each g As GazetteerItem In Items
            If g.Name = tg.Name Then
                Return True
            End If
        Next
        Return False
    End Function

    Public Shared Function HasItemInList(ByVal geoList As List(Of TDWGGeo), ByVal newItem As TDWGGeo)
        For Each item As TDWGGeo In geoList
            If item.Code = newItem.Code Then
                Return True
            End If
        Next
        Return False
    End Function

    Public Shared Function IsChildOf(ByVal parentItem As GazetteerItem, ByVal newItem As GazetteerItem, ByVal parentItemLevel As TDWGGeoLevel)
        Dim hasParent As Boolean = False
        If parentItemLevel = TDWGGeoLevel.TDWG1 Then
            If parentItem.Level1Code = newItem.Level1Code Then
                hasParent = True
            End If
        End If
        If parentItemLevel = TDWGGeoLevel.TDWG2 Then
            If parentItem.Level2Code = newItem.Level2Code Then
                hasParent = True
            End If
        End If
        If parentItemLevel = TDWGGeoLevel.TDWG3 Then
            If parentItem.Level3Code = newItem.Level3Code Then
                hasParent = True
            End If
        End If
        If parentItemLevel = TDWGGeoLevel.TDWG4 Then
            If parentItem.Level4Code = newItem.Level4Code Then
                hasParent = True
            End If
        End If
        Return hasParent
    End Function

    Public Function GetGeoRegions(ByVal topTDWGLevel As TDWGGeoLevel, ByVal topLevelName As String) As List(Of TDWGGeo)
        Dim geos As New List(Of TDWGGeo)
        Dim topLevelItem As GazetteerItem = Nothing

        Dim ttg As TDWGGeo = Distribution.GetTDWGeoByName(topTDWGLevel, topLevelName)
        If ttg IsNot Nothing Then
            topLevelItem = New GazetteerItem
            topLevelItem.Name = topLevelName

            If ttg.Level = TDWGGeoLevel.TDWG1 Then
                topLevelItem.Level1Code = ttg.Code
            ElseIf ttg.Level = TDWGGeoLevel.TDWG2 Then
                topLevelItem.Level2Code = ttg.Code
            ElseIf ttg.Level = TDWGGeoLevel.TDWG3 Then
                topLevelItem.Level3Code = ttg.Code
            ElseIf ttg.Level = TDWGGeoLevel.TDWG4 Then
                topLevelItem.Level4Code = ttg.Code
            End If

        End If

        If topLevelItem IsNot Nothing Then
            geos.Add(ttg)

            For Each g As GazetteerItem In Items
                Dim tg As New TDWGGeo

                If IsChildOf(topLevelItem, g, topTDWGLevel) Then
                    If topTDWGLevel < TDWGGeoLevel.TDWG2 Then
                        tg = New TDWGGeo
                        tg.Code = g.Level2Code
                        tg.Level = TDWGGeoLevel.TDWG2

                        If tg.Code <> "" AndAlso Not HasItemInList(geos, tg) Then geos.Add(tg)
                    End If
                    If topTDWGLevel < TDWGGeoLevel.TDWG3 Then
                        tg = New TDWGGeo
                        tg.Code = g.Level3Code
                        tg.Level = TDWGGeoLevel.TDWG3

                        If tg.Code <> "" AndAlso Not HasItemInList(geos, tg) Then geos.Add(tg)
                    End If
                    If topTDWGLevel < TDWGGeoLevel.TDWG4 Then
                        tg = New TDWGGeo
                        tg.Code = g.Level4Code
                        tg.Level = TDWGGeoLevel.TDWG4

                        If tg.Code <> "" AndAlso Not HasItemInList(geos, tg) Then geos.Add(tg)
                    End If
                End If
            Next
        End If

        Return geos
    End Function

End Class

Public Class Distribution

    Public Layers As String = "earth"
    Public Regions As String = "NONE" '"SUM,MYA,MLY,NWG,MRN,SOL,ASS"
    Public Level As TDWGGeoLevel = TDWGGeoLevel.TDWG3
    Public AreaStyle As String = "a:8dd3c7,,1"
    Public WidthHeight As Integer = 400
    Public BoundingBox As String = "-180,-90,180,90"

    Private Shared _gazetteer As Gazetteer

    Private Shared ReadOnly Property ConnectionString() As String
        Get
            Return System.Configuration.ConfigurationManager.AppSettings("ConnectionString")
        End Get
    End Property

    Public Shared ReadOnly Property Gazetteer() As Gazetteer
        Get
            If _gazetteer Is Nothing Then
                Dim path As String = System.Web.HttpContext.Current.Request.PhysicalApplicationPath
                _gazetteer = New Gazetteer
                _gazetteer.Load(path + "\TDWGGeo\tblGazetteer.txt")
            End If
            Return _gazetteer
        End Get
    End Property

    Public Function GetMapUrl(ByVal geoList As List(Of TDWGGeo)) As String
        Dim assPres As String = "a:8dd3c7,,0"
        Dim assEndem As String = "b:dd5500,,0"
        Dim assIndig As String = "c:00ff00,,0"
        Dim assExot As String = "d:ff0000,,0"

        Dim tdwg1 As New Collections.Hashtable
        Dim tdwg2 As New Collections.Hashtable
        Dim tdwg3 As New Collections.Hashtable
        Dim tdwg4 As New Collections.Hashtable

        tdwg1("a") = ""
        tdwg1("b") = ""
        tdwg1("c") = ""
        tdwg1("d") = ""
        tdwg2("a") = ""
        tdwg2("b") = ""
        tdwg2("c") = ""
        tdwg2("d") = ""
        tdwg3("a") = ""
        tdwg3("b") = ""
        tdwg3("c") = ""
        tdwg3("d") = ""
        tdwg4("a") = ""
        tdwg4("b") = ""
        tdwg4("c") = ""
        tdwg4("d") = ""

        For Each tg As TDWGGeo In geoList

            Dim cd As String = tg.Code
            If tg.Level = TDWGGeoLevel.TDWG4 And cd.IndexOf("-") <> -1 Then cd = cd.Substring(0, cd.IndexOf("-")) ' TODO remove ??

            Dim ht As Hashtable = Nothing

            If tg.Level = TDWGGeoLevel.TDWG1 Then
                ht = tdwg1
            ElseIf tg.Level = TDWGGeoLevel.TDWG2 Then
                ht = tdwg2
            ElseIf tg.Level = TDWGGeoLevel.TDWG3 Then
                ht = tdwg3
            ElseIf tg.Level = TDWGGeoLevel.TDWG4 Then
                ht = tdwg4
            End If

            'if is present
            If tg.Status = GeoStatus.Present Then
                Dim reg As String = ht("a")
                If reg Is Nothing OrElse reg.IndexOf("," + cd + ",") = -1 Then
                    reg += cd + ","
                    ht("a") = reg
                End If
            ElseIf tg.Status = GeoStatus.Endemic Then
                Dim reg As String = ht("b")
                If reg.IndexOf("," + cd + ",") = -1 Then
                    reg += cd + ","
                    ht("b") = reg
                End If
            ElseIf tg.Status = GeoStatus.Indigenous Then
                Dim reg As String = ht("c")
                If reg.IndexOf("," + cd + ",") = -1 Then
                    reg += cd + ","
                    ht("c") = reg
                End If
            ElseIf tg.Status = GeoStatus.Exotic Then
                Dim reg As String = ht("d")
                If reg.IndexOf("," + cd + ",") = -1 Then
                    reg += cd + ","
                    ht("d") = reg
                End If
            End If


        Next

        tdwg1("a") = tdwg1("a").ToString().Trim(",")
        tdwg1("b") = tdwg1("b").ToString().Trim(",")
        tdwg1("c") = tdwg1("c").ToString().Trim(",")
        tdwg1("d") = tdwg1("d").ToString().Trim(",")

        tdwg2("a") = tdwg2("a").ToString().Trim(",")
        tdwg2("b") = tdwg2("b").ToString().Trim(",")
        tdwg2("c") = tdwg2("c").ToString().Trim(",")
        tdwg2("d") = tdwg2("d").ToString().Trim(",")

        tdwg3("a") = tdwg3("a").ToString().Trim(",")
        tdwg3("b") = tdwg3("b").ToString().Trim(",")
        tdwg3("c") = tdwg3("c").ToString().Trim(",")
        tdwg3("d") = tdwg3("d").ToString().Trim(",")

        tdwg4("a") = tdwg4("a").ToString().Trim(",")
        tdwg4("b") = tdwg4("b").ToString().Trim(",")
        tdwg4("c") = tdwg4("c").ToString().Trim(",")
        tdwg4("d") = tdwg4("d").ToString().Trim(",")

        Dim url As String = System.Configuration.ConfigurationManager.AppSettings.Get("MapUrl")
        url += "?l=" + Layers

        Dim regions As String = ""
        'have to do this in reverse order (ie tdwg1 last) so that the more precise areas display on top
        If tdwg4("a").ToString().Length > 0 Or tdwg4("b").ToString().Length > 0 Or tdwg4("c").ToString().Length > 0 Or tdwg4("d").ToString().Length > 0 _
          Or tdwg3("a").ToString().Length > 0 Or tdwg3("b").ToString().Length > 0 Or tdwg3("c").ToString().Length > 0 Or tdwg3("d").ToString().Length > 0 Then
            Dim t4 As String = ""
            If tdwg4("a").ToString.Length > 0 Then
                t4 += "a:" + tdwg4("a")
            End If
            If tdwg3("a").ToString.Length > 0 Then
                If tdwg4("a").ToString.Length = 0 Then t4 += "a:"
                t4 += tdwg3("a")
            End If

            If tdwg4("b").ToString.Length > 0 Then
                If t4.Length > 0 Then t4 += "|"
                t4 += "b:" + tdwg4("b")
            End If
            If tdwg3("b").ToString.Length > 0 Then
                If tdwg4("b").ToString.Length = 0 Then t4 += "b:"
                t4 += tdwg3("b")
            End If

            If tdwg4("c").ToString.Length > 0 Then
                If t4.Length > 0 Then t4 += "|"
                t4 += "c:" + tdwg4("c")
            End If
            If tdwg3("c").ToString.Length > 0 Then
                If tdwg4("c").ToString.Length = 0 Then t4 += "c:"
                t4 += tdwg3("c")
            End If

            If tdwg4("d").ToString.Length > 0 Then
                If t4.Length > 0 Then t4 += "|"
                t4 += "d:" + tdwg4("d")
            End If
            If tdwg3("d").ToString.Length > 0 Then
                If tdwg4("d").ToString.Length = 0 Then t4 += "d:"
                t4 += tdwg3("d")
            End If

            If regions.Length > 0 Then regions += "||"
            regions += "tdwg3:" + t4 ' seems to need to be TDWG3 for tdwg 4 ones !! ??
        End If
        If tdwg2("a").ToString().Length > 0 Or tdwg2("b").ToString().Length > 0 Or tdwg2("c").ToString().Length > 0 Or tdwg2("d").ToString().Length > 0 Then
            Dim t2 As String = ""
            If tdwg2("a").ToString.Length > 0 Then
                t2 += "a:" + tdwg2("a")
            End If
            If tdwg2("b").ToString.Length > 0 Then
                If t2.Length > 0 Then t2 += "|"
                t2 += "b:" + tdwg2("b")
            End If
            If tdwg2("c").ToString.Length > 0 Then
                If t2.Length > 0 Then t2 += "|"
                t2 += "c:" + tdwg2("c")
            End If
            If tdwg2("d").ToString.Length > 0 Then
                If t2.Length > 0 Then t2 += "|"
                t2 += "d:" + tdwg2("d")
            End If
            If regions.Length > 0 Then regions += "||"
            regions += "tdwg2:" + t2
        End If
        If tdwg1("a").ToString().Length > 0 Or tdwg1("b").ToString().Length > 0 Or tdwg1("c").ToString().Length > 0 Or tdwg1("d").ToString().Length > 0 Then
            Dim t1 As String = ""
            If tdwg1("a").ToString.Length > 0 Then
                t1 += "a:" + tdwg1("a")
            End If
            If tdwg1("b").ToString.Length > 0 Then
                If t1.Length > 0 Then t1 += "|"
                t1 += "b:" + tdwg1("b")
            End If
            If tdwg1("c").ToString.Length > 0 Then
                If t1.Length > 0 Then t1 += "|"
                t1 += "c:" + tdwg1("c")
            End If
            If tdwg1("d").ToString.Length > 0 Then
                If t1.Length > 0 Then t1 += "|"
                t1 += "d:" + tdwg1("d")
            End If
            If regions.Length > 0 Then regions += "||"
            regions += "tdwg1:" + t1
        End If

        url += "&ad=" + regions + "&as=" + assPres + "|" + assEndem + "|" + assIndig + "|" + assExot
        url += "&bbox=" + BoundingBox + "&recalculate=false"
        url += "&ms=" + WidthHeight.ToString

        Return url
    End Function

    Public Function GetMapUrl() As String
        Dim url As String = System.Configuration.ConfigurationManager.AppSettings.Get("MapUrl")
        url += "?l=" + Layers + "&ad=" + Level.ToString.ToLower + _
            ":a:" + Regions + "&as=" + AreaStyle + "&ms=" + WidthHeight.ToString + "&bbox=" + BoundingBox

        Return url
    End Function

    Public Shared Function GetTDWGeoByName(ByVal level As TDWGGeoLevel, ByVal name As String) As TDWGGeo
        Dim g As TDWGGeo = Nothing

        Dim path As String = System.Web.HttpContext.Current.Request.PhysicalApplicationPath

        If level = TDWGGeoLevel.TDWG1 Then
            Dim lines As String() = IO.File.ReadAllLines(path + "\TDWGGeo\tblLevel1.txt", Text.Encoding.Default)
            For Each line As String In lines
                Dim vals As String() = line.Split("*")
                If vals(1) = name Then
                    g = New TDWGGeo
                    g.Level = TDWGGeoLevel.TDWG1
                    g.Code = vals(0)
                    g.Name = vals(1)
                    Exit For
                End If
            Next
        End If

        If level = TDWGGeoLevel.TDWG2 Then
            Dim lines As String() = IO.File.ReadAllLines(path + "\TDWGGeo\tblLevel2.txt", Text.Encoding.Default)
            For Each line As String In lines
                Dim vals As String() = line.Split("*")
                If vals(1) = name Then
                    g = New TDWGGeo
                    g.Level = TDWGGeoLevel.TDWG2
                    g.Code = vals(0)
                    g.Name = vals(1)
                    g.ISOCode = vals(3)
                    Exit For
                End If
            Next
        End If

        If level = TDWGGeoLevel.TDWG3 Then
            Dim lines As String() = IO.File.ReadAllLines(path + "\TDWGGeo\tblLevel3.txt", Text.Encoding.Default)
            For Each line As String In lines
                Dim vals As String() = line.Split("*")
                If vals(1) = name Then
                    g = New TDWGGeo
                    g.Level = TDWGGeoLevel.TDWG3
                    g.Code = vals(0)
                    g.Name = vals(1)
                    g.ISOCode = vals(3)
                    Exit For
                End If
            Next
        End If

        If level = TDWGGeoLevel.TDWG4 Then
            Dim lines As String() = IO.File.ReadAllLines(path + "\TDWGGeo\tblLevel4.txt", Text.Encoding.Default)
            For Each line As String In lines
                Dim vals As String() = line.Split("*")
                If vals(1) = name Then
                    g = New TDWGGeo
                    g.Level = TDWGGeoLevel.TDWG4
                    g.Code = vals(0)
                    g.Name = vals(1)
                    g.ISOCode = vals(3)
                    Exit For
                End If
            Next
        End If

        Return g
    End Function

    Public Shared Function GetTDWGeoByCode(ByVal code As String) As TDWGGeo
        Dim g As TDWGGeo = Nothing

        Dim path As String = System.Web.HttpContext.Current.Request.PhysicalApplicationPath

        Dim lines As String() = IO.File.ReadAllLines(path + "\TDWGGeo\tblLevel1.txt", Text.Encoding.Default)
        For Each line As String In lines
            Dim vals As String() = line.Split("*")
            If vals(0) = code Or vals(0).StartsWith(code + ",") Then
                g = New TDWGGeo
                g.Level = TDWGGeoLevel.TDWG1
                g.Code = vals(0)
                g.Name = vals(1)
                Return g
            End If
        Next

        lines = IO.File.ReadAllLines(path + "\TDWGGeo\tblLevel2.txt", Text.Encoding.Default)
        For Each line As String In lines
            Dim vals As String() = line.Split("*")
            If vals(0) = code Or vals(0).StartsWith(code + ",") Then
                g = New TDWGGeo
                g.Level = TDWGGeoLevel.TDWG2
                g.Code = vals(0)
                g.Name = vals(1)
                g.ISOCode = vals(3)
                Return g
            End If
        Next
    
        lines = IO.File.ReadAllLines(path + "\TDWGGeo\tblLevel3.txt", Text.Encoding.Default)
        For Each line As String In lines
            Dim vals As String() = line.Split("*")
            If vals(0) = code Or vals(0).StartsWith(code + ",") Then
                g = New TDWGGeo
                g.Level = TDWGGeoLevel.TDWG3
                g.Code = vals(0)
                g.Name = vals(1)
                g.ISOCode = vals(3)
                Return g
            End If
        Next

        lines = IO.File.ReadAllLines(path + "\TDWGGeo\tblLevel4.txt", Text.Encoding.Default)
        For Each line As String In lines
            Dim vals As String() = line.Split("*")
            If vals(0) = code Or vals(0).StartsWith(code + ",") Then
                g = New TDWGGeo
                g.Level = TDWGGeoLevel.TDWG4
                g.Code = vals(0)
                g.Name = vals(1)
                g.ISOCode = vals(3)
                Return g
            End If
        Next

        Return Nothing
    End Function

    Public Shared Function GetTDWGGeoList(ByVal level As TDWGGeoLevel) As List(Of TDWGGeo)
        Dim geo As New List(Of TDWGGeo)
        Dim first As Boolean = True

        Dim path As String = System.Web.HttpContext.Current.Request.PhysicalApplicationPath

        If level = TDWGGeoLevel.TDWG1 Then
            Dim lines As String() = IO.File.ReadAllLines(path + "\TDWGGeo\tblLevel1.txt", Text.Encoding.Default)
            For Each line As String In lines
                If first Then
                    first = False
                Else
                    Dim vals As String() = line.Split("*")
                    Dim g As New TDWGGeo
                    g.Level = TDWGGeoLevel.TDWG1
                    g.Code = vals(0)
                    g.Name = vals(1)
                    geo.Add(g)
                End If
            Next
        End If

        If level = TDWGGeoLevel.TDWG3 Then
            Dim lines As String() = IO.File.ReadAllLines(path + "\TDWGGeo\tblLevel3.txt", Text.Encoding.Default)
            For Each line As String In lines
                If first Then
                    first = False
                Else
                    Dim vals As String() = line.Split("*")
                    Dim g As New TDWGGeo
                    g.Level = TDWGGeoLevel.TDWG3
                    g.Code = vals(0)
                    g.Name = vals(1)
                    g.ISOCode = vals(3)
                    geo.Add(g)
                End If
            Next
        End If

        If level = TDWGGeoLevel.TDWG2 Then
            Dim lines As String() = IO.File.ReadAllLines(path + "\TDWGGeo\tblLevel2.txt", Text.Encoding.Default)
            For Each line As String In lines
                If first Then
                    first = False
                Else
                    Dim vals As String() = line.Split("*")
                    Dim g As New TDWGGeo
                    g.Level = TDWGGeoLevel.TDWG2
                    g.Code = vals(0)
                    g.Name = vals(1)
                    g.ISOCode = vals(3)
                    geo.Add(g)
                End If
            Next
        End If

        If level = TDWGGeoLevel.TDWG4 Then
            Dim lines As String() = IO.File.ReadAllLines(path + "\TDWGGeo\tblLevel4.txt", Text.Encoding.Default)
            For Each line As String In lines
                If first Then
                    first = False
                Else
                    Dim vals As String() = line.Split("*")
                    Dim g As New TDWGGeo
                    g.Level = TDWGGeoLevel.TDWG4
                    g.Code = vals(0)
                    g.Name = vals(1)
                    g.ISOCode = vals(3)
                    geo.Add(g)
                End If
            Next
        End If

        geo.Sort()

        Return geo
    End Function

    Public Function GetNameDistributionDescendents(ByVal nameGuid As String) As List(Of TDWGGeo)
        Dim geo As New List(Of TDWGGeo)

        Dim ds As New DataSet

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As New SqlCommand
                cmd.Connection = cnn

                Dim sql As String = "set arithabort on; select distinct OD.data.value('./@schema', 'nvarchar(100)') as [Schema], " + _
                    "OD.data.value('./@region', 'nvarchar(100)') as Region, " + _
                    "OD.data.value('./@Occurrence', 'nvarchar(100)') as Occurrence, " + _
                    "OD.data.value('./@Origin', 'nvarchar(100)') as Origin " + _
                    " from tblOtherData " + _
                    " inner join tblflatname cn on cn.flatnamenameufk = recordfk " + _
                    " inner join tblflatname n on cn.flatnamenameufk = n.flatnameseedname " + _
                    "cross apply OtherDataXml.nodes('/DataSet/Biostat') as OD(data) " + _
                    " where n.flatnamenameufk = '" + nameGuid + "' and " + _
                 "OD.data.exist('/DataSet/Biostat[contains(@Occurrence, ""Present"")]') = 1 "

                cmd.CommandText = Sql
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

                'get regions
                Dim geos As String = ","
                If ds.Tables.Count > 0 Then
                    For Each dr As DataRow In ds.Tables(0).Rows

                        Dim cd As String = dr("Region").ToString
                        Dim tg As TDWGGeo = Distribution.GetTDWGeoByCode(cd)
                        If tg IsNot Nothing Then

                            If Not dr.IsNull("Origin") AndAlso dr("Origin").ToString.Length > 0 Then
                                Dim st As String = dr("Origin").ToString.ToLower
                                If st.StartsWith("endemic") Then
                                    tg.Status = GeoStatus.Endemic
                                ElseIf st.StartsWith("indigenous") Then
                                    tg.Status = GeoStatus.Indigenous
                                ElseIf st.StartsWith("exotic") Then
                                    tg.Status = GeoStatus.Exotic
                                End If
                            ElseIf Not dr.IsNull("Occurrence") Then
                                If dr("Occurrence").ToString.ToLower.StartsWith("present") Then
                                    tg.Status = GeoStatus.Present
                                End If
                            End If

                            geo.Add(tg)
                        End If

                    Next
                End If

            End Using
        End Using


        Return geo
    End Function

    Public Function GetNameDistribution(ByVal nameGuid As String) As List(Of TDWGGeo)
        Dim geo As New List(Of TDWGGeo)

        Dim ds As New DataSet

        Using cnn As New SqlConnection(ConnectionString)
            cnn.Open()

            Using cmd As New SqlCommand
                cmd.Connection = cnn

                Dim sql As String = "set arithabort on; select OD.data.value('./@schema', 'nvarchar(100)') as [Schema], " + _
                    "OD.data.value('./@region', 'nvarchar(100)') as Region, " + _
                    "OD.data.value('./@Occurrence', 'nvarchar(100)') as Occurrence, " + _
                    "OD.data.value('./@Origin', 'nvarchar(100)') as Origin " + _
                    " from tblOtherData " + _
                    "cross apply OtherDataXml.nodes('/DataSet/Biostat') as OD(data) " + _
                    "where RecordFk = '" + nameGuid + "' and " + _
                 "OD.data.exist('/DataSet/Biostat[contains(@Occurrence, ""Present"")]') = 1 "
                '"OD.data.exist('/DataSet/Biostat[contains(@schema, ""TDWG Level"")]') = 1 "

                cmd.CommandText = sql
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(ds)

                'get regions
                Dim geos As String = ","
                If ds.Tables.Count > 0 Then
                    For Each dr As DataRow In ds.Tables(0).Rows

                        Dim cd As String = dr("Region").ToString
                        Dim tg As TDWGGeo = Distribution.GetTDWGeoByCode(cd)
                        If tg IsNot Nothing Then

                            If Not dr.IsNull("Origin") Then
                                Dim st As String = dr("Origin").ToString.ToLower
                                If st.StartsWith("endemic") Then
                                    tg.Status = GeoStatus.Endemic
                                ElseIf st.StartsWith("indigenous") Then
                                    tg.Status = GeoStatus.Indigenous
                                ElseIf st.StartsWith("exotic") Then
                                    tg.Status = GeoStatus.Exotic
                                End If
                            ElseIf Not dr.IsNull("Occurrence") Then
                                If dr("Occurrence").ToString.ToLower.StartsWith("present") Then
                                    tg.Status = GeoStatus.Present
                                End If
                            End If

                            geo.Add(tg)
                        End If

                        'If dr("Schema").ToString.ToLower = "tdwg level 4" Then
                        '    Dim cd As String = dr("Region").ToString
                        '    If cd.ToString.IndexOf("-") <> -1 Then
                        '        cd = cd.Substring(0, cd.IndexOf("-"))
                        '    End If

                        '    If geos.IndexOf("," + cd + ",") = -1 Then
                        '        Dim tg As New TDWGGeo ' = Distribution.GetTDWGeoByName(TDWGGeoLevel.TDWG3, cd)
                        '        tg.Code = cd
                        '        tg.Level = TDWGGeoLevel.TDWG4
                        '        geo.Add(tg)
                        '    End If

                        'ElseIf dr("Schema").ToString.ToLower = "tdwg level 3" Then
                        '    Dim cd As String = dr("Region").ToString
                        '    Dim tg As New TDWGGeo ' = Distribution.GetTDWGeoByName(TDWGGeoLevel.TDWG3, cd)
                        '    tg.Code = cd
                        '    tg.Level = TDWGGeoLevel.TDWG3
                        '    geo.Add(tg)

                        'ElseIf dr("Schema").ToString.ToLower = "tdwg level 2" Then
                        '    Dim cd As String = dr("Region").ToString
                        '    Dim tg As New TDWGGeo
                        '    tg.Code = cd
                        '    tg.Level = TDWGGeoLevel.TDWG2
                        '    geo.Add(tg)

                        'ElseIf dr("Schema").ToString.ToLower = "tdwg level 1" Then
                        '    Dim cd As String = dr("Region").ToString
                        '    Dim tg As New TDWGGeo
                        '    tg.Code = cd
                        '    tg.Level = TDWGGeoLevel.TDWG1
                        '    geo.Add(tg)

                        'End If
                    Next
                End If

            End Using
        End Using


        Return geo
    End Function
End Class

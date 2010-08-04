Public Class Rank
    Inherits BaseObject

    Public RankAbbreviation As String
    Public RankTCS As String
    Public RankKnownAbbreviations As String
    Public RankSort As Integer = -1
    Public RankMatchRuleSetFk As Integer = -1

    Public Sub New()
    End Sub

    Public Sub New(ByVal row As DataRow, ByVal recId As String)
        MyBase.New(row, recId)
        'LoadFieldsFromRow(row)

        Name = row("RankName").ToString
        RankAbbreviation = row("RankAbbreviation").ToString
        RankTCS = row("RankTCS").ToString
        RankKnownAbbreviations = row("RankKnownAbbreviations").ToString
        If Not row.IsNull("RankSort") Then RankSort = row("RankSort")
        If Not row.IsNull("RankMatchRuleSetFk") Then RankMatchRuleSetFk = row("RankMatchRuleSetFk")
    End Sub
End Class

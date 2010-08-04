Public Class DaTrees
    Inherits System.ComponentModel.Component

#Region " Component Designer generated code "

    Public Sub New(Container As System.ComponentModel.IContainer)
        MyClass.New()

        'Required for Windows.Forms Class Composition Designer support
        Container.Add(me)
    End Sub

    Public Sub New()
        MyBase.New()

        'This call is required by the Component Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call
        ConnectionString = ""

    End Sub

    'Component overrides dispose to clean up the component list.
    Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
        If disposing Then
            If Not (components Is Nothing) Then
                components.Dispose()
            End If
        End If
        MyBase.Dispose(disposing)
    End Sub

    'Required by the Component Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Component Designer
    'It can be modified using the Component Designer.
    'Do not modify it using the code editor.
    Friend WithEvents SqlConNuku As System.Data.SqlClient.SqlConnection
    Friend WithEvents SqlDaTreeNodes As System.Data.SqlClient.SqlDataAdapter
    Friend WithEvents SqlComGetNodes As System.Data.SqlClient.SqlCommand
    Friend WithEvents SqlDaNodeToRoot As System.Data.SqlClient.SqlDataAdapter
    Friend WithEvents SqlComSelect_NodeToRoot As System.Data.SqlClient.SqlCommand
    Friend WithEvents SqlDaTreeState As System.Data.SqlClient.SqlDataAdapter
    Friend WithEvents SqlComDeleteTreeState As System.Data.SqlClient.SqlCommand
    Friend WithEvents SqlComGetTreeState As System.Data.SqlClient.SqlCommand
    Friend WithEvents SqlComNewTreeState As System.Data.SqlClient.SqlCommand
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.SqlConNuku = New System.Data.SqlClient.SqlConnection()
        Me.SqlDaTreeNodes = New System.Data.SqlClient.SqlDataAdapter()
        Me.SqlComGetNodes = New System.Data.SqlClient.SqlCommand()
        Me.SqlDaNodeToRoot = New System.Data.SqlClient.SqlDataAdapter()
        Me.SqlComSelect_NodeToRoot = New System.Data.SqlClient.SqlCommand()
        Me.SqlDaTreeState = New System.Data.SqlClient.SqlDataAdapter()
        Me.SqlComDeleteTreeState = New System.Data.SqlClient.SqlCommand()
        Me.SqlComGetTreeState = New System.Data.SqlClient.SqlCommand()
        Me.SqlComNewTreeState = New System.Data.SqlClient.SqlCommand()
        '
        'SqlConNuku
        '
      Me.SqlConNuku.ConnectionString = "data source=DEVSERVER01;initial catalog=Nuku;password=;persist securit" & _
      "y info=True;user id=DevEnv;workstation id=Dev10;packet size=4096"
        '
        'SqlDaTreeNodes
        '
        Me.SqlDaTreeNodes.SelectCommand = Me.SqlComGetNodes
        Me.SqlDaTreeNodes.TableMappings.AddRange(New System.Data.Common.DataTableMapping() {New System.Data.Common.DataTableMapping("Table", "sprGetNode", New System.Data.Common.DataColumnMapping() {New System.Data.Common.DataColumnMapping("NameParentFk", "NameParentFk"), New System.Data.Common.DataColumnMapping("NameGuid", "NameGuid"), New System.Data.Common.DataColumnMapping("NameCanonical", "NameCanonical"), New System.Data.Common.DataColumnMapping("NameTaxonRankFk", "NameTaxonRankFk"), New System.Data.Common.DataColumnMapping("ChildCount", "ChildCount"), New System.Data.Common.DataColumnMapping("NameMisapplied", "NameMisapplied"), New System.Data.Common.DataColumnMapping("NameAuthors", "NameAuthors"), New System.Data.Common.DataColumnMapping("NameInEd", "NameInEd"), New System.Data.Common.DataColumnMapping("NameYearOfPublication", "NameYearOfPublication"), New System.Data.Common.DataColumnMapping("NameFull", "NameFull"), New System.Data.Common.DataColumnMapping("PermissionsPk", "PermissionsPk"), New System.Data.Common.DataColumnMapping("PermissionsRead", "PermissionsRead"), New System.Data.Common.DataColumnMapping("PermissionsWrite", "PermissionsWrite"), New System.Data.Common.DataColumnMapping("PermissionsAddChildren", "PermissionsAddChildren"), New System.Data.Common.DataColumnMapping("PermissionsChangeLinks", "PermissionsChangeLinks"), New System.Data.Common.DataColumnMapping("PermissionsModifyPermission", "PermissionsModifyPermission"), New System.Data.Common.DataColumnMapping("InheritedPermissionsPk", "InheritedPermissionsPk"), New System.Data.Common.DataColumnMapping("InheritedPermissionsRead", "InheritedPermissionsRead"), New System.Data.Common.DataColumnMapping("InheritedPermissionsWrite", "InheritedPermissionsWrite"), New System.Data.Common.DataColumnMapping("InheritedPermissionsAddChildren", "InheritedPermissionsAddChildren"), New System.Data.Common.DataColumnMapping("InheritedPermissionsChangeLinks", "InheritedPermissionsChangeLinks"), New System.Data.Common.DataColumnMapping("InheritedPermissionsModifyPermission", "InheritedPermissionsModifyPermission"), New System.Data.Common.DataColumnMapping("NameCurrentFk", "NameCurrentFk")})})
        '
        'SqlComGetNodes
        '
        Me.SqlComGetNodes.CommandText = "dbo.sprGetNode"
        Me.SqlComGetNodes.CommandType = System.Data.CommandType.StoredProcedure
        Me.SqlComGetNodes.Connection = Me.SqlConNuku
        Me.SqlComGetNodes.Parameters.Add(New System.Data.SqlClient.SqlParameter("@RETURN_VALUE", System.Data.SqlDbType.Int, 4, System.Data.ParameterDirection.ReturnValue, True, CType(10, Byte), CType(0, Byte), "", System.Data.DataRowVersion.Current, Nothing))
        Me.SqlComGetNodes.Parameters.Add(New System.Data.SqlClient.SqlParameter("@NameGuid", System.Data.SqlDbType.UniqueIdentifier, 0, System.Data.ParameterDirection.Input, True, CType(0, Byte), CType(0, Byte), "", System.Data.DataRowVersion.Current, Nothing))
        Me.SqlComGetNodes.Parameters.Add(New System.Data.SqlClient.SqlParameter("@intClassificationKey", System.Data.SqlDbType.Int))
        Me.SqlComGetNodes.Parameters.Add(New System.Data.SqlClient.SqlParameter("@intRoleKey", System.Data.SqlDbType.Int))
        Me.SqlComGetNodes.Parameters.Add(New System.Data.SqlClient.SqlParameter("@bitDoSuppress", System.Data.SqlDbType.Bit))
        '
        'SqlDaNodeToRoot
        '
        Me.SqlDaNodeToRoot.SelectCommand = Me.SqlComSelect_NodeToRoot
        Me.SqlDaNodeToRoot.TableMappings.AddRange(New System.Data.Common.DataTableMapping() {New System.Data.Common.DataTableMapping("Table", "sprSelect_NodeToRoot", New System.Data.Common.DataColumnMapping(-1) {})})
        '
        'SqlComSelect_NodeToRoot
        '
        Me.SqlComSelect_NodeToRoot.CommandText = "dbo.[sprSelect_NodeToRoot]"
        Me.SqlComSelect_NodeToRoot.CommandType = System.Data.CommandType.StoredProcedure
        Me.SqlComSelect_NodeToRoot.Connection = Me.SqlConNuku
        Me.SqlComSelect_NodeToRoot.Parameters.Add(New System.Data.SqlClient.SqlParameter("@RETURN_VALUE", System.Data.SqlDbType.Int, 4, System.Data.ParameterDirection.ReturnValue, False, CType(10, Byte), CType(0, Byte), "", System.Data.DataRowVersion.Current, Nothing))
        Me.SqlComSelect_NodeToRoot.Parameters.Add(New System.Data.SqlClient.SqlParameter("@StartNodeKey", System.Data.SqlDbType.UniqueIdentifier, 0, System.Data.ParameterDirection.Input, False, CType(10, Byte), CType(0, Byte), "", System.Data.DataRowVersion.Current, Nothing))
        Me.SqlComSelect_NodeToRoot.Parameters.Add(New System.Data.SqlClient.SqlParameter("@intClassificationKey", System.Data.SqlDbType.Int, 4, System.Data.ParameterDirection.Input, False, CType(10, Byte), CType(0, Byte), "", System.Data.DataRowVersion.Current, Nothing))
        Me.SqlComSelect_NodeToRoot.Parameters.Add(New System.Data.SqlClient.SqlParameter("@intRoleKey", System.Data.SqlDbType.Int, 4, System.Data.ParameterDirection.Input, False, CType(10, Byte), CType(0, Byte), "", System.Data.DataRowVersion.Current, Nothing))
        '
        'SqlDaTreeState
        '
        Me.SqlDaTreeState.TableMappings.AddRange(New System.Data.Common.DataTableMapping() {New System.Data.Common.DataTableMapping("Table", "dbo.spruGetTreeState", New System.Data.Common.DataColumnMapping() {New System.Data.Common.DataColumnMapping("TreeStatePk", "TreeStatePk"), New System.Data.Common.DataColumnMapping("TreeStateSession", "TreeStateSession"), New System.Data.Common.DataColumnMapping("TreeStateXml", "TreeStateXml"), New System.Data.Common.DataColumnMapping("TreeStateDateAdded", "TreeStateDateAdded"), New System.Data.Common.DataColumnMapping("TreeStateLastAccessed", "TreeStateLastAccessed")})})
        '
        'SqlComDeleteTreeState
        '
        Me.SqlComDeleteTreeState.CommandText = "dbo.sprdDeleteTreeState"
        Me.SqlComDeleteTreeState.CommandType = System.Data.CommandType.StoredProcedure
        Me.SqlComDeleteTreeState.Connection = Me.SqlConNuku
        Me.SqlComDeleteTreeState.Parameters.Add(New System.Data.SqlClient.SqlParameter("@RETURN_VALUE", System.Data.SqlDbType.Int, 4, System.Data.ParameterDirection.ReturnValue, True, CType(10, Byte), CType(0, Byte), "", System.Data.DataRowVersion.Current, Nothing))
        Me.SqlComDeleteTreeState.Parameters.Add(New System.Data.SqlClient.SqlParameter("@intTreeStatePk", System.Data.SqlDbType.Int, 4, System.Data.ParameterDirection.Input, True, CType(10, Byte), CType(0, Byte), "", System.Data.DataRowVersion.Current, Nothing))
        '
        'SqlComGetTreeState
        '
        Me.SqlComGetTreeState.CommandText = "dbo.spruGetTreeState"
        Me.SqlComGetTreeState.CommandType = System.Data.CommandType.StoredProcedure
        Me.SqlComGetTreeState.Connection = Me.SqlConNuku
        Me.SqlComGetTreeState.Parameters.Add(New System.Data.SqlClient.SqlParameter("@RETURN_VALUE", System.Data.SqlDbType.Int, 4, System.Data.ParameterDirection.ReturnValue, True, CType(10, Byte), CType(0, Byte), "", System.Data.DataRowVersion.Current, Nothing))
        Me.SqlComGetTreeState.Parameters.Add(New System.Data.SqlClient.SqlParameter("@intTreeStateKey", System.Data.SqlDbType.Int, 4, System.Data.ParameterDirection.Input, True, CType(10, Byte), CType(0, Byte), "", System.Data.DataRowVersion.Current, Nothing))
        Me.SqlComGetTreeState.Parameters.Add(New System.Data.SqlClient.SqlParameter("@intTreeStateSession", System.Data.SqlDbType.Int, 4, System.Data.ParameterDirection.Output, True, CType(10, Byte), CType(0, Byte), "", System.Data.DataRowVersion.Current, Nothing))
        Me.SqlComGetTreeState.Parameters.Add(New System.Data.SqlClient.SqlParameter("@datTreeStateDateAdded", System.Data.SqlDbType.DateTime, 8, System.Data.ParameterDirection.Output, True, CType(0, Byte), CType(0, Byte), "", System.Data.DataRowVersion.Current, Nothing))
        Me.SqlComGetTreeState.Parameters.Add(New System.Data.SqlClient.SqlParameter("@datTreeStateLastAccessed", System.Data.SqlDbType.DateTime, 8, System.Data.ParameterDirection.Output, True, CType(0, Byte), CType(0, Byte), "", System.Data.DataRowVersion.Current, Nothing))
        '
        'SqlComNewTreeState
        '
        Me.SqlComNewTreeState.CommandText = "dbo.spriNewTreeState"
        Me.SqlComNewTreeState.CommandType = System.Data.CommandType.StoredProcedure
        Me.SqlComNewTreeState.Connection = Me.SqlConNuku
        Me.SqlComNewTreeState.Parameters.Add(New System.Data.SqlClient.SqlParameter("@RETURN_VALUE", System.Data.SqlDbType.Int, 4, System.Data.ParameterDirection.ReturnValue, True, CType(10, Byte), CType(0, Byte), "", System.Data.DataRowVersion.Current, Nothing))
        Me.SqlComNewTreeState.Parameters.Add(New System.Data.SqlClient.SqlParameter("@intTreeStateSession", System.Data.SqlDbType.Int, 4, System.Data.ParameterDirection.Input, True, CType(10, Byte), CType(0, Byte), "", System.Data.DataRowVersion.Current, Nothing))
        Me.SqlComNewTreeState.Parameters.Add(New System.Data.SqlClient.SqlParameter("@txtTreeStateXml", System.Data.SqlDbType.NText, 1073741823, System.Data.ParameterDirection.Input, True, CType(0, Byte), CType(0, Byte), "", System.Data.DataRowVersion.Current, Nothing))
        Me.SqlComNewTreeState.Parameters.Add(New System.Data.SqlClient.SqlParameter("@intTreeStatePk", System.Data.SqlDbType.Int, 4, System.Data.ParameterDirection.Output, True, CType(10, Byte), CType(0, Byte), "", System.Data.DataRowVersion.Current, Nothing))

    End Sub

#End Region


#Region "Properties"

    Public Property ConnectionString() As String
        Get
            Return SqlConNuku.ConnectionString
        End Get
        Set(ByVal Value As String)
            SqlConNuku.ConnectionString = Value
        End Set
    End Property

#End Region


    Public Sub DaInitialise(ByVal ConnectionString As String)
        Me.ConnectionString = ConnectionString

    End Sub



#Region "TaxTree State"

    Public Function InsertTaxTreeState(ByVal strXml As String, ByVal Session As Long) As Long

        '@intTreeStateSession
        '@txtTreeStateXml	
        '@intTreeStatePk		

        SqlComNewTreeState.Parameters("@txtTreeStateXml").Value = strXml
        SqlComNewTreeState.Parameters("@intTreeStateSession").Value = Session

        SqlComNewTreeState.Parameters("@intTreeStatePk").Value = Nothing

        SqlComNewTreeState.Connection.Open()
        SqlComNewTreeState.ExecuteScalar()
        SqlComNewTreeState.Connection.Close()

        Return SqlComNewTreeState.Parameters("@intTreeStatePk").Value
    End Function

    Public Function GetTaxTreeState(ByVal StateId As Long) As String
        '@intTreeStateKey			int,
        '@intTreeStateSession		int,
        '@datTreeStateDateAdded		datetime,
        '@datTreeStateLastAccessed	datetime

        SqlComGetTreeState.Parameters("@intTreeStateKey").Value = StateId

        SqlComGetTreeState.Connection.Open()
        Dim strXml As String = SqlComGetTreeState.ExecuteScalar()
        SqlComGetTreeState.Connection.Close()

        Dim SessionId As Long
        'If SqlComGetTreeState.Parameters("@intTreeStateSession").Value Then
        'SessionId = 0
        'Else
        'SessionId = SqlComGetTreeState.Parameters("@intTreeStateSession").Value
        'End If

        'Dim DateAdded As Date = SqlComGetTreeState.Parameters("@datTreeStateDateAdded").Value
        'Dim DateLastAccessed As Date = SqlComGetTreeState.Parameters("@datTreeStateLastAccessed").Value
        Return strXml
    End Function

    Public Function DeleteTaxTreeState(ByVal TaxTreeStateKey As Long)

        SqlComDeleteTreeState.Parameters("@intTreeStatePk").Value = TaxTreeStateKey

        SqlComDeleteTreeState.Connection.Open()
        SqlComDeleteTreeState.ExecuteScalar()
        SqlComDeleteTreeState.Connection.Close()
    End Function

#End Region

#Region "Tree"

    Public Function GetTaxTreeNodes(ByVal ParentNodeId As String, ByVal ClassificationKey As Long, Optional ByVal DoSuppress As Boolean = False) As DsTaxTreeNode
        Dim ds As DsTaxTreeNode = New DsTaxTreeNode()

        SqlComGetNodes.Parameters("@NameGuid").Value = New Guid(ParentNodeId)
        SqlComGetNodes.Parameters("@intClassificationKey").Value = ClassificationKey
        SqlComGetNodes.Parameters("@bitDoSuppress").Value = DoSuppress
        SqlComGetNodes.CommandTimeout = 60

        SqlDaTreeNodes.SelectCommand.Parameters("@intRoleKey").Value = DBNull.Value 'for permissions

        Try
            SqlDaTreeNodes.Fill(ds)
        Catch ex As Exception
            Debug.WriteLine(ex.Message)
            Throw ex
        End Try

        Return ds

    End Function

    Public Function GetNodeToRoot(ByVal NodeKey As String, ByVal ClassificationKey As Long) As DsNodeToRoot
        Dim ds As New DsNodeToRoot()
        SqlComSelect_NodeToRoot.Parameters("@StartNodeKey").Value = New Guid(NodeKey)
        SqlComSelect_NodeToRoot.Parameters("@intClassificationKey").Value = ClassificationKey
        SqlComSelect_NodeToRoot.Parameters("@intRoleKey").Value = DBNull.Value 'for permissions
        
        SqlDaNodeToRoot.Fill(ds)
        Return ds
    End Function

    Public Function GetRootKey() As String
        Dim cmd As New SqlClient.SqlCommand
        cmd.Connection = New SqlClient.SqlConnection(ConnectionString)
        cmd.CommandText = "sprSelect_RootKey"
        cmd.CommandType = CommandType.StoredProcedure
        cmd.Connection.Open()

        Dim key As String = cmd.ExecuteScalar

        cmd.Connection.Close()

        Return key
    End Function

#End Region





End Class

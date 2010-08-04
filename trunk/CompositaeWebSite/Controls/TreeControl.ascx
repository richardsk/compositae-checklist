<%@ Control Language="vb" AutoEventWireup="false" Inherits="TreeControl" CodeFile="TreeControl.ascx.vb" %>

<div style="border:solid 1px black;width:235px" >
    <asp:CheckBox ID="allNamesCheck" runat="server" AutoPostBack="True" Font-Size="Smaller"
        Text="Include names with unknown status" meta:resourcekey="allNamesCheckResource1" />

    <asp:Panel ID="panel1" runat="server" ScrollBars="Auto" Width="230px" Height="220px" meta:resourcekey="panel1Resource1">
        
    </asp:Panel>
    &nbsp;
    
    <p style="font-size:smaller">
    <b>&nbsp;<asp:Label ID="Label1" runat="server" Font-Bold="True" Text="Tree colour key:" meta:resourcekey="Label1Resource1"></asp:Label></b><br />
        &nbsp;&nbsp;
        <asp:Label ID="Label2" runat="server" Font-Bold="True" Text="Bold" meta:resourcekey="Label2Resource1"></asp:Label>
        -
        <asp:Label ID="Label3" runat="server" Text="accepted names" meta:resourcekey="Label3Resource1"></asp:Label><br />
        &nbsp;&nbsp;
        <asp:Label ID="Label4" runat="server" Text="Normal" meta:resourcekey="Label4Resource1"></asp:Label>
        -
        <asp:Label ID="Label6" runat="server" Text="synonyms" meta:resourcekey="Label6Resource1"></asp:Label><br />
        &nbsp;&nbsp;<span style="color:Gray;"></span> 
        <asp:Label ID="Label5" runat="server" ForeColor="Green" Text="Green" meta:resourcekey="Label5Resource1"></asp:Label>
        -
        <asp:Label ID="Label7" runat="server" Text="no concept" meta:resourcekey="Label7Resource1"></asp:Label><br />
        &nbsp;&nbsp;<span style="color:Red;"></span> 
        <asp:Label ID="Label8" runat="server" ForeColor="Red" Text="Red" meta:resourcekey="Label8Resource1"></asp:Label>
        -
        <asp:Label ID="Label9" runat="server" Text="invalid or illegitimate unknown" meta:resourcekey="Label9Resource1"></asp:Label><br />
        &nbsp;&nbsp;<span style="color:Red;"></span> 
        <asp:Label ID="Label10" runat="server" ForeColor="Purple" Font-Bold="True" Text="Purple" meta:resourcekey="Label10Resource1"></asp:Label>
        -
        <asp:Label ID="Label11" runat="server" Text="invalid or illegitimate synonyms" meta:resourcekey="Label11Resource1"></asp:Label><br />
    </p>
</div>
    




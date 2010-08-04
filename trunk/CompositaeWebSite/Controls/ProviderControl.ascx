<%@ Control Language="VB" AutoEventWireup="false" CodeFile="ProviderControl.ascx.vb" Inherits="Controls_ProviderControl" %>

<table width="100%">
    <tr>
        <td>
            <asp:Label Width="100%" ID="Label1" runat="server" CssClass="BlockHeader" Text="Provider Details" meta:resourcekey="Label1Resource1"></asp:Label><br />
            &nbsp;<asp:HyperLink ID="dataProvLink" runat="server" NavigateUrl="~/default.aspx?Page=ProviderList" meta:resourcekey="dataProvLinkResource1">Data Providers</asp:HyperLink>
        </td>
    </tr>
</table>    
<br />

<asp:GridView ID="DetailsGrid" runat="server" AutoGenerateColumns="False" BorderStyle="None" BorderWidth="0px" Font-Size="Medium" ShowHeader="False" GridLines="None" meta:resourcekey="DetailsGridResource1">
    <RowStyle VerticalAlign="Top" />
</asp:GridView>

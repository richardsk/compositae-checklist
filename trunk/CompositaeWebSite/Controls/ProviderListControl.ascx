<%@ Control Language="VB" AutoEventWireup="false" CodeFile="ProviderListControl.ascx.vb" Inherits="Controls_ProviderListControl" %>
<table width="100%">
    <tr>
        <td>
            <asp:Label ID="NameLabel" runat="server" Text="Data Providers" CssClass="BlockHeader" meta:resourcekey="NameLabelResource1" Width="100%"></asp:Label><br />
&nbsp;<asp:HyperLink ID="dataProvLink" runat="server" NavigateUrl="~/default.aspx?Page=ProviderList">Data Providers</asp:HyperLink>&nbsp;
            <asp:HyperLink ID="HyperLink2" runat="server" NavigateUrl="~/default.aspx?Page=ProviderList&coverage=true">Coverage Map</asp:HyperLink>
            <br /><br />
            <asp:PlaceHolder runat="server" ID="mapPlaceholder"></asp:PlaceHolder>
            <asp:DataList ForeColor="black" ID="DetailsGridView" runat="server" BorderWidth="0px" Font-Size="Medium"  >
                <ItemTemplate >
                <a href="default.aspx?Page=Provider&ProviderId=<%# DataBinder.Eval(Container.DataItem, "ProviderId") %>" >
                    <%# DataBinder.Eval(Container.DataItem, "ProviderName") %>
                </a>                           
                </ItemTemplate>
            </asp:DataList>
        </td>
    </tr>
</table>
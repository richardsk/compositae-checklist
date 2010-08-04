<%@ Control Language="VB" AutoEventWireup="false" CodeFile="HomeControl.ascx.vb" Inherits="HomeControl" %>
<%@ Register Src="MapControl.ascx" TagName="MapControl" TagPrefix="uc1" %>
    
<table width="100%" >
    <tr>
        <td align="center" valign="top" style="height: 20px">
            <asp:Label ID="Label5" Height="24px" runat="server" Text="Search Names" meta:resourcekey="Label5Resource1" BackColor="#DBBC57" BorderColor="Black" BorderStyle="Solid" BorderWidth="1px" ForeColor="White" Width="100%"></asp:Label></td>
        <td rowspan="4" style="padding-left: 4px; width:55%" valign="top">
        <table style="width:100%; border-right: black 1px solid; border-top: black 1px solid; border-left: black 1px solid; border-bottom: black 1px solid; border-collapse: collapse; border-top-width:0" cellpadding="0" cellspacing="0" >
            <tr>
                <td align="center" colspan="2" valign="top">
                    <asp:Label ID="Label2" runat="server" Text="Search by Distribution BETA" meta:resourcekey="Label2Resource1" BackColor="#DBBC57" BorderColor="Black" BorderStyle="Solid" BorderWidth="1px" ForeColor="White" Height="24px" Width="100%"></asp:Label></td>                
            </tr>
            <tr>
                <td colspan="2" align="center" >
                    <uc1:MapControl ID="MapControl1" runat="server" />
                </td>
            </tr>
            <tr>
                <td style="border-right: black 1px solid; border-top: black 1px solid; border-left: black 1px solid; border-bottom: black 1px solid; background-color: #dbbc57; color: white;" align="center">
                    <asp:Label ID="Label3" runat="server" Text="Continent (TDWG Level 1)" meta:resourcekey="Label3Resource1"></asp:Label></td>
                <td style="border-right: black 1px solid; border-top: black 1px solid; border-left: black 1px solid;
                    border-bottom: black 1px solid; background-color: #dbbc57; color: white;" align="center">
                    <asp:Label ID="Label4" runat="server" Text="Region (TDWG Level 2)" meta:resourcekey="Label4Resource2" ></asp:Label></td>
            </tr>
            <tr>
                <td>
                    <asp:DropDownList ID="continentsCombo" runat="server" meta:resourcekey="continentsComboResource1">
                    </asp:DropDownList>                    
                    &nbsp;<asp:Button ID="contSearchButton" runat="server" Text="Search" meta:resourcekey="contSearchButtonResource1" />
                </td>
                <td>
                    <asp:DropDownList ID="regionCombo" runat="server" meta:resourcekey="regionComboResource1" >
                    </asp:DropDownList>&nbsp;<asp:Button ID="RegionSearchButton" runat="server" Text="Search" meta:resourcekey="RegionSearchButtonResource1"  />
                </td>
            </tr>
            <tr>
                <td style="border-right: black 1px solid; border-top: black 1px solid; border-left: black 1px solid; border-bottom: black 1px solid; background-color: #dbbc57; color: white;" align="center">
                    <asp:Label ID="Label6" runat="server" Text="Botanical Country (TDWG Level 3)" meta:resourcekey="Label6Resource1"></asp:Label></td>
                <td style="border-right: black 1px solid; border-top: black 1px solid; border-left: black 1px solid;
                    border-bottom: black 1px solid; background-color: #dbbc57; color: white;" align="center">
                    <asp:Label ID="Label7" runat="server" Text="Basic Recording Unit (TDWG Level 4)" meta:resourcekey="Label7Resource1" ></asp:Label></td>
            </tr>
            <tr>
                <td>
                    <asp:DropDownList ID="countryCombo" runat="server" meta:resourcekey="countryComboResource2" >
                    </asp:DropDownList>                    
                    &nbsp;<asp:Button ID="countryButton" runat="server" Text="Search" meta:resourcekey="countryButtonResource1" />
                </td>
                <td>
                    <asp:DropDownList ID="basicUnitCombo" runat="server" meta:resourcekey="basicUnitComboResource1" >
                    </asp:DropDownList>
                    &nbsp;<asp:Button ID="basicUnitButton" runat="server" Text="Search" meta:resourcekey="basicUnitButtonResource1"  />
                </td>
            </tr>
        </table>
            &nbsp;</td>
    </tr>
    <tr>
    <td valign="top">
        <asp:Label ID="Label1" Font-Size="small" runat="server" Text='Welcome to the Global Compositae Checklist - a searchable integrated database of nomenclatural and taxonomic information for one of the largest plant families in the world (also known as the Asteraceae). The database is compiled from many contributed datasets and is continually being edited and updated and should be considered a working checklist.  <a href="default.aspx?Page=Feedback" style="color:black">Feedback is welcome</a>' meta:resourcekey="Label1Resource3"></asp:Label>
        
    </td>    
    </tr>
    <tr>
        <td style="height: 30px;" valign="top">
            <asp:TextBox ID="SearchText" runat="server" Columns="35" MaxLength="100" meta:resourcekey="SearchTextResource1"></asp:TextBox><asp:Button
                ID="SearchButton" runat="server" Text="Search" meta:resourcekey="SearchButtonResource2" />
            <br />
            <asp:HyperLink ID="moreSearching2" runat="server" CssClass="smaller" ForeColor="Black" meta:resourcekey="searchNamesLinkResource1"
                NavigateUrl="~/Default.aspx?Page=AdvNameSearch" Text="Advanced search"></asp:HyperLink></td>
    </tr>
</table>



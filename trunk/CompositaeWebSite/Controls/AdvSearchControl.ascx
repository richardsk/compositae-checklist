<%@ Control Language="VB" AutoEventWireup="false" CodeFile="AdvSearchControl.ascx.vb" Inherits="Controls_AdvSearchControl" %>
<table class="smaller">
    <tr>
        <td class="bold" style="width: 107px">
            <asp:Label ID="Label2" runat="server" meta:resourcekey="Label2Resource1" Text="Field"></asp:Label></td>
        <td style="width: 231px">
            <asp:DropDownList ID="Field1" runat="server" AutoPostBack="True" meta:resourcekey="Field1Resource1"
                Width="205px">
            </asp:DropDownList></td>
    </tr>
    <tr>
        <td class="bold" style="width: 107px">
            <asp:Label ID="Label8" runat="server" meta:resourcekey="Label8Resource1" Text="Search Text"></asp:Label></td>
        <td style="width: 231px">
            <asp:TextBox ID="SearchText1" runat="server" MaxLength="50" meta:resourcekey="SearchText1Resource1"
                Width="200px"></asp:TextBox>
            <asp:DropDownList ID="provCombo1" runat="server" Visible="False" Width="205px">
            </asp:DropDownList>
            <asp:DropDownList ID="geoCombo" runat="server" Visible="false" Width="205px" >
            </asp:DropDownList>
        </td>
    </tr>
    <tr>
        <td style="width: 107px">
            </td>
        <td style="width: 231px">
            <label for="AdvancedSearchControl1_cbxAnywhereInText1">
                <asp:CheckBox ID="AnywhereCheck1" runat="server" Checked="True" meta:resourcekey="AnywhereCheck1Resource1"
                    Text="Anywhere in text" /></label>
            &nbsp;<label for="AdvancedSearchControl1_cbxWholeWord1">
                <asp:CheckBox ID="WholeWordCheck1" runat="server" meta:resourcekey="WholeWordCheck1Resource1"
                    Text="Whole Word" /></label></td>
    </tr>
    <tr>
        <td style="width: 107px">
            <asp:Image ID="downArrowImg" runat="server" ImageUrl="~/images/DownArrow.gif" ></asp:Image> &nbsp;
            <asp:CheckBox ID="AndCheck1" runat="server" AutoPostBack="True" meta:resourcekey="AndCheck1Resource1"
                Text="And" /></td>
        <td align="right" style="width: 231px">
            <span id="AdvancedSearchControl1_RequiredFieldValidator2" controltovalidate="AdvancedSearchControl1_txtSearchText1"
                errormessage="Enter in search criteria." initialvalue="" isvalid="true" style="font-weight: bold;
                visibility: hidden; color: red"></span>
            <asp:CheckBox ID="OrCheck1" runat="server" AutoPostBack="True" meta:resourcekey="OrCheck1Resource1"
                Text="Or" />
            <asp:Image runat="server" ID="rightArrowImg" ImageUrl="~/images/RightArrow.gif" ></asp:Image></td>
    </tr>
</table>

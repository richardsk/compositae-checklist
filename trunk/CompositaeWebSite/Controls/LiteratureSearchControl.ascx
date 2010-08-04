<%@ Control Language="VB" AutoEventWireup="false" CodeFile="LiteratureSearchControl.ascx.vb" Inherits="Controls_LiteratureSearchControl" %>

                            <script id="clientEventHandlersJS" language="javascript">
<!--

function RangeSearchSwitch_onclick() {
	var x = document.getElementById('SearchControl1_cbxRangeSearch');
	if(!x.checked)
	{
		RangeSearchRow.style.display = "none";
	}	
	else
	{
		RangeSearchRow.style.display = "block";
	}	
}

    

//-->
                            </script>
    
<table width="100%">
    <tr>
        <td>
            <p>
                <span id="SearchControl1_lblSearchHeading" class="PageHeading" style="font-size: 17pt">
                    
                <asp:Label ID="Label1" runat="server" Text="Literature Search" meta:resourcekey="Label1Resource1"></asp:Label>
                </span>
                </p>
            <table class="searchBox">
                <tr>
                    <td>
                        <table>
                            <tr>
                                <td style="height: 7px">
                                    <span id="SearchControl1_Label2" class="smaller_bold" style="font-weight: bold; font-size: 8pt">
                                        <asp:Label ID="Label2" runat="server" Text="Search Text" meta:resourcekey="Label2Resource1"></asp:Label></span></td>
                                <td style="font-size: 8pt; height: 7px">
                                    <asp:TextBox ID="SearchText" runat="server" Columns="20" MaxLength="100" Width="360px" meta:resourcekey="SearchTextResource1"></asp:TextBox></td>
                            </tr>
                            <tr style="font-size: 8pt">
                            </tr>
                            <tr id="RangeSearchSwitch" language="javascript" onclick="return RangeSearchSwitch_onclick()"
                                style="font-size: 8pt">
                                <td style="height: 9px">
                                    <span style="font-weight: bold">
                                        <input id="SearchControl1_cbxRangeSearch" name="SearchControl1$cbxRangeSearch" size="50"
                                            type="checkbox" /><label for="SearchControl1_cbxRangeSearch">
                                                <asp:Label ID="Label3" runat="server" Text="Range Search" meta:resourcekey="Label3Resource1"></asp:Label></label></span></td>
                                <td style="height: 9px">
                                    &nbsp;&nbsp;<span id="SearchControl1_RequiredFieldValidator1" class="smaller" controltovalidate="SearchControl1_txtSearch"
                                        errormessage="Enter in search criteria." initialvalue="" isvalid="true" style="font-weight: bold;
                                        visibility: hidden; color: red">
                                    <asp:Label ID="Label4" runat="server" Text="Enter in search criteria." meta:resourcekey="Label4Resource1"></asp:Label></span></td>
                            </tr>
                            <tr>
                            </tr>
                            <tr id="RangeSearchRow" style="display: none" >
                                <td style="height: 1px">
                                    <span id="SearchControl1_Label3" class="smaller_bold" style="font-weight: bold">
                                        <asp:Label ID="Label5" runat="server" Text="Upper Value" meta:resourcekey="Label5Resource1"></asp:Label></span></td>
                                <td style="height: 1px">
                                    <asp:TextBox ID="UpperText" runat="server" Columns="20" MaxLength="100" Width="360px" meta:resourcekey="UpperTextResource1"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <td>
                                    &nbsp;
                                    <asp:Button ID="ClearButton" runat="server" Text="Clear" meta:resourcekey="ClearButtonResource1" /></td>
                                <td align="right">
                                    &nbsp; &nbsp;<asp:Button ID="SearchButton" runat="server" Text="Search" meta:resourcekey="SearchButtonResource1" />
                                    &nbsp;
                                    &nbsp; &nbsp;&nbsp; &nbsp;<asp:Label ID="Label6" runat="server" Text="Search Help" meta:resourcekey="Label6Resource1"></asp:Label>&nbsp;
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td align="left" class="smaller">
            <br />&nbsp;&nbsp;
            <asp:HyperLink ID="HyperAdvancedSearch" runat="server" meta:resourcekey="HyperAdvancedSearchResource1" NavigateUrl="default.aspx?Page=AdvLitSearch">Advanced Search</asp:HyperLink></td>
    </tr>
    <tr>
        <td align="left" class="smaller">
        </td>
    </tr>
    <tr>
        <td align="left" class="smaller">
            <asp:GridView ID="ResultsGridView" runat="server" AllowPaging="True" AutoGenerateColumns="False"
                PageSize="30" Visible="False" GridLines="None" meta:resourcekey="ResultsGridViewResource1">
                <HeaderStyle BackColor="#ADAD74" />
                <AlternatingRowStyle BackColor="#ADAD74" />
                <RowStyle ForeColor="Black" />
                <PagerStyle ForeColor="Black" />
            </asp:GridView>
            <asp:Label ID="ErrorLabel" runat="server" Font-Size="Medium" ForeColor="Red" Text="Error getting search results"
                Visible="False" meta:resourcekey="ErrorLabelResource1"></asp:Label></td>
    </tr>
</table>

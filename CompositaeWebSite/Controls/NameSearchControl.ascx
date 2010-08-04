<%@ Control Language="VB" AutoEventWireup="false" CodeFile="NameSearchControl.ascx.vb" Inherits="Controls_NameSearchControl" %>
            <table border="0" width="100%">
                <tr>
                    <td>
                        <asp:Label ID="Label1" runat="server" CssClass="BlockHeader" Height="24px" meta:resourcekey="Label1Resource1"
                            Text="Search Results" Width="100%"></asp:Label></td>
                </tr>
                <tr>
                    <td>
                        <p>

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

                            <span id="SearchControl1_lblSearchHeading" class="PageHeading"></span></p>
                        <asp:Label ID="numSearchResults" Font-Size="smaller" runat="server" ForeColor="Green" meta:resourcekey="numSearchResultsResource1"></asp:Label>
                        &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                        <asp:Image ID="reportImage" runat="server" BorderColor="White" BorderWidth="0px"
                            ImageAlign="Bottom" ImageUrl="~/Images/report.jpg" Visible="False" />
                        <asp:LinkButton ID="downloadLink" Font-Size="smaller" runat="server">Download RTF Report</asp:LinkButton>
                        &nbsp;&nbsp;
                        <asp:Image ID="downloadCsvImage" runat="server" BorderColor="White" BorderWidth="0px"
                            ImageAlign="Bottom" ImageUrl="~/Images/report.jpg" Visible="False" />
                        <asp:LinkButton ID="downloadCsvLink" runat="server" Font-Size="smaller" Visible="False">Download  CSV Report</asp:LinkButton></td>
                </tr>
                <tr>
                    <td>
                        <asp:GridView ID="ResultsGridView" runat="server" AllowPaging="True" PageSize="30"
                            Visible="False" AutoGenerateColumns="False" GridLines="None" Width="100%" CellPadding="2" Font-Size="Smaller" meta:resourcekey="ResultsGridViewResource1">
                            <HeaderStyle BackColor="#DBBC57" ForeColor="White" />
                            <AlternatingRowStyle BackColor="LightYellow" />
                            <RowStyle ForeColor="Black" />
                            <PagerStyle ForeColor="Black" />
                        </asp:GridView>
                        <asp:Label ID="ErrorLabel" runat="server" Font-Size="Medium" ForeColor="Red" Text="Error getting search results"
                            Visible="False" meta:resourcekey="ErrorLabelResource1" CssClass="smaller"></asp:Label><asp:PlaceHolder ID="didYouMeanPlaceholder" runat="server"></asp:PlaceHolder>
                        </td>
                </tr>
            </table>

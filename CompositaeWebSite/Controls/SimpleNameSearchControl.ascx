<%@ Control Language="VB" AutoEventWireup="false" CodeFile="SimpleNameSearchControl.ascx.vb" Inherits="SimpleNameSearchControl" %>
            <table border="0">
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
                        <table class="searchBox">
                            <tr>
                                <td>
                                    <table>
                                        <tr>
                                            <td style="height: 7px">
                                                <span id="SearchControl1_Label2" class="smaller_bold" style="font-weight: bold">Search
                                                    for taxon name</span></td>
                                            <td style="height: 7px; width: 475px;">
                                                <asp:TextBox ID="SearchText" runat="server" Columns="60" MaxLength="100"></asp:TextBox>
                                                <asp:Button ID="SearchButton" runat="server" Text="Search" />
                                                &nbsp; &nbsp;</td>
                                        </tr>
                                        <tr>
                                        </tr>
                                        <tr>
                                        </tr>
                                    </table>
                        &nbsp;<a id="HyperAdvancedSearch" href="Default.aspx?Page=NameSearch" style="color: black;" class="smaller_bold">More
                            Searching</a>&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="smaller">
                    </td>
                </tr>
                <tr>
                    <td class="smaller">
                        <asp:GridView ID="ResultsGridView" runat="server" AllowPaging="True" PageSize="30"
                            Visible="False" AutoGenerateColumns="False" GridLines="None" Width="100%">
                            <HeaderStyle BackColor="#ADAD74" />
                            <AlternatingRowStyle BackColor="#ADAD74" />
                            <RowStyle ForeColor="Black" />
                            <PagerStyle ForeColor="Black" />
                        </asp:GridView>
                        <asp:Label ID="ErrorLabel" runat="server" Font-Size="Medium" ForeColor="Red" Text="Error getting search results"
                            Visible="False"></asp:Label></td>
                </tr>
            </table>

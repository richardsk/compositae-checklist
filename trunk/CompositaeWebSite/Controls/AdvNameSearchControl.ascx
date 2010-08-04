<%@ Control Language="VB" AutoEventWireup="false" CodeFile="AdvNameSearchControl.ascx.vb" Inherits="Controls_AdvNameSearchControl" %>
<%@ Register Src="AdvSearchControl.ascx" TagName="AdvSearchControl" TagPrefix="uc1" %>

    <table border="0" width="100%">
        <tr>
            <td>
                <asp:Label ID="Label1" runat="server" CssClass="BlockHeader" Height="24px" meta:resourcekey="Label1Resource1"
                    Text="Advanced Name Search" Width="100%"></asp:Label><br />
                <asp:Label ID="errLabel" runat="server" ForeColor="Red" Text="Enter in search criteria."
                    Visible="False" meta:resourcekey="errLabelResource1"></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                <table class="searchBox">
                    <tr>
                        <td>
                            <table width="100%">
                                <tr>
                                    <td>
                                        <uc1:AdvSearchControl ID="AdvSearchControl1" runat="server" />
                                    </td>
                                    <td>
                                        <uc1:AdvSearchControl ID="AdvSearchControl2" runat="server" Visible="False" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <uc1:AdvSearchControl ID="AdvSearchControl3" runat="server" Visible="False" />
                                    </td>
                                    <td>
                                        <uc1:AdvSearchControl ID="AdvSearchControl4" runat="server" Visible="False" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <uc1:AdvSearchControl ID="AdvSearchControl5" runat="server" Visible="False" />
                                    </td>
                                    <td>
                                        <uc1:AdvSearchControl ID="AdvSearchControl6" runat="server" Visible="False" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="1">
                            <asp:CheckBox ID="chkIncludeAccepted" runat="server" CssClass="smaller_bold" Text="Include accepted names" Checked="True" meta:resourcekey="chkIncludeAcceptedResource1" />
                            &nbsp; &nbsp;&nbsp;
                            <asp:CheckBox ID="chkIncludeSynonyms" runat="server" CssClass="smaller_bold" Text="Include synonyms" Checked="True" meta:resourcekey="chkIncludeSynonymsResource1" />
                            &nbsp; &nbsp;
                            <asp:CheckBox ID="chkIncludeUnknown" runat="server" CssClass="smaller_bold" Text="Include names of unknown status" Checked="True" meta:resourcekey="chkIncludeUnknownResource1" /><br />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="1" class="smaller" >
                            &nbsp;<asp:Button ID="clearButton" runat="server" Text="Clear" meta:resourcekey="clearButtonResource1"  />
                            &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                            &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                            &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                            &nbsp; &nbsp;<asp:Button ID="SearchButton" runat="server" Text="Search" meta:resourcekey="SearchButtonResource1" />&nbsp; &nbsp;&nbsp;
                            <asp:HyperLink ID="HyperLink1" runat="server" ForeColor="Black" meta:resourcekey="HyperLink1Resource1"
                                NavigateUrl="~/default.aspx?Page=About&Tab=SearchHelp" Text="Search Help" Target="_blank" ></asp:HyperLink></td>
                    </tr>
                </table>

            </td>
        </tr>
        <tr>
            <td >
                <asp:Label ID="numSearchResults" runat="server" ForeColor="Green" Font-Size="Smaller" meta:resourcekey="numSearchResultsResource1"></asp:Label>
                
                  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                <asp:Image ID="reportImage" runat="server" BorderColor="White" BorderWidth="0px"
                    ImageAlign="Bottom" ImageUrl="~/Images/report.jpg" Visible="False" meta:resourcekey="reportImageResource1" />
                <asp:LinkButton ID="reportLink" runat="server" Font-Size="Smaller" meta:resourcekey="reportLinkResource1"
                    Visible="False" Text="Download  RTF Report"></asp:LinkButton>
                &nbsp;&nbsp;
                <asp:Image ID="downloadCsvImage" runat="server" BorderColor="White" BorderWidth="0px"
                    ImageAlign="Bottom" ImageUrl="~/Images/report.jpg" Visible="False" meta:resourcekey="downloadCsvImageResource1" />
                    <asp:LinkButton id="downloadCsvLink" runat="server" Font-Size="Smaller" Visible="False" meta:resourcekey="downloadCsvLinkResource1" Text="Download  CSV Report"></asp:LinkButton></td>
        </tr>
        <tr>
            <td class="smaller">
    <asp:GridView ID="ResultsGridView" runat="server" AllowPaging="True" AutoGenerateColumns="False"
        PageSize="30" Visible="False" GridLines="None" CellPadding="2"  Width="100%" meta:resourcekey="ResultsGridViewResource1">
        <HeaderStyle BackColor="#DBBC57" ForeColor="White" />
        <AlternatingRowStyle BackColor="LightYellow" />
        <RowStyle ForeColor="Black" />
        <PagerStyle ForeColor="Black" />
    </asp:GridView>
    <asp:Label ID="ErrorLabel" runat="server" Font-Size="Medium" ForeColor="Red" Text="Error getting search results"
        Visible="False" meta:resourcekey="ErrorLabelResource1"></asp:Label></td>
        </tr>
    </table>

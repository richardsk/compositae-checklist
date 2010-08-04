<%@ Control Language="VB" AutoEventWireup="false" CodeFile="AdvLitSearchControl.ascx.vb" Inherits="AdvLitSearchControl" %>
    
<table border="0" width="100%">
    <tr>
        <td valign="top">
        </td>
        <td valign="top">
            <table border="0" width="100%">
                <tr>
                    <td>
                        <p>

                            <span id="AdvancedSearchControl1_lblSearchHeading" class="PageHeading" style="font-size: 17pt">
                                <strong>Literature Advanced Search</strong></span>
                        </p>
                        <table class="searchBox">
                            <tr>
                                <td colspan="3">
                                    <span class="smaller">
                                        <label for="AdvancedSearchControl1_IncludeTagNamesCheck">
                                            <span style="font-size: 8pt"></span>
                                        </label>
                                    </span>
                                </td>
                            </tr>
                            <tr valign="top">
                                <td id="advanced1" style="width: 346px">
                                    <table class="smaller">
                                        <tr>
                                            <td class="bold" style="width: 107px">
                                                Field</td>
                                            <td style="width: 231px">
                                                &nbsp;<asp:DropDownList ID="Field1" runat="server" Width="200px">
                                                </asp:DropDownList></td>
                                        </tr>
                                        <tr>
                                            <td class="bold" style="width: 107px">
                                                Search Text</td>
                                            <td style="width: 231px">
                                                <asp:TextBox ID="SearchText1" runat="server" MaxLength="50" Width="200px"></asp:TextBox></td>
                                        </tr>
                                        <tr>
                                            <td style="width: 107px" >
                                                <asp:CheckBox ID="RangeCheck1" runat="server" Text="Range Search" AutoPostBack="True" /></td>
                                            <td style="width: 231px">
                                                <label for="AdvancedSearchControl1_cbxAnywhereInText1">
                                                    &nbsp;<asp:CheckBox ID="AnywhereCheck1" runat="server" Checked="True" Text="Anywhere in text" /></label>&nbsp;&nbsp;<label for="AdvancedSearchControl1_cbxWholeWord1">
                                                        <asp:CheckBox ID="WholeWordCheck1" runat="server" Text="Whole Word" /></label></td>
                                        </tr>
                                        <tr id="AdvancedUpperText1" >
                                            <td class="bold" id="UpperTD1" runat="server" visible="false" style="width: 107px">
                                                Upper Text</td>
                                            <td style="width: 231px" id="UpperTD2" runat="server" visible="false">
                                                <asp:TextBox ID="UpperText1" runat="server" MaxLength="50" Width="200px"></asp:TextBox></td>
                                        </tr>
                                        <tr>
                                            <td style="width: 107px" >
                                                <img src="images/DownArrow.gif" />&nbsp;
                                                <asp:CheckBox ID="AndCheck1" runat="server" Text="And" AutoPostBack="True" /></td>
                                            <td align="right" style="width: 231px" >
                                                <span id="AdvancedSearchControl1_RequiredFieldValidator2" controltovalidate="AdvancedSearchControl1_txtSearchText1"
                                                    errormessage="Enter in search criteria." initialvalue="" isvalid="true" style="font-weight: bold;
                                                    visibility: hidden; color: red">Enter in search criteria.</span>
                                                <asp:CheckBox ID="OrCheck1" runat="server" Text="Or" AutoPostBack="True" /><img src="images/RightArrow.gif" /></td>
                                        </tr>
                                    </table>
                                </td>
                                <td id="advanced_or1" runat="server" visible="false"> 
                                    <table class="smaller">
                                        <tr>
                                            <td class="bold">
                                                Field</td>
                                            <td style="width: 207px">
                                                &nbsp;<asp:DropDownList ID="FieldOr1" runat="server" Width="200px">
                                                </asp:DropDownList></td>
                                        </tr>
                                        <tr>
                                            <td class="bold">
                                                Search Text</td>
                                            <td style="width: 207px">
                                                <asp:TextBox ID="SearchTextOr1" runat="server" MaxLength="50" Width="200px"></asp:TextBox></td>
                                        </tr>
                                        <tr>
                                            <td >
                                                <label for="AdvancedSearchControl1_cbxRangeSearch_or1">
                                                    &nbsp;<asp:CheckBox ID="RangeCheckOr1" runat="server" Text="Range Search" AutoPostBack="True" /></label></td>
                                            <td style="width: 207px">
                                                <label for="AdvancedSearchControl1_cbxAnywhereInText_or1">
                                                    &nbsp;</label><asp:CheckBox ID="AnywhereCheckOr1" runat="server" Checked="True" Text="Anywhere" />
                                                <asp:CheckBox ID="WholeWordCheckOr1" runat="server" Text="Whole Word" /></td>
                                        </tr>
                                        <tr id="AdvancedUpperText_or1" >
                                            <td class="bold" id="UpperTD3" runat="server" visible="false">
                                                Upper Text</td>
                                            <td id="UpperTD4" runat="server" style="width: 207px" visible="false">
                                                <asp:TextBox ID="UpperTextOr1" runat="server" MaxLength="50" Width="200px"></asp:TextBox></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr id="advanced2" bgcolor="#adad74"  valign="top">
                                <td style="width: 346px" id="and_1" runat="server" visible="false">
                                    <table class="smaller" id="TABLE2" runat="server">
                                        <tr>
                                            <td class="bold">
                                                Field</td>
                                            <td style="width: 207px">
                                                &nbsp;<asp:DropDownList ID="Field2" runat="server" Width="200px">
                                                </asp:DropDownList></td>
                                        </tr>
                                        <tr>
                                            <td class="bold">
                                                Search Text</td>
                                            <td style="width: 207px">
                                                <asp:TextBox ID="SearchText2" runat="server" MaxLength="50" Width="200px"></asp:TextBox></td>
                                        </tr>
                                        <tr>
                                            <td >
                                                <label for="AdvancedSearchControl1_cbxRangeSearch2"><asp:CheckBox ID="RangeCheck2" runat="server" Text="Range Search" AutoPostBack="True" />
                                                </label></td>
                                            <td style="width: 207px">
                                                &nbsp;
                                                <label for="AdvancedSearchControl1_cbxWholeWord2">
                                                    &nbsp;<asp:CheckBox ID="AnywhereCheck2" runat="server" Checked="True" Text="Anywhere" /><asp:CheckBox
                                                        ID="WholeWordCheck2" runat="server" Text="Whole Word" /></label></td>
                                        </tr>
                                        <tr id="AdvancedUpperText2" >
                                            <td class="bold" style="height: 26px" id="UpperTD5" runat="server" visible="false">
                                                Upper Text</td>
                                            <td style="height: 26px; width: 207px;" id="UpperTD6" runat="server" visible="false">
                                                <asp:TextBox ID="UpperText2" runat="server" MaxLength="50" Width="200px"></asp:TextBox></td>
                                        </tr>
                                        <tr>
                                            <td >
                                                <img src="images/DownArrow.gif" />&nbsp;
                                                <asp:CheckBox ID="AndCheck2" runat="server" Text="And" AutoPostBack="True" /></td>
                                            <td align="right" style="width: 207px"><asp:CheckBox ID="OrCheck2" runat="server" Text="Or" AutoPostBack="True" />
                                                <img src="images/RightArrow.gif" /></td>
                                        </tr>
                                    </table>
                                </td>
                                <td id="advanced_or2" runat="server" visible="false" > 
                                    <table class="smaller">
                                        <tr>
                                            <td class="bold">
                                                Field</td>
                                            <td>
                                                &nbsp;<asp:DropDownList ID="FieldOr2" runat="server" Width="200px">
                                                </asp:DropDownList></td>
                                        </tr>
                                        <tr>
                                            <td class="bold">
                                                Search Text</td>
                                            <td>
                                                <asp:TextBox ID="SearchTextOr2" runat="server" MaxLength="50" Width="200px"></asp:TextBox></td>
                                        </tr>
                                        <tr>
                                            <td >
                                                <label for="AdvancedSearchControl1_cbxRangeSearch_or2"><asp:CheckBox ID="RangeCheckOr2" runat="server" Text="Range Search" AutoPostBack="True" />
                                                </label></td>
                                            <td>
                                                <label for="AdvancedSearchControl1_cbxAnywhereInText_or2">
                                                    &nbsp;</label>
                                                <asp:CheckBox ID="AnywhereCheckOr2" runat="server" Checked="True" Text="Anywhere" />
                                                <asp:CheckBox
                                                        ID="WholeWordCheckOr2" runat="server" Text="Whole Word" /></td>
                                        </tr>
                                        <tr id="AdvancedUpperText_or2" >
                                            <td class="bold" id="UpperTD7" runat="server" visible="false">
                                                Upper Text</td>
                                            <td id="UpperTD8" runat="server" visible="false">
                                                <asp:TextBox ID="UpperTextOr2" runat="server" MaxLength="50" Width="200px"></asp:TextBox></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr id="advanced3"  valign="top">
                                <td style="width: 346px" id="and_2" runat="server" visible="false">
                                    <table class="smaller">
                                        <tr>
                                            <td class="bold">
                                                Field</td>
                                            <td>
                                                &nbsp;<asp:DropDownList ID="Field3" runat="server" Width="200px">
                                                </asp:DropDownList></td>
                                        </tr>
                                        <tr>
                                            <td class="bold">
                                                Search Text</td>
                                            <td>
                                                <asp:TextBox ID="SearchText3" runat="server" MaxLength="50" Width="200px"></asp:TextBox></td>
                                        </tr>
                                        <tr>
                                            <td >
                                                <label for="AdvancedSearchControl1_cbxRangeSearch3"><asp:CheckBox ID="RangeCheck3" runat="server" Text="Range Search" /></label></td>
                                            <td>
                                                <label for="AdvancedSearchControl1_cbxAnywhereInText3">
                                                    &nbsp;</label><label for="AdvancedSearchControl1_cbxWholeWord3">
                                                    <asp:CheckBox ID="AnywhereCheck3" runat="server" Checked="True" Text="Anywhere" />&nbsp;<asp:CheckBox
                                                        ID="WholeWordCheck3" runat="server" Text="Whole Word" /></label></td>
                                        </tr>
                                        <tr id="AdvancedUpperText3" >
                                            <td class="bold" id="UpperTD9" runat="server" visible="false">
                                                Upper Text</td>
                                            <td id="UpperTD10" runat="server" visible="false">
                                                <asp:TextBox ID="UpperText3" runat="server" MaxLength="50" Width="200px"></asp:TextBox></td>
                                        </tr>
                                        <tr>
                                            <td>
                                            </td>
                                            <td align="right" ><asp:CheckBox ID="OrCheck3" runat="server" Text="Or" AutoPostBack="True" />
                                                <img src="images/RightArrow.gif" /></td>
                                        </tr>
                                    </table>
                                </td>
                                <td id="advanced_or3" runat="server" visible="false" >
                                    <table class="smaller">
                                        <tr>
                                            <td class="bold">
                                                Field</td>
                                            <td>
                                                &nbsp;<asp:DropDownList ID="FieldOr3" runat="server" Width="200px">
                                                </asp:DropDownList></td>
                                        </tr>
                                        <tr>
                                            <td class="bold">
                                                Search Text</td>
                                            <td>
                                                <asp:TextBox ID="SearchTextOr3" runat="server" MaxLength="50" Width="200px"></asp:TextBox></td>
                                        </tr>
                                        <tr>
                                            <td >
                                                <label for="AdvancedSearchControl1_cbxRangeSearch_or3">
                                                    &nbsp;<asp:CheckBox ID="RangeCheckOr3" runat="server" Text="Range Search" /></label></td>
                                            <td>
                                                <label for="AdvancedSearchControl1_cbxAnywhereInText_or3">
                                                    &nbsp;</label><asp:CheckBox ID="AnywhereCheckOr3" runat="server" Checked="True" Text="Anywhere" />
                                                <asp:CheckBox
                                                        ID="WholeWordCheckOr3" runat="server" Text="Whole Word" /></td>
                                        </tr>
                                        <tr id="AdvancedUpperText_or3" >
                                            <td class="bold" id="UpperTD11" runat="server" visible="false">
                                                Upper Text</td>
                                            <td id="UpperTD12" runat="server" visible="false">
                                                <asp:TextBox ID="UpperTextOr3" runat="server" MaxLength="50" Width="200px"></asp:TextBox></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    &nbsp;<input id="AdvancedSearchControl1_cmdClear" name="AdvancedSearchControl1$cmdClear"
                                        onclick='javascript:WebForm_DoPostBackWithOptions(new WebForm_PostBackOptions("AdvancedSearchControl1$cmdClear", "", true, "", "", false, false))'
                                        type="submit" value="Clear" />
                                    &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                                    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                                    &nbsp; &nbsp;<asp:Button ID="SearchButton" runat="server" Text="Search" />&nbsp; <a id="AdvancedSearchControl1_HyperLink1" class="smaller" href="HelpForm_1_Compositae.aspx"
                                        target="DisplayFrame"><span style="font-size: 8pt; color: #000000">Search Help</span></a></td>
                            </tr>
                        </table>

                    </td>
                </tr>
                <tr >
                    <td class="smaller">
                        <a style="color:Black" id="HyperSimpleSearch" href="Default.aspx?Page=LitSearch">Simple Search</a>&nbsp;
                    </td>
                </tr>
                <tr>
                    <td class="smaller">
                    </td>
                </tr>
                <tr>
                    <td class="smaller">
            <asp:GridView ID="ResultsGridView" runat="server" AllowPaging="True" AutoGenerateColumns="False"
                PageSize="30" Visible="False" GridLines="None">
                <HeaderStyle BackColor="#ADAD74" />
                <AlternatingRowStyle BackColor="#ADAD74" />
                <RowStyle ForeColor="Black" />
                <PagerStyle ForeColor="Black" />
            </asp:GridView>
            <asp:Label ID="ErrorLabel" runat="server" Font-Size="Medium" ForeColor="Red" Text="Error getting search results"
                Visible="False"></asp:Label></td>
                </tr>
            </table>
            </td>
    </tr>
</table>

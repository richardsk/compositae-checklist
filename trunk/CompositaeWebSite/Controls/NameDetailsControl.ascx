<%@ Control Language="VB" AutoEventWireup="false" CodeFile="NameDetailsControl.ascx.vb" Inherits="Controls_NameDetailsControl" %>
<%@ Register Src="ReportControl.ascx" TagName="ReportControl" TagPrefix="uc5" %>
<%@ Register Src="OtherDataControl.ascx" TagName="OtherDataControl" TagPrefix="uc4" %>
<%@ Register Src="TaxonConceptsControl.ascx" TagName="TaxonConceptsControl" TagPrefix="uc3" %>
<%@ Register Src="OriginalDataControl.ascx" TagName="OriginalDataControl" TagPrefix="uc2" %>
<%@ Register Src="ConsensusControl.ascx" TagName="ConsensusControl" TagPrefix="uc1" %>

<LINK rel="stylesheet" type="text/css" href="../Includes/style.css" />

<SCRIPT language="javascript">
<!--

function DetailsPopup(nameGuid, pnField)
{
    var DetailsWin = window.open('ProviderFieldDetails.aspx?nameGuid=' + nameGuid + '&pnField=' + pnField,'DetailsWin','top=100,left=100,width=750,height=350px,scrollbars=1,resizable=1,status=0');
    DetailsWin.focus();
}

function ConceptPopup(nameGuid, crGuid)
{
    var ConcWin = window.open('ProviderConceptDetails.aspx?nameGuid=' + nameGuid + '&crGuid=' + crGuid,'ConcWin','top=100,left=100,width=750,height=350px,scrollbars=1,resizable=1,status=0');
    ConcWin.focus();
}
 
//-->
</SCRIPT> 

<table id="Table2" align="left" border="0" cellpadding="3" cellspacing="0" width="100%" style="padding-left: 4px">
    
    <tr style="color: #808080;">
        <td align="left" valign="top" >
            <div >
                <asp:Table ID="menuTable" runat="server" Width="100%" meta:resourcekey="menuTableResource1">
                    <asp:TableRow runat="server" meta:resourcekey="TableRowResource1">
                        <asp:TableCell runat="server" CssClass="NameDetailsMenu" HorizontalAlign="Center"
                            Width="180px" meta:resourcekey="TableCellResource1">Name Summary</asp:TableCell>
                        <asp:TableCell runat="server" CssClass="NameDetailsMenu" Width="170px" meta:resourcekey="TableCellResource2">Contributed Data</asp:TableCell>
                        <asp:TableCell runat="server" CssClass="NameDetailsMenu" Width="200px" meta:resourcekey="TableCellResource3">Taxonomic Concepts</asp:TableCell>
                        <asp:TableCell runat="server" CssClass="NameDetailsMenu" Width="170px" meta:resourcekey="TableCellResource4">Distribution</asp:TableCell>
                        <asp:TableCell runat="server" CssClass="NameDetailsMenu" Width="160px" meta:resourcekey="TableCellResource5">Outputs</asp:TableCell>
                    </asp:TableRow>
                </asp:Table>
                &nbsp;
            <asp:Label ID="NameHierarchyLabel" runat="server" Font-Size="Medium" ForeColor="Black"
                meta:resourcekey="NameHierarchyLabelResource1" Text="Label"></asp:Label>
                </div>
                
        </td>
    </tr>
    <tr>
        <td>              
                            <uc1:ConsensusControl ID="ConsensusControl1" runat="server" Visible="False" />
                
                            <uc2:OriginalDataControl ID="OriginalDataControl1" runat="server" Visible="False" />
                            <uc3:TaxonConceptsControl ID="TaxonConceptsControl1" runat="server" Visible="False" />
                            <uc4:OtherDataControl ID="OtherDataControl1" runat="server" Visible="False" />
            <uc5:ReportControl ID="ReportControl1" runat="server" Visible="False" />
            <%--Add a MultiView control to "contain" View controls which will serve as tab pages.--%>
                
            
        </td>
        <td align="right" nowrap="nowrap" style="font-weight: bold; font-size: 14pt" valign="center">
        </td>
    </tr>
    <tr>
        <td bgcolor="<%WebDataAccess.Utility.AltBGColor()%>" class="smaller" height="20" valign="top">
        </td>
    </tr>
    <tr>
        <td valign="top" class="smaller">
            </td>
    </tr>
</table>

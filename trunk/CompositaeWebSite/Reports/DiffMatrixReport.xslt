<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="/">
		<html>
			<body>
				<h3>Difference Matrix Report</h3>
				<p style="line-height:0">&#160;</p>
				<xsl:apply-templates select="NewDataSet/Table"/>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="NewDataSet/Table">
		<p style="font-size:small">
			<b>Name LSID: </b>
			<xsl:value-of select="NameLSID"/>
		</p>
		
		<table border="1" style="font-size:small">
			<tr style="font-weight:bold">
				<td>Provider</td>
				<td>Id</td>
				<td>Full Name</td>
				<td>Rank</td>
				<td>Canonical</td>
				<td>Authors</td>
				<td>BasionymAuthors</td>
				<td>CombinationAuthors</td>
				<td>PublishedIn</td>
				<td>Year</td>
				<td>MicroReference</td>
				<td>TypeVoucher</td>
				<td>TypeName</td>
				<td>Orthography</td>
				<td>Basionym</td>
				<td>BasedOn</td>
				<td>ConservedAgainst</td>
				<td>HomonymOf</td>
				<td>ReplacementFor</td>
				<td>InCitation</td>
				<td>Invalid</td>
				<td>Illegitimate</td>
				<td>Misapplied</td>
				<td>ProParte</td>
				<td>NomNotes</td>
				<td>StatusNotes</td>
				<td>Notes</td>
			</tr>
			<tr>
				<td>TICA</td>
				<td></td>
				<td>
					<xsl:value-of select="NameFull"/>
				</td>
				<td>
					<xsl:value-of select="NameRank"/>
				</td>
				<td>
					<xsl:value-of select="NameCanonical"/>
				</td>
				<td>
					<xsl:value-of select="NameAuthors"/>
				</td>
				<td>
					<xsl:value-of select="NameBasionymAuthors"/>
				</td>
				<td>
					<xsl:value-of select="NameCombinationAuthors"/>
				</td>
				<td>
					<xsl:value-of select="NamePublishedIn"/>
				</td>
				<td>
					<xsl:value-of select="NameYear"/>
				</td>
				<td>
					<xsl:value-of select="NameMicroReference"/>
				</td>
				<td>
					<xsl:value-of select="NameTypeVoucher"/>
				</td>
				<td>
					<xsl:value-of select="NameTypeName"/>
				</td>
				<td>
					<xsl:value-of select="NameOrthography"/>
				</td>
				<td>
					<xsl:value-of select="NameBasionym"/>
				</td>
				<td>
					<xsl:value-of select="NameBasedOn"/>
				</td>
				<td>
					<xsl:value-of select="NameConservedAgainst"/>
				</td>
				<td>
					<xsl:value-of select="NameHomonymOf"/>
				</td>
				<td>
					<xsl:value-of select="NameReplacementFor"/>
				</td>
				<td>
					<xsl:value-of select="NameInCitation"/>
				</td>
				<td>
					<xsl:value-of select="NameInvalid"/>
				</td>
				<td>
					<xsl:value-of select="NameIllegitimate"/>
				</td>
				<td>
					<xsl:value-of select="NameMisapplied"/>
				</td>
				<td>
					<xsl:value-of select="NameProParte"/>
				</td>
				<td>
					<xsl:value-of select="NameNomNotes"/>
				</td>
				<td>
					<xsl:value-of select="NameStatusNotes"/>
				</td>
				<td>
					<xsl:value-of select="NameNotes"/>
				</td>
			</tr>
			<xsl:apply-templates select="/NewDataSet/Table1"/>
		</table>	
	</xsl:template>
	
	<xsl:template match="NewDataSet/Table1">
		<tr>
			<td>
				<xsl:value-of select="substring(ProviderName, 0, 30)"/>
				<xsl:if test="string-length(ProviderName) > 30"> ...</xsl:if> 
			</td>
			<td>
				<xsl:value-of select="PNNameId"/>
			</td>
			<td>
				<xsl:value-of select="PNNameFull"/>
			</td>
			<td>
				<xsl:value-of select="PNNameRank"/>
			</td>
			<td>
				<xsl:value-of select="PNNameCanonical"/>
			</td>
			<td>
				<xsl:value-of select="PNNameAuthors"/>
			</td>
			<td>
				<xsl:value-of select="PNBasionymAuthors"/>
			</td>
			<td>
				<xsl:value-of select="PNCombinationAuthors"/>
			</td>
			<td>
				<xsl:value-of select="PNPublishedIn"/>
			</td>
			<td>
				<xsl:value-of select="PNYear"/>
			</td>
			<td>
				<xsl:value-of select="PNMicroReference"/>
			</td>
			<td>
				<xsl:value-of select="PNTypeVoucher"/>
			</td>
			<td>
				<xsl:value-of select="PNTypeName"/>
			</td>
			<td>
				<xsl:value-of select="PNOrthography"/>
			</td>
			<td>
				<xsl:value-of select="PNBasionym"/>
			</td>
			<td>
				<xsl:value-of select="PNBasedOn"/>
			</td>
			<td>
				<xsl:value-of select="PMConservedAgainst"/>
			</td>
			<td>
				<xsl:value-of select="PNHomonymOf"/>
			</td>
			<td>
				<xsl:value-of select="PNReplacementFor"/>
			</td>
			<td>
				<xsl:value-of select="PNInCitation"/>
			</td>
			<td>
				<xsl:value-of select="PNInvalid"/>
			</td>
			<td>
				<xsl:value-of select="PNIllegitimate"/>
			</td>
			<td>
				<xsl:value-of select="PNMisapplied"/>
			</td>
			<td>
				<xsl:value-of select="PNProParte"/>
			</td>
			<td>
				<xsl:value-of select="PNNomNotes"/>
			</td>
			<td>
				<xsl:value-of select="PNStatusNotes"/>
			</td>
			<td>
				<xsl:value-of select="PNNotes"/>
			</td>
		</tr>
	</xsl:template>


</xsl:stylesheet>

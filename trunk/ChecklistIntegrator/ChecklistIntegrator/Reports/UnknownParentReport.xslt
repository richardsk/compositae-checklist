<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="/">
		<html>
		<body>
			<h2>Provider Names</h2>
			<xsl:apply-templates select="NewDataSet/Table[recordType='ProviderName']"/>
		</body>
		</html>
	</xsl:template>

	<xsl:template match="NewDataSet/Table[recordType='ProviderName']">
		<b>ID: </b> <xsl:value-of select="recordId"/>&#160;&#160;
		<b>Name: </b> <xsl:value-of select="recordDetails"/>&#160;&#160;	
		<a>
			<xsl:attribute name="href">
				<xsl:value-of select="concat(none.html, string('&amp;type='), recordType, string('&amp;recordId='), recordId, string('&amp;action=goto'))"/>
			</xsl:attribute>View Provider Name
		</a>
    <br/>
	</xsl:template>

</xsl:stylesheet> 

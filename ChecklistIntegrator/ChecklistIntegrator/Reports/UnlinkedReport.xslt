<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="/">
		<html>
		<body>
			<h2>Provider Names</h2>
			<xsl:apply-templates select="NewDataSet/Table[recordType='ProviderName']"/>

			<h2>Provider Concepts</h2>
			<xsl:apply-templates select="NewDataSet/Table[recordType='ProviderConcept']"/>
			
			<h2>Provider References</h2>
			<xsl:apply-templates select="NewDataSet/Table[recordType='ProviderReference']"/>
		</body>
		</html>
	</xsl:template>

	<xsl:template match="NewDataSet/Table[recordType='ProviderName']">
		<b>ID: </b> <xsl:value-of select="recordId"/>&#160;&#160;
		<b>Name: </b> <xsl:value-of select="recordDetails"/>&#160;&#160;	
		<a>
			<xsl:attribute name="href">
				<xsl:value-of select="concat(none.html, string('&amp;type='), recordType, string('&amp;recordId='), recordId, string('&amp;action=goto'))"/>
			</xsl:attribute>Go to Provider Name
		</a><br/>
	</xsl:template>

	<xsl:template match="NewDataSet/Table[recordType='ProviderConcept']">
		<b>ID: </b> <xsl:value-of select="recordId"/>&#160;&#160;
		<b>Concept: </b> <xsl:value-of select="recordDetails"/>&#160;&#160;
		<a>
			<xsl:attribute name="href">
				<xsl:value-of select="concat(none.html, string('&amp;type='), recordType, string('&amp;recordId='), recordId, string('&amp;action=goto'))"/>
			</xsl:attribute>Go to Provider Name for the Concept
		</a><br/>
	</xsl:template>
	
	<xsl:template match="NewDataSet/Table[recordType='ProviderReference']">
		<b>ID: </b> <xsl:value-of select="recordId"/>&#160;&#160;
		<b>Reference: </b> <xsl:value-of select="recordDetails"/>&#160;&#160;
		<a>
			<xsl:attribute name="href">
				<xsl:value-of select="concat(none.html, string('&amp;type='), recordType, string('&amp;recordId='), recordId, string('&amp;action=goto'))"/>
			</xsl:attribute>Go to Provider Reference
		</a><br/>
	</xsl:template>
</xsl:stylesheet> 

<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml SANBI_sample.xml?>
<!--provider id = 15-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<Distributions>
			<xsl:for-each select="//Distribution">
				<xsl:variable name="vRegion" select="."/>
				<Distribution schema='SANBI Regions'>
					<xsl:attribute name="region"><xsl:value-of select="$vRegion"/></xsl:attribute>
					<xsl:attribute name="occurrence">Present</xsl:attribute>
					<xsl:attribute name="origin"></xsl:attribute>
					<xsl:attribute name="isOriginal">true</xsl:attribute>
				</Distribution>
			</xsl:for-each>
		</Distributions>
	</xsl:template>
</xsl:stylesheet>

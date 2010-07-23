<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml AbuDhabi_Sample.xml?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<Distributions>
			<xsl:for-each select="//Distribution">
				<Distribution schema='TDWG Level 4' region='GST-UA' origin=''>
					<xsl:attribute name="occurrence"><xsl:value-of select="Occurrence"/></xsl:attribute>
				</Distribution>
			</xsl:for-each>
		</Distributions>
	</xsl:template>
</xsl:stylesheet>

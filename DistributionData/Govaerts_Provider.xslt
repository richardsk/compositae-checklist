<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml Govaerts_Sample.xml?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<Distributions>
			<xsl:for-each select="//Distribution">
				<Distribution>
					<xsl:attribute name="schema">TDWG Level <xsl:value-of select="substring-after(Schema,'TDWG')"/>
					</xsl:attribute>
					<xsl:attribute name="region">
						<xsl:value-of select="Region"/>
					</xsl:attribute>
					<xsl:attribute name="occurrence">
						<xsl:value-of select="Occurrence"/>
					</xsl:attribute>
					<xsl:attribute name="origin">
						<xsl:value-of select="Origin"/>
					</xsl:attribute>
				</Distribution>
			</xsl:for-each>
		</Distributions>
	</xsl:template>
</xsl:stylesheet>
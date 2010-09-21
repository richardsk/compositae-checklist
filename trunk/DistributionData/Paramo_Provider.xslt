<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml Paramo_sample.xml?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<Distributions>
			<xsl:for-each select="//Distribution">
				<Distribution>
					<xsl:attribute name="schema">Country</xsl:attribute>
					<xsl:attribute name="region">
						<xsl:choose>
							<xsl:when test="contains(., '?')='true'"><xsl:value-of select="translate(.,'?','')"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="occurrence">
						<xsl:choose>
							<xsl:when test="contains(., '?')='true'">Uncertain</xsl:when>
							<xsl:otherwise>Present</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="origin"></xsl:attribute>
				</Distribution>
			</xsl:for-each>
		</Distributions>
	</xsl:template>
</xsl:stylesheet>

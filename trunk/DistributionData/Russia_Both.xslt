<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml Russia.xml?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<Distributions>
			<xsl:for-each select="//Distribution">
				<xsl:for-each select="Region">
					<Distribution>
						<xsl:attribute name="schema">
							<xsl:choose>
								<xsl:when test="string-length(.)=1">TDWG Level 1</xsl:when>
								<xsl:when test="string-length(.)=2">TDWG Level 2</xsl:when>
								<xsl:when test="string-length(.)=3">TDWG Level 3</xsl:when>
								<xsl:otherwise>TDWG Level 4</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xsl:attribute name="region"><xsl:value-of select="."/></xsl:attribute>
						<xsl:attribute name="origin">
							<xsl:value-of select="parent::Distribution/Origin"/>
						</xsl:attribute>
						<xsl:attribute name="occurrence">
							<xsl:value-of select="parent::Distribution/Occurrence"/>
						</xsl:attribute>
					</Distribution>
				</xsl:for-each>
			</xsl:for-each>
		</Distributions>
	</xsl:template>
</xsl:stylesheet>

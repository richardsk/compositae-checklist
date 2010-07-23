<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml SANBI_sample.xml?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<Distributions>
			<xsl:for-each select="//Distribution">
				<xsl:variable name="vRegion" select="."/>
				<Distribution>
					<xsl:attribute name="schema">
						<xsl:choose>
							<xsl:when test="$vRegion='FSA-OO'">TDWG Level 2</xsl:when>
							<xsl:when test="$vRegion='SAF-OO'">TDWG Level 2</xsl:when>
							<xsl:otherwise>TDWG Level 4</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="region">
						<xsl:choose>
							<xsl:when test="$vRegion='BOT-OO'">BOT-OO</xsl:when>
							<xsl:when test="$vRegion='FSA-OO'">27</xsl:when>
							<xsl:when test="$vRegion='SAF-OO'">27</xsl:when>
							<xsl:when test="$vRegion='SAF-WC'">CPP-WC</xsl:when>
							<xsl:when test="$vRegion='SAF-EC'">CPP-EC</xsl:when>
							<xsl:when test="$vRegion='SAF-FS'">OFS-OO</xsl:when>
							<xsl:when test="$vRegion='SAF-GA'">TVL-GA</xsl:when>
							<xsl:when test="$vRegion='SAF-KN'">NAT-OO</xsl:when>
							<xsl:when test="$vRegion='LES-OO'">LES-OO</xsl:when>
							<xsl:when test="$vRegion='SAF-LP'">TVL-NP</xsl:when>
							<xsl:when test="$vRegion='SAF-MP'">TVL-MP</xsl:when>
							<xsl:when test="$vRegion='SAF-NW'">TVL-NW</xsl:when>
							<xsl:when test="$vRegion='SWZ-OO'">SWZ-OO</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$vRegion"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="occurrence">Present</xsl:attribute>
					<xsl:attribute name="origin"/>
					<xsl:attribute name="isOriginal">false</xsl:attribute>
				</Distribution>
			</xsl:for-each>
		</Distributions>
	</xsl:template>
</xsl:stylesheet>

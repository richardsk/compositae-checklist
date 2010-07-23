<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml GuianaShield_sample.xml?>
<!--provider id = 12-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<Distributions>
			<xsl:for-each select="//Distribution">
				<xsl:variable name="vRegion" select="translate(., '?', '')"/>
				<!-- map to TDWG standard -->
				<xsl:variable name="vTRegion">
					<xsl:choose>
						<xsl:when test="$vRegion='AM'">VEN-OO</xsl:when>
						<xsl:when test="$vRegion='BO'">VEN-OO</xsl:when>
						<xsl:when test="$vRegion='DA'">VEN-OO</xsl:when>						
						<xsl:when test="$vRegion='FG'">FRG-OO</xsl:when>
						<xsl:when test="$vRegion='GU'">GUY-OO</xsl:when>						
						<xsl:when test="$vRegion='SU'">SUR-OO</xsl:when>
						
						<xsl:otherwise>
							<xsl:value-of select="$vRegion"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<Distribution schema="TDWG Level 4" occurrence="Present" origin="">
					<xsl:attribute name="region">
						<xsl:value-of select="$vTRegion"/>
					</xsl:attribute>
					<xsl:attribute name="isOriginal">false</xsl:attribute>
				</Distribution>
			</xsl:for-each>
		</Distributions>
	</xsl:template>
</xsl:stylesheet>

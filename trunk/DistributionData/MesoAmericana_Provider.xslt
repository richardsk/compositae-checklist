<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml MesoAmericana_sample.xml?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<Distributions>
			<xsl:call-template name="parse">
				<xsl:with-param name="pText" select="translate(., '.', ',')"/>
			</xsl:call-template>
		</Distributions>
	</xsl:template>
	<xsl:template name="parse">
		<xsl:param name="pText"/>
		<xsl:choose>
			<xsl:when test="contains($pText, ',')">
				<xsl:call-template name="writeValue">
					<xsl:with-param name="pRegion" select="substring-before($pText, ',')"/>
				</xsl:call-template>
				<xsl:call-template name="parse">
					<xsl:with-param name="pText" select="substring-after($pText, ',')"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="writeValue">
		<xsl:param name="pRegion"/>
		<xsl:if test="$pRegion!=''">
			<Distribution schema="Country">
				<xsl:attribute name="region"><xsl:value-of select="normalize-space($pRegion)"/></xsl:attribute>
				<xsl:attribute name="occurrence">Present</xsl:attribute>
				<xsl:attribute name="origin"/>
				<xsl:attribute name="isOriginal">true</xsl:attribute>
			</Distribution>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml VietnamFlora_Sample.xml?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<Distributions>
		<xsl:call-template name="parse">
			<xsl:with-param name="pText">
				<xsl:value-of select="."/>
			</xsl:with-param>
		</xsl:call-template>
		</Distributions>
	</xsl:template>
	<xsl:template name="parse">
		<xsl:param name="pText"/>
		<xsl:variable name='vRegion' select="substring-before($pText, ',')"/>
		<xsl:variable name='vRemain' select="normalize-space(substring-after($pText, ','))"/>
		<xsl:if test="$vRegion!=''">
			<Distribution>
				<xsl:attribute name="schema">Provinces of Vietnam</xsl:attribute>
				<xsl:attribute name="region"><xsl:value-of select="$vRegion"/></xsl:attribute>
				<xsl:attribute name="origin"></xsl:attribute>
				<xsl:attribute name="occurrence">Present</xsl:attribute>
			</Distribution>
		</xsl:if>
		<xsl:if test="string-length($vRemain)&gt;0">
			<xsl:call-template name="parse">
				<xsl:with-param name="pText" select="$vRemain"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>

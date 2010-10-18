<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml Tasmania.xml?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<Distributions>
			<xsl:for-each select="//Distribution">
				<xsl:variable name="vRegion">
					<xsl:call-template name="conRegion">
						<xsl:with-param name="pRegion" select="Region"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="vSchema" select="substring-before($vRegion,';')"/>
				<xsl:variable name="vReg" select="substring-after($vRegion,';')"/>
				<Distribution>
					<xsl:attribute name="schema"><xsl:value-of select="$vSchema"/></xsl:attribute>
					<xsl:attribute name="region"><xsl:value-of select="$vReg"/></xsl:attribute>
					<xsl:attribute name="origin"><xsl:value-of select="Origin"/></xsl:attribute>
					<xsl:attribute name="occurrence"><xsl:value-of select="Occurrence"/></xsl:attribute>
				</Distribution>
			</xsl:for-each>
		</Distributions>
	</xsl:template>
	<xsl:template name="conRegion">
		<xsl:param name="pRegion"/>
		<xsl:choose>
			<xsl:when test="$pRegion='Australia'">Country;Australia</xsl:when>
			<xsl:when test="$pRegion='Australian Capital Territory'">Australian States;Australian Capital Territory</xsl:when>
			<xsl:when test="$pRegion='New South Wales'">Australian States;New South Wales</xsl:when>
			<xsl:when test="$pRegion='Queensland'">Australian States;Queensland</xsl:when>
			<xsl:when test="$pRegion='Western Australia'">Australian States;Western Australia</xsl:when>
			<xsl:when test="$pRegion='South Australia'">Australian States;South Australia</xsl:when>
			<xsl:when test="$pRegion='Victoria'">Australian States;Victoria</xsl:when>
			<xsl:when test="$pRegion='Northern Territory'">Australian States;Northern Territory</xsl:when>
			<xsl:when test="$pRegion='Tasmania'">Australian States;Tasmania</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>

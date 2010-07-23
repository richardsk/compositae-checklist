<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<Distributions>
			<xsl:for-each select="//Occurrence">
				<Distribution>
					<xsl:variable name="vResult">
						<xsl:call-template name="conBiostatus">
							<xsl:with-param name="pProv" select="Status"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:attribute name="schema">Euro+Med</xsl:attribute>
					<xsl:attribute name="region"><xsl:value-of select="AreaCode"/></xsl:attribute>
					<xsl:attribute name="origin">
								<xsl:value-of select="substring-after($vResult, ';')"/>
							</xsl:attribute>
							<xsl:attribute name="occurrence">
									<xsl:value-of select="substring-before($vResult, ';')"/>
							</xsl:attribute>
				</Distribution>
			</xsl:for-each>
		</Distributions>
	</xsl:template>


<xsl:template name="conBiostatus">
	<xsl:param name="pProv"/>
	<xsl:choose>
		<xsl:when test="$pProv='cultivated: C'"></xsl:when>
		<xsl:when test="$pProv='introduced: F'"></xsl:when>
		<xsl:when test="$pProv='introduced: I(A)'"></xsl:when>
		<xsl:when test="$pProv='native: D'"></xsl:when>
		<xsl:when test="$pProv='native: E'"></xsl:when>
		<xsl:when test="$pProv='introduced: D'"></xsl:when>
		<xsl:when test="$pProv='introduced: I'"></xsl:when>
		<xsl:when test="$pProv='introduced: I(N)'"></xsl:when>
		<xsl:when test="$pProv='introduced: Q'"></xsl:when>
		<xsl:when test="$pProv='native: F'"></xsl:when>
		<xsl:when test="$pProv='native: N'"></xsl:when>
		<xsl:when test="$pProv='native: Q'"></xsl:when>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>

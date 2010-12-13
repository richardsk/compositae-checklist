<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml Colombia_Sample.xml?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<Distributions>
			<xsl:for-each select="//Distribution">

			<xsl:for-each select="Region">

				<xsl:variable name="vRegion">
					<xsl:call-template name="conRegion">
						<xsl:with-param name="pRegion" select="."/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="vSchema" select="substring-before($vRegion,';')"/>
				<xsl:variable name="vReg" select="substring-after($vRegion,';')"/>
				<Distribution>
					<xsl:attribute name="schema"><xsl:value-of select="$vSchema"/></xsl:attribute>
					<xsl:attribute name="region"><xsl:value-of select="$vReg"/></xsl:attribute>
					<xsl:attribute name="occurrence"><xsl:value-of select="../Occurrence"/></xsl:attribute>
					<xsl:attribute name="origin"><xsl:value-of select="../Origin"/></xsl:attribute>
				</Distribution>

			</xsl:for-each>


			</xsl:for-each>
		</Distributions>
	</xsl:template>
	<xsl:template name="conRegion">
		<xsl:param name="pRegion"/>
		<xsl:choose>
			<xsl:when test="$pRegion='Venezuela'">ISO Countries;Venezuela</xsl:when>
			<xsl:when test="$pRegion='Colombia'">ISO Countries;Colombia</xsl:when>
			<xsl:when test="$pRegion='Ecuador'">ISO Countries;Ecuador</xsl:when>
			<xsl:when test="$pRegion='Costa Rica'">ISO Countries;Costa Rica</xsl:when>
			<xsl:when test="$pRegion='Peru'">ISO Countries;Peru</xsl:when>
			<xsl:when test="$pRegion='Bolivia'">ISO Countries;Bolivia</xsl:when>
			<xsl:when test="$pRegion='Chile'">ISO Countries;Chile</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml Colombia_Sample.xml?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<Distributions>
			<xsl:for-each select="//Distribution">

			<xsl:for-each select="//Region">

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
					<xsl:attribute name="occurrence"><xsl:value-of select="Occurrence"/></xsl:attribute>
					<xsl:attribute name="origin"><xsl:value-of select="Origin"/></xsl:attribute>
				</Distribution>

			</xsl:for-each>


			</xsl:for-each>
		</Distributions>
	</xsl:template>
	<xsl:template name="conRegion">
		<xsl:param name="pRegion"/>
		<xsl:choose>
			<xsl:when test="$pRegion='AC'">TDWG Level 4;BZN-AC</xsl:when>
			<xsl:when test="$pRegion='AL'">TDWG Level 4;BZE-AL</xsl:when>
			<xsl:when test="$pRegion='AP'">TDWG Level 4;BZN-AP</xsl:when>
			<xsl:when test="$pRegion='AM'">TDWG Level 4;BZN-AM</xsl:when>
			<xsl:when test="$pRegion='BA'">TDWG Level 4;BZE-BA</xsl:when>
			<xsl:when test="$pRegion='CE'">TDWG Level 4;BZE-CE</xsl:when>
			<xsl:when test="$pRegion='DF'">TDWG Level 4;BZC-DF</xsl:when>
			<xsl:when test="$pRegion='ES'">TDWG Level 4;BZL-ES</xsl:when>
			<xsl:when test="$pRegion='GO'">TDWG Level 4;BZC-GO</xsl:when>
			<xsl:when test="$pRegion='MA'">TDWG Level 4;BZE-MA</xsl:when>
			<xsl:when test="$pRegion='MT'">TDWG Level 4;BZC-MT</xsl:when>
			<xsl:when test="$pRegion='MS'">TDWG Level 4;BZC-MS</xsl:when>
			<xsl:when test="$pRegion='MG'">TDWG Level 4;BZL-MG</xsl:when>
			<xsl:when test="$pRegion='PA'">TDWG Level 4;BZN-PA</xsl:when>
			<xsl:when test="$pRegion='PB'">TDWG Level 4;BZE-PB</xsl:when>
			<xsl:when test="$pRegion='PR'">TDWG Level 4;BZS-PR</xsl:when>
			<xsl:when test="$pRegion='PE'">TDWG Level 4;BZE-PE</xsl:when>
			<xsl:when test="$pRegion='PI'">TDWG Level 4;BZE-PI</xsl:when>
			<xsl:when test="$pRegion='RJ'">TDWG Level 4;BZL-RJ</xsl:when>
			<xsl:when test="$pRegion='RN'">TDWG Level 4;BZE-RN</xsl:when>
			<xsl:when test="$pRegion='RS'">TDWG Level 4;BZS-RS</xsl:when>
			<xsl:when test="$pRegion='RO'">TDWG Level 4;BZN-RO</xsl:when>
			<xsl:when test="$pRegion='RR'">TDWG Level 4;BZN-RM</xsl:when>
			<xsl:when test="$pRegion='SC'">TDWG Level 4;BZS-SC</xsl:when>
			<xsl:when test="$pRegion='SP'">TDWG Level 4;BZL-SP</xsl:when>
			<xsl:when test="$pRegion='SE'">TDWG Level 4;BZE-SE</xsl:when>
			<xsl:when test="$pRegion='TO'">TDWG Level 4;BZN-TO</xsl:when>
			<xsl:when test="$pRegion='N'">TDWG Level 3;BZN</xsl:when>
			<xsl:when test="$pRegion='NE'">TDWG Level 3;BZE</xsl:when>
			<xsl:when test="$pRegion='CO'">TDWG Level 3;BZC</xsl:when>
			<xsl:when test="$pRegion='SE'">TDWG Level 3;BZL</xsl:when>
			<xsl:when test="$pRegion='S'">TDWG Level 3;BZS</xsl:when>
			<xsl:when test="$pRegion='Brazil'">TDWG Level 2;84</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>

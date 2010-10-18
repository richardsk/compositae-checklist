<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml South Australia.xml?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<Distributions>
			<xsl:for-each select="//Biostatus">
				<xsl:variable name="vRegion">
					<xsl:call-template name="conRegion">
						<xsl:with-param name="pRegion" select="Region"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="vSchema" select="substring-before($vRegion,';')"/>
				<xsl:variable name="vReg" select="substring-after($vRegion,';')"/>
				<xsl:variable name="vStatus">
					<xsl:choose>
						<xsl:when test="Status='*'">Exotic</xsl:when>
						<xsl:when test="Status='?e'">Exotic</xsl:when>
						<xsl:when test="Status='?n'">Indigenous</xsl:when>
						<xsl:when test="Status='Critically Endangered'">Indigenous</xsl:when>
						<xsl:when test="Status='Endangered'">Indigenous</xsl:when>
						<xsl:when test="Status='Endangered*'">Indigenous</xsl:when>
						<xsl:when test="Status='Extinct*'">Uncertain</xsl:when>
						<xsl:when test="Status='Rare'">Indigenous</xsl:when>
						<xsl:when test="Status='Vulnerable'">Indigenous</xsl:when>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="vOccurrence">
					<xsl:choose>
						<xsl:when test="Occurrence='Present'">Present</xsl:when>
					</xsl:choose>
				</xsl:variable>

				<Distribution>
					<xsl:attribute name="schema">
						<xsl:value-of select="$vSchema"/>
					</xsl:attribute>
					<xsl:attribute name="region">
						<xsl:value-of select="$vReg"/>
					</xsl:attribute>
					<xsl:attribute name="origin">
						<xsl:value-of select="$vStatus"/>
					</xsl:attribute>
					<xsl:attribute name="occurrence"><xsl:value-of select="$vOccurrence"/></xsl:attribute>
				</Distribution>
				
			</xsl:for-each>
		</Distributions>
	</xsl:template>
	
	<xsl:template name="conRegion">
		<xsl:param name="pRegion"/>
		<xsl:choose>
			<xsl:when test="$pRegion='Australia'">ISO Countries;Australia</xsl:when>
			<xsl:when test="$pRegion='NSW'">ISO Countries;Australia</xsl:when>
			<xsl:when test="$pRegion='NW'">South Australian Herbarium Regions;North-Western</xsl:when>
			<xsl:when test="$pRegion='LE'">South Australian Herbarium Regions;Lake Eyre</xsl:when>
			<xsl:when test="$pRegion='NU'">South Australian Herbarium Regions;Nullarbor</xsl:when>
			<xsl:when test="$pRegion='GT'">South Australian Herbarium Regions;Gairdner-Torrens</xsl:when>
			<xsl:when test="$pRegion='FR'">South Australian Herbarium Regions;Flinders Ranges</xsl:when>
			<xsl:when test="$pRegion='EA'">South Australian Herbarium Regions;Eastern</xsl:when>
			<xsl:when test="$pRegion='EP'">South Australian Herbarium Regions;Eyre Peninsula</xsl:when>
			<xsl:when test="$pRegion='NL'">South Australian Herbarium Regions;Northern Lofty</xsl:when>
			<xsl:when test="$pRegion='MU'">South Australian Herbarium Regions;Murray</xsl:when>
			<xsl:when test="$pRegion='YP'">South Australian Herbarium Regions;Yorke Peninsula</xsl:when>
			<xsl:when test="$pRegion='SL'">South Australian Herbarium Regions;Southern Lofty</xsl:when>
			<xsl:when test="$pRegion='KI'">South Australian Herbarium Regions;Kangaroo Island</xsl:when>
			<xsl:when test="$pRegion='SE'">South Australian Herbarium Regions;South-Eastern</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>

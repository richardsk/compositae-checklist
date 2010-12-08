<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml Colombia_Sample.xml?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<Distributions>
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
					<xsl:attribute name="origin"></xsl:attribute>
					<xsl:attribute name="occurrence">Present</xsl:attribute>
				</Distribution>
			</xsl:for-each>
		</Distributions>
	</xsl:template>
	<xsl:template name="conRegion">
		<xsl:param name="pRegion"/>
		<xsl:choose>
			<xsl:when test="$pRegion='Amazonas'">TDWG Level 4;CLM-OO</xsl:when>
			<xsl:when test="$pRegion='Antioquia'">TDWG Level 4;CLM-OO</xsl:when>
			<xsl:when test="$pRegion='Arauca'">TDWG Level 4;CLM-OO</xsl:when>
			<xsl:when test="$pRegion='Atlántico'">TDWG Level 4;CLM-OO</xsl:when>
			<xsl:when test="$pRegion='Bolívar'">TDWG Level 4;CLM-OO</xsl:when>
			<xsl:when test="$pRegion='Boyacá'">TDWG Level 4;CLM-OO</xsl:when>
			<xsl:when test="$pRegion='Caldas'">TDWG Level 4;CLM-OO</xsl:when>
			<xsl:when test="$pRegion='Caquetá'">TDWG Level 4;CLM-OO</xsl:when>
			<xsl:when test="$pRegion='Casanare'">TDWG Level 4;CLM-OO</xsl:when>
			<xsl:when test="$pRegion='Cauca'">TDWG Level 4;CLM-OO</xsl:when>
			<xsl:when test="$pRegion='Cesar'">TDWG Level 4;CLM-OO</xsl:when>
			<xsl:when test="$pRegion='Chocó'">TDWG Level 4;CLM-OO</xsl:when>
			<xsl:when test="$pRegion='Córdoba'">TDWG Level 4;CLM-OO</xsl:when>
			<xsl:when test="$pRegion='Cundinamarca'">TDWG Level 4;CLM-OO</xsl:when>
			<xsl:when test="$pRegion='Desconocido'">TDWG Level 4;CLM-OO</xsl:when>
			<xsl:when test="$pRegion='Guajira'">TDWG Level 4;CLM-OO</xsl:when>
			<xsl:when test="$pRegion='Guaviare'">TDWG Level 4;CLM-OO</xsl:when>
			<xsl:when test="$pRegion='Huila'">TDWG Level 4;CLM-OO</xsl:when>
			<xsl:when test="$pRegion='Magdalena'">TDWG Level 4;CLM-OO</xsl:when>
			<xsl:when test="$pRegion='Meta'">TDWG Level 4;CLM-OO</xsl:when>
			<xsl:when test="$pRegion='Nariño'">TDWG Level 4;CLM-OO</xsl:when>
			<xsl:when test="$pRegion='Norte de Santander'">TDWG Level 4;CLM-OO</xsl:when>
			<xsl:when test="$pRegion='Putumayo'">TDWG Level 4;CLM-OO</xsl:when>
			<xsl:when test="$pRegion='Quindío'">TDWG Level 4;CLM-OO</xsl:when>
			<xsl:when test="$pRegion='Risaralda'">TDWG Level 4;CLM-OO</xsl:when>
			<xsl:when test="$pRegion='San Andrés y Providencia'">TDWG Level 4;CLM-OO</xsl:when>
			<xsl:when test="$pRegion='Santander'">TDWG Level 4;CLM-OO</xsl:when>
			<xsl:when test="$pRegion='Sucre'">TDWG Level 4;CLM-OO</xsl:when>
			<xsl:when test="$pRegion='Tolima'">TDWG Level 4;CLM-OO</xsl:when>
			<xsl:when test="$pRegion='Tolima'">TDWG Level 4;CLM-OO</xsl:when>
			<xsl:when test="$pRegion='Valle'">TDWG Level 4;CLM-OO</xsl:when>
			<xsl:when test="$pRegion='Vaupés'">TDWG Level 4;CLM-OO</xsl:when>
			<xsl:when test="$pRegion='Vichada'">TDWG Level 4;CLM-OO</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>

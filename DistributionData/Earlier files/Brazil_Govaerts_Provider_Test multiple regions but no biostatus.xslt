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
				<xsl:when test="$pRegion='AC'">Brazilian States;Acre</xsl:when>
				<xsl:when test="$pRegion='AL'">Brazilian States;Alagoas</xsl:when>
				<xsl:when test="$pRegion='AP'">Brazilian States;Amapá</xsl:when>
				<xsl:when test="$pRegion='AM'">Brazilian States;Amazonas</xsl:when>
				<xsl:when test="$pRegion='BA'">Brazilian States;Bahia</xsl:when>
				<xsl:when test="$pRegion='CE'">Brazilian States;Ceará</xsl:when>
				<xsl:when test="$pRegion='DF'">Brazilian States;Distrito Federal</xsl:when>
				<xsl:when test="$pRegion='ES'">Brazilian States;Espírito Santo</xsl:when>
				<xsl:when test="$pRegion='GO'">Brazilian States;Goiás</xsl:when>
				<xsl:when test="$pRegion='MA'">Brazilian States;Maranhão</xsl:when>
				<xsl:when test="$pRegion='MT'">Brazilian States;Mato Grosso</xsl:when>
				<xsl:when test="$pRegion='MS'">Brazilian States;Mato Grosso do Sul</xsl:when>
				<xsl:when test="$pRegion='MG'">Brazilian States;Minas Gerais</xsl:when>
				<xsl:when test="$pRegion='PA'">Brazilian States;Pará</xsl:when>
				<xsl:when test="$pRegion='PB'">Brazilian States;Paraíba</xsl:when>
				<xsl:when test="$pRegion='PR'">Brazilian States;Paraná</xsl:when>
				<xsl:when test="$pRegion='PE'">Brazilian States;Pernambuco</xsl:when>
				<xsl:when test="$pRegion='PI'">Brazilian States;Piauí</xsl:when>
				<xsl:when test="$pRegion='RJ'">Brazilian States;Rio de Janeiro</xsl:when>
				<xsl:when test="$pRegion='RN'">Brazilian States;Rio Grande do Norte</xsl:when>
				<xsl:when test="$pRegion='RS'">Brazilian States;Rio Grande do Sul</xsl:when>
				<xsl:when test="$pRegion='RO'">Brazilian States;Rondônia</xsl:when>
				<xsl:when test="$pRegion='RR'">Brazilian States;Roraima</xsl:when>
				<xsl:when test="$pRegion='SC'">Brazilian States;Santa Catarina</xsl:when>
				<xsl:when test="$pRegion='SP'">Brazilian States;São Paulo</xsl:when>
				<xsl:when test="$pRegion='SE'">Brazilian States;Sergipe</xsl:when>
				<xsl:when test="$pRegion='TO'">Brazilian States;Tocantins</xsl:when>
				<xsl:when test="$pRegion='N'">Brazilian Regions;Norte</xsl:when>
				<xsl:when test="$pRegion='NE'">Brazilian Regions;Nordeste</xsl:when>
				<xsl:when test="$pRegion='CO'">Brazilian Regions;Centro-Oeste</xsl:when>
				<xsl:when test="$pRegion='SE'">Brazilian Regions;Sudeste</xsl:when>
				<xsl:when test="$pRegion='S'">Brazilian Regions;Sul</xsl:when>
				<xsl:when test="$pRegion='Brazil'">ISO Countries;Brazil</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>

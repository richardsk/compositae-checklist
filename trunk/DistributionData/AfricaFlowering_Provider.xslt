<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml AfricaFlowering_sample.xml?>
<!--provider id = 13-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<Distributions>
			<!--Loop thru for multiple rows-->
			<xsl:for-each select="//Distribution">
				<xsl:variable name="vRegion" select="."/>
				<xsl:call-template name="ProcessRegion">
					<xsl:with-param name="pRegionIn" select="$vRegion"/>
				</xsl:call-template>
			</xsl:for-each>
		</Distributions>
	</xsl:template>
	
	<xsl:template name="ProcessRegion">
		<xsl:param name="pRegionIn"/>
		<!-- get first region-->
		<xsl:variable name="vRegion">
			<xsl:value-of select="substring-before($pRegionIn, '_')"/>
		</xsl:variable>
		<!-- get remaining regions-->
		<xsl:variable name="vRegions" select="substring-after($pRegionIn, '_')"/>
		<!-- pick which whether to use Region or RegionIn-->
		<xsl:variable name="vUse">
			<xsl:choose>
				<xsl:when test="$vRegion=''">
					<xsl:value-of select="$pRegionIn"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$vRegion"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<!-- match the string and call appropriate template -->
		<xsl:choose>
			<xsl:when test="$vUse='AN'"><xsl:call-template name="Northern"/></xsl:when>
			<xsl:when test="$vUse='RN'"><xsl:call-template name="Northern"/></xsl:when>
			<xsl:when test="$vUse='AS'"><xsl:call-template name="Southern"/></xsl:when>
			<xsl:when test="$vUse='RS'"><xsl:call-template name="Southern"/></xsl:when>
			<xsl:when test="$vUse='AT'"><xsl:call-template name="Tropical"/></xsl:when>
			<xsl:when test="$vUse='RT'"><xsl:call-template name="Tropical"/></xsl:when>
		</xsl:choose>
		<!-- loop back to self to process remaining regions until regions is empty-->
		<xsl:if test="$vRegions!=''">
			<xsl:call-template name="ProcessRegion">
				<xsl:with-param name="pRegionIn" select="$vRegions"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="Northern">
		<Distribution schema="African Flowering Plants Database" region="Northern Africa" occurrence="Present" origin="">
			<xsl:attribute name="isOriginal">false</xsl:attribute>
		</Distribution>
	</xsl:template>
	
	<xsl:template name="Southern">
		<Distribution schema="African Flowering Plants Database" region="Southern Africa" occurrence="Present" origin="">
			<xsl:attribute name="isOriginal">false</xsl:attribute>
		</Distribution>
	</xsl:template>
	
	<xsl:template name="Tropical">
		<Distribution schema="African Flowering Plants Database" region="Tropical Africa" occurrence="Present" origin="">
			<xsl:attribute name="isOriginal">false</xsl:attribute>
		</Distribution>
	</xsl:template>
</xsl:stylesheet>

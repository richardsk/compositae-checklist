<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml SouthernCone_Sample.xml?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<Distributions>
			<xsl:variable name="vBiostatus">
				<xsl:call-template name="conBiostatus">
					<xsl:with-param name="pProv">
						<xsl:value-of select="normalize-space(substring-after(., '.'))"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:variable>
			<xsl:call-template name="parse">
				<xsl:with-param name="pText" select="translate(substring-before(., '.'), '()', ',')"/>
				<xsl:with-param name="pBiostatus" select="$vBiostatus"/>
			</xsl:call-template>
		</Distributions>
	</xsl:template>
	
	<xsl:template name="parse">
		<xsl:param name="pText"/>
		<xsl:param name="pBiostatus"/>
		<xsl:choose>
			<xsl:when test="contains($pText, ',')">
				<xsl:call-template name="writeValue">
					<xsl:with-param name="pRegion" select="substring-before($pText, ',')"/>
					<xsl:with-param name="pBiostatus" select="$pBiostatus"/>
				</xsl:call-template>
				<xsl:call-template name="parse">
					<xsl:with-param name="pText" select="substring-after($pText, ',')"/>
					<xsl:with-param name="pBiostatus" select="$pBiostatus"/>
				</xsl:call-template>
			</xsl:when>
			<!--do we need an otherwise here?-->
			<xsl:otherwise>
				<xsl:call-template name="writeValue">
					<xsl:with-param name="pRegion" select="$pText"/>
					<xsl:with-param name="pBiostatus" select="$pBiostatus"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="writeValue">
		<xsl:param name="pRegion"/>
		<xsl:param name="pBiostatus"/>
		<xsl:if test="$pRegion!=''">
			<xsl:variable name="vRegion">
				<xsl:call-template name="conRegion">
					<xsl:with-param name="pProv" select="normalize-space($pRegion)"/>
				</xsl:call-template>
			</xsl:variable>
			<Distribution>
				<xsl:attribute name="schema"><xsl:value-of select="substring-before($vRegion,';')"/></xsl:attribute>
				<xsl:attribute name="region">	<xsl:value-of select="substring-after($vRegion,';')"/></xsl:attribute>
				<xsl:attribute name="occurrence"><xsl:value-of select="substring-before($pBiostatus, ';')"/></xsl:attribute>
				<xsl:attribute name="origin"><xsl:value-of select="substring-after($pBiostatus, ';')"/></xsl:attribute>
				<!--<xsl:attribute name="isOriginal">true</xsl:attribute>-->
			</Distribution>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="conBiostatus">
		<xsl:param name="pProv"/>
		<xsl:choose>
			<xsl:when test="$pProv='N.'">Present;Indigenous</xsl:when>
			<xsl:when test="$pProv='E.'">Present;Endemic</xsl:when>
			<xsl:when test="$pProv='I.'">Present;Exotic</xsl:when>
			<xsl:when test="$pProv='?.'">Uncertain;Unknown</xsl:when>
			<xsl:when test="$pProv='T.'">Present;Exotic</xsl:when>
			<xsl:when test="$pProv='U.'">Present;Unknown</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="conRegion">
		<xsl:param name="pProv"/>
		<xsl:choose>
			<xsl:when test="$pProv='?'">TDWG Level 2;36</xsl:when>
			<xsl:when test="$pProv='AH'">TDWG Level 4;CHS-AH</xsl:when>
			<xsl:when test="$pProv='BJ'">TDWG Level 4;CHN-BJ</xsl:when>
			<xsl:when test="$pProv='FJ'">TDWG Level 4;CHS-FJ</xsl:when>
			<xsl:when test="$pProv='GS'">TDWG Level 4;CHN-GS</xsl:when>
			<xsl:when test="$pProv='GD'">TDWG Level 4;CHS-GD</xsl:when>
			<xsl:when test="$pProv='GX'">TDWG Level 4;CHS-GX</xsl:when>
			<xsl:when test="$pProv='GZ'">TDWG Level 4;CHC-GZ</xsl:when>
			<xsl:when test="$pProv='HI'">TDWG Level 4;CHH-OO</xsl:when>
			<xsl:when test="$pProv='HE'">TDWG Level 4;CHN-HB</xsl:when>
			<xsl:when test="$pProv='HL'">TDWG Level 4;CHM-HJ</xsl:when>
			<xsl:when test="$pProv='HN'">TDWG Level 4;CHS-HE</xsl:when>
			<xsl:when test="$pProv='HK'">TDWG Level 4;CHS-HK</xsl:when>
			<xsl:when test="$pProv='HB'">TDWG Level 4;CHC-HU</xsl:when>
			<xsl:when test="$pProv='HU'">TDWG Level 4;CHS-HN</xsl:when>
			<xsl:when test="$pProv='JS'">TDWG Level 4;CHS-JS</xsl:when>
			<xsl:when test="$pProv='JX'">TDWG Level 4;CHS-JX</xsl:when>
			<xsl:when test="$pProv='JL'">TDWG Level 4;CHM-JL</xsl:when>
			<xsl:when test="$pProv='LN'">TDWG Level 4;CHM-LN</xsl:when>
			<xsl:when test="$pProv='MC'">TDWG Level 4;CHS-MA</xsl:when>
			<xsl:when test="$pProv='NM'">TDWG Level 4;CHI-NM</xsl:when>
			<xsl:when test="$pProv='NX'">TDWG Level 4;CHI-NX</xsl:when>
			<xsl:when test="$pProv='QH'">TDWG Level 4;CHQ-OO</xsl:when>
			<xsl:when test="$pProv='SN'">TDWG Level 4;CHN-SA</xsl:when>
			<xsl:when test="$pProv='SD'">TDWG Level 4;CHN-SD</xsl:when>
			<xsl:when test="$pProv='SH'">TDWG Level 4;CHS-SH</xsl:when>
			<xsl:when test="$pProv='SX'">TDWG Level 4;CHN-SX</xsl:when>
			<xsl:when test="$pProv='SC'">TDWG Level 4;CHC-SC</xsl:when>
			<xsl:when test="$pProv='SS'">TDWG Level 3;SCS</xsl:when>
			<xsl:when test="$pProv='TW'">TDWG Level 4;TAI-OO</xsl:when>
			<xsl:when test="$pProv='TJ'">TDWG Level 4;CHN-TJ</xsl:when>
			<xsl:when test="$pProv='XJ'">TDWG Level 4;CHX-OO</xsl:when>
			<xsl:when test="$pProv='XZ'">TDWG Level 4;CHT-OO</xsl:when>
			<xsl:when test="$pProv='YN'">TDWG Level 4;CHC-YN</xsl:when>
			<xsl:when test="$pProv='ZJ'">TDWG Level 4;CHS-ZJ</xsl:when>
			<xsl:when test="$pProv='AA'">TDWG Level 1;2</xsl:when>
			<xsl:when test="$pProv='AF'">TDWG Level 4;AFG-OO</xsl:when>
			<xsl:when test="$pProv='AS'">TDWG Level 4;3</xsl:when>
			<xsl:when test="$pProv='AU'">TDWG Level 2;50</xsl:when>
			<xsl:when test="$pProv='BA'">TDWG Level 4;BAN-OO</xsl:when>
			<xsl:when test="$pProv='BH'">TDWG Level 4;EHM-BH</xsl:when>
			<xsl:when test="$pProv='CA'">TDWG Level 4;CBD-OO</xsl:when>
			<xsl:when test="$pProv='CB'">TDWG Level 2;81</xsl:when>
			<xsl:when test="$pProv='EU'">TDWG Level 1;1</xsl:when>
			<xsl:when test="$pProv='IA'">TDWG Level 3;IND</xsl:when>
			<xsl:when test="$pProv='ID'">TDWG Level 2;42</xsl:when>
			<xsl:when test="$pProv='IO'">TDWG Level 1;4</xsl:when>
			<xsl:when test="$pProv='JA'">TDWG Level 3;JAP</xsl:when>
			<xsl:when test="$pProv='KA'">TDWG Level 4;KAZ-OO</xsl:when>
			<xsl:when test="$pProv='KO'">TDWG Level 3;KOR</xsl:when>
			<xsl:when test="$pProv='KR'">TDWG Level 4;WHM-JK</xsl:when>
			<xsl:when test="$pProv='KY'">TDWG Level 3;KGZ</xsl:when>
			<xsl:when test="$pProv='LA'">TDWG Level 4;LAO-OO</xsl:when>
			<xsl:when test="$pProv='MA'">TDWG Level 4;MLY-PM</xsl:when>
			<xsl:when test="$pProv='MD'">TDWG Level 4;MDG-OO</xsl:when>
			<xsl:when test="$pProv='MO'">TDWG Level 4;MON-OO</xsl:when>
			<xsl:when test="$pProv='MY'">TDWG Level 4;MYA-OO</xsl:when>
			<xsl:when test="$pProv='NA'">TDWG Level 1;7</xsl:when>
			<xsl:when test="$pProv='NE'">TDWG Level 4;NEP-OO</xsl:when>
			<xsl:when test="$pProv='NG'">TDWG Level 3;NWG</xsl:when>
			<xsl:when test="$pProv='NZ'">TDWG Level 2;51</xsl:when>
			<xsl:when test="$pProv='PA'">TDWG Level 4;PAK-OO</xsl:when>
			<xsl:when test="$pProv='PH'">TDWG Level 4;PHI-OO</xsl:when>
			<xsl:when test="$pProv='PI'">TDWG Level 1;6</xsl:when>
			<xsl:when test="$pProv='RU'">TDWG Level 1;3</xsl:when>
			<xsl:when test="$pProv='SA'">TDWG Level 1;8</xsl:when>
			<xsl:when test="$pProv='SI'">TDWG Level 4;MLY-SI</xsl:when>
			<xsl:when test="$pProv='SL'">TDWG Level 4;SRL-OO</xsl:when>
			<xsl:when test="$pProv='SM'">TDWG Level 4;EHM-SI</xsl:when>
			<xsl:when test="$pProv='TA'">TDWG Level 4;TZK-OO</xsl:when>
			<xsl:when test="$pProv='TH'">TDWG Level 4;THA-OO</xsl:when>
			<xsl:when test="$pProv='TU'">TDWG Level 4;TKM-OO</xsl:when>
			<xsl:when test="$pProv='UZ'">TDWG Level 4;UZB-OO</xsl:when>
			<xsl:when test="$pProv='VN'">TDWG Level 4;VIE-OO</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	
</xsl:stylesheet>

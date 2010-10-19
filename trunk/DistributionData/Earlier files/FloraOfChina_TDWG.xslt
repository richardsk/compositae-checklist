<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml FloraOfChina_Sample.xml?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<Distributions>
			<xsl:for-each select="//Province">
				<xsl:variable name="vProv">
					<xsl:call-template name="conProv">
						<xsl:with-param name="pProv" select="."/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:if test="$vProv!=''">
					<Distibution>
						<xsl:attribute name="schema">TDWG Level 4</xsl:attribute>
						<xsl:attribute name="region"><xsl:value-of select="$vProv"/></xsl:attribute>
						<xsl:attribute name="occurrence">Present</xsl:attribute>
						<xsl:attribute name="origin"/>
					</Distibution>
				</xsl:if>
			</xsl:for-each>
			<xsl:for-each select="//Country">
				<xsl:variable name="vCoun">
					<xsl:call-template name="conCountry">
						<xsl:with-param name="pCountry" select="."/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:if test="$vCoun !=''">
					<Distribution>
						<xsl:attribute name="schema"><xsl:value-of select="substring-after($vCoun, ':')"/></xsl:attribute>
						<xsl:attribute name="region"><xsl:value-of select="substring-before($vCoun, ':')"/></xsl:attribute>
						<xsl:attribute name="occurrence">Present</xsl:attribute>
						<xsl:attribute name="origin"/>
					</Distribution>
				</xsl:if>
			</xsl:for-each>
			<xsl:for-each select="//Region">
				<xsl:variable name="vRegion">
					<xsl:call-template name="conRegion">
						<xsl:with-param name="pRegion" select="."/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:if test="$vRegion !=''">
					<Distribution>
						<xsl:attribute name="schema"><xsl:value-of select="substring-after($vRegion, ':')"/></xsl:attribute>
						<xsl:attribute name="region"><xsl:value-of select="substring-before($vRegion, ':')"/></xsl:attribute>
						<xsl:attribute name="occurrence">Present</xsl:attribute>
						<xsl:attribute name="origin"/>
					</Distribution>
				</xsl:if>
			</xsl:for-each>
		</Distributions>
	</xsl:template>
	<xsl:template name="conProv">
		<xsl:param name="pProv"/>
		<xsl:choose>
			<xsl:when test="$pProv='(YN'">CHC-YN</xsl:when>
			<xsl:when test="$pProv='?'"/>
			<xsl:when test="$pProv='1H'"/>
			<xsl:when test="$pProv='AH'">CHS-AH</xsl:when>
			<xsl:when test="$pProv='AN'">CHS-AN</xsl:when>
			<xsl:when test="$pProv='BH'"/>
			<xsl:when test="$pProv='BJ'">CHN-BJ</xsl:when>
			<xsl:when test="$pProv='BJ?'">CHN-BJ</xsl:when>
			<xsl:when test="$pProv='FJ'">CHS-FJ</xsl:when>
			<xsl:when test="$pProv='GA'"/>
			<xsl:when test="$pProv='GD'">CHS-GD</xsl:when>
			<xsl:when test="$pProv='GS'">CHN-GS</xsl:when>
			<xsl:when test="$pProv='GX'">CHS-GX</xsl:when>
			<xsl:when test="$pProv='GZ'">CHC-GZ</xsl:when>
			<xsl:when test="$pProv='HB'">CHN-HB</xsl:when>
			<xsl:when test="$pProv='HE'">CHS-HE</xsl:when>
			<xsl:when test="$pProv='HI'"/>
			<xsl:when test="$pProv='HK'">CHS-HK</xsl:when>
			<xsl:when test="$pProv='HL'"/>
			<xsl:when test="$pProv='HN'">CHS-HN</xsl:when>
			<xsl:when test="$pProv='HS'"/>
			<xsl:when test="$pProv='HU'">CHC-HU</xsl:when>
			<xsl:when test="$pProv='JL'">CHM-JL</xsl:when>
			<xsl:when test="$pProv='JL?'">CHM-JL</xsl:when>
			<xsl:when test="$pProv='JS'">CHS-JS</xsl:when>
			<xsl:when test="$pProv='JX'">CHS-JX</xsl:when>
			<xsl:when test="$pProv='JZ'"/>
			<xsl:when test="$pProv='LN'">CHM-LN</xsl:when>
			<xsl:when test="$pProv='LN?)'">CHM-LN</xsl:when>
			<xsl:when test="$pProv='MD'"/>
			<xsl:when test="$pProv='NM SC'"/>
			<xsl:when test="$pProv='MC'"/>
			<xsl:when test="$pProv='NE'"/>
			<xsl:when test="$pProv='NM'">CHI-NM</xsl:when>
			<xsl:when test="$pProv='NW CHINA'"/>
			<xsl:when test="$pProv='NX'">CHI-NX</xsl:when>
			<xsl:when test="$pProv='NX?'">CHI-NX</xsl:when>
			<xsl:when test="$pProv='QH'"/>
			<xsl:when test="$pProv='QJ'"/>
			<xsl:when test="$pProv='SC'">CHC-SC</xsl:when>
			<xsl:when test="$pProv='SD'">CHN-SD</xsl:when>
			<xsl:when test="$pProv='SD?'">CHN-SD</xsl:when>
			<xsl:when test="$pProv='SH'">CHS-SH</xsl:when>
			<xsl:when test="$pProv='SN'"/>
			<xsl:when test="$pProv='SS'"/>
			<xsl:when test="$pProv='SX'">CHN-SX</xsl:when>
			<xsl:when test="$pProv='SZ'"/>
			<xsl:when test="$pProv='SW CHINA'"/>
			<xsl:when test="$pProv='TJ'">CHN-TJ</xsl:when>
			<xsl:when test="$pProv='TW?'"/>
			<xsl:when test="$pProv='TW (HL'"/>
			<xsl:when test="$pProv='TW'"/>
			<xsl:when test="$pProv='XM'"/>
			<xsl:when test="$pProv='XJ'"/>
			<xsl:when test="$pProv='XZ?)'"/>
			<xsl:when test="$pProv='XZ'"/>
			<xsl:when test="$pProv='YN'">CHC-YN</xsl:when>
			<xsl:when test="$pProv='YZ'"/>
			<xsl:when test="$pProv=''"/>
			<xsl:when test="$pProv='??'"/>
			<xsl:when test="$pProv='ZJ'">CHS-ZJ</xsl:when>
			<xsl:when test="$pProv='NEED SPECIFIC PROVINCE'"/>
			<xsl:when test="$pProv='NEED SPECIFIC PROVINCES'"/>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="conCountry">
		<xsl:param name="pCountry"/>
		<xsl:choose>
			<xsl:when test="$pCountry='AF'">AFG-OO:TDWG Level 4</xsl:when>
			<xsl:when test="$pCountry='BA'">BAN-OO:TDWG Level 4</xsl:when>
			<xsl:when test="$pCountry='BH'">EHM-BH:TDWG Level 4</xsl:when>
			<xsl:when test="$pCountry='CA'">CBD-OO:TDWG Level 4</xsl:when>
			<xsl:when test="$pCountry='IA'">IND:TDWG Level 3</xsl:when>
			<xsl:when test="$pCountry='ID'"/>
			<xsl:when test="$pCountry='JA'">JAP:TDWG Level 3</xsl:when>
			<xsl:when test="$pCountry='KR'"/>
			<xsl:when test="$pCountry='KA'">KAZ-OO:TDWG Level 4</xsl:when>
			<xsl:when test="$pCountry='KO'">KOR:TDWG Level 3</xsl:when>
			<xsl:when test="$pCountry='KY'"/>
			<xsl:when test="$pCountry='LA'">LAO-OO:TDWG Level 4</xsl:when>
			<xsl:when test="$pCountry='MA'"/>
			<xsl:when test="$pCountry='MO'">MON-OO:TDWG Level 4</xsl:when>
			<xsl:when test="$pCountry='MY'">MYA-OO:TDWG Level 4</xsl:when>
			<xsl:when test="$pCountry='NE'">NEP-OO:TDWG Level 4</xsl:when>
			<xsl:when test="$pCountry='NG'">NWG:TDWG Level 3</xsl:when>
			<xsl:when test="$pCountry='PA'">PAK-OO:TDWG Level 4</xsl:when>
			<xsl:when test="$pCountry='PH'">PHI-OO:TDWG Level 4</xsl:when>
			<xsl:when test="$pCountry='RU'"/>
			<xsl:when test="$pCountry='SI'">MLY-SI:TDWG Level 4</xsl:when>
			<xsl:when test="$pCountry='SM'">EHM-SI:TDWG Level 4</xsl:when>
			<xsl:when test="$pCountry='SL'">SRL-OO:TDWG Level 4</xsl:when>
			<xsl:when test="$pCountry='TA'"/>
			<xsl:when test="$pCountry='TH'">THA-OO:TDWG Level 4</xsl:when>
			<xsl:when test="$pCountry='TU'">TKM-OO:TDWG Level 4</xsl:when>
			<xsl:when test="$pCountry='UZ'">UZB-OO:TDWG Level 4</xsl:when>
			<xsl:when test="$pCountry='VN'">VIE-OO:TDWG Level 4</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="conRegion">
		<xsl:param name="pRegion"/>
		<xsl:choose>
			<xsl:when test="$pRegion='AA'"></xsl:when>
			<xsl:when test="$pRegion='AS'"></xsl:when>
			<xsl:when test="$pRegion='AU'"></xsl:when>
			<xsl:when test="$pRegion='CB'">81:TDWG Level 2</xsl:when>
			<xsl:when test="$pRegion='EU'">1:TDWG Level 1</xsl:when>
			<xsl:when test="$pRegion='IO'"></xsl:when>
			<xsl:when test="$pRegion='MD'">MDG-OO:TDWG Level 4</xsl:when>
			<xsl:when test="$pRegion='NZ'">51:TDWG Level 2</xsl:when>
			<xsl:when test="$pRegion='NA'"></xsl:when>
			<xsl:when test="$pRegion='PI'"></xsl:when>
			<xsl:when test="$pRegion='SA'"></xsl:when>
			<xsl:when test="$pRegion='WW'"></xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>

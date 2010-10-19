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
			<xsl:when test="$pProv='N.'">Present;Native</xsl:when>
			<xsl:when test="$pProv='E.'">Present;Endemic</xsl:when>
			<xsl:when test="$pProv='I.'">Present;Introduced</xsl:when>
			<xsl:when test="$pProv='?.'">Uncertain;Unknown</xsl:when>
			<xsl:when test="$pProv='T.'">Present;Naturalised</xsl:when>
			<xsl:when test="$pProv='U.'">Present;Unknown</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="conRegion">
		<xsl:param name="pProv"/>
		<xsl:choose>
			<xsl:when test="$pProv='?'">ISO Countries;China</xsl:when>
			<xsl:when test="$pProv='AH'">Provinces of China;Anhui</xsl:when>
			<xsl:when test="$pProv='BJ'">Provinces of China;Beijing</xsl:when>
			<xsl:when test="$pProv='FJ'">Provinces of China;Fujian</xsl:when>
			<xsl:when test="$pProv='GS'">Provinces of China;Gansu</xsl:when>
			<xsl:when test="$pProv='GD'">Provinces of China;Guangdong</xsl:when>
			<xsl:when test="$pProv='GX'">Provinces of China;Guangxi</xsl:when>
			<xsl:when test="$pProv='GZ'">Provinces of China;Guizhou</xsl:when>
			<xsl:when test="$pProv='HI'">Provinces of China;Hainan</xsl:when>
			<xsl:when test="$pProv='HE'">Provinces of China;Hebei</xsl:when>
			<xsl:when test="$pProv='HL'">Provinces of China;Heilongjiang</xsl:when>
			<xsl:when test="$pProv='HN'">Provinces of China;Henan</xsl:when>
			<xsl:when test="$pProv='HK'">Provinces of China;Hong Kong</xsl:when>
			<xsl:when test="$pProv='HB'">Provinces of China;Hubei</xsl:when>
			<xsl:when test="$pProv='HU'">Provinces of China;Hunan</xsl:when>
			<xsl:when test="$pProv='JS'">Provinces of China;Jiangsu</xsl:when>
			<xsl:when test="$pProv='JX'">Provinces of China;Jiangxi</xsl:when>
			<xsl:when test="$pProv='JL'">Provinces of China;Jilin</xsl:when>
			<xsl:when test="$pProv='LN'">Provinces of China;Liaoning</xsl:when>
			<xsl:when test="$pProv='MC'">Provinces of China;Macao</xsl:when>
			<xsl:when test="$pProv='NM'">Provinces of China;Nei Mongol</xsl:when>
			<xsl:when test="$pProv='NX'">Provinces of China;Ningxia</xsl:when>
			<xsl:when test="$pProv='QH'">Provinces of China;Qinghai</xsl:when>
			<xsl:when test="$pProv='SN'">Provinces of China;Shaanxi</xsl:when>
			<xsl:when test="$pProv='SD'">Provinces of China;Shandong</xsl:when>
			<xsl:when test="$pProv='SH'">Provinces of China;Shanghai</xsl:when>
			<xsl:when test="$pProv='SX'">Provinces of China;Shanxi</xsl:when>
			<xsl:when test="$pProv='SC'">Provinces of China;Sichuan</xsl:when>
			<xsl:when test="$pProv='SS'">Provinces of China;South China Sea Islands</xsl:when>
			<xsl:when test="$pProv='TW'">Provinces of China;Taiwan</xsl:when>
			<xsl:when test="$pProv='TJ'">Provinces of China;Tianjin</xsl:when>
			<xsl:when test="$pProv='XJ'">Provinces of China;Xinjiang</xsl:when>
			<xsl:when test="$pProv='XZ'">Provinces of China;Xizang</xsl:when>
			<xsl:when test="$pProv='YN'">Provinces of China;Yunnan</xsl:when>
			<xsl:when test="$pProv='ZJ'">Provinces of China;Zhejiang</xsl:when>
			<xsl:when test="$pProv='AA'">Continent;Africa</xsl:when>
			<xsl:when test="$pProv='AF'">ISO Countries;Afghanistan</xsl:when>
			<xsl:when test="$pProv='AS'">Continent;Asia  [Including Iran, Iraq, Turkey]</xsl:when>
			<xsl:when test="$pProv='AU'">ISO Countries;Australia</xsl:when>
			<xsl:when test="$pProv='BA'">ISO Countries;Bangladesh</xsl:when>
			<xsl:when test="$pProv='BH'">ISO Countries;Bhutan</xsl:when>
			<xsl:when test="$pProv='CA'">ISO Countries;Cambodia</xsl:when>
			<xsl:when test="$pProv='CB'">Region;Caribbean</xsl:when>
			<xsl:when test="$pProv='EU'">Continent;Europe</xsl:when>
			<xsl:when test="$pProv='IA'">ISO Countries;India</xsl:when>
			<xsl:when test="$pProv='ID'">ISO Countries;Indonesia</xsl:when>
			<xsl:when test="$pProv='IO'">Islands;Indian Ocean Islands</xsl:when>
			<xsl:when test="$pProv='JA'">ISO Countries;Japan</xsl:when>
			<xsl:when test="$pProv='KA'">ISO Countries;Kazakhstan</xsl:when>
			<xsl:when test="$pProv='KO'">ISO Countries;Korea</xsl:when>
			<xsl:when test="$pProv='KR'">Region;Kashmir</xsl:when>
			<xsl:when test="$pProv='KY'">ISO Countries;Kyrgyzstan</xsl:when>
			<xsl:when test="$pProv='LA'">ISO Countries;Laos</xsl:when>
			<xsl:when test="$pProv='MA'">ISO Countries;Malaysia</xsl:when>
			<xsl:when test="$pProv='MD'">ISO Countries;Madagascar</xsl:when>
			<xsl:when test="$pProv='MO'">ISO Countries;Mongolia</xsl:when>
			<xsl:when test="$pProv='MY'">ISO Countries;Myanmar [Formerly Burma]</xsl:when>
			<xsl:when test="$pProv='NA'">Continent;North America</xsl:when>
			<xsl:when test="$pProv='NE'">ISO Countries;Nepal</xsl:when>
			<xsl:when test="$pProv='NG'">ISO Countries;New Guinea</xsl:when>
			<xsl:when test="$pProv='NZ'">ISO Countries;New Zealand</xsl:when>
			<xsl:when test="$pProv='PA'">ISO Countries;Pakistan</xsl:when>
			<xsl:when test="$pProv='PH'">ISO Countries;Philippines</xsl:when>
			<xsl:when test="$pProv='PI'">Islands;Pacific Islands</xsl:when>
			<xsl:when test="$pProv='RU'">ISO Countries;Russia [Former Soviet Union]</xsl:when>
			<xsl:when test="$pProv='SA'">Continent;South America</xsl:when>
			<xsl:when test="$pProv='SI'">ISO Countries;Singapore</xsl:when>
			<xsl:when test="$pProv='SL'">ISO Countries;Sri Lanka</xsl:when>
			<xsl:when test="$pProv='SM'">ISO Countries;Sikkim</xsl:when>
			<xsl:when test="$pProv='TA'">ISO Countries;Tajikistan</xsl:when>
			<xsl:when test="$pProv='TH'">ISO Countries;Thailand</xsl:when>
			<xsl:when test="$pProv='TU'">ISO Countries;Turkmenistan</xsl:when>
			<xsl:when test="$pProv='UZ'">ISO Countries;Uzbekistan</xsl:when>
			<xsl:when test="$pProv='VN'">ISO Countries;Vietnam</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	
</xsl:stylesheet>

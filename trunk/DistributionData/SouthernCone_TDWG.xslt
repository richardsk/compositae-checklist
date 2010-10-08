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
			<xsl:when test="$pProv='Adventicia.'">Sometimes present;Exotic</xsl:when>
			<xsl:when test="$pProv='Adventicia'">Sometimes present;Exotic</xsl:when>
			<xsl:when test="$pProv='Native.'">Present in wild;Indigenous</xsl:when>
			<xsl:when test="$pProv='Endémica.'">Present in wild;Endemic</xsl:when>
			<xsl:when test="$pProv='Naturalizada.'">Present in wild;Exotic</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="conRegion">
		<xsl:param name="pProv"/>
		<xsl:choose>
			<xsl:when test="$pProv='ARG'">TDWG Level 2;85</xsl:when>
			<xsl:when test="$pProv='BAI'">TDWG Level 4;AGE-BA</xsl:when>
			<xsl:when test="$pProv='COR'">TDWG Level 4;AGE-CD</xsl:when>
			<xsl:when test="$pProv='CHA'">TDWG Level 4;AGE-CH</xsl:when>
			<xsl:when test="$pProv='COS'">TDWG Level 4;AGE-CN</xsl:when>
			<xsl:when test="$pProv='DFE'">TDWG Level 4;AGE-DF</xsl:when>
			<xsl:when test="$pProv='ERI'">TDWG Level 4;AGE-ER</xsl:when>
			<xsl:when test="$pProv='FOR'">TDWG Level 4;AGE-FO</xsl:when>
			<xsl:when test="$pProv='LPA'">TDWG Level 4;AGE-LP</xsl:when>
			<xsl:when test="$pProv='MIS'">TDWG Level 4;AGE-MI</xsl:when>
			<xsl:when test="$pProv='SFE'">TDWG Level 4;AGE-SF</xsl:when>
			<xsl:when test="$pProv='CHU'">TDWG Level 4;AGS-CB</xsl:when>
			<xsl:when test="$pProv='NEU'">TDWG Level 4;AGS-NE</xsl:when>
			<xsl:when test="$pProv='RNE'">TDWG Level 4;AGS-RN</xsl:when>
			<xsl:when test="$pProv='SCR'">TDWG Level 4;AGS-SC</xsl:when>
			<xsl:when test="$pProv='TDF'">TDWG Level 4;AGS-TF</xsl:when>
			<xsl:when test="$pProv='CAT'">TDWG Level 4;AGW-CA</xsl:when>
			<xsl:when test="$pProv='JUJ'">TDWG Level 4;AGW-JU</xsl:when>
			<xsl:when test="$pProv='LRI'">TDWG Level 4;AGW-LR</xsl:when>
			<xsl:when test="$pProv='MEN'">TDWG Level 4;AGW-ME</xsl:when>
			<xsl:when test="$pProv='SAL'">TDWG Level 4;AGW-SA</xsl:when>
			<xsl:when test="$pProv='SDE'">TDWG Level 4;AGW-SE</xsl:when>
			<xsl:when test="$pProv='SJU'">TDWG Level 4;AGW-SJ</xsl:when>
			<xsl:when test="$pProv='SLU'">TDWG Level 4;AGW-SL</xsl:when>
			<xsl:when test="$pProv='TUC'">TDWG Level 4;AGW-TU</xsl:when>
			<xsl:when test="$pProv='BRA'">TDWG Level 2;84</xsl:when>
			<xsl:when test="$pProv='PAR'">TDWG Level 4;BZS-PR</xsl:when>
			<xsl:when test="$pProv='RGS'">TDWG Level 4;BZS-RS</xsl:when>
			<xsl:when test="$pProv='CHL'">TDWG Level 2;85</xsl:when>
			<xsl:when test="$pProv='SCA'">TDWG Level 4;BZS-SC</xsl:when>
			<xsl:when test="$pProv='VIII'">TDWG Level 4;CLC-BI</xsl:when>
			<xsl:when test="$pProv='IV'">TDWG Level 4;CLC-CO</xsl:when>
			<xsl:when test="$pProv='IX'">TDWG Level 4;CLC-LA</xsl:when>
			<xsl:when test="$pProv='VII'">TDWG Level 4;CLC-MA</xsl:when>
			<xsl:when test="$pProv='VI'">TDWG Level 4;CLC-OH</xsl:when>
			<xsl:when test="$pProv='RME'">TDWG Level 4;CLC-SA</xsl:when>
			<xsl:when test="$pProv='V'">TDWG Level 4;CLC-VA</xsl:when>
			<xsl:when test="$pProv='II'">TDWG Level 4;CLN-AN</xsl:when>
			<xsl:when test="$pProv='III'">TDWG Level 4;CLN-AT</xsl:when>
			<xsl:when test="$pProv='I'">TDWG Level 4;CLN-TA</xsl:when>
			<xsl:when test="$pProv='XI'">TDWG Level 4;CLS-AI</xsl:when>
			<xsl:when test="$pProv='X'">TDWG Level 4;CLS-LL</xsl:when>
			<xsl:when test="$pProv='XII'">TDWG Level 4;CLS-MG</xsl:when>
			<xsl:when test="$pProv='IDP'">TDWG Level 4;DSV-OO</xsl:when>
			<xsl:when test="$pProv='IJF'">TDWG Level 4;JNF-OO</xsl:when>
			<xsl:when test="$pProv='PRY'">TDWG Level 4;PAR-OO</xsl:when>
			<xsl:when test="$pProv='URY'">TDWG Level 4;URU-OO</xsl:when>
			<xsl:when test="$pProv='COL'">TDWG Level 4;URU-OO</xsl:when>
			<xsl:when test="$pProv='ART'">TDWG Level 4;URU-OO</xsl:when>
			<xsl:when test="$pProv='CAS'">TDWG Level 4;URU-OO</xsl:when>
			<xsl:when test="$pProv='CLA'">TDWG Level 4;URU-OO</xsl:when>
			<xsl:when test="$pProv='DUR'">TDWG Level 4;URU-OO</xsl:when>
			<xsl:when test="$pProv='FLA'">TDWG Level 4;URU-OO</xsl:when>
			<xsl:when test="$pProv='FLO'">TDWG Level 4;URU-OO</xsl:when>
			<xsl:when test="$pProv='LAV'">TDWG Level 4;URU-OO</xsl:when>
			<xsl:when test="$pProv='MAL'">TDWG Level 4;URU-OO</xsl:when>
			<xsl:when test="$pProv='MON'">TDWG Level 4;URU-OO</xsl:when>
			<xsl:when test="$pProv='PAY'">TDWG Level 4;URU-OO</xsl:when>
			<xsl:when test="$pProv='RIV'">TDWG Level 4;URU-OO</xsl:when>
			<xsl:when test="$pProv='RNO'">TDWG Level 4;URU-OO</xsl:when>
			<xsl:when test="$pProv='ROC'">TDWG Level 4;URU-OO</xsl:when>
			<xsl:when test="$pProv='SAO'">TDWG Level 4;URU-OO</xsl:when>
			<xsl:when test="$pProv='SJO'">TDWG Level 4;URU-OO</xsl:when>
			<xsl:when test="$pProv='SOR'">TDWG Level 4;URU-OO</xsl:when>
			<xsl:when test="$pProv='TAC'">TDWG Level 4;URU-OO</xsl:when>
			<xsl:when test="$pProv='TYT'">TDWG Level 4;URU-OO</xsl:when>
			<xsl:when test="$pProv='APA'">TDWG Level 4;PAR-OO</xsl:when>
			<xsl:when test="$pProv='AMA'">TDWG Level 4;PAR-OO</xsl:when>
			<xsl:when test="$pProv='CAU'">TDWG Level 4;PAR-OO</xsl:when>
			<xsl:when test="$pProv='CAA'">TDWG Level 4;PAR-OO</xsl:when>
			<xsl:when test="$pProv='CAN'">TDWG Level 4;PAR-OO</xsl:when>
			<xsl:when test="$pProv='CON'">TDWG Level 4;PAR-OO</xsl:when>
			<xsl:when test="$pProv='COA'">TDWG Level 4;PAR-OO</xsl:when>
			<xsl:when test="$pProv='MIE'">TDWG Level 4;PAR-OO</xsl:when>
			<xsl:when test="$pProv='PAI'">TDWG Level 4;PAR-OO</xsl:when>
			<xsl:when test="$pProv='SPE'">TDWG Level 4;PAR-OO</xsl:when>
			<xsl:when test="$pProv='CEN'">TDWG Level 4;PAR-OO</xsl:when>
			<xsl:when test="$pProv='GUA'">TDWG Level 4;PAR-OO</xsl:when>
			<xsl:when test="$pProv='APY'">TDWG Level 4;PAR-OO</xsl:when>
			<xsl:when test="$pProv='ITA'">TDWG Level 4;PAR-OO</xsl:when>
			<xsl:when test="$pProv='NEE'">TDWG Level 4;PAR-OO</xsl:when>
			<xsl:when test="$pProv='Desconocida'">TDWG Level 4;PAR-OO</xsl:when>
		

		</xsl:choose>
	</xsl:template>
	
	
</xsl:stylesheet>

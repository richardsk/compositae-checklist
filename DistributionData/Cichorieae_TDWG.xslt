<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml EuroMed_Sample.xml?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<Distributions>
			<xsl:for-each select="//Distribution">
				<xsl:variable name="vResult">
					<xsl:call-template name="conBiostatus">
						<xsl:with-param name="pProv" select="Origin"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="vRegion">
					<xsl:call-template name="conRegion">
						<xsl:with-param name="pProv" select="Region"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:call-template name="Write">
							<xsl:with-param name="pSchema"><xsl:value-of select="substring-before($vRegion,';')"/></xsl:with-param>
							<xsl:with-param name="pRegion"><xsl:value-of select="substring-after($vRegion,';')"/></xsl:with-param>
							<xsl:with-param name="pOcc"><xsl:value-of select="substring-before($vResult, ';')"/></xsl:with-param>
							<xsl:with-param name="pOrig"><xsl:value-of select="substring-after($vResult, ';')"/></xsl:with-param>
						</xsl:call-template>
				
			</xsl:for-each>
		</Distributions>
	</xsl:template>
	
	
<xsl:template name="Write">
		<xsl:param name="pSchema"/>
		<xsl:param name="pRegion"/>
		<xsl:param name="pOcc"/>
		<xsl:param name="pOrig"/>
		<!--Get the extra schema and region text from pRegion-->
		<xsl:variable name="vRemainder">
			<xsl:value-of select="substring-after($pRegion,';')"/>
		</xsl:variable>
		<!--set up a variable to get the region value, which may be all of pRegion or the left part-->
		<xsl:variable name="vReg">
			<xsl:choose>
				<xsl:when test="$vRemainder=''"><xsl:value-of select="$pRegion"/></xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="substring-before($pRegion, ';')"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!--write the result-->
		<Distribution>
			<xsl:attribute name="schema"><xsl:value-of select="$pSchema"/></xsl:attribute>
			<xsl:attribute name="region"><xsl:value-of select="$vReg"/></xsl:attribute>
			<xsl:attribute name="origin"><xsl:value-of select="$pOrig"/></xsl:attribute>
			<xsl:attribute name="occurrence"><xsl:value-of select="$pOcc"/></xsl:attribute>
		</Distribution>
		<!--check to see whether it has to be called again (ie., there was another region in pRegion)-->
		<xsl:if test="$vRemainder!=''">
			<xsl:call-template name="Write">
					<xsl:with-param name="pSchema"><xsl:value-of select="substring-before($vRemainder,';')"/></xsl:with-param>
					<xsl:with-param name="pRegion"><xsl:value-of select="substring-after($vRemainder,';')"/></xsl:with-param>
					<xsl:with-param name="pOcc"><xsl:value-of select="$pOcc"/></xsl:with-param>
					<xsl:with-param name="pOrig"><xsl:value-of select="$pOrig"/></xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>	
	
	
	
	<xsl:template name="conBiostatus">
		<xsl:param name="pProv"/>
		<xsl:choose>
			<xsl:when test="$pProv='introduced'">Present;Exotic</xsl:when>
			<xsl:when test="$pProv='introduced: adventitious (casual)'">Sometimes present;Exotic</xsl:when>
			<xsl:when test="$pProv='introduced: doubtfully introduced (perhaps cultivated only)'">Uncertain;Exotic</xsl:when>
			<xsl:when test="$pProv='introduced: naturalized'">Present;Exotic</xsl:when>
			<xsl:when test="$pProv='introduced: presence questionable'">Uncertain;Exotic</xsl:when>
			<xsl:when test="$pProv='introduced: reported in error'">Recorded in Error;Exotic</xsl:when>
			<xsl:when test="$pProv='native'">Present;Indigenous</xsl:when>
			<xsl:when test="$pProv='native: doubtfully native'">Uncertain;Indigenous</xsl:when>
			<xsl:when test="$pProv='native: formerly native'">Extinct;Indigenous</xsl:when>
			<xsl:when test="$pProv='native: presence questionable'">Uncertain;Indigenous</xsl:when>
			<xsl:when test="$pProv='native: reported in error'">Recorded in Error;Indigenous</xsl:when>
			<xsl:when test="$pProv='present: doubtfully present'">Uncertain;</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="conRegion">
		<xsl:param name="pProv"/>
		<xsl:choose>
			<xsl:when test="$pProv='ABT-OO'">TDWG Level 4;ABT-OO</xsl:when>
			<xsl:when test="$pProv='AFG'">TDWG Level 3;AFG</xsl:when>
			<xsl:when test="$pProv='AFG-OO'">TDWG Level 4;AFG-OO</xsl:when>
			<xsl:when test="$pProv='AGE-BA'">TDWG Level 4;AGE-BA</xsl:when>
			<xsl:when test="$pProv='AGE-CD'">TDWG Level 4;AGE-CD</xsl:when>
			<xsl:when test="$pProv='AGE-CH'">TDWG Level 4;AGE-CH</xsl:when>
			<xsl:when test="$pProv='AGE-CN'">TDWG Level 4;AGE-CN</xsl:when>
			<xsl:when test="$pProv='AGE-DF'">TDWG Level 4;AGE-DF</xsl:when>
			<xsl:when test="$pProv='AGE-ER'">TDWG Level 4;AGE-ER</xsl:when>
			<xsl:when test="$pProv='AGE-FO'">TDWG Level 4;AGE-FO</xsl:when>
			<xsl:when test="$pProv='AGE-LP'">TDWG Level 4;AGE-LP</xsl:when>
			<xsl:when test="$pProv='AGE-MI'">TDWG Level 4;AGE-MI</xsl:when>
			<xsl:when test="$pProv='AGE-SF'">TDWG Level 4;AGE-SF</xsl:when>
			<xsl:when test="$pProv='AGS-CB'">TDWG Level 4;AGS-CB</xsl:when>
			<xsl:when test="$pProv='AGS-NE'">TDWG Level 4;AGS-NE</xsl:when>
			<xsl:when test="$pProv='AGS-RN'">TDWG Level 4;AGS-RN</xsl:when>
			<xsl:when test="$pProv='AGS-SC'">TDWG Level 4;AGS-SC</xsl:when>
			<xsl:when test="$pProv='AGS-TF'">TDWG Level 4;AGS-TF</xsl:when>
			<xsl:when test="$pProv='AGW-CA'">TDWG Level 4;AGW-CA</xsl:when>
			<xsl:when test="$pProv='AGW-JU'">TDWG Level 4;AGW-JU</xsl:when>
			<xsl:when test="$pProv='AGW-LR'">TDWG Level 4;AGW-LR</xsl:when>
			<xsl:when test="$pProv='AGW-ME'">TDWG Level 4;AGW-ME</xsl:when>
			<xsl:when test="$pProv='AGW-SA'">TDWG Level 4;AGW-SA</xsl:when>
			<xsl:when test="$pProv='AGW-SE'">TDWG Level 4;AGW-SE</xsl:when>
			<xsl:when test="$pProv='AGW-SJ'">TDWG Level 4;AGW-SJ</xsl:when>
			<xsl:when test="$pProv='AGW-SL'">TDWG Level 4;AGW-SL</xsl:when>
			<xsl:when test="$pProv='AGW-TU'">TDWG Level 4;AGW-TU</xsl:when>
			<xsl:when test="$pProv='ALA-OO'">TDWG Level 4;ALA-OO</xsl:when>
			<xsl:when test="$pProv='ALB-OO'">TDWG Level 4;ALB-OO</xsl:when>
			<xsl:when test="$pProv='ALD-OO'">TDWG Level 4;ALD-OO</xsl:when>
			<xsl:when test="$pProv='ALG-OO'">TDWG Level 4;ALG-OO</xsl:when>
			<xsl:when test="$pProv='ALT-OO'">TDWG Level 4;ALT-OO</xsl:when>
			<xsl:when test="$pProv='ALU'">TDWG Level 3;ALU</xsl:when>
			<xsl:when test="$pProv='AMU'">TDWG Level 3;AMU</xsl:when>
			<xsl:when test="$pProv='AMU-OO'">TDWG Level 4;AMU-OO</xsl:when>
			<xsl:when test="$pProv='AND-AN'">TDWG Level 4;AND-AN</xsl:when>
			<xsl:when test="$pProv='ANG-OO'">TDWG Level 4;ANG-OO</xsl:when>
			<xsl:when test="$pProv='ARI-OO'">TDWG Level 4;ARI-OO</xsl:when>
			<xsl:when test="$pProv='ARK-OO'">TDWG Level 4;ARK-OO</xsl:when>
			<xsl:when test="$pProv='ARU-OO'">TDWG Level 4;ARU-OO</xsl:when>
			<xsl:when test="$pProv='ASK-OO'">TDWG Level 4;ASK-OO</xsl:when>
			<xsl:when test="$pProv='ASS-AS'">TDWG Level 4;ASS-AS</xsl:when>
			<xsl:when test="$pProv='ASS-MA'">TDWG Level 4;ASS-MA</xsl:when>
			<xsl:when test="$pProv='ASS-ME'">TDWG Level 4;ASS-ME</xsl:when>
			<xsl:when test="$pProv='ASS-MI'">TDWG Level 4;ASS-MI</xsl:when>
			<xsl:when test="$pProv='ASS-NA'">TDWG Level 4;ASS-NA</xsl:when>
			<xsl:when test="$pProv='ASS-TR'">TDWG Level 4;ASS-TR</xsl:when>
			<xsl:when test="$pProv='ATP-OO'">TDWG Level 4;ATP-OO</xsl:when>
			<xsl:when test="$pProv='AUT'">TDWG Level 3;AUT</xsl:when>
			<xsl:when test="$pProv='AUT-AU'">TDWG Level 4;AUT-AU</xsl:when>
			<xsl:when test="$pProv='AUT-LI'">TDWG Level 4;AUT-LI</xsl:when>
			<xsl:when test="$pProv='AZO-OO'">TDWG Level 4;AZO-OO</xsl:when>
			<xsl:when test="$pProv='BAH-OO'">TDWG Level 4;BAH-OO</xsl:when>
			<xsl:when test="$pProv='BAL-OO'">TDWG Level 4;BAL-OO</xsl:when>
			<xsl:when test="$pProv='BAN-OO'">TDWG Level 4;BAN-OO</xsl:when>
			<xsl:when test="$pProv='BEN-OO'">TDWG Level 4;BEN-OO</xsl:when>
			<xsl:when test="$pProv='BER-OO'">TDWG Level 4;BER-OO</xsl:when>
			<xsl:when test="$pProv='BGM'">TDWG Level 3;BGM</xsl:when>
			<xsl:when test="$pProv='BGM-BE'">TDWG Level 4;BGM-BE</xsl:when>
			<xsl:when test="$pProv='BGM-LU'">TDWG Level 4;BGM-LU</xsl:when>
			<xsl:when test="$pProv='BKN'">TDWG Level 3;BKN</xsl:when>
			<xsl:when test="$pProv='BLR-OO'">TDWG Level 4;BLR-OO</xsl:when>
			<xsl:when test="$pProv='BLT-ES'">TDWG Level 4;BLT-ES</xsl:when>
			<xsl:when test="$pProv='BLT-KA'">TDWG Level 4;BLT-KA</xsl:when>
			<xsl:when test="$pProv='BLT-LA'">TDWG Level 4;BLT-LA</xsl:when>
			<xsl:when test="$pProv='BLT-LI'">TDWG Level 4;BLT-LI</xsl:when>
			<xsl:when test="$pProv='BOL-OO'">TDWG Level 4;BOL-OO</xsl:when>
			<xsl:when test="$pProv='BOR-SB'">TDWG Level 4;BOR-SB</xsl:when>
			<xsl:when test="$pProv='BOT-OO'">TDWG Level 4;BOT-OO</xsl:when>
			<xsl:when test="$pProv='BRC-OO'">TDWG Level 4;BRC-OO</xsl:when>
			<xsl:when test="$pProv='BRY-OO'">TDWG Level 4;BRY-OO</xsl:when>
			<xsl:when test="$pProv='BUL-OO'">TDWG Level 4;BUL-OO</xsl:when>
			<xsl:when test="$pProv='BUR-OO'">TDWG Level 4;BUR-OO</xsl:when>
			<xsl:when test="$pProv='BZE-BA'">TDWG Level 4;BZE-BA</xsl:when>
			<xsl:when test="$pProv='BZL-MG'">TDWG Level 4;BZL-MG</xsl:when>
			<xsl:when test="$pProv='BZL-RJ'">TDWG Level 4;BZL-RJ</xsl:when>
			<xsl:when test="$pProv='BZL-SP'">TDWG Level 4;BZL-SP</xsl:when>
			<xsl:when test="$pProv='BZS-PR'">TDWG Level 4;BZS-PR</xsl:when>
			<xsl:when test="$pProv='BZS-RS'">TDWG Level 4;BZS-RS</xsl:when>
			<xsl:when test="$pProv='BZS-SC'">TDWG Level 4;BZS-SC</xsl:when>
			<xsl:when test="$pProv='CAF-OO'">TDWG Level 4;CAF-OO</xsl:when>
			<xsl:when test="$pProv='CAL-OO'">TDWG Level 4;CAL-OO</xsl:when>
			<xsl:when test="$pProv='CAY-OO'">TDWG Level 4;CAY-OO</xsl:when>
			<xsl:when test="$pProv='CBD-OO'">TDWG Level 4;CBD-OO</xsl:when>
			<xsl:when test="$pProv='CHA-OO'">TDWG Level 4;CHA-OO</xsl:when>
			<xsl:when test="$pProv='CHC-CQ'">TDWG Level 4;CHC-CQ</xsl:when>
			<xsl:when test="$pProv='CHC-GZ'">TDWG Level 4;CHC-GZ</xsl:when>
			<xsl:when test="$pProv='CHC-HU'">TDWG Level 4;CHC-HU</xsl:when>
			<xsl:when test="$pProv='CHC-SC'">TDWG Level 4;CHC-SC</xsl:when>
			<xsl:when test="$pProv='CHC-YN'">TDWG Level 4;CHC-YN</xsl:when>
			<xsl:when test="$pProv='CHH-OO'">TDWG Level 4;CHH-OO</xsl:when>
			<xsl:when test="$pProv='CHI-NM'">TDWG Level 4;CHI-NM</xsl:when>
			<xsl:when test="$pProv='CHI-NX'">TDWG Level 4;CHI-NX</xsl:when>
			<xsl:when test="$pProv='CHM-HJ'">TDWG Level 4;CHM-HJ</xsl:when>
			<xsl:when test="$pProv='CHM-JL'">TDWG Level 4;CHM-JL</xsl:when>
			<xsl:when test="$pProv='CHM-LN'">TDWG Level 4;CHM-LN</xsl:when>
			<xsl:when test="$pProv='CHN-BJ'">TDWG Level 4;CHN-BJ</xsl:when>
			<xsl:when test="$pProv='CHN-GS'">TDWG Level 4;CHN-GS</xsl:when>
			<xsl:when test="$pProv='CHN-HB'">TDWG Level 4;CHN-HB</xsl:when>
			<xsl:when test="$pProv='CHN-SA'">TDWG Level 4;CHN-SA</xsl:when>
			<xsl:when test="$pProv='CHN-SD'">TDWG Level 4;CHN-SD</xsl:when>
			<xsl:when test="$pProv='CHN-SX'">TDWG Level 4;CHN-SX</xsl:when>
			<xsl:when test="$pProv='CHQ-OO'">TDWG Level 4;CHQ-OO</xsl:when>
			<xsl:when test="$pProv='CHS-AH'">TDWG Level 4;CHS-AH</xsl:when>
			<xsl:when test="$pProv='CHS-FJ'">TDWG Level 4;CHS-FJ</xsl:when>
			<xsl:when test="$pProv='CHS-GD'">TDWG Level 4;CHS-GD</xsl:when>
			<xsl:when test="$pProv='CHS-GX'">TDWG Level 4;CHS-GX</xsl:when>
			<xsl:when test="$pProv='CHS-HE'">TDWG Level 4;CHS-HE</xsl:when>
			<xsl:when test="$pProv='CHS-HK'">TDWG Level 4;CHS-HK</xsl:when>
			<xsl:when test="$pProv='CHS-HN'">TDWG Level 4;CHS-HN</xsl:when>
			<xsl:when test="$pProv='CHS-JS'">TDWG Level 4;CHS-JS</xsl:when>
			<xsl:when test="$pProv='CHS-JX'">TDWG Level 4;CHS-JX</xsl:when>
			<xsl:when test="$pProv='CHS-ZJ'">TDWG Level 4;CHS-ZJ</xsl:when>
			<xsl:when test="$pProv='CHT-OO'">TDWG Level 4;CHT-OO</xsl:when>
			<xsl:when test="$pProv='CHX-OO'">TDWG Level 4;CHX-OO</xsl:when>
			<xsl:when test="$pProv='CLC-BI'">TDWG Level 4;CLC-BI</xsl:when>
			<xsl:when test="$pProv='CLC-CO'">TDWG Level 4;CLC-CO</xsl:when>
			<xsl:when test="$pProv='CLC-LA'">TDWG Level 4;CLC-LA</xsl:when>
			<xsl:when test="$pProv='CLC-MA'">TDWG Level 4;CLC-MA</xsl:when>
			<xsl:when test="$pProv='CLC-OH'">TDWG Level 4;CLC-OH</xsl:when>
			<xsl:when test="$pProv='CLC-SA'">TDWG Level 4;CLC-SA</xsl:when>
			<xsl:when test="$pProv='CLC-VA'">TDWG Level 4;CLC-VA</xsl:when>
			<xsl:when test="$pProv='CLM-OO'">TDWG Level 4;CLM-OO</xsl:when>
			<xsl:when test="$pProv='CLN-AN'">TDWG Level 4;CLN-AN</xsl:when>
			<xsl:when test="$pProv='CLN-AT'">TDWG Level 4;CLN-AT</xsl:when>
			<xsl:when test="$pProv='CLN-TA'">TDWG Level 4;CLN-TA</xsl:when>
			<xsl:when test="$pProv='CLS-AI'">TDWG Level 4;CLS-AI</xsl:when>
			<xsl:when test="$pProv='CLS-LL'">TDWG Level 4;CLS-LL</xsl:when>
			<xsl:when test="$pProv='CLS-MG'">TDWG Level 4;CLS-MG</xsl:when>
			<xsl:when test="$pProv='CMN-OO'">TDWG Level 4;CMN-OO</xsl:when>
			<xsl:when test="$pProv='CNT-OO'">TDWG Level 4;CNT-OO</xsl:when>
			<xsl:when test="$pProv='CNY-OO'">TDWG Level 4;CNY-OO</xsl:when>
			<xsl:when test="$pProv='COL-OO'">TDWG Level 4;COL-OO</xsl:when>
			<xsl:when test="$pProv='COM-CO'">TDWG Level 4;COM-CO</xsl:when>
			<xsl:when test="$pProv='COM-MA'">TDWG Level 4;COM-MA</xsl:when>
			<xsl:when test="$pProv='CON-OO'">TDWG Level 4;CON-OO</xsl:when>
			<xsl:when test="$pProv='COR-OO'">TDWG Level 4;COR-OO</xsl:when>
			<xsl:when test="$pProv='COS-OO'">TDWG Level 4;COS-OO</xsl:when>
			<xsl:when test="$pProv='CPP-EC'">TDWG Level 4;CPP-EC</xsl:when>
			<xsl:when test="$pProv='CPP-NC'">TDWG Level 4;CPP-NC</xsl:when>
			<xsl:when test="$pProv='CPP-WC'">TDWG Level 4;CPP-WC</xsl:when>
			<xsl:when test="$pProv='CTA-OO'">TDWG Level 4;CTA-OO</xsl:when>
			<xsl:when test="$pProv='CTM-OO'">TDWG Level 4;CTM-OO</xsl:when>
			<xsl:when test="$pProv='CUB-OO'">TDWG Level 4;CUB-OO</xsl:when>
			<xsl:when test="$pProv='CVI'">TDWG Level 3;CVI</xsl:when>
			<xsl:when test="$pProv='CVI-OO'">TDWG Level 4;CVI-OO</xsl:when>
			<xsl:when test="$pProv='CYP'">TDWG Level 3;CYP</xsl:when>
			<xsl:when test="$pProv='CYP-OO'">TDWG Level 4;CYP-OO</xsl:when>
			<xsl:when test="$pProv='CZE'">TDWG Level 3;CZE</xsl:when>
			<xsl:when test="$pProv='CZE-CZ'">TDWG Level 4;CZE-CZ</xsl:when>
			<xsl:when test="$pProv='CZE-SK'">TDWG Level 4;CZE-SK</xsl:when>
			<xsl:when test="$pProv='DEL-OO'">TDWG Level 4;DEL-OO</xsl:when>
			<xsl:when test="$pProv='DEN-OO'">TDWG Level 4;DEN-OO</xsl:when>
			<xsl:when test="$pProv='DJI-OO'">TDWG Level 4;DJI-OO</xsl:when>
			<xsl:when test="$pProv='DOM-OO'">TDWG Level 4;DOM-OO</xsl:when>
			<xsl:when test="$pProv='DSV-OO'">TDWG Level 4;DSV-OO</xsl:when>
			<xsl:when test="$pProv='EAI-OO'">TDWG Level 4;EAI-OO</xsl:when>
			<xsl:when test="$pProv='ECU'">TDWG Level 3;ECU</xsl:when>
			<xsl:when test="$pProv='ECU-OO'">TDWG Level 4;ECU-OO</xsl:when>
			<xsl:when test="$pProv='EGY-OO'">TDWG Level 4;EGY-OO</xsl:when>
			<xsl:when test="$pProv='EHM'">TDWG Level 3;EHM</xsl:when>
			<xsl:when test="$pProv='EHM-AP'">TDWG Level 4;EHM-AP</xsl:when>
			<xsl:when test="$pProv='EHM-BH'">TDWG Level 4;EHM-BH</xsl:when>
			<xsl:when test="$pProv='EHM-DJ'">TDWG Level 4;EHM-DJ</xsl:when>
			<xsl:when test="$pProv='EHM-SI'">TDWG Level 4;EHM-SI</xsl:when>
			<xsl:when test="$pProv='EQG-OO'">TDWG Level 4;EQG-OO</xsl:when>
			<xsl:when test="$pProv='ERI-OO'">TDWG Level 4;ERI-OO</xsl:when>
			<xsl:when test="$pProv='ETH-OO'">TDWG Level 4;ETH-OO</xsl:when>
			<xsl:when test="$pProv='FIJ-OO'">TDWG Level 4;FIJ-OO</xsl:when>
			<xsl:when test="$pProv='FIN-OO'">TDWG Level 4;FIN-OO</xsl:when>
			<xsl:when test="$pProv='FLA-OO'">TDWG Level 4;FLA-OO</xsl:when>
			<xsl:when test="$pProv='FOR-OO'">TDWG Level 4;FOR-OO</xsl:when>
			<xsl:when test="$pProv='FRA'">TDWG Level 3;FRA</xsl:when>
			<xsl:when test="$pProv='FRA-CI'">TDWG Level 4;FRA-CI</xsl:when>
			<xsl:when test="$pProv='FRA-FR'">TDWG Level 4;FRA-FR</xsl:when>
			<xsl:when test="$pProv='GAL-OO'">TDWG Level 4;GAL-OO</xsl:when>
			<xsl:when test="$pProv='GAM-OO'">TDWG Level 4;GAM-OO</xsl:when>
			<xsl:when test="$pProv='GEO-OO'">TDWG Level 4;GEO-OO</xsl:when>
			<xsl:when test="$pProv='GER-OO'">TDWG Level 4;GER-OO</xsl:when>
			<xsl:when test="$pProv='GGI-BI'">TDWG Level 4;GGI-BI</xsl:when>
			<xsl:when test="$pProv='GHA-OO'">TDWG Level 4;GHA-OO</xsl:when>
			<xsl:when test="$pProv='GNL-OO'">TDWG Level 4;GNL-OO</xsl:when>
			<xsl:when test="$pProv='GRB-OO'">TDWG Level 4;GRB-OO</xsl:when>
			<xsl:when test="$pProv='GRC-OO'">TDWG Level 4;GRC-OO</xsl:when>
			<xsl:when test="$pProv='GST-BA'">TDWG Level 4;GST-BA</xsl:when>
			<xsl:when test="$pProv='GST-QA'">TDWG Level 4;GST-QA</xsl:when>
			<xsl:when test="$pProv='GST-UA'">TDWG Level 4;GST-UA</xsl:when>
			<xsl:when test="$pProv='GUA-OO'">TDWG Level 4;GUA-OO</xsl:when>
			<xsl:when test="$pProv='GUI-OO'">TDWG Level 4;GUI-OO</xsl:when>
			<xsl:when test="$pProv='HAI-HA'">TDWG Level 4;HAI-HA</xsl:when>
			<xsl:when test="$pProv='HAI-NI'">TDWG Level 4;HAI-NI</xsl:when>
			<xsl:when test="$pProv='HAW-HI'">TDWG Level 4;HAW-HI</xsl:when>
			<xsl:when test="$pProv='HON'">TDWG Level 3;HON</xsl:when>
			<xsl:when test="$pProv='HON-OO'">TDWG Level 4;HON-OO</xsl:when>
			<xsl:when test="$pProv='HUN-OO'">TDWG Level 4;HUN-OO</xsl:when>
			<xsl:when test="$pProv='ICE-OO'">TDWG Level 4;ICE-OO</xsl:when>
			<xsl:when test="$pProv='IDA-OO'">TDWG Level 4;IDA-OO</xsl:when>
			<xsl:when test="$pProv='ILL-OO'">TDWG Level 4;ILL-OO</xsl:when>
			<xsl:when test="$pProv='IND'">TDWG Level 3;IND</xsl:when>
			<xsl:when test="$pProv='IND-BI'">TDWG Level 4;IND-BI</xsl:when>
			<xsl:when test="$pProv='IND-DE'">TDWG Level 4;IND-DE</xsl:when>
			<xsl:when test="$pProv='IND-HA'">TDWG Level 4;IND-HA</xsl:when>
			<xsl:when test="$pProv='IND-KE'">TDWG Level 4;IND-KE</xsl:when>
			<xsl:when test="$pProv='IND-KT'">TDWG Level 4;IND-KT</xsl:when>
			<xsl:when test="$pProv='IND-MP'">TDWG Level 4;IND-MP</xsl:when>
			<xsl:when test="$pProv='IND-MR'">TDWG Level 4;IND-MR</xsl:when>
			<xsl:when test="$pProv='IND-OR'">TDWG Level 4;IND-OR</xsl:when>
			<xsl:when test="$pProv='IND-PU'">TDWG Level 4;IND-PU</xsl:when>
			<xsl:when test="$pProv='IND-RA'">TDWG Level 4;IND-RA</xsl:when>
			<xsl:when test="$pProv='IND-TN'">TDWG Level 4;IND-TN</xsl:when>
			<xsl:when test="$pProv='IND-UP'">TDWG Level 4;IND-UP</xsl:when>
			<xsl:when test="$pProv='IND-WB'">TDWG Level 4;IND-WB</xsl:when>
			<xsl:when test="$pProv='INI-OO'">TDWG Level 4;INI-OO</xsl:when>
			<xsl:when test="$pProv='IOW-OO'">TDWG Level 4;IOW-OO</xsl:when>
			<xsl:when test="$pProv='IRE'">TDWG Level 3;IRE</xsl:when>
			<xsl:when test="$pProv='IRE-IR'">TDWG Level 4;IRE-IR</xsl:when>
			<xsl:when test="$pProv='IRE-NI'">TDWG Level 4;IRE-NI</xsl:when>
			<xsl:when test="$pProv='IRK-OO'">TDWG Level 4;IRK-OO</xsl:when>
			<xsl:when test="$pProv='IRN'">TDWG Level 3;IRN</xsl:when>
			<xsl:when test="$pProv='IRN-OO'">TDWG Level 4;IRN-OO</xsl:when>
			<xsl:when test="$pProv='IRQ'">TDWG Level 3;IRQ</xsl:when>
			<xsl:when test="$pProv='IRQ-OO'">TDWG Level 4;IRQ-OO</xsl:when>
			<xsl:when test="$pProv='ITA'">TDWG Level 3;ITA</xsl:when>
			<xsl:when test="$pProv='IVO-OO'">TDWG Level 4;IVO-OO</xsl:when>
			<xsl:when test="$pProv='JAM-OO'">TDWG Level 4;JAM-OO</xsl:when>
			<xsl:when test="$pProv='JAP'">TDWG Level 3;JAP</xsl:when>
			<xsl:when test="$pProv='JAP-HK'">TDWG Level 4;JAP-HK</xsl:when>
			<xsl:when test="$pProv='JAP-HN'">TDWG Level 4;JAP-HN</xsl:when>
			<xsl:when test="$pProv='JAP-KY'">TDWG Level 4;JAP-KY</xsl:when>
			<xsl:when test="$pProv='JAP-SH'">TDWG Level 4;JAP-SH</xsl:when>
			<xsl:when test="$pProv='JAW-OO'">TDWG Level 4;JAW-OO</xsl:when>
			<xsl:when test="$pProv='JNF'">TDWG Level 3;JNF</xsl:when>
			<xsl:when test="$pProv='JNF-OO'">TDWG Level 4;JNF-OO</xsl:when>
			<xsl:when test="$pProv='KAM'">TDWG Level 3;KAM</xsl:when>
			<xsl:when test="$pProv='KAM-OO'">TDWG Level 4;KAM-OO</xsl:when>
			<xsl:when test="$pProv='KAN-OO'">TDWG Level 4;KAN-OO</xsl:when>
			<xsl:when test="$pProv='KAZ-OO'">TDWG Level 4;KAZ-OO</xsl:when>
			<xsl:when test="$pProv='KEN-OO'">TDWG Level 4;KEN-OO</xsl:when>
			<xsl:when test="$pProv='KER-OO'">TDWG Level 4;KER-OO</xsl:when>
			<xsl:when test="$pProv='KGZ'">TDWG Level 3;KGZ</xsl:when>
			<xsl:when test="$pProv='KGZ-OO'">TDWG Level 4;KGZ-OO</xsl:when>
			<xsl:when test="$pProv='KHA'">TDWG Level 3;KHA</xsl:when>
			<xsl:when test="$pProv='KHA-OO'">TDWG Level 4;KHA-OO</xsl:when>
			<xsl:when test="$pProv='KOR'">TDWG Level 3;KOR</xsl:when>
			<xsl:when test="$pProv='KOR-NK'">TDWG Level 4;KOR-NK</xsl:when>
			<xsl:when test="$pProv='KOR-SK'">TDWG Level 4;KOR-SK</xsl:when>
			<xsl:when test="$pProv='KRA-OO'">TDWG Level 4;KRA-OO</xsl:when>
			<xsl:when test="$pProv='KRI-OO'">TDWG Level 4;KRI-OO</xsl:when>
			<xsl:when test="$pProv='KRY-OO'">TDWG Level 4;KRY-OO</xsl:when>
			<xsl:when test="$pProv='KTY-OO'">TDWG Level 4;KTY-OO</xsl:when>
			<xsl:when test="$pProv='KUR'">TDWG Level 3;KUR</xsl:when>
			<xsl:when test="$pProv='KUR-OO'">TDWG Level 4;KUR-OO</xsl:when>
			<xsl:when test="$pProv='KUW-OO'">TDWG Level 4;KUW-OO</xsl:when>
			<xsl:when test="$pProv='LAB-OO'">TDWG Level 4;LAB-OO</xsl:when>
			<xsl:when test="$pProv='LAO'">TDWG Level 3;LAO</xsl:when>
			<xsl:when test="$pProv='LAO-OO'">TDWG Level 4;LAO-OO</xsl:when>
			<xsl:when test="$pProv='LBR-OO'">TDWG Level 4;LBR-OO</xsl:when>
			<xsl:when test="$pProv='LBS'">TDWG Level 3;LBS</xsl:when>
			<xsl:when test="$pProv='LBS-LB'">TDWG Level 4;LBS-LB</xsl:when>
			<xsl:when test="$pProv='LBS-SY'">TDWG Level 4;LBS-SY</xsl:when>
			<xsl:when test="$pProv='LBY-OO'">TDWG Level 4;LBY-OO</xsl:when>
			<xsl:when test="$pProv='LEE-AB'">TDWG Level 4;LEE-AB</xsl:when>
			<xsl:when test="$pProv='LEE-AG'">TDWG Level 4;LEE-AG</xsl:when>
			<xsl:when test="$pProv='LEE-BV'">TDWG Level 4;LEE-BV</xsl:when>
			<xsl:when test="$pProv='LEE-GU'">TDWG Level 4;LEE-GU</xsl:when>
			<xsl:when test="$pProv='LEE-MO'">TDWG Level 4;LEE-MO</xsl:when>
			<xsl:when test="$pProv='LEE-NL'">TDWG Level 4;LEE-NL</xsl:when>
			<xsl:when test="$pProv='LEE-SM'">TDWG Level 4;LEE-SM</xsl:when>
			<xsl:when test="$pProv='LEE-VI'">TDWG Level 4;LEE-VI</xsl:when>
			<xsl:when test="$pProv='LES-OO'">TDWG Level 4;LES-OO</xsl:when>
			<xsl:when test="$pProv='LOU-OO'">TDWG Level 4;LOU-OO</xsl:when>
			<xsl:when test="$pProv='MAG'">TDWG Level 3;MAG</xsl:when>
			<xsl:when test="$pProv='MAG-OO'">TDWG Level 4;MAG-OO</xsl:when>
			<xsl:when test="$pProv='MAI-OO'">TDWG Level 4;MAI-OO</xsl:when>
			<xsl:when test="$pProv='MAN-OO'">TDWG Level 4;MAN-OO</xsl:when>
			<xsl:when test="$pProv='MAS-OO'">TDWG Level 4;MAS-OO</xsl:when>
			<xsl:when test="$pProv='MAU-OO'">TDWG Level 4;MAU-OO</xsl:when>
			<xsl:when test="$pProv='MDG-OO'">TDWG Level 4;MDG-OO</xsl:when>
			<xsl:when test="$pProv='MDR-OO'">TDWG Level 4;MDR-OO</xsl:when>
			<xsl:when test="$pProv='MDV-OO'">TDWG Level 4;MDV-OO</xsl:when>
			<xsl:when test="$pProv='MIC-OO'">TDWG Level 4;MIC-OO</xsl:when>
			<xsl:when test="$pProv='MIN-OO'">TDWG Level 4;MIN-OO</xsl:when>
			<xsl:when test="$pProv='MLI-OO'">TDWG Level 4;MLI-OO</xsl:when>
			<xsl:when test="$pProv='MLW-OO'">TDWG Level 4;MLW-OO</xsl:when>
			<xsl:when test="$pProv='MLY-PM'">TDWG Level 4;MLY-PM</xsl:when>
			<xsl:when test="$pProv='MNT-OO'">TDWG Level 4;MNT-OO</xsl:when>
			<xsl:when test="$pProv='MOL-OO'">TDWG Level 4;MOL-OO</xsl:when>
			<xsl:when test="$pProv='MON'">TDWG Level 3;MON</xsl:when>
			<xsl:when test="$pProv='MON-OO'">TDWG Level 4;MON-OO</xsl:when>
			<xsl:when test="$pProv='MOR'">TDWG Level 3;MOR</xsl:when>
			<xsl:when test="$pProv='MOZ-OO'">TDWG Level 4;MOZ-OO</xsl:when>
			<xsl:when test="$pProv='MRY-OO'">TDWG Level 4;MRY-OO</xsl:when>
			<xsl:when test="$pProv='MSI-OO'">TDWG Level 4;MSI-OO</xsl:when>
			<xsl:when test="$pProv='MSO-OO'">TDWG Level 4;MSO-OO</xsl:when>
			<xsl:when test="$pProv='MTN-OO'">TDWG Level 4;MTN-OO</xsl:when>
			<xsl:when test="$pProv='MXC'">TDWG Level 3;MXC</xsl:when>
			<xsl:when test="$pProv='MXC-DF'">TDWG Level 4;MXC-DF</xsl:when>
			<xsl:when test="$pProv='MXC-ME'">TDWG Level 4;MXC-ME</xsl:when>
			<xsl:when test="$pProv='MXC-MO'">TDWG Level 4;MXC-MO</xsl:when>
			<xsl:when test="$pProv='MXC-PU'">TDWG Level 4;MXC-PU</xsl:when>
			<xsl:when test="$pProv='MXC-TL'">TDWG Level 4;MXC-TL</xsl:when>
			<xsl:when test="$pProv='MXE-AG'">TDWG Level 4;MXE-AG</xsl:when>
			<xsl:when test="$pProv='MXE-CO'">TDWG Level 4;MXE-CO</xsl:when>
			<xsl:when test="$pProv='MXE-CU'">TDWG Level 4;MXE-CU</xsl:when>
			<xsl:when test="$pProv='MXE-DU'">TDWG Level 4;MXE-DU</xsl:when>
			<xsl:when test="$pProv='MXE-GU'">TDWG Level 4;MXE-GU</xsl:when>
			<xsl:when test="$pProv='MXE-HI'">TDWG Level 4;MXE-HI</xsl:when>
			<xsl:when test="$pProv='MXE-NL'">TDWG Level 4;MXE-NL</xsl:when>
			<xsl:when test="$pProv='MXE-QU'">TDWG Level 4;MXE-QU</xsl:when>
			<xsl:when test="$pProv='MXE-SL'">TDWG Level 4;MXE-SL</xsl:when>
			<xsl:when test="$pProv='MXE-TA'">TDWG Level 4;MXE-TA</xsl:when>
			<xsl:when test="$pProv='MXE-ZA'">TDWG Level 4;MXE-ZA</xsl:when>
			<xsl:when test="$pProv='MXG-VC'">TDWG Level 4;MXG-VC</xsl:when>
			<xsl:when test="$pProv='MXI-GU'">TDWG Level 4;MXI-GU</xsl:when>
			<xsl:when test="$pProv='MXN-BC'">TDWG Level 4;MXN-BC</xsl:when>
			<xsl:when test="$pProv='MXN-BS'">TDWG Level 4;MXN-BS</xsl:when>
			<xsl:when test="$pProv='MXN-SI'">TDWG Level 4;MXN-SI</xsl:when>
			<xsl:when test="$pProv='MXN-SO'">TDWG Level 4;MXN-SO</xsl:when>
			<xsl:when test="$pProv='MXS-CL'">TDWG Level 4;MXS-CL</xsl:when>
			<xsl:when test="$pProv='MXS-GR'">TDWG Level 4;MXS-GR</xsl:when>
			<xsl:when test="$pProv='MXS-JA'">TDWG Level 4;MXS-JA</xsl:when>
			<xsl:when test="$pProv='MXS-MI'">TDWG Level 4;MXS-MI</xsl:when>
			<xsl:when test="$pProv='MXS-NA'">TDWG Level 4;MXS-NA</xsl:when>
			<xsl:when test="$pProv='MXS-OA'">TDWG Level 4;MXS-OA</xsl:when>
			<xsl:when test="$pProv='MXT-CA'">TDWG Level 4;MXT-CA</xsl:when>
			<xsl:when test="$pProv='MXT-CI'">TDWG Level 4;MXT-CI</xsl:when>
			<xsl:when test="$pProv='MXT-QR'">TDWG Level 4;MXT-QR</xsl:when>
			<xsl:when test="$pProv='MXT-YU'">TDWG Level 4;MXT-YU</xsl:when>
			<xsl:when test="$pProv='MYA-OO'">TDWG Level 4;MYA-OO</xsl:when>
			<xsl:when test="$pProv='NAM-OO'">TDWG Level 4;NAM-OO</xsl:when>
			<xsl:when test="$pProv='NAT-OO'">TDWG Level 4;NAT-OO</xsl:when>
			<xsl:when test="$pProv='NBR-OO'">TDWG Level 4;NBR-OO</xsl:when>
			<xsl:when test="$pProv='NCA-OO'">TDWG Level 4;NCA-OO</xsl:when>
			<xsl:when test="$pProv='NCS'">TDWG Level 3;NCS</xsl:when>
			<xsl:when test="$pProv='NCS-DA'">TDWG Level 4;NCS-DA</xsl:when>
			<xsl:when test="$pProv='NDA-OO'">TDWG Level 4;NDA-OO</xsl:when>
			<xsl:when test="$pProv='NEB-OO'">TDWG Level 4;NEB-OO</xsl:when>
			<xsl:when test="$pProv='NEP-OO'">TDWG Level 4;NEP-OO</xsl:when>
			<xsl:when test="$pProv='NET-OO'">TDWG Level 4;NET-OO</xsl:when>
			<xsl:when test="$pProv='NEV-OO'">TDWG Level 4;NEV-OO</xsl:when>
			<xsl:when test="$pProv='NFL-NE'">TDWG Level 4;NFL-NE</xsl:when>
			<xsl:when test="$pProv='NFL-SP'">TDWG Level 4;NFL-SP</xsl:when>
			<xsl:when test="$pProv='NGA-OO'">TDWG Level 4;NGA-OO</xsl:when>
			<xsl:when test="$pProv='NGR-OO'">TDWG Level 4;NGR-OO</xsl:when>
			<xsl:when test="$pProv='NLA-CU'">TDWG Level 4;NLA-CU</xsl:when>
			<xsl:when test="$pProv='NNS-OO'">TDWG Level 4;NNS-OO</xsl:when>
			<xsl:when test="$pProv='NOR-OO'">TDWG Level 4;NOR-OO</xsl:when>
			<xsl:when test="$pProv='NSC-OO'">TDWG Level 4;NSC-OO</xsl:when>
			<xsl:when test="$pProv='NSW-CT'">TDWG Level 4;NSW-CT</xsl:when>
			<xsl:when test="$pProv='NSW-NS'">TDWG Level 4;NSW-NS</xsl:when>
			<xsl:when test="$pProv='NTA-OO'">TDWG Level 4;NTA-OO</xsl:when>
			<xsl:when test="$pProv='NUN-OO'">TDWG Level 4;NUN-OO</xsl:when>
			<xsl:when test="$pProv='NWC-OO'">TDWG Level 4;NWC-OO</xsl:when>
			<xsl:when test="$pProv='NWG-IJ'">TDWG Level 4;NWG-IJ</xsl:when>
			<xsl:when test="$pProv='NWG-PN'">TDWG Level 4;NWG-PN</xsl:when>
			<xsl:when test="$pProv='NWH-OO'">TDWG Level 4;NWH-OO</xsl:when>
			<xsl:when test="$pProv='NWJ-OO'">TDWG Level 4;NWJ-OO</xsl:when>
			<xsl:when test="$pProv='NWM-OO'">TDWG Level 4;NWM-OO</xsl:when>
			<xsl:when test="$pProv='NWT-OO'">TDWG Level 4;NWT-OO</xsl:when>
			<xsl:when test="$pProv='NWY-OO'">TDWG Level 4;NWY-OO</xsl:when>
			<xsl:when test="$pProv='NZN-OO'">TDWG Level 4;NZN-OO</xsl:when>
			<xsl:when test="$pProv='NZS-OO'">TDWG Level 4;NZS-OO</xsl:when>
			<xsl:when test="$pProv='OFS-OO'">TDWG Level 4;OFS-OO</xsl:when>
			<xsl:when test="$pProv='OGA-OO'">TDWG Level 4;OGA-OO</xsl:when>
			<xsl:when test="$pProv='OHI-OO'">TDWG Level 4;OHI-OO</xsl:when>
			<xsl:when test="$pProv='OKL-OO'">TDWG Level 4;OKL-OO</xsl:when>
			<xsl:when test="$pProv='OMA-OO'">TDWG Level 4;OMA-OO</xsl:when>
			<xsl:when test="$pProv='ONT-OO'">TDWG Level 4;ONT-OO</xsl:when>
			<xsl:when test="$pProv='ORE-OO'">TDWG Level 4;ORE-OO</xsl:when>
			<xsl:when test="$pProv='PAK'">TDWG Level 3;PAK</xsl:when>
			<xsl:when test="$pProv='PAK-OO'">TDWG Level 4;PAK-OO</xsl:when>
			<xsl:when test="$pProv='PAL'">TDWG Level 3;PAL</xsl:when>
			<xsl:when test="$pProv='PAL-IS'">TDWG Level 4;PAL-IS</xsl:when>
			<xsl:when test="$pProv='PAL-JO'">TDWG Level 4;PAL-JO</xsl:when>
			<xsl:when test="$pProv='PAN-OO'">TDWG Level 4;PAN-OO</xsl:when>
			<xsl:when test="$pProv='PAR-OO'">TDWG Level 4;PAR-OO</xsl:when>
			<xsl:when test="$pProv='PEI-OO'">TDWG Level 4;PEI-OO</xsl:when>
			<xsl:when test="$pProv='PEN-OO'">TDWG Level 4;PEN-OO</xsl:when>
			<xsl:when test="$pProv='PER'">TDWG Level 3;PER</xsl:when>
			<xsl:when test="$pProv='PER-OO'">TDWG Level 4;PER-OO</xsl:when>
			<xsl:when test="$pProv='PHI-OO'">TDWG Level 4;PHI-OO</xsl:when>
			<xsl:when test="$pProv='POL-OO'">TDWG Level 4;POL-OO</xsl:when>
			<xsl:when test="$pProv='POR-OO'">TDWG Level 4;POR-OO</xsl:when>
			<xsl:when test="$pProv='PRM'">TDWG Level 3;PRM</xsl:when>
			<xsl:when test="$pProv='PRM-OO'">TDWG Level 4;PRM-OO</xsl:when>
			<xsl:when test="$pProv='PUE-OO'">TDWG Level 4;PUE-OO</xsl:when>
			<xsl:when test="$pProv='QLD-QU'">TDWG Level 4;QLD-QU</xsl:when>
			<xsl:when test="$pProv='QUE-OO'">TDWG Level 4;QUE-OO</xsl:when>
			<xsl:when test="$pProv='REU-OO'">TDWG Level 4;REU-OO</xsl:when>
			<xsl:when test="$pProv='RHO'">TDWG Level 3;RHO</xsl:when>
			<xsl:when test="$pProv='RHO-OO'">TDWG Level 4;RHO-OO</xsl:when>
			<xsl:when test="$pProv='ROD-OO'">TDWG Level 4;ROD-OO</xsl:when>
			<xsl:when test="$pProv='ROM-OO'">TDWG Level 4;ROM-OO</xsl:when>
			<xsl:when test="$pProv='RUC-OO'">TDWG Level 4;RUC-OO</xsl:when>
			<xsl:when test="$pProv='RUE-OO'">TDWG Level 4;RUE-OO</xsl:when>
			<xsl:when test="$pProv='RUN-OO'">TDWG Level 4;RUN-OO</xsl:when>
			<xsl:when test="$pProv='RUS-OO'">TDWG Level 4;RUS-OO</xsl:when>
			<xsl:when test="$pProv='RUW-OO'">TDWG Level 4;RUW-OO</xsl:when>
			<xsl:when test="$pProv='RWA-OO'">TDWG Level 4;RWA-OO</xsl:when>
			<xsl:when test="$pProv='SAK'">TDWG Level 3;SAK</xsl:when>
			<xsl:when test="$pProv='SAK-OO'">TDWG Level 4;SAK-OO</xsl:when>
			<xsl:when test="$pProv='SAR-OO'">TDWG Level 4;SAR-OO</xsl:when>
			<xsl:when test="$pProv='SAS-OO'">TDWG Level 4;SAS-OO</xsl:when>
			<xsl:when test="$pProv='SAU-OO'">TDWG Level 4;SAU-OO</xsl:when>
			<xsl:when test="$pProv='SCA-OO'">TDWG Level 4;SCA-OO</xsl:when>
			<xsl:when test="$pProv='SDA-OO'">TDWG Level 4;SDA-OO</xsl:when>
			<xsl:when test="$pProv='SEL-OO'">TDWG Level 4;SEL-OO</xsl:when>
			<xsl:when test="$pProv='SEN-OO'">TDWG Level 4;SEN-OO</xsl:when>
			<xsl:when test="$pProv='SEY-OO'">TDWG Level 4;SEY-OO</xsl:when>
			<xsl:when test="$pProv='SIC'">TDWG Level 3;SIC</xsl:when>
			<xsl:when test="$pProv='SIC-MA'">TDWG Level 4;SIC-MA</xsl:when>
			<xsl:when test="$pProv='SIC-SI'">TDWG Level 4;SIC-SI</xsl:when>
			<xsl:when test="$pProv='SIE-OO'">TDWG Level 4;SIE-OO</xsl:when>
			<xsl:when test="$pProv='SIN-OO'">TDWG Level 4;SIN-OO</xsl:when>
			<xsl:when test="$pProv='SOA-OO'">TDWG Level 4;SOA-OO</xsl:when>
			<xsl:when test="$pProv='SOC-OO'">TDWG Level 4;SOC-OO</xsl:when>
			<xsl:when test="$pProv='SOM-OO'">TDWG Level 4;SOM-OO</xsl:when>
			<xsl:when test="$pProv='SPA'">TDWG Level 3;SPA</xsl:when>
			<xsl:when test="$pProv='SPA-AN'">TDWG Level 4;SPA-AN</xsl:when>
			<xsl:when test="$pProv='SPA-GI'">TDWG Level 4;SPA-GI</xsl:when>
			<xsl:when test="$pProv='SPA-SP'">TDWG Level 4;SPA-SP</xsl:when>
			<xsl:when test="$pProv='SRL-OO'">TDWG Level 4;SRL-OO</xsl:when>
			<xsl:when test="$pProv='STH-OO'">TDWG Level 4;STH-OO</xsl:when>
			<xsl:when test="$pProv='SUD-OO'">TDWG Level 4;SUD-OO</xsl:when>
			<xsl:when test="$pProv='SUL-OO'">TDWG Level 4;SUL-OO</xsl:when>
			<xsl:when test="$pProv='SUM-OO'">TDWG Level 4;SUM-OO</xsl:when>
			<xsl:when test="$pProv='SVA-OO'">TDWG Level 4;SVA-OO</xsl:when>
			<xsl:when test="$pProv='SWE-OO'">TDWG Level 4;SWE-OO</xsl:when>
			<xsl:when test="$pProv='SWI-OO'">TDWG Level 4;SWI-OO</xsl:when>
			<xsl:when test="$pProv='SWZ-OO'">TDWG Level 4;SWZ-OO</xsl:when>
			<xsl:when test="$pProv='TAI'">TDWG Level 3;TAI</xsl:when>
			<xsl:when test="$pProv='TAI-OO'">TDWG Level 4;TAI-OO</xsl:when>
			<xsl:when test="$pProv='TAN-OO'">TDWG Level 4;TAN-OO</xsl:when>
			<xsl:when test="$pProv='TAS-OO'">TDWG Level 4;TAS-OO</xsl:when>
			<xsl:when test="$pProv='TCI-OO'">TDWG Level 4;TCI-OO</xsl:when>
			<xsl:when test="$pProv='TCS-AB'">TDWG Level 4;TCS-AB</xsl:when>
			<xsl:when test="$pProv='TCS-AD'">TDWG Level 4;TCS-AD</xsl:when>
			<xsl:when test="$pProv='TCS-AR'">TDWG Level 4;TCS-AR</xsl:when>
			<xsl:when test="$pProv='TCS-AZ'">TDWG Level 4;TCS-AZ</xsl:when>
			<xsl:when test="$pProv='TCS-GR'">TDWG Level 4;TCS-GR</xsl:when>
			<xsl:when test="$pProv='TCS-NA'">TDWG Level 4;TCS-NA</xsl:when>
			<xsl:when test="$pProv='TEN-OO'">TDWG Level 4;TEN-OO</xsl:when>
			<xsl:when test="$pProv='TEX-OO'">TDWG Level 4;TEX-OO</xsl:when>
			<xsl:when test="$pProv='THA'">TDWG Level 3;THA</xsl:when>
			<xsl:when test="$pProv='THA-OO'">TDWG Level 4;THA-OO</xsl:when>
			<xsl:when test="$pProv='TKM'">TDWG Level 3;TKM</xsl:when>
			<xsl:when test="$pProv='TKM-OO'">TDWG Level 4;TKM-OO</xsl:when>
			<xsl:when test="$pProv='TOG-OO'">TDWG Level 4;TOG-OO</xsl:when>
			<xsl:when test="$pProv='TRT-OO'">TDWG Level 4;TRT-OO</xsl:when>
			<xsl:when test="$pProv='TUE-OO'">TDWG Level 4;TUE-OO</xsl:when>
			<xsl:when test="$pProv='TUN-OO'">TDWG Level 4;TUN-OO</xsl:when>
			<xsl:when test="$pProv='TUR-OO'">TDWG Level 4;TUR-OO</xsl:when>
			<xsl:when test="$pProv='TVA-OO'">TDWG Level 4;TVA-OO</xsl:when>
			<xsl:when test="$pProv='TVL-GA'">TDWG Level 4;TVL-GA</xsl:when>
			<xsl:when test="$pProv='TVL-MP'">TDWG Level 4;TVL-MP</xsl:when>
			<xsl:when test="$pProv='TVL-NP'">TDWG Level 4;TVL-NP</xsl:when>
			<xsl:when test="$pProv='TVL-NW'">TDWG Level 4;TVL-NW</xsl:when>
			<xsl:when test="$pProv='TZK'">TDWG Level 3;TZK</xsl:when>
			<xsl:when test="$pProv='TZK-OO'">TDWG Level 4;TZK-OO</xsl:when>
			<xsl:when test="$pProv='UGA-OO'">TDWG Level 4;UGA-OO</xsl:when>
			<xsl:when test="$pProv='UKR-MO'">TDWG Level 4;UKR-MO</xsl:when>
			<xsl:when test="$pProv='UKR-UK'">TDWG Level 4;UKR-UK</xsl:when>
			<xsl:when test="$pProv='URU'">TDWG Level 3;URU</xsl:when>
			<xsl:when test="$pProv='URU-OO'">TDWG Level 4;URU-OO</xsl:when>
			<xsl:when test="$pProv='UTA-OO'">TDWG Level 4;UTA-OO</xsl:when>
			<xsl:when test="$pProv='UZB'">TDWG Level 3;UZB</xsl:when>
			<xsl:when test="$pProv='UZB-OO'">TDWG Level 4;UZB-OO</xsl:when>
			<xsl:when test="$pProv='VEN-OO'">TDWG Level 4;VEN-OO</xsl:when>
			<xsl:when test="$pProv='VER-OO'">TDWG Level 4;VER-OO</xsl:when>
			<xsl:when test="$pProv='VIC-OO'">TDWG Level 4;VIC-OO</xsl:when>
			<xsl:when test="$pProv='VIE-OO'">TDWG Level 4;VIE-OO</xsl:when>
			<xsl:when test="$pProv='VNA-OO'">TDWG Level 4;VNA-OO</xsl:when>
			<xsl:when test="$pProv='VRG-OO'">TDWG Level 4;VRG-OO</xsl:when>
			<xsl:when test="$pProv='WAS-OO'">TDWG Level 4;WAS-OO</xsl:when>
			<xsl:when test="$pProv='WAU-AC'">TDWG Level 4;WAU-AC</xsl:when>
			<xsl:when test="$pProv='WAU-WA'">TDWG Level 4;WAU-WA</xsl:when>
			<xsl:when test="$pProv='WDC-OO'">TDWG Level 4;WDC-OO</xsl:when>
			<xsl:when test="$pProv='WHM-HP'">TDWG Level 4;WHM-HP</xsl:when>
			<xsl:when test="$pProv='WHM-JK'">TDWG Level 4;WHM-JK</xsl:when>
			<xsl:when test="$pProv='WHM-UT'">TDWG Level 4;WHM-UT</xsl:when>
			<xsl:when test="$pProv='WIN-BA'">TDWG Level 4;WIN-BA</xsl:when>
			<xsl:when test="$pProv='WIN-DO'">TDWG Level 4;WIN-DO</xsl:when>
			<xsl:when test="$pProv='WIN-GR'">TDWG Level 4;WIN-GR</xsl:when>
			<xsl:when test="$pProv='WIN-MA'">TDWG Level 4;WIN-MA</xsl:when>
			<xsl:when test="$pProv='WIN-SL'">TDWG Level 4;WIN-SL</xsl:when>
			<xsl:when test="$pProv='WIN-SV'">TDWG Level 4;WIN-SV</xsl:when>
			<xsl:when test="$pProv='WIS-OO'">TDWG Level 4;WIS-OO</xsl:when>
			<xsl:when test="$pProv='WSA'">TDWG Level 3;WSA</xsl:when>
			<xsl:when test="$pProv='WSA-OO'">TDWG Level 4;WSA-OO</xsl:when>
			<xsl:when test="$pProv='WSB-OO'">TDWG Level 4;WSB-OO</xsl:when>
			<xsl:when test="$pProv='WVA-OO'">TDWG Level 4;WVA-OO</xsl:when>
			<xsl:when test="$pProv='WYO-OO'">TDWG Level 4;WYO-OO</xsl:when>
			<xsl:when test="$pProv='YAK-OO'">TDWG Level 4;YAK-OO</xsl:when>
			<xsl:when test="$pProv='YEM-NY'">TDWG Level 4;YEM-NY</xsl:when>
			<xsl:when test="$pProv='YEM-SY'">TDWG Level 4;YEM-SY</xsl:when>
			<xsl:when test="$pProv='YUG-BH'">TDWG Level 4;YUG-BH</xsl:when>
			<xsl:when test="$pProv='YUG-CR'">TDWG Level 4;YUG-CR</xsl:when>
			<xsl:when test="$pProv='YUG-MA'">TDWG Level 4;YUG-MA</xsl:when>
			<xsl:when test="$pProv='YUG-MN'">TDWG Level 4;YUG-MN</xsl:when>
			<xsl:when test="$pProv='YUG-SE'">TDWG Level 4;YUG-SE</xsl:when>
			<xsl:when test="$pProv='YUG-SL'">TDWG Level 4;YUG-SL</xsl:when>
			<xsl:when test="$pProv='YUK-OO'">TDWG Level 4;YUK-OO</xsl:when>
			<xsl:when test="$pProv='ZAI-OO'">TDWG Level 4;ZAI-OO</xsl:when>
			<xsl:when test="$pProv='ZAM-OO'">TDWG Level 4;ZAM-OO</xsl:when>
			<xsl:when test="$pProv='ZIM-OO'">TDWG Level 4;ZIM-OO</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>

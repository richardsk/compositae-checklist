<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml EuroMed_Sample.xml?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<Distributions>
			<xsl:for-each select="//Occurrence">
				<xsl:variable name="vResult">
					<xsl:call-template name="conBiostatus">
						<xsl:with-param name="pProv" select="Status"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="vRegion">
					<xsl:call-template name="conRegion">
						<xsl:with-param name="pProv" select="AreaCode"/>
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
			<xsl:when test="$pProv='cultivated: C'">Present;Cultivated</xsl:when>
			<xsl:when test="$pProv='introduced: F'">Recorded in error;Exotic</xsl:when>
			<xsl:when test="$pProv='introduced: I(A)'">Sometimes present;Exotic</xsl:when>
			<xsl:when test="$pProv='native: D'">Uncertain;Indigenous</xsl:when>
			<xsl:when test="$pProv='native: E'">Extinct;Indigenous</xsl:when>
			<xsl:when test="$pProv='introduced: D'">Uncertain;Exotic</xsl:when>
			<xsl:when test="$pProv='introduced: I'">Present;Exotic</xsl:when>
			<xsl:when test="$pProv='introduced: I(N)'">Present in wild;Exotic</xsl:when>
			<xsl:when test="$pProv='introduced: Q'">Uncertain;Exotic</xsl:when>
			<xsl:when test="$pProv='native: F'">Recorded in error;Indigenous</xsl:when>
			<xsl:when test="$pProv='native: N'">Present in wild;Indigenous</xsl:when>
			<xsl:when test="$pProv='native: Q'">Uncertain;Exotic</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="conRegion">
		<xsl:param name="pProv"/>
		<xsl:choose>
			<xsl:when test="$pProv='Bt'">TDWG Level 4;BLT-ES;TDWG Level 4;BLT-KA;TDWG Level 4;BLT-LA;TDWG Level 4;BLT-LI</xsl:when>
			<xsl:when test="$pProv='Cc'">TDWG Level 4;TCS-AZ;TDWG Level 4;TCS-NA;TDWG Level 4;TCS-AR;TDWG Level 4;GEO-OO</xsl:when>
			<xsl:when test="$pProv='Ga'">TDWG Level 4;FRA-FR;TDWG Level 4;FRA-CI;TDWG Level 4;FRA-MO</xsl:when>
			<xsl:when test="$pProv='It'">TDWG Level 4;ITA-IT;TDWG Level 4;ITA-SM;TDWG Level 4;ITA-VC</xsl:when>
			<xsl:when test="$pProv='Hs'">TDWG Level 4;SPA-SP;TDWG Level 4;SPA-AN;TDWG Level 4;SPA-GI</xsl:when>
			<xsl:when test="$pProv='Au'">TDWG Level 4;AUT-AU;TDWG Level 4;AUT-LI</xsl:when>
			<xsl:when test="$pProv='Be'">TDWG Level 4;BGM-BE;TDWG Level 4;BGM-LU</xsl:when>
			<xsl:when test="$pProv='Ga(F)'">TDWG Level 4;FRA-FR;TDWG Level 4;FRA-MO</xsl:when>
			<xsl:when test="$pProv='Hb'">TDWG Level 4;IRE-IR;TDWG Level 4;IRE-NI</xsl:when>
			<xsl:when test="$pProv='LS'">TDWG Level 4;LBS-LB;TDWG Level 4;LBS-SY</xsl:when>
			<xsl:when test="$pProv='IJ'">TDWG Level 4;PAL-IS;TDWG Level 4;PAL-JO</xsl:when>
			<xsl:when test="$pProv='Si'">TDWG Level 4;SIC-SI;TDWG Level 4;SIC-MA</xsl:when>
			<xsl:when test="$pProv='Ab'">TDWG Level 4;TCS-AZ;TDWG Level 4;TCS-NA</xsl:when>
			<xsl:when test="$pProv='Ab(A)'">TDWG Level 4;TCS-AZ</xsl:when>
			<xsl:when test="$pProv='Ab(N)'">TDWG Level 4;TCS-NA</xsl:when>
			<xsl:when test="$pProv='AE'">TDWG Level 4;EAI-OO</xsl:when>
			<xsl:when test="$pProv='AE(G)'">TDWG Level 4;EAI-OO</xsl:when>
			<xsl:when test="$pProv='AE(T)'">TDWG Level 4;TUR-OO</xsl:when>
			<xsl:when test="$pProv='Ag'">TDWG Level 4;ALG-OO</xsl:when>
			<xsl:when test="$pProv='Al'">TDWG Level 4;ALB-OO</xsl:when>
			<xsl:when test="$pProv='Ar'">TDWG Level 4;TCS-AR</xsl:when>
			<xsl:when test="$pProv='Au(A)'">TDWG Level 4;AUT-AU</xsl:when>
			<xsl:when test="$pProv='Au(L)'">TDWG Level 4;AUT-LI</xsl:when>
			<xsl:when test="$pProv='Az'">TDWG Level 4;AZO-OO</xsl:when>
			<xsl:when test="$pProv='Az(C)'">TDWG Level 4;AZO-OO</xsl:when>
			<xsl:when test="$pProv='Az(F)'">TDWG Level 4;AZO-OO</xsl:when>
			<xsl:when test="$pProv='Az(G)'">TDWG Level 4;AZO-OO</xsl:when>
			<xsl:when test="$pProv='Az(J)'">TDWG Level 4;AZO-OO</xsl:when>
			<xsl:when test="$pProv='Az(L)'">TDWG Level 4;AZO-OO</xsl:when>
			<xsl:when test="$pProv='Az(M)'">TDWG Level 4;AZO-OO</xsl:when>
			<xsl:when test="$pProv='Az(P)'">TDWG Level 4;AZO-OO</xsl:when>
			<xsl:when test="$pProv='Az(S)'">TDWG Level 4;AZO-OO</xsl:when>
			<xsl:when test="$pProv='Az(T)'">TDWG Level 4;AZO-OO</xsl:when>
			<xsl:when test="$pProv='Be(B)'">TDWG Level 4;BGM-BE</xsl:when>
			<xsl:when test="$pProv='Be(L)'">TDWG Level 4;BGM-LU</xsl:when>
			<xsl:when test="$pProv='BH'">TDWG Level 4;YUG-BH</xsl:when>
			<xsl:when test="$pProv='Bl'">TDWG Level 4;BAL-OO</xsl:when>
			<xsl:when test="$pProv='Bl(I)'">TDWG Level 4;BAL-OO</xsl:when>
			<xsl:when test="$pProv='Bl(M)'">TDWG Level 4;BAL-OO</xsl:when>
			<xsl:when test="$pProv='Bl(N)'">TDWG Level 4;BAL-OO</xsl:when>
			<xsl:when test="$pProv='Br'">TDWG Level 4;GRB-OO</xsl:when>
			<xsl:when test="$pProv='Bu'">TDWG Level 4;BUL-OO</xsl:when>
			<xsl:when test="$pProv='By'">TDWG Level 4;BLR-OO</xsl:when>
			<xsl:when test="$pProv='Ca'">TDWG Level 4;CNY-OO</xsl:when>
			<xsl:when test="$pProv='Ca(C)'">TDWG Level 4;CNY-OO</xsl:when>
			<xsl:when test="$pProv='Ca(F)'">TDWG Level 4;CNY-OO</xsl:when>
			<xsl:when test="$pProv='Ca(G)'">TDWG Level 4;CNY-OO</xsl:when>
			<xsl:when test="$pProv='Ca(H)'">TDWG Level 4;CNY-OO</xsl:when>
			<xsl:when test="$pProv='Ca(L)'">TDWG Level 4;CNY-OO</xsl:when>
			<xsl:when test="$pProv='Ca(P)'">TDWG Level 4;CNY-OO</xsl:when>
			<xsl:when test="$pProv='Ca(T)'">TDWG Level 4;CNY-OO</xsl:when>
			<xsl:when test="$pProv='Cg'">TDWG Level 4;YUG-MN</xsl:when>
			<xsl:when test="$pProv='Co'">TDWG Level 4;COR-OO</xsl:when>
			<xsl:when test="$pProv='Cr'">TDWG Level 4;KRI-OO</xsl:when>
			<xsl:when test="$pProv='Cs'">TDWG Level 4;CZE-CZ</xsl:when>
			<xsl:when test="$pProv='Ct'">TDWG Level 4;YUG-CR</xsl:when>
			<xsl:when test="$pProv='Cy'">TDWG Level 4;CYP-OO</xsl:when>
			<xsl:when test="$pProv='Da'">TDWG Level 4;DEN-OO</xsl:when>
			<xsl:when test="$pProv='Eg'">TDWG Level 4;EGY-OO</xsl:when>
			<xsl:when test="$pProv='Es'">TDWG Level 4;BLT-ES</xsl:when>
			<xsl:when test="$pProv='Fa'">TDWG Level 4;FOR-OO</xsl:when>
			<xsl:when test="$pProv='Fe'">TDWG Level 4;FIN-OO</xsl:when>
			<xsl:when test="$pProv='Ga(C)'">TDWG Level 4;FRA-CI</xsl:when>
			<xsl:when test="$pProv='Ge'">TDWG Level 4;GER-OO</xsl:when>
			<xsl:when test="$pProv='Gg'">TDWG Level 4;GEO-OO</xsl:when>
			<xsl:when test="$pProv='Gr'">TDWG Level 4;GRC-OO</xsl:when>
			<xsl:when test="$pProv='Hb(E)'">TDWG Level 4;IRE-IR</xsl:when>
			<xsl:when test="$pProv='Hb(N)'">TDWG Level 4;IRE-NI</xsl:when>
			<xsl:when test="$pProv='He'">TDWG Level 4;SWI-OO</xsl:when>
			<xsl:when test="$pProv='Hs(A)'">TDWG Level 4;SPA-AN</xsl:when>
			<xsl:when test="$pProv='Hs(G)'">TDWG Level 4;SPA-GI</xsl:when>
			<xsl:when test="$pProv='Hs(S)'">TDWG Level 4;SPA-SP</xsl:when>
			<xsl:when test="$pProv='Ho'">TDWG Level 4;NET-OO</xsl:when>
			<xsl:when test="$pProv='Hu'">TDWG Level 4;HUN-OO</xsl:when>
			<xsl:when test="$pProv='Ir'">TDWG Level 4;PAL-IS</xsl:when>
			<xsl:when test="$pProv='Is'">TDWG Level 4;ICE-OO</xsl:when>
			<xsl:when test="$pProv='Jo'">TDWG Level 4;PAL-JO</xsl:when>
			<xsl:when test="$pProv='La'">TDWG Level 4;BLT-LA</xsl:when>
			<xsl:when test="$pProv='Le'">TDWG Level 4;LBS-LB</xsl:when>
			<xsl:when test="$pProv='Li'">TDWG Level 4;LBY-OO</xsl:when>
			<xsl:when test="$pProv='Lt'">TDWG Level 4;BLT-LI</xsl:when>
			<xsl:when test="$pProv='Lu'">TDWG Level 4;POR-OO</xsl:when>
			<xsl:when test="$pProv='Ma'">TDWG Level 3;MOR</xsl:when>
			<xsl:when test="$pProv='Mk'">TDWG Level 4;YUG-MA</xsl:when>
			<xsl:when test="$pProv='Md'">TDWG Level 4;MDR-OO</xsl:when>
			<xsl:when test="$pProv='Md(D)'">TDWG Level 4;MDR-OO</xsl:when>
			<xsl:when test="$pProv='Md(M)'">TDWG Level 4;MDR-OO</xsl:when>
			<xsl:when test="$pProv='Md(P)'">TDWG Level 4;MDR-OO</xsl:when>
			<xsl:when test="$pProv='Mo'">TDWG Level 4;UKR-MO</xsl:when>
			<xsl:when test="$pProv='No'">TDWG Level 4;NOR-OO</xsl:when>
			<xsl:when test="$pProv='Po'">TDWG Level 4;POL-OO</xsl:when>
			<xsl:when test="$pProv='Rf'">TDWG Level 2;14</xsl:when>
			<xsl:when test="$pProv='Rf(A):'">TDWG Level 4;WSB-OO</xsl:when>
			<xsl:when test="$pProv='Rf(C):'">TDWG Level 4;RUC-OO</xsl:when>
			<xsl:when test="$pProv='Rf(CS):'">TDWG Level 4;NCS</xsl:when>
			<xsl:when test="$pProv='Rf(E):'">TDWG Level 4;RUE-OO</xsl:when>
			<xsl:when test="$pProv='Rf(K):'">TDWG Level 4;BLT-KA</xsl:when>
			<xsl:when test="$pProv='Rf(N):N.'">TDWG Level 4;RUN-OO</xsl:when>
			<xsl:when test="$pProv='Rf(NW):'">TDWG Level 4;RUW-OO</xsl:when>
			<xsl:when test="$pProv='Rf(S):'">TDWG Level 4;RUS-OO</xsl:when>
			<xsl:when test="$pProv='Rm'">TDWG Level 4;ROM-OO</xsl:when>
			<xsl:when test="$pProv='Sa'">TDWG Level 4;SAR-OO</xsl:when>
			<xsl:when test="$pProv='Sb'">TDWG Level 4;SVA-OO</xsl:when>
			<xsl:when test="$pProv='Sg'">TDWG Level 4;SEL-OO</xsl:when>
			<xsl:when test="$pProv='Si(M)'">TDWG Level 4;SIC-MA</xsl:when>
			<xsl:when test="$pProv='Si(S)'">TDWG Level 4;SIC-SI</xsl:when>
			<xsl:when test="$pProv='Sk'">TDWG Level 4;CZE-SL</xsl:when>
			<xsl:when test="$pProv='Sl'">TDWG Level 4;YUG-SL</xsl:when>
			<xsl:when test="$pProv='Sn'">TDWG Level 4;SIN-OO</xsl:when>
			<xsl:when test="$pProv='Sr'">TDWG Level 4;YUG-SE</xsl:when>
			<xsl:when test="$pProv='Su'">TDWG Level 4;SWE-OO</xsl:when>
			<xsl:when test="$pProv='Sy'">TDWG Level 4;LBS-SY</xsl:when>
			<xsl:when test="$pProv='Tn'">TDWG Level 4;TUN-OO</xsl:when>
			<xsl:when test="$pProv='Tu'">TDWG Level 4;TUR-OO</xsl:when>
			<xsl:when test="$pProv='Tu(A)'">TDWG Level 4;TUR-OO</xsl:when>
			<xsl:when test="$pProv='Tu(E)'">TDWG Level 4;TUE-OO</xsl:when>
			<xsl:when test="$pProv='Uk'">TDWG Level 4;UKR-UK</xsl:when>
			<xsl:when test="$pProv='Uk(K)'">TDWG Level 4;KRY-OO</xsl:when>
			<xsl:when test="$pProv='Uk(U)'">TDWG Level 4;UKR-UK</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>

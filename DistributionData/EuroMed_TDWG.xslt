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
			<xsl:when test="$pProv='cultivated: C'">Present in cultivation;</xsl:when>
			<xsl:when test="$pProv='introduced: F'">Recorded in error;Exotic</xsl:when>
			<xsl:when test="$pProv='introduced: I(A)'">Sometimes present;Exotic</xsl:when>
			<xsl:when test="$pProv='native: D'">Present in wild;</xsl:when>
			<xsl:when test="$pProv='native: E'"/>
			<xsl:when test="$pProv='introduced: D'"/>
			<xsl:when test="$pProv='introduced: I'">Present;Exotic</xsl:when>
			<xsl:when test="$pProv='introduced: I(N)'">Present in wild;Exotic</xsl:when>
			<xsl:when test="$pProv='introduced: Q'"/>
			<xsl:when test="$pProv='native: F'"/>
			<xsl:when test="$pProv='native: N'"/>
			<xsl:when test="$pProv='native: Q'"/>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="conRegion">
		<xsl:param name="pProv"/>
		<xsl:choose>
			<xsl:when test="$pProv='Ab'">TDWG Level 3;TCS</xsl:when>
			<xsl:when test="$pProv='AE(G)'"/>
			<xsl:when test="$pProv='Ag'"/>
			<xsl:when test="$pProv='Ar'"/>
			<xsl:when test="$pProv='Au'"/>
			<xsl:when test="$pProv='Au(A)'"/>
			<xsl:when test="$pProv='Az'"/>
			<xsl:when test="$pProv='Az(C)'"/>
			<xsl:when test="$pProv='Az(P)'"/>
			<xsl:when test="$pProv='Be(B)'"/>
			<xsl:when test="$pProv='BH'"/>
			<xsl:when test="$pProv='Bl'"/>
			<xsl:when test="$pProv='Bl(I)'"/>
			<xsl:when test="$pProv='Bl(M)'"/>
			<xsl:when test="$pProv='Br'">TDWG Level 4;GRB-OO</xsl:when>
			<xsl:when test="$pProv='Bt'">TDWG Level 4;BLT-ES;TDWG Level 4;BLT-KA;TDWG Level 4;BLT-LA;TDWG Level 4;BLT-LI</xsl:when>
			<xsl:when test="$pProv='Ca'"/>
			<xsl:when test="$pProv='Ca(C)'"/>
			<xsl:when test="$pProv='Ca(L)'"/>
			<xsl:when test="$pProv='Cg'"/>
			<xsl:when test="$pProv='Co'"/>
			<xsl:when test="$pProv='Cr'"/>
			<xsl:when test="$pProv='Ct'"/>
			<xsl:when test="$pProv='Es'"/>
			<xsl:when test="$pProv='Ga(C)'"/>
			<xsl:when test="$pProv='Ge'"/>
			<xsl:when test="$pProv='Gg'"/>
			<xsl:when test="$pProv='Hb(N)'"/>
			<xsl:when test="$pProv='Ho'"/>
			<xsl:when test="$pProv='Hs(G)'"/>
			<xsl:when test="$pProv='Hu'"/>
			<xsl:when test="$pProv='Is'"/>
			<xsl:when test="$pProv='It'"/>
			<xsl:when test="$pProv='Jo'"/>
			<xsl:when test="$pProv='Ju'"/>
			<xsl:when test="$pProv='Le'"/>
			<xsl:when test="$pProv='Lt'"/>
			<xsl:when test="$pProv='Ma'"/>
			<xsl:when test="$pProv='Md(D)'"/>
			<xsl:when test="$pProv='Md(M)'"/>
			<xsl:when test="$pProv='Mo'"/>
			<xsl:when test="$pProv='Po'"/>
			<xsl:when test="$pProv='Rf(A)'"/>
			<xsl:when test="$pProv='Rf(C)'"/>
			<xsl:when test="$pProv='Rf(CS)'"/>
			<xsl:when test="$pProv='Rf(E)'"/>
			<xsl:when test="$pProv='Rf(K)'"/>
			<xsl:when test="$pProv='Sl'"/>
			<xsl:when test="$pProv='Sn'"/>
			<xsl:when test="$pProv='Sr'"/>
			<xsl:when test="$pProv='Sy'"/>
			<xsl:when test="$pProv='Tu(A)'"/>
			<xsl:when test="$pProv='Ab(A)'"/>
			<xsl:when test="$pProv='Ab(N)'"/>
			<xsl:when test="$pProv='AE'"/>
			<xsl:when test="$pProv='AE(T)'"/>
			<xsl:when test="$pProv='Al'"/>
			<xsl:when test="$pProv='Au(L)'"/>
			<xsl:when test="$pProv='Az(F)'"/>
			<xsl:when test="$pProv='Az(G)'"/>
			<xsl:when test="$pProv='Az(J)'"/>
			<xsl:when test="$pProv='Az(L)'"/>
			<xsl:when test="$pProv='Az(M)'"/>
			<xsl:when test="$pProv='Az(S)'"/>
			<xsl:when test="$pProv='Az(T)'"/>
			<xsl:when test="$pProv='Be'"/>
			<xsl:when test="$pProv='Be(L)'"/>
			<xsl:when test="$pProv='Bl(N)'"/>
			<xsl:when test="$pProv='Bu'"/>
			<xsl:when test="$pProv='By'"/>
			<xsl:when test="$pProv='Ca(F)'"/>
			<xsl:when test="$pProv='Ca(G)'"/>
			<xsl:when test="$pProv='Ca(H)'"/>
			<xsl:when test="$pProv='Ca(P)'"/>
			<xsl:when test="$pProv='Ca(T)'"/>
			<xsl:when test="$pProv='Cs'"/>
			<xsl:when test="$pProv='Cy'"/>
			<xsl:when test="$pProv='Da'"/>
			<xsl:when test="$pProv='Eg'"/>
			<xsl:when test="$pProv='Fa'"/>
			<xsl:when test="$pProv='Fe'"/>
			<xsl:when test="$pProv='Ga'"/>
			<xsl:when test="$pProv='Ga(F)'"/>
			<xsl:when test="$pProv='Gr'"/>
			<xsl:when test="$pProv='Hb'"/>
			<xsl:when test="$pProv='Hb(E)'"/>
			<xsl:when test="$pProv='He'"/>
			<xsl:when test="$pProv='Hs'"/>
			<xsl:when test="$pProv='Hs(A)'"/>
			<xsl:when test="$pProv='Hs(S)'"/>
			<xsl:when test="$pProv='IJ'"/>
			<xsl:when test="$pProv='Ir'"/>
			<xsl:when test="$pProv='La'"/>
			<xsl:when test="$pProv='Li'"/>
			<xsl:when test="$pProv='LS'"/>
			<xsl:when test="$pProv='Lu'"/>
			<xsl:when test="$pProv='Ma(E)'"/>
			<xsl:when test="$pProv='Ma(M)'"/>
			<xsl:when test="$pProv='Md'"/>
			<xsl:when test="$pProv='Md(P)'"/>
			<xsl:when test="$pProv='Mk'"/>
			<xsl:when test="$pProv='No'"/>
			<xsl:when test="$pProv='Rf(N)'"/>
			<xsl:when test="$pProv='Rf(NW)'"/>
			<xsl:when test="$pProv='Rf(S)'"/>
			<xsl:when test="$pProv='Rm'"/>
			<xsl:when test="$pProv='Sa'"/>
			<xsl:when test="$pProv='Sb'"/>
			<xsl:when test="$pProv='Sg'"/>
			<xsl:when test="$pProv='Si'"/>
			<xsl:when test="$pProv='Si(M)'"/>
			<xsl:when test="$pProv='Si(S)'"/>
			<xsl:when test="$pProv='Sk'"/>
			<xsl:when test="$pProv='Su'"/>
			<xsl:when test="$pProv='Tn'"/>
			<xsl:when test="$pProv='Tu(E)'"/>
			<xsl:when test="$pProv='Uk'"/>
			<xsl:when test="$pProv='Uk(K)'"/>
			<xsl:when test="$pProv='Uk(U)'"/>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>

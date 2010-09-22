<?xml version="1.0" encoding="UTF-8"?>
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
		<xsl:when test="$pProv='cultivated: C'"></xsl:when>
		<xsl:when test="$pProv='introduced: F'"></xsl:when>
		<xsl:when test="$pProv='introduced: I(A)'"></xsl:when>
		<xsl:when test="$pProv='native: D'"></xsl:when>
		<xsl:when test="$pProv='native: E'"></xsl:when>
		<xsl:when test="$pProv='introduced: D'"></xsl:when>
		<xsl:when test="$pProv='introduced: I'"></xsl:when>
		<xsl:when test="$pProv='introduced: I(N)'"></xsl:when>
		<xsl:when test="$pProv='introduced: Q'"></xsl:when>
		<xsl:when test="$pProv='native: F'"></xsl:when>
		<xsl:when test="$pProv='native: N'"></xsl:when>
		<xsl:when test="$pProv='native: Q'"></xsl:when>
	</xsl:choose>
</xsl:template>
	<xsl:template name="conRegion">
		<xsl:param name="pProv"/>
		<xsl:choose>
			<xsl:when test="$pProv='Bt'">Euro+Med Country;Baltic countries (Es + La + Lt + Rf(K))</xsl:when>
			<xsl:when test="$pProv='Cc'">Euro+Med Country;Caucasia (Ab + Ar + Gg + Rf(CS))</xsl:when>
			<xsl:when test="$pProv='Ga'">Euro+Med Country;France, with Channel Islands and Monaco (without Co)</xsl:when>
			<xsl:when test="$pProv='It'">Euro+Med Country;Italy, with San Marino and Vatican City (without Sa and Si(S))</xsl:when>
			<xsl:when test="$pProv='Hs'">Euro+Med Country;Spain, with Gibraltar and Andorra (without Bl and Ca)</xsl:when>
			<xsl:when test="$pProv='Au'">Euro+Med Country;Austria, with Liechtenstein</xsl:when>
			<xsl:when test="$pProv='Be'">Euro+Med Country;Belgium, with Luxemburg</xsl:when>
			<xsl:when test="$pProv='Ga(F)'">Euro+Med Country;France with Monaco</xsl:when>
			<xsl:when test="$pProv='Hb'">Euro+Med Country;Ireland with N. Ireland</xsl:when>
			<xsl:when test="$pProv='LS'">Euro+Med Country;Lebanon and Syria (Le + Sy)</xsl:when>
			<xsl:when test="$pProv='IJ'">Euro+Med Country;Palestine (Ir + Jo)</xsl:when>
			<xsl:when test="$pProv='Si'">Euro+Med Country;Sicily, with Malta</xsl:when>
			<xsl:when test="$pProv='Ab'">Euro+Med Country;Azerbaijan</xsl:when>
			<xsl:when test="$pProv='Ab(A)'">Euro+Med Country;Core Azerbaijan</xsl:when>
			<xsl:when test="$pProv='Ab(N)'">Euro+Med Country;Nakhichevan</xsl:when>
			<xsl:when test="$pProv='AE'">Euro+Med Country;East Aegean Islands</xsl:when>
			<xsl:when test="$pProv='AE(G)'">Euro+Med Country;Greek East Aegean islands, including Kastellorizo</xsl:when>
			<xsl:when test="$pProv='AE(T)'">Euro+Med Country;Bozcaada Island</xsl:when>
			<xsl:when test="$pProv='Ag'">Euro+Med Country;Algeria</xsl:when>
			<xsl:when test="$pProv='Al'">Euro+Med Country;Albania</xsl:when>
			<xsl:when test="$pProv='Ar'">Euro+Med Country;Armenia</xsl:when>
			<xsl:when test="$pProv='Au(A)'">Euro+Med Country;Austria</xsl:when>
			<xsl:when test="$pProv='Au(L)'">Euro+Med Country;Liechtenstein</xsl:when>
			<xsl:when test="$pProv='Az'">Euro+Med Country;Azores</xsl:when>
			<xsl:when test="$pProv='Az(C)'">Euro+Med Country;Corvo</xsl:when>
			<xsl:when test="$pProv='Az(F)'">Euro+Med Country;Faial</xsl:when>
			<xsl:when test="$pProv='Az(G)'">Euro+Med Country;Graciosa</xsl:when>
			<xsl:when test="$pProv='Az(J)'">Euro+Med Country;São Jorge</xsl:when>
			<xsl:when test="$pProv='Az(L)'">Euro+Med Country;Flores</xsl:when>
			<xsl:when test="$pProv='Az(M)'">Euro+Med Country;São Miguel</xsl:when>
			<xsl:when test="$pProv='Az(P)'">Euro+Med Country;Pico</xsl:when>
			<xsl:when test="$pProv='Az(S)'">Euro+Med Country;Santa Maria</xsl:when>
			<xsl:when test="$pProv='Az(T)'">Euro+Med Country;Terceira</xsl:when>
			<xsl:when test="$pProv='Be(B)'">Euro+Med Country;Belgium</xsl:when>
			<xsl:when test="$pProv='Be(L)'">Euro+Med Country;Luxemburg</xsl:when>
			<xsl:when test="$pProv='BH'">Euro+Med Country;Bosnia-Herzegovina</xsl:when>
			<xsl:when test="$pProv='Bl'">Euro+Med Country;Balearic Islands</xsl:when>
			<xsl:when test="$pProv='Bl(I)'">Euro+Med Country;Ibiza, including Formentera</xsl:when>
			<xsl:when test="$pProv='Bl(M)'">Euro+Med Country;Mallorca</xsl:when>
			<xsl:when test="$pProv='Bl(N)'">Euro+Med Country;Menorca</xsl:when>
			<xsl:when test="$pProv='Br'">Euro+Med Country;United Kingdom (excluding Channel Islands and Hb(N))</xsl:when>
			<xsl:when test="$pProv='Bu'">Euro+Med Country;Bulgaria</xsl:when>
			<xsl:when test="$pProv='By'">Euro+Med Country;Belarus</xsl:when>
			<xsl:when test="$pProv='Ca'">Euro+Med Country;Canary Islands</xsl:when>
			<xsl:when test="$pProv='Ca(C)'">Euro+Med Country;Gran Canaria</xsl:when>
			<xsl:when test="$pProv='Ca(F)'">Euro+Med Country;Fuerteventura, including Lobos</xsl:when>
			<xsl:when test="$pProv='Ca(G)'">Euro+Med Country;Gomera</xsl:when>
			<xsl:when test="$pProv='Ca(H)'">Euro+Med Country;Hierro</xsl:when>
			<xsl:when test="$pProv='Ca(L)'">Euro+Med Country;Lanzarote and adjacent islands</xsl:when>
			<xsl:when test="$pProv='Ca(P)'">Euro+Med Country;La Palma</xsl:when>
			<xsl:when test="$pProv='Ca(T)'">Euro+Med Country;Tenerife</xsl:when>
			<xsl:when test="$pProv='Cg'">Euro+Med Country;Montenegro</xsl:when>
			<xsl:when test="$pProv='Co'">Euro+Med Country;Corsica</xsl:when>
			<xsl:when test="$pProv='Cr'">Euro+Med Country;Crete and Karpathos island groups</xsl:when>
			<xsl:when test="$pProv='Cs'">Euro+Med Country;Czech Republic</xsl:when>
			<xsl:when test="$pProv='Ct'">Euro+Med Country;Croatia</xsl:when>
			<xsl:when test="$pProv='Cy'">Euro+Med Country;Cyprus</xsl:when>
			<xsl:when test="$pProv='Da'">Euro+Med Country;Denmark (without Fa)</xsl:when>
			<xsl:when test="$pProv='Eg'">Euro+Med Country;Egypt (without Sn)</xsl:when>
			<xsl:when test="$pProv='Es'">Euro+Med Country;Estonia</xsl:when>
			<xsl:when test="$pProv='Fa'">Euro+Med Country;Faeroe Islands</xsl:when>
			<xsl:when test="$pProv='Fe'">Euro+Med Country;Finland</xsl:when>
			<xsl:when test="$pProv='Ga(C)'">Euro+Med Country;Channel Islands</xsl:when>
			<xsl:when test="$pProv='Ge'">Euro+Med Country;Germany</xsl:when>
			<xsl:when test="$pProv='Gg'">Euro+Med Country;Georgia</xsl:when>
			<xsl:when test="$pProv='Gr'">Euro+Med Country;Greece (without Cr and AE(G))</xsl:when>
			<xsl:when test="$pProv='Hb(E)'">Euro+Med Country;Ireland</xsl:when>
			<xsl:when test="$pProv='Hb(N)'">Euro+Med Country;Northern Ireland</xsl:when>
			<xsl:when test="$pProv='He'">Euro+Med Country;Switzerland</xsl:when>
			<xsl:when test="$pProv='Hs(A)'">Euro+Med Country;Andorra</xsl:when>
			<xsl:when test="$pProv='Hs(G)'">Euro+Med Country;Gibraltar</xsl:when>
			<xsl:when test="$pProv='Hs(S)'">Euro+Med Country;Mainland Spain</xsl:when>
			<xsl:when test="$pProv='Ho'">Euro+Med Country;Netherlands</xsl:when>
			<xsl:when test="$pProv='Hu'">Euro+Med Country;Hungary</xsl:when>
			<xsl:when test="$pProv='Ir'">Euro+Med Country;Israel, with the Palestinian Authority territories</xsl:when>
			<xsl:when test="$pProv='Is'">Euro+Med Country;Iceland</xsl:when>
			<xsl:when test="$pProv='Jo'">Euro+Med Country;Jordan</xsl:when>
			<xsl:when test="$pProv='La'">Euro+Med Country;Latvia</xsl:when>
			<xsl:when test="$pProv='Le'">Euro+Med Country;Lebanon</xsl:when>
			<xsl:when test="$pProv='Li'">Euro+Med Country;Libya</xsl:when>
			<xsl:when test="$pProv='Lt'">Euro+Med Country;Lithuania</xsl:when>
			<xsl:when test="$pProv='Lu'">Euro+Med Country;Portugal (without Az, Md and Sg)</xsl:when>
			<xsl:when test="$pProv='Ma'">Euro+Med Country;Morocco, with Spanish Territories</xsl:when>
			<xsl:when test="$pProv='Mk'">Euro+Med Country;The Former Yugoslav Republic of Makedonija</xsl:when>
			<xsl:when test="$pProv='Md'">Euro+Med Country;Madeira</xsl:when>
			<xsl:when test="$pProv='Md(D)'">Euro+Med Country;Desertas</xsl:when>
			<xsl:when test="$pProv='Md(M)'">Euro+Med Country;Madeira</xsl:when>
			<xsl:when test="$pProv='Md(P)'">Euro+Med Country;Porto Santo</xsl:when>
			<xsl:when test="$pProv='Mo'">Euro+Med Country;Moldavia</xsl:when>
			<xsl:when test="$pProv='No'">Euro+Med Country;Norway (without Sb)</xsl:when>
			<xsl:when test="$pProv='Po'">Euro+Med Country;Poland</xsl:when>
			<xsl:when test="$pProv='Rf'">Euro+Med Country;European part of the Russian Federation</xsl:when>
			<xsl:when test="$pProv='Rf(A):'">Euro+Med Country;Novaya Zemlya and Franz-Joseph Land</xsl:when>
			<xsl:when test="$pProv='Rf(C):'">Euro+Med Country;C. European Russia, comprising Kostroma, Tver, Yaroslavl, Vladimir, Nizhniy Novgorod, Smolensk, Moscow, Ryazan, Mordovia, Chuvashia, Ulyanovsk, Kaluga, Tula, Lipetsk, Tambov, Penza, Bryansk, Orlov, Kursk, Voronezh, Belgorod</xsl:when>
			<xsl:when test="$pProv='Rf(CS):'">Euro+Med Country;Russian Caucasia</xsl:when>
			<xsl:when test="$pProv='Rf(E):'">Euro+Med Country;E. European Russia, comprising Vyatka, Perm, Udmurtia, Bashkortostan, Tatarstan, Samara, Orenburg</xsl:when>
			<xsl:when test="$pProv='Rf(K):'">Euro+Med Country;Kaliningrad Region</xsl:when>
			<xsl:when test="$pProv='Rf(N):N.'">Euro+Med Country;European Russia, comprising Arkhangelskaya, Karelia, Komi, Murmansk, Vologda</xsl:when>
			<xsl:when test="$pProv='Rf(NW):'">Euro+Med Country;Northwest European Russia, comprising Novgorod, Pskov, St Petersburg</xsl:when>
			<xsl:when test="$pProv='Rf(S):'">Euro+Med Country;S. European Russia, comprising Saratov, Volgograd, Astrakhan, Rostov, Kalmykiya)</xsl:when>
			<xsl:when test="$pProv='Rm'">Euro+Med Country;Romania</xsl:when>
			<xsl:when test="$pProv='Sa'">Euro+Med Country;Sardinia</xsl:when>
			<xsl:when test="$pProv='Sb'">Euro+Med Country;Svalbard: Spitsbergen, Björnöya and Jan Mayen</xsl:when>
			<xsl:when test="$pProv='Sg'">Euro+Med Country;Salvage Islands</xsl:when>
			<xsl:when test="$pProv='Si(M)'">Euro+Med Country;Malta</xsl:when>
			<xsl:when test="$pProv='Si(S)'">Euro+Med Country;Sicily and surrounding islands</xsl:when>
			<xsl:when test="$pProv='Sk'">Euro+Med Country;Slovakia</xsl:when>
			<xsl:when test="$pProv='Sl'">Euro+Med Country;Slovenia</xsl:when>
			<xsl:when test="$pProv='Sn'">Euro+Med Country;Sinai</xsl:when>
			<xsl:when test="$pProv='Sr'">Euro+Med Country;Serbia</xsl:when>
			<xsl:when test="$pProv='Su'">Euro+Med Country;Sweden</xsl:when>
			<xsl:when test="$pProv='Sy'">Euro+Med Country;Syria</xsl:when>
			<xsl:when test="$pProv='Tn'">Euro+Med Country;Tunisia</xsl:when>
			<xsl:when test="$pProv='Tu'">Euro+Med Country;Turkey (without AE(T))</xsl:when>
			<xsl:when test="$pProv='Tu(A)'">Euro+Med Country;Asiatic Turkey (Anatolia)</xsl:when>
			<xsl:when test="$pProv='Tu(E)'">Euro+Med Country;Turkey-in-Europe, including Gökçeada</xsl:when>
			<xsl:when test="$pProv='Uk'">Euro+Med Country;Ukraine</xsl:when>
			<xsl:when test="$pProv='Uk(K)'">Euro+Med Country;Crimea</xsl:when>
			<xsl:when test="$pProv='Uk(U)'">Euro+Med Country;Non-Crimean Ukraine</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>

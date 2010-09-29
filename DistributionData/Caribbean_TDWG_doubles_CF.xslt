<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml Caribean_Sample.xml?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<Distributions>
			<xsl:for-each select="//Distribution">
				<xsl:if test="@region!='ow'">
				<xsl:if test="@region!='status'">
					<!--do not process if the region is ow-->
					<!--Set up a variable that contains standard text so that we can interpret the biostatus information-->
					<xsl:variable name="vResult">
						<xsl:call-template name="ProcessBiostatus">
							<xsl:with-param name="pText" select="."/>
						</xsl:call-template>
					</xsl:variable>
					<!--Process the regions to convert to standard tdwg-->
					<xsl:variable name="vRegion">
						<xsl:call-template name="conRegion">
							<xsl:with-param name="pRegion" select="@region"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:if test="$vResult!='FAIL'">
						<!--Because we have some regions that map to >1 tdwg region we now need to call a template to write the results-->
						<xsl:call-template name="Write">
							<xsl:with-param name="pSchema"><xsl:value-of select="substring-before($vRegion,';')"/></xsl:with-param>
							<xsl:with-param name="pRegion"><xsl:value-of select="substring-after($vRegion,';')"/></xsl:with-param>
							<xsl:with-param name="pOcc"><xsl:value-of select="substring-before($vResult, ';')"/></xsl:with-param>
							<xsl:with-param name="pOrig"><xsl:value-of select="substring-after($vResult, ';')"/></xsl:with-param>
						</xsl:call-template>
					</xsl:if>
				</xsl:if>
				</xsl:if>
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
	
	<xsl:template name="conRegion">
		<xsl:param name="pRegion"/>
		<xsl:choose>
			<xsl:when test="$pRegion='la'">TDWG Level 3;LEE;TDWG Level 3;WIN</xsl:when>
			<xsl:when test="$pRegion='ja'">TDWG Level 4;JAM-OO</xsl:when>
			<xsl:when test="$pRegion='cu'">TDWG Level 4;CUB-OO</xsl:when>
			<xsl:when test="$pRegion='ci'">TDWG Level 4;CAY-OO</xsl:when>
			<xsl:when test="$pRegion='hi'">TDWG Level 4;DOM-OO;TDWG Level 3;HAI</xsl:when>
			<xsl:when test="$pRegion='pr'">TDWG Level 4;PUE-OO</xsl:when>
			<xsl:when test="$pRegion='vi'">TDWG Level 4;LEE-VI</xsl:when>
			<xsl:when test="$pRegion='ba'">TDWG Level 4;BAH-OO</xsl:when>
			<xsl:when test="$pRegion='ma'">TDWG Level 1;7</xsl:when>
			<xsl:when test="$pRegion='mex'">TDWG Level 2;79</xsl:when>
			<xsl:when test="$pRegion='ca'">TDWG Level 2;80</xsl:when>
			<xsl:when test="$pRegion='sa'">TDWG Level 1;8</xsl:when>
			<xsl:when test="$pRegion='wi'">TDWG Level 2;81</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="ProcessBiostatus">
		<xsl:param name="pText"/>
		<xsl:choose>
			<xsl:when test="$pText='?'">Uncertain;</xsl:when>
			<xsl:when test="$pText='Asia'">FAIL</xsl:when>
			<xsl:when test="$pText='Asia; Pacific'">FAIL</xsl:when>
			<xsl:when test="$pText='C. Europe'">FAIL</xsl:when>
			<xsl:when test="$pText='cosmopolit'">FAIL</xsl:when>
			<xsl:when test="$pText='cultivated'">Present;Cultivated</xsl:when>
			<xsl:when test="$pText='cultivated/escaped'">Present;Cultivated</xsl:when>
			<xsl:when test="$pText='dubious'">Uncertain;</xsl:when>
			<xsl:when test="$pText='endemic'">Present in wild;Endemic</xsl:when>
			<xsl:when test="$pText='endemic?'">Present in wild;Indigenous</xsl:when>
			<xsl:when test="$pText='Europe'">FAIL</xsl:when>
			<xsl:when test="$pText='Europe.; Asia'">FAIL</xsl:when>
			<xsl:when test="$pText='exotic'">Present;Exotic</xsl:when>
			<xsl:when test="$pText='exotic?'">Present;Exotic</xsl:when>
			<xsl:when test="$pText='FL'">Present;</xsl:when>
			<xsl:when test="$pText='Florida'">Present;</xsl:when>
			<xsl:when test="$pText='Hawaii'">Present;</xsl:when>
			<xsl:when test="$pText='intro/common'">Present;Exotic</xsl:when>
			<xsl:when test="$pText='intro/cultivated'">Present;Cultivated</xsl:when>
			<xsl:when test="$pText='intro/local'">Present;Exotic</xsl:when>
			<xsl:when test="$pText='intro/naturalized'">Present in wild;Exotic</xsl:when>
			<xsl:when test="$pText='introduced'">Present;Exotic</xsl:when>
			<xsl:when test="$pText='Ivory Coast'">Present;</xsl:when>
			<xsl:when test="$pText='natiendemic'">Present in wild;Endemic</xsl:when>
			<xsl:when test="$pText='nativ:Transvaal'">FAIL</xsl:when>
			<xsl:when test="$pText='native Europe'">FAIL</xsl:when>
			<xsl:when test="$pText='native'">Present in wild;Indigenous</xsl:when>
			<xsl:when test="$pText='native, north and south'">Present in wild;Indigenous</xsl:when>
			<xsl:when test="$pText='native/1 coll.'">Present in wild;Indigenous</xsl:when>
			<xsl:when test="$pText='native/common'">Present in wild;Indigenous</xsl:when>
			<xsl:when test="$pText='native/endemic dub'">Present in wild;Indigenous</xsl:when>
			<xsl:when test="$pText='native/endemic'">Present in wild;Endemic</xsl:when>
			<xsl:when test="$pText='native/frequent'">Present in wild;Indigenous</xsl:when>
			<xsl:when test="$pText='native/general'">Present in wild;Indigenous</xsl:when>
			<xsl:when test="$pText='native/historical'">Present in wild;Indigenous</xsl:when>
			<xsl:when test="$pText='native/local'">Present in wild;Indigenous</xsl:when>
			<xsl:when test="$pText='native/locally common'">Present in wild;Indigenous</xsl:when>
			<xsl:when test="$pText='native/occasional'">Sometimes present;Indigenous</xsl:when>
			<xsl:when test="$pText='native/rare and local'">Present in wild;Indigenous</xsl:when>
			<xsl:when test="$pText='native/rare'">Present in wild;Indigenous</xsl:when>
			<xsl:when test="$pText='native/rather common'">Present in wild;Indigenous</xsl:when>
			<xsl:when test="$pText='native/rather uncommon'">Present in wild;Indigenous</xsl:when>
			<xsl:when test="$pText='native/twice collected'">Present in wild;Indigenous</xsl:when>
			<xsl:when test="$pText='native/uncommon'">Present in wild;Indigenous</xsl:when>
			<xsl:when test="$pText='native/very common'">Present in wild;Indigenous</xsl:when>
			<xsl:when test="$pText='native/very local'">Present in wild;Indigenous</xsl:when>
			<xsl:when test="$pText='native/very rare'">Present in wild;Indigenous</xsl:when>
			<xsl:when test="$pText='native/vommon'">Present in wild;Indigenous</xsl:when>
			<xsl:when test="$pText='native/widespread, uncomm'">Present in wild;Indigenous</xsl:when>
			<xsl:when test="$pText='native: Africa'">FAIL</xsl:when>
			<xsl:when test="$pText='native: Asia'">FAIL</xsl:when>
			<xsl:when test="$pText='native: China'">FAIL</xsl:when>
			<xsl:when test="$pText='native: Eurasia'">FAIL</xsl:when>
			<xsl:when test="$pText='native: Europe'">FAIL</xsl:when>
			<xsl:when test="$pText='native: India'">FAIL</xsl:when>
			<xsl:when test="$pText='native: Java'">FAIL</xsl:when>
			<xsl:when test="$pText='native:Portugal'">FAIL</xsl:when>
			<xsl:when test="$pText='native?'">Present;Uncertain</xsl:when>
			<xsl:when test="$pText='nativend north'">Present in wild;Endemic</xsl:when>
			<xsl:when test="$pText='nativend south'">Present in wild;Endemic</xsl:when>
			<xsl:when test="$pText='nativendemic cen'">Present in wild;Endemic</xsl:when>
			<xsl:when test="$pText='nativendemic dub'">Present in wild;Endemic</xsl:when>
			<xsl:when test="$pText='nativendemic'">Present in wild;Endemic</xsl:when>
			<xsl:when test="$pText='nativendemic, cen'">Present in wild;Endemic</xsl:when>
			<xsl:when test="$pText='nativendemic, occ'">Present in wild;Endemic</xsl:when>
			<xsl:when test="$pText='nativendemic, ori'">Present in wild;Endemic</xsl:when>
			<xsl:when test="$pText='nativendemic/1 coll.'">Present in wild;Endemic</xsl:when>
			<xsl:when test="$pText='nativendemic/common'">Present in wild;Endemic</xsl:when>
			<xsl:when test="$pText='nativendemic/endange'">Present in wild;Endemic</xsl:when>
			<xsl:when test="$pText='nativendemic/frequent'">Present in wild;Endemic</xsl:when>
			<xsl:when test="$pText='nativendemic/general'">Present in wild;Endemic</xsl:when>
			<xsl:when test="$pText='nativendemic/local and uncommon'">Present in wild;Endemic</xsl:when>
			<xsl:when test="$pText='nativendemic/local'">Present in wild;Endemic</xsl:when>
			<xsl:when test="$pText='nativendemic/locally common'">Present in wild;Endemic</xsl:when>
			<xsl:when test="$pText='nativendemic/locally frequent'">Present in wild;Endemic</xsl:when>
			<xsl:when test="$pText='nativendemic/occas to loc comm'">Present in wild;Endemic</xsl:when>
			<xsl:when test="$pText='nativendemic/occasional'">Sometimes present;Endemic</xsl:when>
			<xsl:when test="$pText='nativendemic/rare and local'">Present in wild;Endemic</xsl:when>
			<xsl:when test="$pText='nativendemic/rare'">Present in wild;Endemic</xsl:when>
			<xsl:when test="$pText='nativendemic/uncommon'">Present in wild;Endemic</xsl:when>
			<xsl:when test="$pText='nativendemic/very local'">Present in wild;Endemic</xsl:when>
			<xsl:when test="$pText='nativendemic/very locally comm'">Present in wild;Endemic</xsl:when>
			<xsl:when test="$pText='nativendemic/very rare'">Present in wild;Endemic</xsl:when>
			<xsl:when test="$pText='nativendemic/widely scattered'">Present in wild;Endemic</xsl:when>
			<xsl:when test="$pText='nativendemic?'">Present in wild;Indigenous</xsl:when>
			<xsl:when test="$pText='nativendmic'">Present in wild;Endemic</xsl:when>
			<xsl:when test="$pText='No'">Absent;</xsl:when>
			<xsl:when test="$pText='no'">Absent;</xsl:when>
			<xsl:when test="$pText='no?'">Uncertain;</xsl:when>
			<xsl:when test="$pText='North and South native'">Present in wild;Indigenous</xsl:when>
			<xsl:when test="$pText='North and South nativendemic'">Present in wild;Endemic</xsl:when>
			<xsl:when test="$pText='North and South'">Present;</xsl:when>
			<xsl:when test="$pText='North native'">Present in wild;Indigenous</xsl:when>
			<xsl:when test="$pText='North nativendemic'">Present in wild;Endemic</xsl:when>
			<xsl:when test="$pText='North'">Present;</xsl:when>
			<xsl:when test="$pText='Philippines'">FAIL</xsl:when>
			<xsl:when test="$pText='rare native'">Present in wild;Indigenous</xsl:when>
			<xsl:when test="$pText='rare'">Present in wild;Indigenous</xsl:when>
			<xsl:when test="$pText='South native'">Present in wild;Indigenous</xsl:when>
			<xsl:when test="$pText='South nativendemic'">Present in wild;Endemic</xsl:when>
			<xsl:when test="$pText='South'">Present;</xsl:when>
			<xsl:when test="$pText='Trinidad'">FAIL</xsl:when>
			<xsl:when test="$pText='Ven'">FAIL</xsl:when>
			<xsl:when test="$pText='W. Africa'">FAIL</xsl:when>
			<xsl:when test="$pText='Yes'">Present;</xsl:when>
			<xsl:when test="$pText='yes?'">Uncertain;</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>

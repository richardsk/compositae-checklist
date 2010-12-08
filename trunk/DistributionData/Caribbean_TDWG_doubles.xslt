<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml Caribean_Sample.xml?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<Distributions>
			<xsl:for-each select="//Distribution">
				<xsl:if test="@region!='ow'">
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
		</xsl:choose>
	</xsl:template>
	<xsl:template name="ProcessBiostatus">
		<xsl:param name="pText"/>
		<xsl:choose>
			<xsl:when test="$pText='?'">FAIL</xsl:when>
			<xsl:when test="$pText='Asia'"/>
			<xsl:when test="$pText='Asia; Pacific'"/>
			<xsl:when test="$pText='C. Europe'"/>
			<xsl:when test="$pText='cosmopolit'"/>
			<xsl:when test="$pText='cultivated'"/>
			<xsl:when test="$pText='cultivated/escaped'"/>
			<xsl:when test="$pText='dubious'"/>
			<xsl:when test="$pText='endemic'">Present in wild;Endemic</xsl:when>
			<xsl:when test="$pText='endemic?'">Present in wild;Indigenous</xsl:when>
			<xsl:when test="$pText='Europe'"/>
			<xsl:when test="$pText='Europe.; Asia'"/>
			<xsl:when test="$pText='exotic'"/>
			<xsl:when test="$pText='exotic?'"/>
			<xsl:when test="$pText='FL'"/>
			<xsl:when test="$pText='Florida'"/>
			<xsl:when test="$pText='Hawaii'"/>
			<xsl:when test="$pText='intro/common'"/>
			<xsl:when test="$pText='intro/cultivated'"/>
			<xsl:when test="$pText='intro/local'"/>
			<xsl:when test="$pText='intro/naturalized'"/>
			<xsl:when test="$pText='introduced'"/>
			<xsl:when test="$pText='Ivory Coast'"/>
			<xsl:when test="$pText='natiendemic'"/>
			<xsl:when test="$pText='nativ:Transvaal'"/>
			<xsl:when test="$pText='native Europe'"/>
			<xsl:when test="$pText='native'">Present in wild;Indigenous</xsl:when>
			<xsl:when test="$pText='native, north and south'"/>
			<xsl:when test="$pText='native/1 coll.'"/>
			<xsl:when test="$pText='native/common'"/>
			<xsl:when test="$pText='native/endemic dub'"/>
			<xsl:when test="$pText='native/endemic'">Present in wild;Endemic</xsl:when>
			<xsl:when test="$pText='native/frequent'">Present in wild;Indigenous</xsl:when>
			<xsl:when test="$pText='native/general'">Present in wild;Indigenous</xsl:when>
			<xsl:when test="$pText='native/historical'"/>
			<xsl:when test="$pText='native/local'">Present in wild;Indigenous</xsl:when>
			<xsl:when test="$pText='native/locally common'">Present in wild;Indigenous</xsl:when>
			<xsl:when test="$pText='native/occasional'">Present in wild;Indigenous</xsl:when>
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
			<xsl:when test="$pText='native: Africa'"/>
			<xsl:when test="$pText='native: Asia'"/>
			<xsl:when test="$pText='native: China'"/>
			<xsl:when test="$pText='native: Eurasia'"/>
			<xsl:when test="$pText='native: Europe'"/>
			<xsl:when test="$pText='native: India'"/>
			<xsl:when test="$pText='native: Java'"/>
			<xsl:when test="$pText='native:Portugal'"/>
			<xsl:when test="$pText='native?'"/>
			<xsl:when test="$pText='nativend north'"/>
			<xsl:when test="$pText='nativend south'"/>
			<xsl:when test="$pText='nativendemic cen'"/>
			<xsl:when test="$pText='nativendemic dub'"/>
			<xsl:when test="$pText='nativendemic'"/>
			<xsl:when test="$pText='nativendemic, cen'"/>
			<xsl:when test="$pText='nativendemic, occ'"/>
			<xsl:when test="$pText='nativendemic, ori'"/>
			<xsl:when test="$pText='nativendemic/1 coll.'"/>
			<xsl:when test="$pText='nativendemic/common'"/>
			<xsl:when test="$pText='nativendemic/endange'"/>
			<xsl:when test="$pText='nativendemic/frequent'"/>
			<xsl:when test="$pText='nativendemic/general'"/>
			<xsl:when test="$pText='nativendemic/local and uncommon'"/>
			<xsl:when test="$pText='nativendemic/local'"/>
			<xsl:when test="$pText='nativendemic/locally common'"/>
			<xsl:when test="$pText='nativendemic/locally frequent'"/>
			<xsl:when test="$pText='nativendemic/occas to loc comm'"/>
			<xsl:when test="$pText='nativendemic/occasional'"/>
			<xsl:when test="$pText='nativendemic/rare and local'"/>
			<xsl:when test="$pText='nativendemic/rare'"/>
			<xsl:when test="$pText='nativendemic/uncommon'"/>
			<xsl:when test="$pText='nativendemic/very local'"/>
			<xsl:when test="$pText='nativendemic/very locally comm'"/>
			<xsl:when test="$pText='nativendemic/very rare'"/>
			<xsl:when test="$pText='nativendemic/widely scattered'"/>
			<xsl:when test="$pText='nativendemic?'"/>
			<xsl:when test="$pText='nativendmic'"/>
			<xsl:when test="$pText='No'">Absent;</xsl:when>
			<xsl:when test="$pText='no?'"/>
			<xsl:when test="$pText='North and South native'">Present in wild;Indigenous</xsl:when>
			<xsl:when test="$pText='North and South nativendemic'">Present in wild;Endemic</xsl:when>
			<xsl:when test="$pText='North and South'"/>
			<xsl:when test="$pText='North native'"/>
			<xsl:when test="$pText='North nativendemic'"/>
			<xsl:when test="$pText='North'"/>
			<xsl:when test="$pText='Philippines'"/>
			<xsl:when test="$pText='rare native'"/>
			<xsl:when test="$pText='rare'"/>
			<xsl:when test="$pText='South native'"/>
			<xsl:when test="$pText='South nativendemic'"/>
			<xsl:when test="$pText='South'"/>
			<xsl:when test="$pText='Trinidad'"/>
			<xsl:when test="$pText='Ven'"/>
			<xsl:when test="$pText='W. Africa'"/>
			<xsl:when test="$pText='Yes'"/>
			<xsl:when test="$pText='yes?'"/>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>

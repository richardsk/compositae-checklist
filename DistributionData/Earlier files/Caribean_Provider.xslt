<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml Caribean_Sample.xml?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<Distributions>
			<xsl:for-each select="//Distribution">
				<xsl:if test="@region!='ow'">   <!--do not process if the region is ow-->
					<!--Set up a variable that contains standard text so that we can interpret the biostatus information-->
					<xsl:variable name="vResult">
						<xsl:call-template name="ProcessBiostatus">
							<xsl:with-param name="pText" select="."/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:if test="$vResult!='FAIL'">
						<Distribution>
							<xsl:attribute name="schema">Caribbean Checklist</xsl:attribute>
							<xsl:attribute name="region">
								<xsl:value-of select="@region"/>
							</xsl:attribute>
							<xsl:attribute name="origin">
								<xsl:value-of select="substring-after($vResult, ';')"/>
							</xsl:attribute>
							<xsl:attribute name="occurrence">
									<xsl:value-of select="substring-before($vResult, ';')"/>
							</xsl:attribute>
						</Distribution>
					</xsl:if>
				</xsl:if>
			</xsl:for-each>
		</Distributions>
	</xsl:template>
	<xsl:template name="ProcessBiostatus">
		<xsl:param name="pText"/>
		<xsl:choose>
			<xsl:when test="$pText='?'">FAIL</xsl:when>
			<xsl:when test="$pText='Asia'"></xsl:when>
			<xsl:when test="$pText='Asia; Pacific'"></xsl:when>
			<xsl:when test="$pText='C. Europe'"></xsl:when>
			<xsl:when test="$pText='cosmopolit'"></xsl:when>
			<xsl:when test="$pText='cultivated'"></xsl:when>
			<xsl:when test="$pText='cultivated/escaped'"></xsl:when>
			<xsl:when test="$pText='dubious'"></xsl:when>
			<xsl:when test="$pText='endemic'">Present in wild;Endemic</xsl:when>
			<xsl:when test="$pText='endemic?'">Present in wild;Indigenous</xsl:when>
			<xsl:when test="$pText='Europe'"></xsl:when>
			<xsl:when test="$pText='Europe.; Asia'"></xsl:when>
			<xsl:when test="$pText='exotic'"></xsl:when>
			<xsl:when test="$pText='exotic?'"></xsl:when>
			<xsl:when test="$pText='FL'"></xsl:when>
			<xsl:when test="$pText='Florida'"></xsl:when>
			<xsl:when test="$pText='Hawaii'"></xsl:when>
			<xsl:when test="$pText='intro/common'"></xsl:when>
			<xsl:when test="$pText='intro/cultivated'"></xsl:when>
			<xsl:when test="$pText='intro/local'"></xsl:when>
			<xsl:when test="$pText='intro/naturalized'"></xsl:when>
			<xsl:when test="$pText='introduced'"></xsl:when>
			<xsl:when test="$pText='Ivory Coast'"></xsl:when>
			<xsl:when test="$pText='natiendemic'"></xsl:when>
			<xsl:when test="$pText='nativ:Transvaal'"></xsl:when>
			<xsl:when test="$pText='native Europe'"></xsl:when>
			<xsl:when test="$pText='native'">Present in wild;Indigenous</xsl:when>
			<xsl:when test="$pText='native, north and south'"></xsl:when>
			<xsl:when test="$pText='native/1 coll.'"></xsl:when>
			<xsl:when test="$pText='native/common'"></xsl:when>
			<xsl:when test="$pText='native/endemic dub'"></xsl:when>
			<xsl:when test="$pText='native/endemic'">Present in wild;Endemic</xsl:when>
			<xsl:when test="$pText='native/frequent'">Present in wild;Indigenous</xsl:when>
			<xsl:when test="$pText='native/general'">Present in wild;Indigenous</xsl:when>
			<xsl:when test="$pText='native/historical'"></xsl:when>
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
			<xsl:when test="$pText='native: Africa'"></xsl:when>
			<xsl:when test="$pText='native: Asia'"></xsl:when>
			<xsl:when test="$pText='native: China'"></xsl:when>
			<xsl:when test="$pText='native: Eurasia'"></xsl:when>
			<xsl:when test="$pText='native: Europe'"></xsl:when>
			<xsl:when test="$pText='native: India'"></xsl:when>
			<xsl:when test="$pText='native: Java'"></xsl:when>
			<xsl:when test="$pText='native:Portugal'"></xsl:when>
			<xsl:when test="$pText='native?'"></xsl:when>
			<xsl:when test="$pText='nativend north'"></xsl:when>
			<xsl:when test="$pText='nativend south'"></xsl:when>
			<xsl:when test="$pText='nativendemic cen'"></xsl:when>
			<xsl:when test="$pText='nativendemic dub'"></xsl:when>
			<xsl:when test="$pText='nativendemic'"></xsl:when>
			<xsl:when test="$pText='nativendemic, cen'"></xsl:when>
			<xsl:when test="$pText='nativendemic, occ'"></xsl:when>
			<xsl:when test="$pText='nativendemic, ori'"></xsl:when>
			<xsl:when test="$pText='nativendemic/1 coll.'"></xsl:when>
			<xsl:when test="$pText='nativendemic/common'"></xsl:when>
			<xsl:when test="$pText='nativendemic/endange'"></xsl:when>
			<xsl:when test="$pText='nativendemic/frequent'"></xsl:when>
			<xsl:when test="$pText='nativendemic/general'"></xsl:when>
			<xsl:when test="$pText='nativendemic/local and uncommon'"></xsl:when>
			<xsl:when test="$pText='nativendemic/local'"></xsl:when>
			<xsl:when test="$pText='nativendemic/locally common'"></xsl:when>
			<xsl:when test="$pText='nativendemic/locally frequent'"></xsl:when>
			<xsl:when test="$pText='nativendemic/occas to loc comm'"></xsl:when>
			<xsl:when test="$pText='nativendemic/occasional'"></xsl:when>
			<xsl:when test="$pText='nativendemic/rare and local'"></xsl:when>
			<xsl:when test="$pText='nativendemic/rare'"></xsl:when>
			<xsl:when test="$pText='nativendemic/uncommon'"></xsl:when>
			<xsl:when test="$pText='nativendemic/very local'"></xsl:when>
			<xsl:when test="$pText='nativendemic/very locally comm'"></xsl:when>
			<xsl:when test="$pText='nativendemic/very rare'"></xsl:when>
			<xsl:when test="$pText='nativendemic/widely scattered'"></xsl:when>
			<xsl:when test="$pText='nativendemic?'"></xsl:when>
			<xsl:when test="$pText='nativendmic'"></xsl:when>
			<xsl:when test="$pText='No'">Absent;</xsl:when>
			<xsl:when test="$pText='no?'"></xsl:when>
			<xsl:when test="$pText='North and South native'">Present in wild;Indigenous</xsl:when>
			<xsl:when test="$pText='North and South nativendemic'">Present in wild;Endemic</xsl:when>
			<xsl:when test="$pText='North and South'"></xsl:when>
			<xsl:when test="$pText='North native'"></xsl:when>
			<xsl:when test="$pText='North nativendemic'"></xsl:when>
			<xsl:when test="$pText='North'"></xsl:when>
			<xsl:when test="$pText='Philippines'"></xsl:when>
			<xsl:when test="$pText='rare native'"></xsl:when>
			<xsl:when test="$pText='rare'"></xsl:when>
			<xsl:when test="$pText='South native'"></xsl:when>
			<xsl:when test="$pText='South nativendemic'"></xsl:when>
			<xsl:when test="$pText='South'"></xsl:when>
			<xsl:when test="$pText='Trinidad'"></xsl:when>
			<xsl:when test="$pText='Ven'"></xsl:when>
			<xsl:when test="$pText='W. Africa'"></xsl:when>
			<xsl:when test="$pText='Yes'"></xsl:when>
			<xsl:when test="$pText='yes?'"></xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>

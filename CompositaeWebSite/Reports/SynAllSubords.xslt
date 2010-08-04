<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="/">
		<html>
			<body>
				<h3>Subordinates Report</h3>
				<p style="line-height:0">&#160;</p>
				<xsl:apply-templates select="NewDataSet/Table"/>

			</body>
		</html>
	</xsl:template>

	<xsl:template match="NewDataSet/Table">
		<p style="line-height:0">
			<b>Name: </b>
			<xsl:value-of select="NameFull"/>
		</p>
		<p style="line-height:0">
			<b>Rank: </b>
			<xsl:value-of select="NameRank"/>
		</p>
		<p style="line-height:0">
			<b>Status: </b>
			<xsl:choose>
				<xsl:when test="NamePreferredFk = NameGuid | NamePreferredFk = ''">
					Preferred Name
				</xsl:when>
				<xsl:otherwise>
					Synonym of <xsl:value-of select="NamePreferred"/>
				</xsl:otherwise>
			</xsl:choose>
		</p>
		<p style="line-height:0">
			<b>Subordinates:</b>
		</p>
		<xsl:variable name="id" select="NameGuid"></xsl:variable>
		<xsl:if test="count(/NewDataSet/Table[NameParentFk=$id]) > 0">
			<ul>
				<xsl:for-each select="/NewDataSet/Table[NameParentFk=$id]">
					<xsl:call-template name="DisplaySubord">
						<xsl:with-param name="NameId" select="NameGuid"/>
					</xsl:call-template>
				</xsl:for-each>
			</ul>
		</xsl:if>
		<p style="line-height:0">
			<b>Synonyms:</b>
		</p>
		<xsl:if test="count(/NewDataSet/Table[NamePreferredFk=$id]) > 0">
			<ul>
				<xsl:for-each select="/NewDataSet/Table1[NamePreferredFk=$id]">
					<xsl:call-template name="DisplaySynonym">
						<xsl:with-param name="NameId" select="NameGuid"/>
					</xsl:call-template>
				</xsl:for-each>
			</ul>
		</xsl:if>
		<p style="line-height:0">&#160;</p>
	</xsl:template>

	<xsl:template name="DisplaySubord">
		<xsl:param name="NameId"></xsl:param>
		<li>
			<xsl:value-of select="NameFull"/>  (Rank = <xsl:value-of select="NameRank"/>)
		</li>
	</xsl:template>

	<xsl:template name="DisplaySynonym">
		<xsl:param name="NameId"></xsl:param>
		<li>
			<xsl:choose>
				<xsl:when test="NamePreferredFk = NameGuid | NamePreferredFk = ''">
					<xsl:value-of select="NameFull"/>  (Rank = <xsl:value-of select="NameRank"/>)
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="NameFull"/> = <xsl:value-of select="NamePreferred"/>  (Rank = <xsl:value-of select="NameRank"/>)
				</xsl:otherwise>
			</xsl:choose>
		</li>
	</xsl:template>
	
</xsl:stylesheet>

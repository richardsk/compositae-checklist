<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method = "xml" omit-xml-declaration="no" standalone="no" indent="yes"  />

	<xsl:template match="/">
		<DataSet>
			<!-- This is test data only -->
			<xsl:apply-templates />
		</DataSet>
	</xsl:template>

	<xsl:template match="TestRefs/Reference">
		<tblProviderReference>
			<PRReferenceId><xsl:value-of select="RefId" /></PRReferenceId>
			<PRCitation><xsl:value-of select="Citation"/></PRCitation>			
		</tblProviderReference>
		
		<xsl:if test="count(Author)>0 or count(Title)>0">
			<tblProviderRIS>
				<PRISId><xsl:value-of select="RefId" /></PRISId>
				<PRISAuthors><xsl:value-of select="Author"/></PRISAuthors>
				<PRISTitle><xsl:value-of select="Title"/></PRISTitle>
				<PRISStartPage><xsl:value-of select="StartPage"/></PRISStartPage>
				<PRISEndPage><xsl:value-of select="EndPage"/></PRISEndPage>
			</tblProviderRIS>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>

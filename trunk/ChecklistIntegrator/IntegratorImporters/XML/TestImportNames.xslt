<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method = "xml" omit-xml-declaration="no" standalone="no" indent="yes"  />
	
	<xsl:template match="/">
		<DataSet>
			<!-- This is test data only -->
			<xsl:apply-templates />								
		</DataSet>
	</xsl:template>
	
	<xsl:template match="TestNames/Name">
		<tblProviderName>	
		    <PNProviderUpdatedDate><xsl:value-of select="Updated" /></PNProviderUpdatedDate>
		    <PNProviderAddedDate><xsl:value-of select="Added" /></PNProviderAddedDate>
		    <PNNameId><xsl:value-of select="Id" /></PNNameId>
		    <PNNameFull><xsl:value-of select="Name" /></PNNameFull>
		    <PNNameRank><xsl:value-of select="Rank" /></PNNameRank>
		    <PNNameCanonical><xsl:value-of select="Canonical" /></PNNameCanonical>
		    <PNNameAuthors><xsl:value-of select="Authors" /></PNNameAuthors>
		    <PNYear><xsl:value-of select="Year" /></PNYear>	
		    <PNNotes><xsl:value-of select="Notes" /></PNNotes>
		</tblProviderName>
		<xsl:if test="count(CurrentNameId)>0">
			<tblProviderConcept>
				<PCConceptId><xsl:number count="tblProviderConcept" value="position()"/></PCConceptId>
				<PCName2><xsl:value-of select="Name" /></PCName2>
				<PCName1Id><xsl:value-of select="Id" /></PCName1Id>
				<PCName2Id><xsl:value-of select="CurrentNameId" /></PCName2Id>
				<PCAccordingTo><xsl:value-of select="CurrentAccTo"/></PCAccordingTo>
				<PCRelationship>has preferred name</PCRelationship>
			</tblProviderConcept>
		</xsl:if>
  </xsl:template>
</xsl:stylesheet>
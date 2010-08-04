<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
	<DataSet>
		<Publications>
			<xsl:apply-templates select="NewDataSet/Reference"/>
		</Publications>
		<TaxonNames>
			<xsl:apply-templates select="NewDataSet/Name"/>
		</TaxonNames>
		<TaxonConcepts>
			<TasonConcept id="1">
				<Name>
					<xsl:attribute name="ref">
						<xsl:value-of select="NewDataSet/Name/PNNameId"/>
					</xsl:attribute>
					<xsl:attribute name="scientific">true</xsl:attribute>
				</Name>
				<AccordingTo>
					<Simple>
						TICA ??
					</Simple>
				</AccordingTo>
				<TaxonRelationships>
					<TaxonRelationship type="is provider record for">
						<ToTaxonConcept ref="2"/>						
					</TaxonRelationship>
				</TaxonRelationships>
			</TasonConcept>
			<TaxonConcept id="2">
				<Name>
					<xsl:attribute name="ref">
						<xsl:value-of select="NewDataSet/Name/PNNameFk"/>
					</xsl:attribute>
					<xsl:attribute name="scientific">true</xsl:attribute>					
				</Name>
			</TaxonConcept>
			<xsl:apply-templates select="NewDataSet/Concept"/>
		</TaxonConcepts>
	</DataSet>
</xsl:template>

<xsl:template match="NewDataSet/Reference">
	<Publication>
		<xsl:attribute name="id">
			<xsl:value-of select="PRReferenceId"/>
		</xsl:attribute>
		<Simple>
			<xsl:value-of select="PRCitation"/>
		</Simple>
	</Publication>
</xsl:template>

<xsl:template match="NewDataSet/Name">
	<TaxonName>
		<xsl:attribute name="id">
			<xsl:value-of select="PNNameId"/>
		</xsl:attribute>
		<xsl:attribute name="nomenclaturalCode">Botanical</xsl:attribute>
		<Simple>
			<xsl:value-of select="PNNameFull"/>
		</Simple>
		<Rank>
			<xsl:value-of select="PNNameRank"/>
		</Rank>
		<CanonicalName>
			<Simple>
				<xsl:value-of select="substring(PNNameFull, 1, string-length(PNNameFull) - string-length(PNNameAuthors))"/>
			</Simple>
			<xsl:choose>
				<xsl:when test="NameRankSort &lt; 3001">
					<Uninomial>
						<xsl:value-of select="PNNameCanonical"/>
					</Uninomial>
				</xsl:when>
				<xsl:otherwise>
					<Genus>
						<xsl:value-of select="substring-before(PNNameFull, ' ')"/>
					</Genus>
					<xsl:choose>
						<xsl:when test="NameRankSort &gt; 4200">
							<SpecificEpithet>
								<xsl:value-of select="substring-before(substring-after(PNNameFull, ' '), ' ')"/>
							</SpecificEpithet>
							<InfraspecificEpithet>
								<xsl:value-of select="PNNameCanonical"/>
							</InfraspecificEpithet>
						</xsl:when>
						<xsl:otherwise>
							<SpecificEpithet>
								<xsl:value-of select="PNNameCanonical"/>
							</SpecificEpithet>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</CanonicalName>
		<CanonicalAuthorship>
			<Simple>
				<xsl:value-of select="PNNameAuthors"/>
			</Simple>
			<Authorship>
				TODO - Is this right? List of authors?
				<Simple>
					<xsl:value-of select="PNNameAuthors"/>
				</Simple>
			</Authorship>
		</CanonicalAuthorship>
		<xsl:if test="PNReferenceId != ''">
			<PublishedIn>
				<xsl:attribute name="ref">
					<xsl:value-of select="PNReferenceId"/>
				</xsl:attribute>
			</PublishedIn>
		</xsl:if>
		<Year>
			<xsl:value-of select="PNYear"/>
		</Year>
		<MicroReference>
			<xsl:value-of select="PNMicroReference"/>
		</MicroReference>
		<xsl:if test="PNTypeNameId != ''">
			<Typification>
				<TypeName>
					<NameReference>
						<xsl:attribute name="ref">
							<xsl:value-of select="PNTypeNameId"/>
						</xsl:attribute>
					</NameReference>
				</TypeName>
			</Typification>
		</xsl:if>
		<xsl:if test="PNBasionymId != ''">
			<Basionym>
				<RelatedName>
					<xsl:attribute name="ref">
						<xsl:value-of select="PNBasionymId"/>
					</xsl:attribute>
				</RelatedName>
			</Basionym>
		</xsl:if>
		<xsl:if test="PNBasedOnId != ''">
			<BasedOn>
				<RelatedName>
					<xsl:attribute name="ref">
						<xsl:value-of select="PNBasedOnId"/>
					</xsl:attribute>
				</RelatedName>
			</BasedOn>
		</xsl:if>
		<xsl:if test="PNConservedAgainstId != ''">
			<ConservedAgainst>
				<RelatedName>
					<xsl:attribute name="ref">
						<xsl:value-of select="PNConservedAgainstId"/>
					</xsl:attribute>
				</RelatedName>
			</ConservedAgainst>
		</xsl:if>
		<xsl:if test="PNHomonymOfId != ''">
			<HomonymOf>
				<RelatedName>
					<xsl:attribute name="ref">
						<xsl:value-of select="PNHomonymOfId"/>
					</xsl:attribute>
				</RelatedName>
			</HomonymOf>
		</xsl:if>
		<xsl:if test="PNReplacementForId != ''">
			<ReplacementFor>
				<RelatedName>
					<xsl:attribute name="ref">
						<xsl:value-of select="PNReplacementForId"/>
					</xsl:attribute>
				</RelatedName>
			</ReplacementFor>
		</xsl:if>
	</TaxonName>
</xsl:template>

	<xsl:template match="NewDataSet/Concept">
		<TaxonConcept>
			<xsl:attribute name="id">
				<xsl:value-of select="PCConceptId"/>
			</xsl:attribute>
			<Name>
				<xsl:attribute name="ref">
					<xsl:value-of select="PCName1Id"/>
				</xsl:attribute>
				<xsl:attribute name="scientific">true</xsl:attribute>
			</Name>
			<xsl:if test="PCAccordingToId != ''">
				<AccordingTo>
					<Simple>
						<xsl:value-of select="PCAccordingTo"/>
					</Simple>
					<AccordingToDetailed>
						<PublishedIn>
							<xsl:attribute name="ref">
								<xsl:value-of select="PCAccordingToId"/>
							</xsl:attribute>
						</PublishedIn>
					</AccordingToDetailed>
				</AccordingTo>
			</xsl:if>
			<TaxonRelationships>
				<TaxonRelationship>
					<xsl:attribute name="type">
						<xsl:value-of select="PCRelationship"/>
					</xsl:attribute>
					<ToTaxonConcept>
						<xsl:attribute name="ref">
							TODO ConceptPk of ToConcept ??
						</xsl:attribute>
					</ToTaxonConcept>
				</TaxonRelationship>
			</TaxonRelationships>
		</TaxonConcept>
	</xsl:template>
	
</xsl:stylesheet> 


<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns="http://www.compositae.org/schemas/TCS_Compositae"  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >
<xsl:output method="xml" encoding="utf-8"/>
	<xsl:template match="/">
		<DataSet>
		
			<!--xsl:attribute name="xsi:schemaLocation">http://www.compositae.org/schemas/TCS_Compositae D:\Documents\COMPOS~1\TICA\TCS_Compositae.xsd</xsl:attribute-->
			<xsl:attribute name="xsi:schemaLocation">http://www.compositae.org/schemas/TCS_Compositae http://compositae.landcareresearch.co.nz/schema/TCS_Compositae.xsd</xsl:attribute>
			<MetaData>
				<MetaDataDetailed>
					<ExportDate><xsl:value-of select="NewDataSet/@exportDate"/></ExportDate>
					<Providers>
						<xsl:call-template name="ProcessProviders"/>
					</Providers>
				</MetaDataDetailed>
			</MetaData>
			<xsl:if test="count(//NewDataSet/Reference) &gt; 0 or count(//NewDataSet/ProviderReference) &gt; 0">
				<Publications>
					<xsl:call-template name="ProcessReference"/>
					<xsl:call-template name="ProcessProviderReference"/>
				</Publications>
			</xsl:if>
			<xsl:if test="count(//NewDataSet/Name) &gt; 0 or count(//NewDataSet/ProviderName) &gt; 0">
				<TaxonNames>
					<xsl:call-template name="ProcessName"/>
					<xsl:call-template name="ProcessProviderName"/>
				</TaxonNames>
			</xsl:if>
			<xsl:if test="count(//Concept) &gt; 0 or count(//ProviderConcept) &gt; 0">
				<TaxonConcepts>
					<xsl:call-template name="ProcessConcept"/>
					<xsl:call-template name="ProcessProviderConcept"/>
				</TaxonConcepts>
			</xsl:if>
		</DataSet>
	</xsl:template>
	<xsl:template name="ProcessProviders">
		<xsl:for-each select="//NewDataSet/Provider">
			<xsl:sort select="ProviderPk"/>
			<xsl:variable name="varProviderID">
				<xsl:value-of select="ProviderPk"/>
			</xsl:variable>
			<xsl:variable name="varUsedName">
				<xsl:value-of select="//ProviderName[ProviderPk=$varProviderID][position()=1]/PNPk"/>
			</xsl:variable>
			<xsl:variable name="varUsedConcept">
				<xsl:value-of select="//ProviderConcept[ProviderPk=$varProviderID][position()=1]/PCPk"/>
			</xsl:variable>
			<xsl:variable name="varUsedRef">
				<xsl:value-of select="//ProviderReference[ProviderPk=$varProviderID][position()=1]/PRPk"/>
			</xsl:variable>
			<xsl:variable name="varUsedTest">
				<xsl:value-of select="$varUsedName"/>
				<xsl:value-of select="$varUsedConcept"/>
				<xsl:value-of select="$varUsedRef"/>
			</xsl:variable>
			<xsl:if test="$varUsedTest !=''">
				<Provider>
					<xsl:attribute name="id"><xsl:value-of select="ProviderPk"/></xsl:attribute>
					<ProviderName>
						<xsl:value-of select="ProviderName"/>
					</ProviderName>
					<xsl:if test="ProviderHomeUrl !=''">
						<ProviderHomeUrl>
							<xsl:value-of select="ProviderHomeUrl"/>
						</ProviderHomeUrl>
					</xsl:if>
					<xsl:if test="ProviderProjectUrl !=''">
						<ProviderProjectUrl>
							<xsl:value-of select="ProviderProjectUrl"/>
						</ProviderProjectUrl>
					</xsl:if>
					<xsl:if test="ProviderContactName !=''">
						<ProviderContactName>
							<xsl:value-of select="ProviderContactName"/>
						</ProviderContactName>
					</xsl:if>
					<xsl:if test="ProviderContactEmail !=''">
						<ProviderContactEmail>
							<xsl:value-of select="ProviderContactEmail"/>
						</ProviderContactEmail>
					</xsl:if>
					<xsl:if test="ProviderContactAddress !=''">
						<ProviderContactAddress>
							<xsl:value-of select="ProviderContactAddress"/>
						</ProviderContactAddress>
					</xsl:if>
					<xsl:if test="ProviderNameFull !=''">
						<ProviderNameFull>
							<xsl:value-of select="ProviderNameFull"/>
						</ProviderNameFull>
					</xsl:if>
				</Provider>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="ProcessReference">
		<xsl:for-each select="//NewDataSet/Reference">
			<xsl:variable name="varRefGuid"><xsl:value-of select="ReferenceLSID"/></xsl:variable>
			<Publication>
				<xsl:attribute name="id"><xsl:value-of select="ReferenceLSID"/></xsl:attribute>
				<Simple>
					<xsl:value-of select="ReferenceCitation"/>
				</Simple>
				<PublicationDetailed>
					<xsl:for-each select="//ReferenceRIS[RISReferenceFk=$varRefGuid]">
						<Titles>
							<Title>
								<xsl:attribute name="level"><xsl:value-of select="RISType"/></xsl:attribute>
								<xsl:value-of select="RISTitle"/>
							</Title>
							<xsl:if test="RISJournalName !=''">
								<Title><xsl:attribute name="level">JOURNAL</xsl:attribute><xsl:value-of select="RISJournalName"/></Title>
							</xsl:if>
							<xsl:if test="RISTitle2 !=''">
								<Title><xsl:attribute name="level">3</xsl:attribute><xsl:value-of select="RISTitle2"/></Title>
							</xsl:if>
							<xsl:if test="RISTitle3 !=''">
								<Title><xsl:attribute name="level">4</xsl:attribute><xsl:value-of select="RISTitle3"/></Title>
							</xsl:if>
						</Titles>
						<xsl:if test="RISAuthors !=''">
							<Authors>
								<Simple><xsl:value-of select="RISAuthors"/></Simple>
							</Authors>
						</xsl:if>
						<xsl:if test="RISDate !=''">
							<Dates><Date><xsl:value-of select="RISDate"/></Date></Dates>
						</xsl:if>
						<xsl:if test="RISVolume !=''">
							<Volume><xsl:value-of select="RISVolume"/></Volume>
						</xsl:if>
						<xsl:if test="RISIssue !='' and RISIssue!=' '">
							<Issue><xsl:value-of select="RISIssue"/></Issue>
						</xsl:if>
						<xsl:if test="RISEdition !=''">
							<Edition><xsl:value-of select="RISEdition"/></Edition>
						</xsl:if>
						<xsl:if test="RISStartPage !='' or RISEndPage !=''">
							<Pages>
								<xsl:if test="RISStartPage !=''">
									<Page><xsl:attribute name="type">start</xsl:attribute><xsl:value-of select="RISStartPage"/></Page>
								</xsl:if>
								<xsl:if test="RISEndPage !=''">
									<Page><xsl:attribute name="type">end</xsl:attribute><xsl:value-of select="RISEndPage"/></Page>
								</xsl:if>
							</Pages>
						</xsl:if>
						<xsl:if test="RISCityOfPublication !='' or RISPublisher !=''">
							<Publisher>
								<xsl:if test="RISPublisher !=''">
									<Name><xsl:value-of select="RISPublisher"/></Name>
								</xsl:if>
								<xsl:if test="RISCityOfPublication !=''">
									<City><xsl:value-of select="RISCityOfPublication"/></City>
								</xsl:if>
							</Publisher>
						</xsl:if>
						<xsl:if test="RISWebUrl !=''">
							<Links><Link><xsl:attribute name="type">url</xsl:attribute><xsl:value-of select="RISWebUrl"/></Link></Links>
						</xsl:if>
					</xsl:for-each>
					<PublicationMetadata>
						<RecordType><xsl:attribute name="type">consensus</xsl:attribute></RecordType>
						<PublicationRecordCreation>
							<xsl:attribute name="date"><xsl:value-of select="ReferenceCreatedDate"/></xsl:attribute>
							<xsl:attribute name="createdBy"><xsl:value-of select="ReferenceCreatedBy"/></xsl:attribute>
						</PublicationRecordCreation>
						<xsl:if test="ReferenceUpdatedDate !=''">
							<PublicationRecordUpdate>
								<xsl:attribute name="date"><xsl:value-of select="ReferenceUpdatedDate"/></xsl:attribute>
								<xsl:attribute name="updatedBy"><xsl:value-of select="ReferenceUpdatedBy"/></xsl:attribute>
							</PublicationRecordUpdate>
						</xsl:if>
					</PublicationMetadata>
				</PublicationDetailed>
			</Publication>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="ProcessProviderReference">
		<xsl:for-each select="//ProviderReference">
			<xsl:variable name="varRefID"><xsl:value-of select="PRPk"/></xsl:variable>
			<Publication>
				<xsl:attribute name="id"><xsl:value-of select="PRPk"/></xsl:attribute>
				<Simple><xsl:value-of select="PRCitation"/></Simple>
				<PublicationDetailed>
					<xsl:for-each select="ProviderReferenceRIS[PRISProviderReferenceFK = $varRefID]">
						<Titles>
							<Title>
								<xsl:attribute name="level"><xsl:value-of select="PRISType"/></xsl:attribute>
								<xsl:value-of select="RISTitle"/>
							</Title>
							<xsl:if test="PRISJournalName !=''">
								<Title><xsl:attribute name="level">JOURNAL</xsl:attribute><xsl:value-of select="PRISJournalName"/></Title>
							</xsl:if>
							<xsl:if test="PRISTitle2 !=''">
								<Title><xsl:attribute name="level">3</xsl:attribute><xsl:value-of select="PRISTitle2"/></Title>
							</xsl:if>
							<xsl:if test="PRISTitle3 !=''">
								<Title><xsl:attribute name="level">4</xsl:attribute><xsl:value-of select="PRISTitle3"/></Title>
							</xsl:if>
						</Titles>
						<xsl:if test="PRISAuthors !=''">
							<Authors>
								<Simple><xsl:value-of select="PRISAuthors"/></Simple>
							</Authors>
						</xsl:if>
						<xsl:if test="PRISDate !=''">
							<Dates><Date><xsl:value-of select="PRISDate"/></Date></Dates>
						</xsl:if>
						<xsl:if test="PRISVolume !=''">
							<Volume><xsl:value-of select="PRISVolume"/></Volume>
						</xsl:if>
						<xsl:if test="PRISIssue !=''">
							<Issue><xsl:value-of select="PRISIssue"/></Issue>
						</xsl:if>
						<xsl:if test="PRISEdition !=''">
							<Edition><xsl:value-of select="PRISEdition"/></Edition>
						</xsl:if>
						<xsl:if test="PRISStartPage !='' or PRISEndPage !=''">
							<Pages>
								<xsl:if test="PRISStartPage !=''">
									<Page><xsl:attribute name="type">start</xsl:attribute><xsl:value-of select="PRISStartPage"/></Page>
								</xsl:if>
								<xsl:if test="PRISEndPage !=''">
									<Page><xsl:attribute name="type">end</xsl:attribute><xsl:value-of select="PRISEndPage"/></Page>
								</xsl:if>
							</Pages>
						</xsl:if>
						<xsl:if test="PRISCityOfPublication !='' or PRISPublisher !=''">
							<Publisher>
								<xsl:if test="PRISPublisher !=''">
									<Name><xsl:value-of select="PRISPublisher"/></Name>
								</xsl:if>
								<xsl:if test="PRISCityOfPublication !=''">
									<City><xsl:value-of select="PRISCityOfPublication"/></City>
								</xsl:if>
							</Publisher>
						</xsl:if>
						<xsl:if test="PRISWebUrl !=''">
							<Links><Link><xsl:attribute name="type">url</xsl:attribute><xsl:value-of select="PRISWebUrl"/></Link></Links>
						</xsl:if>
					</xsl:for-each>
					<PublicationMetadata>
						<RecordType>
							<xsl:attribute name="type">
								<xsl:choose>
									<xsl:when test="ProviderIsEditor='true'">editor</xsl:when>
									<xsl:otherwise>provider</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
						</RecordType>
						<IsProviderRecordFor>
							<xsl:attribute name="ref"><xsl:value-of select="PRReferenceFk"/></xsl:attribute>
							<xsl:attribute name="matchType"><xsl:value-of select="PRLinkStatus"/></xsl:attribute>
						</IsProviderRecordFor>
						<PublicationRecordCreation>
							<xsl:attribute name="date"><xsl:value-of select="PRCreatedDate"/></xsl:attribute>
							<xsl:attribute name="createdBy"><xsl:value-of select="PRCreatedBy"/></xsl:attribute>
						</PublicationRecordCreation>
						<PublicationRecordUpdate>
							<xsl:attribute name="date"><xsl:value-of select="PRUpdatedDate"/></xsl:attribute>
							<xsl:attribute name="updatedBy"><xsl:value-of select="PRUpdatedBy"/></xsl:attribute>
						</PublicationRecordUpdate>
						<OriginalProviderId>
							<xsl:attribute name="id"><xsl:value-of select="PRReferenceId"/></xsl:attribute>
							<xsl:attribute name="ref"><xsl:value-of select="ProviderPk"/></xsl:attribute>
						</OriginalProviderId>
					</PublicationMetadata>
				</PublicationDetailed>				
			</Publication>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="ProcessName">
		<xsl:for-each select="//NewDataSet/Name">
			<TaxonName>
				<xsl:attribute name="id"><xsl:value-of select="NameLSID"/></xsl:attribute>
				<xsl:attribute name="nomenclaturalCode">Botanical</xsl:attribute>
				<Simple>
					<xsl:value-of select="NameFull"/>
				</Simple>
				<Rank>
					<xsl:attribute name="code"><xsl:value-of select="NameRankTCS"/></xsl:attribute>
					<xsl:value-of select="NameRank"/>
				</Rank>
				<CanonicalName>
					<Simple>
						<xsl:value-of select="NameFull"/>
					</Simple>
					<xsl:choose>
						<xsl:when test="NameRankSort &lt; 3001">
							<Uninomial>
								<xsl:value-of select="NameCanonical"/>
							</Uninomial>
						</xsl:when>
						<xsl:otherwise>
							<Genus>
								<xsl:value-of select="substring-before(NameFull, ' ')"/>
							</Genus>
							<xsl:choose>
								<xsl:when test="NameRankSort &gt; 4200">
									<SpecificEpithet>
										<xsl:value-of select="substring-before(substring-after(NameFull, ' '), ' ')"/>
									</SpecificEpithet>
									<InfraspecificEpithet>
										<xsl:value-of select="NameCanonical"/>
									</InfraspecificEpithet>
								</xsl:when>
								<xsl:otherwise>
									<SpecificEpithet>
										<xsl:value-of select="NameCanonical"/>
									</SpecificEpithet>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</CanonicalName>
				<CanonicalAuthorship>
					<Simple>
						<xsl:value-of select="NameAuthors"/>
					</Simple>
					<xsl:if test="NameBasionymAuthors !=''">
						<BasionymAuthorship>
							<Simple>
								<xsl:value-of select="NameBasionymAuthors"/>
							</Simple>
						</BasionymAuthorship>
					</xsl:if>
					<xsl:if test="NameCombinationAuthors != ''">
						<CombinationAuthorship>
							<Simple>
								<xsl:value-of select="NameCombinationAuthors"/>
							</Simple>
						</CombinationAuthorship>
					</xsl:if>
				</CanonicalAuthorship>
				<xsl:variable name="vCR1">
					<xsl:call-template name="testRefLink">
						<xsl:with-param name="pRefId">
							<xsl:value-of select="NameReferenceFk"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:variable>
				<xsl:if test="NamePublishedIn != ''">
					<PublishedIn>
						<xsl:attribute name="ref"><xsl:value-of select="NameReferenceFk"/></xsl:attribute>
						<xsl:attribute name="linkType"><xsl:value-of select="$vCR1"/></xsl:attribute>
						<xsl:value-of select="NamePublishedIn"/>
					</PublishedIn>
				</xsl:if>
				<xsl:if test="NameYear !=''">
					<Year>
						<xsl:value-of select="NameYear"/>
					</Year>
				</xsl:if>
				<MicroReference>
					<xsl:value-of select="NameMicroReference"/>
				</MicroReference>
				<xsl:if test="NameTypeNameFk != ''">
					<Typification>
						<TypeName>
							<NameReference>
								<xsl:attribute name="ref"><xsl:value-of select="NameTypeNameFk"/></xsl:attribute>
							</NameReference>
						</TypeName>
					</Typification>
				</xsl:if>
				<xsl:if test="NameOrthography !=''">
					<SpellingCorrectionOf>
						<RelatedName>
							<xsl:value-of select="NameOrthography"/>
						</RelatedName>
					</SpellingCorrectionOf>
				</xsl:if>
				<xsl:if test="NameBasionymFk != ''">
					<Basionym>
						<RelatedName>
							<xsl:attribute name="ref"><xsl:value-of select="NameBasionymFk"/></xsl:attribute>
							<xsl:value-of select="NameBasionym"/>
						</RelatedName>
					</Basionym>
				</xsl:if>
				<xsl:if test="NameBasedOnFk != ''">
					<BasedOn>
						<RelatedName>
							<xsl:attribute name="ref"><xsl:value-of select="NameBasedOnFk"/></xsl:attribute>
							<xsl:value-of select="NameBasedOn"/>
						</RelatedName>
					</BasedOn>
				</xsl:if>
				<xsl:if test="NameConservedAgainstFk != ''">
					<ConservedAgainst>
						<RelatedName>
							<xsl:attribute name="ref"><xsl:value-of select="NameConservedAgainstFk"/></xsl:attribute>
							<xsl:value-of select="NameConservedAgainst"/>
						</RelatedName>
					</ConservedAgainst>
				</xsl:if>
				<xsl:if test="NameHomonymOfFk != ''">
					<HomonymOf>
						<RelatedName>
							<xsl:attribute name="ref"><xsl:value-of select="NameHomonymOfFk"/></xsl:attribute>
							<xsl:value-of select="NameHomonymOf"/>
						</RelatedName>
					</HomonymOf>
				</xsl:if>
				<xsl:if test="NameReplacementForFk != ''">
					<ReplacementFor>
						<RelatedName>
							<xsl:attribute name="ref"><xsl:value-of select="NameReplacementForFk"/></xsl:attribute>
						</RelatedName>
					</ReplacementFor>
				</xsl:if>
				<xsl:variable name="varNomStatus">
					<xsl:value-of select="NameStatusNotes"/>
					<xsl:if test="NameInvalid='true'">Nom. Inval. </xsl:if>
					<xsl:if test="NameIllegitimate='true'">Nom. Illegl. </xsl:if>
					<xsl:if test="NameProParte='true'">Pro Parte </xsl:if>
				</xsl:variable>
				<xsl:if test="$varNomStatus !=''">
					<PublicationStatus>
						<Note>
							<xsl:value-of select="$varNomStatus"/>
						</Note>
					</PublicationStatus>
				</xsl:if>
				<ProviderSpecificData>
					<RecordType><xsl:attribute name="type">consensus</xsl:attribute></RecordType>
					<NameRecordCreation>
						<xsl:attribute name="date"><xsl:value-of select="NameCreatedDate"/></xsl:attribute>
						<xsl:attribute name="createdBy"><xsl:value-of select="NameCreatedBy"/></xsl:attribute>
					</NameRecordCreation>
					<NameRecordUpdate>
						<xsl:attribute name="date"><xsl:value-of select="NameUpdatedDate"/></xsl:attribute>
						<xsl:attribute name="updatedBy"><xsl:value-of select="NameUpdatedBy"/></xsl:attribute>
					</NameRecordUpdate>
				</ProviderSpecificData>
			</TaxonName>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="ProcessProviderName">
		<xsl:for-each select="//NewDataSet/ProviderName">
			<TaxonName>
				<xsl:attribute name="id"><xsl:value-of select="PNPk"/></xsl:attribute>
				<xsl:attribute name="nomenclaturalCode">Botanical</xsl:attribute>
				<Simple>
					<xsl:value-of select="PNNameFull"/>
				</Simple>
				<xsl:if test="PNRankTCS != '' or PNNameRank !=''">
					<Rank>
						<xsl:attribute name="code"><xsl:value-of select="PNRankTCS"/></xsl:attribute>
						<xsl:value-of select="PNNameRank"/>
					</Rank>
				</xsl:if>
				<CanonicalName>
					<Simple>
						<xsl:value-of select="PNNameCanonical"/>
					</Simple>
					<xsl:choose>
						<xsl:when test="PNRankSort &lt; 3001">
							<Uninomial>
								<xsl:value-of select="PNNameCanonical"/>
							</Uninomial>
						</xsl:when>
						<xsl:otherwise>
							<Genus>
								<xsl:value-of select="substring-before(PNNameFull, ' ')"/>
							</Genus>
							<xsl:choose>
								<xsl:when test="PNRankSort &gt; 4200">
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
					<xsl:if test="PNBasionymAuthors!=''">
						<BasionymAuthorship>
							<Simple>
								<xsl:value-of select="PNBasionymAuthors"/>
							</Simple>
						</BasionymAuthorship>
					</xsl:if>
					<xsl:if test="PNCombinationAuthors!=''">
						<CombinationAuthorship>
							<Simple>
								<xsl:value-of select="PNCombinationAuthors"/>
							</Simple>
						</CombinationAuthorship>
					</xsl:if>
				</CanonicalAuthorship>
				<xsl:variable name="vR1">
					<xsl:call-template name="testPRRefLink">
						<xsl:with-param name="pRefId">
							<xsl:value-of select="PNReferenceId"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:variable>
				<PublishedIn>
					<xsl:attribute name="ref"><xsl:value-of select="PNReferenceId"/></xsl:attribute>
					<xsl:attribute name="linkType"><xsl:value-of select="$vR1"/></xsl:attribute>
					<xsl:value-of select="PNPublishedIn"/>
				</PublishedIn>
				<xsl:if test="PNYear !=''">
					<Year>
						<xsl:value-of select="PNYear"/>
					</Year>
				</xsl:if>
				<MicroReference>
					<xsl:value-of select="PNMicroReference"/>
				</MicroReference>
				<xsl:if test="PNTypeName !=''">
					<Typification>
						<TypeName>
							<NameReference>
								<xsl:attribute name="ref"><xsl:value-of select="PNTypeNameId"/></xsl:attribute>
								<xsl:attribute name="linkType"><xsl:call-template name="testPRNameLink"><xsl:with-param name="pNameId"><xsl:value-of select="PNTypeNameId"/></xsl:with-param></xsl:call-template></xsl:attribute>
								<xsl:value-of select="PNTypeName"/>
							</NameReference>
						</TypeName>
					</Typification>
				</xsl:if>
				<xsl:if test="PNBasionym!=''">
					<Basionym>
						<RelatedName>
							<xsl:attribute name="ref"><xsl:value-of select="PNBasionymId"/></xsl:attribute>
							<xsl:attribute name="linkType"><xsl:call-template name="testPRNameLink"><xsl:with-param name="pNameId"><xsl:value-of select="PNBasionymId"/></xsl:with-param></xsl:call-template></xsl:attribute>
							<xsl:value-of select="PNBasionym"/>
						</RelatedName>
					</Basionym>
				</xsl:if>
				<xsl:if test="PNBasedOn!=''">
					<BasedOn>
						<RelatedName>
							<xsl:attribute name="ref"><xsl:value-of select="PNBasedId"/></xsl:attribute>
							<xsl:attribute name="linkType"><xsl:call-template name="testPRNameLink"><xsl:with-param name="pNameId"><xsl:value-of select="PNBasedId"/></xsl:with-param></xsl:call-template></xsl:attribute>
							<xsl:value-of select="PNBasedOn"/>
						</RelatedName>
					</BasedOn>
				</xsl:if>
				<xsl:variable name="varNomStatus">
					<xsl:value-of select="PNStatusNotes"/>
					<xsl:if test="PNInvalid='true'">Nom. Inval. </xsl:if>
					<xsl:if test="PNIllegitimate='true'">Nom. Illegl. </xsl:if>
					<xsl:if test="PNProParte='true'">Pro Parte </xsl:if>
				</xsl:variable>
				<xsl:if test="$varNomStatus !=''">
					<PublicationStatus>
						<Note><xsl:value-of select="$varNomStatus"/></Note>
					</PublicationStatus>
				</xsl:if>
				<ProviderSpecificData>
					<RecordType>
						<xsl:attribute name="type">
							<xsl:choose>
								<xsl:when test="ProviderIsEditor='true'">editor</xsl:when>
								<xsl:otherwise>provider</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
					</RecordType>
					<IsProviderRecordFor>
						<xsl:attribute name="ref"><xsl:value-of select="PNNameFk"/></xsl:attribute>
						<xsl:attribute name="matchType"><xsl:value-of select="PNLinkStatus"/></xsl:attribute>
					</IsProviderRecordFor>
					<NameRecordCreation>
						<xsl:attribute name="date"><xsl:value-of select="PNCreatedDate"/></xsl:attribute>
						<xsl:attribute name="createdBy"><xsl:value-of select="PNCreatedBy"/></xsl:attribute>
					</NameRecordCreation>
					<NameRecordUpdate>
						<xsl:attribute name="date"><xsl:value-of select="PNUpdatedDate"/></xsl:attribute>
						<xsl:attribute name="updatedBy"><xsl:value-of select="PNUpdatedBy"/></xsl:attribute>
					</NameRecordUpdate>
					<OriginalProviderId>
						<xsl:attribute name="id"><xsl:value-of select="PNNameId"/></xsl:attribute>
						<xsl:attribute name="version"><xsl:value-of select="PNNameVersion"/></xsl:attribute>
						<xsl:attribute name="ref"><xsl:value-of select="ProviderPk"/></xsl:attribute>
					</OriginalProviderId>
				</ProviderSpecificData>
			</TaxonName>
		</xsl:for-each>
	</xsl:template>
	

	<xsl:template name="ProcessConcept">
		<xsl:for-each select="//Concept">
			<TaxonConcept>
				<xsl:attribute name="id"><xsl:value-of select="ConceptLSID"/></xsl:attribute>
				<Name>
					<xsl:attribute name="ref"><xsl:value-of select="ConceptName1Fk"/></xsl:attribute>
					<xsl:attribute name="linkType">
						<xsl:call-template name="testNameLink">
							<xsl:with-param name="pNameId"><xsl:value-of select="ConceptName1Fk"/></xsl:with-param>
						</xsl:call-template>
					</xsl:attribute>
					<xsl:attribute name="scientific">true</xsl:attribute>
					<xsl:value-of select="ConceptName1"/>
				</Name>
				<xsl:if test="ConceptAccordingTo !='' or ConceptAccordingToFk !=''">
					<AccordingTo>
						<Simple>
							<xsl:value-of select="ConceptAccordingTo"/>
						</Simple>
						<xsl:if test="ConceptAccordingToFk !=''">
							<AccordingToDetailed>
								<PublishedIn>
									<xsl:attribute name="ref"><xsl:value-of select="ConceptAccordingToFk"/></xsl:attribute>
									<xsl:attribute name="linkType">
										<xsl:call-template name="testRefLink">
											<xsl:with-param name="pRefId">
												<xsl:value-of select="ConceptAccordingToFk"/>
											</xsl:with-param>
										</xsl:call-template>
									</xsl:attribute>
									<xsl:value-of select="ConceptAccordingTo"/>
								</PublishedIn>
							</AccordingToDetailed>
						</xsl:if>
					</AccordingTo>
				</xsl:if>
				<xsl:variable name="varConcept1ID"><xsl:value-of select="ConceptPk"/></xsl:variable>				
				<xsl:if test="//ConceptRelationship[ConceptRelationshipConcept1Fk=$varConcept1ID][position()=1]/ConceptGuid !=''">
					<TaxonRelationships>
						<xsl:for-each select="//ConceptRelationship[ConceptRelationshipConcept1Fk=$varConcept1ID]">
							<xsl:variable name="varConcept2ID"><xsl:value-of select="ConceptRelationshipConcept2Fk"/></xsl:variable>
							<TaxonRelationship>
								<xsl:attribute name="type">
									<xsl:call-template name="correctRelationship">
										<xsl:with-param name="parRelType"><xsl:value-of select="ConceptRelationshipRelationship"/></xsl:with-param>
									</xsl:call-template>
								</xsl:attribute>
								<ToTaxonConcept>
									<xsl:attribute name="ref">
										<xsl:value-of select="//Concept[ConceptPk=$varConcept2ID]/ConceptLSID"/>
									</xsl:attribute>
									<xsl:attribute name="linkType">
										<xsl:call-template name="testConceptLink">
											<xsl:with-param name="pConceptId"><xsl:value-of select="$varConcept2ID"/></xsl:with-param>
										</xsl:call-template>
									</xsl:attribute>
									<xsl:value-of select="//Concept[ConceptPk=$varConcept2ID]/ConceptName1"/>
								</ToTaxonConcept>
							</TaxonRelationship>
						</xsl:for-each>
					</TaxonRelationships>
				</xsl:if>
				<ProviderSpecificData>
					<RecordType><xsl:attribute name="type">consensus</xsl:attribute></RecordType>
					<ConceptRecordCreation>
						<xsl:attribute name="date"><xsl:value-of select="ConceptCreatedDate"/></xsl:attribute>
						<xsl:attribute name="createdBy"><xsl:value-of select="ConceptCreatedBy"/></xsl:attribute>
					</ConceptRecordCreation>
					<xsl:if test="ConceptUpdatedDate !=''">
						<ConceptRecordUpdate>
							<xsl:attribute name="date"><xsl:value-of select="ConceptUpdatedDate"/></xsl:attribute>
							<xsl:attribute name="updatedBy"><xsl:value-of select="ConceptUpdatedBy"/></xsl:attribute>
						</ConceptRecordUpdate>
					</xsl:if>
				</ProviderSpecificData>
			</TaxonConcept>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="ProcessProviderConcept">
		<xsl:for-each select="//ProviderConcept">
			<TaxonConcept>
				<xsl:attribute name="id"><xsl:value-of select="PCPk"/></xsl:attribute>
				<Name>
					<xsl:attribute name="ref"><xsl:value-of select="PNPk"/></xsl:attribute>
					<xsl:attribute name="linkType">
						<xsl:call-template name="testPRNameLink">
							<xsl:with-param name="pNameId"><xsl:value-of select="PNPk"/></xsl:with-param>
						</xsl:call-template>
					</xsl:attribute>
					<xsl:attribute name="scientific">true</xsl:attribute>
					<xsl:value-of select="PCName1"/>
				</Name>
				<xsl:if test="PCAccordingTo !='' or PRPk !=''">
					<AccordingTo>
						<Simple><xsl:value-of select="PCAccordingTo"/></Simple>
						<AccordingToDetailed>
							<PublishedIn>
								<xsl:attribute name="ref"><xsl:value-of select="PRPk"/></xsl:attribute>
								<xsl:attribute name="linkType">
									<xsl:call-template name="testPRRefLink">
										<xsl:with-param name="pRefId"><xsl:value-of select="PRPk"/></xsl:with-param>
									</xsl:call-template>
								</xsl:attribute>
								<xsl:value-of select="PCAccordingTo"/>
							</PublishedIn>
						</AccordingToDetailed>
					</AccordingTo>
				</xsl:if>
				<xsl:variable name="varPCPK"><xsl:value-of select="PCPk"/></xsl:variable>
				<xsl:if test="//ProviderConceptRelationship[PCPk = $varPCPK][position()=1]/PCPk !=''">
					<TaxonRelationships>
					<xsl:for-each select="//ProviderConceptRelationship[PCPk = $varPCPK]">
						<TaxonRelationship>
							<xsl:attribute name="type">
								<xsl:call-template name="correctRelationship">
									<xsl:with-param name="parRelType"><xsl:value-of select="PCRRelationship"/></xsl:with-param>
								</xsl:call-template>
							</xsl:attribute>
							<ToTaxonConcept>
								<xsl:attribute name="ref"><xsl:value-of select="PCPk2"/></xsl:attribute>
								<xsl:attribute name="linkType">
									<xsl:call-template name="testPRConceptLink">
										<xsl:with-param name="pConceptId"><xsl:value-of select="PCPk2"/></xsl:with-param>
									</xsl:call-template>
								</xsl:attribute>
							</ToTaxonConcept>
						</TaxonRelationship>
					</xsl:for-each>		
					</TaxonRelationships>	
				</xsl:if>
				<ProviderSpecificData>
					<RecordType>
						<xsl:attribute name="type">
							<xsl:choose>
								<xsl:when test="ProviderIsEditor='true'">editor</xsl:when>
								<xsl:otherwise>provider</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
					</RecordType>
					<IsProviderRecordFor>
						<xsl:attribute name="ref"><xsl:value-of select="PCConceptLSID"/></xsl:attribute>
						<xsl:attribute name="matchType"><xsl:value-of select="PCLinkStatus"/></xsl:attribute>
					</IsProviderRecordFor>
					<ConceptRecordCreation>
						<xsl:attribute name="date"><xsl:value-of select="PCCreatedDate"/></xsl:attribute>
						<xsl:attribute name="createdBy"><xsl:value-of select="PCCreatedBy"/></xsl:attribute>
					</ConceptRecordCreation>
					<ConceptRecordUpdate>
						<xsl:attribute name="date"><xsl:value-of select="PCUpdatedDate"/></xsl:attribute>
						<xsl:attribute name="updatedBy"><xsl:value-of select="PCUpdatedBy"/></xsl:attribute>
					</ConceptRecordUpdate>
					<OriginalProviderId>
						<xsl:attribute name="id"><xsl:value-of select="PCConceptId"/></xsl:attribute>
						<xsl:attribute name="ref"><xsl:value-of select="ProviderPk"/></xsl:attribute>
					</OriginalProviderId>
				</ProviderSpecificData>
			</TaxonConcept>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="testPRRefLink">
		<xsl:param name="pRefId"/>
		<xsl:choose>
			<xsl:when test="//ProviderReference[PRPk=$pRefId]/PRPk!=''">local</xsl:when>
			<xsl:otherwise>external</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="testPRNameLink">
		<xsl:param name="pNameId"/>
		<xsl:choose>
			<xsl:when test="//NewDataSet/ProviderName[PNPk=$pNameId]/PNPk!=''">local</xsl:when>
			<xsl:otherwise>external</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="testRefLink">
		<xsl:param name="pRefId"/>
		<xsl:choose>
			<xsl:when test="//Reference[ReferenceLSID=$pRefId]/ReferenceGuid !=''">local</xsl:when>
			<xsl:otherwise>external</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="testNameLink">
		<xsl:param name="pNameId"/>
		<xsl:choose>
			<xsl:when test="//Name[NameLSID=$pNameId]/NameGuid !=''">local</xsl:when>
			<xsl:otherwise>external</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="testConceptLink">
		<xsl:param name="pConceptId"/>
		<xsl:choose>
			<xsl:when test="//Concept[ConceptPk=$pConceptId]/ConceptLSID !=''">local</xsl:when>
			<xsl:otherwise>external</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="testPRConceptLink">
		<xsl:param name="pConceptId"/>
		<xsl:choose>
			<xsl:when test="//ProviderConcept[PCPk=$pConceptId]/PCPk !=''">local</xsl:when>
			<xsl:otherwise>external</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="correctRelationship">
		<xsl:param name="parRelType"/>
		<xsl:choose>
			<xsl:when test="$parRelType='is child of'">is child taxon of</xsl:when>
			<xsl:when test="$parRelType='has preferred name'">is included in</xsl:when>
			<xsl:otherwise><xsl:value-of select="$parRelType"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>

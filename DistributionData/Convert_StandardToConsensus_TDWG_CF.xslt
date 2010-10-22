<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:key use="@schema" name="kSchema" match="Distribution" />
  <xsl:key use="concat(@schema, '+', @region)" name="kSchemaRegion" match="Distribution" />
  <xsl:key use="concat(@schema,'+', @region, '+', @occurrence, '+', @origin)" name="kBiostat" match="Distribution" />
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />
  <xsl:template match="/">
    <DataSet>
      <xsl:for-each select="//Distribution">
        <xsl:sort select="@schema" />
        <xsl:sort select="@region" />
        <xsl:sort select="@occurrence" />
        <xsl:sort select="@origin" />
        <xsl:variable name="vSchema" select="@schema" />
        <xsl:if test="generate-id()=generate-id(key('kSchema', @schema)[1])">
          <xsl:for-each select="//Distribution[@schema=$vSchema]">
            <xsl:sort select="@region" />
            <xsl:sort select="@occurrence" />
            <xsl:sort select="@origin" />
            <xsl:variable name="vRegion" select="@region" />
            <xsl:if test="generate-id()=generate-id(key('kSchemaRegion', concat(@schema, '+', @region))[1])">
              <xsl:for-each select="//Distribution[@schema=$vSchema and @region=$vRegion]">
                <xsl:sort select="@schema" />
                <xsl:sort select="@region" />
                <xsl:sort select="@occurrence" />
                <xsl:sort select="@origin" />
                <xsl:if test="generate-id()=generate-id(key('kBiostat', concat(@schema,'+', @region, '+', @occurrence, '+', @origin))[1])">
                  <xsl:call-template name="writeBiostat">
                    <xsl:with-param name="pSchema" select="@schema" />
                    <xsl:with-param name="pRegion" select="$vRegion" />
                    <xsl:with-param name="pOcc" select="@occurrence" />
                    <xsl:with-param name="pOrig" select="@origin" />
                  </xsl:call-template>
                </xsl:if>
              </xsl:for-each>
            </xsl:if>
          </xsl:for-each>
        </xsl:if>
      </xsl:for-each>
    </DataSet>
  </xsl:template>
  <xsl:template name="writeBiostat">
    <xsl:param name="pSchema" />
    <xsl:param name="pRegion" />
    <xsl:param name="pOcc" />
    <xsl:param name="pOrig" />
    <xsl:variable name="vT">
      <xsl:call-template name="transTDWG">
        <xsl:with-param name="pSchema" select="$pSchema" />
        <xsl:with-param name="pRegion" select="$pRegion" />
      </xsl:call-template>
    </xsl:variable>
    <Biostat>
      <xsl:attribute name="L1">
        <xsl:value-of select="substring-after(substring-before($vT, ';'), 'L1: ')" />
      </xsl:attribute>
      <xsl:attribute name="L2">
        <xsl:value-of select="substring-before(substring-after($vT, 'L2: '), ';')" />
      </xsl:attribute>
      <xsl:attribute name="L3">
        <xsl:value-of select="substring-before(substring-after($vT, 'L3: '), ';')" />
      </xsl:attribute>
      <xsl:attribute name="L4">
        <xsl:value-of select="substring-after($vT, 'L4: ')" />
      </xsl:attribute>
      <!--<xsl:attribute name="schema"><xsl:value-of select="$pSchema"/></xsl:attribute>-->
      <xsl:attribute name="region">
        <xsl:value-of select="$pRegion" />
      </xsl:attribute>
      <xsl:attribute name="Occurrence">
        <xsl:value-of select="$pOcc" />
      </xsl:attribute>
      <xsl:attribute name="Origin">
        <xsl:value-of select="$pOrig" />
      </xsl:attribute>
      <Providers>
        <xsl:for-each select="//Provider[count(Distributions/Distribution[@schema=$pSchema and @region=$pRegion and @occurrence=$pOcc and @origin=$pOrig]) &gt; 0]">
          <xsl:sort select="@id" data-type="number" />
          <Provider>
            <xsl:attribute name="id">
              <xsl:value-of select="@id" />
            </xsl:attribute>
            <xsl:value-of select="@name" />
          </Provider>
        </xsl:for-each>
      </Providers>
    </Biostat>
  </xsl:template>
  <xsl:template name="transTDWG">
    <xsl:param name="pSchema" />
    <xsl:param name="pRegion" />
    <xsl:choose>
      <xsl:when test="$pSchema='TDWG Level 1'">
        <xsl:choose>
          <xsl:when test="$pRegion='1'">L1: 1 - Europe;</xsl:when>
          <xsl:when test="$pRegion='2'">L1: 2 - Africa;</xsl:when>
          <xsl:when test="$pRegion='3'">L1: 3 - Asia-Temperate;</xsl:when>
          <xsl:when test="$pRegion='4'">L1: 4 - Asia-Tropical;</xsl:when>
          <xsl:when test="$pRegion='5'">L1: 5 - Australasia;</xsl:when>
          <xsl:when test="$pRegion='6'">L1: 6 - Pacific;</xsl:when>
          <xsl:when test="$pRegion='7'">L1: 7 - Northern America;</xsl:when>
          <xsl:when test="$pRegion='8'">L1: 8 - Southern America;</xsl:when>
          <xsl:when test="$pRegion='9'">L1: 9 - Antarctic;</xsl:when>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$pSchema='TDWG Level 2'">
        <xsl:choose>
          <xsl:when test="$pRegion='10'">L1: 1 - Europe; L2: 10 - Northern Europe;</xsl:when>
          <xsl:when test="$pRegion='11'">L1: 1 - Europe; L2: 11 - Middle Europe;</xsl:when>
          <xsl:when test="$pRegion='12'">L1: 1 - Europe; L2: 12 - Southwestern Europe;</xsl:when>
          <xsl:when test="$pRegion='13'">L1: 1 - Europe; L2: 13 - Southeastern Europe;</xsl:when>
          <xsl:when test="$pRegion='14'">L1: 1 - Europe; L2: 14 - Eastern Europe;</xsl:when>
          <xsl:when test="$pRegion='20'">L1: 2 - Africa; L2: 20 - Northern Africa;</xsl:when>
          <xsl:when test="$pRegion='21'">L1: 2 - Africa; L2: 21 - Macaronesia;</xsl:when>
          <xsl:when test="$pRegion='22'">L1: 2 - Africa; L2: 22 - West Tropical Africa;</xsl:when>
          <xsl:when test="$pRegion='23'">L1: 2 - Africa; L2: 23 - West-Central Tropical Africa;</xsl:when>
          <xsl:when test="$pRegion='24'">L1: 2 - Africa; L2: 24 - Northeast Tropical Africa;</xsl:when>
          <xsl:when test="$pRegion='25'">L1: 2 - Africa; L2: 25 - East Tropical Africa;</xsl:when>
          <xsl:when test="$pRegion='26'">L1: 2 - Africa; L2: 26 - South Tropical Africa;</xsl:when>
          <xsl:when test="$pRegion='27'">L1: 2 - Africa; L2: 27 - Southern Africa;</xsl:when>
          <xsl:when test="$pRegion='28'">L1: 2 - Africa; L2: 28 - Middle Atlantic Ocean;</xsl:when>
          <xsl:when test="$pRegion='29'">L1: 2 - Africa; L2: 29 - Western Indian Ocean;</xsl:when>
          <xsl:when test="$pRegion='30'">L1: 3 - Asia-Temperate; L2: 30 - Siberia;</xsl:when>
          <xsl:when test="$pRegion='31'">L1: 3 - Asia-Temperate; L2: 31 - Russian Far East;</xsl:when>
          <xsl:when test="$pRegion='32'">L1: 3 - Asia-Temperate; L2: 32 - Middle Asia;</xsl:when>
          <xsl:when test="$pRegion='33'">L1: 3 - Asia-Temperate; L2: 33 - Caucasus;</xsl:when>
          <xsl:when test="$pRegion='34'">L1: 3 - Asia-Temperate; L2: 34 - Western Asia;</xsl:when>
          <xsl:when test="$pRegion='35'">L1: 3 - Asia-Temperate; L2: 35 - Arabian Peninsula;</xsl:when>
          <xsl:when test="$pRegion='36'">L1: 3 - Asia-Temperate; L2: 36 - China;</xsl:when>
          <xsl:when test="$pRegion='37'">L1: 3 - Asia-Temperate; L2: 37 - Mongolia;</xsl:when>
          <xsl:when test="$pRegion='38'">L1: 3 - Asia-Temperate; L2: 38 - Eastern Asia;</xsl:when>
          <xsl:when test="$pRegion='40'">L1: 4 - Asia-Tropical; L2: 40 - Indian Subcontinent;</xsl:when>
          <xsl:when test="$pRegion='41'">L1: 4 - Asia-Tropical; L2: 41 - Indo-China;</xsl:when>
          <xsl:when test="$pRegion='42'">L1: 4 - Asia-Tropical; L2: 42 - Malesia;</xsl:when>
          <xsl:when test="$pRegion='43'">L1: 4 - Asia-Tropical; L2: 43 - Papuasia;</xsl:when>
          <xsl:when test="$pRegion='50'">L1: 5 - Australasia; L2: 50 - Australia;</xsl:when>
          <xsl:when test="$pRegion='51'">L1: 5 - Australasia; L2: 51 - New Zealand;</xsl:when>
          <xsl:when test="$pRegion='60'">L1: 6 - Pacific; L2: 60 - Southwestern Pacific;</xsl:when>
          <xsl:when test="$pRegion='61'">L1: 6 - Pacific; L2: 61 - South-Central Pacific;</xsl:when>
          <xsl:when test="$pRegion='62'">L1: 6 - Pacific; L2: 62 - Northwestern Pacific;</xsl:when>
          <xsl:when test="$pRegion='63'">L1: 6 - Pacific; L2: 63 - North-Central Pacific;</xsl:when>
          <xsl:when test="$pRegion='70'">L1: 7 - Northern America; L2: 70 - Subarctic America;</xsl:when>
          <xsl:when test="$pRegion='71'">L1: 7 - Northern America; L2: 71 - Western Canada;</xsl:when>
          <xsl:when test="$pRegion='72'">L1: 7 - Northern America; L2: 72 - Eastern Canada;</xsl:when>
          <xsl:when test="$pRegion='73'">L1: 7 - Northern America; L2: 73 - Northwestern U.S.A.;</xsl:when>
          <xsl:when test="$pRegion='74'">L1: 7 - Northern America; L2: 74 - North-Central U.S.A.;</xsl:when>
          <xsl:when test="$pRegion='75'">L1: 7 - Northern America; L2: 75 - Northeastern U.S.A.;</xsl:when>
          <xsl:when test="$pRegion='76'">L1: 7 - Northern America; L2: 76 - Southwestern U.S.A.;</xsl:when>
          <xsl:when test="$pRegion='77'">L1: 7 - Northern America; L2: 77 - South-Central U.S.A.;</xsl:when>
          <xsl:when test="$pRegion='78'">L1: 7 - Northern America; L2: 78 - Southeastern U.S.A.;</xsl:when>
          <xsl:when test="$pRegion='79'">L1: 7 - Northern America; L2: 79 - Mexico;</xsl:when>
          <xsl:when test="$pRegion='80'">L1: 8 - Southern America; L2: 80 - Central America;</xsl:when>
          <xsl:when test="$pRegion='81'">L1: 8 - Southern America; L2: 81 - Caribbean;</xsl:when>
          <xsl:when test="$pRegion='82'">L1: 8 - Southern America; L2: 82 - Northern South America;</xsl:when>
          <xsl:when test="$pRegion='83'">L1: 8 - Southern America; L2: 83 - Western South America;</xsl:when>
          <xsl:when test="$pRegion='84'">L1: 8 - Southern America; L2: 84 - Brazil;</xsl:when>
          <xsl:when test="$pRegion='85'">L1: 8 - Southern America; L2: 85 - Southern South America;</xsl:when>
          <xsl:when test="$pRegion='90'">L1: 9 - Antarctic; L2: 90 - Subantarctic Islands;</xsl:when>
          <xsl:when test="$pRegion='91'">L1: 9 - Antarctic; L2: 91 - Antarctic Continent;</xsl:when>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$pSchema='TDWG Level 3'">
        <xsl:choose>
          <xsl:when test="$pRegion='DEN'">L1: 1 - Europe; L2: 10 - Northern Europe; L3: Denmark (DEN); L4: Denmark (DEN-OO)</xsl:when>
          <xsl:when test="$pRegion='FIN'">L1: 1 - Europe; L2: 10 - Northern Europe; L3: Finland (FIN); L4: Finland (FIN-OO)</xsl:when>
          <xsl:when test="$pRegion='FOR'">L1: 1 - Europe; L2: 10 - Northern Europe; L3: Føroyar (FOR); L4: Føroyar (FOR-OO)</xsl:when>
          <xsl:when test="$pRegion='GRB'">L1: 1 - Europe; L2: 10 - Northern Europe; L3: Great Britain (GRB); L4: Great Britain (GRB-OO)</xsl:when>
          <xsl:when test="$pRegion='ICE'">L1: 1 - Europe; L2: 10 - Northern Europe; L3: Iceland (ICE); L4: Iceland (ICE-OO)</xsl:when>
          <xsl:when test="$pRegion='IRE'">L1: 1 - Europe; L2: 10 - Northern Europe; L3: Ireland (IRE); L4:</xsl:when>
          <xsl:when test="$pRegion='NOR'">L1: 1 - Europe; L2: 10 - Northern Europe; L3: Norway (NOR); L4: Norway (NOR-OO)</xsl:when>
          <xsl:when test="$pRegion='SVA'">L1: 1 - Europe; L2: 10 - Northern Europe; L3: Svalbard (SVA); L4: Svalbard (SVA-OO)</xsl:when>
          <xsl:when test="$pRegion='SWE'">L1: 1 - Europe; L2: 10 - Northern Europe; L3: Sweden (SWE); L4: Sweden (SWE-OO)</xsl:when>
          <xsl:when test="$pRegion='AUT'">L1: 1 - Europe; L2: 11 - Middle Europe; L3: Austria (AUT); L4:</xsl:when>
          <xsl:when test="$pRegion='BGM'">L1: 1 - Europe; L2: 11 - Middle Europe; L3: Belgium (BGM); L4:</xsl:when>
          <xsl:when test="$pRegion='CZE'">L1: 1 - Europe; L2: 11 - Middle Europe; L3: Czechoslovakia (CZE); L4:</xsl:when>
          <xsl:when test="$pRegion='GER'">L1: 1 - Europe; L2: 11 - Middle Europe; L3: Germany (GER); L4: Germany (GER-OO)</xsl:when>
          <xsl:when test="$pRegion='HUN'">L1: 1 - Europe; L2: 11 - Middle Europe; L3: Hungary (HUN); L4: Hungary (HUN-OO)</xsl:when>
          <xsl:when test="$pRegion='NET'">L1: 1 - Europe; L2: 11 - Middle Europe; L3: Netherlands (NET); L4: Netherlands (NET-OO)</xsl:when>
          <xsl:when test="$pRegion='POL'">L1: 1 - Europe; L2: 11 - Middle Europe; L3: Poland (POL); L4: Poland (POL-OO)</xsl:when>
          <xsl:when test="$pRegion='SWI'">L1: 1 - Europe; L2: 11 - Middle Europe; L3: Switzerland (SWI); L4: Switzerland (SWI-OO)</xsl:when>
          <xsl:when test="$pRegion='BAL'">L1: 1 - Europe; L2: 12 - Southwestern Europe; L3: Baleares (BAL); L4: Baleares (BAL-OO)</xsl:when>
          <xsl:when test="$pRegion='COR'">L1: 1 - Europe; L2: 12 - Southwestern Europe; L3: Corse (COR); L4: Corse (COR-OO)</xsl:when>
          <xsl:when test="$pRegion='FRA'">L1: 1 - Europe; L2: 12 - Southwestern Europe; L3: France (FRA); L4:</xsl:when>
          <xsl:when test="$pRegion='FRA'">L1: 1 - Europe; L2: 12 - Southwestern Europe; L3: France (FRA); L4: Monaco (FRA-MO)</xsl:when>
          <xsl:when test="$pRegion='POR'">L1: 1 - Europe; L2: 12 - Southwestern Europe; L3: Portugal (POR); L4: Portugal (POR-OO)</xsl:when>
          <xsl:when test="$pRegion='SAR'">L1: 1 - Europe; L2: 12 - Southwestern Europe; L3: Sardegna (SAR); L4: Sardegna (SAR-OO)</xsl:when>
          <xsl:when test="$pRegion='SPA'">L1: 1 - Europe; L2: 12 - Southwestern Europe; L3: Spain (SPA); L4:</xsl:when>
          <xsl:when test="$pRegion='ALB'">L1: 1 - Europe; L2: 13 - Southeastern Europe; L3: Albania (ALB); L4: Albania (ALB-OO)</xsl:when>
          <xsl:when test="$pRegion='BUL'">L1: 1 - Europe; L2: 13 - Southeastern Europe; L3: Bulgaria (BUL); L4: Bulgaria (BUL-OO)</xsl:when>
          <xsl:when test="$pRegion='GRC'">L1: 1 - Europe; L2: 13 - Southeastern Europe; L3: Greece (GRC); L4: Greece (GRC-OO)</xsl:when>
          <xsl:when test="$pRegion='ITA'">L1: 1 - Europe; L2: 13 - Southeastern Europe; L3: Italy (ITA); L4:</xsl:when>
          <xsl:when test="$pRegion='KRI'">L1: 1 - Europe; L2: 13 - Southeastern Europe; L3: Kriti (KRI); L4: Kriti (KRI-OO)</xsl:when>
          <xsl:when test="$pRegion='ROM'">L1: 1 - Europe; L2: 13 - Southeastern Europe; L3: Romania (ROM); L4: Romania (ROM-OO)</xsl:when>
          <xsl:when test="$pRegion='SIC'">L1: 1 - Europe; L2: 13 - Southeastern Europe; L3: Sicilia (SIC); L4:</xsl:when>
          <xsl:when test="$pRegion='TUE'">L1: 1 - Europe; L2: 13 - Southeastern Europe; L3: Turkey-in-Europe (TUE); L4: Turkey-in-Europe (TUE-OO)</xsl:when>
          <xsl:when test="$pRegion='YUG'">L1: 1 - Europe; L2: 13 - Southeastern Europe; L3: Yugoslavia (YUG); L4:</xsl:when>
          <xsl:when test="$pRegion='BLR'">L1: 1 - Europe; L2: 14 - Eastern Europe; L3: Belarus (BLR); L4: Belarus (BLR-OO)</xsl:when>
          <xsl:when test="$pRegion='BLT'">L1: 1 - Europe; L2: 14 - Eastern Europe; L3: Baltic States (BLT); L4:</xsl:when>
          <xsl:when test="$pRegion='KRY'">L1: 1 - Europe; L2: 14 - Eastern Europe; L3: Krym (KRY); L4: Krym (KRY-OO)</xsl:when>
          <xsl:when test="$pRegion='RUC'">L1: 1 - Europe; L2: 14 - Eastern Europe; L3: Central European Russia (RUC); L4: Central European Russia (RUC-OO)</xsl:when>
          <xsl:when test="$pRegion='RUE'">L1: 1 - Europe; L2: 14 - Eastern Europe; L3: East European Russia (RUE); L4: East European Russia (RUE-OO)</xsl:when>
          <xsl:when test="$pRegion='RUN'">L1: 1 - Europe; L2: 14 - Eastern Europe; L3: North European Russia (RUN); L4: North European Russia (RUN-OO)</xsl:when>
          <xsl:when test="$pRegion='RUS'">L1: 1 - Europe; L2: 14 - Eastern Europe; L3: South European Russia (RUS); L4: South European Russia (RUS-OO)</xsl:when>
          <xsl:when test="$pRegion='RUW'">L1: 1 - Europe; L2: 14 - Eastern Europe; L3: Northwest European Russia (RUW); L4: Northwest European Russia (RUW-OO)</xsl:when>
          <xsl:when test="$pRegion='UKR'">L1: 1 - Europe; L2: 14 - Eastern Europe; L3: Ukraine (UKR); L4:</xsl:when>
          <xsl:when test="$pRegion='ALG'">L1: 2 - Africa; L2: 20 - Northern Africa; L3: Algeria (ALG); L4: Algeria (ALG-OO)</xsl:when>
          <xsl:when test="$pRegion='EGY'">L1: 2 - Africa; L2: 20 - Northern Africa; L3: Egypt (EGY); L4: Egypt (EGY-OO)</xsl:when>
          <xsl:when test="$pRegion='LBY'">L1: 2 - Africa; L2: 20 - Northern Africa; L3: Libya (LBY); L4: Libya (LBY-OO)</xsl:when>
          <xsl:when test="$pRegion='MOR'">L1: 2 - Africa; L2: 20 - Northern Africa; L3: Morocco (MOR); L4:</xsl:when>
          <xsl:when test="$pRegion='TUN'">L1: 2 - Africa; L2: 20 - Northern Africa; L3: Tunisia (TUN); L4: Tunisia (TUN-OO)</xsl:when>
          <xsl:when test="$pRegion='WSA'">L1: 2 - Africa; L2: 20 - Northern Africa; L3: Western Sahara (WSA); L4: Western Sahara (WSA-OO)</xsl:when>
          <xsl:when test="$pRegion='AZO'">L1: 2 - Africa; L2: 21 - Macaronesia; L3: Azores (AZO); L4: Açôres (AZO-OO)</xsl:when>
          <xsl:when test="$pRegion='CNY'">L1: 2 - Africa; L2: 21 - Macaronesia; L3: Canary Is. (CNY); L4: Canary Is. (CNY-OO)</xsl:when>
          <xsl:when test="$pRegion='CVI'">L1: 2 - Africa; L2: 21 - Macaronesia; L3: Cape Verde (CVI); L4: Cape Verde (CVI-OO)</xsl:when>
          <xsl:when test="$pRegion='MDR'">L1: 2 - Africa; L2: 21 - Macaronesia; L3: Madeira (MDR); L4: Madeira (MDR-OO)</xsl:when>
          <xsl:when test="$pRegion='SEL'">L1: 2 - Africa; L2: 21 - Macaronesia; L3: Selvagens (SEL); L4: Selvagens (SEL-OO)</xsl:when>
          <xsl:when test="$pRegion='BEN'">L1: 2 - Africa; L2: 22 - West Tropical Africa; L3: Benin (BEN); L4: Benin (BEN-OO)</xsl:when>
          <xsl:when test="$pRegion='BKN'">L1: 2 - Africa; L2: 22 - West Tropical Africa; L3: Burkina (BKN); L4: Burkina (BKN-OO)</xsl:when>
          <xsl:when test="$pRegion='GAM'">L1: 2 - Africa; L2: 22 - West Tropical Africa; L3: Gambia, The (GAM); L4: Gambia, The (GAM-OO)</xsl:when>
          <xsl:when test="$pRegion='GHA'">L1: 2 - Africa; L2: 22 - West Tropical Africa; L3: Ghana (GHA); L4: Ghana (GHA-OO)</xsl:when>
          <xsl:when test="$pRegion='GNB'">L1: 2 - Africa; L2: 22 - West Tropical Africa; L3: Guinea-Bissau (GNB); L4: Guinea-Bissau (GNB-OO)</xsl:when>
          <xsl:when test="$pRegion='GUI'">L1: 2 - Africa; L2: 22 - West Tropical Africa; L3: Guinea (GUI); L4: Guinea (GUI-OO)</xsl:when>
          <xsl:when test="$pRegion='IVO'">L1: 2 - Africa; L2: 22 - West Tropical Africa; L3: Ivory Coast (IVO); L4: Ivory Coast (IVO-OO)</xsl:when>
          <xsl:when test="$pRegion='LBR'">L1: 2 - Africa; L2: 22 - West Tropical Africa; L3: Liberia (LBR); L4: Liberia (LBR-OO)</xsl:when>
          <xsl:when test="$pRegion='MLI'">L1: 2 - Africa; L2: 22 - West Tropical Africa; L3: Mali (MLI); L4: Mali (MLI-OO)</xsl:when>
          <xsl:when test="$pRegion='MTN'">L1: 2 - Africa; L2: 22 - West Tropical Africa; L3: Mauritania (MTN); L4: Mauritania (MTN-OO)</xsl:when>
          <xsl:when test="$pRegion='NGA'">L1: 2 - Africa; L2: 22 - West Tropical Africa; L3: Nigeria (NGA); L4: Nigeria (NGA-OO)</xsl:when>
          <xsl:when test="$pRegion='NGR'">L1: 2 - Africa; L2: 22 - West Tropical Africa; L3: Niger (NGR); L4: Niger (NGR-OO)</xsl:when>
          <xsl:when test="$pRegion='SEN'">L1: 2 - Africa; L2: 22 - West Tropical Africa; L3: Senegal (SEN); L4: Senegal (SEN-OO)</xsl:when>
          <xsl:when test="$pRegion='SIE'">L1: 2 - Africa; L2: 22 - West Tropical Africa; L3: Sierra Leone (SIE); L4: Sierra Leone (SIE-OO)</xsl:when>
          <xsl:when test="$pRegion='TOG'">L1: 2 - Africa; L2: 22 - West Tropical Africa; L3: Togo (TOG); L4: Togo (TOG-OO)</xsl:when>
          <xsl:when test="$pRegion='BUR'">L1: 2 - Africa; L2: 23 - West-Central Tropical Africa; L3: Burundi (BUR); L4: Burundi (BUR-OO)</xsl:when>
          <xsl:when test="$pRegion='CAB'">L1: 2 - Africa; L2: 23 - West-Central Tropical Africa; L3: Cabinda (CAB); L4: Cabinda (CAB-OO)</xsl:when>
          <xsl:when test="$pRegion='CAF'">L1: 2 - Africa; L2: 23 - West-Central Tropical Africa; L3: Central African Republic (CAF); L4: Central African Republic (CAF-OO)</xsl:when>
          <xsl:when test="$pRegion='CMN'">L1: 2 - Africa; L2: 23 - West-Central Tropical Africa; L3: Cameroon (CMN); L4: Cameroon (CMN-OO)</xsl:when>
          <xsl:when test="$pRegion='CON'">L1: 2 - Africa; L2: 23 - West-Central Tropical Africa; L3: Congo (CON); L4: Congo (CON-OO)</xsl:when>
          <xsl:when test="$pRegion='EQG'">L1: 2 - Africa; L2: 23 - West-Central Tropical Africa; L3: Equatorial Guinea (EQG); L4: Equatorial Guinea (EQG-OO)</xsl:when>
          <xsl:when test="$pRegion='GAB'">L1: 2 - Africa; L2: 23 - West-Central Tropical Africa; L3: Gabon (GAB); L4: Gabon (GAB-OO)</xsl:when>
          <xsl:when test="$pRegion='GGI'">L1: 2 - Africa; L2: 23 - West-Central Tropical Africa; L3: Gulf of Guinea Is. (GGI); L4:</xsl:when>
          <xsl:when test="$pRegion='RWA'">L1: 2 - Africa; L2: 23 - West-Central Tropical Africa; L3: Rwanda (RWA); L4: Rwanda (RWA-OO)</xsl:when>
          <xsl:when test="$pRegion='ZAI'">L1: 2 - Africa; L2: 23 - West-Central Tropical Africa; L3: Zaire (ZAI); L4: Zaire (ZAI-OO)</xsl:when>
          <xsl:when test="$pRegion='CHA'">L1: 2 - Africa; L2: 24 - Northeast Tropical Africa; L3: Chad (CHA); L4: Chad (CHA-OO)</xsl:when>
          <xsl:when test="$pRegion='DJI'">L1: 2 - Africa; L2: 24 - Northeast Tropical Africa; L3: Djibouti (DJI); L4: Djibouti (DJI-OO)</xsl:when>
          <xsl:when test="$pRegion='ERI'">L1: 2 - Africa; L2: 24 - Northeast Tropical Africa; L3: Eritrea (ERI); L4: Eritrea (ERI-OO)</xsl:when>
          <xsl:when test="$pRegion='ETH'">L1: 2 - Africa; L2: 24 - Northeast Tropical Africa; L3: Ethiopia (ETH); L4: Ethiopia (ETH-OO)</xsl:when>
          <xsl:when test="$pRegion='SOC'">L1: 2 - Africa; L2: 24 - Northeast Tropical Africa; L3: Socotra (SOC); L4: Socotra (SOC-OO)</xsl:when>
          <xsl:when test="$pRegion='SOM'">L1: 2 - Africa; L2: 24 - Northeast Tropical Africa; L3: Somalia (SOM); L4: Somalia (SOM-OO)</xsl:when>
          <xsl:when test="$pRegion='SUD'">L1: 2 - Africa; L2: 24 - Northeast Tropical Africa; L3: Sudan (SUD); L4: Sudan (SUD-OO)</xsl:when>
          <xsl:when test="$pRegion='KEN'">L1: 2 - Africa; L2: 25 - East Tropical Africa; L3: Kenya (KEN); L4: Kenya (KEN-OO)</xsl:when>
          <xsl:when test="$pRegion='TAN'">L1: 2 - Africa; L2: 25 - East Tropical Africa; L3: Tanzania (TAN); L4: Tanzania (TAN-OO)</xsl:when>
          <xsl:when test="$pRegion='UGA'">L1: 2 - Africa; L2: 25 - East Tropical Africa; L3: Uganda (UGA); L4: Uganda (UGA-OO)</xsl:when>
          <xsl:when test="$pRegion='ANG'">L1: 2 - Africa; L2: 26 - South Tropical Africa; L3: Angola (ANG); L4: Angola (ANG-OO)</xsl:when>
          <xsl:when test="$pRegion='MLW'">L1: 2 - Africa; L2: 26 - South Tropical Africa; L3: Malawi (MLW); L4: Malawi (MLW-OO)</xsl:when>
          <xsl:when test="$pRegion='MOZ'">L1: 2 - Africa; L2: 26 - South Tropical Africa; L3: Mozambique (MOZ); L4: Mozambique (MOZ-OO)</xsl:when>
          <xsl:when test="$pRegion='ZAM'">L1: 2 - Africa; L2: 26 - South Tropical Africa; L3: Zambia (ZAM); L4: Zambia (ZAM-OO)</xsl:when>
          <xsl:when test="$pRegion='ZIM'">L1: 2 - Africa; L2: 26 - South Tropical Africa; L3: Zimbabwe (ZIM); L4: Zimbabwe (ZIM-OO)</xsl:when>
          <xsl:when test="$pRegion='BOT'">L1: 2 - Africa; L2: 27 - Southern Africa; L3: Botswana (BOT); L4: Botswana (BOT-OO)</xsl:when>
          <xsl:when test="$pRegion='CPP'">L1: 2 - Africa; L2: 27 - Southern Africa; L3: Cape Provinces (CPP); L4:</xsl:when>
          <xsl:when test="$pRegion='CPV'">L1: 2 - Africa; L2: 27 - Southern Africa; L3: Caprivi Strip (CPV); L4: Caprivi Strip (CPV-OO)</xsl:when>
          <xsl:when test="$pRegion='LES'">L1: 2 - Africa; L2: 27 - Southern Africa; L3: Lesotho (LES); L4: Lesotho (LES-OO)</xsl:when>
          <xsl:when test="$pRegion='NAM'">L1: 2 - Africa; L2: 27 - Southern Africa; L3: Namibia (NAM); L4: Namibia (NAM-OO)</xsl:when>
          <xsl:when test="$pRegion='NAT'">L1: 2 - Africa; L2: 27 - Southern Africa; L3: KwaZulu-Natal (NAT); L4: KwaZulu-Natal (NAT-OO)</xsl:when>
          <xsl:when test="$pRegion='OFS'">L1: 2 - Africa; L2: 27 - Southern Africa; L3: Free State (OFS); L4: Free State (OFS-OO)</xsl:when>
          <xsl:when test="$pRegion='SWZ'">L1: 2 - Africa; L2: 27 - Southern Africa; L3: Swaziland (SWZ); L4: Swaziland (SWZ-OO)</xsl:when>
          <xsl:when test="$pRegion='TVL'">L1: 2 - Africa; L2: 27 - Southern Africa; L3: Northern Provinces (TVL); L4:</xsl:when>
          <xsl:when test="$pRegion='ASC'">L1: 2 - Africa; L2: 28 - Middle Atlantic Ocean; L3: Ascension (ASC); L4: Ascension (ASC-OO)</xsl:when>
          <xsl:when test="$pRegion='STH'">L1: 2 - Africa; L2: 28 - Middle Atlantic Ocean; L3: St.Helena (STH); L4: St.Helena (STH-OO)</xsl:when>
          <xsl:when test="$pRegion='ALD'">L1: 2 - Africa; L2: 29 - Western Indian Ocean; L3: Aldabra (ALD); L4: Aldabra (ALD-OO)</xsl:when>
          <xsl:when test="$pRegion='CGS'">L1: 2 - Africa; L2: 29 - Western Indian Ocean; L3: Chagos Archipelago (CGS); L4: Chagos Archipelago (CGS-OO)</xsl:when>
          <xsl:when test="$pRegion='COM'">L1: 2 - Africa; L2: 29 - Western Indian Ocean; L3: Comoros (COM); L4:</xsl:when>
          <xsl:when test="$pRegion='MAU'">L1: 2 - Africa; L2: 29 - Western Indian Ocean; L3: Mauritius (MAU); L4: Mauritius (MAU-OO)</xsl:when>
          <xsl:when test="$pRegion='MCI'">L1: 2 - Africa; L2: 29 - Western Indian Ocean; L3: Mozambique Channel Is. (MCI); L4: Mozambique Channel Is. (MCI-OO)</xsl:when>
          <xsl:when test="$pRegion='MDG'">L1: 2 - Africa; L2: 29 - Western Indian Ocean; L3: Madagascar (MDG); L4: Madagascar (MDG-OO)</xsl:when>
          <xsl:when test="$pRegion='REU'">L1: 2 - Africa; L2: 29 - Western Indian Ocean; L3: Réunion (REU); L4: Réunion (REU-OO)</xsl:when>
          <xsl:when test="$pRegion='ROD'">L1: 2 - Africa; L2: 29 - Western Indian Ocean; L3: Rodrigues (ROD); L4: Rodrigues (ROD-OO)</xsl:when>
          <xsl:when test="$pRegion='SEY'">L1: 2 - Africa; L2: 29 - Western Indian Ocean; L3: Seychelles (SEY); L4: Seychelles (SEY-OO)</xsl:when>
          <xsl:when test="$pRegion='ALT'">L1: 3 - Asia-Temperate; L2: 30 - Siberia; L3: Altay (ALT); L4: Altay (ALT-OO)</xsl:when>
          <xsl:when test="$pRegion='BRY'">L1: 3 - Asia-Temperate; L2: 30 - Siberia; L3: Buryatiya (BRY); L4: Buryatiya (BRY-OO)</xsl:when>
          <xsl:when test="$pRegion='CTA'">L1: 3 - Asia-Temperate; L2: 30 - Siberia; L3: Chita (CTA); L4: Chita (CTA-OO)</xsl:when>
          <xsl:when test="$pRegion='IRK'">L1: 3 - Asia-Temperate; L2: 30 - Siberia; L3: Irkutsk (IRK); L4: Irkutsk (IRK-OO)</xsl:when>
          <xsl:when test="$pRegion='KRA'">L1: 3 - Asia-Temperate; L2: 30 - Siberia; L3: Krasnoyarsk (KRA); L4: Krasnoyarsk (KRA-OO)</xsl:when>
          <xsl:when test="$pRegion='TVA'">L1: 3 - Asia-Temperate; L2: 30 - Siberia; L3: Tuva (TVA); L4: Tuva (TVA-OO)</xsl:when>
          <xsl:when test="$pRegion='WSB'">L1: 3 - Asia-Temperate; L2: 30 - Siberia; L3: West Siberia (WSB); L4: West Siberia (WSB-OO)</xsl:when>
          <xsl:when test="$pRegion='YAK'">L1: 3 - Asia-Temperate; L2: 30 - Siberia; L3: Yakutskiya (YAK); L4: Yakutskiya (YAK-OO)</xsl:when>
          <xsl:when test="$pRegion='AMU'">L1: 3 - Asia-Temperate; L2: 31 - Russian Far East; L3: Amur (AMU); L4: Amur (AMU-OO)</xsl:when>
          <xsl:when test="$pRegion='KAM'">L1: 3 - Asia-Temperate; L2: 31 - Russian Far East; L3: Kamchatka (KAM); L4: Kamchatka (KAM-OO)</xsl:when>
          <xsl:when test="$pRegion='KHA'">L1: 3 - Asia-Temperate; L2: 31 - Russian Far East; L3: Khabarovsk (KHA); L4: Khabarovsk (KHA-OO)</xsl:when>
          <xsl:when test="$pRegion='KUR'">L1: 3 - Asia-Temperate; L2: 31 - Russian Far East; L3: Kuril Is. (KUR); L4: Kuril Is. (KUR-OO)</xsl:when>
          <xsl:when test="$pRegion='MAG'">L1: 3 - Asia-Temperate; L2: 31 - Russian Far East; L3: Magadan (MAG); L4: Magadan (MAG-OO)</xsl:when>
          <xsl:when test="$pRegion='PRM'">L1: 3 - Asia-Temperate; L2: 31 - Russian Far East; L3: Primorye (PRM); L4: Primorye (PRM-OO)</xsl:when>
          <xsl:when test="$pRegion='SAK'">L1: 3 - Asia-Temperate; L2: 31 - Russian Far East; L3: Sakhalin (SAK); L4: Sakhalin (SAK-OO)</xsl:when>
          <xsl:when test="$pRegion='KAZ'">L1: 3 - Asia-Temperate; L2: 32 - Middle Asia; L3: Kazakhstan (KAZ); L4: Kazakhstan (KAZ-OO)</xsl:when>
          <xsl:when test="$pRegion='KGZ'">L1: 3 - Asia-Temperate; L2: 32 - Middle Asia; L3: Kirgizistan (KGZ); L4: Kirgizistan (KGZ-OO)</xsl:when>
          <xsl:when test="$pRegion='TKM'">L1: 3 - Asia-Temperate; L2: 32 - Middle Asia; L3: Turkmenistan (TKM); L4: Turkmenistan (TKM-OO)</xsl:when>
          <xsl:when test="$pRegion='TZK'">L1: 3 - Asia-Temperate; L2: 32 - Middle Asia; L3: Tadzhikistan (TZK); L4: Tadzhikistan (TZK-OO)</xsl:when>
          <xsl:when test="$pRegion='UZB'">L1: 3 - Asia-Temperate; L2: 32 - Middle Asia; L3: Uzbekistan (UZB); L4: Uzbekistan (UZB-OO)</xsl:when>
          <xsl:when test="$pRegion='NCS'">L1: 3 - Asia-Temperate; L2: 33 - Caucasus; L3: North Caucasus (NCS); L4:</xsl:when>
          <xsl:when test="$pRegion='TCS'">L1: 3 - Asia-Temperate; L2: 33 - Caucasus; L3: Transcaucasus (TCS); L4:</xsl:when>
          <xsl:when test="$pRegion='AFG'">L1: 3 - Asia-Temperate; L2: 34 - Western Asia; L3: Afghanistan (AFG); L4: Afghanistan (AFG-OO)</xsl:when>
          <xsl:when test="$pRegion='CYP'">L1: 3 - Asia-Temperate; L2: 34 - Western Asia; L3: Cyprus (CYP); L4: Cyprus (CYP-OO)</xsl:when>
          <xsl:when test="$pRegion='EAI'">L1: 3 - Asia-Temperate; L2: 34 - Western Asia; L3: East Aegean Is. (EAI); L4: East Aegean Is. (EAI-OO)</xsl:when>
          <xsl:when test="$pRegion='IRN'">L1: 3 - Asia-Temperate; L2: 34 - Western Asia; L3: Iran (IRN); L4: Iran (IRN-OO)</xsl:when>
          <xsl:when test="$pRegion='IRQ'">L1: 3 - Asia-Temperate; L2: 34 - Western Asia; L3: Iraq (IRQ); L4: Iraq (IRQ-OO)</xsl:when>
          <xsl:when test="$pRegion='LBS'">L1: 3 - Asia-Temperate; L2: 34 - Western Asia; L3: Lebanon-Syria (LBS); L4:</xsl:when>
          <xsl:when test="$pRegion='PAL'">L1: 3 - Asia-Temperate; L2: 34 - Western Asia; L3: Palestine (PAL); L4:</xsl:when>
          <xsl:when test="$pRegion='SIN'">L1: 3 - Asia-Temperate; L2: 34 - Western Asia; L3: Sinai (SIN); L4: Sinai (SIN-OO)</xsl:when>
          <xsl:when test="$pRegion='TUR'">L1: 3 - Asia-Temperate; L2: 34 - Western Asia; L3: Turkey (TUR); L4: Turkey (TUR-OO)</xsl:when>
          <xsl:when test="$pRegion='GST'">L1: 3 - Asia-Temperate; L2: 35 - Arabian Peninsula; L3: Gulf States (GST); L4:</xsl:when>
          <xsl:when test="$pRegion='KUW'">L1: 3 - Asia-Temperate; L2: 35 - Arabian Peninsula; L3: Kuwait (KUW); L4: Kuwait (KUW-OO)</xsl:when>
          <xsl:when test="$pRegion='OMA'">L1: 3 - Asia-Temperate; L2: 35 - Arabian Peninsula; L3: Oman (OMA); L4: Oman (OMA-OO)</xsl:when>
          <xsl:when test="$pRegion='SAU'">L1: 3 - Asia-Temperate; L2: 35 - Arabian Peninsula; L3: Saudi Arabia (SAU); L4: Saudi Arabia (SAU-OO)</xsl:when>
          <xsl:when test="$pRegion='YEM'">L1: 3 - Asia-Temperate; L2: 35 - Arabian Peninsula; L3: Yemen (YEM); L4:</xsl:when>
          <xsl:when test="$pRegion='CHC'">L1: 3 - Asia-Temperate; L2: 36 - China; L3: China South-Central (CHC); L4:</xsl:when>
          <xsl:when test="$pRegion='CHH'">L1: 3 - Asia-Temperate; L2: 36 - China; L3: Hainan (CHH); L4: Hainan (CHH-OO)</xsl:when>
          <xsl:when test="$pRegion='CHI'">L1: 3 - Asia-Temperate; L2: 36 - China; L3: Inner Mongolia (CHI); L4:</xsl:when>
          <xsl:when test="$pRegion='CHM'">L1: 3 - Asia-Temperate; L2: 36 - China; L3: Manchuria (CHM); L4:</xsl:when>
          <xsl:when test="$pRegion='CHN'">L1: 3 - Asia-Temperate; L2: 36 - China; L3: China North-Central (CHN); L4:</xsl:when>
          <xsl:when test="$pRegion='CHQ'">L1: 3 - Asia-Temperate; L2: 36 - China; L3: Qinghai (CHQ); L4: Qinghai (CHQ-OO)</xsl:when>
          <xsl:when test="$pRegion='CHS'">L1: 3 - Asia-Temperate; L2: 36 - China; L3: China Southeast (CHS); L4:</xsl:when>
          <xsl:when test="$pRegion='CHT'">L1: 3 - Asia-Temperate; L2: 36 - China; L3: Tibet (CHT); L4: Tibet (CHT-OO)</xsl:when>
          <xsl:when test="$pRegion='CHX'">L1: 3 - Asia-Temperate; L2: 36 - China; L3: Xinjiang (CHX); L4: Xinjiang (CHX-OO)</xsl:when>
          <xsl:when test="$pRegion='MON'">L1: 3 - Asia-Temperate; L2: 37 - Mongolia; L3: Mongolia (MON); L4: Mongolia (MON-OO)</xsl:when>
          <xsl:when test="$pRegion='JAP'">L1: 3 - Asia-Temperate; L2: 38 - Eastern Asia; L3: Japan (JAP); L4:</xsl:when>
          <xsl:when test="$pRegion='KOR'">L1: 3 - Asia-Temperate; L2: 38 - Eastern Asia; L3: Korea (KOR); L4:</xsl:when>
          <xsl:when test="$pRegion='KZN'">L1: 3 - Asia-Temperate; L2: 38 - Eastern Asia; L3: Kazan-retto (KZN); L4: Kazan-retto (KZN-OO)</xsl:when>
          <xsl:when test="$pRegion='NNS'">L1: 3 - Asia-Temperate; L2: 38 - Eastern Asia; L3: Nansei-shoto (NNS); L4: Nansei-shoto (NNS-OO)</xsl:when>
          <xsl:when test="$pRegion='OGA'">L1: 3 - Asia-Temperate; L2: 38 - Eastern Asia; L3: Ogasawara-shoto (OGA); L4: Ogasawara-shoto (OGA-OO)</xsl:when>
          <xsl:when test="$pRegion='TAI'">L1: 3 - Asia-Temperate; L2: 38 - Eastern Asia; L3: Taiwan (TAI); L4: Taiwan (TAI-OO)</xsl:when>
          <xsl:when test="$pRegion='ASS'">L1: 4 - Asia-Tropical; L2: 40 - Indian Subcontinent; L3: Assam (ASS); L4:</xsl:when>
          <xsl:when test="$pRegion='BAN'">L1: 4 - Asia-Tropical; L2: 40 - Indian Subcontinent; L3: Bangladesh (BAN); L4: Bangladesh (BAN-OO)</xsl:when>
          <xsl:when test="$pRegion='EHM'">L1: 4 - Asia-Tropical; L2: 40 - Indian Subcontinent; L3: East Himalaya (EHM); L4:</xsl:when>
          <xsl:when test="$pRegion='IND'">L1: 4 - Asia-Tropical; L2: 40 - Indian Subcontinent; L3: India (IND); L4:</xsl:when>
          <xsl:when test="$pRegion='LDV'">L1: 4 - Asia-Tropical; L2: 40 - Indian Subcontinent; L3: Laccadive Is. (LDV); L4: Laccadive Is. (LDV-OO)</xsl:when>
          <xsl:when test="$pRegion='MDV'">L1: 4 - Asia-Tropical; L2: 40 - Indian Subcontinent; L3: Maldives (MDV); L4: Maldives (MDV-OO)</xsl:when>
          <xsl:when test="$pRegion='NEP'">L1: 4 - Asia-Tropical; L2: 40 - Indian Subcontinent; L3: Nepal (NEP); L4: Nepal (NEP-OO)</xsl:when>
          <xsl:when test="$pRegion='PAK'">L1: 4 - Asia-Tropical; L2: 40 - Indian Subcontinent; L3: Pakistan (PAK); L4: Pakistan (PAK-OO)</xsl:when>
          <xsl:when test="$pRegion='SRL'">L1: 4 - Asia-Tropical; L2: 40 - Indian Subcontinent; L3: Sri Lanka (SRL); L4: Sri Lanka (SRL-OO)</xsl:when>
          <xsl:when test="$pRegion='WHM'">L1: 4 - Asia-Tropical; L2: 40 - Indian Subcontinent; L3: West Himalaya (WHM); L4:</xsl:when>
          <xsl:when test="$pRegion='AND'">L1: 4 - Asia-Tropical; L2: 41 - Indo-China; L3: Andaman Is. (AND); L4:</xsl:when>
          <xsl:when test="$pRegion='CBD'">L1: 4 - Asia-Tropical; L2: 41 - Indo-China; L3: Cambodia (CBD); L4: Cambodia (CBD-OO)</xsl:when>
          <xsl:when test="$pRegion='LAO'">L1: 4 - Asia-Tropical; L2: 41 - Indo-China; L3: Laos (LAO); L4: Laos (LAO-OO)</xsl:when>
          <xsl:when test="$pRegion='MYA'">L1: 4 - Asia-Tropical; L2: 41 - Indo-China; L3: Myanmar (MYA); L4: Myanmar (MYA-OO)</xsl:when>
          <xsl:when test="$pRegion='NCB'">L1: 4 - Asia-Tropical; L2: 41 - Indo-China; L3: Nicobar Is. (NCB); L4: Nicobar Is. (NCB-OO)</xsl:when>
          <xsl:when test="$pRegion='SCS'">L1: 4 - Asia-Tropical; L2: 41 - Indo-China; L3: South China Sea (SCS); L4:</xsl:when>
          <xsl:when test="$pRegion='THA'">L1: 4 - Asia-Tropical; L2: 41 - Indo-China; L3: Thailand (THA); L4: Thailand (THA-OO)</xsl:when>
          <xsl:when test="$pRegion='VIE'">L1: 4 - Asia-Tropical; L2: 41 - Indo-China; L3: Vietnam (VIE); L4: Vietnam (VIE-OO)</xsl:when>
          <xsl:when test="$pRegion='BOR'">L1: 4 - Asia-Tropical; L2: 42 - Malesia; L3: Borneo (BOR); L4:</xsl:when>
          <xsl:when test="$pRegion='CKI'">L1: 4 - Asia-Tropical; L2: 42 - Malesia; L3: Cocos (Keeling) Is. (CKI); L4: Cocos (Keeling) Is. (CKI-OO)</xsl:when>
          <xsl:when test="$pRegion='JAW'">L1: 4 - Asia-Tropical; L2: 42 - Malesia; L3: Jawa (JAW); L4: Jawa (JAW-OO)</xsl:when>
          <xsl:when test="$pRegion='LSI'">L1: 4 - Asia-Tropical; L2: 42 - Malesia; L3: Lesser Sunda Is. (LSI); L4:</xsl:when>
          <xsl:when test="$pRegion='MLY'">L1: 4 - Asia-Tropical; L2: 42 - Malesia; L3: Malaya (MLY); L4:</xsl:when>
          <xsl:when test="$pRegion='MOL'">L1: 4 - Asia-Tropical; L2: 42 - Malesia; L3: Maluku (MOL); L4: Maluku (MOL-OO)</xsl:when>
          <xsl:when test="$pRegion='PHI'">L1: 4 - Asia-Tropical; L2: 42 - Malesia; L3: Philippines (PHI); L4: Philippines (PHI-OO)</xsl:when>
          <xsl:when test="$pRegion='SUL'">L1: 4 - Asia-Tropical; L2: 42 - Malesia; L3: Sulawesi (SUL); L4: Sulawesi (SUL-OO)</xsl:when>
          <xsl:when test="$pRegion='SUM'">L1: 4 - Asia-Tropical; L2: 42 - Malesia; L3: Sumatera (SUM); L4: Sumatera (SUM-OO)</xsl:when>
          <xsl:when test="$pRegion='XMS'">L1: 4 - Asia-Tropical; L2: 42 - Malesia; L3: Christmas I. (XMS); L4: Christmas I. (XMS-OO)</xsl:when>
          <xsl:when test="$pRegion='BIS'">L1: 4 - Asia-Tropical; L2: 43 - Papuasia; L3: Bismarck Archipelago (BIS); L4: Bismarck Archipelago (BIS-OO)</xsl:when>
          <xsl:when test="$pRegion='NWG'">L1: 4 - Asia-Tropical; L2: 43 - Papuasia; L3: New Guinea (NWG); L4:</xsl:when>
          <xsl:when test="$pRegion='SOL'">L1: 4 - Asia-Tropical; L2: 43 - Papuasia; L3: Solomon Is. (SOL); L4:</xsl:when>
          <xsl:when test="$pRegion='NFK'">L1: 5 - Australasia; L2: 50 - Australia; L3: Norfolk Is. (NFK); L4:</xsl:when>
          <xsl:when test="$pRegion='NSW'">L1: 5 - Australasia; L2: 50 - Australia; L3: New South Wales (NSW); L4:</xsl:when>
          <xsl:when test="$pRegion='NTA'">L1: 5 - Australasia; L2: 50 - Australia; L3: Northern Territory (NTA); L4: Northern Territory (NTA-OO)</xsl:when>
          <xsl:when test="$pRegion='QLD'">L1: 5 - Australasia; L2: 50 - Australia; L3: Queensland (QLD); L4:</xsl:when>
          <xsl:when test="$pRegion='SOA'">L1: 5 - Australasia; L2: 50 - Australia; L3: South Australia (SOA); L4: South Australia (SOA-OO)</xsl:when>
          <xsl:when test="$pRegion='TAS'">L1: 5 - Australasia; L2: 50 - Australia; L3: Tasmania (TAS); L4: Tasmania (TAS-OO)</xsl:when>
          <xsl:when test="$pRegion='VIC'">L1: 5 - Australasia; L2: 50 - Australia; L3: Victoria (VIC); L4: Victoria (VIC-OO)</xsl:when>
          <xsl:when test="$pRegion='WAU'">L1: 5 - Australasia; L2: 50 - Australia; L3: Western Australia (WAU); L4:</xsl:when>
          <xsl:when test="$pRegion='ATP'">L1: 5 - Australasia; L2: 51 - New Zealand; L3: Antipodean Is. (ATP); L4: Antipodean Is. (ATP-OO)</xsl:when>
          <xsl:when test="$pRegion='CTM'">L1: 5 - Australasia; L2: 51 - New Zealand; L3: Chatham Is. (CTM); L4: Chatham Is. (CTM-OO)</xsl:when>
          <xsl:when test="$pRegion='KER'">L1: 5 - Australasia; L2: 51 - New Zealand; L3: Kermadec Is. (KER); L4: Kermadec Is. (KER-OO)</xsl:when>
          <xsl:when test="$pRegion='NZN'">L1: 5 - Australasia; L2: 51 - New Zealand; L3: New Zealand North (NZN); L4: New Zealand North (NZN-OO)</xsl:when>
          <xsl:when test="$pRegion='NZS'">L1: 5 - Australasia; L2: 51 - New Zealand; L3: New Zealand South (NZS); L4: New Zealand South (NZS-OO)</xsl:when>
          <xsl:when test="$pRegion='FIJ'">L1: 6 - Pacific; L2: 60 - Southwestern Pacific; L3: Fiji (FIJ); L4: Fiji (FIJ-OO)</xsl:when>
          <xsl:when test="$pRegion='GIL'">L1: 6 - Pacific; L2: 60 - Southwestern Pacific; L3: Gilbert Is. (GIL); L4: Gilbert Is. (GIL-OO)</xsl:when>
          <xsl:when test="$pRegion='HBI'">L1: 6 - Pacific; L2: 60 - Southwestern Pacific; L3: Howland-Baker Is. (HBI); L4: Howland-Baker Is. (HBI-OO)</xsl:when>
          <xsl:when test="$pRegion='NRU'">L1: 6 - Pacific; L2: 60 - Southwestern Pacific; L3: Nauru (NRU); L4: Nauru (NRU-OO)</xsl:when>
          <xsl:when test="$pRegion='NUE'">L1: 6 - Pacific; L2: 60 - Southwestern Pacific; L3: Niue (NUE); L4: Niue (NUE-OO)</xsl:when>
          <xsl:when test="$pRegion='NWC'">L1: 6 - Pacific; L2: 60 - Southwestern Pacific; L3: New Caledonia (NWC); L4: New Caledonia (NWC-OO)</xsl:when>
          <xsl:when test="$pRegion='PHX'">L1: 6 - Pacific; L2: 60 - Southwestern Pacific; L3: Phoenix Is. (PHX); L4: Phoenix Is. (PHX-OO)</xsl:when>
          <xsl:when test="$pRegion='SAM'">L1: 6 - Pacific; L2: 60 - Southwestern Pacific; L3: Samoa (SAM); L4:</xsl:when>
          <xsl:when test="$pRegion='SCZ'">L1: 6 - Pacific; L2: 60 - Southwestern Pacific; L3: Santa Cruz Is. (SCZ); L4: Santa Cruz Is. (SCZ-OO)</xsl:when>
          <xsl:when test="$pRegion='TOK'">L1: 6 - Pacific; L2: 60 - Southwestern Pacific; L3: Tokelau-Manihiki (TOK); L4:</xsl:when>
          <xsl:when test="$pRegion='TON'">L1: 6 - Pacific; L2: 60 - Southwestern Pacific; L3: Tonga (TON); L4: Tonga (TON-OO)</xsl:when>
          <xsl:when test="$pRegion='TUV'">L1: 6 - Pacific; L2: 60 - Southwestern Pacific; L3: Tuvalu (TUV); L4: Tuvalu (TUV-OO)</xsl:when>
          <xsl:when test="$pRegion='VAN'">L1: 6 - Pacific; L2: 60 - Southwestern Pacific; L3: Vanuatu (VAN); L4: Vanuatu (VAN-OO)</xsl:when>
          <xsl:when test="$pRegion='WAL'">L1: 6 - Pacific; L2: 60 - Southwestern Pacific; L3: Wallis-Futuna Is. (WAL); L4: Wallis-Futuna Is. (WAL-OO)</xsl:when>
          <xsl:when test="$pRegion='COO'">L1: 6 - Pacific; L2: 61 - South-Central Pacific; L3: Cook Is. (COO); L4: Cook Is. (COO-OO)</xsl:when>
          <xsl:when test="$pRegion='EAS'">L1: 6 - Pacific; L2: 61 - South-Central Pacific; L3: Easter Is. (EAS); L4: Easter Is. (EAS-OO)</xsl:when>
          <xsl:when test="$pRegion='LIN'">L1: 6 - Pacific; L2: 61 - South-Central Pacific; L3: Line Is. (LIN); L4:</xsl:when>
          <xsl:when test="$pRegion='MRQ'">L1: 6 - Pacific; L2: 61 - South-Central Pacific; L3: Marquesas (MRQ); L4: Marquesas (MRQ-OO)</xsl:when>
          <xsl:when test="$pRegion='PIT'">L1: 6 - Pacific; L2: 61 - South-Central Pacific; L3: Pitcairn Is. (PIT); L4: Pitcairn Is. (PIT-OO)</xsl:when>
          <xsl:when test="$pRegion='SCI'">L1: 6 - Pacific; L2: 61 - South-Central Pacific; L3: Society Is. (SCI); L4: Society Is. (SCI-OO)</xsl:when>
          <xsl:when test="$pRegion='TUA'">L1: 6 - Pacific; L2: 61 - South-Central Pacific; L3: Tuamotu (TUA); L4: Tuamotu (TUA-OO)</xsl:when>
          <xsl:when test="$pRegion='TUB'">L1: 6 - Pacific; L2: 61 - South-Central Pacific; L3: Tubuai Is. (TUB); L4: Tubuai Is. (TUB-OO)</xsl:when>
          <xsl:when test="$pRegion='CRL'">L1: 6 - Pacific; L2: 62 - Northwestern Pacific; L3: Caroline Is. (CRL); L4:</xsl:when>
          <xsl:when test="$pRegion='MCS'">L1: 6 - Pacific; L2: 62 - Northwestern Pacific; L3: Marcus I. (MCS); L4: Marcus I. (MCS-OO)</xsl:when>
          <xsl:when test="$pRegion='MRN'">L1: 6 - Pacific; L2: 62 - Northwestern Pacific; L3: Marianas (MRN); L4:</xsl:when>
          <xsl:when test="$pRegion='MRS'">L1: 6 - Pacific; L2: 62 - Northwestern Pacific; L3: Marshall Is. (MRS); L4: Marshall Is. (MRS-OO)</xsl:when>
          <xsl:when test="$pRegion='WAK'">L1: 6 - Pacific; L2: 62 - Northwestern Pacific; L3: Wake I. (WAK); L4: Wake I. (WAK-OO)</xsl:when>
          <xsl:when test="$pRegion='HAW'">L1: 6 - Pacific; L2: 63 - North-Central Pacific; L3: Hawaii (HAW); L4:</xsl:when>
          <xsl:when test="$pRegion='ALU'">L1: 7 - Northern America; L2: 70 - Subarctic America; L3: Aleutian Is. (ALU); L4: Aleutian Is. (ALU-OO)</xsl:when>
          <xsl:when test="$pRegion='ASK'">L1: 7 - Northern America; L2: 70 - Subarctic America; L3: Alaska (ASK); L4: Alaska (ASK-OO)</xsl:when>
          <xsl:when test="$pRegion='GNL'">L1: 7 - Northern America; L2: 70 - Subarctic America; L3: Greenland (GNL); L4: Greenland (GNL-OO)</xsl:when>
          <xsl:when test="$pRegion='NUN'">L1: 7 - Northern America; L2: 70 - Subarctic America; L3: Nunavut (NUN); L4: Nunavut (NUN-OO)</xsl:when>
          <xsl:when test="$pRegion='NWT'">L1: 7 - Northern America; L2: 70 - Subarctic America; L3: Northwest Territories (NWT); L4: Northwest Territories (NWT-OO)</xsl:when>
          <xsl:when test="$pRegion='YUK'">L1: 7 - Northern America; L2: 70 - Subarctic America; L3: Yukon (YUK); L4: Yukon (YUK-OO)</xsl:when>
          <xsl:when test="$pRegion='ABT'">L1: 7 - Northern America; L2: 71 - Western Canada; L3: Alberta (ABT); L4: Alberta (ABT-OO)</xsl:when>
          <xsl:when test="$pRegion='BRC'">L1: 7 - Northern America; L2: 71 - Western Canada; L3: British Columbia (BRC); L4: British Columbia (BRC-OO)</xsl:when>
          <xsl:when test="$pRegion='MAN'">L1: 7 - Northern America; L2: 71 - Western Canada; L3: Manitoba (MAN); L4: Manitoba (MAN-OO)</xsl:when>
          <xsl:when test="$pRegion='SAS'">L1: 7 - Northern America; L2: 71 - Western Canada; L3: Saskatchewan (SAS); L4: Saskatchewan (SAS-OO)</xsl:when>
          <xsl:when test="$pRegion='LAB'">L1: 7 - Northern America; L2: 72 - Eastern Canada; L3: Labrador (LAB); L4: Labrador (LAB-OO)</xsl:when>
          <xsl:when test="$pRegion='NBR'">L1: 7 - Northern America; L2: 72 - Eastern Canada; L3: New Brunswick (NBR); L4: New Brunswick (NBR-OO)</xsl:when>
          <xsl:when test="$pRegion='NFL'">L1: 7 - Northern America; L2: 72 - Eastern Canada; L3: Newfoundland (NFL); L4:</xsl:when>
          <xsl:when test="$pRegion='NSC'">L1: 7 - Northern America; L2: 72 - Eastern Canada; L3: Nova Scotia (NSC); L4: Nova Scotia (NSC-OO)</xsl:when>
          <xsl:when test="$pRegion='ONT'">L1: 7 - Northern America; L2: 72 - Eastern Canada; L3: Ontario (ONT); L4: Ontario (ONT-OO)</xsl:when>
          <xsl:when test="$pRegion='PEI'">L1: 7 - Northern America; L2: 72 - Eastern Canada; L3: Prince Edward I. (PEI); L4: Prince Edward I. (PEI-OO)</xsl:when>
          <xsl:when test="$pRegion='QUE'">L1: 7 - Northern America; L2: 72 - Eastern Canada; L3: Québec (QUE); L4: Québec (QUE-OO)</xsl:when>
          <xsl:when test="$pRegion='COL'">L1: 7 - Northern America; L2: 73 - Northwestern U.S.A.; L3: Colorado (COL); L4: Colorado (COL-OO)</xsl:when>
          <xsl:when test="$pRegion='IDA'">L1: 7 - Northern America; L2: 73 - Northwestern U.S.A.; L3: Idaho (IDA); L4: Idaho (IDA-OO)</xsl:when>
          <xsl:when test="$pRegion='MNT'">L1: 7 - Northern America; L2: 73 - Northwestern U.S.A.; L3: Montana (MNT); L4: Montana (MNT-OO)</xsl:when>
          <xsl:when test="$pRegion='ORE'">L1: 7 - Northern America; L2: 73 - Northwestern U.S.A.; L3: Oregon (ORE); L4: Oregon (ORE-OO)</xsl:when>
          <xsl:when test="$pRegion='WAS'">L1: 7 - Northern America; L2: 73 - Northwestern U.S.A.; L3: Washington (WAS); L4: Washington (WAS-OO)</xsl:when>
          <xsl:when test="$pRegion='WYO'">L1: 7 - Northern America; L2: 73 - Northwestern U.S.A.; L3: Wyoming (WYO); L4: Wyoming (WYO-OO)</xsl:when>
          <xsl:when test="$pRegion='ILL'">L1: 7 - Northern America; L2: 74 - North-Central U.S.A.; L3: Illinois (ILL); L4: Illinois (ILL-OO)</xsl:when>
          <xsl:when test="$pRegion='IOW'">L1: 7 - Northern America; L2: 74 - North-Central U.S.A.; L3: Iowa (IOW); L4: Iowa (IOW-OO)</xsl:when>
          <xsl:when test="$pRegion='KAN'">L1: 7 - Northern America; L2: 74 - North-Central U.S.A.; L3: Kansas (KAN); L4: Kansas (KAN-OO)</xsl:when>
          <xsl:when test="$pRegion='MIN'">L1: 7 - Northern America; L2: 74 - North-Central U.S.A.; L3: Minnesota (MIN); L4: Minnesota (MIN-OO)</xsl:when>
          <xsl:when test="$pRegion='MSO'">L1: 7 - Northern America; L2: 74 - North-Central U.S.A.; L3: Missouri (MSO); L4: Missouri (MSO-OO)</xsl:when>
          <xsl:when test="$pRegion='NDA'">L1: 7 - Northern America; L2: 74 - North-Central U.S.A.; L3: North Dakota (NDA); L4: North Dakota (NDA-OO)</xsl:when>
          <xsl:when test="$pRegion='NEB'">L1: 7 - Northern America; L2: 74 - North-Central U.S.A.; L3: Nebraska (NEB); L4: Nebraska (NEB-OO)</xsl:when>
          <xsl:when test="$pRegion='OKL'">L1: 7 - Northern America; L2: 74 - North-Central U.S.A.; L3: Oklahoma (OKL); L4: Oklahoma (OKL-OO)</xsl:when>
          <xsl:when test="$pRegion='SDA'">L1: 7 - Northern America; L2: 74 - North-Central U.S.A.; L3: South Dakota (SDA); L4: South Dakota (SDA-OO)</xsl:when>
          <xsl:when test="$pRegion='WIS'">L1: 7 - Northern America; L2: 74 - North-Central U.S.A.; L3: Wisconsin (WIS); L4: Wisconsin (WIS-OO)</xsl:when>
          <xsl:when test="$pRegion='CNT'">L1: 7 - Northern America; L2: 75 - Northeastern U.S.A.; L3: Connecticut (CNT); L4: Connecticut (CNT-OO)</xsl:when>
          <xsl:when test="$pRegion='INI'">L1: 7 - Northern America; L2: 75 - Northeastern U.S.A.; L3: Indiana (INI); L4: Indiana (INI-OO)</xsl:when>
          <xsl:when test="$pRegion='MAI'">L1: 7 - Northern America; L2: 75 - Northeastern U.S.A.; L3: Maine (MAI); L4: Maine (MAI-OO)</xsl:when>
          <xsl:when test="$pRegion='MAS'">L1: 7 - Northern America; L2: 75 - Northeastern U.S.A.; L3: Masachusettes (MAS); L4: Masachusettes (MAS-OO)</xsl:when>
          <xsl:when test="$pRegion='MIC'">L1: 7 - Northern America; L2: 75 - Northeastern U.S.A.; L3: Michigan (MIC); L4: Michigan (MIC-OO)</xsl:when>
          <xsl:when test="$pRegion='NWH'">L1: 7 - Northern America; L2: 75 - Northeastern U.S.A.; L3: New Hampshire (NWH); L4: New Hampshire (NWH-OO)</xsl:when>
          <xsl:when test="$pRegion='NWJ'">L1: 7 - Northern America; L2: 75 - Northeastern U.S.A.; L3: New Jersey (NWJ); L4: New Jersey (NWJ-OO)</xsl:when>
          <xsl:when test="$pRegion='NWY'">L1: 7 - Northern America; L2: 75 - Northeastern U.S.A.; L3: New York (NWY); L4: New York (NWY-OO)</xsl:when>
          <xsl:when test="$pRegion='OHI'">L1: 7 - Northern America; L2: 75 - Northeastern U.S.A.; L3: Ohio (OHI); L4: Ohio (OHI-OO)</xsl:when>
          <xsl:when test="$pRegion='PEN'">L1: 7 - Northern America; L2: 75 - Northeastern U.S.A.; L3: Pennsylvania (PEN); L4: Pennsylvania (PEN-OO)</xsl:when>
          <xsl:when test="$pRegion='RHO'">L1: 7 - Northern America; L2: 75 - Northeastern U.S.A.; L3: Rhode I. (RHO); L4: Rhode I. (RHO-OO)</xsl:when>
          <xsl:when test="$pRegion='VER'">L1: 7 - Northern America; L2: 75 - Northeastern U.S.A.; L3: Vermont (VER); L4: Vermont (VER-OO)</xsl:when>
          <xsl:when test="$pRegion='WVA'">L1: 7 - Northern America; L2: 75 - Northeastern U.S.A.; L3: West Virginia (WVA); L4: West Virginia (WVA-OO)</xsl:when>
          <xsl:when test="$pRegion='ARI'">L1: 7 - Northern America; L2: 76 - Southwestern U.S.A.; L3: Arizona (ARI); L4: Arizona (ARI-OO)</xsl:when>
          <xsl:when test="$pRegion='CAL'">L1: 7 - Northern America; L2: 76 - Southwestern U.S.A.; L3: California (CAL); L4: California (CAL-OO)</xsl:when>
          <xsl:when test="$pRegion='NEV'">L1: 7 - Northern America; L2: 76 - Southwestern U.S.A.; L3: Nevada (NEV); L4: Nevada (NEV-OO)</xsl:when>
          <xsl:when test="$pRegion='UTA'">L1: 7 - Northern America; L2: 76 - Southwestern U.S.A.; L3: Utah (UTA); L4: Utah (UTA-OO)</xsl:when>
          <xsl:when test="$pRegion='NWM'">L1: 7 - Northern America; L2: 77 - South-Central U.S.A.; L3: New Mexico (NWM); L4: New Mexico (NWM-OO)</xsl:when>
          <xsl:when test="$pRegion='TEX'">L1: 7 - Northern America; L2: 77 - South-Central U.S.A.; L3: Texas (TEX); L4: Texas (TEX-OO)</xsl:when>
          <xsl:when test="$pRegion='ALA'">L1: 7 - Northern America; L2: 78 - Southeastern U.S.A.; L3: Alabama (ALA); L4: Alabama (ALA-OO)</xsl:when>
          <xsl:when test="$pRegion='ARK'">L1: 7 - Northern America; L2: 78 - Southeastern U.S.A.; L3: Arkansas (ARK); L4: Arkansas (ARK-OO)</xsl:when>
          <xsl:when test="$pRegion='DEL'">L1: 7 - Northern America; L2: 78 - Southeastern U.S.A.; L3: Delaware (DEL); L4: Delaware (DEL-OO)</xsl:when>
          <xsl:when test="$pRegion='FLA'">L1: 7 - Northern America; L2: 78 - Southeastern U.S.A.; L3: Florida (FLA); L4: Florida (FLA-OO)</xsl:when>
          <xsl:when test="$pRegion='GEO'">L1: 7 - Northern America; L2: 78 - Southeastern U.S.A.; L3: Georgia (GEO); L4: Georgia (GEO-OO)</xsl:when>
          <xsl:when test="$pRegion='KTY'">L1: 7 - Northern America; L2: 78 - Southeastern U.S.A.; L3: Kentucky (KTY); L4: Kentucky (KTY-OO)</xsl:when>
          <xsl:when test="$pRegion='LOU'">L1: 7 - Northern America; L2: 78 - Southeastern U.S.A.; L3: Louisiana (LOU); L4: Louisiana (LOU-OO)</xsl:when>
          <xsl:when test="$pRegion='MRY'">L1: 7 - Northern America; L2: 78 - Southeastern U.S.A.; L3: Maryland (MRY); L4: Maryland (MRY-OO)</xsl:when>
          <xsl:when test="$pRegion='MSI'">L1: 7 - Northern America; L2: 78 - Southeastern U.S.A.; L3: Mississippi (MSI); L4: Mississippi (MSI-OO)</xsl:when>
          <xsl:when test="$pRegion='NCA'">L1: 7 - Northern America; L2: 78 - Southeastern U.S.A.; L3: North Carolina (NCA); L4: North Carolina (NCA-OO)</xsl:when>
          <xsl:when test="$pRegion='SCA'">L1: 7 - Northern America; L2: 78 - Southeastern U.S.A.; L3: South Carolina (SCA); L4: South Carolina (SCA-OO)</xsl:when>
          <xsl:when test="$pRegion='TEN'">L1: 7 - Northern America; L2: 78 - Southeastern U.S.A.; L3: Tennessee (TEN); L4: Tennessee (TEN-OO)</xsl:when>
          <xsl:when test="$pRegion='VRG'">L1: 7 - Northern America; L2: 78 - Southeastern U.S.A.; L3: Virginia (VRG); L4: Virginia (VRG-OO)</xsl:when>
          <xsl:when test="$pRegion='WDC'">L1: 7 - Northern America; L2: 78 - Southeastern U.S.A.; L3: District of Columbia (WDC); L4: District of Columbia (WDC-OO)</xsl:when>
          <xsl:when test="$pRegion='MXC'">L1: 7 - Northern America; L2: 79 - Mexico; L3: Mexico Central (MXC); L4:</xsl:when>
          <xsl:when test="$pRegion='MXE'">L1: 7 - Northern America; L2: 79 - Mexico; L3: Mexico Northeast (MXE); L4:</xsl:when>
          <xsl:when test="$pRegion='MXG'">L1: 7 - Northern America; L2: 79 - Mexico; L3: Mexico Gulf (MXG); L4: Veracruz (MXG-VC)</xsl:when>
          <xsl:when test="$pRegion='MXI'">L1: 7 - Northern America; L2: 79 - Mexico; L3: Mexican Pacific Is. (MXI); L4:</xsl:when>
          <xsl:when test="$pRegion='MXN'">L1: 7 - Northern America; L2: 79 - Mexico; L3: Mexico Northwest (MXN); L4:</xsl:when>
          <xsl:when test="$pRegion='MXS'">L1: 7 - Northern America; L2: 79 - Mexico; L3: Mexico Southwest (MXS); L4:</xsl:when>
          <xsl:when test="$pRegion='MXT'">L1: 7 - Northern America; L2: 79 - Mexico; L3: Mexico Southeast (MXT); L4:</xsl:when>
          <xsl:when test="$pRegion='BLZ'">L1: 8 - Southern America; L2: 80 - Central America; L3: Belize (BLZ); L4: Belize (BLZ-OO)</xsl:when>
          <xsl:when test="$pRegion='COS'">L1: 8 - Southern America; L2: 80 - Central America; L3: Costa Rica (COS); L4: Costa Rica (COS-OO)</xsl:when>
          <xsl:when test="$pRegion='CPI'">L1: 8 - Southern America; L2: 80 - Central America; L3: Central American Pacific Is. (CPI); L4:</xsl:when>
          <xsl:when test="$pRegion='ELS'">L1: 8 - Southern America; L2: 80 - Central America; L3: El Salvador (ELS); L4: El Salvador (ELS-OO)</xsl:when>
          <xsl:when test="$pRegion='GUA'">L1: 8 - Southern America; L2: 80 - Central America; L3: Guatemala (GUA); L4: Guatemala (GUA-OO)</xsl:when>
          <xsl:when test="$pRegion='HON'">L1: 8 - Southern America; L2: 80 - Central America; L3: Honduras (HON); L4: Honduras (HON-OO)</xsl:when>
          <xsl:when test="$pRegion='NIC'">L1: 8 - Southern America; L2: 80 - Central America; L3: Nicaragua (NIC); L4: Nicaragua (NIC-OO)</xsl:when>
          <xsl:when test="$pRegion='PAN'">L1: 8 - Southern America; L2: 80 - Central America; L3: Panamá (PAN); L4: Panamá (PAN-OO)</xsl:when>
          <xsl:when test="$pRegion='ARU'">L1: 8 - Southern America; L2: 81 - Caribbean; L3: Aruba (ARU); L4: Aruba (ARU-OO)</xsl:when>
          <xsl:when test="$pRegion='BAH'">L1: 8 - Southern America; L2: 81 - Caribbean; L3: Bahamas (BAH); L4: Bahamas (BAH-OO)</xsl:when>
          <xsl:when test="$pRegion='BER'">L1: 8 - Southern America; L2: 81 - Caribbean; L3: Bermuda (BER); L4: Bermuda (BER-OO)</xsl:when>
          <xsl:when test="$pRegion='CAY'">L1: 8 - Southern America; L2: 81 - Caribbean; L3: Cayman Is. (CAY); L4: Cayman Is. (CAY-OO)</xsl:when>
          <xsl:when test="$pRegion='CUB'">L1: 8 - Southern America; L2: 81 - Caribbean; L3: Cuba (CUB); L4: Cuba (CUB-OO)</xsl:when>
          <xsl:when test="$pRegion='DOM'">L1: 8 - Southern America; L2: 81 - Caribbean; L3: Dominican Republic (DOM); L4: Dominican Republic (DOM-OO)</xsl:when>
          <xsl:when test="$pRegion='HAI'">L1: 8 - Southern America; L2: 81 - Caribbean; L3: Haiti (HAI); L4:</xsl:when>
          <xsl:when test="$pRegion='JAM'">L1: 8 - Southern America; L2: 81 - Caribbean; L3: Jamaica (JAM); L4: Jamaica (JAM-OO)</xsl:when>
          <xsl:when test="$pRegion='LEE'">L1: 8 - Southern America; L2: 81 - Caribbean; L3: Leeward Is. (LEE); L4:</xsl:when>
          <xsl:when test="$pRegion='NLA'">L1: 8 - Southern America; L2: 81 - Caribbean; L3: Netherlands Antilles (NLA); L4:</xsl:when>
          <xsl:when test="$pRegion='PUE'">L1: 8 - Southern America; L2: 81 - Caribbean; L3: Puerto Rico (PUE); L4: Puerto Rico (PUE-OO)</xsl:when>
          <xsl:when test="$pRegion='SWC'">L1: 8 - Southern America; L2: 81 - Caribbean; L3: Southwest Caribbean (SWC); L4:</xsl:when>
          <xsl:when test="$pRegion='TCI'">L1: 8 - Southern America; L2: 81 - Caribbean; L3: Turks-Caicos Is. (TCI); L4: Turks-Caicos Is. (TCI-OO)</xsl:when>
          <xsl:when test="$pRegion='TRT'">L1: 8 - Southern America; L2: 81 - Caribbean; L3: Trinidad-Tobago (TRT); L4: Trinidad-Tobago (TRT-OO)</xsl:when>
          <xsl:when test="$pRegion='VNA'">L1: 8 - Southern America; L2: 81 - Caribbean; L3: Venezuelan Antilles (VNA); L4: Venezuelan Antilles (VNA-OO)</xsl:when>
          <xsl:when test="$pRegion='WIN'">L1: 8 - Southern America; L2: 81 - Caribbean; L3: Windward Is. (WIN); L4:</xsl:when>
          <xsl:when test="$pRegion='FRG'">L1: 8 - Southern America; L2: 82 - Northern South America; L3: French Guiana (FRG); L4: French Guiana (FRG-OO)</xsl:when>
          <xsl:when test="$pRegion='GUY'">L1: 8 - Southern America; L2: 82 - Northern South America; L3: Guyana (GUY); L4: Guyana (GUY-OO)</xsl:when>
          <xsl:when test="$pRegion='SUR'">L1: 8 - Southern America; L2: 82 - Northern South America; L3: Suriname (SUR); L4: Surinam (SUR-OO)</xsl:when>
          <xsl:when test="$pRegion='VEN'">L1: 8 - Southern America; L2: 82 - Northern South America; L3: Venezuela (VEN); L4: Venezuela (VEN-OO)</xsl:when>
          <xsl:when test="$pRegion='BOL'">L1: 8 - Southern America; L2: 83 - Western South America; L3: Bolivia (BOL); L4: Bolivia (BOL-OO)</xsl:when>
          <xsl:when test="$pRegion='CLM'">L1: 8 - Southern America; L2: 83 - Western South America; L3: Colombia (CLM); L4: Colombia (CLM-OO)</xsl:when>
          <xsl:when test="$pRegion='ECU'">L1: 8 - Southern America; L2: 83 - Western South America; L3: Ecuador (ECU); L4: Ecuador (ECU-OO)</xsl:when>
          <xsl:when test="$pRegion='GAL'">L1: 8 - Southern America; L2: 83 - Western South America; L3: Galápagos (GAL); L4: Galápagos (GAL-OO)</xsl:when>
          <xsl:when test="$pRegion='PER'">L1: 8 - Southern America; L2: 83 - Western South America; L3: Peru (PER); L4: Peru (PER-OO)</xsl:when>
          <xsl:when test="$pRegion='BZC'">L1: 8 - Southern America; L2: 84 - Brazil; L3: Brazil West-Central (BZC); L4:</xsl:when>
          <xsl:when test="$pRegion='BZE'">L1: 8 - Southern America; L2: 84 - Brazil; L3: Brazil Northeast (BZE); L4:</xsl:when>
          <xsl:when test="$pRegion='BZL'">L1: 8 - Southern America; L2: 84 - Brazil; L3: Brazil Southeast (BZL); L4:</xsl:when>
          <xsl:when test="$pRegion='BZN'">L1: 8 - Southern America; L2: 84 - Brazil; L3: Brazil North (BZN); L4:</xsl:when>
          <xsl:when test="$pRegion='BZS'">L1: 8 - Southern America; L2: 84 - Brazil; L3: Brazil South (BZS); L4:</xsl:when>
          <xsl:when test="$pRegion='AGE'">L1: 8 - Southern America; L2: 85 - Southern South America; L3: Argentina Northeast (AGE); L4:</xsl:when>
          <xsl:when test="$pRegion='AGS'">L1: 8 - Southern America; L2: 85 - Southern South America; L3: Argentina South (AGS); L4:</xsl:when>
          <xsl:when test="$pRegion='AGW'">L1: 8 - Southern America; L2: 85 - Southern South America; L3: Argentina Northwest (AGW); L4:</xsl:when>
          <xsl:when test="$pRegion='CLC'">L1: 8 - Southern America; L2: 85 - Southern South America; L3: Chile Central (CLC); L4:</xsl:when>
          <xsl:when test="$pRegion='CLN'">L1: 8 - Southern America; L2: 85 - Southern South America; L3: Chile North (CLN); L4:</xsl:when>
          <xsl:when test="$pRegion='CLS'">L1: 8 - Southern America; L2: 85 - Southern South America; L3: Chile South (CLS); L4:</xsl:when>
          <xsl:when test="$pRegion='DSV'">L1: 8 - Southern America; L2: 85 - Southern South America; L3: Desventurados Is. (DSV); L4: Desventurados Is. (DSV-OO)</xsl:when>
          <xsl:when test="$pRegion='JNF'">L1: 8 - Southern America; L2: 85 - Southern South America; L3: Juan Fernández Is. (JNF); L4: Juan Fernández Is. (JNF-OO)</xsl:when>
          <xsl:when test="$pRegion='PAR'">L1: 8 - Southern America; L2: 85 - Southern South America; L3: Paraguay (PAR); L4: Paraguay (PAR-OO)</xsl:when>
          <xsl:when test="$pRegion='URU'">L1: 8 - Southern America; L2: 85 - Southern South America; L3: Uruguay (URU); L4: Uruguay (URU-OO)</xsl:when>
          <xsl:when test="$pRegion='ASP'">L1: 9 - Antarctic; L2: 90 - Subantarctic Islands; L3: Amsterdam-St.Paul Is. (ASP); L4: Amsterdam-St.Paul Is. (ASP-OO)</xsl:when>
          <xsl:when test="$pRegion='BOU'">L1: 9 - Antarctic; L2: 90 - Subantarctic Islands; L3: Bouvet I. (BOU); L4: Bouvet I. (BOU-OO)</xsl:when>
          <xsl:when test="$pRegion='CRZ'">L1: 9 - Antarctic; L2: 90 - Subantarctic Islands; L3: Crozet Is. (CRZ); L4: Crozet Is. (CRZ-OO)</xsl:when>
          <xsl:when test="$pRegion='FAL'">L1: 9 - Antarctic; L2: 90 - Subantarctic Islands; L3: Falkland Is. (FAL); L4: Falkland Is. (FAL-OO)</xsl:when>
          <xsl:when test="$pRegion='HMD'">L1: 9 - Antarctic; L2: 90 - Subantarctic Islands; L3: Heard-McDonald Is. (HMD); L4: Heard-McDonald Is. (HMD-OO)</xsl:when>
          <xsl:when test="$pRegion='KEG'">L1: 9 - Antarctic; L2: 90 - Subantarctic Islands; L3: Kerguelen (KEG); L4: Kerguelen (KEG-OO)</xsl:when>
          <xsl:when test="$pRegion='MAQ'">L1: 9 - Antarctic; L2: 90 - Subantarctic Islands; L3: Macquarie Is. (MAQ); L4: Macquarie Is. (MAQ-OO)</xsl:when>
          <xsl:when test="$pRegion='MPE'">L1: 9 - Antarctic; L2: 90 - Subantarctic Islands; L3: Marion-Prince Edward Is. (MPE); L4: Marion-Prince Edward Is. (MPE-OO)</xsl:when>
          <xsl:when test="$pRegion='SGE'">L1: 9 - Antarctic; L2: 90 - Subantarctic Islands; L3: South Georgia (SGE); L4: South Georgia (SGE-OO)</xsl:when>
          <xsl:when test="$pRegion='SSA'">L1: 9 - Antarctic; L2: 90 - Subantarctic Islands; L3: South Sandwich Is. (SSA); L4: South Sandwich Is. (SSA-OO)</xsl:when>
          <xsl:when test="$pRegion='TDC'">L1: 9 - Antarctic; L2: 90 - Subantarctic Islands; L3: Tristan da Cunha (TDC); L4: Tristan da Cunha (TDC-OO)</xsl:when>
          <xsl:when test="$pRegion='ANT'">L1: 9 - Antarctic; L2: 91 - Antarctic Continent; L3: Antarctica (ANT); L4: Antarctica (ANT-OO)</xsl:when>        </xsl:choose>
      </xsl:when>
      <xsl:when test="$pSchema='TDWG Level 4'">
        <xsl:choose>
          <xsl:when test="$pRegion='DEN-OO'">L1: 1 - Europe; L2: 10 - Northern Europe; L3: Denmark (DEN); L4: Denmark (DEN-OO)</xsl:when>
          <xsl:when test="$pRegion='FIN-OO'">L1: 1 - Europe; L2: 10 - Northern Europe; L3: Finland (FIN); L4: Finland (FIN-OO)</xsl:when>
          <xsl:when test="$pRegion='FOR-OO'">L1: 1 - Europe; L2: 10 - Northern Europe; L3: Føroyar (FOR); L4: Føroyar (FOR-OO)</xsl:when>
          <xsl:when test="$pRegion='GRB-OO'">L1: 1 - Europe; L2: 10 - Northern Europe; L3: Great Britain (GRB); L4: Great Britain (GRB-OO)</xsl:when>
          <xsl:when test="$pRegion='ICE-OO'">L1: 1 - Europe; L2: 10 - Northern Europe; L3: Iceland (ICE); L4: Iceland (ICE-OO)</xsl:when>
          <xsl:when test="$pRegion='IRE-IR'">L1: 1 - Europe; L2: 10 - Northern Europe; L3: Ireland (IRE); L4: Ireland (IRE-IR)</xsl:when>
          <xsl:when test="$pRegion='IRE-NI'">L1: 1 - Europe; L2: 10 - Northern Europe; L3: Ireland (IRE); L4: Northern Ireland (IRE-NI)</xsl:when>
          <xsl:when test="$pRegion='NOR-OO'">L1: 1 - Europe; L2: 10 - Northern Europe; L3: Norway (NOR); L4: Norway (NOR-OO)</xsl:when>
          <xsl:when test="$pRegion='SVA-OO'">L1: 1 - Europe; L2: 10 - Northern Europe; L3: Svalbard (SVA); L4: Svalbard (SVA-OO)</xsl:when>
          <xsl:when test="$pRegion='SWE-OO'">L1: 1 - Europe; L2: 10 - Northern Europe; L3: Sweden (SWE); L4: Sweden (SWE-OO)</xsl:when>
          <xsl:when test="$pRegion='AUT-AU'">L1: 1 - Europe; L2: 11 - Middle Europe; L3: Austria (AUT); L4: Austria (AUT-AU)</xsl:when>
          <xsl:when test="$pRegion='AUT-LI'">L1: 1 - Europe; L2: 11 - Middle Europe; L3: Austria (AUT); L4: Liechtenstein (AUT-LI)</xsl:when>
          <xsl:when test="$pRegion='BGM-BE'">L1: 1 - Europe; L2: 11 - Middle Europe; L3: Belgium (BGM); L4: Belgium (BGM-BE)</xsl:when>
          <xsl:when test="$pRegion='BGM-LU'">L1: 1 - Europe; L2: 11 - Middle Europe; L3: Belgium (BGM); L4: Luxembourg (BGM-LU)</xsl:when>
          <xsl:when test="$pRegion='CZE-CZ'">L1: 1 - Europe; L2: 11 - Middle Europe; L3: Czechoslovakia (CZE); L4: Czech Republic (CZE-CZ)</xsl:when>
          <xsl:when test="$pRegion='CZE-SK'">L1: 1 - Europe; L2: 11 - Middle Europe; L3: Czechoslovakia (CZE); L4: Slovakia (CZE-SK)</xsl:when>
          <xsl:when test="$pRegion='GER-OO'">L1: 1 - Europe; L2: 11 - Middle Europe; L3: Germany (GER); L4: Germany (GER-OO)</xsl:when>
          <xsl:when test="$pRegion='HUN-OO'">L1: 1 - Europe; L2: 11 - Middle Europe; L3: Hungary (HUN); L4: Hungary (HUN-OO)</xsl:when>
          <xsl:when test="$pRegion='NET-OO'">L1: 1 - Europe; L2: 11 - Middle Europe; L3: Netherlands (NET); L4: Netherlands (NET-OO)</xsl:when>
          <xsl:when test="$pRegion='POL-OO'">L1: 1 - Europe; L2: 11 - Middle Europe; L3: Poland (POL); L4: Poland (POL-OO)</xsl:when>
          <xsl:when test="$pRegion='SWI-OO'">L1: 1 - Europe; L2: 11 - Middle Europe; L3: Switzerland (SWI); L4: Switzerland (SWI-OO)</xsl:when>
          <xsl:when test="$pRegion='BAL-OO'">L1: 1 - Europe; L2: 12 - Southwestern Europe; L3: Baleares (BAL); L4: Baleares (BAL-OO)</xsl:when>
          <xsl:when test="$pRegion='COR-OO'">L1: 1 - Europe; L2: 12 - Southwestern Europe; L3: Corse (COR); L4: Corse (COR-OO)</xsl:when>
          <xsl:when test="$pRegion='FRA-CI'">L1: 1 - Europe; L2: 12 - Southwestern Europe; L3: France (FRA); L4: Channel Is. (FRA-CI)</xsl:when>
          <xsl:when test="$pRegion='FRA-FR'">L1: 1 - Europe; L2: 12 - Southwestern Europe; L3: France (FRA); L4: France (FRA-FR)</xsl:when>
          <xsl:when test="$pRegion='FRA-MO'">L1: 1 - Europe; L2: 12 - Southwestern Europe; L3: France (FRA); L4: Monaco (FRA-MO)</xsl:when>
          <xsl:when test="$pRegion='POR-OO'">L1: 1 - Europe; L2: 12 - Southwestern Europe; L3: Portugal (POR); L4: Portugal (POR-OO)</xsl:when>
          <xsl:when test="$pRegion='SAR-OO'">L1: 1 - Europe; L2: 12 - Southwestern Europe; L3: Sardegna (SAR); L4: Sardegna (SAR-OO)</xsl:when>
          <xsl:when test="$pRegion='SPA-AN'">L1: 1 - Europe; L2: 12 - Southwestern Europe; L3: Spain (SPA); L4: Andorra (SPA-AN)</xsl:when>
          <xsl:when test="$pRegion='SPA-GI'">L1: 1 - Europe; L2: 12 - Southwestern Europe; L3: Spain (SPA); L4: Gilbraltar (SPA-GI)</xsl:when>
          <xsl:when test="$pRegion='SPA-SP'">L1: 1 - Europe; L2: 12 - Southwestern Europe; L3: Spain (SPA); L4: Spain (SPA-SP)</xsl:when>
          <xsl:when test="$pRegion='ALB-OO'">L1: 1 - Europe; L2: 13 - Southeastern Europe; L3: Albania (ALB); L4: Albania (ALB-OO)</xsl:when>
          <xsl:when test="$pRegion='BUL-OO'">L1: 1 - Europe; L2: 13 - Southeastern Europe; L3: Bulgaria (BUL); L4: Bulgaria (BUL-OO)</xsl:when>
          <xsl:when test="$pRegion='GRC-OO'">L1: 1 - Europe; L2: 13 - Southeastern Europe; L3: Greece (GRC); L4: Greece (GRC-OO)</xsl:when>
          <xsl:when test="$pRegion='ITA-IT'">L1: 1 - Europe; L2: 13 - Southeastern Europe; L3: Italy (ITA); L4: Italy (ITA-IT)</xsl:when>
          <xsl:when test="$pRegion='ITA-SM'">L1: 1 - Europe; L2: 13 - Southeastern Europe; L3: Italy (ITA); L4: San Marino (ITA-SM)</xsl:when>
          <xsl:when test="$pRegion='ITA-VC'">L1: 1 - Europe; L2: 13 - Southeastern Europe; L3: Italy (ITA); L4: Vatican City (ITA-VC)</xsl:when>
          <xsl:when test="$pRegion='KRI-OO'">L1: 1 - Europe; L2: 13 - Southeastern Europe; L3: Kriti (KRI); L4: Kriti (KRI-OO)</xsl:when>
          <xsl:when test="$pRegion='ROM-OO'">L1: 1 - Europe; L2: 13 - Southeastern Europe; L3: Romania (ROM); L4: Romania (ROM-OO)</xsl:when>
          <xsl:when test="$pRegion='SIC-MA'">L1: 1 - Europe; L2: 13 - Southeastern Europe; L3: Sicilia (SIC); L4: Malta (SIC-MA)</xsl:when>
          <xsl:when test="$pRegion='SIC-SI'">L1: 1 - Europe; L2: 13 - Southeastern Europe; L3: Sicilia (SIC); L4: Sicilia (SIC-SI)</xsl:when>
          <xsl:when test="$pRegion='TUE-OO'">L1: 1 - Europe; L2: 13 - Southeastern Europe; L3: Turkey-in-Europe (TUE); L4: Turkey-in-Europe (TUE-OO)</xsl:when>
          <xsl:when test="$pRegion='YUG-BH'">L1: 1 - Europe; L2: 13 - Southeastern Europe; L3: Yugoslavia (YUG); L4: Bosnia-Herzegovina (YUG-BH)</xsl:when>
          <xsl:when test="$pRegion='YUG-CR'">L1: 1 - Europe; L2: 13 - Southeastern Europe; L3: Yugoslavia (YUG); L4: Croatia (YUG-CR)</xsl:when>
          <xsl:when test="$pRegion='YUG-KO'">L1: 1 - Europe; L2: 13 - Southeastern Europe; L3: Yugoslavia (YUG); L4: Kosovo (YUG-KO)</xsl:when>
          <xsl:when test="$pRegion='YUG-MA'">L1: 1 - Europe; L2: 13 - Southeastern Europe; L3: Yugoslavia (YUG); L4: Macedonia (YUG-MA)</xsl:when>
          <xsl:when test="$pRegion='YUG-MN'">L1: 1 - Europe; L2: 13 - Southeastern Europe; L3: Yugoslavia (YUG); L4: Montenegro (YUG-MN)</xsl:when>
          <xsl:when test="$pRegion='YUG-SE'">L1: 1 - Europe; L2: 13 - Southeastern Europe; L3: Yugoslavia (YUG); L4: Serbia (YUG-SE)</xsl:when>
          <xsl:when test="$pRegion='YUG-SL'">L1: 1 - Europe; L2: 13 - Southeastern Europe; L3: Yugoslavia (YUG); L4: Slovenia (YUG-SL)</xsl:when>
          <xsl:when test="$pRegion='BLR-OO'">L1: 1 - Europe; L2: 14 - Eastern Europe; L3: Belarus (BLR); L4: Belarus (BLR-OO)</xsl:when>
          <xsl:when test="$pRegion='BLT-ES'">L1: 1 - Europe; L2: 14 - Eastern Europe; L3: Baltic States (BLT); L4: Estonia (BLT-ES)</xsl:when>
          <xsl:when test="$pRegion='BLT-KA'">L1: 1 - Europe; L2: 14 - Eastern Europe; L3: Baltic States (BLT); L4: Kaliningrad (BLT-KA)</xsl:when>
          <xsl:when test="$pRegion='BLT-LA'">L1: 1 - Europe; L2: 14 - Eastern Europe; L3: Baltic States (BLT); L4: Latvia (BLT-LA)</xsl:when>
          <xsl:when test="$pRegion='BLT-LI'">L1: 1 - Europe; L2: 14 - Eastern Europe; L3: Baltic States (BLT); L4: Lithuania (BLT-LI)</xsl:when>
          <xsl:when test="$pRegion='KRY-OO'">L1: 1 - Europe; L2: 14 - Eastern Europe; L3: Krym (KRY); L4: Krym (KRY-OO)</xsl:when>
          <xsl:when test="$pRegion='RUC-OO'">L1: 1 - Europe; L2: 14 - Eastern Europe; L3: Central European Russia (RUC); L4: Central European Russia (RUC-OO)</xsl:when>
          <xsl:when test="$pRegion='RUE-OO'">L1: 1 - Europe; L2: 14 - Eastern Europe; L3: East European Russia (RUE); L4: East European Russia (RUE-OO)</xsl:when>
          <xsl:when test="$pRegion='RUN-OO'">L1: 1 - Europe; L2: 14 - Eastern Europe; L3: North European Russia (RUN); L4: North European Russia (RUN-OO)</xsl:when>
          <xsl:when test="$pRegion='RUS-OO'">L1: 1 - Europe; L2: 14 - Eastern Europe; L3: South European Russia (RUS); L4: South European Russia (RUS-OO)</xsl:when>
          <xsl:when test="$pRegion='RUW-OO'">L1: 1 - Europe; L2: 14 - Eastern Europe; L3: Northwest European Russia (RUW); L4: Northwest European Russia (RUW-OO)</xsl:when>
          <xsl:when test="$pRegion='UKR-MO'">L1: 1 - Europe; L2: 14 - Eastern Europe; L3: Ukraine (UKR); L4: Moldova (UKR-MO)</xsl:when>
          <xsl:when test="$pRegion='UKR-UK'">L1: 1 - Europe; L2: 14 - Eastern Europe; L3: Ukraine (UKR); L4: Ukraine (UKR-UK)</xsl:when>
          <xsl:when test="$pRegion='ALG-OO'">L1: 2 - Africa; L2: 20 - Northern Africa; L3: Algeria (ALG); L4: Algeria (ALG-OO)</xsl:when>
          <xsl:when test="$pRegion='EGY-OO'">L1: 2 - Africa; L2: 20 - Northern Africa; L3: Egypt (EGY); L4: Egypt (EGY-OO)</xsl:when>
          <xsl:when test="$pRegion='LBY-OO'">L1: 2 - Africa; L2: 20 - Northern Africa; L3: Libya (LBY); L4: Libya (LBY-OO)</xsl:when>
          <xsl:when test="$pRegion='MOR-MO'">L1: 2 - Africa; L2: 20 - Northern Africa; L3: Morocco (MOR); L4: Morocco (MOR-MO)</xsl:when>
          <xsl:when test="$pRegion='MOR-SP'">L1: 2 - Africa; L2: 20 - Northern Africa; L3: Morocco (MOR); L4: Spanish North African Territories (MOR-SP)</xsl:when>
          <xsl:when test="$pRegion='TUN-OO'">L1: 2 - Africa; L2: 20 - Northern Africa; L3: Tunisia (TUN); L4: Tunisia (TUN-OO)</xsl:when>
          <xsl:when test="$pRegion='WSA-OO'">L1: 2 - Africa; L2: 20 - Northern Africa; L3: Western Sahara (WSA); L4: Western Sahara (WSA-OO)</xsl:when>
          <xsl:when test="$pRegion='AZO-OO'">L1: 2 - Africa; L2: 21 - Macaronesia; L3: Azores (AZO); L4: Açôres (AZO-OO)</xsl:when>
          <xsl:when test="$pRegion='CNY-OO'">L1: 2 - Africa; L2: 21 - Macaronesia; L3: Canary Is. (CNY); L4: Canary Is. (CNY-OO)</xsl:when>
          <xsl:when test="$pRegion='CVI-OO'">L1: 2 - Africa; L2: 21 - Macaronesia; L3: Cape Verde (CVI); L4: Cape Verde (CVI-OO)</xsl:when>
          <xsl:when test="$pRegion='MDR-OO'">L1: 2 - Africa; L2: 21 - Macaronesia; L3: Madeira (MDR); L4: Madeira (MDR-OO)</xsl:when>
          <xsl:when test="$pRegion='SEL-OO'">L1: 2 - Africa; L2: 21 - Macaronesia; L3: Selvagens (SEL); L4: Selvagens (SEL-OO)</xsl:when>
          <xsl:when test="$pRegion='BEN-OO'">L1: 2 - Africa; L2: 22 - West Tropical Africa; L3: Benin (BEN); L4: Benin (BEN-OO)</xsl:when>
          <xsl:when test="$pRegion='BKN-OO'">L1: 2 - Africa; L2: 22 - West Tropical Africa; L3: Burkina (BKN); L4: Burkina (BKN-OO)</xsl:when>
          <xsl:when test="$pRegion='GAM-OO'">L1: 2 - Africa; L2: 22 - West Tropical Africa; L3: Gambia, The (GAM); L4: Gambia, The (GAM-OO)</xsl:when>
          <xsl:when test="$pRegion='GHA-OO'">L1: 2 - Africa; L2: 22 - West Tropical Africa; L3: Ghana (GHA); L4: Ghana (GHA-OO)</xsl:when>
          <xsl:when test="$pRegion='GNB-OO'">L1: 2 - Africa; L2: 22 - West Tropical Africa; L3: Guinea-Bissau (GNB); L4: Guinea-Bissau (GNB-OO)</xsl:when>
          <xsl:when test="$pRegion='GUI-OO'">L1: 2 - Africa; L2: 22 - West Tropical Africa; L3: Guinea (GUI); L4: Guinea (GUI-OO)</xsl:when>
          <xsl:when test="$pRegion='IVO-OO'">L1: 2 - Africa; L2: 22 - West Tropical Africa; L3: Ivory Coast (IVO); L4: Ivory Coast (IVO-OO)</xsl:when>
          <xsl:when test="$pRegion='LBR-OO'">L1: 2 - Africa; L2: 22 - West Tropical Africa; L3: Liberia (LBR); L4: Liberia (LBR-OO)</xsl:when>
          <xsl:when test="$pRegion='MLI-OO'">L1: 2 - Africa; L2: 22 - West Tropical Africa; L3: Mali (MLI); L4: Mali (MLI-OO)</xsl:when>
          <xsl:when test="$pRegion='MTN-OO'">L1: 2 - Africa; L2: 22 - West Tropical Africa; L3: Mauritania (MTN); L4: Mauritania (MTN-OO)</xsl:when>
          <xsl:when test="$pRegion='NGA-OO'">L1: 2 - Africa; L2: 22 - West Tropical Africa; L3: Nigeria (NGA); L4: Nigeria (NGA-OO)</xsl:when>
          <xsl:when test="$pRegion='NGR-OO'">L1: 2 - Africa; L2: 22 - West Tropical Africa; L3: Niger (NGR); L4: Niger (NGR-OO)</xsl:when>
          <xsl:when test="$pRegion='SEN-OO'">L1: 2 - Africa; L2: 22 - West Tropical Africa; L3: Senegal (SEN); L4: Senegal (SEN-OO)</xsl:when>
          <xsl:when test="$pRegion='SIE-OO'">L1: 2 - Africa; L2: 22 - West Tropical Africa; L3: Sierra Leone (SIE); L4: Sierra Leone (SIE-OO)</xsl:when>
          <xsl:when test="$pRegion='TOG-OO'">L1: 2 - Africa; L2: 22 - West Tropical Africa; L3: Togo (TOG); L4: Togo (TOG-OO)</xsl:when>
          <xsl:when test="$pRegion='BUR-OO'">L1: 2 - Africa; L2: 23 - West-Central Tropical Africa; L3: Burundi (BUR); L4: Burundi (BUR-OO)</xsl:when>
          <xsl:when test="$pRegion='CAB-OO'">L1: 2 - Africa; L2: 23 - West-Central Tropical Africa; L3: Cabinda (CAB); L4: Cabinda (CAB-OO)</xsl:when>
          <xsl:when test="$pRegion='CAF-OO'">L1: 2 - Africa; L2: 23 - West-Central Tropical Africa; L3: Central African Republic (CAF); L4: Central African Republic (CAF-OO)</xsl:when>
          <xsl:when test="$pRegion='CMN-OO'">L1: 2 - Africa; L2: 23 - West-Central Tropical Africa; L3: Cameroon (CMN); L4: Cameroon (CMN-OO)</xsl:when>
          <xsl:when test="$pRegion='CON-OO'">L1: 2 - Africa; L2: 23 - West-Central Tropical Africa; L3: Congo (CON); L4: Congo (CON-OO)</xsl:when>
          <xsl:when test="$pRegion='EQG-OO'">L1: 2 - Africa; L2: 23 - West-Central Tropical Africa; L3: Equatorial Guinea (EQG); L4: Equatorial Guinea (EQG-OO)</xsl:when>
          <xsl:when test="$pRegion='GAB-OO'">L1: 2 - Africa; L2: 23 - West-Central Tropical Africa; L3: Gabon (GAB); L4: Gabon (GAB-OO)</xsl:when>
          <xsl:when test="$pRegion='GGI-AN'">L1: 2 - Africa; L2: 23 - West-Central Tropical Africa; L3: Gulf of Guinea Is. (GGI); L4: Annobón (GGI-AN)</xsl:when>
          <xsl:when test="$pRegion='GGI-BI'">L1: 2 - Africa; L2: 23 - West-Central Tropical Africa; L3: Gulf of Guinea Is. (GGI); L4: Bioko (GGI-BI)</xsl:when>
          <xsl:when test="$pRegion='GGI-PR'">L1: 2 - Africa; L2: 23 - West-Central Tropical Africa; L3: Gulf of Guinea Is. (GGI); L4: Principe (GGI-PR)</xsl:when>
          <xsl:when test="$pRegion='GGI-ST'">L1: 2 - Africa; L2: 23 - West-Central Tropical Africa; L3: Gulf of Guinea Is. (GGI); L4: São Tomé (GGI-ST)</xsl:when>
          <xsl:when test="$pRegion='RWA-OO'">L1: 2 - Africa; L2: 23 - West-Central Tropical Africa; L3: Rwanda (RWA); L4: Rwanda (RWA-OO)</xsl:when>
          <xsl:when test="$pRegion='ZAI-OO'">L1: 2 - Africa; L2: 23 - West-Central Tropical Africa; L3: Zaire (ZAI); L4: Zaire (ZAI-OO)</xsl:when>
          <xsl:when test="$pRegion='CHA-OO'">L1: 2 - Africa; L2: 24 - Northeast Tropical Africa; L3: Chad (CHA); L4: Chad (CHA-OO)</xsl:when>
          <xsl:when test="$pRegion='DJI-OO'">L1: 2 - Africa; L2: 24 - Northeast Tropical Africa; L3: Djibouti (DJI); L4: Djibouti (DJI-OO)</xsl:when>
          <xsl:when test="$pRegion='ERI-OO'">L1: 2 - Africa; L2: 24 - Northeast Tropical Africa; L3: Eritrea (ERI); L4: Eritrea (ERI-OO)</xsl:when>
          <xsl:when test="$pRegion='ETH-OO'">L1: 2 - Africa; L2: 24 - Northeast Tropical Africa; L3: Ethiopia (ETH); L4: Ethiopia (ETH-OO)</xsl:when>
          <xsl:when test="$pRegion='SOC-OO'">L1: 2 - Africa; L2: 24 - Northeast Tropical Africa; L3: Socotra (SOC); L4: Socotra (SOC-OO)</xsl:when>
          <xsl:when test="$pRegion='SOM-OO'">L1: 2 - Africa; L2: 24 - Northeast Tropical Africa; L3: Somalia (SOM); L4: Somalia (SOM-OO)</xsl:when>
          <xsl:when test="$pRegion='SUD-OO'">L1: 2 - Africa; L2: 24 - Northeast Tropical Africa; L3: Sudan (SUD); L4: Sudan (SUD-OO)</xsl:when>
          <xsl:when test="$pRegion='KEN-OO'">L1: 2 - Africa; L2: 25 - East Tropical Africa; L3: Kenya (KEN); L4: Kenya (KEN-OO)</xsl:when>
          <xsl:when test="$pRegion='TAN-OO'">L1: 2 - Africa; L2: 25 - East Tropical Africa; L3: Tanzania (TAN); L4: Tanzania (TAN-OO)</xsl:when>
          <xsl:when test="$pRegion='UGA-OO'">L1: 2 - Africa; L2: 25 - East Tropical Africa; L3: Uganda (UGA); L4: Uganda (UGA-OO)</xsl:when>
          <xsl:when test="$pRegion='ANG-OO'">L1: 2 - Africa; L2: 26 - South Tropical Africa; L3: Angola (ANG); L4: Angola (ANG-OO)</xsl:when>
          <xsl:when test="$pRegion='MLW-OO'">L1: 2 - Africa; L2: 26 - South Tropical Africa; L3: Malawi (MLW); L4: Malawi (MLW-OO)</xsl:when>
          <xsl:when test="$pRegion='MOZ-OO'">L1: 2 - Africa; L2: 26 - South Tropical Africa; L3: Mozambique (MOZ); L4: Mozambique (MOZ-OO)</xsl:when>
          <xsl:when test="$pRegion='ZAM-OO'">L1: 2 - Africa; L2: 26 - South Tropical Africa; L3: Zambia (ZAM); L4: Zambia (ZAM-OO)</xsl:when>
          <xsl:when test="$pRegion='ZIM-OO'">L1: 2 - Africa; L2: 26 - South Tropical Africa; L3: Zimbabwe (ZIM); L4: Zimbabwe (ZIM-OO)</xsl:when>
          <xsl:when test="$pRegion='BOT-OO'">L1: 2 - Africa; L2: 27 - Southern Africa; L3: Botswana (BOT); L4: Botswana (BOT-OO)</xsl:when>
          <xsl:when test="$pRegion='CPP-EC'">L1: 2 - Africa; L2: 27 - Southern Africa; L3: Cape Provinces (CPP); L4: Eastern Cape Province (CPP-EC)</xsl:when>
          <xsl:when test="$pRegion='CPP-NC'">L1: 2 - Africa; L2: 27 - Southern Africa; L3: Cape Provinces (CPP); L4: Northern Cape Province (CPP-NC)</xsl:when>
          <xsl:when test="$pRegion='CPP-WC'">L1: 2 - Africa; L2: 27 - Southern Africa; L3: Cape Provinces (CPP); L4: Western Cape Province (CPP-WC)</xsl:when>
          <xsl:when test="$pRegion='CPV-OO'">L1: 2 - Africa; L2: 27 - Southern Africa; L3: Caprivi Strip (CPV); L4: Caprivi Strip (CPV-OO)</xsl:when>
          <xsl:when test="$pRegion='LES-OO'">L1: 2 - Africa; L2: 27 - Southern Africa; L3: Lesotho (LES); L4: Lesotho (LES-OO)</xsl:when>
          <xsl:when test="$pRegion='NAM-OO'">L1: 2 - Africa; L2: 27 - Southern Africa; L3: Namibia (NAM); L4: Namibia (NAM-OO)</xsl:when>
          <xsl:when test="$pRegion='NAT-OO'">L1: 2 - Africa; L2: 27 - Southern Africa; L3: KwaZulu-Natal (NAT); L4: KwaZulu-Natal (NAT-OO)</xsl:when>
          <xsl:when test="$pRegion='OFS-OO'">L1: 2 - Africa; L2: 27 - Southern Africa; L3: Free State (OFS); L4: Free State (OFS-OO)</xsl:when>
          <xsl:when test="$pRegion='SWZ-OO'">L1: 2 - Africa; L2: 27 - Southern Africa; L3: Swaziland (SWZ); L4: Swaziland (SWZ-OO)</xsl:when>
          <xsl:when test="$pRegion='TVL-GA'">L1: 2 - Africa; L2: 27 - Southern Africa; L3: Northern Provinces (TVL); L4: Gauteng (TVL-GA)</xsl:when>
          <xsl:when test="$pRegion='TVL-MP'">L1: 2 - Africa; L2: 27 - Southern Africa; L3: Northern Provinces (TVL); L4: Mpumalanga (TVL-MP)</xsl:when>
          <xsl:when test="$pRegion='TVL-NP'">L1: 2 - Africa; L2: 27 - Southern Africa; L3: Northern Provinces (TVL); L4: Northern Province (TVL-NP)</xsl:when>
          <xsl:when test="$pRegion='TVL-NW'">L1: 2 - Africa; L2: 27 - Southern Africa; L3: Northern Provinces (TVL); L4: North-West Province (TVL-NW)</xsl:when>
          <xsl:when test="$pRegion='ASC-OO'">L1: 2 - Africa; L2: 28 - Middle Atlantic Ocean; L3: Ascension (ASC); L4: Ascension (ASC-OO)</xsl:when>
          <xsl:when test="$pRegion='STH-OO'">L1: 2 - Africa; L2: 28 - Middle Atlantic Ocean; L3: St.Helena (STH); L4: St.Helena (STH-OO)</xsl:when>
          <xsl:when test="$pRegion='ALD-OO'">L1: 2 - Africa; L2: 29 - Western Indian Ocean; L3: Aldabra (ALD); L4: Aldabra (ALD-OO)</xsl:when>
          <xsl:when test="$pRegion='CGS-OO'">L1: 2 - Africa; L2: 29 - Western Indian Ocean; L3: Chagos Archipelago (CGS); L4: Chagos Archipelago (CGS-OO)</xsl:when>
          <xsl:when test="$pRegion='COM-CO'">L1: 2 - Africa; L2: 29 - Western Indian Ocean; L3: Comoros (COM); L4: Comoros (COM-CO)</xsl:when>
          <xsl:when test="$pRegion='COM-MA'">L1: 2 - Africa; L2: 29 - Western Indian Ocean; L3: Comoros (COM); L4: Mayotte (COM-MA)</xsl:when>
          <xsl:when test="$pRegion='MAU-OO'">L1: 2 - Africa; L2: 29 - Western Indian Ocean; L3: Mauritius (MAU); L4: Mauritius (MAU-OO)</xsl:when>
          <xsl:when test="$pRegion='MCI-OO'">L1: 2 - Africa; L2: 29 - Western Indian Ocean; L3: Mozambique Channel Is. (MCI); L4: Mozambique Channel Is. (MCI-OO)</xsl:when>
          <xsl:when test="$pRegion='MDG-OO'">L1: 2 - Africa; L2: 29 - Western Indian Ocean; L3: Madagascar (MDG); L4: Madagascar (MDG-OO)</xsl:when>
          <xsl:when test="$pRegion='REU-OO'">L1: 2 - Africa; L2: 29 - Western Indian Ocean; L3: Réunion (REU); L4: Réunion (REU-OO)</xsl:when>
          <xsl:when test="$pRegion='ROD-OO'">L1: 2 - Africa; L2: 29 - Western Indian Ocean; L3: Rodrigues (ROD); L4: Rodrigues (ROD-OO)</xsl:when>
          <xsl:when test="$pRegion='SEY-OO'">L1: 2 - Africa; L2: 29 - Western Indian Ocean; L3: Seychelles (SEY); L4: Seychelles (SEY-OO)</xsl:when>
          <xsl:when test="$pRegion='ALT-OO'">L1: 3 - Asia-Temperate; L2: 30 - Siberia; L3: Altay (ALT); L4: Altay (ALT-OO)</xsl:when>
          <xsl:when test="$pRegion='BRY-OO'">L1: 3 - Asia-Temperate; L2: 30 - Siberia; L3: Buryatiya (BRY); L4: Buryatiya (BRY-OO)</xsl:when>
          <xsl:when test="$pRegion='CTA-OO'">L1: 3 - Asia-Temperate; L2: 30 - Siberia; L3: Chita (CTA); L4: Chita (CTA-OO)</xsl:when>
          <xsl:when test="$pRegion='IRK-OO'">L1: 3 - Asia-Temperate; L2: 30 - Siberia; L3: Irkutsk (IRK); L4: Irkutsk (IRK-OO)</xsl:when>
          <xsl:when test="$pRegion='KRA-OO'">L1: 3 - Asia-Temperate; L2: 30 - Siberia; L3: Krasnoyarsk (KRA); L4: Krasnoyarsk (KRA-OO)</xsl:when>
          <xsl:when test="$pRegion='TVA-OO'">L1: 3 - Asia-Temperate; L2: 30 - Siberia; L3: Tuva (TVA); L4: Tuva (TVA-OO)</xsl:when>
          <xsl:when test="$pRegion='WSB-OO'">L1: 3 - Asia-Temperate; L2: 30 - Siberia; L3: West Siberia (WSB); L4: West Siberia (WSB-OO)</xsl:when>
          <xsl:when test="$pRegion='YAK-OO'">L1: 3 - Asia-Temperate; L2: 30 - Siberia; L3: Yakutskiya (YAK); L4: Yakutskiya (YAK-OO)</xsl:when>
          <xsl:when test="$pRegion='AMU-OO'">L1: 3 - Asia-Temperate; L2: 31 - Russian Far East; L3: Amur (AMU); L4: Amur (AMU-OO)</xsl:when>
          <xsl:when test="$pRegion='KAM-OO'">L1: 3 - Asia-Temperate; L2: 31 - Russian Far East; L3: Kamchatka (KAM); L4: Kamchatka (KAM-OO)</xsl:when>
          <xsl:when test="$pRegion='KHA-OO'">L1: 3 - Asia-Temperate; L2: 31 - Russian Far East; L3: Khabarovsk (KHA); L4: Khabarovsk (KHA-OO)</xsl:when>
          <xsl:when test="$pRegion='KUR-OO'">L1: 3 - Asia-Temperate; L2: 31 - Russian Far East; L3: Kuril Is. (KUR); L4: Kuril Is. (KUR-OO)</xsl:when>
          <xsl:when test="$pRegion='MAG-OO'">L1: 3 - Asia-Temperate; L2: 31 - Russian Far East; L3: Magadan (MAG); L4: Magadan (MAG-OO)</xsl:when>
          <xsl:when test="$pRegion='PRM-OO'">L1: 3 - Asia-Temperate; L2: 31 - Russian Far East; L3: Primorye (PRM); L4: Primorye (PRM-OO)</xsl:when>
          <xsl:when test="$pRegion='SAK-OO'">L1: 3 - Asia-Temperate; L2: 31 - Russian Far East; L3: Sakhalin (SAK); L4: Sakhalin (SAK-OO)</xsl:when>
          <xsl:when test="$pRegion='KAZ-OO'">L1: 3 - Asia-Temperate; L2: 32 - Middle Asia; L3: Kazakhstan (KAZ); L4: Kazakhstan (KAZ-OO)</xsl:when>
          <xsl:when test="$pRegion='KGZ-OO'">L1: 3 - Asia-Temperate; L2: 32 - Middle Asia; L3: Kirgizistan (KGZ); L4: Kirgizistan (KGZ-OO)</xsl:when>
          <xsl:when test="$pRegion='TKM-OO'">L1: 3 - Asia-Temperate; L2: 32 - Middle Asia; L3: Turkmenistan (TKM); L4: Turkmenistan (TKM-OO)</xsl:when>
          <xsl:when test="$pRegion='TZK-OO'">L1: 3 - Asia-Temperate; L2: 32 - Middle Asia; L3: Tadzhikistan (TZK); L4: Tadzhikistan (TZK-OO)</xsl:when>
          <xsl:when test="$pRegion='UZB-OO'">L1: 3 - Asia-Temperate; L2: 32 - Middle Asia; L3: Uzbekistan (UZB); L4: Uzbekistan (UZB-OO)</xsl:when>
          <xsl:when test="$pRegion='NCS-CH'">L1: 3 - Asia-Temperate; L2: 33 - Caucasus; L3: North Caucasus (NCS); L4: Chechnya (NCS-CH)</xsl:when>
          <xsl:when test="$pRegion='NCS-DA'">L1: 3 - Asia-Temperate; L2: 33 - Caucasus; L3: North Caucasus (NCS); L4: Dagestan (NCS-DA)</xsl:when>
          <xsl:when test="$pRegion='NCS-IN'">L1: 3 - Asia-Temperate; L2: 33 - Caucasus; L3: North Caucasus (NCS); L4: Ingushetiya (NCS-IN)</xsl:when>
          <xsl:when test="$pRegion='NCS-KB'">L1: 3 - Asia-Temperate; L2: 33 - Caucasus; L3: North Caucasus (NCS); L4: Kabardino-Balkariya (NCS-KB)</xsl:when>
          <xsl:when test="$pRegion='NCS-KC'">L1: 3 - Asia-Temperate; L2: 33 - Caucasus; L3: North Caucasus (NCS); L4: Karacheyevo-Cherkessiya (NCS-KC)</xsl:when>
          <xsl:when test="$pRegion='NCS-KR'">L1: 3 - Asia-Temperate; L2: 33 - Caucasus; L3: North Caucasus (NCS); L4: Krasnodar (NCS-KR)</xsl:when>
          <xsl:when test="$pRegion='NCS-SO'">L1: 3 - Asia-Temperate; L2: 33 - Caucasus; L3: North Caucasus (NCS); L4: Severo-Osetiya (NCS-SO)</xsl:when>
          <xsl:when test="$pRegion='NCS-ST'">L1: 3 - Asia-Temperate; L2: 33 - Caucasus; L3: North Caucasus (NCS); L4: Stavropol (NCS-ST)</xsl:when>
          <xsl:when test="$pRegion='TCS-AB'">L1: 3 - Asia-Temperate; L2: 33 - Caucasus; L3: Transcaucasus (TCS); L4: Abkhaziya (TCS-AB)</xsl:when>
          <xsl:when test="$pRegion='TCS-AD'">L1: 3 - Asia-Temperate; L2: 33 - Caucasus; L3: Transcaucasus (TCS); L4: Adzhariya (TCS-AD)</xsl:when>
          <xsl:when test="$pRegion='TCS-AR'">L1: 3 - Asia-Temperate; L2: 33 - Caucasus; L3: Transcaucasus (TCS); L4: Armenia (TCS-AR)</xsl:when>
          <xsl:when test="$pRegion='TCS-AZ'">L1: 3 - Asia-Temperate; L2: 33 - Caucasus; L3: Transcaucasus (TCS); L4: Azerbaijan (TCS-AZ)</xsl:when>
          <xsl:when test="$pRegion='TCS-GR'">L1: 3 - Asia-Temperate; L2: 33 - Caucasus; L3: Transcaucasus (TCS); L4: Georgia (TCS-GR)</xsl:when>
          <xsl:when test="$pRegion='TCS-NA'">L1: 3 - Asia-Temperate; L2: 33 - Caucasus; L3: Transcaucasus (TCS); L4: Nakhichevan (TCS-NA)</xsl:when>
          <xsl:when test="$pRegion='TCS-NK'">L1: 3 - Asia-Temperate; L2: 33 - Caucasus; L3: Transcaucasus (TCS); L4: Nagorno Karabakh (TCS-NK)</xsl:when>
          <xsl:when test="$pRegion='AFG-OO'">L1: 3 - Asia-Temperate; L2: 34 - Western Asia; L3: Afghanistan (AFG); L4: Afghanistan (AFG-OO)</xsl:when>
          <xsl:when test="$pRegion='CYP-OO'">L1: 3 - Asia-Temperate; L2: 34 - Western Asia; L3: Cyprus (CYP); L4: Cyprus (CYP-OO)</xsl:when>
          <xsl:when test="$pRegion='EAI-OO'">L1: 3 - Asia-Temperate; L2: 34 - Western Asia; L3: East Aegean Is. (EAI); L4: East Aegean Is. (EAI-OO)</xsl:when>
          <xsl:when test="$pRegion='IRN-OO'">L1: 3 - Asia-Temperate; L2: 34 - Western Asia; L3: Iran (IRN); L4: Iran (IRN-OO)</xsl:when>
          <xsl:when test="$pRegion='IRQ-OO'">L1: 3 - Asia-Temperate; L2: 34 - Western Asia; L3: Iraq (IRQ); L4: Iraq (IRQ-OO)</xsl:when>
          <xsl:when test="$pRegion='LBS-LB'">L1: 3 - Asia-Temperate; L2: 34 - Western Asia; L3: Lebanon-Syria (LBS); L4: Lebanon (LBS-LB)</xsl:when>
          <xsl:when test="$pRegion='LBS-SY'">L1: 3 - Asia-Temperate; L2: 34 - Western Asia; L3: Lebanon-Syria (LBS); L4: Syria (LBS-SY)</xsl:when>
          <xsl:when test="$pRegion='PAL-IS'">L1: 3 - Asia-Temperate; L2: 34 - Western Asia; L3: Palestine (PAL); L4: Israel (PAL-IS)</xsl:when>
          <xsl:when test="$pRegion='PAL-JO'">L1: 3 - Asia-Temperate; L2: 34 - Western Asia; L3: Palestine (PAL); L4: Jordan (PAL-JO)</xsl:when>
          <xsl:when test="$pRegion='SIN-OO'">L1: 3 - Asia-Temperate; L2: 34 - Western Asia; L3: Sinai (SIN); L4: Sinai (SIN-OO)</xsl:when>
          <xsl:when test="$pRegion='TUR-OO'">L1: 3 - Asia-Temperate; L2: 34 - Western Asia; L3: Turkey (TUR); L4: Turkey (TUR-OO)</xsl:when>
          <xsl:when test="$pRegion='GST-BA'">L1: 3 - Asia-Temperate; L2: 35 - Arabian Peninsula; L3: Gulf States (GST); L4: Bahrain (GST-BA)</xsl:when>
          <xsl:when test="$pRegion='GST-QA'">L1: 3 - Asia-Temperate; L2: 35 - Arabian Peninsula; L3: Gulf States (GST); L4: Qatar (GST-QA)</xsl:when>
          <xsl:when test="$pRegion='GST-UA'">L1: 3 - Asia-Temperate; L2: 35 - Arabian Peninsula; L3: Gulf States (GST); L4: United Arab Emirates (GST-UA)</xsl:when>
          <xsl:when test="$pRegion='KUW-OO'">L1: 3 - Asia-Temperate; L2: 35 - Arabian Peninsula; L3: Kuwait (KUW); L4: Kuwait (KUW-OO)</xsl:when>
          <xsl:when test="$pRegion='OMA-OO'">L1: 3 - Asia-Temperate; L2: 35 - Arabian Peninsula; L3: Oman (OMA); L4: Oman (OMA-OO)</xsl:when>
          <xsl:when test="$pRegion='SAU-OO'">L1: 3 - Asia-Temperate; L2: 35 - Arabian Peninsula; L3: Saudi Arabia (SAU); L4: Saudi Arabia (SAU-OO)</xsl:when>
          <xsl:when test="$pRegion='YEM-NY'">L1: 3 - Asia-Temperate; L2: 35 - Arabian Peninsula; L3: Yemen (YEM); L4: North Yemen (YEM-NY)</xsl:when>
          <xsl:when test="$pRegion='YEM-SY'">L1: 3 - Asia-Temperate; L2: 35 - Arabian Peninsula; L3: Yemen (YEM); L4: South Yemen (YEM-SY)</xsl:when>
          <xsl:when test="$pRegion='CHC-CQ'">L1: 3 - Asia-Temperate; L2: 36 - China; L3: China South-Central (CHC); L4: Chongqing (CHC-CQ)</xsl:when>
          <xsl:when test="$pRegion='CHC-GZ'">L1: 3 - Asia-Temperate; L2: 36 - China; L3: China South-Central (CHC); L4: Guizhou (CHC-GZ)</xsl:when>
          <xsl:when test="$pRegion='CHC-HU'">L1: 3 - Asia-Temperate; L2: 36 - China; L3: China South-Central (CHC); L4: Hubei (CHC-HU)</xsl:when>
          <xsl:when test="$pRegion='CHC-SC'">L1: 3 - Asia-Temperate; L2: 36 - China; L3: China South-Central (CHC); L4: Sichuan (CHC-SC)</xsl:when>
          <xsl:when test="$pRegion='CHC-YN'">L1: 3 - Asia-Temperate; L2: 36 - China; L3: China South-Central (CHC); L4: Yunnan (CHC-YN)</xsl:when>
          <xsl:when test="$pRegion='CHH-OO'">L1: 3 - Asia-Temperate; L2: 36 - China; L3: Hainan (CHH); L4: Hainan (CHH-OO)</xsl:when>
          <xsl:when test="$pRegion='CHI-NM'">L1: 3 - Asia-Temperate; L2: 36 - China; L3: Inner Mongolia (CHI); L4: Nei Mongol (CHI-NM)</xsl:when>
          <xsl:when test="$pRegion='CHI-NX'">L1: 3 - Asia-Temperate; L2: 36 - China; L3: Inner Mongolia (CHI); L4: Ningxia (CHI-NX)</xsl:when>
          <xsl:when test="$pRegion='CHM-HJ'">L1: 3 - Asia-Temperate; L2: 36 - China; L3: Manchuria (CHM); L4: Heilongjiang (CHM-HJ)</xsl:when>
          <xsl:when test="$pRegion='CHM-JL'">L1: 3 - Asia-Temperate; L2: 36 - China; L3: Manchuria (CHM); L4: Jilin (CHM-JL)</xsl:when>
          <xsl:when test="$pRegion='CHM-LN'">L1: 3 - Asia-Temperate; L2: 36 - China; L3: Manchuria (CHM); L4: Liaoning (CHM-LN)</xsl:when>
          <xsl:when test="$pRegion='CHN-BJ'">L1: 3 - Asia-Temperate; L2: 36 - China; L3: China North-Central (CHN); L4: Beijing (CHN-BJ)</xsl:when>
          <xsl:when test="$pRegion='CHN-GS'">L1: 3 - Asia-Temperate; L2: 36 - China; L3: China North-Central (CHN); L4: Gansu (CHN-GS)</xsl:when>
          <xsl:when test="$pRegion='CHN-HB'">L1: 3 - Asia-Temperate; L2: 36 - China; L3: China North-Central (CHN); L4: Hebei (CHN-HB)</xsl:when>
          <xsl:when test="$pRegion='CHN-SA'">L1: 3 - Asia-Temperate; L2: 36 - China; L3: China North-Central (CHN); L4: Shaanxi (CHN-SA)</xsl:when>
          <xsl:when test="$pRegion='CHN-SD'">L1: 3 - Asia-Temperate; L2: 36 - China; L3: China North-Central (CHN); L4: Shandong (CHN-SD)</xsl:when>
          <xsl:when test="$pRegion='CHN-SX'">L1: 3 - Asia-Temperate; L2: 36 - China; L3: China North-Central (CHN); L4: Shanxi (CHN-SX)</xsl:when>
          <xsl:when test="$pRegion='CHN-TJ'">L1: 3 - Asia-Temperate; L2: 36 - China; L3: China North-Central (CHN); L4: Tianjin (CHN-TJ)</xsl:when>
          <xsl:when test="$pRegion='CHQ-OO'">L1: 3 - Asia-Temperate; L2: 36 - China; L3: Qinghai (CHQ); L4: Qinghai (CHQ-OO)</xsl:when>
          <xsl:when test="$pRegion='CHS-AH'">L1: 3 - Asia-Temperate; L2: 36 - China; L3: China Southeast (CHS); L4: Anhui (CHS-AH)</xsl:when>
          <xsl:when test="$pRegion='CHS-FJ'">L1: 3 - Asia-Temperate; L2: 36 - China; L3: China Southeast (CHS); L4: Fujian (CHS-FJ)</xsl:when>
          <xsl:when test="$pRegion='CHS-GD'">L1: 3 - Asia-Temperate; L2: 36 - China; L3: China Southeast (CHS); L4: Guangdong (CHS-GD)</xsl:when>
          <xsl:when test="$pRegion='CHS-GX'">L1: 3 - Asia-Temperate; L2: 36 - China; L3: China Southeast (CHS); L4: Guangxi (CHS-GX)</xsl:when>
          <xsl:when test="$pRegion='CHS-HE'">L1: 3 - Asia-Temperate; L2: 36 - China; L3: China Southeast (CHS); L4: Henan (CHS-HE)</xsl:when>
          <xsl:when test="$pRegion='CHS-HK'">L1: 3 - Asia-Temperate; L2: 36 - China; L3: China Southeast (CHS); L4: Hong Kong (CHS-HK)</xsl:when>
          <xsl:when test="$pRegion='CHS-HN'">L1: 3 - Asia-Temperate; L2: 36 - China; L3: China Southeast (CHS); L4: Hunan (CHS-HN)</xsl:when>
          <xsl:when test="$pRegion='CHS-JS'">L1: 3 - Asia-Temperate; L2: 36 - China; L3: China Southeast (CHS); L4: Jiangsu (CHS-JS)</xsl:when>
          <xsl:when test="$pRegion='CHS-JX'">L1: 3 - Asia-Temperate; L2: 36 - China; L3: China Southeast (CHS); L4: Jiangxi (CHS-JX)</xsl:when>
          <xsl:when test="$pRegion='CHS-KI'">L1: 3 - Asia-Temperate; L2: 36 - China; L3: China Southeast (CHS); L4: Kin-Men (CHS-KI)</xsl:when>
          <xsl:when test="$pRegion='CHS-MA'">L1: 3 - Asia-Temperate; L2: 36 - China; L3: China Southeast (CHS); L4: Macau (CHS-MA)</xsl:when>
          <xsl:when test="$pRegion='CHS-MP'">L1: 3 - Asia-Temperate; L2: 36 - China; L3: China Southeast (CHS); L4: Ma-tsu-Pai-chúan (CHS-MP)</xsl:when>
          <xsl:when test="$pRegion='CHS-SH'">L1: 3 - Asia-Temperate; L2: 36 - China; L3: China Southeast (CHS); L4: Shanghai (CHS-SH)</xsl:when>
          <xsl:when test="$pRegion='CHS-ZJ'">L1: 3 - Asia-Temperate; L2: 36 - China; L3: China Southeast (CHS); L4: Zhejiang (CHS-ZJ)</xsl:when>
          <xsl:when test="$pRegion='CHT-OO'">L1: 3 - Asia-Temperate; L2: 36 - China; L3: Tibet (CHT); L4: Tibet (CHT-OO)</xsl:when>
          <xsl:when test="$pRegion='CHX-OO'">L1: 3 - Asia-Temperate; L2: 36 - China; L3: Xinjiang (CHX); L4: Xinjiang (CHX-OO)</xsl:when>
          <xsl:when test="$pRegion='MON-OO'">L1: 3 - Asia-Temperate; L2: 37 - Mongolia; L3: Mongolia (MON); L4: Mongolia (MON-OO)</xsl:when>
          <xsl:when test="$pRegion='JAP-HK'">L1: 3 - Asia-Temperate; L2: 38 - Eastern Asia; L3: Japan (JAP); L4: Hokkaido (JAP-HK)</xsl:when>
          <xsl:when test="$pRegion='JAP-HN'">L1: 3 - Asia-Temperate; L2: 38 - Eastern Asia; L3: Japan (JAP); L4: Honshu (JAP-HN)</xsl:when>
          <xsl:when test="$pRegion='JAP-KY'">L1: 3 - Asia-Temperate; L2: 38 - Eastern Asia; L3: Japan (JAP); L4: Kyushu (JAP-KY)</xsl:when>
          <xsl:when test="$pRegion='JAP-SH'">L1: 3 - Asia-Temperate; L2: 38 - Eastern Asia; L3: Japan (JAP); L4: Shikoku (JAP-SH)</xsl:when>
          <xsl:when test="$pRegion='KOR-NK'">L1: 3 - Asia-Temperate; L2: 38 - Eastern Asia; L3: Korea (KOR); L4: North Korea (KOR-NK)</xsl:when>
          <xsl:when test="$pRegion='KOR-SK'">L1: 3 - Asia-Temperate; L2: 38 - Eastern Asia; L3: Korea (KOR); L4: South Korea (KOR-SK)</xsl:when>
          <xsl:when test="$pRegion='KZN-OO'">L1: 3 - Asia-Temperate; L2: 38 - Eastern Asia; L3: Kazan-retto (KZN); L4: Kazan-retto (KZN-OO)</xsl:when>
          <xsl:when test="$pRegion='NNS-OO'">L1: 3 - Asia-Temperate; L2: 38 - Eastern Asia; L3: Nansei-shoto (NNS); L4: Nansei-shoto (NNS-OO)</xsl:when>
          <xsl:when test="$pRegion='OGA-OO'">L1: 3 - Asia-Temperate; L2: 38 - Eastern Asia; L3: Ogasawara-shoto (OGA); L4: Ogasawara-shoto (OGA-OO)</xsl:when>
          <xsl:when test="$pRegion='TAI-OO'">L1: 3 - Asia-Temperate; L2: 38 - Eastern Asia; L3: Taiwan (TAI); L4: Taiwan (TAI-OO)</xsl:when>
          <xsl:when test="$pRegion='ASS-AS'">L1: 4 - Asia-Tropical; L2: 40 - Indian Subcontinent; L3: Assam (ASS); L4: Assam (ASS-AS)</xsl:when>
          <xsl:when test="$pRegion='ASS-MA'">L1: 4 - Asia-Tropical; L2: 40 - Indian Subcontinent; L3: Assam (ASS); L4: Manipur (ASS-MA)</xsl:when>
          <xsl:when test="$pRegion='ASS-ME'">L1: 4 - Asia-Tropical; L2: 40 - Indian Subcontinent; L3: Assam (ASS); L4: Meghalaya (ASS-ME)</xsl:when>
          <xsl:when test="$pRegion='ASS-MI'">L1: 4 - Asia-Tropical; L2: 40 - Indian Subcontinent; L3: Assam (ASS); L4: Mizoram (ASS-MI)</xsl:when>
          <xsl:when test="$pRegion='ASS-NA'">L1: 4 - Asia-Tropical; L2: 40 - Indian Subcontinent; L3: Assam (ASS); L4: Nagaland (ASS-NA)</xsl:when>
          <xsl:when test="$pRegion='ASS-TR'">L1: 4 - Asia-Tropical; L2: 40 - Indian Subcontinent; L3: Assam (ASS); L4: Tripura (ASS-TR)</xsl:when>
          <xsl:when test="$pRegion='BAN-OO'">L1: 4 - Asia-Tropical; L2: 40 - Indian Subcontinent; L3: Bangladesh (BAN); L4: Bangladesh (BAN-OO)</xsl:when>
          <xsl:when test="$pRegion='EHM-AP'">L1: 4 - Asia-Tropical; L2: 40 - Indian Subcontinent; L3: East Himalaya (EHM); L4: Arunachal Pradesh (EHM-AP)</xsl:when>
          <xsl:when test="$pRegion='EHM-BH'">L1: 4 - Asia-Tropical; L2: 40 - Indian Subcontinent; L3: East Himalaya (EHM); L4: Bhutan (EHM-BH)</xsl:when>
          <xsl:when test="$pRegion='EHM-DJ'">L1: 4 - Asia-Tropical; L2: 40 - Indian Subcontinent; L3: East Himalaya (EHM); L4: Darjiling (EHM-DJ)</xsl:when>
          <xsl:when test="$pRegion='EHM-SI'">L1: 4 - Asia-Tropical; L2: 40 - Indian Subcontinent; L3: East Himalaya (EHM); L4: Sikkim (EHM-SI)</xsl:when>
          <xsl:when test="$pRegion='IND-AP'">L1: 4 - Asia-Tropical; L2: 40 - Indian Subcontinent; L3: India (IND); L4: Andhra Pradesh (IND-AP)</xsl:when>
          <xsl:when test="$pRegion='IND-BI'">L1: 4 - Asia-Tropical; L2: 40 - Indian Subcontinent; L3: India (IND); L4: Bihar (IND-BI)</xsl:when>
          <xsl:when test="$pRegion='IND-CH'">L1: 4 - Asia-Tropical; L2: 40 - Indian Subcontinent; L3: India (IND); L4: Chandigarh (IND-CH)</xsl:when>
          <xsl:when test="$pRegion='IND-CT'">L1: 4 - Asia-Tropical; L2: 40 - Indian Subcontinent; L3: India (IND); L4: Chattisgarh (IND-CT)</xsl:when>
          <xsl:when test="$pRegion='IND-DD'">L1: 4 - Asia-Tropical; L2: 40 - Indian Subcontinent; L3: India (IND); L4: Dadra-Nagar-Haveli (IND-DD)</xsl:when>
          <xsl:when test="$pRegion='IND-DE'">L1: 4 - Asia-Tropical; L2: 40 - Indian Subcontinent; L3: India (IND); L4: Delhi (IND-DE)</xsl:when>
          <xsl:when test="$pRegion='IND-DI'">L1: 4 - Asia-Tropical; L2: 40 - Indian Subcontinent; L3: India (IND); L4: Diu (IND-DI)</xsl:when>
          <xsl:when test="$pRegion='IND-DM'">L1: 4 - Asia-Tropical; L2: 40 - Indian Subcontinent; L3: India (IND); L4: Daman (IND-DM)</xsl:when>
          <xsl:when test="$pRegion='IND-GO'">L1: 4 - Asia-Tropical; L2: 40 - Indian Subcontinent; L3: India (IND); L4: Goa (IND-GO)</xsl:when>
          <xsl:when test="$pRegion='IND-GU'">L1: 4 - Asia-Tropical; L2: 40 - Indian Subcontinent; L3: India (IND); L4: Gujarat (IND-GU)</xsl:when>
          <xsl:when test="$pRegion='IND-HA'">L1: 4 - Asia-Tropical; L2: 40 - Indian Subcontinent; L3: India (IND); L4: Haryana (IND-HA)</xsl:when>
          <xsl:when test="$pRegion='IND-JK'">L1: 4 - Asia-Tropical; L2: 40 - Indian Subcontinent; L3: India (IND); L4: Jharkhand (IND-JK)</xsl:when>
          <xsl:when test="$pRegion='IND-KE'">L1: 4 - Asia-Tropical; L2: 40 - Indian Subcontinent; L3: India (IND); L4: Kerala (IND-KE)</xsl:when>
          <xsl:when test="$pRegion='IND-KL'">L1: 4 - Asia-Tropical; L2: 40 - Indian Subcontinent; L3: India (IND); L4: Karaikal (IND-KL)</xsl:when>
          <xsl:when test="$pRegion='IND-KT'">L1: 4 - Asia-Tropical; L2: 40 - Indian Subcontinent; L3: India (IND); L4: Karnataka (IND-KT)</xsl:when>
          <xsl:when test="$pRegion='IND-MH'">L1: 4 - Asia-Tropical; L2: 40 - Indian Subcontinent; L3: India (IND); L4: Mahé (IND-MH)</xsl:when>
          <xsl:when test="$pRegion='IND-MP'">L1: 4 - Asia-Tropical; L2: 40 - Indian Subcontinent; L3: India (IND); L4: Madhya Pradesh (IND-MP)</xsl:when>
          <xsl:when test="$pRegion='IND-MR'">L1: 4 - Asia-Tropical; L2: 40 - Indian Subcontinent; L3: India (IND); L4: Maharashtra (IND-MR)</xsl:when>
          <xsl:when test="$pRegion='IND-OR'">L1: 4 - Asia-Tropical; L2: 40 - Indian Subcontinent; L3: India (IND); L4: Orissa (IND-OR)</xsl:when>
          <xsl:when test="$pRegion='IND-PO'">L1: 4 - Asia-Tropical; L2: 40 - Indian Subcontinent; L3: India (IND); L4: Pondicherry (IND-PO)</xsl:when>
          <xsl:when test="$pRegion='IND-PU'">L1: 4 - Asia-Tropical; L2: 40 - Indian Subcontinent; L3: India (IND); L4: Punjab (IND-PU)</xsl:when>
          <xsl:when test="$pRegion='IND-RA'">L1: 4 - Asia-Tropical; L2: 40 - Indian Subcontinent; L3: India (IND); L4: Rajasthan (IND-RA)</xsl:when>
          <xsl:when test="$pRegion='IND-TN'">L1: 4 - Asia-Tropical; L2: 40 - Indian Subcontinent; L3: India (IND); L4: Tamil Nadu (IND-TN)</xsl:when>
          <xsl:when test="$pRegion='IND-UP'">L1: 4 - Asia-Tropical; L2: 40 - Indian Subcontinent; L3: India (IND); L4: Uttar Pradesh (IND-UP)</xsl:when>
          <xsl:when test="$pRegion='IND-WB'">L1: 4 - Asia-Tropical; L2: 40 - Indian Subcontinent; L3: India (IND); L4: West Bengal (IND-WB)</xsl:when>
          <xsl:when test="$pRegion='IND-YA'">L1: 4 - Asia-Tropical; L2: 40 - Indian Subcontinent; L3: India (IND); L4: Yanam (IND-YA)</xsl:when>
          <xsl:when test="$pRegion='LDV-OO'">L1: 4 - Asia-Tropical; L2: 40 - Indian Subcontinent; L3: Laccadive Is. (LDV); L4: Laccadive Is. (LDV-OO)</xsl:when>
          <xsl:when test="$pRegion='MDV-OO'">L1: 4 - Asia-Tropical; L2: 40 - Indian Subcontinent; L3: Maldives (MDV); L4: Maldives (MDV-OO)</xsl:when>
          <xsl:when test="$pRegion='NEP-OO'">L1: 4 - Asia-Tropical; L2: 40 - Indian Subcontinent; L3: Nepal (NEP); L4: Nepal (NEP-OO)</xsl:when>
          <xsl:when test="$pRegion='PAK-OO'">L1: 4 - Asia-Tropical; L2: 40 - Indian Subcontinent; L3: Pakistan (PAK); L4: Pakistan (PAK-OO)</xsl:when>
          <xsl:when test="$pRegion='SRL-OO'">L1: 4 - Asia-Tropical; L2: 40 - Indian Subcontinent; L3: Sri Lanka (SRL); L4: Sri Lanka (SRL-OO)</xsl:when>
          <xsl:when test="$pRegion='WHM-HP'">L1: 4 - Asia-Tropical; L2: 40 - Indian Subcontinent; L3: West Himalaya (WHM); L4: Himachal Pradesh (WHM-HP)</xsl:when>
          <xsl:when test="$pRegion='WHM-JK'">L1: 4 - Asia-Tropical; L2: 40 - Indian Subcontinent; L3: West Himalaya (WHM); L4: Jammu-Kashmir (WHM-JK)</xsl:when>
          <xsl:when test="$pRegion='WHM-UT'">L1: 4 - Asia-Tropical; L2: 40 - Indian Subcontinent; L3: West Himalaya (WHM); L4: Uttaranchal (WHM-UT)</xsl:when>
          <xsl:when test="$pRegion='AND-AN'">L1: 4 - Asia-Tropical; L2: 41 - Indo-China; L3: Andaman Is. (AND); L4: Andaman Is. (AND-AN)</xsl:when>
          <xsl:when test="$pRegion='AND-CO'">L1: 4 - Asia-Tropical; L2: 41 - Indo-China; L3: Andaman Is. (AND); L4: Coco Is. (AND-CO)</xsl:when>
          <xsl:when test="$pRegion='CBD-OO'">L1: 4 - Asia-Tropical; L2: 41 - Indo-China; L3: Cambodia (CBD); L4: Cambodia (CBD-OO)</xsl:when>
          <xsl:when test="$pRegion='LAO-OO'">L1: 4 - Asia-Tropical; L2: 41 - Indo-China; L3: Laos (LAO); L4: Laos (LAO-OO)</xsl:when>
          <xsl:when test="$pRegion='MYA-OO'">L1: 4 - Asia-Tropical; L2: 41 - Indo-China; L3: Myanmar (MYA); L4: Myanmar (MYA-OO)</xsl:when>
          <xsl:when test="$pRegion='NCB-OO'">L1: 4 - Asia-Tropical; L2: 41 - Indo-China; L3: Nicobar Is. (NCB); L4: Nicobar Is. (NCB-OO)</xsl:when>
          <xsl:when test="$pRegion='SCS-PI'">L1: 4 - Asia-Tropical; L2: 41 - Indo-China; L3: South China Sea (SCS); L4: Paracel Is. (SCS-PI)</xsl:when>
          <xsl:when test="$pRegion='SCS-SI'">L1: 4 - Asia-Tropical; L2: 41 - Indo-China; L3: South China Sea (SCS); L4: Spratly Is. (SCS-SI)</xsl:when>
          <xsl:when test="$pRegion='THA-OO'">L1: 4 - Asia-Tropical; L2: 41 - Indo-China; L3: Thailand (THA); L4: Thailand (THA-OO)</xsl:when>
          <xsl:when test="$pRegion='VIE-OO'">L1: 4 - Asia-Tropical; L2: 41 - Indo-China; L3: Vietnam (VIE); L4: Vietnam (VIE-OO)</xsl:when>
          <xsl:when test="$pRegion='BOR-BR'">L1: 4 - Asia-Tropical; L2: 42 - Malesia; L3: Borneo (BOR); L4: Brunei (BOR-BR)</xsl:when>
          <xsl:when test="$pRegion='BOR-KA'">L1: 4 - Asia-Tropical; L2: 42 - Malesia; L3: Borneo (BOR); L4: Kalimantan (BOR-KA)</xsl:when>
          <xsl:when test="$pRegion='BOR-SB'">L1: 4 - Asia-Tropical; L2: 42 - Malesia; L3: Borneo (BOR); L4: Sabah (BOR-SB)</xsl:when>
          <xsl:when test="$pRegion='BOR-SR'">L1: 4 - Asia-Tropical; L2: 42 - Malesia; L3: Borneo (BOR); L4: Sarawak (BOR-SR)</xsl:when>
          <xsl:when test="$pRegion='CKI-OO'">L1: 4 - Asia-Tropical; L2: 42 - Malesia; L3: Cocos (Keeling) Is. (CKI); L4: Cocos (Keeling) Is. (CKI-OO)</xsl:when>
          <xsl:when test="$pRegion='JAW-OO'">L1: 4 - Asia-Tropical; L2: 42 - Malesia; L3: Jawa (JAW); L4: Jawa (JAW-OO)</xsl:when>
          <xsl:when test="$pRegion='LSI-BA'">L1: 4 - Asia-Tropical; L2: 42 - Malesia; L3: Lesser Sunda Is. (LSI); L4: Bali (LSI-BA)</xsl:when>
          <xsl:when test="$pRegion='LSI-ET'">L1: 4 - Asia-Tropical; L2: 42 - Malesia; L3: Lesser Sunda Is. (LSI); L4: East Timor (LSI-ET)</xsl:when>
          <xsl:when test="$pRegion='LSI-LS'">L1: 4 - Asia-Tropical; L2: 42 - Malesia; L3: Lesser Sunda Is. (LSI); L4: Lesser Sunda Is. (LSI-LS)</xsl:when>
          <xsl:when test="$pRegion='MLY-PM'">L1: 4 - Asia-Tropical; L2: 42 - Malesia; L3: Malaya (MLY); L4: Peninsular Malaysia (MLY-PM)</xsl:when>
          <xsl:when test="$pRegion='MLY-SI'">L1: 4 - Asia-Tropical; L2: 42 - Malesia; L3: Malaya (MLY); L4: Singapore (MLY-SI)</xsl:when>
          <xsl:when test="$pRegion='MOL-OO'">L1: 4 - Asia-Tropical; L2: 42 - Malesia; L3: Maluku (MOL); L4: Maluku (MOL-OO)</xsl:when>
          <xsl:when test="$pRegion='PHI-OO'">L1: 4 - Asia-Tropical; L2: 42 - Malesia; L3: Philippines (PHI); L4: Philippines (PHI-OO)</xsl:when>
          <xsl:when test="$pRegion='SUL-OO'">L1: 4 - Asia-Tropical; L2: 42 - Malesia; L3: Sulawesi (SUL); L4: Sulawesi (SUL-OO)</xsl:when>
          <xsl:when test="$pRegion='SUM-OO'">L1: 4 - Asia-Tropical; L2: 42 - Malesia; L3: Sumatera (SUM); L4: Sumatera (SUM-OO)</xsl:when>
          <xsl:when test="$pRegion='XMS-OO'">L1: 4 - Asia-Tropical; L2: 42 - Malesia; L3: Christmas I. (XMS); L4: Christmas I. (XMS-OO)</xsl:when>
          <xsl:when test="$pRegion='BIS-OO'">L1: 4 - Asia-Tropical; L2: 43 - Papuasia; L3: Bismarck Archipelago (BIS); L4: Bismarck Archipelago (BIS-OO)</xsl:when>
          <xsl:when test="$pRegion='NWG-IJ'">L1: 4 - Asia-Tropical; L2: 43 - Papuasia; L3: New Guinea (NWG); L4: Irian Jaya (NWG-IJ)</xsl:when>
          <xsl:when test="$pRegion='NWG-PN'">L1: 4 - Asia-Tropical; L2: 43 - Papuasia; L3: New Guinea (NWG); L4: Papua New Guinea (NWG-PN)</xsl:when>
          <xsl:when test="$pRegion='SOL-NO'">L1: 4 - Asia-Tropical; L2: 43 - Papuasia; L3: Solomon Is. (SOL); L4: North Solomons (SOL-NO)</xsl:when>
          <xsl:when test="$pRegion='SOL-SO'">L1: 4 - Asia-Tropical; L2: 43 - Papuasia; L3: Solomon Is. (SOL); L4: South Solomons (SOL-SO)</xsl:when>
          <xsl:when test="$pRegion='NFK-LH'">L1: 5 - Australasia; L2: 50 - Australia; L3: Norfolk Is. (NFK); L4: Lord Howe I. (NFK-LH)</xsl:when>
          <xsl:when test="$pRegion='NFK-NI'">L1: 5 - Australasia; L2: 50 - Australia; L3: Norfolk Is. (NFK); L4: Norfolk I. (NFK-NI)</xsl:when>
          <xsl:when test="$pRegion='NSW-CT'">L1: 5 - Australasia; L2: 50 - Australia; L3: New South Wales (NSW); L4: Australian Capital Territory (NSW-CT)</xsl:when>
          <xsl:when test="$pRegion='NSW-NS'">L1: 5 - Australasia; L2: 50 - Australia; L3: New South Wales (NSW); L4: New South Wales (NSW-NS)</xsl:when>
          <xsl:when test="$pRegion='NTA-OO'">L1: 5 - Australasia; L2: 50 - Australia; L3: Northern Territory (NTA); L4: Northern Territory (NTA-OO)</xsl:when>
          <xsl:when test="$pRegion='QLD-CS'">L1: 5 - Australasia; L2: 50 - Australia; L3: Queensland (QLD); L4: Coral Sea Is. Territory (QLD-CS)</xsl:when>
          <xsl:when test="$pRegion='QLD-QU'">L1: 5 - Australasia; L2: 50 - Australia; L3: Queensland (QLD); L4: Queensland (QLD-QU)</xsl:when>
          <xsl:when test="$pRegion='SOA-OO'">L1: 5 - Australasia; L2: 50 - Australia; L3: South Australia (SOA); L4: South Australia (SOA-OO)</xsl:when>
          <xsl:when test="$pRegion='TAS-OO'">L1: 5 - Australasia; L2: 50 - Australia; L3: Tasmania (TAS); L4: Tasmania (TAS-OO)</xsl:when>
          <xsl:when test="$pRegion='VIC-OO'">L1: 5 - Australasia; L2: 50 - Australia; L3: Victoria (VIC); L4: Victoria (VIC-OO)</xsl:when>
          <xsl:when test="$pRegion='WAU-AC'">L1: 5 - Australasia; L2: 50 - Australia; L3: Western Australia (WAU); L4: Ashmore-Cartier Is. (WAU-AC)</xsl:when>
          <xsl:when test="$pRegion='WAU-WA'">L1: 5 - Australasia; L2: 50 - Australia; L3: Western Australia (WAU); L4: Western Australia (WAU-WA)</xsl:when>
          <xsl:when test="$pRegion='ATP-OO'">L1: 5 - Australasia; L2: 51 - New Zealand; L3: Antipodean Is. (ATP); L4: Antipodean Is. (ATP-OO)</xsl:when>
          <xsl:when test="$pRegion='CTM-OO'">L1: 5 - Australasia; L2: 51 - New Zealand; L3: Chatham Is. (CTM); L4: Chatham Is. (CTM-OO)</xsl:when>
          <xsl:when test="$pRegion='KER-OO'">L1: 5 - Australasia; L2: 51 - New Zealand; L3: Kermadec Is. (KER); L4: Kermadec Is. (KER-OO)</xsl:when>
          <xsl:when test="$pRegion='NZN-OO'">L1: 5 - Australasia; L2: 51 - New Zealand; L3: New Zealand North (NZN); L4: New Zealand North (NZN-OO)</xsl:when>
          <xsl:when test="$pRegion='NZS-OO'">L1: 5 - Australasia; L2: 51 - New Zealand; L3: New Zealand South (NZS); L4: New Zealand South (NZS-OO)</xsl:when>
          <xsl:when test="$pRegion='FIJ-OO'">L1: 6 - Pacific; L2: 60 - Southwestern Pacific; L3: Fiji (FIJ); L4: Fiji (FIJ-OO)</xsl:when>
          <xsl:when test="$pRegion='GIL-OO'">L1: 6 - Pacific; L2: 60 - Southwestern Pacific; L3: Gilbert Is. (GIL); L4: Gilbert Is. (GIL-OO)</xsl:when>
          <xsl:when test="$pRegion='HBI-OO'">L1: 6 - Pacific; L2: 60 - Southwestern Pacific; L3: Howland-Baker Is. (HBI); L4: Howland-Baker Is. (HBI-OO)</xsl:when>
          <xsl:when test="$pRegion='NRU-OO'">L1: 6 - Pacific; L2: 60 - Southwestern Pacific; L3: Nauru (NRU); L4: Nauru (NRU-OO)</xsl:when>
          <xsl:when test="$pRegion='NUE-OO'">L1: 6 - Pacific; L2: 60 - Southwestern Pacific; L3: Niue (NUE); L4: Niue (NUE-OO)</xsl:when>
          <xsl:when test="$pRegion='NWC-OO'">L1: 6 - Pacific; L2: 60 - Southwestern Pacific; L3: New Caledonia (NWC); L4: New Caledonia (NWC-OO)</xsl:when>
          <xsl:when test="$pRegion='PHX-OO'">L1: 6 - Pacific; L2: 60 - Southwestern Pacific; L3: Phoenix Is. (PHX); L4: Phoenix Is. (PHX-OO)</xsl:when>
          <xsl:when test="$pRegion='SAM-AS'">L1: 6 - Pacific; L2: 60 - Southwestern Pacific; L3: Samoa (SAM); L4: American Samoa (SAM-AS)</xsl:when>
          <xsl:when test="$pRegion='SAM-WS'">L1: 6 - Pacific; L2: 60 - Southwestern Pacific; L3: Samoa (SAM); L4: Samoa (SAM-WS)</xsl:when>
          <xsl:when test="$pRegion='SCZ-OO'">L1: 6 - Pacific; L2: 60 - Southwestern Pacific; L3: Santa Cruz Is. (SCZ); L4: Santa Cruz Is. (SCZ-OO)</xsl:when>
          <xsl:when test="$pRegion='TOK-MA'">L1: 6 - Pacific; L2: 60 - Southwestern Pacific; L3: Tokelau-Manihiki (TOK); L4: Manihiki Is. (TOK-MA)</xsl:when>
          <xsl:when test="$pRegion='TOK-SW'">L1: 6 - Pacific; L2: 60 - Southwestern Pacific; L3: Tokelau-Manihiki (TOK); L4: Swains I. (TOK-SW)</xsl:when>
          <xsl:when test="$pRegion='TOK-TO'">L1: 6 - Pacific; L2: 60 - Southwestern Pacific; L3: Tokelau-Manihiki (TOK); L4: Tokelau (TOK-TO)</xsl:when>
          <xsl:when test="$pRegion='TON-OO'">L1: 6 - Pacific; L2: 60 - Southwestern Pacific; L3: Tonga (TON); L4: Tonga (TON-OO)</xsl:when>
          <xsl:when test="$pRegion='TUV-OO'">L1: 6 - Pacific; L2: 60 - Southwestern Pacific; L3: Tuvalu (TUV); L4: Tuvalu (TUV-OO)</xsl:when>
          <xsl:when test="$pRegion='VAN-OO'">L1: 6 - Pacific; L2: 60 - Southwestern Pacific; L3: Vanuatu (VAN); L4: Vanuatu (VAN-OO)</xsl:when>
          <xsl:when test="$pRegion='WAL-OO'">L1: 6 - Pacific; L2: 60 - Southwestern Pacific; L3: Wallis-Futuna Is. (WAL); L4: Wallis-Futuna Is. (WAL-OO)</xsl:when>
          <xsl:when test="$pRegion='COO-OO'">L1: 6 - Pacific; L2: 61 - South-Central Pacific; L3: Cook Is. (COO); L4: Cook Is. (COO-OO)</xsl:when>
          <xsl:when test="$pRegion='EAS-OO'">L1: 6 - Pacific; L2: 61 - South-Central Pacific; L3: Easter Is. (EAS); L4: Easter Is. (EAS-OO)</xsl:when>
          <xsl:when test="$pRegion='LIN-KI'">L1: 6 - Pacific; L2: 61 - South-Central Pacific; L3: Line Is. (LIN); L4: Kiribati Line Is. (LIN-KI)</xsl:when>
          <xsl:when test="$pRegion='LIN-US'">L1: 6 - Pacific; L2: 61 - South-Central Pacific; L3: Line Is. (LIN); L4: U.S. Line Is. (LIN-US)</xsl:when>
          <xsl:when test="$pRegion='MRQ-OO'">L1: 6 - Pacific; L2: 61 - South-Central Pacific; L3: Marquesas (MRQ); L4: Marquesas (MRQ-OO)</xsl:when>
          <xsl:when test="$pRegion='PIT-OO'">L1: 6 - Pacific; L2: 61 - South-Central Pacific; L3: Pitcairn Is. (PIT); L4: Pitcairn Is. (PIT-OO)</xsl:when>
          <xsl:when test="$pRegion='SCI-OO'">L1: 6 - Pacific; L2: 61 - South-Central Pacific; L3: Society Is. (SCI); L4: Society Is. (SCI-OO)</xsl:when>
          <xsl:when test="$pRegion='TUA-OO'">L1: 6 - Pacific; L2: 61 - South-Central Pacific; L3: Tuamotu (TUA); L4: Tuamotu (TUA-OO)</xsl:when>
          <xsl:when test="$pRegion='TUB-OO'">L1: 6 - Pacific; L2: 61 - South-Central Pacific; L3: Tubuai Is. (TUB); L4: Tubuai Is. (TUB-OO)</xsl:when>
          <xsl:when test="$pRegion='CRL-MF'">L1: 6 - Pacific; L2: 62 - Northwestern Pacific; L3: Caroline Is. (CRL); L4: Micronesia Federated States (CRL-MF)</xsl:when>
          <xsl:when test="$pRegion='CRL-PA'">L1: 6 - Pacific; L2: 62 - Northwestern Pacific; L3: Caroline Is. (CRL); L4: Palau (CRL-PA)</xsl:when>
          <xsl:when test="$pRegion='MCS-OO'">L1: 6 - Pacific; L2: 62 - Northwestern Pacific; L3: Marcus I. (MCS); L4: Marcus I. (MCS-OO)</xsl:when>
          <xsl:when test="$pRegion='MRN-GU'">L1: 6 - Pacific; L2: 62 - Northwestern Pacific; L3: Marianas (MRN); L4: Guam (MRN-GU)</xsl:when>
          <xsl:when test="$pRegion='MRN-NM'">L1: 6 - Pacific; L2: 62 - Northwestern Pacific; L3: Marianas (MRN); L4: Northern Marianas (MRN-NM)</xsl:when>
          <xsl:when test="$pRegion='MRS-OO'">L1: 6 - Pacific; L2: 62 - Northwestern Pacific; L3: Marshall Is. (MRS); L4: Marshall Is. (MRS-OO)</xsl:when>
          <xsl:when test="$pRegion='WAK-OO'">L1: 6 - Pacific; L2: 62 - Northwestern Pacific; L3: Wake I. (WAK); L4: Wake I. (WAK-OO)</xsl:when>
          <xsl:when test="$pRegion='HAW-HI'">L1: 6 - Pacific; L2: 63 - North-Central Pacific; L3: Hawaii (HAW); L4: Hawaiian Is. (HAW-HI)</xsl:when>
          <xsl:when test="$pRegion='HAW-JI'">L1: 6 - Pacific; L2: 63 - North-Central Pacific; L3: Hawaii (HAW); L4: Johnston I. (HAW-JI)</xsl:when>
          <xsl:when test="$pRegion='HAW-MI'">L1: 6 - Pacific; L2: 63 - North-Central Pacific; L3: Hawaii (HAW); L4: Midway Is. (HAW-MI)</xsl:when>
          <xsl:when test="$pRegion='ALU-OO'">L1: 7 - Northern America; L2: 70 - Subarctic America; L3: Aleutian Is. (ALU); L4: Aleutian Is. (ALU-OO)</xsl:when>
          <xsl:when test="$pRegion='ASK-OO'">L1: 7 - Northern America; L2: 70 - Subarctic America; L3: Alaska (ASK); L4: Alaska (ASK-OO)</xsl:when>
          <xsl:when test="$pRegion='GNL-OO'">L1: 7 - Northern America; L2: 70 - Subarctic America; L3: Greenland (GNL); L4: Greenland (GNL-OO)</xsl:when>
          <xsl:when test="$pRegion='NUN-OO'">L1: 7 - Northern America; L2: 70 - Subarctic America; L3: Nunavut (NUN); L4: Nunavut (NUN-OO)</xsl:when>
          <xsl:when test="$pRegion='NWT-OO'">L1: 7 - Northern America; L2: 70 - Subarctic America; L3: Northwest Territories (NWT); L4: Northwest Territories (NWT-OO)</xsl:when>
          <xsl:when test="$pRegion='YUK-OO'">L1: 7 - Northern America; L2: 70 - Subarctic America; L3: Yukon (YUK); L4: Yukon (YUK-OO)</xsl:when>
          <xsl:when test="$pRegion='ABT-OO'">L1: 7 - Northern America; L2: 71 - Western Canada; L3: Alberta (ABT); L4: Alberta (ABT-OO)</xsl:when>
          <xsl:when test="$pRegion='BRC-OO'">L1: 7 - Northern America; L2: 71 - Western Canada; L3: British Columbia (BRC); L4: British Columbia (BRC-OO)</xsl:when>
          <xsl:when test="$pRegion='MAN-OO'">L1: 7 - Northern America; L2: 71 - Western Canada; L3: Manitoba (MAN); L4: Manitoba (MAN-OO)</xsl:when>
          <xsl:when test="$pRegion='SAS-OO'">L1: 7 - Northern America; L2: 71 - Western Canada; L3: Saskatchewan (SAS); L4: Saskatchewan (SAS-OO)</xsl:when>
          <xsl:when test="$pRegion='LAB-OO'">L1: 7 - Northern America; L2: 72 - Eastern Canada; L3: Labrador (LAB); L4: Labrador (LAB-OO)</xsl:when>
          <xsl:when test="$pRegion='NBR-OO'">L1: 7 - Northern America; L2: 72 - Eastern Canada; L3: New Brunswick (NBR); L4: New Brunswick (NBR-OO)</xsl:when>
          <xsl:when test="$pRegion='NFL-NE'">L1: 7 - Northern America; L2: 72 - Eastern Canada; L3: Newfoundland (NFL); L4: Newfoundland (NFL-NE)</xsl:when>
          <xsl:when test="$pRegion='NFL-SP'">L1: 7 - Northern America; L2: 72 - Eastern Canada; L3: Newfoundland (NFL); L4: St.Pierre-Miquelon (NFL-SP)</xsl:when>
          <xsl:when test="$pRegion='NSC-OO'">L1: 7 - Northern America; L2: 72 - Eastern Canada; L3: Nova Scotia (NSC); L4: Nova Scotia (NSC-OO)</xsl:when>
          <xsl:when test="$pRegion='ONT-OO'">L1: 7 - Northern America; L2: 72 - Eastern Canada; L3: Ontario (ONT); L4: Ontario (ONT-OO)</xsl:when>
          <xsl:when test="$pRegion='PEI-OO'">L1: 7 - Northern America; L2: 72 - Eastern Canada; L3: Prince Edward I. (PEI); L4: Prince Edward I. (PEI-OO)</xsl:when>
          <xsl:when test="$pRegion='QUE-OO'">L1: 7 - Northern America; L2: 72 - Eastern Canada; L3: Québec (QUE); L4: Québec (QUE-OO)</xsl:when>
          <xsl:when test="$pRegion='COL-OO'">L1: 7 - Northern America; L2: 73 - Northwestern U.S.A.; L3: Colorado (COL); L4: Colorado (COL-OO)</xsl:when>
          <xsl:when test="$pRegion='IDA-OO'">L1: 7 - Northern America; L2: 73 - Northwestern U.S.A.; L3: Idaho (IDA); L4: Idaho (IDA-OO)</xsl:when>
          <xsl:when test="$pRegion='MNT-OO'">L1: 7 - Northern America; L2: 73 - Northwestern U.S.A.; L3: Montana (MNT); L4: Montana (MNT-OO)</xsl:when>
          <xsl:when test="$pRegion='ORE-OO'">L1: 7 - Northern America; L2: 73 - Northwestern U.S.A.; L3: Oregon (ORE); L4: Oregon (ORE-OO)</xsl:when>
          <xsl:when test="$pRegion='WAS-OO'">L1: 7 - Northern America; L2: 73 - Northwestern U.S.A.; L3: Washington (WAS); L4: Washington (WAS-OO)</xsl:when>
          <xsl:when test="$pRegion='WYO-OO'">L1: 7 - Northern America; L2: 73 - Northwestern U.S.A.; L3: Wyoming (WYO); L4: Wyoming (WYO-OO)</xsl:when>
          <xsl:when test="$pRegion='ILL-OO'">L1: 7 - Northern America; L2: 74 - North-Central U.S.A.; L3: Illinois (ILL); L4: Illinois (ILL-OO)</xsl:when>
          <xsl:when test="$pRegion='IOW-OO'">L1: 7 - Northern America; L2: 74 - North-Central U.S.A.; L3: Iowa (IOW); L4: Iowa (IOW-OO)</xsl:when>
          <xsl:when test="$pRegion='KAN-OO'">L1: 7 - Northern America; L2: 74 - North-Central U.S.A.; L3: Kansas (KAN); L4: Kansas (KAN-OO)</xsl:when>
          <xsl:when test="$pRegion='MIN-OO'">L1: 7 - Northern America; L2: 74 - North-Central U.S.A.; L3: Minnesota (MIN); L4: Minnesota (MIN-OO)</xsl:when>
          <xsl:when test="$pRegion='MSO-OO'">L1: 7 - Northern America; L2: 74 - North-Central U.S.A.; L3: Missouri (MSO); L4: Missouri (MSO-OO)</xsl:when>
          <xsl:when test="$pRegion='NDA-OO'">L1: 7 - Northern America; L2: 74 - North-Central U.S.A.; L3: North Dakota (NDA); L4: North Dakota (NDA-OO)</xsl:when>
          <xsl:when test="$pRegion='NEB-OO'">L1: 7 - Northern America; L2: 74 - North-Central U.S.A.; L3: Nebraska (NEB); L4: Nebraska (NEB-OO)</xsl:when>
          <xsl:when test="$pRegion='OKL-OO'">L1: 7 - Northern America; L2: 74 - North-Central U.S.A.; L3: Oklahoma (OKL); L4: Oklahoma (OKL-OO)</xsl:when>
          <xsl:when test="$pRegion='SDA-OO'">L1: 7 - Northern America; L2: 74 - North-Central U.S.A.; L3: South Dakota (SDA); L4: South Dakota (SDA-OO)</xsl:when>
          <xsl:when test="$pRegion='WIS-OO'">L1: 7 - Northern America; L2: 74 - North-Central U.S.A.; L3: Wisconsin (WIS); L4: Wisconsin (WIS-OO)</xsl:when>
          <xsl:when test="$pRegion='CNT-OO'">L1: 7 - Northern America; L2: 75 - Northeastern U.S.A.; L3: Connecticut (CNT); L4: Connecticut (CNT-OO)</xsl:when>
          <xsl:when test="$pRegion='INI-OO'">L1: 7 - Northern America; L2: 75 - Northeastern U.S.A.; L3: Indiana (INI); L4: Indiana (INI-OO)</xsl:when>
          <xsl:when test="$pRegion='MAI-OO'">L1: 7 - Northern America; L2: 75 - Northeastern U.S.A.; L3: Maine (MAI); L4: Maine (MAI-OO)</xsl:when>
          <xsl:when test="$pRegion='MAS-OO'">L1: 7 - Northern America; L2: 75 - Northeastern U.S.A.; L3: Masachusettes (MAS); L4: Masachusettes (MAS-OO)</xsl:when>
          <xsl:when test="$pRegion='MIC-OO'">L1: 7 - Northern America; L2: 75 - Northeastern U.S.A.; L3: Michigan (MIC); L4: Michigan (MIC-OO)</xsl:when>
          <xsl:when test="$pRegion='NWH-OO'">L1: 7 - Northern America; L2: 75 - Northeastern U.S.A.; L3: New Hampshire (NWH); L4: New Hampshire (NWH-OO)</xsl:when>
          <xsl:when test="$pRegion='NWJ-OO'">L1: 7 - Northern America; L2: 75 - Northeastern U.S.A.; L3: New Jersey (NWJ); L4: New Jersey (NWJ-OO)</xsl:when>
          <xsl:when test="$pRegion='NWY-OO'">L1: 7 - Northern America; L2: 75 - Northeastern U.S.A.; L3: New York (NWY); L4: New York (NWY-OO)</xsl:when>
          <xsl:when test="$pRegion='OHI-OO'">L1: 7 - Northern America; L2: 75 - Northeastern U.S.A.; L3: Ohio (OHI); L4: Ohio (OHI-OO)</xsl:when>
          <xsl:when test="$pRegion='PEN-OO'">L1: 7 - Northern America; L2: 75 - Northeastern U.S.A.; L3: Pennsylvania (PEN); L4: Pennsylvania (PEN-OO)</xsl:when>
          <xsl:when test="$pRegion='RHO-OO'">L1: 7 - Northern America; L2: 75 - Northeastern U.S.A.; L3: Rhode I. (RHO); L4: Rhode I. (RHO-OO)</xsl:when>
          <xsl:when test="$pRegion='VER-OO'">L1: 7 - Northern America; L2: 75 - Northeastern U.S.A.; L3: Vermont (VER); L4: Vermont (VER-OO)</xsl:when>
          <xsl:when test="$pRegion='WVA-OO'">L1: 7 - Northern America; L2: 75 - Northeastern U.S.A.; L3: West Virginia (WVA); L4: West Virginia (WVA-OO)</xsl:when>
          <xsl:when test="$pRegion='ARI-OO'">L1: 7 - Northern America; L2: 76 - Southwestern U.S.A.; L3: Arizona (ARI); L4: Arizona (ARI-OO)</xsl:when>
          <xsl:when test="$pRegion='CAL-OO'">L1: 7 - Northern America; L2: 76 - Southwestern U.S.A.; L3: California (CAL); L4: California (CAL-OO)</xsl:when>
          <xsl:when test="$pRegion='NEV-OO'">L1: 7 - Northern America; L2: 76 - Southwestern U.S.A.; L3: Nevada (NEV); L4: Nevada (NEV-OO)</xsl:when>
          <xsl:when test="$pRegion='UTA-OO'">L1: 7 - Northern America; L2: 76 - Southwestern U.S.A.; L3: Utah (UTA); L4: Utah (UTA-OO)</xsl:when>
          <xsl:when test="$pRegion='NWM-OO'">L1: 7 - Northern America; L2: 77 - South-Central U.S.A.; L3: New Mexico (NWM); L4: New Mexico (NWM-OO)</xsl:when>
          <xsl:when test="$pRegion='TEX-OO'">L1: 7 - Northern America; L2: 77 - South-Central U.S.A.; L3: Texas (TEX); L4: Texas (TEX-OO)</xsl:when>
          <xsl:when test="$pRegion='ALA-OO'">L1: 7 - Northern America; L2: 78 - Southeastern U.S.A.; L3: Alabama (ALA); L4: Alabama (ALA-OO)</xsl:when>
          <xsl:when test="$pRegion='ARK-OO'">L1: 7 - Northern America; L2: 78 - Southeastern U.S.A.; L3: Arkansas (ARK); L4: Arkansas (ARK-OO)</xsl:when>
          <xsl:when test="$pRegion='DEL-OO'">L1: 7 - Northern America; L2: 78 - Southeastern U.S.A.; L3: Delaware (DEL); L4: Delaware (DEL-OO)</xsl:when>
          <xsl:when test="$pRegion='FLA-OO'">L1: 7 - Northern America; L2: 78 - Southeastern U.S.A.; L3: Florida (FLA); L4: Florida (FLA-OO)</xsl:when>
          <xsl:when test="$pRegion='GEO-OO'">L1: 7 - Northern America; L2: 78 - Southeastern U.S.A.; L3: Georgia (GEO); L4: Georgia (GEO-OO)</xsl:when>
          <xsl:when test="$pRegion='KTY-OO'">L1: 7 - Northern America; L2: 78 - Southeastern U.S.A.; L3: Kentucky (KTY); L4: Kentucky (KTY-OO)</xsl:when>
          <xsl:when test="$pRegion='LOU-OO'">L1: 7 - Northern America; L2: 78 - Southeastern U.S.A.; L3: Louisiana (LOU); L4: Louisiana (LOU-OO)</xsl:when>
          <xsl:when test="$pRegion='MRY-OO'">L1: 7 - Northern America; L2: 78 - Southeastern U.S.A.; L3: Maryland (MRY); L4: Maryland (MRY-OO)</xsl:when>
          <xsl:when test="$pRegion='MSI-OO'">L1: 7 - Northern America; L2: 78 - Southeastern U.S.A.; L3: Mississippi (MSI); L4: Mississippi (MSI-OO)</xsl:when>
          <xsl:when test="$pRegion='NCA-OO'">L1: 7 - Northern America; L2: 78 - Southeastern U.S.A.; L3: North Carolina (NCA); L4: North Carolina (NCA-OO)</xsl:when>
          <xsl:when test="$pRegion='SCA-OO'">L1: 7 - Northern America; L2: 78 - Southeastern U.S.A.; L3: South Carolina (SCA); L4: South Carolina (SCA-OO)</xsl:when>
          <xsl:when test="$pRegion='TEN-OO'">L1: 7 - Northern America; L2: 78 - Southeastern U.S.A.; L3: Tennessee (TEN); L4: Tennessee (TEN-OO)</xsl:when>
          <xsl:when test="$pRegion='VRG-OO'">L1: 7 - Northern America; L2: 78 - Southeastern U.S.A.; L3: Virginia (VRG); L4: Virginia (VRG-OO)</xsl:when>
          <xsl:when test="$pRegion='WDC-OO'">L1: 7 - Northern America; L2: 78 - Southeastern U.S.A.; L3: District of Columbia (WDC); L4: District of Columbia (WDC-OO)</xsl:when>
          <xsl:when test="$pRegion='MXC-DF'">L1: 7 - Northern America; L2: 79 - Mexico; L3: Mexico Central (MXC); L4: Mexico Distrito Federal (MXC-DF)</xsl:when>
          <xsl:when test="$pRegion='MXC-ME'">L1: 7 - Northern America; L2: 79 - Mexico; L3: Mexico Central (MXC); L4: México State (MXC-ME)</xsl:when>
          <xsl:when test="$pRegion='MXC-MO'">L1: 7 - Northern America; L2: 79 - Mexico; L3: Mexico Central (MXC); L4: Morelos (MXC-MO)</xsl:when>
          <xsl:when test="$pRegion='MXC-PU'">L1: 7 - Northern America; L2: 79 - Mexico; L3: Mexico Central (MXC); L4: Puebla (MXC-PU)</xsl:when>
          <xsl:when test="$pRegion='MXC-TL'">L1: 7 - Northern America; L2: 79 - Mexico; L3: Mexico Central (MXC); L4: Tlaxcala (MXC-TL)</xsl:when>
          <xsl:when test="$pRegion='MXE-AG'">L1: 7 - Northern America; L2: 79 - Mexico; L3: Mexico Northeast (MXE); L4: Aguascalientes (MXE-AG)</xsl:when>
          <xsl:when test="$pRegion='MXE-CO'">L1: 7 - Northern America; L2: 79 - Mexico; L3: Mexico Northeast (MXE); L4: Coahuila (MXE-CO)</xsl:when>
          <xsl:when test="$pRegion='MXE-CU'">L1: 7 - Northern America; L2: 79 - Mexico; L3: Mexico Northeast (MXE); L4: Chihuahua (MXE-CU)</xsl:when>
          <xsl:when test="$pRegion='MXE-DU'">L1: 7 - Northern America; L2: 79 - Mexico; L3: Mexico Northeast (MXE); L4: Durango (MXE-DU)</xsl:when>
          <xsl:when test="$pRegion='MXE-GU'">L1: 7 - Northern America; L2: 79 - Mexico; L3: Mexico Northeast (MXE); L4: Guanajuato (MXE-GU)</xsl:when>
          <xsl:when test="$pRegion='MXE-HI'">L1: 7 - Northern America; L2: 79 - Mexico; L3: Mexico Northeast (MXE); L4: Hidalgo (MXE-HI)</xsl:when>
          <xsl:when test="$pRegion='MXE-NL'">L1: 7 - Northern America; L2: 79 - Mexico; L3: Mexico Northeast (MXE); L4: Nuevo León (MXE-NL)</xsl:when>
          <xsl:when test="$pRegion='MXE-QU'">L1: 7 - Northern America; L2: 79 - Mexico; L3: Mexico Northeast (MXE); L4: Querétaro (MXE-QU)</xsl:when>
          <xsl:when test="$pRegion='MXE-SL'">L1: 7 - Northern America; L2: 79 - Mexico; L3: Mexico Northeast (MXE); L4: San Luis Potosí (MXE-SL)</xsl:when>
          <xsl:when test="$pRegion='MXE-TA'">L1: 7 - Northern America; L2: 79 - Mexico; L3: Mexico Northeast (MXE); L4: Tamaulipas (MXE-TA)</xsl:when>
          <xsl:when test="$pRegion='MXE-ZA'">L1: 7 - Northern America; L2: 79 - Mexico; L3: Mexico Northeast (MXE); L4: Zacatecas (MXE-ZA)</xsl:when>
          <xsl:when test="$pRegion='MXG-VC'">L1: 7 - Northern America; L2: 79 - Mexico; L3: Mexico Gulf (MXG); L4: Veracruz (MXG-VC)</xsl:when>
          <xsl:when test="$pRegion='MXI-GU'">L1: 7 - Northern America; L2: 79 - Mexico; L3: Mexican Pacific Is. (MXI); L4: Guadalupe I. (MXI-GU)</xsl:when>
          <xsl:when test="$pRegion='MXI-RA'">L1: 7 - Northern America; L2: 79 - Mexico; L3: Mexican Pacific Is. (MXI); L4: Rocas Alijos (MXI-RA)</xsl:when>
          <xsl:when test="$pRegion='MXI-RG'">L1: 7 - Northern America; L2: 79 - Mexico; L3: Mexican Pacific Is. (MXI); L4: Revillagigedo Is. (MXI-RG)</xsl:when>
          <xsl:when test="$pRegion='MXN-BC'">L1: 7 - Northern America; L2: 79 - Mexico; L3: Mexico Northwest (MXN); L4: Baja California (MXN-BC)</xsl:when>
          <xsl:when test="$pRegion='MXN-BS'">L1: 7 - Northern America; L2: 79 - Mexico; L3: Mexico Northwest (MXN); L4: Baja California Sur (MXN-BS)</xsl:when>
          <xsl:when test="$pRegion='MXN-SI'">L1: 7 - Northern America; L2: 79 - Mexico; L3: Mexico Northwest (MXN); L4: Sinaloa (MXN-SI)</xsl:when>
          <xsl:when test="$pRegion='MXN-SO'">L1: 7 - Northern America; L2: 79 - Mexico; L3: Mexico Northwest (MXN); L4: Sonora (MXN-SO)</xsl:when>
          <xsl:when test="$pRegion='MXS-CL'">L1: 7 - Northern America; L2: 79 - Mexico; L3: Mexico Southwest (MXS); L4: Colima (MXS-CL)</xsl:when>
          <xsl:when test="$pRegion='MXS-GR'">L1: 7 - Northern America; L2: 79 - Mexico; L3: Mexico Southwest (MXS); L4: Guerrero (MXS-GR)</xsl:when>
          <xsl:when test="$pRegion='MXS-JA'">L1: 7 - Northern America; L2: 79 - Mexico; L3: Mexico Southwest (MXS); L4: Jalisco (MXS-JA)</xsl:when>
          <xsl:when test="$pRegion='MXS-MI'">L1: 7 - Northern America; L2: 79 - Mexico; L3: Mexico Southwest (MXS); L4: Michoacán (MXS-MI)</xsl:when>
          <xsl:when test="$pRegion='MXS-NA'">L1: 7 - Northern America; L2: 79 - Mexico; L3: Mexico Southwest (MXS); L4: Nayarit (MXS-NA)</xsl:when>
          <xsl:when test="$pRegion='MXS-OA'">L1: 7 - Northern America; L2: 79 - Mexico; L3: Mexico Southwest (MXS); L4: Oaxaca (MXS-OA)</xsl:when>
          <xsl:when test="$pRegion='MXT-CA'">L1: 7 - Northern America; L2: 79 - Mexico; L3: Mexico Southeast (MXT); L4: Campeche (MXT-CA)</xsl:when>
          <xsl:when test="$pRegion='MXT-CI'">L1: 7 - Northern America; L2: 79 - Mexico; L3: Mexico Southeast (MXT); L4: Chiapas (MXT-CI)</xsl:when>
          <xsl:when test="$pRegion='MXT-QR'">L1: 7 - Northern America; L2: 79 - Mexico; L3: Mexico Southeast (MXT); L4: Quintana Roo (MXT-QR)</xsl:when>
          <xsl:when test="$pRegion='MXT-TB'">L1: 7 - Northern America; L2: 79 - Mexico; L3: Mexico Southeast (MXT); L4: Tabasco (MXT-TB)</xsl:when>
          <xsl:when test="$pRegion='MXT-YU'">L1: 7 - Northern America; L2: 79 - Mexico; L3: Mexico Southeast (MXT); L4: Yucatán (MXT-YU)</xsl:when>
          <xsl:when test="$pRegion='BLZ-OO'">L1: 8 - Southern America; L2: 80 - Central America; L3: Belize (BLZ); L4: Belize (BLZ-OO)</xsl:when>
          <xsl:when test="$pRegion='COS-OO'">L1: 8 - Southern America; L2: 80 - Central America; L3: Costa Rica (COS); L4: Costa Rica (COS-OO)</xsl:when>
          <xsl:when test="$pRegion='CPI-CL'">L1: 8 - Southern America; L2: 80 - Central America; L3: Central American Pacific Is. (CPI); L4: Clipperton I. (CPI-CL)</xsl:when>
          <xsl:when test="$pRegion='CPI-CO'">L1: 8 - Southern America; L2: 80 - Central America; L3: Central American Pacific Is. (CPI); L4: Cocos I. (CPI-CO)</xsl:when>
          <xsl:when test="$pRegion='CPI-MA'">L1: 8 - Southern America; L2: 80 - Central America; L3: Central American Pacific Is. (CPI); L4: Malpelo I. (CPI-MA)</xsl:when>
          <xsl:when test="$pRegion='ELS-OO'">L1: 8 - Southern America; L2: 80 - Central America; L3: El Salvador (ELS); L4: El Salvador (ELS-OO)</xsl:when>
          <xsl:when test="$pRegion='GUA-OO'">L1: 8 - Southern America; L2: 80 - Central America; L3: Guatemala (GUA); L4: Guatemala (GUA-OO)</xsl:when>
          <xsl:when test="$pRegion='HON-OO'">L1: 8 - Southern America; L2: 80 - Central America; L3: Honduras (HON); L4: Honduras (HON-OO)</xsl:when>
          <xsl:when test="$pRegion='NIC-OO'">L1: 8 - Southern America; L2: 80 - Central America; L3: Nicaragua (NIC); L4: Nicaragua (NIC-OO)</xsl:when>
          <xsl:when test="$pRegion='PAN-OO'">L1: 8 - Southern America; L2: 80 - Central America; L3: Panamá (PAN); L4: Panamá (PAN-OO)</xsl:when>
          <xsl:when test="$pRegion='ARU-OO'">L1: 8 - Southern America; L2: 81 - Caribbean; L3: Aruba (ARU); L4: Aruba (ARU-OO)</xsl:when>
          <xsl:when test="$pRegion='BAH-OO'">L1: 8 - Southern America; L2: 81 - Caribbean; L3: Bahamas (BAH); L4: Bahamas (BAH-OO)</xsl:when>
          <xsl:when test="$pRegion='BER-OO'">L1: 8 - Southern America; L2: 81 - Caribbean; L3: Bermuda (BER); L4: Bermuda (BER-OO)</xsl:when>
          <xsl:when test="$pRegion='CAY-OO'">L1: 8 - Southern America; L2: 81 - Caribbean; L3: Cayman Is. (CAY); L4: Cayman Is. (CAY-OO)</xsl:when>
          <xsl:when test="$pRegion='CUB-OO'">L1: 8 - Southern America; L2: 81 - Caribbean; L3: Cuba (CUB); L4: Cuba (CUB-OO)</xsl:when>
          <xsl:when test="$pRegion='DOM-OO'">L1: 8 - Southern America; L2: 81 - Caribbean; L3: Dominican Republic (DOM); L4: Dominican Republic (DOM-OO)</xsl:when>
          <xsl:when test="$pRegion='HAI-HA'">L1: 8 - Southern America; L2: 81 - Caribbean; L3: Haiti (HAI); L4: Haiti (HAI-HA)</xsl:when>
          <xsl:when test="$pRegion='HAI-NI'">L1: 8 - Southern America; L2: 81 - Caribbean; L3: Haiti (HAI); L4: Navassa I. (HAI-NI)</xsl:when>
          <xsl:when test="$pRegion='JAM-OO'">L1: 8 - Southern America; L2: 81 - Caribbean; L3: Jamaica (JAM); L4: Jamaica (JAM-OO)</xsl:when>
          <xsl:when test="$pRegion='LEE-AB'">L1: 8 - Southern America; L2: 81 - Caribbean; L3: Leeward Is. (LEE); L4: Antigua-Barbuda (LEE-AB)</xsl:when>
          <xsl:when test="$pRegion='LEE-AG'">L1: 8 - Southern America; L2: 81 - Caribbean; L3: Leeward Is. (LEE); L4: Anguilla (LEE-AG)</xsl:when>
          <xsl:when test="$pRegion='LEE-AV'">L1: 8 - Southern America; L2: 81 - Caribbean; L3: Leeward Is. (LEE); L4: Aves I. (LEE-AV)</xsl:when>
          <xsl:when test="$pRegion='LEE-BV'">L1: 8 - Southern America; L2: 81 - Caribbean; L3: Leeward Is. (LEE); L4: British Virgin Is. (LEE-BV)</xsl:when>
          <xsl:when test="$pRegion='LEE-GU'">L1: 8 - Southern America; L2: 81 - Caribbean; L3: Leeward Is. (LEE); L4: Guadeloupe (LEE-GU)</xsl:when>
          <xsl:when test="$pRegion='LEE-MO'">L1: 8 - Southern America; L2: 81 - Caribbean; L3: Leeward Is. (LEE); L4: Montserrat (LEE-MO)</xsl:when>
          <xsl:when test="$pRegion='LEE-NL'">L1: 8 - Southern America; L2: 81 - Caribbean; L3: Leeward Is. (LEE); L4: Netherlands Leeward Is. (LEE-NL)</xsl:when>
          <xsl:when test="$pRegion='LEE-SK'">L1: 8 - Southern America; L2: 81 - Caribbean; L3: Leeward Is. (LEE); L4: St.Kitts-Nevis (LEE-SK)</xsl:when>
          <xsl:when test="$pRegion='LEE-SM'">L1: 8 - Southern America; L2: 81 - Caribbean; L3: Leeward Is. (LEE); L4: St.Martin-St.Barthélémy (LEE-SM)</xsl:when>
          <xsl:when test="$pRegion='LEE-VI'">L1: 8 - Southern America; L2: 81 - Caribbean; L3: Leeward Is. (LEE); L4: Virgin Is. (LEE-VI)</xsl:when>
          <xsl:when test="$pRegion='NLA-BO'">L1: 8 - Southern America; L2: 81 - Caribbean; L3: Netherlands Antilles (NLA); L4: Bonaire (NLA-BO)</xsl:when>
          <xsl:when test="$pRegion='NLA-CU'">L1: 8 - Southern America; L2: 81 - Caribbean; L3: Netherlands Antilles (NLA); L4: Curaçao (NLA-CU)</xsl:when>
          <xsl:when test="$pRegion='PUE-OO'">L1: 8 - Southern America; L2: 81 - Caribbean; L3: Puerto Rico (PUE); L4: Puerto Rico (PUE-OO)</xsl:when>
          <xsl:when test="$pRegion='SWC-CC'">L1: 8 - Southern America; L2: 81 - Caribbean; L3: Southwest Caribbean (SWC); L4: Colombian Caribbean Is. (SWC-CC)</xsl:when>
          <xsl:when test="$pRegion='SWC-HC'">L1: 8 - Southern America; L2: 81 - Caribbean; L3: Southwest Caribbean (SWC); L4: Honduran Caribbean Is. (SWC-HC)</xsl:when>
          <xsl:when test="$pRegion='SWC-NC'">L1: 8 - Southern America; L2: 81 - Caribbean; L3: Southwest Caribbean (SWC); L4: Nicaraguan Caribbean Is. (SWC-NC)</xsl:when>
          <xsl:when test="$pRegion='TCI-OO'">L1: 8 - Southern America; L2: 81 - Caribbean; L3: Turks-Caicos Is. (TCI); L4: Turks-Caicos Is. (TCI-OO)</xsl:when>
          <xsl:when test="$pRegion='TRT-OO'">L1: 8 - Southern America; L2: 81 - Caribbean; L3: Trinidad-Tobago (TRT); L4: Trinidad-Tobago (TRT-OO)</xsl:when>
          <xsl:when test="$pRegion='VNA-OO'">L1: 8 - Southern America; L2: 81 - Caribbean; L3: Venezuelan Antilles (VNA); L4: Venezuelan Antilles (VNA-OO)</xsl:when>
          <xsl:when test="$pRegion='WIN-BA'">L1: 8 - Southern America; L2: 81 - Caribbean; L3: Windward Is. (WIN); L4: Barbados (WIN-BA)</xsl:when>
          <xsl:when test="$pRegion='WIN-DO'">L1: 8 - Southern America; L2: 81 - Caribbean; L3: Windward Is. (WIN); L4: Dominica (WIN-DO)</xsl:when>
          <xsl:when test="$pRegion='WIN-GR'">L1: 8 - Southern America; L2: 81 - Caribbean; L3: Windward Is. (WIN); L4: Grenada (WIN-GR)</xsl:when>
          <xsl:when test="$pRegion='WIN-MA'">L1: 8 - Southern America; L2: 81 - Caribbean; L3: Windward Is. (WIN); L4: Martinique (WIN-MA)</xsl:when>
          <xsl:when test="$pRegion='WIN-SL'">L1: 8 - Southern America; L2: 81 - Caribbean; L3: Windward Is. (WIN); L4: St.Lucia (WIN-SL)</xsl:when>
          <xsl:when test="$pRegion='WIN-SV'">L1: 8 - Southern America; L2: 81 - Caribbean; L3: Windward Is. (WIN); L4: St.Vincent (WIN-SV)</xsl:when>
          <xsl:when test="$pRegion='FRG-OO'">L1: 8 - Southern America; L2: 82 - Northern South America; L3: French Guiana (FRG); L4: French Guiana (FRG-OO)</xsl:when>
          <xsl:when test="$pRegion='GUY-OO'">L1: 8 - Southern America; L2: 82 - Northern South America; L3: Guyana (GUY); L4: Guyana (GUY-OO)</xsl:when>
          <xsl:when test="$pRegion='SUR-OO'">L1: 8 - Southern America; L2: 82 - Northern South America; L3: Suriname (SUR); L4: Surinam (SUR-OO)</xsl:when>
          <xsl:when test="$pRegion='VEN-OO'">L1: 8 - Southern America; L2: 82 - Northern South America; L3: Venezuela (VEN); L4: Venezuela (VEN-OO)</xsl:when>
          <xsl:when test="$pRegion='BOL-OO'">L1: 8 - Southern America; L2: 83 - Western South America; L3: Bolivia (BOL); L4: Bolivia (BOL-OO)</xsl:when>
          <xsl:when test="$pRegion='CLM-OO'">L1: 8 - Southern America; L2: 83 - Western South America; L3: Colombia (CLM); L4: Colombia (CLM-OO)</xsl:when>
          <xsl:when test="$pRegion='ECU-OO'">L1: 8 - Southern America; L2: 83 - Western South America; L3: Ecuador (ECU); L4: Ecuador (ECU-OO)</xsl:when>
          <xsl:when test="$pRegion='GAL-OO'">L1: 8 - Southern America; L2: 83 - Western South America; L3: Galápagos (GAL); L4: Galápagos (GAL-OO)</xsl:when>
          <xsl:when test="$pRegion='PER-OO'">L1: 8 - Southern America; L2: 83 - Western South America; L3: Peru (PER); L4: Peru (PER-OO)</xsl:when>
          <xsl:when test="$pRegion='BZC-DF'">L1: 8 - Southern America; L2: 84 - Brazil; L3: Brazil West-Central (BZC); L4: Brazilia Distrito Federal (BZC-DF)</xsl:when>
          <xsl:when test="$pRegion='BZC-GO'">L1: 8 - Southern America; L2: 84 - Brazil; L3: Brazil West-Central (BZC); L4: Goiás (BZC-GO)</xsl:when>
          <xsl:when test="$pRegion='BZC-MS'">L1: 8 - Southern America; L2: 84 - Brazil; L3: Brazil West-Central (BZC); L4: Mato Grosso do Sul (BZC-MS)</xsl:when>
          <xsl:when test="$pRegion='BZC-MT'">L1: 8 - Southern America; L2: 84 - Brazil; L3: Brazil West-Central (BZC); L4: Mato Grosso (BZC-MT)</xsl:when>
          <xsl:when test="$pRegion='BZE-AL'">L1: 8 - Southern America; L2: 84 - Brazil; L3: Brazil Northeast (BZE); L4: Alagoas (BZE-AL)</xsl:when>
          <xsl:when test="$pRegion='BZE-BA'">L1: 8 - Southern America; L2: 84 - Brazil; L3: Brazil Northeast (BZE); L4: Bahia (BZE-BA)</xsl:when>
          <xsl:when test="$pRegion='BZE-CE'">L1: 8 - Southern America; L2: 84 - Brazil; L3: Brazil Northeast (BZE); L4: Ceará (BZE-CE)</xsl:when>
          <xsl:when test="$pRegion='BZE-FN'">L1: 8 - Southern America; L2: 84 - Brazil; L3: Brazil Northeast (BZE); L4: Fernando de Noronha (BZE-FN)</xsl:when>
          <xsl:when test="$pRegion='BZE-MA'">L1: 8 - Southern America; L2: 84 - Brazil; L3: Brazil Northeast (BZE); L4: Maranhao (BZE-MA)</xsl:when>
          <xsl:when test="$pRegion='BZE-PB'">L1: 8 - Southern America; L2: 84 - Brazil; L3: Brazil Northeast (BZE); L4: Paraíba (BZE-PB)</xsl:when>
          <xsl:when test="$pRegion='BZE-PE'">L1: 8 - Southern America; L2: 84 - Brazil; L3: Brazil Northeast (BZE); L4: Pernambuco (BZE-PE)</xsl:when>
          <xsl:when test="$pRegion='BZE-PI'">L1: 8 - Southern America; L2: 84 - Brazil; L3: Brazil Northeast (BZE); L4: Piauí (BZE-PI)</xsl:when>
          <xsl:when test="$pRegion='BZE-RN'">L1: 8 - Southern America; L2: 84 - Brazil; L3: Brazil Northeast (BZE); L4: Rio Grande do Norte (BZE-RN)</xsl:when>
          <xsl:when test="$pRegion='BZE-SE'">L1: 8 - Southern America; L2: 84 - Brazil; L3: Brazil Northeast (BZE); L4: Sergipe (BZE-SE)</xsl:when>
          <xsl:when test="$pRegion='BZL-ES'">L1: 8 - Southern America; L2: 84 - Brazil; L3: Brazil Southeast (BZL); L4: Espirito Santo (BZL-ES)</xsl:when>
          <xsl:when test="$pRegion='BZL-MG'">L1: 8 - Southern America; L2: 84 - Brazil; L3: Brazil Southeast (BZL); L4: Minas Gerais (BZL-MG)</xsl:when>
          <xsl:when test="$pRegion='BZL-RJ'">L1: 8 - Southern America; L2: 84 - Brazil; L3: Brazil Southeast (BZL); L4: Rio de Janeiro (BZL-RJ)</xsl:when>
          <xsl:when test="$pRegion='BZL-SP'">L1: 8 - Southern America; L2: 84 - Brazil; L3: Brazil Southeast (BZL); L4: São Paulo (BZL-SP)</xsl:when>
          <xsl:when test="$pRegion='BZL-TR'">L1: 8 - Southern America; L2: 84 - Brazil; L3: Brazil Southeast (BZL); L4: Trindade (BZL-TR)</xsl:when>
          <xsl:when test="$pRegion='BZN-AC'">L1: 8 - Southern America; L2: 84 - Brazil; L3: Brazil North (BZN); L4: Acre (BZN-AC)</xsl:when>
          <xsl:when test="$pRegion='BZN-AM'">L1: 8 - Southern America; L2: 84 - Brazil; L3: Brazil North (BZN); L4: Amazonas (BZN-AM)</xsl:when>
          <xsl:when test="$pRegion='BZN-AP'">L1: 8 - Southern America; L2: 84 - Brazil; L3: Brazil North (BZN); L4: Amapá (BZN-AP)</xsl:when>
          <xsl:when test="$pRegion='BZN-PA'">L1: 8 - Southern America; L2: 84 - Brazil; L3: Brazil North (BZN); L4: Pará (BZN-PA)</xsl:when>
          <xsl:when test="$pRegion='BZN-RM'">L1: 8 - Southern America; L2: 84 - Brazil; L3: Brazil North (BZN); L4: Roraima (BZN-RM)</xsl:when>
          <xsl:when test="$pRegion='BZN-RO'">L1: 8 - Southern America; L2: 84 - Brazil; L3: Brazil North (BZN); L4: Rondônia (BZN-RO)</xsl:when>
          <xsl:when test="$pRegion='BZN-TO'">L1: 8 - Southern America; L2: 84 - Brazil; L3: Brazil North (BZN); L4: Tocantins (BZN-TO)</xsl:when>
          <xsl:when test="$pRegion='BZS-PR'">L1: 8 - Southern America; L2: 84 - Brazil; L3: Brazil South (BZS); L4: Paraná (BZS-PR)</xsl:when>
          <xsl:when test="$pRegion='BZS-RS'">L1: 8 - Southern America; L2: 84 - Brazil; L3: Brazil South (BZS); L4: Rio Grande do Sul (BZS-RS)</xsl:when>
          <xsl:when test="$pRegion='BZS-SC'">L1: 8 - Southern America; L2: 84 - Brazil; L3: Brazil South (BZS); L4: Santa Catarina (BZS-SC)</xsl:when>
          <xsl:when test="$pRegion='AGE-BA'">L1: 8 - Southern America; L2: 85 - Southern South America; L3: Argentina Northeast (AGE); L4: Buenos Aires (AGE-BA)</xsl:when>
          <xsl:when test="$pRegion='AGE-CH'">L1: 8 - Southern America; L2: 85 - Southern South America; L3: Argentina Northeast (AGE); L4: Chaco (AGE-CH)</xsl:when>
          <xsl:when test="$pRegion='AGE-CN'">L1: 8 - Southern America; L2: 85 - Southern South America; L3: Argentina Northeast (AGE); L4: Corrientes (AGE-CN)</xsl:when>
          <xsl:when test="$pRegion='AGE-CO'">L1: 8 - Southern America; L2: 85 - Southern South America; L3: Argentina Northeast (AGE); L4: Córdoba (AGE-CO)</xsl:when>
          <xsl:when test="$pRegion='AGE-DF'">L1: 8 - Southern America; L2: 85 - Southern South America; L3: Argentina Northeast (AGE); L4: Argentina Distrito Federal (AGE-DF)</xsl:when>
          <xsl:when test="$pRegion='AGE-ER'">L1: 8 - Southern America; L2: 85 - Southern South America; L3: Argentina Northeast (AGE); L4: Entre Ríos (AGE-ER)</xsl:when>
          <xsl:when test="$pRegion='AGE-FO'">L1: 8 - Southern America; L2: 85 - Southern South America; L3: Argentina Northeast (AGE); L4: Formosa (AGE-FO)</xsl:when>
          <xsl:when test="$pRegion='AGE-LP'">L1: 8 - Southern America; L2: 85 - Southern South America; L3: Argentina Northeast (AGE); L4: La Pampa (AGE-LP)</xsl:when>
          <xsl:when test="$pRegion='AGE-MI'">L1: 8 - Southern America; L2: 85 - Southern South America; L3: Argentina Northeast (AGE); L4: Misiones (AGE-MI)</xsl:when>
          <xsl:when test="$pRegion='AGS-CB'">L1: 8 - Southern America; L2: 85 - Southern South America; L3: Argentina South (AGS); L4: Chubut (AGS-CB)</xsl:when>
          <xsl:when test="$pRegion='AGS-NE'">L1: 8 - Southern America; L2: 85 - Southern South America; L3: Argentina South (AGS); L4: Neuquén (AGS-NE)</xsl:when>
          <xsl:when test="$pRegion='AGS-RN'">L1: 8 - Southern America; L2: 85 - Southern South America; L3: Argentina South (AGS); L4: Rio Negro (AGS-RN)</xsl:when>
          <xsl:when test="$pRegion='AGS-SC'">L1: 8 - Southern America; L2: 85 - Southern South America; L3: Argentina South (AGS); L4: Santa Cruz (AGS-SC)</xsl:when>
          <xsl:when test="$pRegion='AGS-SF'">L1: 8 - Southern America; L2: 85 - Southern South America; L3: Argentina South (AGS); L4: Santa Fé (AGS-SF)</xsl:when>
          <xsl:when test="$pRegion='AGS-TF'">L1: 8 - Southern America; L2: 85 - Southern South America; L3: Argentina South (AGS); L4: Tierra del Fuego (Argentina) (AGS-TF)</xsl:when>
          <xsl:when test="$pRegion='AGW-CA'">L1: 8 - Southern America; L2: 85 - Southern South America; L3: Argentina Northwest (AGW); L4: Catamarca (AGW-CA)</xsl:when>
          <xsl:when test="$pRegion='AGW-JU'">L1: 8 - Southern America; L2: 85 - Southern South America; L3: Argentina Northwest (AGW); L4: Jujuy (AGW-JU)</xsl:when>
          <xsl:when test="$pRegion='AGW-LR'">L1: 8 - Southern America; L2: 85 - Southern South America; L3: Argentina Northwest (AGW); L4: La Rioja (AGW-LR)</xsl:when>
          <xsl:when test="$pRegion='AGW-ME'">L1: 8 - Southern America; L2: 85 - Southern South America; L3: Argentina Northwest (AGW); L4: Mendoza (AGW-ME)</xsl:when>
          <xsl:when test="$pRegion='AGW-SA'">L1: 8 - Southern America; L2: 85 - Southern South America; L3: Argentina Northwest (AGW); L4: Salta (AGW-SA)</xsl:when>
          <xsl:when test="$pRegion='AGW-SE'">L1: 8 - Southern America; L2: 85 - Southern South America; L3: Argentina Northwest (AGW); L4: Santiago del Estero (AGW-SE)</xsl:when>
          <xsl:when test="$pRegion='AGW-SJ'">L1: 8 - Southern America; L2: 85 - Southern South America; L3: Argentina Northwest (AGW); L4: San Juan (AGW-SJ)</xsl:when>
          <xsl:when test="$pRegion='AGW-SL'">L1: 8 - Southern America; L2: 85 - Southern South America; L3: Argentina Northwest (AGW); L4: San Luis (AGW-SL)</xsl:when>
          <xsl:when test="$pRegion='AGW-TU'">L1: 8 - Southern America; L2: 85 - Southern South America; L3: Argentina Northwest (AGW); L4: Tucuman (AGW-TU)</xsl:when>
          <xsl:when test="$pRegion='CLC-BI'">L1: 8 - Southern America; L2: 85 - Southern South America; L3: Chile Central (CLC); L4: Biobío (CLC-BI)</xsl:when>
          <xsl:when test="$pRegion='CLC-CO'">L1: 8 - Southern America; L2: 85 - Southern South America; L3: Chile Central (CLC); L4: Coquimbo (CLC-CO)</xsl:when>
          <xsl:when test="$pRegion='CLC-LA'">L1: 8 - Southern America; L2: 85 - Southern South America; L3: Chile Central (CLC); L4: La Araucania (CLC-LA)</xsl:when>
          <xsl:when test="$pRegion='CLC-MA'">L1: 8 - Southern America; L2: 85 - Southern South America; L3: Chile Central (CLC); L4: Maule (CLC-MA)</xsl:when>
          <xsl:when test="$pRegion='CLC-OH'">L1: 8 - Southern America; L2: 85 - Southern South America; L3: Chile Central (CLC); L4: O'Higgins (CLC-OH)</xsl:when>
          <xsl:when test="$pRegion='CLC-SA'">L1: 8 - Southern America; L2: 85 - Southern South America; L3: Chile Central (CLC); L4: Santiago (CLC-SA)</xsl:when>
          <xsl:when test="$pRegion='CLC-VA'">L1: 8 - Southern America; L2: 85 - Southern South America; L3: Chile Central (CLC); L4: Valparaíso (CLC-VA)</xsl:when>
          <xsl:when test="$pRegion='CLN-AN'">L1: 8 - Southern America; L2: 85 - Southern South America; L3: Chile North (CLN); L4: Antofagasta (CLN-AN)</xsl:when>
          <xsl:when test="$pRegion='CLN-AT'">L1: 8 - Southern America; L2: 85 - Southern South America; L3: Chile North (CLN); L4: Atacama (CLN-AT)</xsl:when>
          <xsl:when test="$pRegion='CLN-TA'">L1: 8 - Southern America; L2: 85 - Southern South America; L3: Chile North (CLN); L4: Tarapaca (CLN-TA)</xsl:when>
          <xsl:when test="$pRegion='CLS-AI'">L1: 8 - Southern America; L2: 85 - Southern South America; L3: Chile South (CLS); L4: Aisén (CLS-AI)</xsl:when>
          <xsl:when test="$pRegion='CLS-LL'">L1: 8 - Southern America; L2: 85 - Southern South America; L3: Chile South (CLS); L4: Los Lagos (CLS-LL)</xsl:when>
          <xsl:when test="$pRegion='CLS-MG'">L1: 8 - Southern America; L2: 85 - Southern South America; L3: Chile South (CLS); L4: Magellanes (CLS-MG)</xsl:when>
          <xsl:when test="$pRegion='DSV-OO'">L1: 8 - Southern America; L2: 85 - Southern South America; L3: Desventurados Is. (DSV); L4: Desventurados Is. (DSV-OO)</xsl:when>
          <xsl:when test="$pRegion='JNF-OO'">L1: 8 - Southern America; L2: 85 - Southern South America; L3: Juan Fernández Is. (JNF); L4: Juan Fernández Is. (JNF-OO)</xsl:when>
          <xsl:when test="$pRegion='PAR-OO'">L1: 8 - Southern America; L2: 85 - Southern South America; L3: Paraguay (PAR); L4: Paraguay (PAR-OO)</xsl:when>
          <xsl:when test="$pRegion='URU-OO'">L1: 8 - Southern America; L2: 85 - Southern South America; L3: Uruguay (URU); L4: Uruguay (URU-OO)</xsl:when>
          <xsl:when test="$pRegion='ASP-OO'">L1: 9 - Antarctic; L2: 90 - Subantarctic Islands; L3: Amsterdam-St.Paul Is. (ASP); L4: Amsterdam-St.Paul Is. (ASP-OO)</xsl:when>
          <xsl:when test="$pRegion='BOU-OO'">L1: 9 - Antarctic; L2: 90 - Subantarctic Islands; L3: Bouvet I. (BOU); L4: Bouvet I. (BOU-OO)</xsl:when>
          <xsl:when test="$pRegion='CRZ-OO'">L1: 9 - Antarctic; L2: 90 - Subantarctic Islands; L3: Crozet Is. (CRZ); L4: Crozet Is. (CRZ-OO)</xsl:when>
          <xsl:when test="$pRegion='FAL-OO'">L1: 9 - Antarctic; L2: 90 - Subantarctic Islands; L3: Falkland Is. (FAL); L4: Falkland Is. (FAL-OO)</xsl:when>
          <xsl:when test="$pRegion='HMD-OO'">L1: 9 - Antarctic; L2: 90 - Subantarctic Islands; L3: Heard-McDonald Is. (HMD); L4: Heard-McDonald Is. (HMD-OO)</xsl:when>
          <xsl:when test="$pRegion='KEG-OO'">L1: 9 - Antarctic; L2: 90 - Subantarctic Islands; L3: Kerguelen (KEG); L4: Kerguelen (KEG-OO)</xsl:when>
          <xsl:when test="$pRegion='MAQ-OO'">L1: 9 - Antarctic; L2: 90 - Subantarctic Islands; L3: Macquarie Is. (MAQ); L4: Macquarie Is. (MAQ-OO)</xsl:when>
          <xsl:when test="$pRegion='MPE-OO'">L1: 9 - Antarctic; L2: 90 - Subantarctic Islands; L3: Marion-Prince Edward Is. (MPE); L4: Marion-Prince Edward Is. (MPE-OO)</xsl:when>
          <xsl:when test="$pRegion='SGE-OO'">L1: 9 - Antarctic; L2: 90 - Subantarctic Islands; L3: South Georgia (SGE); L4: South Georgia (SGE-OO)</xsl:when>
          <xsl:when test="$pRegion='SSA-OO'">L1: 9 - Antarctic; L2: 90 - Subantarctic Islands; L3: South Sandwich Is. (SSA); L4: South Sandwich Is. (SSA-OO)</xsl:when>
          <xsl:when test="$pRegion='TDC-OO'">L1: 9 - Antarctic; L2: 90 - Subantarctic Islands; L3: Tristan da Cunha (TDC); L4: Tristan da Cunha (TDC-OO)</xsl:when>
          <xsl:when test="$pRegion='ANT-OO'">L1: 9 - Antarctic; L2: 91 - Antarctic Continent; L3: Antarctica (ANT); L4: Antarctica (ANT-OO)</xsl:when>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
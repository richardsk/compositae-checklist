<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:key use="@L1" name="kL1" match="Biostat" />
  <xsl:key use="concat(@L1,'+', @L2)" name="kL2" match="Biostat" />
  <xsl:key use="concat(@L1,'+', @L2, '+', @L3)" name="kL3" match="Biostat" />
  <xsl:key use="concat(@L1,'+', @L2, '+', @L3, '+', @L4)" name="kL4" match="Biostat" />
  <xsl:key name="kProv" match="Provider" use="."/>
  <xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes" />
  <xsl:template match="/">
    <html>
      <style>
        th, td {TEXT-ALIGN: left; PADDING-RIGHT: 1px; PADDING-LEFT: 3px}
        th {BORDER-TOP: #cccccc 1px solid; BACKGROUND-COLOR: #f2f2f}
        .topline, .t11, .t12, .t13, .t14 , .t22, .t23, .t24, .t33,  .t34, .t44  {BORDER-TOP: #cccccc 1px solid}
        .noline, .t21, .t31, .t32, .t41, .t42, .t43 {}

      </style>
      <body>
        <table width="100%">
          <caption align="left">Distribution using World Geographic Schema for Record Plant Occurrences.</caption>
          <tbody>
            <tr>
              <th>Level 1</th>
              <th>Level 2</th>
              <th>Level 3</th>
              <th>Level 4</th>
              <th>Biostatus</th>
              <th>Occurrence</th>
              <th>Origin</th>
              <th>Providers</th>
            </tr>
            <xsl:for-each select="//Biostat">
              <xsl:sort select="@L1" />
              <xsl:sort select="@L2" />
              <xsl:sort select="@L3" />
              <xsl:sort select="@L4" />
              <xsl:variable name="level">
                <xsl:choose>
                  <xsl:when test="generate-id() = generate-id(key('kL1', @L1)[1])">1</xsl:when>
                  <xsl:otherwise>
                    <xsl:choose>
                      <xsl:when test="generate-id() = generate-id(key('kL2', concat(@L1,'+', @L2))[1])">2</xsl:when>
                      <xsl:otherwise>
                        <xsl:choose>
                          <xsl:when test="generate-id() = generate-id(key('kL3', concat(@L1,'+', @L2, '+', @L3))[1])">3</xsl:when>
                          <xsl:otherwise>4</xsl:otherwise>
                        </xsl:choose>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <tr>
                <td>
                  <xsl:attribute name="class">
                    <xsl:value-of select="concat('t', $level, '1')" />
                  </xsl:attribute>
                  <xsl:choose>
                    <xsl:when test="generate-id() = generate-id(key('kL1', @L1)[1])">
                      <xsl:value-of select="@L1" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:attribute name="class">
                    <xsl:value-of select="concat('t', $level, '2')" />
                  </xsl:attribute>
                  <xsl:if test="generate-id() = generate-id(key('kL2', concat(@L1,'+', @L2))[1])">
                    <xsl:value-of select="@L2" />
                  </xsl:if>
                  <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                </td>
                <td>
                  <xsl:attribute name="class">
                    <xsl:value-of select="concat('t', $level, '3')" />
                  </xsl:attribute>
                  <xsl:if test="generate-id() = generate-id(key('kL3', concat(@L1,'+', @L2, '+', @L3))[1])">
                    <xsl:value-of select="@L3" />
                  </xsl:if>
                  <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                </td>
                <td>
                  <xsl:attribute name="class">
                    <xsl:value-of select="concat('t', $level, '4')" />
                  </xsl:attribute>
                  <xsl:if test="generate-id() = generate-id(key('kL4', concat(@L1,'+', @L2, '+', @L3, '+', @L4))[1])">
                    <xsl:value-of select="@L4" />
                  </xsl:if>
                  <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                </td>
                <td class="topline">
                  <xsl:call-template name="biostatus">
                    <xsl:with-param name="pOcc" select="@Occurrence" />
                    <xsl:with-param name="pOrig" select="@Origin" />
                  </xsl:call-template>
                  <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                </td>
                <td class="topline">
                  <xsl:value-of select="@Occurrence" />
                  <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                </td>
                <td class="topline">
                  <xsl:value-of select="@Origin" />
                  <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                </td>
                <td class="topline">
                  <xsl:for-each select=".//Provider">
                    <xsl:sort select="." />
                    <xsl:if test="generate-id(.) = generate-id(key('kProv', .)[1])">
                      <xsl:if test="position()!=1">, </xsl:if>
                      <xsl:value-of select="." />
                    </xsl:if>
                  </xsl:for-each>
                  <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                </td>
              </tr>
            </xsl:for-each>
          </tbody>
        </table>
      </body>
    </html>
  </xsl:template>
  <xsl:template name="biostatus">
    <xsl:param name="pOcc" />
    <xsl:param name="pOrig" />
    <xsl:choose>
      <xsl:when test="$pOrig='Indigenous'">
        <xsl:choose>
          <xsl:when test="$pOcc='Present'">Indigenous</xsl:when>
          <xsl:otherwise>
            Origin:  <xsl:value-of select="$pOrig" /> Occurence: <xsl:value-of select="$pOcc" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$pOrig='Endemic'">
        <xsl:choose>
          <xsl:when test="$pOcc='Present'">Endemic</xsl:when>
          <xsl:otherwise>
            Origin:  <xsl:value-of select="$pOrig" /> Occurence: <xsl:value-of select="$pOcc" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$pOrig='Non-endemic'">
        <xsl:choose>
          <xsl:when test="$pOcc='Present'">Non-endemic</xsl:when>
          <xsl:when test="$pOcc='Sometimes present'">?Vagrant</xsl:when>
          <xsl:otherwise>
            Origin:  <xsl:value-of select="$pOrig" /> Occurence: <xsl:value-of select="$pOcc" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$pOrig='Exotic'">
        <xsl:choose>
          <xsl:when test="$pOcc='Present'">Exotic</xsl:when>
          <xsl:when test="$pOcc='Sometimes present'">Casual</xsl:when>
          <xsl:otherwise>
            Origin:  <xsl:value-of select="$pOrig" /> Occurence: <xsl:value-of select="$pOcc" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$pOrig=''">
        <xsl:choose>
          <xsl:when test="$pOcc='Absent'">Absent</xsl:when>
          <xsl:when test="$pOcc='Present'">Present</xsl:when>
          <xsl:otherwise>
            Origin:  <xsl:value-of select="$pOrig" /> Occurence: <xsl:value-of select="$pOcc" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        Origin:  <xsl:value-of select="$pOrig" /> Occurence: <xsl:value-of select="$pOcc" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
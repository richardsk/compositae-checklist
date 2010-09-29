<?xml version="1.0" encoding="UTF-8"?>
<?altova_samplexml SouthernCone_Sample.xml?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<Distributions>
			<xsl:variable name="vBiostatus">
				<xsl:call-template name="conBiostatus">
					<xsl:with-param name="pProv">
						<xsl:value-of select="normalize-space(substring-after(., '.'))"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:variable>
			<xsl:call-template name="parse">
				<xsl:with-param name="pText" select="translate(substring-before(., '.'), '()', ',')"/>
				<xsl:with-param name="pBiostatus" select="$vBiostatus"/>
			</xsl:call-template>
		</Distributions>
	</xsl:template>
	
	<xsl:template name="parse">
		<xsl:param name="pText"/>
		<xsl:param name="pBiostatus"/>
		<xsl:choose>
			<xsl:when test="contains($pText, ',')">
				<xsl:call-template name="writeValue">
					<xsl:with-param name="pRegion" select="substring-before($pText, ',')"/>
					<xsl:with-param name="pBiostatus" select="$pBiostatus"/>
				</xsl:call-template>
				<xsl:call-template name="parse">
					<xsl:with-param name="pText" select="substring-after($pText, ',')"/>
					<xsl:with-param name="pBiostatus" select="$pBiostatus"/>
				</xsl:call-template>
			</xsl:when>
			<!--do we need an otherwise here?-->
			<xsl:otherwise>
				<xsl:call-template name="writeValue">
					<xsl:with-param name="pRegion" select="$pText"/>
					<xsl:with-param name="pBiostatus" select="$pBiostatus"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="writeValue">
		<xsl:param name="pRegion"/>
		<xsl:param name="pBiostatus"/>
		<xsl:if test="$pRegion!=''">
			<xsl:variable name="vRegion">
				<xsl:call-template name="conRegion">
					<xsl:with-param name="pProv" select="normalize-space($pRegion)"/>
				</xsl:call-template>
			</xsl:variable>
			<Distribution>
				<xsl:attribute name="schema"><xsl:value-of select="substring-before($vRegion,';')"/></xsl:attribute>
				<xsl:attribute name="region">	<xsl:value-of select="substring-after($vRegion,';')"/></xsl:attribute>
				<xsl:attribute name="occurrence"><xsl:value-of select="substring-before($pBiostatus, ';')"/></xsl:attribute>
				<xsl:attribute name="origin"><xsl:value-of select="substring-after($pBiostatus, ';')"/></xsl:attribute>
				<!--<xsl:attribute name="isOriginal">true</xsl:attribute>-->
			</Distribution>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="conBiostatus">
		<xsl:param name="pProv"/>
		<xsl:choose>
			<xsl:when test="$pProv='Present.'">Present;</xsl:when>
			<xsl:when test="$pProv='Endemic.'">Present;Endemic</xsl:when>
			<xsl:when test="$pProv='Exotic.'">Present;Exotic</xsl:when>
			<xsl:when test="$pProv='Cultivated.'">Present;Cultivated</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="conRegion">
		<xsl:param name="pProv"/>
		<xsl:choose>
			<xsl:when test="$pProv='Afghanistan'">ISO Countries;Afghanistan</xsl:when>
			<xsl:when test="$pProv='Africa'">ISO Countries;Africa</xsl:when>
			<xsl:when test="$pProv='Albania'">ISO Countries;Albania</xsl:when>
			<xsl:when test="$pProv='Algeria'">ISO Countries;Algeria</xsl:when>
			<xsl:when test="$pProv='Angola'">ISO Countries;Angola</xsl:when>
			<xsl:when test="$pProv='Antigua'">ISO Countries;Antigua</xsl:when>
			<xsl:when test="$pProv='Antigua and Barbuda'">ISO Countries;Antigua and Barbuda</xsl:when>
			<xsl:when test="$pProv='Argentina'">ISO Countries;Argentina</xsl:when>
			<xsl:when test="$pProv='Armenia'">ISO Countries;Armenia</xsl:when>
			<xsl:when test="$pProv='Australia'">ISO Countries;Australia</xsl:when>
			<xsl:when test="$pProv='Austria'">ISO Countries;Austria</xsl:when>
			<xsl:when test="$pProv='Azerbaijan'">ISO Countries;Azerbaijan</xsl:when>
			<xsl:when test="$pProv='Bahamas'">ISO Countries;Bahamas</xsl:when>
			<xsl:when test="$pProv='Bangladesh'">ISO Countries;Bangladesh</xsl:when>
			<xsl:when test="$pProv='Barbados'">ISO Countries;Barbados</xsl:when>
			<xsl:when test="$pProv='Barbuda'">ISO Countries;Barbuda</xsl:when>
			<xsl:when test="$pProv='Belarus'">ISO Countries;Belarus</xsl:when>
			<xsl:when test="$pProv='Belgium'">ISO Countries;Belgium</xsl:when>
			<xsl:when test="$pProv='Belize'">ISO Countries;Belize</xsl:when>
			<xsl:when test="$pProv='Benin'">ISO Countries;Benin</xsl:when>
			<xsl:when test="$pProv='Bhutan'">ISO Countries;Bhutan</xsl:when>
			<xsl:when test="$pProv='Bolivia'">ISO Countries;Bolivia</xsl:when>
			<xsl:when test="$pProv='Bolivia'">ISO Countries;Bolivia</xsl:when>
			<xsl:when test="$pProv='Botswana'">ISO Countries;Botswana</xsl:when>
			<xsl:when test="$pProv='Brazil'">ISO Countries;Brazil</xsl:when>
			<xsl:when test="$pProv='Bulgaria'">ISO Countries;Bulgaria</xsl:when>
			<xsl:when test="$pProv='Burundi'">ISO Countries;Burundi</xsl:when>
			<xsl:when test="$pProv='Cambodia'">ISO Countries;Cambodia</xsl:when>
			<xsl:when test="$pProv='Cameroon'">ISO Countries;Cameroon</xsl:when>
			<xsl:when test="$pProv='Canada'">ISO Countries;Canada</xsl:when>
			<xsl:when test="$pProv='Canary Islands'">ISO Countries;Canary Islands</xsl:when>
			<xsl:when test="$pProv='Cape Verde'">ISO Countries;Cape Verde</xsl:when>
			<xsl:when test="$pProv='Caribbean'">ISO Countries;Caribbean</xsl:when>
			<xsl:when test="$pProv='Caribbean Islands'">ISO Countries;Caribbean Islands</xsl:when>
			<xsl:when test="$pProv='Cayman Islands'">ISO Countries;Cayman Islands</xsl:when>
			<xsl:when test="$pProv='Central African Republic'">ISO Countries;Central African Republic</xsl:when>
			<xsl:when test="$pProv='Chad'">ISO Countries;Chad</xsl:when>
			<xsl:when test="$pProv='Chile'">ISO Countries;Chile</xsl:when>
			<xsl:when test="$pProv='China'">ISO Countries;China</xsl:when>
			<xsl:when test="$pProv='Colombia'">ISO Countries;Colombia</xsl:when>
			<xsl:when test="$pProv='Congo'">ISO Countries;Congo</xsl:when>
			<xsl:when test="$pProv='Cook Islands'">ISO Countries;Cook Islands</xsl:when>
			<xsl:when test="$pProv='Costa Rica'">ISO Countries;Costa Rica</xsl:when>
			<xsl:when test="$pProv='Ivory Coast'">ISO Countries;Cote D'Ivoire</xsl:when>
			<xsl:when test="$pProv='Cuba'">ISO Countries;Cuba</xsl:when>
			<xsl:when test="$pProv='Cyprus'">ISO Countries;Cyprus</xsl:when>
			<xsl:when test="$pProv='Czech Republic'">ISO Countries;Czech Republic</xsl:when>
			<xsl:when test="$pProv='Czechoslovakia'">ISO Countries;Czechoslovakia</xsl:when>
			<xsl:when test="$pProv='Denmark'">ISO Countries;Denmark</xsl:when>
			<xsl:when test="$pProv='Dominica'">ISO Countries;Dominica</xsl:when>
			<xsl:when test="$pProv='Dominican Republic'">ISO Countries;Dominican Republic</xsl:when>
			<xsl:when test="$pProv='Ecuador'">ISO Countries;Ecuador</xsl:when>
			<xsl:when test="$pProv='Egypt'">ISO Countries;Egypt</xsl:when>
			<xsl:when test="$pProv='El Salvador'">ISO Countries;El Salvador</xsl:when>
			<xsl:when test="$pProv='England'">ISO Countries;England</xsl:when>
			<xsl:when test="$pProv='Equatorial Guinea'">ISO Countries;Equatorial Guinea</xsl:when>
			<xsl:when test="$pProv='Estonia'">ISO Countries;Estonia</xsl:when>
			<xsl:when test="$pProv='Ethiopia'">ISO Countries;Ethiopia</xsl:when>
			<xsl:when test="$pProv='Europe'">ISO Countries;Europe</xsl:when>
			<xsl:when test="$pProv='Faroe Islands'">ISO Countries;Faroe Islands</xsl:when>
			<xsl:when test="$pProv='Fiji'">ISO Countries;Fiji</xsl:when>
			<xsl:when test="$pProv='Fiji Islands'">ISO Countries;Fiji Islands</xsl:when>
			<xsl:when test="$pProv='Finland'">ISO Countries;Finland</xsl:when>
			<xsl:when test="$pProv='Former Yugoslavia'">ISO Countries;Former Yugoslavia</xsl:when>
			<xsl:when test="$pProv='France'">ISO Countries;France</xsl:when>
			<xsl:when test="$pProv='French Guiana'">ISO Countries;French Guiana</xsl:when>
			<xsl:when test="$pProv='Gabon'">ISO Countries;Gabon</xsl:when>
			<xsl:when test="$pProv='Gambia'">ISO Countries;Gambia</xsl:when>
			<xsl:when test="$pProv='Georgia'">ISO Countries;Georgia</xsl:when>
			<xsl:when test="$pProv='Germany'">ISO Countries;Germany</xsl:when>
			<xsl:when test="$pProv='Ghana'">ISO Countries;Ghana</xsl:when>
			<xsl:when test="$pProv='Greece'">ISO Countries;Greece</xsl:when>
			<xsl:when test="$pProv='Grenada'">ISO Countries;Grenada</xsl:when>
			<xsl:when test="$pProv='Guadeloupe'">ISO Countries;Guadeloupe</xsl:when>
			<xsl:when test="$pProv='Guatemala'">ISO Countries;Guatemala</xsl:when>
			<xsl:when test="$pProv='Guinea'">ISO Countries;Guinea</xsl:when>
			<xsl:when test="$pProv='Guinea-Bissau'">ISO Countries;Guinea-Bissau</xsl:when>
			<xsl:when test="$pProv='Guyana'">ISO Countries;Guyana</xsl:when>
			<xsl:when test="$pProv='Haiti'">ISO Countries;Haiti</xsl:when>
			<xsl:when test="$pProv='Hawaii'">ISO Countries;Hawaii</xsl:when>
			<xsl:when test="$pProv='Hawaii Islands'">ISO Countries;Hawaii Islands</xsl:when>
			<xsl:when test="$pProv='Honduras'">ISO Countries;Honduras</xsl:when>
			<xsl:when test="$pProv='Hongkong'">ISO Countries;Hongkong</xsl:when>
			<xsl:when test="$pProv='Hungary'">ISO Countries;Hungary</xsl:when>
			<xsl:when test="$pProv='Iceland'">ISO Countries;Iceland</xsl:when>
			<xsl:when test="$pProv='India'">ISO Countries;India</xsl:when>
			<xsl:when test="$pProv='Indonesia'">ISO Countries;Indonesia</xsl:when>
			<xsl:when test="$pProv='Iran'">ISO Countries;Iran</xsl:when>
			<xsl:when test="$pProv='Iraq'">ISO Countries;Iraq</xsl:when>
			<xsl:when test="$pProv='Ireland'">ISO Countries;Ireland</xsl:when>
			<xsl:when test="$pProv='Israel'">ISO Countries;Israel</xsl:when>
			<xsl:when test="$pProv='Italy'">ISO Countries;Italy</xsl:when>
			<xsl:when test="$pProv='Jamaica'">ISO Countries;Jamaica</xsl:when>
			<xsl:when test="$pProv='Japan'">ISO Countries;Japan</xsl:when>
			<xsl:when test="$pProv='Jordan'">ISO Countries;Jordan</xsl:when>
			<xsl:when test="$pProv='Kazakhstan'">ISO Countries;Kazakhstan</xsl:when>
			<xsl:when test="$pProv='Kenya'">ISO Countries;Kenya</xsl:when>
			<xsl:when test="$pProv='Korea'">ISO Countries;Korea</xsl:when>
			<xsl:when test="$pProv='Kurdistan'">ISO Countries;Kurdistan</xsl:when>
			<xsl:when test="$pProv='Kyrgyzstan'">ISO Countries;Kyrgyzstan</xsl:when>
			<xsl:when test="$pProv='Laos'">ISO Countries;Laos</xsl:when>
			<xsl:when test="$pProv='Latvia'">ISO Countries;Latvia</xsl:when>
			<xsl:when test="$pProv='Lebanon'">ISO Countries;Lebanon</xsl:when>
			<xsl:when test="$pProv='Lesotho'">ISO Countries;Lesotho</xsl:when>
			<xsl:when test="$pProv='Liberia'">ISO Countries;Liberia</xsl:when>
			<xsl:when test="$pProv='Libya'">ISO Countries;Libya</xsl:when>
			<xsl:when test="$pProv='Lithuania'">ISO Countries;Lithuania</xsl:when>
			<xsl:when test="$pProv='Madagascar'">ISO Countries;Madagascar</xsl:when>
			<xsl:when test="$pProv='Malawi'">ISO Countries;Malawi</xsl:when>
			<xsl:when test="$pProv='Malaysia'">ISO Countries;Malaysia</xsl:when>
			<xsl:when test="$pProv='Maldives'">ISO Countries;Maldives</xsl:when>
			<xsl:when test="$pProv='Mali'">ISO Countries;Mali</xsl:when>
			<xsl:when test="$pProv='Malta'">ISO Countries;Malta</xsl:when>
			<xsl:when test="$pProv='Marshall Islands'">ISO Countries;Marshall Islands</xsl:when>
			<xsl:when test="$pProv='Martinique'">ISO Countries;Martinique</xsl:when>
			<xsl:when test="$pProv='Mauritania'">ISO Countries;Mauritania</xsl:when>
			<xsl:when test="$pProv='Mauritius'">ISO Countries;Mauritius</xsl:when>
			<xsl:when test="$pProv='Mexico'">ISO Countries;Mexico</xsl:when>
			<xsl:when test="$pProv='Micronesia'">ISO Countries;Micronesia</xsl:when>
			<xsl:when test="$pProv='Moldova'">ISO Countries;Moldova</xsl:when>
			<xsl:when test="$pProv='Mongolia'">ISO Countries;Mongolia</xsl:when>
			<xsl:when test="$pProv='Montserrat'">ISO Countries;Montserrat</xsl:when>
			<xsl:when test="$pProv='Morocco'">ISO Countries;Morocco</xsl:when>
			<xsl:when test="$pProv='Mozambique'">ISO Countries;Mozambique</xsl:when>
			<xsl:when test="$pProv='Myanmar'">ISO Countries;Myanmar</xsl:when>
			<xsl:when test="$pProv='Namibia'">ISO Countries;Namibia</xsl:when>
			<xsl:when test="$pProv='Nepal'">ISO Countries;Nepal</xsl:when>
			<xsl:when test="$pProv='Netherlands'">ISO Countries;Netherlands</xsl:when>
			<xsl:when test="$pProv='New Caledonia'">ISO Countries;New Caledonia</xsl:when>
			<xsl:when test="$pProv='New Zealand'">ISO Countries;New Zealand</xsl:when>
			<xsl:when test="$pProv='Nicaragua'">ISO Countries;Nicaragua</xsl:when>
			<xsl:when test="$pProv='Niger'">ISO Countries;Niger</xsl:when>
			<xsl:when test="$pProv='Nigeria'">ISO Countries;Nigeria</xsl:when>
			<xsl:when test="$pProv='North America'">ISO Countries;North America</xsl:when>
			<xsl:when test="$pProv='Norway'">ISO Countries;Norway</xsl:when>
			<xsl:when test="$pProv='Pacific Island'">ISO Countries;Pacific Island</xsl:when>
			<xsl:when test="$pProv='Pacific Islands'">ISO Countries;Pacific Islands</xsl:when>
			<xsl:when test="$pProv='Pakistan '">ISO Countries;Pakistan </xsl:when>
			<xsl:when test="$pProv='Panama'">ISO Countries;Panama</xsl:when>
			<xsl:when test="$pProv='Papua New Guinea'">ISO Countries;Papua New Guinea</xsl:when>
			<xsl:when test="$pProv='Paraguay'">ISO Countries;Paraguay</xsl:when>
			<xsl:when test="$pProv='Peru'">ISO Countries;Peru</xsl:when>
			<xsl:when test="$pProv='Philippines'">ISO Countries;Philippines</xsl:when>
			<xsl:when test="$pProv='Poland'">ISO Countries;Poland</xsl:when>
			<xsl:when test="$pProv='Polynesia'">ISO Countries;Polynesia</xsl:when>
			<xsl:when test="$pProv='Portugal'">ISO Countries;Portugal</xsl:when>
			<xsl:when test="$pProv='Puerto Rico'">ISO Countries;Puerto Rico</xsl:when>
			<xsl:when test="$pProv='Reunion'">ISO Countries;Reunion</xsl:when>
			<xsl:when test="$pProv='Romania'">ISO Countries;Romania</xsl:when>
			<xsl:when test="$pProv='Rwanda'">ISO Countries;Rwanda</xsl:when>
			<xsl:when test="$pProv='Samoa'">ISO Countries;Samoa</xsl:when>
			<xsl:when test="$pProv='Saudi Arabia'">ISO Countries;Saudi Arabia</xsl:when>
			<xsl:when test="$pProv='Senegal'">ISO Countries;Senegal</xsl:when>
			<xsl:when test="$pProv='Seychelles'">ISO Countries;Seychelles</xsl:when>
			<xsl:when test="$pProv='Sierra Leone'">ISO Countries;Sierra Leone</xsl:when>
			<xsl:when test="$pProv='Singapore'">ISO Countries;Singapore</xsl:when>
			<xsl:when test="$pProv='Slovakia'">ISO Countries;Slovakia</xsl:when>
			<xsl:when test="$pProv='Solomon Islands'">ISO Countries;Solomon Islands</xsl:when>
			<xsl:when test="$pProv='Somalia'">ISO Countries;Somalia</xsl:when>
			<xsl:when test="$pProv='South Africa'">ISO Countries;South Africa</xsl:when>
			<xsl:when test="$pProv='South America'">ISO Countries;South America</xsl:when>
			<xsl:when test="$pProv='Spain'">ISO Countries;Spain</xsl:when>
			<xsl:when test="$pProv='Sri Lanka'">ISO Countries;Sri Lanka</xsl:when>
			<xsl:when test="$pProv='St. Kitts and Nevis'">ISO Countries;St. Kitts and Nevis</xsl:when>
			<xsl:when test="$pProv='St. Lucia'">ISO Countries;St. Lucia</xsl:when>
			<xsl:when test="$pProv='St. Vincent'">ISO Countries;St. Vincent</xsl:when>
			<xsl:when test="$pProv='St. Vincent and Grenadines'">ISO Countries;St. Vincent and Grenadines</xsl:when>
			<xsl:when test="$pProv='Sudan'">ISO Countries;Sudan</xsl:when>
			<xsl:when test="$pProv='Suriname'">ISO Countries;Suriname</xsl:when>
			<xsl:when test="$pProv='Swaziland'">ISO Countries;Swaziland</xsl:when>
			<xsl:when test="$pProv='Sweden'">ISO Countries;Sweden</xsl:when>
			<xsl:when test="$pProv='Switzerland'">ISO Countries;Switzerland</xsl:when>
			<xsl:when test="$pProv='Syria'">ISO Countries;Syria</xsl:when>
			<xsl:when test="$pProv='Tadzhikistan'">ISO Countries;Tadzhikistan</xsl:when>
			<xsl:when test="$pProv='Taiwan '">ISO Countries;Taiwan </xsl:when>
			<xsl:when test="$pProv='Tajikistan'">ISO Countries;Tajikistan</xsl:when>
			<xsl:when test="$pProv='Tanzania'">ISO Countries;Tanzania</xsl:when>
			<xsl:when test="$pProv='Thailand'">ISO Countries;Thailand</xsl:when>
			<xsl:when test="$pProv='Tibet'">ISO Countries;Tibet</xsl:when>
			<xsl:when test="$pProv='Togo'">ISO Countries;Togo</xsl:when>
			<xsl:when test="$pProv='Trinidad and Tobago'">ISO Countries;Trinidad and Tobago</xsl:when>
			<xsl:when test="$pProv='Tunisia'">ISO Countries;Tunisia</xsl:when>
			<xsl:when test="$pProv='Turkestan'">ISO Countries;Turkestan</xsl:when>
			<xsl:when test="$pProv='Turkey'">ISO Countries;Turkey</xsl:when>
			<xsl:when test="$pProv='Turkistan'">ISO Countries;Turkistan</xsl:when>
			<xsl:when test="$pProv='Turkmenistan'">ISO Countries;Turkmenistan</xsl:when>
			<xsl:when test="$pProv='Uganda'">ISO Countries;Uganda</xsl:when>
			<xsl:when test="$pProv='Ukraine'">ISO Countries;Ukraine</xsl:when>
			<xsl:when test="$pProv='United Kingdom'">ISO Countries;United Kingdom</xsl:when>
			<xsl:when test="$pProv='United States of America'">ISO Countries;United States of America</xsl:when>
			<xsl:when test="$pProv='Uruguay'">ISO Countries;Uruguay</xsl:when>
			<xsl:when test="$pProv='Uzbekistan'">ISO Countries;Uzbekistan</xsl:when>
			<xsl:when test="$pProv='Venezuela'">ISO Countries;Venezuela</xsl:when>
			<xsl:when test="$pProv='Vietnam'">ISO Countries;Vietnam</xsl:when>
			<xsl:when test="$pProv='Virgin Islands'">ISO Countries;Virgin Islands</xsl:when>
			<xsl:when test="$pProv='West Indies'">ISO Countries;West Indies</xsl:when>
			<xsl:when test="$pProv='Yemen'">ISO Countries;Yemen</xsl:when>
			<xsl:when test="$pProv='Yugoslavia'">ISO Countries;Yugoslavia</xsl:when>
			<xsl:when test="$pProv='Zaire'">ISO Countries;Zaire</xsl:when>
			<xsl:when test="$pProv='Zambia'">ISO Countries;Zambia</xsl:when>
			<xsl:when test="$pProv='Zimbabwe'">ISO Countries;Zimbabwe</xsl:when>
			<xsl:when test="$pProv='Andaman'">ISO Countries;Andaman</xsl:when>
			<xsl:when test="$pProv='Andaman'">Indian Union Territories;Andaman</xsl:when>
			<xsl:when test="$pProv='Andhra Pradesh'">Indian States;Andhra Pradesh</xsl:when>
			<xsl:when test="$pProv='Arunachal Pradesh'">Indian States;Arunachal Pradesh</xsl:when>
			<xsl:when test="$pProv='Assam'">Indian States;Assam</xsl:when>
			<xsl:when test="$pProv='Bihar'">Indian States;Bihar</xsl:when>
			<xsl:when test="$pProv='Chhatisgarh'">Indian States;Chhatisgarh</xsl:when>
			<xsl:when test="$pProv='Delhi'">Indian Union Territories;Delhi</xsl:when>
			<xsl:when test="$pProv='Goa'">Indian States;Goa</xsl:when>
			<xsl:when test="$pProv='Gujarat'">Indian States;Gujarat</xsl:when>
			<xsl:when test="$pProv='Haryana'">Indian States;Haryana</xsl:when>
			<xsl:when test="$pProv='Himachal Pradesh'">Indian States;Himachal Pradesh</xsl:when>
			<xsl:when test="$pProv='Jammu and Kashmir'">Indian States;Jammu and Kashmir</xsl:when>
			<xsl:when test="$pProv='Jharkhand'">Indian States;Jharkhand</xsl:when>
			<xsl:when test="$pProv='Karnataka'">Indian States;Karnataka</xsl:when>
			<xsl:when test="$pProv='Kerala'">Indian States;Kerala</xsl:when>
			<xsl:when test="$pProv='Madhya Pradesh'">Indian States;Madhya Pradesh</xsl:when>
			<xsl:when test="$pProv='Maharashtra'">Indian States;Maharashtra</xsl:when>
			<xsl:when test="$pProv='Manipur'">Indian States;Manipur</xsl:when>
			<xsl:when test="$pProv='Meghalaya'">Indian States;Meghalaya</xsl:when>
			<xsl:when test="$pProv='Mizoram'">Indian States;Mizoram</xsl:when>
			<xsl:when test="$pProv='Nagaland'">Indian States;Nagaland</xsl:when>
			<xsl:when test="$pProv='Orissa'">Indian States;Orissa</xsl:when>
			<xsl:when test="$pProv='Punjab'">Indian States;Punjab</xsl:when>
			<xsl:when test="$pProv='Rajasthan'">Indian States;Rajasthan</xsl:when>
			<xsl:when test="$pProv='Sikkim'">Indian States;Sikkim</xsl:when>
			<xsl:when test="$pProv='Tamil Nadu'">Indian States;Tamil Nadu</xsl:when>
			<xsl:when test="$pProv='Tripura'">Indian States;Tripura</xsl:when>
			<xsl:when test="$pProv='Uttar Pradesh'">Indian States;Uttar Pradesh</xsl:when>
			<xsl:when test="$pProv='Uttarakhand'">Indian States;Uttarakhand</xsl:when>
			<xsl:when test="$pProv='West Bengal'">Indian States;West Bengal</xsl:when>
			<xsl:when test="$pProv='Dadra and Nagar Haveli'">Indian States;Dadra and Nagar Haveli</xsl:when>
			<xsl:when test="$pProv='Daman'">Indian States;Daman</xsl:when>
			<xsl:when test="$pProv='Diu'">Indian States;Diu</xsl:when>
			<xsl:when test="$pProv='Nicobar'">Indian Union Territories;Nicobar</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	
</xsl:stylesheet>

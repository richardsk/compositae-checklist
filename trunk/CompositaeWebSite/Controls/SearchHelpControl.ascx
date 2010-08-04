<%@ Control Language="VB" AutoEventWireup="false" CodeFile="SearchHelpControl.ascx.vb" Inherits="Controls_SearchHelpControl" %>
<table id="Table1" align="left" border="0" cellpadding="10" cellspacing="0" height="100%"
    width="100%">
    <tr>
        <td align="left" height="17" valign="top">
            <p>
                <table id="Table2" align="left" border="0" cellpadding="1" cellspacing="1" 
                    width="600">
                    <tr>
                        <td>
                            
                            <span class="PageHeading" style="font-size: 17pt">&nbsp;Search Help</span></td>
                        
                    </tr>
                    <tr >
                        <td align="left" height="100%" valign="top">
                        <br />
                            <h3>Name Search Help</h3>

                            <p>The <b>simple</b> search returns records that contain the search text anywhere within the full Scientific Name</p>

                            <b>Simple search tips</b>
                            <p>The search results show the scientific name for a taxon at any rank, including the authors of the names.</p>

                            <p>For example<br />
                            “austral” will find names containing “austral” anywhere in the text e.g., australis and australe<br />
                            “raoulia hoo” will find names containing “raoulia” and “hoo” e.g., Raoulia hookeri Allan or Raoulia australis Hook.f.</p>

                            <p>Simple search can include 'and', 'or' and 'not' statements, although the 'and' search function is performed by default when more than one word is entered in the search field.</p>

                            <p>For example "raoulia and y" will find names containing both "raoulia" and "y" e.g. Raoulia goyenii Kirk.<br />
                            "raoulia or australis" will return all terms that contain either "raoulia" or "australis" or both e.g. Bidens australis Spreng. and Raoulia australis Hook.f.<br />
                            "raoulia not australis" will return all names containing "raoulia" but not containing "australis" e.g. Raoulia monroi Hook.f. but not Raoulia australis Hook.f.<br />
                            "raoulia and (h or cin) not hook" will return names containing "raoulia" and any names or authors containing "h" or "cin", but not containing "hook" e.g. Raoulia cinerea Petrie and Raoulia hectorii var. mollis Buchanan, but not Raoulia australis Hook.f.<br /></p>

                            <p><b>Advanced Search</b></p>
                            <p>Advanced search offers numerous options for making searches more precise and getting more useful results. Advanced search can include 'and', 'or' and 'not' statements as described above, and applied to individual field names:</p>
                            <p><b>Full Name:</b> This field contains the scientific name for a taxon at any rank, including the authors of the names, e.g. "<i>Bidens fervida</i>  Lam."</p>

                            <p><b>Canonical:</b> 
                            This is the terminal ‘element’ of the name, excluding the authors. e.g. "fervida".<br />
                            The term "canonical" is borrowed from algebra in order to indicate a defined component which is part of a logically constructed whole. Unfortunately, in botanical nomenclature, there is no single word for this entity.</p>

                            <p><b>Authors:</b> The author(s) of the name cited in standard form as listed by Brummitt and Powell (1992: Authors of Plant Names. Royal Botanic Gardens, Kew.) and the International Plant Names Index).</p>

                            <p><b>Rank:</b> This field contains the rank for each taxonomic name listed in the database. This field can be used to find all the names at a given rank, for example by searching for "family" all family names will be returned. The values in this field are one of the following ranks: Kingdom, Phylum, Division, Class, Order, Family, Genus, species, subspecies (subsp.), variety (var.), form (f.), cultivar (cv.).</p>
                            <p>The abbreviations in the brackets above should be used to search for ranks below species.</p>

                            <p><b>Preferred name:</b> This field contains the accepted name.</p>

                            <p><b>Parent name:</b> This field allows a search for all of the children of a parent.</p>

                            <p><b>Year:</b> This field contains the year the name was published.</p>

                            <p><b>LSID:</b> This field contains the LSID (Life Science IDentifier).</p>

                            <p>By checking the <b>and</b> or <b>or</b> boxes more search criteria can be added.</p>


                            <h3>Literature Search Help</h3>

                            <p>The literature search function displays all available publications that feature the search criteria in any field. Click on any of the results to bring up the details of that publication.</p>

                            <p>The advanced search function allows more precise results by selecting which fields to search in, namely <b>Title, Author, Date, Publisher, Journal, Abbreviation, Start Page, End Page</b> and <b>ID</b>.</p>


                        </td>
                    </tr>
                </table>
            
        </td>
    </tr>
</table>

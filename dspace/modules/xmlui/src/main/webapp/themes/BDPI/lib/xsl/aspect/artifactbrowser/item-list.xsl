<!--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

-->
<!--
    Rendering of a list of items (e.g. in a search or
    browse results page)

    Author: art.lowel at atmire.com
    Author: lieven.droogmans at atmire.com
    Author: ben at atmire.com
    Author: Alexey Maslov

-->

<xsl:stylesheet
    xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
    xmlns:dri="http://di.tamu.edu/DRI/1.0/"
    xmlns:mets="http://www.loc.gov/METS/"
    xmlns:dim="http://www.dspace.org/xmlns/dspace/dim"
    xmlns:xlink="http://www.w3.org/TR/xlink/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:atom="http://www.w3.org/2005/Atom"
    xmlns:ore="http://www.openarchives.org/ore/terms/"
    xmlns:oreatom="http://www.openarchives.org/ore/atom/"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xalan="http://xml.apache.org/xalan"
    xmlns:encoder="xalan://java.net.URLEncoder"
    xmlns:util="org.dspace.app.xmlui.utils.XSLUtils"
    xmlns:confman="org.dspace.core.ConfigurationManager"
	xmlns:utilUSP="org.dspace.app.xmlui.utils.USPXSLUtils"	
    exclude-result-prefixes="xalan encoder i18n dri mets dim xlink xsl util confman">

    <xsl:output indent="yes"/>

    <!--these templates are modfied to support the 2 different item list views that
    can be configured with the property 'xmlui.theme.mirage.item-list.emphasis' in dspace.cfg-->

    <xsl:template name="itemSummaryList-DIM">
        <xsl:variable name="itemWithdrawn" select="./mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']/mets:xmlData/dim:dim/@withdrawn" />

        <xsl:variable name="href">
            <xsl:choose>
                <xsl:when test="$itemWithdrawn">
                    <xsl:value-of select="@OBJEDIT"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@OBJID"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="emphasis" select="confman:getProperty('xmlui.theme.mirage.item-list.emphasis')"/>
        <xsl:choose>
            <xsl:when test="'file' = $emphasis">


                <div class="item-wrapper clearfix">
                    <xsl:apply-templates select="./mets:fileSec" mode="artifact-preview"><xsl:with-param name="href" select="$href"/></xsl:apply-templates>
                    <xsl:apply-templates select="./mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']/mets:xmlData/dim:dim"
                                         mode="itemSummaryList-DIM-file"><xsl:with-param name="href" select="$href"/></xsl:apply-templates>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="./mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']/mets:xmlData/dim:dim"
                                     mode="itemSummaryList-DIM-metadata"><xsl:with-param name="href" select="$href"/></xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--handles the rendering of a single item in a list in file mode-->
    <xsl:template match="dim:dim" mode="itemSummaryList-DIM-file">
        <xsl:param name="href"/>
        <xsl:variable name="metadataWidth" select="675 - $thumbnail.maxwidth - 30"/>
        <div class="item-metadata" style="width: {$metadataWidth}px;">
            <span class="bold"><i18n:text>xmlui.dri2xhtml.pioneer.title</i18n:text><xsl:text>:</xsl:text></span>
            <span class="content" style="width: {$metadataWidth - 110}px;">
                <xsl:element name="a">
                    <xsl:attribute name="href">
                        <xsl:value-of select="$href"/>
                    </xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="dim:field[@element='title']">
                            <xsl:value-of select="dim:field[@element='title'][1]/node()"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
            </span>
            <span class="Z3988">
                <xsl:attribute name="title">
                    <xsl:call-template name="renderCOinS"/>
                </xsl:attribute>
                &#xFEFF; <!-- non-breaking space to force separating the end tag -->
            </span>
            <span class="bold"><i18n:text>xmlui.dri2xhtml.pioneer.author</i18n:text><xsl:text>:</xsl:text></span>
            <span class="content" style="width: {$metadataWidth - 110}px;">
                <xsl:choose>
                    <xsl:when test="dim:field[@element='contributor'][@qualifier='author']">
                        <xsl:for-each select="dim:field[@element='contributor'][@qualifier='author']">
                            <span>
                                <xsl:if test="@authority">
                                    <xsl:attribute name="class">
                                        <xsl:text>ds-dc_contributor_author-authority</xsl:text>
                                    </xsl:attribute>
                                </xsl:if>
                                <xsl:copy-of select="node()"/>
                            </span>
                            <xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='author']) != 0">
                                <xsl:text>; </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="dim:field[@element='creator']">
                        <xsl:for-each select="dim:field[@element='creator']">
                            <xsl:copy-of select="node()"/>
                            <xsl:if test="count(following-sibling::dim:field[@element='creator']) != 0">
                                <xsl:text>; </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="dim:field[@element='contributor']">
                        <xsl:for-each select="dim:field[@element='contributor']">
                            <xsl:copy-of select="node()"/>
                            <xsl:if test="count(following-sibling::dim:field[@element='contributor']) != 0">
                                <xsl:text>; </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <i18n:text>xmlui.dri2xhtml.METS-1.0.no-author</i18n:text>
                    </xsl:otherwise>
                </xsl:choose>
            </span>
            <xsl:if test="dim:field[@element='date' and @qualifier='issued'] or dim:field[@element='publisher']">
                <span class="bold"><i18n:text>xmlui.dri2xhtml.pioneer.date</i18n:text><xsl:text>:</xsl:text></span>
                <span class="content" style="width: {$metadataWidth - 110}px;">
                    <xsl:value-of
                            select="substring(dim:field[@element='date' and @qualifier='issued']/node(),1,10)"/>
                </span>
            </xsl:if>
        </div>
    </xsl:template>
	
	<xsl:variable name="urlAtual" select="dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='URI']"/>

    <!--handles the rendering of a single item in a list in metadata mode-->
    <xsl:template match="dim:dim" mode="itemSummaryList-DIM-metadata">
		<xsl:param name="href"/>
		<xsl:variable name="lowerCase" select="'abcdefghijklmnopqrstuvwxyzçáéíóúýàèìòùãõñäëïöüÿâêîôûÁÉÍÓÚÝÀÈÌÒÙÄËÏÖÜÃÕÑÂÊÎÔÛ'"/> 
		<xsl:variable name="upperCase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZÇAEIOUYAEIOUAONAEIOUYAEIOUAEIOUYAEIOUAEIOUAONAEIOU'"/>        
        <div class="artifact-description">
            <div class="artifact-title">
                <xsl:element name="a">
                    <xsl:attribute name="href">
                        <xsl:value-of select="$href"/>
                    </xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="dim:field[@element='title']">
                            <xsl:value-of select="dim:field[@element='title'][1]/node()"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
                <span class="Z3988">
                    <xsl:attribute name="title">
                        <xsl:call-template name="renderCOinS"/>
                    </xsl:attribute>
                    &#xFEFF; <!-- non-breaking space to force separating the end tag -->
                </span>
            </div>
            <div class="artifact-info">
                <span class="author">
				
<!-- ========================================================================================== -->
<!-- 130726 - Implementar link no icone USP para a pagina CV referente ao Autor USP selecionado --> 
<!-- @author Dan Shinkai (SI/EACH/USP) -->
<!-- ========================================================================================== -->

				    <xsl:variable name="verificaLink" select="utilUSP:contemHandleURL($urlAtual)" />					
                    <xsl:choose>
                        <xsl:when test="dim:field[@element='contributor'][@qualifier='author']">
								
							<xsl:for-each select="dim:field[@element='contributor'][@qualifier='author']">
								<span>
								  <xsl:if test="@authority">
									<xsl:attribute name="class"><xsl:text>ds-dc_contributor_author-authority</xsl:text></xsl:attribute>
								  </xsl:if>
								  <xsl:copy-of select="node()"/>
								</span>
								
								<xsl:choose>
								
<!-- 130725 - Dan - Condicao que verifica se o no atual possui o metadado authority. O link e criado a partir do valor do authority. -->
									<xsl:when test="@authority">									
										<xsl:text> </xsl:text>

<!-- 130725 - Dan - Codigo para recuperar somente o codpes do autor --> 
										<xsl:variable name="codpes">
											<xsl:value-of select="./@authority"/>
										</xsl:variable>
										
										<xsl:variable name="verificaAuthor" select="utilUSP:verificaAuthorUSP($codpes)"/>

<!-- 130419 - Dan - Codigo para recuperar somente o itemID --> 
										<xsl:for-each select="../dim:field[@element='identifier'][@mdschema='dc'][@qualifier='uri']">
											 <xsl:variable name="url" select="current()"/>
											 <xsl:variable name="urlSub" select="substring-after($url,'handle/')"/>

											 <xsl:if test="$urlSub!=''">
												<xsl:variable name="itemID" select="substring-after($urlSub,'/')"/> 
<!-- 130419 - Dan - Codigo que insere o itemID e o codpes na URL. E necessario realizar a verificacao da url atual para a construcao do link, pois podera haver duplicacao no link --> 
												<xsl:choose>
													<xsl:when test="$verificaAuthor!=''">
														<a href="{$verificaAuthor}" target="_self" class="removeLinkUSP">												
															<img alt="Icon" src="{concat($theme-path, '/images/ehUSP.png')}"/>
														</a>
													</xsl:when>
													<xsl:otherwise>
														<xsl:choose>
			 
														   <xsl:when test="$verificaLink = 0"> 
															  <a href="handle/{$urlSub}/{$codpes}/author" target="_self" class="removeLinkUSP"> 
																 <img alt="Icon" src="{concat($theme-path, '/images/ehUSP.png')}"/> 
															  </a>
			 
														   </xsl:when> 
													
														   <xsl:when test="$verificaLink = 2"> 
															  <a href="{$codpes}/author" target="_self" class="removeLinkUSP"> 
																  <img alt="Icon" src="{concat($theme-path, '/images/ehUSP.png')}"/> 
															  </a>
			 
														   </xsl:when> 
													
														   <xsl:otherwise> 
															  <a href="{$itemID}/{$codpes}/author" target="_self" class="removeLinkUSP"> 
																  <img alt="Icon" src=" {concat($theme-path, '/images/ehUSP.png')}"/> 
															  </a>
			 
														   </xsl:otherwise> 
														</xsl:choose>
													</xsl:otherwise>
												</xsl:choose>
											 </xsl:if>
									    </xsl:for-each>
									</xsl:when>
									
<!-- 130725 - Dan - Condicao que verifica se o no atual possui o metadado authority. O link e criado a partir do metadado do autor USP. -->
									
									<xsl:otherwise>
										<xsl:variable name="nodeSemAcento" select="utilUSP:retiraEspacos(translate(./node(), $lowerCase, $upperCase))"/> 
										<xsl:for-each select="../dim:field[@mdschema='usp'][@element='autor'][not(@qualifier)]"> 
										   <xsl:variable name="uspAutor" select="substring-before(./node(),':')"/> 
										   <xsl:variable name="uspAutorSemAcento" select="utilUSP:retiraEspacos(translate($uspAutor,$lowerCase,$upperCase))"/> 
										    <xsl:if test="$nodeSemAcento=$uspAutorSemAcento"> 
											  <xsl:text> </xsl:text>

<!-- 130419 - Dan - Codigo para recuperar somente o codpes do autor --> 
											  <xsl:variable name="uspAutorInfo" select="substring-after(./node(),':')"/> 
											  <xsl:variable name="codpes" select="substring-before($uspAutorInfo,':')"/> 
											  <xsl:variable name="verificaAuthor" select="utilUSP:verificaAuthorUSP($codpes)"/>

<!-- 130419 - Dan - Codigo para recuperar somente o itemID --> 
											  <xsl:for-each select="../dim:field[@element='identifier'][@mdschema='dc'][@qualifier='uri']">
												 <xsl:variable name="url" select="current()"/>
												 <xsl:variable name="urlSub" select="substring-after($url,'handle/')"/>

												 <xsl:if test="$urlSub!=''">
													<xsl:variable name="itemID" select="substring-after($urlSub,'/')"/> 
<!-- 130419 - Dan - Codigo que insere o itemID e o codpes na URL. E necessario realizar a verificacao da url atual para a construcao do link, pois podera haver duplicacao no link --> 
													<xsl:choose>
													<xsl:when test="$verificaAuthor!=''">
														<a href="{$verificaAuthor}" target="_self" class="removeLinkUSP">												
															<img alt="Icon" src="{concat($theme-path, '/images/ehUSP.png')}"/>
														</a>
													</xsl:when>
													<xsl:otherwise>
														<xsl:choose>
			 
														   <xsl:when test="$verificaLink = 0"> 
															  <a href="handle/{$urlSub}/{$codpes}/author" target="_self" class="removeLinkUSP"> 
																 <img alt="Icon" src="{concat($theme-path, '/images/ehUSP.png')}"/> 
															  </a>
			 
														   </xsl:when> 
													
														   <xsl:when test="$verificaLink = 2"> 
															  <a href="{$codpes}/author" target="_self" class="removeLinkUSP"> 
																  <img alt="Icon" src="{concat($theme-path, '/images/ehUSP.png')}"/> 
															  </a>
			 
														   </xsl:when> 
													
														   <xsl:otherwise> 
															  <a href="{$itemID}/{$codpes}/author" target="_self" class="removeLinkUSP"> 
																  <img alt="Icon" src=" {concat($theme-path, '/images/ehUSP.png')}"/> 
															  </a>
			 
														   </xsl:otherwise> 
														</xsl:choose>
													</xsl:otherwise>
												</xsl:choose>
												 </xsl:if>
											   </xsl:for-each>
											</xsl:if> 
										</xsl:for-each>
									</xsl:otherwise>
								</xsl:choose>
										
								<xsl:if test="count(following-sibling::dim:field[@element='contributor'][@qualifier='author']) != 0">
									<xsl:text>; </xsl:text>
								</xsl:if>

							</xsl:for-each>
                        </xsl:when>
                        <xsl:when test="dim:field[@element='creator']">
                            <xsl:for-each select="dim:field[@element='creator']">
                                <xsl:copy-of select="node()"/>
                                <xsl:if test="count(following-sibling::dim:field[@element='creator']) != 0">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="dim:field[@element='contributor']">
                            <xsl:for-each select="dim:field[@element='contributor']">
                                <xsl:copy-of select="node()"/>
                                <xsl:if test="count(following-sibling::dim:field[@element='contributor']) != 0">
                                    <xsl:text>; </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <i18n:text>xmlui.dri2xhtml.METS-1.0.no-author</i18n:text>
                        </xsl:otherwise>
                    </xsl:choose>
					
<!-- ====================================================================================================== -->
<!-- / FIM 130726 - Implementar link no icone USP para a pagina CV referente ao Autor USP selecionado FIM / --> 
<!-- ====================================================================================================== -->
                </span>
                <xsl:text> </xsl:text>
                <xsl:if test="dim:field[@element='date' and @qualifier='issued'] or dim:field[@element='publisher']">
	                <span class="publisher-date">
	                    <xsl:text>(</xsl:text>
	                    <xsl:if test="dim:field[@element='publisher']">
	                        <span class="publisher">
<!-- 130328 - imprimir separados cidade e pais
@author Dan Shinkai
do modo como esta, acaba imprimindo cidade e pais, pois temos dc.publisher.local (cidade) e usp.publisher.pais
por isso precisamos modificar para separar cidade e pais
	                            <xsl:copy-of select="dim:field[@element='publisher']/node()"/>
-->
                                <xsl:value-of select="dim:field[@element='publisher']" />
                                <xsl:if test="dim:field[@qualifier='pais']">
                                    <xsl:text>, </xsl:text>
                                    <xsl:value-of select="dim:field[@qualifier='pais']" />
                                </xsl:if>
<!-- FIM 130328 - imprimir separados cidade e pais FIM-->

	                        </span>
	                        <xsl:text>, </xsl:text>
	                    </xsl:if>
	                    <span class="date">
	                        <xsl:value-of select="substring(dim:field[@element='date' and @qualifier='issued']/node(),1,10)"/>
	                    </span>
	                    <xsl:text>)</xsl:text>
	                </span>
                </xsl:if>
            </div>
            <xsl:if test="dim:field[@element = 'description' and @qualifier='abstract']">
                <xsl:variable name="abstract" select="dim:field[@element = 'description' and @qualifier='abstract']/node()"/>
                <div class="artifact-abstract">
                    <xsl:value-of select="util:shortenString($abstract, 220, 10)"/>
                </div>
            </xsl:if>
        </div>
    </xsl:template>

    <xsl:template name="itemDetailList-DIM">
        <xsl:call-template name="itemSummaryList-DIM"/>
    </xsl:template>


    <xsl:template match="mets:fileSec" mode="artifact-preview">
        <xsl:param name="href"/>
        <div class="thumbnail-wrapper">
            <div class="artifact-preview">
                <a class="image-link" href="{$href}">
                    <xsl:choose>
                        <xsl:when test="mets:fileGrp[@USE='THUMBNAIL']">
                            <img alt="Thumbnail">
                                <xsl:attribute name="src">
                                    <xsl:value-of
                                            select="mets:fileGrp[@USE='THUMBNAIL']/mets:file/mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
                                </xsl:attribute>
                            </img>
                        </xsl:when>
                        <xsl:otherwise>
                            <img alt="Icon" src="{concat($theme-path, '/images/mime.png')}" style="height: {$thumbnail.maxheight}px;"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </a>
            </div>
        </div>
    </xsl:template>


</xsl:stylesheet>

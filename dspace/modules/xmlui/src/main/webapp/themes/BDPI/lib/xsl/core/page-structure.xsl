<!--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

-->
<!--
    Main structure of the page, determines where
    header, footer, body, navigation are structurally rendered.
    Rendering of the header, footer, trail and alerts

    Author: art.lowel at atmire.com
    Author: lieven.droogmans at atmire.com
    Author: ben at atmire.com
    Author: Alexey Maslov

-->

<xsl:stylesheet xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
	xmlns:dri="http://di.tamu.edu/DRI/1.0/"
	xmlns:mets="http://www.loc.gov/METS/"
	xmlns:xlink="http://www.w3.org/TR/xlink/"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:dim="http://www.dspace.org/xmlns/dspace/dim"
	xmlns:xhtml="http://www.w3.org/1999/xhtml"
	xmlns:mods="http://www.loc.gov/mods/v3"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:confman="org.dspace.core.ConfigurationManager"
	xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="i18n dri mets xlink xsl dim xhtml mods dc confman">

    <xsl:output indent="yes"/>

    <!--
        Requested Page URI. Some functions may alter behavior of processing depending if URI matches a pattern.
        Specifically, adding a static page will need to override the DRI, to directly add content.
    -->
    <xsl:variable name="request-uri" select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='URI']"/>

<xsl:variable name="context-path" select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>

<!-- 130527 andre.assada@usp.br variavel para pegar o endereco root, para montar paginas estaticas -->
<xsl:variable name="meta" select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='serverName']"/>
<xsl:variable name="porta" select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='serverPort']"/>
<xsl:variable name="paginas" select="concat('http://', $meta, ':', $porta, $context-path, '/static/pages')"/>
<!--FIM 130527 andre.assada@usp.br variavel para pegar o endereco root, para montar paginas estaticas FIM-->

    <!--
        The starting point of any XSL processing is matching the root element. In DRI the root element is document,
        which contains a version attribute and three top level elements: body, options, meta (in that order).

        This template creates the html document, giving it a head and body. A title and the CSS style reference
        are placed in the html head, while the body is further split into several divs. The top-level div
        directly under html body is called "ds-main". It is further subdivided into:
            "ds-header"  - the header div containing title, subtitle, trail and other front matter
            "ds-body"    - the div containing all the content of the page; built from the contents of dri:body
            "ds-options" - the div with all the navigation and actions; built from the contents of dri:options
            "ds-footer"  - optional footer div, containing misc information

        The order in which the top level divisions appear may have some impact on the design of CSS and the
        final appearance of the DSpace page. While the layout of the DRI schema does favor the above div
        arrangement, nothing is preventing the designer from changing them around or adding new ones by
        overriding the dri:document template.
    -->
    <xsl:template match="dri:document">
        <html class="no-js" xmlns:fb="http://ogp.me/ns/fb#">
		
            <!-- First of all, build the HTML head element -->
            <xsl:call-template name="buildHead" />
            <!-- Then proceed to the body -->
	    
	    <body>
            <xsl:choose>
              <xsl:when test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='framing'][@qualifier='popup']">
                <xsl:apply-templates select="dri:body/*"/>
              </xsl:when>
                  <xsl:otherwise>
                    <div id="ds-main">
                        <!--The header div, complete with title, subtitle and other junk-->
                        <xsl:call-template name="buildHeader"/>

                        <!--The trail is built by applying a template over pageMeta's trail children. -->
                        <xsl:call-template name="buildTrail"/>

                        <!--javascript-disabled warning, will be invisible if javascript is enabled-->
                        <div id="no-js-warning-wrapper" class="hidden">
                            <div id="no-js-warning">
                                <div class="notice failure">
                                    <xsl:text>JavaScript is disabled for your browser. Some features of this site may not work without it.</xsl:text>
                                </div>
                            </div>
                        </div>


                        <!--ds-content is a groups ds-body and the navigation together and used to put the clearfix on, center, etc.
                            ds-content-wrapper is necessary for IE6 to allow it to center the page content-->
                        <div id="ds-content-wrapper">
                            <div id="ds-content" class="clearfix">
                                <!--
                               Goes over the document tag's children elements: body, options, meta. The body template
                               generates the ds-body div that contains all the content. The options template generates
                               the ds-options div that contains the navigation and action options available to the
                               user. The meta element is ignored since its contents are not processed directly, but
                               instead referenced from the different points in the document. -->
                                <xsl:apply-templates/>
                            </div>
                        </div>


                        <!--
                            The footer div, dropping whatever extra information is needed on the page. It will
                            most likely be something similar in structure to the currently given example. -->
                        <xsl:call-template name="buildFooter"/>

                    </div>

                </xsl:otherwise>
            </xsl:choose>
                <!-- Javascript at the bottom for fast page loading -->
              <xsl:call-template name="addJavascript"/>

            </body>
        </html>
    </xsl:template>

        <!-- The HTML head element contains references to CSS as well as embedded JavaScript code. Most of this
        information is either user-provided bits of post-processing (as in the case of the JavaScript), or
        references to stylesheets pulled directly from the pageMeta element. -->
    <xsl:template name="buildHead">
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>

            <!-- Always force latest IE rendering engine (even in intranet) & Chrome Frame -->
            <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>

            <!--  Mobile Viewport Fix
                  j.mp/mobileviewport & davidbcalhoun.com/2010/viewport-metatag
            device-width : Occupy full width of the screen in its current orientation
            initial-scale = 1.0 retains dimensions instead of zooming out if page height > device height
            maximum-scale = 1.0 retains dimensions instead of zooming in if page width < device width
            -->
            <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0"/>


<!-- 130327 andre.assada@usp.br nova barra usp by Marcio Eichler, agora com codigo centralizado em server unico -->
<!-- <link rel="stylesheet" type="text/css" href="http://www.sibi.usp.br/barraUSP/styles/index.css" /> -->

<!--
<link rel="stylesheet" type="text/css">
    <xsl:text>
        #header{
			background-image:url("http://www.sibi.usp.br/barraUSP/images/right_Logo_usp_BG.gif");
			background-repeat:repeat;
		}
	</xsl:text>
</link>
-->

<!-- <link rel="stylesheet" type="text/css" href="http://www.sibi.usp.br/barraUSP/styles/slide.css" /> -->
<!-- FIM 130327 andre.assada@usp.br nova barra usp by Marcio Eichler, agora com codigo centralizado em server unico FIM -->


            <xsl:call-template name="buildMetas" />


            <link rel="shortcut icon">
                <xsl:attribute name="href">
                    <xsl:value-of select="$context-path"/>
                    <xsl:text>/themes/</xsl:text>
                    <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='theme'][@qualifier='path']"/>
<!-- 130412 andre.assada@usp.br
                    <xsl:text>/images/favicon.ico</xsl:text> --> <xsl:text>/images/faviconUSP.ico</xsl:text>
                </xsl:attribute>
            </link>
            <link rel="apple-touch-icon">
                <xsl:attribute name="href">
                    <xsl:value-of select="$context-path"/>
                    <xsl:text>/themes/</xsl:text>
                    <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='theme'][@qualifier='path']"/>
                    <xsl:text>/images/apple-touch-icon.png</xsl:text>
                </xsl:attribute>
            </link>

            <meta name="Generator">
              <xsl:attribute name="content">
                <xsl:text>DSpace</xsl:text>
                <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='dspace'][@qualifier='version']">
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='dspace'][@qualifier='version']"/>
                </xsl:if>
              </xsl:attribute>
            </meta>
            <!-- Add stylsheets -->
            <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='stylesheet']">
                <link rel="stylesheet" type="text/css">
                    <xsl:attribute name="media">
                        <xsl:value-of select="@qualifier"/>
                    </xsl:attribute>
                    <xsl:attribute name="href">
                        <xsl:value-of select="$context-path"/>
                        <xsl:text>/themes/</xsl:text>
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='theme'][@qualifier='path']"/>
                        <xsl:text>/</xsl:text>
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                </link>
            </xsl:for-each>
			
			<!-- 130920 - Dan Shinkai - Inserido CSS para JPlayer manualmente -->
			<link rel="stylesheet" type="text/css">
                    <xsl:attribute name="media">
                        <xsl:value-of select="@qualifier"/>
                    </xsl:attribute>
                    <xsl:attribute name="href">
                        <xsl:value-of select="$context-path"/>
                        <xsl:text>/themes/</xsl:text>
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='theme'][@qualifier='path']"/>
                        <xsl:text>/</xsl:text>
                        <xsl:text>lib/css/jplayer.blue.monday.css</xsl:text>
                    </xsl:attribute>
			</link>
			
			<!-- JPlayer CSS FIM -->

            <!-- Add syndication feeds -->
            <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='feed']">
                <link rel="alternate" type="application">
                    <xsl:attribute name="type">
                        <xsl:text>application/</xsl:text>
                        <xsl:value-of select="@qualifier"/>
                    </xsl:attribute>
                    <xsl:attribute name="href">
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                </link>
            </xsl:for-each>

            <!--  Add OpenSearch auto-discovery link -->
            <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='opensearch'][@qualifier='shortName']">
                <link rel="search" type="application/opensearchdescription+xml">
                    <xsl:attribute name="href">
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='scheme']"/>
                        <xsl:text>://</xsl:text>
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='serverName']"/>
                        <xsl:text>:</xsl:text>
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='serverPort']"/>
                        <xsl:value-of select="$context-path"/>
                        <xsl:text>/</xsl:text>
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='opensearch'][@qualifier='autolink']"/>
                    </xsl:attribute>
                    <xsl:attribute name="title" >
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='opensearch'][@qualifier='shortName']"/>
                    </xsl:attribute>
                </link>
            </xsl:if>

			<script type="text/javascript">
			<xsl:attribute name="src">
			<xsl:value-of select="$context-path"/>
			<xsl:text>/static/js/jquery-1.9.1.js</xsl:text>
			</xsl:attribute>&#160;</script>
			
			<script type="text/javascript">
			<xsl:attribute name="src">
			<xsl:value-of select="$context-path"/>
			<xsl:text>/static/js/jquery-ui.js</xsl:text>
			</xsl:attribute>&#160;</script>
			
			<!-- 120611 FontResizer chamada do js -->
			<script type="text/javascript">
			<xsl:attribute name="src">
			<xsl:value-of select="$context-path"/>
			<xsl:text>/themes/</xsl:text>
			<xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='theme'][@qualifier='path']"/>
			<xsl:text>/lib/js/fontresizer.js</xsl:text>
			</xsl:attribute>&#160;</script>
			<!-- ========== -->
			
			<!-- 130828 - Dan Shinkai  - Javascript para permitir a utilizacao do AltMetrics -->
			
			<script type="text/javascript">
			<xsl:attribute name="src">
			<xsl:text>https://d1bxh8uas1mnw7.cloudfront.net/assets/embed.js</xsl:text><!-- /static/js/embed.js -->
			</xsl:attribute>
			<xsl:attribute name="async">
			<xsl:text>async</xsl:text>
			</xsl:attribute>&#160;</script>

			<!--script type="text/javascript">
			<xsl:attribute name="src">
			<xsl:text>http://impactstory.org/embed/v1/impactstory.js</xsl:text>
			</xsl:attribute>
			<xsl:attribute name="async">
			<xsl:text>async</xsl:text>
			</xsl:attribute>&#160;</script-->
			
			<!-- FIM -->
			
			<script type="text/javascript">
				$(function(){
				$('#aspect_discovery_Navigation_list_discovery ul li h2').click(function(event){ var elem = $(this).next();
				if(elem.is('ul')){ event.preventDefault();
				$('#menu ul:visible').not(elem).slideUp();
				elem.slideToggle();
				}
				});
				});
			&#160;</script>
			<!--  END - Script de acordeon para o Discovery - Tiago - 15-07-2013 -->
			
			<!-- 130920 - Dan Shinkai - Prototipo JQuery para visualizacao de video. 
			<script type="text/javascript">
				<xsl:attribute name="src">
					<xsl:text>http://ajax.googleapis.com/ajax/libs/jquery/1.6/jquery.min.js</xsl:text>
				</xsl:attribute>&#160;</script>
			
			<script type="text/javascript">
			<xsl:attribute name="src">
				<xsl:value-of select="$context-path"/>
				<xsl:text>/themes/</xsl:text>
				<xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='theme'][@qualifier='path']"/>
				<xsl:text>/lib/js/jquery.jplayer.min.js</xsl:text>
			</xsl:attribute>&#160;</script>
			
			<script type="text/javascript">
				var $jplayer = jQuery.noConflict()
				$jplayer(document).ready(function(){
				  $jplayer("#jquery_jplayer_1").jPlayer({
					ready: function () {
					  $jplayer(this).jPlayer("setMedia", {
						m4v: "http://bdpife4.sibi.usp.br/a/GitReal.mp4",
						poster: ""
					  });
					},
					swfPath: "js/",
					supplied: "m4v",
					size: {
						width: "640px",
						height: "360px",
						cssClass: "jp-video-360p"
					},
					smoothPlayBar: true,
					keyEnabled: true
				  });
				});
			&#160;</script>
			
			 Prototipo JQuery FIM -->
		
<!-- 130808 - Dan Shinkai - Codigo que esconde itens com mais de dez autores na lista de itens -->		
<!-- Dicas: Sinais de '>' ou '<' nao sao reconhecidos diretamente no XSL. Portanto, adicionar dentro de uma tag <xsl:text disable-output-escaping="yes"> 
			no formato '&gt;' para que seja reconhecido pelo HTML. -->
			
			<script type="text/javascript">
				jQuery(document).ready(function() {
				
					$(".author").each(function() {
						var count = $(this).find("span").length;
						if(count <xsl:text disable-output-escaping="yes">&gt;</xsl:text> 20) {
							$(this).addClass("removeAuthor");
							var autores = $("<xsl:text disable-output-escaping="yes">&lt;font class='authorLink'&gt;</xsl:text><i18n:text>xmlui.ArtifactBrowser.ConfigurableBrowse.item.viewAuthor</i18n:text><xsl:text disable-output-escaping="yes">&lt;/font&gt;</xsl:text>");
							$(this).after(autores);									
						}
					});
										
					$(".artifact-info").click(function() {    
						var author = $(this).find(".author");
						var count = $(author).find("span").length;
						
						if(count <xsl:text disable-output-escaping="yes">&gt;</xsl:text> 20) {
							if($(author).css("display") == "none") {
								$(this).find("font").css({"display" : "none"});																					
								$(author).fadeIn("slow");
								
							} else {
								$(author).css({"display" : "none"});
								var autores = $("<xsl:text disable-output-escaping="yes">&lt;font class='authorLink'&gt;</xsl:text><i18n:text>xmlui.ArtifactBrowser.ConfigurableBrowse.item.viewAuthor</i18n:text><xsl:text disable-output-escaping="yes">&lt;/font&gt;</xsl:text>");
								$(author).after(autores);
							}
						}
					});
				});					
			</script>
			<!-- FIM -->
			
			<!-- The following javascript removes the default text of empty text areas when they are focused on or submitted -->
            <!-- There is also javascript to disable submitting a form when the 'enter' key is pressed. -->
			
			<script type="text/javascript">
                <xsl:attribute name="src">
                    <xsl:text>https://www.google.com/jsapi</xsl:text>                    
                </xsl:attribute>&#160;
			</script>
			
			<!-- 130607 - Dan Shinkai - Adicionado funcao concatTextField no qual realizara a criacao da tupla do autor externo USP. Esta funcao sera visivel
			                            somente na pagina de submissao de um item no qual havera os campos para o autor externo USP. Esta sendo assumido
										que os campos sao pre-definidos, ou seja, a ordem no qual sera apresentado os campos sao sempre as mesmas. -->
			<!-- 130615 - Dan Shinkai - Funcao concatTextField() que realiza a concatenacao dos campos para a criacao da tupla do autor externo USP. -->
			<!-- 130615 - Funcao drawChart() que gera o grafico pela API do google chart -->
			<script type="text/javascript">
				//Clear default text of empty text areas on focus
				function tFocus(element)
				{
						if (element.value == '<i18n:text>xmlui.dri2xhtml.default.textarea.value</i18n:text>'){element.value='';}
				}
				//Clear default text of empty text areas on submit
				function tSubmit(form)
				{
						var defaultedElements = document.getElementsByTagName("textarea");
						for (var i=0; i != defaultedElements.length; i++){
								if (defaultedElements[i].value == '<i18n:text>xmlui.dri2xhtml.default.textarea.value</i18n:text>'){
										defaultedElements[i].value='';}}
				}
				//Disable pressing 'enter' key to submit a form (otherwise pressing 'enter' causes a submission to start over)
				function disableEnterKey(e)
				{
					 var key;

					 if(window.event)
						  key = window.event.keyCode;     //Internet Explorer
					 else
						  key = e.which;     //Firefox and Netscape

					 if(key == 13)  //if "Enter" pressed, then disable!
						  return false;
					 else
						  return true;
				}

				function FnArray()
				{
					this.funcs = new Array;
				}

				FnArray.prototype.add = function(f)
				{
					if( typeof f!= "function" )
					{
						f = new Function(f);
					}
					this.funcs[this.funcs.length] = f;
				};

				FnArray.prototype.execute = function()
				{
					for( var i=0; i <xsl:text disable-output-escaping="yes">&lt;</xsl:text> this.funcs.length; i++ )
					{
						this.funcs[i]();
					}
				};

				var runAfterJSImports = new FnArray();
				
				<xsl:if test="/dri:document/dri:body/dri:div/dri:list/dri:item/dri:field[@id='aspect.submission.StepTransformer.field.usp_autor_externo']">
					<xsl:text>
						function concatTextField()								
						{						
							var text = document.getElementsByName("concat-usp-externo");
							var textSubmit = document.getElementsByName("usp_autor_externo");
							
							var nome = text[0].value.replace(":"," ").trim();
							var tupla = nome.concat(":", text[1].value.replace(":"," ").trim(), " :c ", text[2].value.replace(":"," ").trim(), " :u ", text[3].value.replace(":"," ").trim(), " :p ", textSubmit[0].value.replace(":"," ").trim());
							textSubmit[0].value = tupla;									
						}
					</xsl:text>
				</xsl:if>
				
				
				<xsl:if test="/dri:document/dri:body/dri:div/dri:div/dri:div/dri:list[@id='aspect.artifactbrowser.InterUnitAuthorView.list.id_grafico_interUnidLista']">
					<xsl:text>
					  // Load the Visualization API and the piechart package.
					  google.load('visualization', '1.0', {'packages':['corechart']});

					  // Set a callback to run when the Google Visualization API is loaded.
					  google.setOnLoadCallback(drawChart);

					  // Callback that creates and populates a data table,
					  // instantiates the pie chart, passes in the data and
					  // draws it.
					  function drawChart() {

						// Create the data table.
						var data = new google.visualization.DataTable();
						
						var count = 1;
						var idUnidade = "aspect_artifactbrowser_InterUnitAuthorView_cell_id_cols_unid_interUnid_field";
						var idTrabalho = "aspect_artifactbrowser_InterUnitAuthorView_cell_id_cols_trabalhos_interUnid_field";
						var unidade = document.getElementById(idUnidade.concat("1")).innerHTML;
						var qtdTrabalho = document.getElementById(idTrabalho.concat("1")).innerHTML;
						
						data.addColumn('string', 'Topping');
						data.addColumn('number', 'Slices');						
						for(var cont=1;;cont++) {
							data.addRow([unidade,parseInt(qtdTrabalho)]);
							count++;
							if(document.getElementById(idUnidade.concat(count.toString()))){
								unidade = document.getElementById(idUnidade.concat(count.toString())).innerHTML;
								qtdTrabalho = document.getElementById(idTrabalho.concat(count.toString())).innerHTML;	
							}
							else{break;}
						}
						// Set chart options
						var options = {'width':500,
									   'height': 500,
									   'chartArea':{left:"0",top:"10%",width:"100%",height:"100%"}};

						// Instantiate and draw our chart, passing in some options.
						var chart = new google.visualization.PieChart(document.getElementById('aspect_artifactbrowser_InterUnitAuthorView_div_id_grafico_interUnid'));
						chart.draw(data, options);
					  }							
					</xsl:text>
				</xsl:if>
				
				<xsl:if test="/dri:document/dri:body/dri:div/dri:div[@id='aspect.statistics.StatisticsTransformer.div.stats']">
					<xsl:text>
						var div = document.getElementById('aspect_statistics_StatisticsTransformer_div_stats');

						var newText = document.createElement('textarea'); // create new textarea

						div.appendChild(newText);						
					</xsl:text>
				</xsl:if>
            &#160;</script>
			
			
            <!-- Modernizr enables HTML5 elements & feature detects -->
            <script type="text/javascript">
                <xsl:attribute name="src">
                    <xsl:value-of select="$context-path"/>
                    <xsl:text>/themes/</xsl:text>
                    <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='theme'][@qualifier='path']"/>
                    <xsl:text>/lib/js/modernizr-1.7.min.js</xsl:text>
                </xsl:attribute>&#160;</script>

            <!-- Add the title in -->
            <xsl:variable name="page_title" select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='title']" />
			
			<xsl:variable name="doi">
				<xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='citation_doi']"/>
			</xsl:variable>		

<!-- 130813 - Dan Shinkai - Codigo que implementa metricas alternativas na visualizacao do registro de um item simples e completo. Somente para itens nos quais contenham o DOI. -->		
<!-- Dicas: Sinais de '>' ou '<' nao sao reconhecidos diretamente no XSL. Portanto, adicionar dentro de uma tag <xsl:text disable-output-escaping="yes"> 
			no formato '&gt;' para que seja reconhecido pelo HTML. -->

			<xsl:if test="$doi!=''"> 				
				<script type="text/javascript">
					jQuery(document).ready(function() {	
						
						$(".ds-referenceSet-list").after("<xsl:text disable-output-escaping="yes">&lt;div class='impactstory-embed' data-id='</xsl:text><xsl:copy-of select="$doi"></xsl:copy-of><xsl:text disable-output-escaping="yes">' data-id-type='doi' data-api-key='API-DOCS' data-badge-palette='grayscale' data-badge-type='icon'&gt;&lt;/div&gt;</xsl:text>");
						$(".ds-referenceSet-list").after("<xsl:text disable-output-escaping="yes">&lt;div class='altmetric-embed' data-badge-details='right' data-doi='</xsl:text><xsl:copy-of select="$doi"></xsl:copy-of><xsl:text disable-output-escaping="yes">' data-badge-popover='right'&gt;&lt;/div&gt;</xsl:text>");
						$(".ds-referenceSet-list").after("<xsl:text disable-output-escaping="yes">&lt;h2 class='ds-list-head'&gt;</xsl:text><i18n:text>xmlui.ArtifactBrowser.ItemViewer.item.ds_list_head</i18n:text><xsl:text disable-output-escaping="yes">&lt;/h2&gt;</xsl:text>");					
						
					});					
				&#160;</script>
			</xsl:if>
<!-- FIM -->
			
            <title>
                <xsl:choose>
			<!-- previous check -->
			<!--xsl:when test="$request-uri errorhas 'page/creditosBDPIEnUS'"
			    xsl:when test="'page/direitosAutoraisPtBR' = substring($request-uri, string-length($request-uri) - string-length('page/direitosAutoraisPtBR') + 1)">
                                <xsl:variable name="doc" select="document(concat($paginas,'/direitosAutoraisPtBR.xhtml'))"/>
                                <xsl:value-of select="$doc/html/head/title"/>
                        </xsl:when-->
			<!-- general check -->
			<xsl:when test="substring-after($request-uri,'page/') = ''">
	                        <xsl:if test="boolean($page_title)">
				<xsl:copy-of select="$page_title/node()" />
				</xsl:if>
			</xsl:when>
			<xsl:when test="boolean(document(concat($paginas,'/',substring-after($request-uri,'page/'),'.xhtml')))">
	                        <xsl:variable name="doc" select="document(concat($paginas,'/',substring-after($request-uri,'page/'),'.xhtml'))"/>
                                <xsl:value-of select="$doc/html/head/title"/>
			</xsl:when>
                        <xsl:otherwise>
	                        <xsl:if test="boolean($page_title)">
				<xsl:copy-of select="$page_title/node()" />
				</xsl:if>
                        </xsl:otherwise>
                </xsl:choose>
            </title>
            
        </head>
    </xsl:template>

    <xsl:template name="buildMetas">
            <xsl:text><![CDATA[

]]></xsl:text>
            <!-- Head metadata in item pages -->
            <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='xhtml_head_item']">
                <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='xhtml_head_item']"
                              disable-output-escaping="yes"/>
            </xsl:if>
	    <xsl:text><![CDATA[

]]></xsl:text>
            <!-- Add all Google Scholar Metadata values -->
            <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[substring(@element, 1, 9) = 'citation_']">
                <meta name="{@element}" content="{.}"></meta>
            </xsl:for-each>
            <xsl:text><![CDATA[

]]></xsl:text>
    </xsl:template>

    <!-- The header (distinct from the HTML head element) contains the title, subtitle, login box and various
        placeholders for header images -->
    <xsl:template name="buildHeader">

<!-- 130327 andre.assada@usp.br nova barra usp by Marcio Eichler, agora com codigo centralizado em server unico -->
<div id="uspLogo">
    <img src="http://www.producao.usp.br/a/barrausp/images/left_Logo_usp.jpg" style="cursor:pointer;" alt="USP" onclick="javascript:window.open('http://www.usp.br');" />
    <img src="http://www.producao.usp.br/a/barrausp/images/middle_Logo_usp.gif" style="cursor:pointer;" alt="USP" onclick="javascript:window.open('http://www.usp.br');" />
</div>
<script type="text/javascript">
    <xsl:attribute name="src">
        <xsl:text>http://www.producao.usp.br/a/barrausp/js/barra2.js</xsl:text>
    </xsl:attribute>
    <xsl:attribute name="charset">
        <xsl:text>utf-8</xsl:text>
    </xsl:attribute>
    &#160;</script>
<!-- FIM 130327 andre.assada@usp.br nova barra usp by Marcio Eichler, agora com codigo centralizado em server unico FIM -->

        <div id="ds-header-wrapper">
            <div id="ds-header" class="clearfix">
                <a id="ds-header-logo-link">
                    <xsl:attribute name="href">
                        <xsl:value-of
                                select="$context-path"/>
                        <xsl:text>/</xsl:text>
                    </xsl:attribute>
                    <span id="ds-header-logo">&#160;</span>
                    <span id="ds-header-logo-text"></span>
                </a>
                <h1 class="pagetitle visuallyhidden">
                    <xsl:choose>
                        <!-- protection against an empty page title -->
                        <xsl:when test="not(/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='title'])">
                            <xsl:text> </xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:copy-of
                                    select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='title']/node()"/>
                        </xsl:otherwise>
                    </xsl:choose>

                </h1>
                <h2 class="static-pagetitle visuallyhidden">
                    <i18n:text>xmlui.dri2xhtml.structural.head-subtitle</i18n:text>
                </h2>

                <xsl:choose>
                    <xsl:when test="/dri:document/dri:meta/dri:userMeta/@authenticated = 'yes'">
                        <div id="ds-user-box">
                            <p>
                                <a>
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="/dri:document/dri:meta/dri:userMeta/
                                        dri:metadata[@element='identifier' and @qualifier='url']"/>
                                    </xsl:attribute>
                                    <i18n:text>xmlui.dri2xhtml.structural.profile</i18n:text>
                                    <xsl:value-of select="/dri:document/dri:meta/dri:userMeta/
                                    dri:metadata[@element='identifier' and @qualifier='firstName']"/>
                                    <xsl:text> </xsl:text>
                                    <xsl:value-of select="/dri:document/dri:meta/dri:userMeta/
                                    dri:metadata[@element='identifier' and @qualifier='lastName']"/>
                                </a>
<!-- 130415 para sumir com a caixa de usuario do ds-options, deve aparecer o link de submissoes no topo. para colocar toda a caixa, esse modo abaixo serve, mas queremos so o link de submissoes.
                                <xsl:apply-templates select="/dri:document/dri:options/dri:list[@id = 'aspect.viewArtifacts.Navigation.list.account']"/>
-->
<!-- 130415 andre.assada@usp.br link de submissoes aparece no topo, para poder sumir com a caixa "minha conta" dos menus ds-options -->
                                <xsl:text> | </xsl:text>
                                <a>
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="$context-path"/>
                                        <xsl:text>/submissions</xsl:text>
                                    </xsl:attribute>
                                    <i18n:text>xmlui.Submission.Navigation.submissions</i18n:text>
                                </a>
<!-- 130415 FIM  andre.assada@usp.br link de submissoes aparece no topo, para poder sumir com a caixa "minha conta" dos menus ds-options FIM -->
                                <xsl:text> | </xsl:text>
                                <a>
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="/dri:document/dri:meta/dri:userMeta/
                                        dri:metadata[@element='identifier' and @qualifier='logoutURL']"/>
                                    </xsl:attribute>
                                    <i18n:text>xmlui.dri2xhtml.structural.logout</i18n:text>
                                </a>
                            </p>
                        </div>
                    </xsl:when>
                    <xsl:otherwise>
                        <div id="ds-user-box">
                            <p>
                                <!-- 18jun2013 jan.lara@sibi.usp.br - comentado para esconder login enquanto bdpi está fechada -->
			         <a>
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="/dri:document/dri:meta/dri:userMeta/
                                        dri:metadata[@element='identifier' and @qualifier='loginURL']"/>
                                    </xsl:attribute>
                                    <i18n:text>xmlui.dri2xhtml.structural.login</i18n:text>
                                </a>
                            </p>
                        </div>
                    </xsl:otherwise>
                </xsl:choose>

            </div>
<!-- 130417 andre.assada@usp.br locale switcher, cf. JIRA DS-842 -->
            <!-- Display a language selection if more than 1 language is supported -->
            <xsl:if test="count(/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='page'][@qualifier='supportedLocale']) &gt; 1">
                <div id="ds-language-selection">
                    <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='page'][@qualifier='supportedLocale']">
                        <xsl:variable name="locale" select="."/>
                        <a>
                            <xsl:attribute name="href">
                                <xsl:value-of select="concat($context-path,'/?locale-attribute=')"/>
                                <xsl:value-of select="$locale"/>
                            </xsl:attribute>
                            <xsl:if test="$locale = 'pt_BR'">
                                <span id="ds-language-selection-ptBR">&#160;</span>
                            </xsl:if>
                            <xsl:if test="$locale = 'en'">
                                <span id="ds-language-selection-en">&#160;</span>
                            </xsl:if>
                            <xsl:if test="$locale = 'es'">
                                <span id="ds-language-selection-es">&#160;</span>
                            </xsl:if>
                            <xsl:attribute name="alt">
                                <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='supportedLocale'][@qualifier=$locale]"/>
                            </xsl:attribute>
                        </a>
                    </xsl:for-each>
                </div>
            </xsl:if>
<!-- FIM 130417 andre.assada@usp.br locale switcher, cf. JIRA DS-842 FIM -->

        </div>
			<!-- 120612 Josi fontResizer botoes para o user clicar e alterar -->
			<!-- 130813 - Dan Shinkai - Alterado FontResizer -->
			<div id="ds-font-resize">
				
				<xsl:text disable-output-escaping="yes">&lt;a id="fnt_small" href="javascript:void(0);" onclick="changeFont('small')" title='</xsl:text>
				<i18n:text>xmlui.dri2xhtml.structural.font_decrease</i18n:text>
				<xsl:text disable-output-escaping="yes">'&gt;&lt;img src="</xsl:text>
				<xsl:value-of select="$context-path"/>
				<xsl:text disable-output-escaping="yes">/themes/</xsl:text>
				<xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='theme'][@qualifier='path']"/>
				<xsl:text disable-output-escaping="yes">/images/fnt_small.gif"&gt;&lt;/img&gt;&lt;/a&gt;</xsl:text>
				
				<xsl:text disable-output-escaping="yes">&lt;a id="fnt_reset" href="javascript:void(0);" onclick="changeFont('reset')" title='</xsl:text>
				<i18n:text>xmlui.dri2xhtml.structural.font_default</i18n:text>
				<xsl:text disable-output-escaping="yes">'&gt;&lt;img src="</xsl:text>
				<xsl:value-of select="$context-path"/>
				<xsl:text disable-output-escaping="yes">/themes/</xsl:text>
				<xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='theme'][@qualifier='path']"/>
				<xsl:text disable-output-escaping="yes">/images/fnt_reset.gif"&gt;&lt;/img&gt;&lt;/a&gt;</xsl:text>
				
				<xsl:text disable-output-escaping="yes">&lt;a id="fnt_big" href="javascript:void(0);" onclick="changeFont('big')" title='</xsl:text>
				<i18n:text>xmlui.dri2xhtml.structural.font_increase</i18n:text>
				<xsl:text disable-output-escaping="yes">'&gt;&lt;img src="</xsl:text>
				<xsl:value-of select="$context-path"/>
				<xsl:text disable-output-escaping="yes">/themes/</xsl:text>
				<xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='theme'][@qualifier='path']"/>
				<xsl:text disable-output-escaping="yes">/images/fnt_big.gif"&gt;&lt;/img&gt;&lt;/a&gt;</xsl:text>

				<script type="text/javascript">
				<xsl:text>
						var cursize = GetCookie('font-size');
						if (cursize == null) cursize='reset';
						changeFont(cursize);</xsl:text>
				&#160;</script>
			</div>
    </xsl:template>


    <!-- The header (distinct from the HTML head element) contains the title, subtitle, login box and various
        placeholders for header images -->
    <xsl:template name="buildTrail">

<!-- 130404 andre.assada@usp.br links informativos da bdpi ; o link eh criado no messages_xx.xml para adequar locales -->
<!-- 130731 Dan Shinkai - Adicionado link para politica de uso -->
            <div id="ds-trail-informacoes">

		<xsl:text disable-output-escaping="yes">&lt;a</xsl:text>
		<i18n:translate>
		  <i18n:text><![CDATA[ href="{0}{1}"]]></i18n:text>
		  <i18n:param><xsl:value-of select="$context-path"/></i18n:param>
		  <i18n:param><i18n:text>paginasEstaticas.politicaAcesso.href</i18n:text></i18n:param>
		</i18n:translate>
		<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
		<i18n:text>paginasEstaticas.politicaAcesso.trail</i18n:text>
		<xsl:text disable-output-escaping="yes">&lt;/a&gt;</xsl:text>

                <xsl:text>&#160;</xsl:text>
                <xsl:text>&#160;</xsl:text>
                <xsl:text>&#160;</xsl:text>
                <xsl:text>&#160;</xsl:text>
                <xsl:text>&#160;</xsl:text>
                <xsl:text>&#160;</xsl:text>

		<xsl:text disable-output-escaping="yes">&lt;a</xsl:text>
		<i18n:translate>
		  <i18n:text><![CDATA[ href="{0}{1}"]]></i18n:text>
		  <i18n:param><xsl:value-of select="$context-path"/></i18n:param>
		  <i18n:param><i18n:text>paginasEstaticas.direitosAutorais.href</i18n:text></i18n:param>
		</i18n:translate>
		<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
		<i18n:text>paginasEstaticas.direitosAutorais.trail</i18n:text>
		<xsl:text disable-output-escaping="yes">&lt;/a&gt;</xsl:text>

                <xsl:text>&#160;</xsl:text>
                <xsl:text>&#160;</xsl:text>
                <xsl:text>&#160;</xsl:text>
                <xsl:text>&#160;</xsl:text>
                <xsl:text>&#160;</xsl:text>
                <xsl:text>&#160;</xsl:text>

		<xsl:text disable-output-escaping="yes">&lt;a</xsl:text>
		<i18n:translate>
		  <i18n:text><![CDATA[ href="{0}{1}"]]></i18n:text>
		  <i18n:param><xsl:value-of select="$context-path"/></i18n:param>
		  <i18n:param><i18n:text>paginasEstaticas.sobreBDPI.href</i18n:text></i18n:param>
		</i18n:translate>
		<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
		<i18n:text>paginasEstaticas.sobreBDPI.trail</i18n:text>
		<xsl:text disable-output-escaping="yes">&lt;/a&gt;</xsl:text>

		<xsl:text>&#160;</xsl:text>
                <xsl:text>&#160;</xsl:text>
                <xsl:text>&#160;</xsl:text>
                <xsl:text>&#160;</xsl:text>
                <xsl:text>&#160;</xsl:text>
                <xsl:text>&#160;</xsl:text>

		<xsl:text disable-output-escaping="yes">&lt;a</xsl:text>
		<i18n:translate>
		  <i18n:text><![CDATA[ href="{0}{1}"]]></i18n:text>
		  <i18n:param><xsl:value-of select="$context-path"/></i18n:param>
		  <i18n:param><i18n:text>paginasEstaticas.faq.href</i18n:text></i18n:param>
		</i18n:translate>
		<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
		<i18n:text>paginasEstaticas.faq.trail</i18n:text>
		<xsl:text disable-output-escaping="yes">&lt;/a&gt;</xsl:text>

                <xsl:text>&#160;</xsl:text>
            </div>
<!-- FIM 130404 andre.assada@usp.br FIM -->

        <div id="ds-trail-wrapper">
            <ul id="ds-trail">
		<xsl:variable name="staticpagename" select="substring-after($request-uri,'page/')" />
                <xsl:choose>
                    <xsl:when test="$staticpagename = 'politicaAcessoPtBR'">
                         <li class="ds-trail-link first-link"><i18n:text>paginasEstaticas.politicaAcesso.trail</i18n:text></li>
                    </xsl:when>
                    <xsl:when test="$staticpagename = 'direitosAutoraisPtBR'">
                         <li class="ds-trail-link first-link"><i18n:text>paginasEstaticas.direitosAutorais.trail</i18n:text></li>
                    </xsl:when>
                    <xsl:when test="$staticpagename = 'sobreBDPIPtBR'">
                         <li class="ds-trail-link first-link"><i18n:text>paginasEstaticas.sobreBDPI.trail</i18n:text></li>
                    </xsl:when>
                    <xsl:when test="$staticpagename = 'creditosBDPIPtBR'">
                         <li class="ds-trail-link first-link"><i18n:text>paginasEstaticas.creditos.trail</i18n:text></li>
                    </xsl:when>
                    <xsl:when test="$staticpagename = 'privacidadeBDPIPtBR'">
                         <li class="ds-trail-link first-link"><i18n:text>paginasEstaticas.privacidade.trail</i18n:text></li>
                    </xsl:when>
                    <xsl:when test="$staticpagename = 'faqPtBR'">
                         <li class="ds-trail-link first-link"><i18n:text>paginasEstaticas.faq.trail</i18n:text></li>
                    </xsl:when>
                    <xsl:when test="$staticpagename = 'politicaAcessoEnUS'">
                         <li class="ds-trail-link first-link"><i18n:text>paginasEstaticas.politicaAcesso.trail</i18n:text></li>
                    </xsl:when>
                    <xsl:when test="$staticpagename = 'direitosAutoraisEnUS'">
                         <li class="ds-trail-link first-link"><i18n:text>paginasEstaticas.direitosAutorais.trail</i18n:text></li>
                    </xsl:when>
                    <xsl:when test="$staticpagename = 'sobreBDPIEnUS'">
                         <li class="ds-trail-link first-link"><i18n:text>paginasEstaticas.sobreBDPI.trail</i18n:text></li>
                    </xsl:when>
                    <xsl:when test="$staticpagename = 'creditosBDPIEnUS'">
                         <li class="ds-trail-link first-link"><i18n:text>paginasEstaticas.creditos.trail</i18n:text></li>
                    </xsl:when>
                    <xsl:when test="$staticpagename = 'privacidadeBDPIEnUS'">
                         <li class="ds-trail-link first-link"><i18n:text>paginasEstaticas.privacidade.trail</i18n:text></li>
                    </xsl:when>
                    <xsl:when test="$staticpagename = 'faqEnUS'">
                         <li class="ds-trail-link first-link"><i18n:text>paginasEstaticas.faq.trail</i18n:text></li>
                    </xsl:when>
                    <xsl:when test="$staticpagename = 'politicaAcessoEs'">
                         <li class="ds-trail-link first-link"><i18n:text>paginasEstaticas.politicaAcesso.trail</i18n:text></li>
                    </xsl:when>
                    <xsl:when test="$staticpagename = 'direitosAutoraisEs'">
                         <li class="ds-trail-link first-link"><i18n:text>paginasEstaticas.direitosAutorais.trail</i18n:text></li>
                    </xsl:when>
                    <xsl:when test="$staticpagename = 'sobreBDPIEs'">
                         <li class="ds-trail-link first-link"><i18n:text>paginasEstaticas.sobreBDPI.trail</i18n:text></li>
                    </xsl:when>
                    <xsl:when test="$staticpagename = 'creditosBDPIEs'">
                         <li class="ds-trail-link first-link"><i18n:text>paginasEstaticas.creditos.trail</i18n:text></li>
                    </xsl:when>
                    <xsl:when test="$staticpagename = 'privacidadeBDPIEs'">
                         <li class="ds-trail-link first-link"><i18n:text>paginasEstaticas.privacidade.trail</i18n:text></li>
                    </xsl:when>
                    <xsl:when test="$staticpagename = 'faqEs'">
                         <li class="ds-trail-link first-link"><i18n:text>paginasEstaticas.faq.trail</i18n:text></li>
                    </xsl:when>
                    <xsl:when test="$staticpagename = 'community-list'">
                         <li class="ds-trail-link first-link"><i18n:text>xmlui.ArtifactBrowser.CommunityBrowser.trail</i18n:text></li>
                    </xsl:when>
                    <xsl:when test="$staticpagename = 'ajuda'">
                         <li class="ds-trail-link first-link">Ajuda</li>
                    </xsl:when>
                    <xsl:when test="count(/dri:document/dri:meta/dri:pageMeta/dri:trail) = 0">
                        <li class="ds-trail-link first-link">-</li>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="/dri:document/dri:meta/dri:pageMeta/dri:trail"/>
                    </xsl:otherwise>
                </xsl:choose>
            </ul>
        </div>
    </xsl:template>

    <xsl:template match="dri:trail">
        <!--put an arrow between the parts of the trail-->
        <xsl:if test="position()>1">
            <li class="ds-trail-arrow">
                <xsl:text>&#8594;</xsl:text>
            </li>
        </xsl:if>
        <li>
            <xsl:attribute name="class">
                <xsl:text>ds-trail-link </xsl:text>
                <xsl:if test="position()=1">
                    <xsl:text>first-link </xsl:text>
                </xsl:if>
                <xsl:if test="position()=last()">
                    <xsl:text>last-link</xsl:text>
                </xsl:if>
            </xsl:attribute>
            <!-- Determine whether we are dealing with a link or plain text trail link -->
            <xsl:choose>
                <xsl:when test="./@target">
                    <a>
                        <xsl:attribute name="href">
                            <xsl:value-of select="./@target"/>
                        </xsl:attribute>
                        <xsl:apply-templates />
                    </a>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates />
                </xsl:otherwise>
            </xsl:choose>
        </li>
    </xsl:template>

    <xsl:template name="cc-license">
        <xsl:param name="metadataURL"/>
        <xsl:variable name="externalMetadataURL">
            <xsl:text>cocoon:/</xsl:text>
            <xsl:value-of select="$metadataURL"/>
            <xsl:text>?sections=dmdSec,fileSec&amp;fileGrpTypes=THUMBNAIL</xsl:text>
        </xsl:variable>

        <xsl:variable name="ccLicenseName"
                      select="document($externalMetadataURL)//dim:field[@element='rights']"
                      />
        <xsl:variable name="ccLicenseUri"
                      select="document($externalMetadataURL)//dim:field[@element='rights'][@qualifier='uri']"
                      />
        <xsl:variable name="handleUri">
                    <xsl:for-each select="document($externalMetadataURL)//dim:field[@element='identifier' and @qualifier='uri']">
                        <a>
                            <xsl:attribute name="href">
                                <xsl:copy-of select="./node()"/>
                            </xsl:attribute>
                            <xsl:copy-of select="./node()"/>
                        </a>
                        <xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='uri']) != 0">
                            <xsl:text>, </xsl:text>
                        </xsl:if>
                </xsl:for-each>
        </xsl:variable>

   <xsl:if test="$ccLicenseName and $ccLicenseUri and contains($ccLicenseUri, 'creativecommons')">
        <div about="{$handleUri}" class="clearfix">
            <xsl:attribute name="style">
                <xsl:text>margin:0em 2em 0em 2em; padding-bottom:0em;</xsl:text>
            </xsl:attribute>
            <a rel="license"
                href="{$ccLicenseUri}"
                alt="{$ccLicenseName}"
                title="{$ccLicenseName}"
                >
                <img>
                     <xsl:attribute name="src">
                        <xsl:value-of select="concat($theme-path,'/images/cc-ship.gif')"/>
                     </xsl:attribute>
                     <xsl:attribute name="alt">
                         <xsl:value-of select="$ccLicenseName"/>
                     </xsl:attribute>
                     <xsl:attribute name="style">
                         <xsl:text>float:left; margin:0em 1em 0em 0em; border:none;</xsl:text>
                     </xsl:attribute>
                </img>
            </a>
            <span>
                <xsl:attribute name="style">
                    <xsl:text>vertical-align:middle; text-indent:0 !important;</xsl:text>
                </xsl:attribute>
                <i18n:text>xmlui.dri2xhtml.METS-1.0.cc-license-text</i18n:text>
                <xsl:value-of select="$ccLicenseName"/>
            </span>
        </div>
        </xsl:if>
    </xsl:template>

    <!-- Like the header, the footer contains various miscellaneous text, links, and image placeholders -->
    <xsl:template name="buildFooter">
        <div id="ds-footer-wrapper">
            <div id="ds-footer">

                <div id="ds-footer-left">
                     <table border="0" cellpadding="0" cellspacing="0">
                     <tr><td>
                        <div id="ds-footer-logo-sibi">
                            <a title="Universidade de São Paulo" target="_self" href="http://www.usp.br/sibi/" id="ds-footer-logo-link">
                                <span id="ds-footer-logo">&#160;</span>
                            </a>
                        </div>
                        </td>
                        <td>
                            <div id="ds-footer-info-sibi">
                            Rua da Biblioteca, S&#47;N - Complexo Brasiliana<br/>
                            05508-050 - Cidade Universit&#225;ria, S&#227;o Paulo, SP - Brasil<br/>
                            Tel: (0xx11) 3091-1539 e 3091-1566 <br/>
                            E-mail: <a href="mailto:atendimento@sibi.usp.br">atendimento@sibi.usp.br</a><br/>
                            </div>
                        </td>
                      </tr>
                      </table>
                </div>

                <div id="ds-footer-right">

                    <div id="ds-footer-right-privacy">
			<b>
				<xsl:text disable-output-escaping="yes">&lt;a</xsl:text>
				<i18n:translate>
				  <i18n:text><![CDATA[ href="{0}{1}"]]></i18n:text>
				  <i18n:param><xsl:value-of select="$context-path"/></i18n:param>
				  <i18n:param><i18n:text>paginasEstaticas.privacidade.href</i18n:text></i18n:param>
				</i18n:translate>
				<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
				<i18n:text>paginasEstaticas.privacidade.trail</i18n:text>
				<xsl:text disable-output-escaping="yes">&lt;/a&gt;</xsl:text>
			</b>
                        <xsl:text>&#160;&#160;</xsl:text>
                    </div>
                    <div id="ds-footer-right-credits">
			<b>
				<xsl:text disable-output-escaping="yes">&lt;a</xsl:text>
				<i18n:translate>
				  <i18n:text><![CDATA[ href="{0}{1}"]]></i18n:text>
				  <i18n:param><xsl:value-of select="$context-path"/></i18n:param>
				  <i18n:param><i18n:text>paginasEstaticas.creditos.href</i18n:text></i18n:param>
				</i18n:translate>
				<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
				<i18n:text>paginasEstaticas.creditos.trail</i18n:text>
				<xsl:text disable-output-escaping="yes">&lt;/a&gt;</xsl:text>
			</b>
                        <xsl:text>&#160;&#160;</xsl:text>
                    </div>

                    <div id="ds-footer-right-contact">
                        <a>
                            <xsl:attribute name="href">
                                <xsl:value-of select="$context-path"/>
                                <xsl:text>/feedback</xsl:text>
                            </xsl:attribute>
                            <b><i18n:text>xmlui.dri2xhtml.structural.contact-link</i18n:text></b>
                        </a>
                        <xsl:text>&#160;&#160;</xsl:text>
                    </div>
					<!--<div id="ds-footer-right-privacy">
                        <b><i18n:text>paginasEstaticas.faq</i18n:text></b>
                        <xsl:text>&#160;&#160;</xsl:text>
                    </div>-->

                    <br/>
                    <xsl:text disable-output-escaping="yes"><![CDATA[&copy; 2013 - SIBiUSP]]></xsl:text><br/>

                    <!--div id="ds-footer-right-rss">
                        <a>
                            <xsl:attribute name="href">
                                <xsl:value-of select="$context-path"/>
                                <xsl:text>/register</xsl:text>
                            </xsl:attribute>
                            <xsl:attribute name="id">
                                <xsl:text>ds-footer-logo-link</xsl:text>
                            </xsl:attribute>
                            <span id="ds-footer-right-rss">&#160;</span>
                        </a>
                    </div-->
		    
                    <!-- AddThis Button BEGIN -->
                    <xsl:text disable-output-escaping="yes"><![CDATA[
                    <div class="addthis_toolbox addthis_default_style addthis_32x32_style" style="width:350px;height:70px">
                                    <a class="addthis_button_facebook_like" fb:like:layout="box_count" fb:like:action="recommend"></a>
                                    <a class="addthis_button_tweet" tw:count="vertical"></a>
                                    <a class="addthis_button_google_plusone" g:plusone:size="tall"></a>
                                    <a class="addthis_button_linkedin_counter" li:counter="top"></a>
                                    <a class="addthis_button_compact"></a>
                    </div>
                    <script async="async" defer="true" type="text/javascript" src="//s7.addthis.com/js/300/addthis_widget.js#pubid=ra-4f9b00617c1df207" >
                        &#160;
                    </script>
                    ]]></xsl:text>
                    <!-- AddThis Button END old new code:xa-528f81785cf02a6c addthis_32x32_style -->
                    
                </div>


                <div id="ds-footer-links">
<!--
                    <a>
                        <xsl:attribute name="href">
                            <xsl:value-of
                                    select="$context-path"/>
                            <xsl:text>/contact</xsl:text>
                        </xsl:attribute>
                        <i18n:text>xmlui.dri2xhtml.structural.contact-link</i18n:text>
                    </a>
                    <xsl:text> | </xsl:text>
-->
                    <!--a>
                        <xsl:attribute name="href">
                            <xsl:value-of
                                    select="$context-path"/>
                            <xsl:text>/feedback</xsl:text>
                        </xsl:attribute>
                        <i18n:text>xmlui.dri2xhtml.structural.feedback-link</i18n:text>
                    </a-->

                </div>
                <!--Invisible link to HTML sitemap (for search engines) -->
                <a class="hidden">
                    <xsl:attribute name="href">
                        <xsl:value-of
                                select="$context-path"/>
                        <xsl:text>/htmlmap</xsl:text>
                    </xsl:attribute>
                    <xsl:text>&#160;</xsl:text>
                </a>
            </div>
        </div>
    </xsl:template>


<!--
        The meta, body, options elements; the three top-level elements in the schema
-->


    <!--
        The template to handle the dri:body element. It simply creates the ds-body div and applies
        templates of the body's child elements (which consists entirely of dri:div tags).
    -->
    <xsl:template match="dri:body">

        <div id="ds-body">
            <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='alert'][@qualifier='message']">
                <div id="ds-system-wide-alert">
                    <p>
                        <xsl:copy-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='alert'][@qualifier='message']/node()"/>
                    </p>
                </div>
            </xsl:if>

            <!-- Check for the custom pages -->
            <xsl:choose>
		<!-- previous check -->
		<!--xsl:when test="$staticpagename = 'creditosBDPIEnUS'"
		    xsl:when test="'page/direitosAutoraisPtBR' = substring($request-uri, string-length($request-uri) - string-length('page/direitosAutoraisPtBR') + 1)">
                        <xsl:variable name="doc" select="document(concat($paginas,'/direitosAutoraisPtBR.xhtml'))"/>
                        <xsl:value-of select="$doc/html/head/title"/>
                </xsl:when-->
		<!-- general check -->
		<xsl:when test="substring-after($request-uri,'page/') != ''">
                        <xsl:variable name="doc" select="document(concat($paginas,'/',substring-after($request-uri,'page/'),'.xhtml'))"/>
			<xsl:if test="boolean($doc)">
			  <xsl:copy-of select="$doc"/>
			</xsl:if>
		</xsl:when>
                <!-- Otherwise use default handling of body -->
                <xsl:otherwise>
                    <xsl:apply-templates />
                </xsl:otherwise>
            </xsl:choose>

        </div>

<!-- 200913 - Dan Shinkai - Criacao da pagina para apresentar video -->
				<!--<xsl:when test="$staticpagename = 'testando'">
                    <div id="jp_container_1" class="jp-video ">
						<div class="jp-type-single">
							<div id="jquery_jplayer_1" class="jp-jplayer"><xsl:text disable-output-escaping="yes"> </xsl:text></div>
							<div class="jp-gui">
								<div class="jp-video-play">
									<a href="javascript:;" class="jp-video-play-icon" tabindex="1">play</a>
								</div>
							
								<div class="jp-interface">
								  <div class="jp-progress">
									<div class="jp-seek-bar">
									  <div class="jp-play-bar"><xsl:text disable-output-escaping="yes"> </xsl:text></div>
									</div>
								  </div>
								  <div class="jp-current-time"><xsl:text disable-output-escaping="yes"> </xsl:text></div>
								  <div class="jp-duration"><xsl:text disable-output-escaping="yes"> </xsl:text></div>
								  <div class="jp-controls-holder">
									<ul class="jp-controls">
									  <li><a href="javascript:;" class="jp-play" tabindex="1">play</a></li>
									  <li><a href="javascript:;" class="jp-pause" tabindex="1">pause</a></li>
									  <li><a href="javascript:;" class="jp-stop" tabindex="1">stop</a></li>
									  <li><a href="javascript:;" class="jp-mute" tabindex="1" title="mute">mute</a></li>
									  <li><a href="javascript:;" class="jp-unmute" tabindex="1" title="unmute">unmute</a></li>
									  <li><a href="javascript:;" class="jp-volume-max" tabindex="1" title="max volume">max volume</a></li>
									</ul>
									<div class="jp-volume-bar">
									  <div class="jp-volume-bar-value"><xsl:text disable-output-escaping="yes"> </xsl:text></div>
									</div>
									<ul class="jp-toggles">
									  <li><a href="javascript:;" class="jp-full-screen" tabindex="1" title="full screen">full screen</a></li>
									  <li><a href="javascript:;" class="jp-restore-screen" tabindex="1" title="restore screen">restore screen</a></li>
									  <li><a href="javascript:;" class="jp-repeat" tabindex="1" title="repeat">repeat</a></li>
									  <li><a href="javascript:;" class="jp-repeat-off" tabindex="1" title="repeat off">repeat off</a></li>
									</ul>
								  </div>
								  <div class="jp-title">
									<ul>
									  <li>BDPI</li>
									</ul>
								  </div>
								</div>
						  </div>
						</div>
					</div>
                </xsl:when>-->
<!-- Pagina de Video - FIM -->

<!-- 130805 - Dan Shinkai - Implementacao do javascript para permitir a insercao do iframe na pagina de estatisticas. 
		<xsl:text disable-output-escaping="yes">&lt;script type="text/javascript"&gt;</xsl:text>		
			<xsl:if test="/dri:document/dri:body/dri:div/dri:div[@id='aspect.statistics.StatisticsTransformer.div.stats']">
				<xsl:text>										
					ifrm = document.createElement("IFRAME"); 
 				    ifrm.setAttribute("src", "</xsl:text><xsl:value-of select="confman:getProperty('dspace.baseUrl')"/><xsl:text>/a/</xsl:text><i18n:text>paginasEstaticas.acesso</i18n:text><xsl:text>"); 
				    ifrm.setAttribute("frameborder", "0"); 
				    ifrm.setAttribute("scrolling", "no"); 
				    ifrm.style.width = 100+"%"; 
				    ifrm.style.height = 700+"px";    
				    var div = document.getElementById('aspect_statistics_StatisticsTransformer_div_stats');
				    div.appendChild(ifrm); 	
				</xsl:text>
			</xsl:if>
		<xsl:text disable-output-escaping="yes">&lt;/script&gt;</xsl:text>-->
		
    </xsl:template>


    <!-- Currently the dri:meta element is not parsed directly. Instead, parts of it are referenced from inside
        other elements (like reference). The blank template below ends the execution of the meta branch -->
    <xsl:template match="dri:meta">
    </xsl:template>

    <!-- Meta's children: userMeta, pageMeta, objectMeta and repositoryMeta may or may not have templates of
        their own. This depends on the meta template implementation, which currently does not go this deep.
    <xsl:template match="dri:userMeta" />
    <xsl:template match="dri:pageMeta" />
    <xsl:template match="dri:objectMeta" />
    <xsl:template match="dri:repositoryMeta" />
    -->

    <xsl:template name="addJavascript">
	<script type="text/javascript">
	<xsl:attribute name="src">
	 <xsl:value-of select="$context-path/static/js/jquery.min.js"/>
	</xsl:attribute>&#160;</script>	
	
        <!-- Add theme javascipt  -->
        <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='javascript'][@qualifier='url']">
            <script type="text/javascript">
                <xsl:attribute name="src">
                    <xsl:value-of select="."/>
                </xsl:attribute>&#160;</script>
        </xsl:for-each>

        <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='javascript'][not(@qualifier)]">
            <script type="text/javascript">
                <xsl:attribute name="src">
                    <xsl:value-of select="$context-path"/>
                    <xsl:text>/themes/</xsl:text>
                    <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='theme'][@qualifier='path']"/>
                    <xsl:text>/</xsl:text>
                    <xsl:value-of select="."/>
                </xsl:attribute>&#160;</script>
        </xsl:for-each>

        <!-- add "shared" javascript from static, path is relative to webapp root -->
        <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='javascript'][@qualifier='static']">
            <!--This is a dirty way of keeping the scriptaculous stuff from choice-support
            out of our theme without modifying the administrative and submission sitemaps.
            This is obviously not ideal, but adding those scripts in those sitemaps is far
            from ideal as well-->
            <xsl:choose>
                <xsl:when test="text() = 'static/js/choice-support.js'">
                    <script type="text/javascript">
                        <xsl:attribute name="src">
                            <xsl:value-of select="$context-path"/>
                            <xsl:text>/themes/</xsl:text>
                            <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='theme'][@qualifier='path']"/>
                            <xsl:text>/lib/js/choice-support.js</xsl:text>
                        </xsl:attribute>&#160;</script>
                </xsl:when>
                <xsl:when test="not(starts-with(text(), 'static/js/scriptaculous'))">
                    <script type="text/javascript">
                        <xsl:attribute name="src">
                            <xsl:value-of
                                    select="$context-path"/>
                            <xsl:text>/</xsl:text>
                            <xsl:value-of select="."/>
                        </xsl:attribute>&#160;</script>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>

        <!-- add setup JS code if this is a choices lookup page -->
        <xsl:if test="dri:body/dri:div[@n='lookup']">
          <xsl:call-template name="choiceLookupPopUpSetup"/>
        </xsl:if>

        <!--PNG Fix for IE6-->
        <xsl:text disable-output-escaping="yes">&lt;!--[if lt IE 7 ]&gt;</xsl:text>
        <script type="text/javascript">
            <xsl:attribute name="src">
                <xsl:value-of select="$context-path"/>
                <xsl:text>/themes/</xsl:text>
                <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='theme'][@qualifier='path']"/>
                <xsl:text>/lib/js/DD_belatedPNG_0.0.8a.js?v=1</xsl:text>
            </xsl:attribute>&#160;</script>
        <script type="text/javascript">
            <xsl:text>DD_belatedPNG.fix('#ds-header-logo');DD_belatedPNG.fix('#ds-footer-logo');$.each($('img[src$=png]'), function() {DD_belatedPNG.fixPng(this);});</xsl:text>
        &#160;</script>
        <xsl:text disable-output-escaping="yes" >&lt;![endif]--&gt;</xsl:text>


        <script type="text/javascript">
            runAfterJSImports.execute();
        &#160;</script>


        <!-- Add a google analytics script if the key is present -->
        <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='google'][@qualifier='analytics']">
            <script type="text/javascript"><xsl:text>
                   var _gaq = _gaq || [];
                   _gaq.push(['_setAccount', '</xsl:text><xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='google'][@qualifier='analytics']"/><xsl:text>']);
                   _gaq.push(['_trackPageview']);

                   (function() {
                       var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
                       ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
                       var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
                   })();
           </xsl:text>&#160;</script>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>

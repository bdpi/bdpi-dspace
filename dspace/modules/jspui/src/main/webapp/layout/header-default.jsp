<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - HTML header for main home page
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ page import="java.util.List"%>
<%@ page import="java.util.Enumeration"%>
<%@ page import="org.dspace.app.webui.util.JSPManager" %>
<%@ page import="org.dspace.core.ConfigurationManager" %>
<%@ page import="org.dspace.app.util.Util" %>
<%@ page import="javax.servlet.jsp.jstl.core.*" %>
<%@ page import="javax.servlet.jsp.jstl.fmt.*" %>

<%
    String title = (String) request.getAttribute("dspace.layout.title");
    String navbar = (String) request.getAttribute("dspace.layout.navbar");
    boolean locbar = ((Boolean) request.getAttribute("dspace.layout.locbar")).booleanValue();

    String siteURL = request.getContextPath();
    String imageFacebook = siteURL + "/image/logo-usp-facebook.jpg";
    String siteName = ConfigurationManager.getProperty("dspace.name");
    String feedRef = (String) request.getAttribute("dspace.layout.feedref");
    boolean osLink = ConfigurationManager.getBooleanProperty("websvc.opensearch.autolink");
    String osCtx = ConfigurationManager.getProperty("websvc.opensearch.svccontext");
    String osName = ConfigurationManager.getProperty("websvc.opensearch.shortname");
    List parts = (List) request.getAttribute("dspace.layout.linkparts");
    String extraHeadData = (String) request.getAttribute("dspace.layout.head");
    String extraHeadDataLast = (String) request.getAttribute("dspace.layout.head.last");
    String dsVersion = Util.getSourceVersion();
    String generator = dsVersion == null ? "DSpace" : "DSpace " + dsVersion;
    String analyticsKey = ConfigurationManager.getProperty("jspui.google.analytics.key");
%>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:fb="http://ogp.me/ns/fb#">
    <head>
	
	<link href='http://fonts.googleapis.com/css?family=Roboto+Slab:400,700,300&subset=latin,greek-ext,greek' rel='stylesheet' type='text/css'>
	
        <title><%= title%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="Generator" content="<%= generator%>" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <link rel="shortcut icon" href="<%= request.getContextPath()%>/favicon.ico" type="image/x-icon"/>
            <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/jquery-ui-1.10.3.custom/redmond/jquery-ui-1.10.3.custom.css" type="text/css" />
            <!-- <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/bdpi/bdpi.css" type="text/css" /> -->
            <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/bdpi/bdpi-theme.css" type="text/css" />
            <link rel="stylesheet" href="<%= request.getContextPath()%>/static/css/bdpi/dspace-theme.css" type="text/css" />
            <meta name="gs_meta_revision" content="1.1" />
            <%
                if (!"NONE".equals(feedRef)) {
                    for (int i = 0; i < parts.size(); i += 3) {
            %>
            <link rel="alternate" type="application/<%= (String) parts.get(i)%>" title="<%= (String) parts.get(i + 1)%>" href="<%= request.getContextPath()%>/feed/<%= (String) parts.get(i + 2)%>/<%= feedRef%>"/>
			<link href='http://fonts.googleapis.com/css?family=Roboto:400,700,400italic,700italic&subset=latin,latin-ext' rel='stylesheet' type='text/css'>
            <%
                    }
                }

                if (osLink) {
            %>
            <link rel="search" type="application/opensearchdescription+xml" href="<%= request.getContextPath()%>/<%= osCtx%>description.xml" title="<%= osName%>"/>
            <%
                }

                if (extraHeadData != null) {%>
            <%= extraHeadData%>
            <%
                }
            %>

            <script type='text/javascript' src="<%= request.getContextPath()%>/static/js/jquery/jquery-1.11.1.min.js"></script>
            <script type='text/javascript' src='<%= request.getContextPath()%>/static/js/jquery/jquery-ui-1.10.3.custom.min.js'></script>
            <script type='text/javascript' src='<%= request.getContextPath()%>/static/js/bdpi/bdpi.min.js'></script>
            <script type='text/javascript' src='<%= request.getContextPath()%>/static/js/holder.js'></script>
            <script type="text/javascript" src="<%= request.getContextPath()%>/utils.js"></script>
            <script type="text/javascript" src="<%= request.getContextPath()%>/static/js/choice-support.js"></script>
            
            <%--Gooogle Analytics recording.--%>
            <%
                if (analyticsKey != null && analyticsKey.length() > 0) {
            %>
            <script type="text/javascript">
                        var _gaq = _gaq || [];
                        _gaq.push(['_setAccount', '<%= analyticsKey%>']);
                        _gaq.push(['_trackPageview']);
                        (function() {
                        var ga = document.createElement('script');
                                ga.type = 'text/javascript';
                                ga.async = true;
                                ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
                                var s = document.getElementsByTagName('script')[0];
                                s.parentNode.insertBefore(ga, s);
                        })();</script>
                <%
                    }
                    if (extraHeadDataLast != null) {%>
                <%= extraHeadDataLast%>
                <%
                    }
                %>

            <!-- Facebook -->

            <meta property="og:image" content="<%= imageFacebook%>" />
            <meta property="og:site_name" content="<%= siteName%>"/>
            <meta property="og:url" content=<%= siteURL%>${requestScope['javax.servlet.forward.request_uri']} />
            <meta property="og:description" content="Acesse este artigo na BDPI USP" />
            <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
            <!--[if lt IE 9]>
              <script src="<%= request.getContextPath()%>/static/js/html5shiv.js"></script>
              <script src="<%= request.getContextPath()%>/static/js/respond.min.js"></script>
            <![endif]-->
    </head>
    <div id="uspbarra" style="background-color:transparent;border-style:none">
        <div class="uspLogo"  style="background-color:transparent;border-style:none">
            <img class="img-responsive" onclick="javascript:window.open('http://www.usp.br');" alt="USP" style="cursor:pointer;position: absolute;bottom: 0px;" src="<%= siteURL%>/image/Logo_usp_composto.jpg" />
         </div>
        <div class="panel-group" id="accordion"  style="background-color:transparent;border-style:none">
            <div class="panel" style="background-color:transparent;border-style:none">
                                     <div id="collapseThree" class="panel-collapse collapse" style="background-color:transparent">
                                                        <div class="panel-body usppanel" style="background-color:#b3b3bc">
                                                            <div class="row" style="background-color:transparent">
                                                                <div class="col-md-3 text-center">
                                                                    <a href=http://www.usp.br/sibi/><img src="http://www.producao.usp.br/a/barrausp/images/sibi.png" title="SIBi - Sistema Integrado de Bibliotecas da USP" width=150 height=69 border=0 /></a>
                                                                    <div class="uspmenu_top_usp">
                                                                        <ul>
                                                                            <li><a href="http://www.producao.usp.br/a/barrausp/barra/creditos.html" target=_blank>Créditos</a></li>
                                                                            <li><a href="http://www.producao.usp.br/a/barrausp/barra/contato.html" target=_blank>Fale com o SIBi</a></li>
                                                                            <div><img src="http://www.producao.usp.br/a/barrausp/images/spacer.gif" width=10 height=10 /></div>
                                                                            <div class="panel-heading">PORTAL DE BUSCA INTEGRADA</div>
                                                                            <div class="panel-body">Um único ponto de acesso a todos os conteúdos informacionais disponíveis para a comunidade USP.</div>
                                                                            <br />
                                                                            <form class="form-inline" role="form" method="get" name="busca" action="http://www.buscaintegrada.usp.br/primo_library/libweb/action/search.do" onsubmit="if (document.getElementById(\'mySearch\').value==\'Busca geral...\'||document.getElementById(\'mySearch\').value==\'\'){alert(\'Preencha o campo de busca!\ return false;} else {return true;}" >
                                                                                <input type hidden name="dscnt" value="0">
                                                                                <input type hidden name="frbg" value="">
                                                                                <input type hidden name="scp.scps" value=\'scope:("USP"),primo_central_multiple_fe\'>
                                                                                <input type hidden name="tab" value="default_tab" >
                                                                                <input type hidden name="dstmp" value="1330609813304" >
                                                                                <input type hidden name="srt" value="rank" >
                                                                                <input type hidden name="ct" value="search" >
                                                                                <input type hidden name="mode" value="Basic" >
                                                                                <input type hidden name="dum" value="true" >
                                                                                <input type hidden name="indx" value="1" >
                                                                                <input type hidden name="tb" value="t" >
                        <input type hidden name="fn" value="search" >
                            <input type hidden name="vid" value="USP" >
                                <div class="form-group">
                                    <input type="text" name="vl(freeText0)" id="mySearch" size=22  value="Busca geral..."  onfocus="this.value = ''" tabindex=1 />
                                </div>
                                <div class="form-group">    
                                    <input type="submit" value="Buscar" tabindex=2 >
                                </div>            

                                </form>                                
                                </ul>
                                </div>
                                </div>
                                <div class="col-md-3">
                                    <ul class="uspmenu_top_usp">
                                        <div class="panel-heading">BIBLIOTECAS USP</div>
                                        <li><a href="http://www.bibliotecas.usp.br/lista.htm" target="_blank">Lista alfabética</a></li>
                                        <li><a href="http://www.sibi.usp.br/30anos" target="_blank">SIBiUSP 30 Anos</a></li>
                                    </ul>
                                    <ul class="uspmenu_top_usp">
                                        <ul class="uspmenu_top_usp">
                                            <div class="panel-heading">PRODUTOS E SERVIÇOS</div>
                                            <li><a href="http://www.acessoaberto.usp.br/" target="_blank">Acesso Aberto</a></li>
                                            <li><a href="http://dedalus.usp.br/" target="_blank">Acesso ao catálogo Dedalus</a></li>
                                            <li><a href="http://www.buscaintegrada.usp.br" target="_blank">Portal de Busca Integrada</a></li>
                                            <li><a href="http://www.sibi.usp.br/Vocab/" target="_blank">Vocabulário Controlado</a></li>
                                            <li><a href="http://workshop.sibi.usp.br/index.php"  target="_blank">Writing Center - WorkShops</a></li>
                                        </ul>
                                    </ul>
                                </div>
                                <div class="col-md-3">
                                    <ul class="uspmenu_top_usp">	
                                        <div class="panel-heading">BIBLIOTECAS DIGITAIS</div>
                                        <li><a href="http://bore.usp.br" target="_blank">Obras Raras e Especiais</a></li>
                                        <li><a href="http://revistas.usp.br" target="_blank">Portal de Revistas</a></li>
                                        <li><a href="http://www.producao.usp.br" target="_blank">Biblioteca Digital da Produção Intelectual (BDPI)</a></li>
                                    </ul>
                                    <ul class="uspmenu_top_usp">
                                        <div class="panel-heading">PARCERIAS INTERNAS</div>
                                        <li><a href="http://repositorio.iau.usp.br" target="_blank">Repositório Digital IAU</a></li>
                                        <li><a href="http://www.brasiliana.usp.br" target="_blank">Biblioteca Digital Brasiliana</a></li>
                                        <li><a href="http://www.ieb.usp.br/catalogo_eletronico" target="_blank">Biblioteca Digital do IEB</a></li>
                                        <li><a href="http://www.mapashistoricos.usp.br" target="_blank">Cartografia Histórica</a></li>
                                        <li><a href="http://www.teses.usp.br" target="_blank">Teses/Dissertações</a></li>

                                    </ul>                        
                                </div>
                                <div class="col-md-3">
                                    <ul class="uspmenu_top_usp">
                                        <div class="panel-heading">PARCERIAS EXTERNAS</div>
                                        <li><a href="http://regional.bvsalud.org/php/index.php" target="_blank">BVS em Saúde</a></li>
                                        <li><a href="http://enfermagem.bvs.br/php/index.php" target="_blank">BVS em Enfermagem</a></li>
                                        <li><a href="http://odontologia.bvs.br" target="_blank">BVS em Odontologia</a></li>
                                        <li><a href="http://www.bvs-psi.org.br"  target="_blank">BVS Psicologia Brasil</a></li>
                                        <li><a href="http://www.saudepublica.bvs.br/php/index.php" target="_blank">BVS em Saúde Pública</a></li>
                                        <li><a href="http://www.bvmemorial.fapesp.br" target="_blank">Biblioteca Virtual da América Latina</a></li>
                                        <li><a href="http://www.bv.fapesp.br" target="_blank">Biblioteca Virtual da FAPESP</a></li>
                                        <li><a href="http://ppegeo.igc.usp.br/scielo.php" target="_blank">PaGEO (Geociências)</a></li>
                                        <li><a href="http://www.periodicos.capes.gov.br" target="_blank">Portal CAPES</a></li>
                                        <li><a href="http://www.scielo.org/php/index.php?lang=pt" target="_blank">SciELO</a></li>
                                    </ul>                        
                                </div>                    
                                </div>
                                </div>
                                </div>
                <div class="usptab" style="border-style:none;background-color:transparent;" style="position:relative;">
                    <ul class="usplogin" style="border-style:none;" >
                        <li class="uspleft" style="position:relative; z-index:0"></li>
                        <li id="usptoggle" style="position:relative; z-index:0">
                            <a data-toggle="collapse" data-parent="#accordion" href="#collapseThree" id="uspopen" class="uspopen" border="0" style="display: block;">
                                <img src="http://www.producao.usp.br/a/barrausp/images/seta_down.jpg" border="0">
                                    <img src="http://www.producao.usp.br/a/barrausp/images/barrinha.png" alt="SIBi - Abrir o painel" width="35" height="16" border="0" title="SIBi - Abrir o painel">
                                        </a>
                                        <a data-toggle="collapse" data-parent="#accordion" href="#collapseThree" id="uspclose" style="display: none;" class="uspclose" border="0">
                                            <img src="http://www.producao.usp.br/a/barrausp/images/seta_up.jpg" border="0">
                                                <img src="http://www.producao.usp.br/a/barrausp/images/barrinha.png" width="35" height="16" border="0" title="SIBi - Fechar painel" alt="SIBi - Fechar painel">
                                                    </a>
                        </li>
                        <li class="uspright" style="background-color:transparent" style="position:relative; z-index:0; display:visible"></li>
                                                    </ul>
                                                    </div> </div>              
                                </div>
                                </div>
                                 
						
						<!-- uspbarra -->  
                        

						<body class="undernavigation" onload="tamanho();" onresize="tamanho()" style="background-color:#b3b3bc;" >
                                    <a class="sr-only" href="#content">Skip navigation</a>
                                    <div class="container" id="container" style="top:-20px; background-color:#FFF;">
                                        <div class="row" style="top:-36px; background-color:#FFF;">
											
											<div class="cruesplink" style="float:right; position:relative;">
												
												<div class="cruesplinkout" style="float:right; background-color:#FFF;">
												  <a href="http://www.cruesp.sp.gov.br/" target="blank" alt="CRUESP"><img src="<%= siteURL%>/image/cruesppeb.png" style="width:75px;"></a>
												</div>
												<div class="cruesplinkin" style="position:relative; float:right; top:-21px; left:0.5px;display:none;">
												  <a href="http://www.cruesp.sp.gov.br/" target="blank" alt="CRUESP"><img src="<%= siteURL%>/image/cruesp.png" style="width:75px; display: hidden"></a>
												</div>											
											</div>
											
                                            <div class="col-md-8">
                                                <div class="logo"><br><br>
                                                    <a href="<%= siteURL%>"><img class="img-responsive" src="<%= siteURL%>/image/producao.usp.png"></a>
                                                <br>
												</div>
										
                                                </div>
                                           </div>
											<h6 style="position:relative; text-align:right; font-weight: 700; margin:0; top:-6px">
											<a href="?locale=pt_BR">Portugu&ecirc;s</a> | <a href="?locale=en">English</a> | <a href="?locale=es">Espa&ntilde;ol </a>
											&nbsp;</h6>
											
																					
																	<header class="navbar navbar-inverse" role="navigation">
                                                                        <%
                                                                            if (!navbar.equals("off")) {
                                                                        %>

                                                                        <dspace:include page="<%= navbar%>" />

                                                                        <%
                                                                        } else {
                                                                        %>

                                                                        <dspace:include page="/layout/navbar-minimal.jsp" />

                                                                        <%
                                                                            }
                                                                        %>
                                                                    </header>


                                                                    <%-- Page contents --%>

                                                                    <% if (request.getAttribute("dspace.layout.sidebar") != null) { %>
                                                                    <div class="row">

                                                                        <% }%>
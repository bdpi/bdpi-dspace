<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Home page JSP
  -
  - Attributes:
  -    communities - Community[] all communities in DSpace
  -    recent.submissions - RecetSubmissions
--%>

<%@page import="org.dspace.content.Bitstream"%>
<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="java.io.File" %>
<%@ page import="java.util.Enumeration"%>
<%@ page import="java.util.Locale"%>
<%@ page import="javax.servlet.jsp.jstl.core.*" %>
<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>
<%@ page import="org.dspace.core.I18nUtil" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.app.webui.components.RecentSubmissions" %>
<%@ page import="org.dspace.content.Community" %>
<%@ page import="org.dspace.core.ConfigurationManager" %>
<%@ page import="org.dspace.core.NewsManager" %>
<%@ page import="org.dspace.browse.ItemCounter" %>
<%@ page import="org.dspace.content.DCValue" %>
<%@ page import="org.dspace.content.Item" %>
<%@ page import="org.apache.commons.lang.StringUtils"%>

<%
    Community[] communities = (Community[]) request.getAttribute("communities");

    Locale[] supportedLocales = I18nUtil.getSupportedLocales();
    Locale sessionLocale = UIUtil.getSessionLocale(request);
    Config.set(request.getSession(), Config.FMT_LOCALE, sessionLocale);

    String[][] displayAuthors;

    boolean feedEnabled = ConfigurationManager.getBooleanProperty("webui.feed.enable");
    String feedData = "NONE";
    if (feedEnabled) {
        feedData = "ALL:" + ConfigurationManager.getProperty("webui.feed.formats");
    }

    ItemCounter ic = new ItemCounter(UIUtil.obtainContext(request));

    RecentSubmissions submissions = (RecentSubmissions) request.getAttribute("recent.submissions");
%>
<dspace:layout locbar="nolink" titlekey="jsp.home.title" feedData="<%= feedData%>">

<script type="text/javascript">
function tamanho(){

	if( window.innerWidth >= 1050 ){
	//javascript para este tamanho de tela
	}															   
	else{
	//javascript para os demais
	}
}
window.onresize = tamanho;
</script>

<!-- Go to www.addthis.com/dashboard to customize your tools -->
<script type="text/javascript" src="//s7.addthis.com/js/300/addthis_widget.js#pubid=ra-545bb59855d48cfe" async="async"></script>


<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
<script>
$(document).ready(function(){

$('#showmoreshare').on('click', function(){
	$('#allshare').show();
	$('span#showmoreshare').hide();
	$('span#showlessshare').show();
});
$('#showlessshare').on('click', function(){
	$('#allshare').hide();
	$('span#showmoreshare').show();
	$('span#showlessshare').hide();
});

//Para mudar a cor do Cruesp
	
		$(".cruesplink").mouseenter(function() {
				$(".cruesplinkin").show();
	})
			  .mouseleave(function() {
				$(".cruesplinkin").hide();
	})

	
//Para carregar as submissoes recentes.

$("div#recentSubmissions").hide();
$("div#recentSubmissions").first().attr("id","submitFixa");      // p = .classesubmissoes
$("div#recentSubmissions").first().next().attr("id","submitFixa");
$("div#recentSubmissions").first().next().next().attr("id","submitFixa");

$("div#submitFixa").show();
$("span#show").show();
$("span#hide").hide();

$('span#show').css( 'cursor', 'pointer' );
$('span#hide').css( 'cursor', 'pointer' );

    $("span#show").click(function(){
    $("div#recentSubmissions").show(1000);                             // p = .classesubmissoes
	$("span#show").hide();				
	$("span#hide").show();
  });
  $("span#hide").click(function(){
    $("div#recentSubmissions").fadeOut(500);                             // p = .classesubmissoes
	$("span#show").show();
	$("span#hide").hide();
  });
});
</script>

<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>	

<div class="row">
    <div class="col-md-8" id="jumbocol" style="width:100%;top:-25px; z-index:0; padding:1px;">
        <div class="jumbotron" id="jumbotron" style=" padding:20px; margin-bottom:0px;">
            <div class="box" style="max-width:500px;max-width:75%; border-width:0;">
                <div style="position:relative; float:left; margin:0; padding:0; top:-5px;">
				<h4 class="chamada" style="font-family: 'Roboto', sans-serif;">Conheça a BDPI</div>
				</h4>
				
	            <p style="font-size:14px;max-width:400px;letter-spacing:0; font-weight:400;position:relative; clear:both; padding-top:10px;">A Biblioteca Digital da Produção Intelectual da Universidade de São Paulo (BDPI) é um sistema de gestão e disseminação da produção científica, acadêmica, técnica e artística gerada pelas pesquisas desenvolvidas na USP.</p>
            </div>
			
			<!-- Botões de compartilhamento que não funcionam mais	

                    
			-->
				
		</div>
	</div>
</div>


			
<div class="row"  style="clear:left">
    <div class="col-md-8" style="position:relative; float:left; margin-top:0px; margin-bottom:0;">
					<%
						if (submissions != null && submissions.count() > 0) {
					%>

					
		<div class="panel" class="col-md-8" style="padding:10px;  border-bottom-style:solid; border-bottom-width:2px; border-bottom-color:#fcb421; border-top-style:solid; border-top-width:2px; border-top-color:#fcb421; background-color:#f5f5f5;">
			<div class="panel-heading">
				<h2> <fmt:message key="jsp.collection-home.recentsub"/>
								<%
									if (feedEnabled) {
										String[] fmts = feedData.substring(feedData.indexOf(':') + 1).split(",");
										String icon = null;
										int width = 0;
										for (int j = 0; j < fmts.length; j++) {
											if ("rss_1.0".equals(fmts[j])) {
												icon = "rss1.gif";
												width = 80;
											} else if ("rss_2.0".equals(fmts[j])) {
												icon = "rss2.gif";
												width = 80;
											} else {
												icon = "rss.gif";
												width = 36;
											}
								%>
					<a href="<%= request.getContextPath()%>/feed/<%= fmts[j]%>/site"><img src="<%= request.getContextPath()%>/image/<%= icon%>" alt="RSS Feed" width="<%= width%>" height="15" vspace="3" border="0" /></a>
									<%
											}
										}
									%>
				</h2>
			</div>

						<%
							boolean first = true;
							for (Item item : submissions.getRecentSubmissions()) {
								DCValue[] dcv = item.getMetadata("dc", "title", null, Item.ANY);
								String displayTitle = "Untitled";
								if (dcv != null & dcv.length > 0) {
									displayTitle = dcv[0].value;
								}
								dcv = item.getMetadata("dc", "contributor", "author", Item.ANY);
								if (dcv != null & dcv.length > 0) {
									displayAuthors = new String[dcv.length][2];
									for (int dcvcounter = 0; dcvcounter < dcv.length; dcvcounter++) {
										displayAuthors[dcvcounter][0] = dcv[dcvcounter].value;
										displayAuthors[dcvcounter][1] = dcv[dcvcounter].authority;
									}
								} else {
									displayAuthors = new String[1][2];
									displayAuthors[0][0] = "";
									displayAuthors[0][1] = "";
								}
								dcv = item.getMetadata("dc", "description", "abstract", Item.ANY);
								String displayAbstract = "";
								if (dcv != null & dcv.length > 0) {
									displayAbstract = dcv[0].value;
								}
								dcv = item.getMetadata("dc", "rights", null, Item.ANY);
								String displayRights = "";
								if (dcv != null & dcv.length > 0) {
									displayRights = dcv[0].value;
								}
						%>
			<div class="media padding15" id="recentSubmissions">
				<a class="pull-left" href="#">
								<% if (displayRights.equals("openAccess")) {%>
					<img class="pull-left" src="image/32px-Open_Access_logo_PLoS_white.svg.png" height="32px">
								<% } else { %>
					<img class="pull-left" src="image/32px-Closed_Access_logo_white.svg.png" height="32px">
								<% }%>
				</a>
				<div class="media-body col-md-11">
					<a href="<%= request.getContextPath()%>/handle/<%=item.getHandle()%>"><h4 class="media-heading"><%=StringUtils.abbreviate(displayTitle, 400)%>﻿</h4></a>
					<p style="font-style:italic;"><%
									int maxcount;
									String etal = "";
									if (displayAuthors.length > 10) {
										maxcount = 10;
										etal = " et al";
									} else {
										maxcount = displayAuthors.length;
									}
									for (int acount = 0; acount < maxcount; acount++) { %>
										<% if (acount > 0) { %>; <% }%>
										<% if(displayAuthors[acount][1]!=null){ %>
					<a class="authority author" href="/browse?type=author&authority=<%=displayAuthors[acount][1]%>"><%=StringUtils.abbreviate(displayAuthors[acount][0], 1000)%></a> <img src="<%=request.getContextPath()%>/image/ehUSP.png">
										<% } else { %>
										  <%=StringUtils.abbreviate(displayAuthors[acount][0], 1000)%>
										<% } %>
									<% }%><%=etal%></p>
					<p style="font-size:13px;"><%= StringUtils.abbreviate(displayAbstract, 500)%></p>
				</div>
			</div>
						<%
								first = false;
							}
						%>
		<br>
		</div>

		<!-- Exibição de mais submissões -->

		<center>	
		<div style="position:relative; float:right; top:-60px; right:0px; width:40px; height:40px; margin: auto; color: #eee; background-color:#cfcfd2; font-size:30px;
			border-left-style:solid; 
			border-left-width:2px; 
			border-left-color:#fcb421;
			border-top-style:solid; 
			border-top-width:2px; 
			border-top-color:#fcb421;">
			<span id="show" class="glyphicon glyphicon-plus" style="left:1px;"></span>
			<span id="hide" class="glyphicon glyphicon-minus" style="left:-2px;"></span>
		</center>
					<%}%>
		</div>

		<!-- Notícias -->
		
			

				
			<div id="news" style="margin-bottom:30px;position:relative; float:right;padding:10px;position:relative;border-bottom-style:solid; border-bottom-width:2px; border-bottom-color: #64c4d2; border-top-style:solid; border-top-width:2px; border-top-color: #64c4d2; background-color:#f5f5f5;">
		
			<div class="panel-heading">
			<h2 style="font-family: 'Roboto', sans-serif;">  <span class="glyphicon glyphicon-list-alt" style="position:relative; top:2px;"></span> <fmt:message key="jsp.collection-home.latestnews"/>
			<a href=" http://www5.usp.br/feed/?categorias-s=bibliotecas-e-bases-de-dados-usp-infra-estrutura-nos-campi-usp,parcerias-e-convenios-usp-instituicoes-estrangeiras-internacionalizacao-usp,pesquisas-e-grupos-de-pesquisa-usp-pesquisas-pesquisadores-e-inovacao-usp"><img src="image/rss2.gif"></a>
			</h2>
			</div>
		
			<script language="JavaScript" src="http://feed2js.org//feed2js.php?src=http%3A%2F%2Fwww5.usp.br%2Ffeed%2F%3Fcategorias-s%3Dbibliotecas-e-bases-de-dados-usp-infra-estrutura-nos-campi-usp%2Cparcerias-e-convenios-usp-instituicoes-estrangeiras-internacionalizacao-usp%2Cpesquisas-e-grupos-de-pesquisa-usp-pesquisas-pesquisadores-e-inovacao-usp&num=2&desc=200&au=y&utf=y&html=p"  charset="UTF-8" type="text/javascript"></script>

<noscript>
<a href="http://feed2js.org//feed2js.php?src=http%3A%2F%2Fwww5.usp.br%2Ffeed%2F%3Fcategorias-s%3Dbibliotecas-e-bases-de-dados-usp-infra-estrutura-nos-campi-usp%2Cparcerias-e-convenios-usp-instituicoes-estrangeiras-internacionalizacao-usp%2Cpesquisas-e-grupos-de-pesquisa-usp-pesquisas-pesquisadores-e-inovacao-usp&num=2&desc=200&au=y&utf=y&html=y">View RSS feed</a>
</noscript>


		<div style="margin-bottom:40px;">
		<small style="position:relative; float:right; ">fonte: <a href="http://www.usp.br/agen/" target="_blank" style="color:#64c4d2;">Agencia USP de Notícias</a>.</small>
		</div>
		<div class="panel-heading">
			<h2 style="font-family: 'Roboto', sans-serif;"><span class="glyphicon glyphicon-time" style="position:relative; top:3px;"></span> <fmt:message key="jsp.collection-home.events"/>
			<a href="http://www.eventos.usp.br/?event-types=cultura-e-artes&feed=rss2"><img src="image/rss2.gif"></a>
			</h2>
			</div>
		
			<script language="JavaScript" src="http://feed2js.org//feed2js.php?src=http%3A%2F%2Fwww.eventos.usp.br%2F%3Fevent-types%3Dcultura-e-artes%26feed%3Drss2&num=2&desc=200&au=y&utf=y&html=p"  charset="UTF-8" type="text/javascript"></script>

<noscript>
<a href="http://feed2js.org//feed2js.php?src=http%3A%2F%2Fwww.eventos.usp.br%2F%3Fevent-types%3Dcultura-e-artes%26feed%3Drss2&num=2&desc=200&au=y&utf=y&html=y">View RSS feed</a>
</noscript>



			
			<!--
			<div class="media padding15">
				<a class="pull-left" href="#">
					<span class="glyphicon glyphicon-list-alt icon"></span>
				</a>
				<div class="media-body">
					<h2 class="media-heading" style="color:#696969;">Media heading</h2>
					Cras sit amet nibh libero, in gravida nulla. Nulla vel metus scelerisque ante sollicitudin commodo. Cras sit amet nibh libero, in gravida nulla. Nulla vel metus scelerisque ante sollicitudin commodo.<br/><br/><a class="btn btn-primary" href="#" role="button">Leia mais...</a>
				</div>
			</div>
					
			<div class="media padding15">
				<a class="pull-left" href="#">
					<span class="glyphicon glyphicon-list-alt icon"></span>
				</a>
				<div class="media-body">
					<h4 class="media-heading" style="color:#696969">Media heading</h4>
					Cras sit amet nibh libero, in gravida nulla. Nulla vel metus scelerisque ante sollicitudin commodo. Cras purus odio, vestibulum in vulputate at, tempus viverra turpis.<br/><br/><a class="btn btn-primary" href="#" role="button">Leia mais...</a>
				</div>
			</div>

			<div class="media padding15">
				<a class="pull-left" href="#">
					<span class="glyphicon glyphicon-list-alt icon"></span>
				</a>
				<div class="media-body">
					<h4 class="media-heading" style="color:#696969">Media heading</h4>
					Cras sit amet nibh libero, in gravida nulla. Nulla vel metus scelerisque ante sollicitudin commodo. Cras purus odio, vestibulum in vulputate at, tempus viverra turpis.<br/><br/><a class="btn btn-primary" href="#" role="button">Leia mais...</a>
				</div>
			</div> -->
		</div>

		<!-- Notas de rodapé -->
			
		<div style="max-width:900px;min-height:309px;margin-left:auto; margin-right:auto; margin-top:20px; border-top-width:2px; border-top-color:#EEE; clear:both" class="container-notasdorodape">
			<center>
			<div class="col-lg-4" id="notasdorodape">
				<span class="glyphicon glyphicon-floppy-open iconbg"></span>
				<h3>Como depositar</h3>
				<h4><small><p>Donec sed odio dui. Etiam porta sem malesuada magna mollis euismod. Nullam id dolor id nibh ultricies vehicula ut id elit. Morbi leo risus, porta ac consectetur ac, vestibulum at eros. Praesent commodo cursus magna.</p></small></h4>
				<p><a class="btn btn-primary pull-right" href="#" role="button" style="position:relative;left:-60px">Saiba mais »</a></p>
				</br></br>
			</div>
				<!-- /.col-lg-4 -->
			<div class="col-lg-4" id="notasdorodape" >
				<span class="glyphicon glyphicon-comment iconbg"></span>
				<h3>Como citar</h3>
				<h4 style="line-height:300%; letter-spacing:0px;"><small><p style="text-align:justufy">Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Cras mattis consectetur purus sit amet fermentum. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh.</p></small>
				</h4>
				<p><a class="btn btn-primary pull-right" href="#" role="button" style="position:relative;left:-60px">Saiba mais »</a>
				</p>
				</br></br>
			</div>
				<!-- /.col-lg-4 -->
			<div class="col-lg-4" id="notasdorodape">
				<span class="glyphicon glyphicon-pencil iconbg"></span>
				<h3>BDPI em números</h3>
				<!--<h4>
					<div style="width:100px">
						<dl class="dl-horizontal" style="width:300px">
							<dt>Unidades</dt>
							<dd>42</dd>
							<dt>Departamentos</dt>
							<dd>127</dd>
							<dt>Registros</dt>
							<dd>38000</dd>
							<dt>Texto completo</dt>
							<dd>38000</dd>
						</dl>
					</div>
				</h4>-->
				
					<div style="text-align:center;">
					<h4 style="line-height:300%; letter-spacing:0px;"><small><p style="text-align:center; overflow:show;">
					<table style="width:100%">
  <tr>
    <td style="text-align:right;"><span style="font-weight:bold; font-size:16px;">42</span></td>
    <td>Unidades</td>
  </tr>
  <tr>
    <td style="text-align:right;"><span style="font-weight:bold; font-size:16px;">127</span> </td>
    <td>Departamentos</td>
  </tr>
  <tr>
    <td style="text-align:right;"><span style="font-weight:bold; font-size:16px;">38000</span></td>
    <td>Registros</td>
  </tr>
  <tr>
    <td style="text-align:right;"><span style="font-weight:bold; font-size:16px;">38000</span></td>
    <td>Textos completos</td>
  </tr>
  </table>
				
					</p></small>
					</h4>
					
			</div>
			</center>
		</div>

			</dspace:layout>

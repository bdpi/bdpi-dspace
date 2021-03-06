<!-- Toda a parte de CSS está no arquivo src/dspace/modules/jspui/src/main/webapp/static/css/bdpi/bdpi-theme.css  -->

<%@page import="org.dspace.app.webui.util.UIUtil"%>
<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ page import="java.net.URLEncoder"            %>
<%@ page import="java.util.Iterator"             %>
<%@ page import="java.util.Map"                  %>
<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>
<%@ page import="org.dspace.content.Collection"  %>
<%@ page import="org.dspace.content.DCValue"    %>
<%@ page import="org.dspace.content.Item"        %>



﻿


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
<script type="text/javascript" src="//s7.addthis.com/js/300/addthis_widget.js#pubid=ra-545bb59855d48cfe" async="async"></script>
-
<script type="text/javascript">
//CASO EU PRECISE FAZER MUDANÇAS NO LAYOUT RESPONSIVO QUE EU NÃO CONSIGA COM CSS
function tamanho(){
	
	if( window.innerWidth >= 992 ){
	getElementById('subs').style.height=350;
	}															   
	else{
	//javascript para os demais
	}
	
}
window.onresize = tamanho;
</script>

<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
<script>
$(document).ready(function(){
//Para não mostrar todas as submissões recentes na primeira página
$("div#recentSubmissions").hide();
$("div#recentSubmissions").slice(0,3).show();
var first = 0;
var last = 3;
	if(first==0){
	$("button#lessRecSub").hide();
	}

$("button#moreRecSub").click(function(){
	$("button#lessRecSub").show();
	first = first + 3;
	last = last + 3;
	$("div#recentSubmissions").hide();
	$("div#recentSubmissions").slice(first,last).fadeIn();
		if(last > 19){
		$("button#moreRecSub").hide();
		}
});

$("button#lessRecSub").click(function(){
$("button#moreRecSub").show();
first = first - 3;
last = last - 3;
$("div#recentSubmissions").hide();
$("div#recentSubmissions").slice(first,last).fadeIn();
	if(first == 0){
		$("button#lessRecSub").hide();
		}
});


});
</script>

<div class="row" class="jumbohold" style="padding:1px">
	<div class="jumbotron" id="jumbotron" style="position:relative;  top:-42px;">
		<div class="box">
			<div class="chamada">
				<h4 class="chamada2">
				
				
				<fmt:message key="usp.home.bdpititle"/>
				</h4>
			</div>
			<p class="bdpi-descricao">
			<fmt:message key="usp.home.bdpidescription"/>	
			</p>
		</div>
	</div>
</div>
	
<div id="creditodafoto"><p> Foto: Marcos Santos / USP Imagens.</p></div>							
			<div  class="effect2">
<div class="row">
    <div class="col-md-12" class="sub-holder">
					<%
						if (submissions != null && submissions.count() > 0) {
					%>

					
		<div   class="col-md-12" id="subs">
					<h2 class="h2-subs"> <span class="glyphicon glyphicon-book" class="sub-icon"></span> <fmt:message key="jsp.collection-home.recentsub"/>
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
			<div class="col-md-12" id="recentSubmissions">
				<a class="pull-left" href="#">
								<% if (displayRights.equals("openAccess")) {%>
					<img class="pull-left" src="image/32px-Open_Access_logo_PLoS_white.svg.png" height="32px" style="margin:5px; position:relative; top:-6px" alt="Open Access logo">
								<% } else { %>
					<img class="pull-left" src="image/32px-Closed_Access_logo_white.svg.png" height="32px" style="margin:5px; position:relative; top:-6px" alt="Closed Access logo">
								<% }%>
				</a>
				<div class="media-body col-md-11">
					<a href="<%= request.getContextPath()%>/handle/<%=item.getHandle()%>" style="color: #607890; font-weight:300;"><h4 class="media-heading" style="font-size:13.5px"><%=StringUtils.abbreviate(displayTitle, 400)%>﻿</h4></a>
					<p><%
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
					<a class="authority author" style="color: #FF8700; font-size:0.9em; font-weight:400" href="/browse?type=author&authority=<%=displayAuthors[acount][1]%>"><%=StringUtils.abbreviate(displayAuthors[acount][0], 1000)%></a> <img src="<%=request.getContextPath()%>/image/ehUSP.png" alt="usp author" style="height:1em">
										<% } else { %>
										  <span style="color: #FF8700; font-size:0.9em; font-weight:400"><%=StringUtils.abbreviate(displayAuthors[acount][0], 1000)%></span>
										<% } %>
									<% }%><%=etal%></p>
					<p style="font-size:13px"><%= StringUtils.abbreviate(displayAbstract, 500)%></p>
				</div>
			</div>
						<%
								first = false;
							}
						%>
		</br></br></br>
		
		<button id="lessRecSub"><span class="glyphicon glyphicon-chevron-left"></span></button>
		<button id="moreRecSub"><span class="glyphicon glyphicon-chevron-right"></span></button>
		
		</div>
</div>
		<!-- Exibição de mais submissões -->
	<!--
	<div style="height:40px;width:40px; position:relative; float:right; color:gray; background-color:#eee;padding:5px;top:-62px">
			<center><h1><span id="show" class="glyphicon glyphicon-hand-right" style="left:1px;"></span>
	</h1>
	</div>-->
		
					<%}%>
					</div>
		
<link href='http://fonts.googleapis.com/css?family=Roboto+Slab:400,700' rel='stylesheet' type='text/css'>
		<!-- Notícias -->
		<!--<div id="news" class="col-md-12" style="margin-bottom:30px;position:relative; float:right;padding:10px;position:relative;border-bottom-style:solid; border-bottom-width:2px; border-bottom-color:  #1094ab; border-top-style:solid; border-top-width:2px; border-top-color:  #1094ab; background-color:#f5f5f5;">-->
			
			
			
			
			
		
</div>

			
			
			
			

	
	
	</br></br>
	
	<div class="row" style="padding:10px;margin-top:15px" >
<div class="col-md-8">
			<h2 class="h2-subs">  <span class="glyphicon glyphicon-list-alt" class="sub-icon"></span> <fmt:message key="jsp.collection-home.latestnews"/>
			
			</h2>
			
			<div class="col-md-6" style="padding:10px">			
<div style="width:100%; font-size:12px; background-color:#696969; color:#eee; clear:both; font-weight:700;font-family:'Roboto', sans-serif; height:26px; padding:5px">Confederation of Open Access Repositories</div>






<div id="rss">
      <script type="text/javascript">
              
                    rssmikle_url="https://www.coar-repositories.org/feed/";
                    rssmikle_frame_width="100%";
                    rssmikle_frame_height="200";
                    rssmikle_target="_blank";
                    rssmikle_font="'Roboto', sans-serif";
                    rssmikle_font_size="12";
                    rssmikle_border="off";
                    rssmikle_css_url="";
                    autoscroll="off";
                    rssmikle_title="off";
                    rssmikle_title_bgcolor="#696969";
                    rssmikle_title_color="#f5f5f5";
                    rssmikle_title_bgimage="http://";
                    rssmikle_item_bgcolor="#f5f5f5";
                    rssmikle_item_bgimage="http://";
                    rssmikle_item_title_length="90";
                    rssmikle_item_title_color="#1094ab";
                    rssmikle_item_border_bottom="on";
                    rssmikle_item_description="on";
                    rssmikle_item_description_length="150";
                    rssmikle_item_description_color="#666666";
                    rssmikle_item_date="off";
                    rssmikle_item_description_tag="off";
                    rssmikle_item_podcast="off";
             
                </script>
      <script type="text/javascript" src="http://widget.feed.mikle.com/js/rssmikle.js"></script>
      <div style="font-size:10px; text-align:right; width:215px;"></div>
</div>
<div id="rss">
<script type="text/javascript">
                    
                    rssmikle_url="http://www.opendoar.org/rss1data.php";
                    rssmikle_frame_width="100%";
                    rssmikle_frame_height="150";
                    rssmikle_target="_blank";
                    rssmikle_font="'Roboto', sans-serif";
                    rssmikle_font_size="12";
                    rssmikle_border="off";
                    rssmikle_css_url="";
                    autoscroll="off";
                    rssmikle_title="on";
                    rssmikle_title_bgcolor="#696969";
                    rssmikle_title_color="#f5f5f5";
                    rssmikle_title_bgimage="http://";
                    rssmikle_item_bgcolor="#f5f5f5";
                    rssmikle_item_bgimage="http://";
                    rssmikle_item_title_length="100";
                    rssmikle_item_title_color="#666666";
                    rssmikle_item_border_bottom="on";
                    rssmikle_item_description="off";
                    rssmikle_item_description_length="150";
                    rssmikle_item_description_color="#666666";
                    rssmikle_item_date="off";
                    rssmikle_item_description_tag="off";
                    rssmikle_item_podcast="off";
                </script>
      <script type="text/javascript" src="http://widget.feed.mikle.com/js/rssmikle.js"></script>
      <div style="font-size:10px; text-align:right; width:215px;"></div>
</div>
</div>

		
		

<div class="col-md-6" style="padding:10px">			
		
			
	
			<div id="rss">
<script type="text/javascript">
                    
                    rssmikle_url="http://www5.usp.br/feed/?category=uspdestaque";
					rssmikle_frame_width="100%";
                    rssmikle_frame_height="380";
                    rssmikle_target="_blank";
                    rssmikle_font="'Roboto', sans-serif";
                    rssmikle_font_size="12";
                    rssmikle_border="off";
                    rssmikle_css_url="";
                    autoscroll="off";
                    rssmikle_title="on";
                    rssmikle_title_bgcolor="#696969";
                    rssmikle_title_color="#f5f5f5";
                    rssmikle_title_bgimage="http://";
                    rssmikle_item_bgcolor="#f5f5f5";
                    rssmikle_item_bgimage="http://";
                    rssmikle_item_title_length="90";
                    rssmikle_item_title_color="#1094ab";
                    rssmikle_item_border_bottom="on";
                    rssmikle_item_description="on";
                    rssmikle_item_description_length="170";
                    rssmikle_item_description_color="#666666";
                    rssmikle_item_date="off";
                    rssmikle_item_description_tag="off";
                    rssmikle_item_podcast="off";
                   
                </script>
      <script type="text/javascript" src="http://widget.feed.mikle.com/js/rssmikle.js"></script>
</div>

<div style="margin-bottom:0px;">
		<small style="position:relative; float:right; background-color: #f5f5f5; z-index:10; top:-40px; padding:10px; height:30px; opacity:0.7;">Fonte: <a href="http://www.usp.br/agen/" target="_blank" style="color:#607890;">Ag&ecirc;ncia USP de Notícias</a>.</small>
		</div>
		</div>
		

			
			
			
			</div>
				
			
<div class="col-md-4" >
			<h2 class="h2-subs"><span class="glyphicon glyphicon-time" style="position:relative; top:2px; font-size:25px;"></span> <fmt:message key="jsp.collection-home.events"/>
			</h2>
<div class="col-md-12" style="padding:10px">			
			
			
<div id="rss">
<script type="text/javascript">
                    
                    rssmikle_url="http://www.eventos.usp.br/?event-types=cultura-e-artes&feed=rss2";
                    rssmikle_frame_width="100%";
                    rssmikle_frame_height="200";
                    rssmikle_target="_blank";
                    rssmikle_font="'Roboto', sans-serif";
                    rssmikle_font_size="12";
                    rssmikle_border="off";
                    rssmikle_css_url="";
                    autoscroll="off";
                    rssmikle_title="off";
                    rssmikle_title_bgcolor="#696969";
                    rssmikle_title_color="#f5f5f5";
                    rssmikle_title_bgimage="http://";
                    rssmikle_item_bgcolor="#f5f5f5";
                    rssmikle_item_bgimage="http://";
                    rssmikle_item_title_length="100";
                    rssmikle_item_title_color="#1094ab";
                    rssmikle_item_border_bottom="on";
                    rssmikle_item_description="off";
                    rssmikle_item_description_length="150";
                    rssmikle_item_description_color="#666666";
                    rssmikle_item_date="off";
                    rssmikle_item_description_tag="off";
                    rssmikle_item_podcast="off";
                </script>
      <script type="text/javascript" src="http://widget.feed.mikle.com/js/rssmikle.js"></script>
	  <noscript>Nao</noscript>
 
</div>

			<div style="margin:0px; padding:0px;">
		<small style="position:relative; float:right; background-color: #f5f5f5; z-index:10; top:-30px; padding:10px; height:30px; opacity:0.9;width:100%;"></br><p style="position:relative; top: -25px; float:right">
		Fonte: <a href="http://www.eventos.usp.br/" target="_blank" style="color:#607890;">USP Eventos</a>.</p></small>
		</div>
		
		
		<div class="col-md-12" style="top:9px; ; padding:11px;
		
border-color: #FF9900;
border-top-style:solid;
border-top-width:2px;
border-bottom-width:2px;
border-bottom-style:solid;
background-color:#f5f5f5;

		">
			<h2 class="h2-share">  <span class="glyphicon glyphicon-send" class="sub-icon"></span>&nbsp; <fmt:message key="usp.menu.share"/>
			
			</h2>
			
			<div id="share" style="margin: auto;padding:5px; width:200px">
				
<span class='st_facebook_large' displayText='Facebook'></span>

<span class='st_twitter_large' displayText='Tweet'></span>

<span class='st_linkedin_large' displayText='LinkedIn'></span>

<span class='st_googleplus_large' displayText='Google +'></span>

<span class='st_whatsapp_large' displayText='WhatsApp'></span>
</div>
			</div>
			</div>
</div>
		
	</div>	
		
		


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
		

<!-- Notas de rodapé -->
			
			
				<!-- /.col-lg-4 -->
			<div class="col-lg-3" id="notasdorodape">
				<span class="glyphicon glyphicon-eye-open iconbg"></span>
				<h2><fmt:message key="usp.visibilidade.title"/></h2>
				<h5><small><p style="text-align:justufy"><br><fmt:message key="usp.visibilidade.text"/></p></small>
				</h5>
				<!--<p><a class="btn btn-primary pull-right" href="#" role="button" style="position:relative;left:-60px">Saiba mais »</a>
				</p>-->
				</br></br>
			</div>
			<div class="col-lg-6" id="notasdorodape">
				<span class="glyphicon glyphicon-floppy-open iconbg"></span>
				<h2><fmt:message key="usp.deposito.title"/></h2>
				<h5><small><p><br><fmt:message key="usp.deposito.text1"/> <a target="_blank" href="<%= request.getContextPath()%>/feedback" class="footer-link">atendimento@sibi.usp.br <span class="glyphicon glyphicon-new-window" style="font-size:0.65em"></span></a> <fmt:message key="usp.deposito.text2"/></p></small></h5>
				<!--<p><a class="btn btn-primary pull-right" href="#" role="button" style="position:relative;left:-60px">Saiba mais »</a></p>-->
				
			</div>
			
				<!-- /.col-lg-4 -->
			<div class="col-lg-3" id="notasdorodape">
				<span class="glyphicon glyphicon-stats iconbg"></span>
				<h2><fmt:message key="usp.numeros.title"/></h2>
				
				
				<!--<h4>
					<div style="width:100px">
						<dl class="dl-horizontal" style="width:300px">
							<dt>Unidades</dt>
							<dd>55</dd>
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
					<h5 style="line-height:300%; letter-spacing:0px;"><small><p style="text-align:center; overflow:show;">
					
                                        <jsp:useBean id="unidades" class="org.dspace.content.dao.CommunityDAOPostgres"/> 
                                        <jsp:useBean id="registros" class="org.dspace.content.dao.RegistroDAOPostgres"/>    
                                                                     
                                                                                 
                                            <table style="width:100%; margin-bottom:15px;">
  <tr>
    <td style="text-align:right;"><span style="font-weight:strong; font-size:16px;"><%=unidades.getTotalUnidades() %></span></td>
    <td>Unidades</td>
  </tr>
  <tr>
    <td style="text-align:right;"><span style="font-weight:strong; font-size:16px;"><%=unidades.getTotalDepartamentos() %></span> </td>
    <td>Departamentos</td>
  </tr>
<!--  <tr>
    <td style="text-align:right;"><span style="font-weight:strong; font-size:16px;"><%=registros.getTotalRegistros() %></span></td>
    <td>Registros</td>
  </tr>-->
  <tr>
    <td style="text-align:right;"><span style="font-weight:strong; font-size:16px;"><%=registros.getTotalRegistrosOpenAccess() %></span></td>
    <td>Textos de acesso aberto</td>
  </tr>
  </table>

				<!--<p><a href="http://www.producao.usp.br/awstats/" class="btn btn-primary pull-right" href="#" role="button" style="position:relative;left:-60px" target="blank">Ver tudo »</a>
				</p>-->
				
					</p></small>
					</h5>
					
			</div>
			</center>
		</div>


			</dspace:layout>

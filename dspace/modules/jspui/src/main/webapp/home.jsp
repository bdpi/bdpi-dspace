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
																		
	document.getElementById("logos").style.width = 70*27+"px";			// Para dispor os logos na horizontal - 14 é o numero de colunas.
	
	if( window.innerWidth >= 1050 ){
	// caracteristicas deste tamanho de tela
	document.getElementById("jumbocol").style.width 
	= window.innerWidth - (window.innerWidth-1000) - 20 - 420 + "px";       					// Tamanho da foto - Tamanho da tela - margens do body e margem direita da foto.
	document.getElementById("logos-container").style.width = 420+"px";
	document.getElementById("anim").style.height = 300 +"px";
	document.getElementById("logos-container").style.height = 280 +"px";
	// caracteristicas para retomar no caso de diminuir a tela e aumentar de volta
	document.getElementById("logos-container").style.left = 0 +'px';
	document.getElementById("logos-container").style.top = -30+'px';
	document.getElementById("cruesp").style.cssFloat = 'right';

	document.getElementById("logos4").style.width = 70+"px" ;
	document.getElementById("logos4").style.height = 4*70+"px" ;

	}															   
	else{
	// caracteristicas deste tamanho de tela
	document.getElementById("logos").style.width = 70*28+"px";                    // Para ter 2 linhas (28 colunas)
	document.getElementById("jumbocol").style.width = 100+"%";                    //
	var numLogos = Math.floor( (window.innerWidth-30)/70 );        		          // Quantos logos (divisao inteiro) cabem no tamanho da janela (menos 30px de margens)
	document.getElementById("logos-container").style.width = numLogos*70 +"px";   // Para tirar logos cortados.
	document.getElementById("anim").style.height = 150 +"px";					  // Ajuste altura para duas linhas.
	document.getElementById("logos-container").style.height = 140 +"px";          // Ajuste altura para duas linhas.
	document.getElementById("logos-container").style.left = 
	(window.innerWidth -numLogos*70 -30)/2 +"px";								  // Para centralizar a div dos logos.
	document.getElementById("logos-container").style.top = 0+'px';
	document.getElementById("cruesp").style.cssFloat = 'left';
	}
}
window.onresize = tamanho;
</script>

<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>

<script>





$(document).ready(function(){

	//Para mudar a cor do Cruesp

	$(".cruesplink").mouseenter(function() {
					$(".cruesp").css("display","visible");
				$(".cruesppeb").css("display","none");

	});

	
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
<script> 

// Movimento dos logos

$(document).ready(function(){

	$("#noscript").css("display","none");
	$("#logos").css("opacity","1");

	function animatelogos() {
				var elemento =  $("div#logos div#logos4:first-child").html();
				$("div#logos div#logos4:last-child").after("<div id=\"logos4\">"+elemento+"</div>");
				$("div#logos div#logos4:first-child").hide('slow', function(){ $("div#logos div#logos4:first-child").remove(); });
	}

	timerLogos = setInterval(animatelogos, 2000);

	$("#setas").mouseenter(function() {
		clearInterval(timerLogos);
	});
	
	$("#anim").mouseenter(function() {
				clearInterval(timerLogos);

	})
			  .mouseleave(function() {
				timerLogos = setInterval(animatelogos, 2000);
	});
	
// Botão next dos logos
$("button.next").click(function(){
	clearInterval(timerLogos);
	animatelogos();
	});  														  

// Botão previous dos logos
$("button.prev").click(function(){
	var element = $("div#logos div#logos4:last-child").html();
	$("div#logos div#logos4:first-child").before("<div id=\"logos4\" style=\"display:none\">"+element+"</div>");
	$("div#logos div#logos4:last-child").remove();
	$("div#logos div#logos4:first-child").show('slow', function(){});
	});
});

</script>	
<!-- Fim da dinâmica dos logos -->
    <div class="row" id="jumborow">
        <div class="col-md-8" id="jumbocol">
            <div class="jumbotron" id="jumbotron" style="height:320px; padding:20px">
                <div class="box" style="max-width:500px;max-width:75%; top:20px">
                    <h4 class="chamada">Conheça a BDPI</h4>
                    <p style="font-size:13px;max-width:400px">A Biblioteca Digital da Produção Intelectual da Universidade de São Paulo (BDPI) é um sistema de gestão e disseminação da produção científica, acadêmica, técnica e artística gerada pelas pesquisas desenvolvidas na USP.</p>
                </div>
            </div>
			</div>
			<div id="panellogos">
				<div class="panel-heading" id="logospanel-heading">
					<h4 style="margin:0; padding:0"><fmt:message key="jsp.home.com1"/>
					</h4>
					<div id="setas">
						<button id="seta" class="prev" style="margin:auto;"><</button>
						<button id="seta" class="next" style="position:relative;float:right">></button>
					</div>
					<div id="noscript"> Para completa funcionalidade deste site é necessário habilitar o JavaScript.
							  Aqui estão as <a href="http://www.enable-javascript.com/pt/" target="_blank" style="color:blue;">
							  instruções de como habilitar o JavaScript no seu navegador</a>.
					</div>
				</div>
				
				<div class="col-md-4" id="logos-container">
					<div id="anim">
						
						<div id="logos">
						<div id="logos4" style="position:relative;float:left;">
							<div class="col-md-3" id="logo" style="position:relative; float:left"><a href="handle/BDPI/1315"><img class="img-responsive" src="image/logosusp/cebimar.jpg" title="Centro de Biologia Marinha - CEBIMar"></a></div>
							<div class="col-md-3" id="logo" style="position:relative; float:left"><a href="handle/BDPI/1"><img class="img-responsive" src="image/logosusp/cena.jpg" title="Centro de Energia Nuclear na Agricultura - CENA"></a></div>
							<div class="col-md-3" id="logo" style="position:relative; float:left"><a href="handle/BDPI/1365"><img class="img-responsive" src="image/logosusp/each.jpg" title="Escola de Artes, Ciências e Humanidades - EACH"></a></div>
							<div class="col-md-3" id="logo" style="position:relative; float:left"><a href="handle/BDPI/22"><img class="img-responsive" src="image/logosusp/eca.jpg" title="Escola de Comunicações e Artes - ECA"></a></div>
						</div>	
						<div id="logos4"  style="position:relative;float:left;">
							<div class="col-md-3" id="logo" style="position:relative; float:left"><a href="handle/BDPI/1360"><img class="img-responsive" src="image/logosusp/eeferp.jpg" title="Escola de Educação Física e Esporte de Ribeirão Preto - EEFERP"></a></div>
							<div class="col-md-3" id="logo" style="position:relative; float:left"><a href="handle/BDPI/94"><img class="img-responsive" src="image/logosusp/eefe.jpg" title="Escola de Educação Física e Esporte - EEFE"></a></div>
							<div class="col-md-3" id="logo" style="position:relative; float:left"><a href="handle/BDPI/115"><img class="img-responsive" src="image/logosusp/eerp.jpg" title="Escola de Enfermagem de Ribeirão Preto - EERP"></a></div>
							<div class="col-md-3" id="logo" style="position:relative; float:left"><a href="handle/BDPI/68"><img class="img-responsive" src="image/logosusp/ee.jpg" title="Escola de Enfermagem - EE"></a></div>
						</div>	
						<div id="logos4" style="position:relative;float:left;">	
							<div class="col-md-3" id="logo" style="position:relative; float:left"><a href="handle/BDPI/136"><img class="img-responsive" src="image/logosusp/eel.jpg" title="Escola de Engenharia de Lorena - EEL"></a></div>
							<div class="col-md-3" id="logo" style="position:relative; float:left"><a href="handle/BDPI/162"><img class="img-responsive" src="image/logosusp/eesc.jpg" title="Escola de Engenharia de São Carlos - EESC"></a></div>
							<div class="col-md-3" id="logo" style="position:relative; float:left"><a href="handle/BDPI/213"><img class="img-responsive" src="image/logosusp/ep.jpg" title="Escola Politécnica - EP"></a></div>
							<div class="col-md-3" id="logo" style="position:relative; float:left"><a href="handle/BDPI/294"><img class="img-responsive" src="image/logosusp/esalq.jpg" title="Escola Superior de Agricultura Luiz de Queiroz - ESALQ"></a></div>
						</div>	
						<div id="logos4" style="position:relative;float:left;">	
							<div class="col-md-3" id="logo" style="position:relative; float:left"><a href="handle/BDPI/360"><img class="img-responsive" src="image/logosusp/fau.jpg" title="Faculdade de Arquitetura e Urbanismo - FAU"></a></div>
							<div class="col-md-3" id="logo" style="position:relative; float:left"><a href="handle/BDPI/407"><img class="img-responsive" src="image/logosusp/fcfrp.jpg" title="Faculdade de Ciências Farmacêuticas de Ribeirão Preto - FCFRP"></a></div>
							<div class="col-md-3" id="logo" style="position:relative; float:left"><a href="handle/BDPI/381"><img class="img-responsive" src="image/logosusp/fcf.jpg" title="Faculdade de Ciências Farmacêuticas - FCF"></a></div>
							<div class="col-md-3" id="logo" style="position:relative; float:left"><a href="handle/BDPI/479"><img class="img-responsive" src="image/logosusp/fdrp.jpg" title="Faculdade de Direito de Ribeirão Preto - FDRP"></a></div>
						</div>	
						<div id="logos4" style="position:relative;float:left;">
							<div class="col-md-3" id="logo" style="position:relative; float:left"><a href="handle/BDPI/428"><img class="img-responsive" src="image/logosusp/fd.jpg" title="Faculdade de Direito - FD"></a></div>
							<div class="col-md-3" id="logo" style="position:relative; float:left"><a href="handle/BDPI/542"><img class="img-responsive" src="image/logosusp/fearp.jpg" title="Faculdade de Economia, Administração e Contabilidade de Ribeirão Preto - FEARP"></a></div>
							<div class="col-md-3" id="logo" style="position:relative; float:left"><a href="handle/BDPI/521"><img class="img-responsive" src="image/logosusp/fea.jpg" title="Faculdade de Economia, Administração e Contabilidade - FEA"></a></div>
							<div class="col-md-3" id="logo" style="position:relative; float:left"><a href="handle/BDPI/500"><img class="img-responsive" src="image/logosusp/fe.jpg" title="Faculdade de Educação - FE"></a></div>
						</div>	
						<div id="logos4" style="position:relative;float:left;">
							<div class="col-md-3" id="logo" style="position:relative; float:left"><a href="handle/BDPI/1248"><img class="img-responsive" src="image/logosusp/ffclrp.jpg" title="Faculdade de Filosofia, Ciências e Letras de Ribeirão Preto - FFCLRP"></a></div>
							<div class="col-md-3" id="logo" style="position:relative; float:left"><a href="handle/BDPI/563"><img class="img-responsive" src="image/logosusp/fflch.jpg" title="Faculdade de Filosofia, Letras e Ciências Humanas - FFLCH"></a></div>
							<div class="col-md-3" id="logo" style="position:relative; float:left"><a href="handle/BDPI/725"><img class="img-responsive" src="image/logosusp/fmrp.jpg" title="Faculdade de Medicina de Ribeirão Preto - FMRP"></a></div>
							<div class="col-md-3" id="logo" style="position:relative; float:left"><a href="handle/BDPI/624"><img class="img-responsive" src="image/logosusp/fm.jpg" title="Faculdade de Medicina - FM"></a></div>
						</div>	
						<div id="logos4" style="position:relative;float:left;">	
							<div class="col-md-3" id="logo" style="position:relative; float:left"><a href="handle/BDPI/801"><img class="img-responsive" src="image/logosusp/fmvz.jpg" title="Faculdade de Medicina Veterinária e Zootecnia - FMVZ"></a></div>
							<div class="col-md-3" id="logo" style="position:relative; float:left"><a href="handle/BDPI/878"><img class="img-responsive" src="image/logosusp/fob.jpg" title="Faculdade de Odontologia de Bauru - FOB"></a></div>
							<div class="col-md-3" id="logo" style="position:relative; float:left"><a href="handle/BDPI/1284"><img class="img-responsive" src="image/logosusp/forp.jpg" title="Faculdade de Odontologia de Ribeirão Preto - FORP"></a></div>
							<div class="col-md-3" id="logo" style="position:relative; float:left"><a href="handle/BDPI/837"><img class="img-responsive" src="image/logosusp/fo.jpg" title="Faculdade de Odontologia - FO"></a></div>
						</div>	
						<div id="logos4" style="position:relative;float:left;">	
							<div class="col-md-3" id="logo" style="position:relative; float:left"><a href="handle/BDPI/914"><img class="img-responsive" src="image/logosusp/fsp.jpg" title="Faculdade de Saúde Pública - FSP"></a></div>
							<div class="col-md-3" id="logo" style="position:relative; float:left"><a href="handle/BDPI/945"><img class="img-responsive" src="image/logosusp/fzea.jpg" title="Faculdade de Zootecnia e Engenharia de Alimentos - FZEA"></a></div>
							<div class="col-md-3" id="logo" style="position:relative; float:left"><a href="handle/BDPI/1325"><img class="img-responsive" src="image/logosusp/hrac.jpg" title="Hospital de Reabilitação de Anomalias Craniofaciais - HRAC"></a></div>
							<div class="col-md-3" id="logo" style="position:relative; float:left"><a href="handle/BDPI/1330"><img class="img-responsive" src="image/logosusp/hu.jpg" title="Hospital Universitário - HU"></a></div>
						</div>	
						<div id="logos4" style="position:relative;float:left;">	
							<div class="col-md-3" id="logo" style="position:relative; float:left"><a href="handle/BDPI/32492"><img class="img-responsive" src="image/logosusp/iau.jpg" title="Instituto de Arquitetura e Urbanismo de São Carlos - IAU"></a></div>
							<div class="col-md-3" id="logo" style="position:relative; float:left"><a href="handle/BDPI/966"><img class="img-responsive" src="image/logosusp/iag.jpg" title="Instituto de Astronomia, Geofísica e Ciências Atmosféricas - IAG"></a></div>      
							<div class="col-md-3" id="logo" style="position:relative; float:left"><a href="handle/BDPI/987"><img class="img-responsive" src="image/logosusp/ib.jpg" title="Instituto de Biociências - IB"></a></div>
							<div class="col-md-3" id="logo" style="position:relative; float:left"><a href="handle/BDPI/1018"><img class="img-responsive" src="image/logosusp/icb.jpg" title="Instituto de Ciências Biomédicas - ICB"></a></div>
						</div>	
						<div id="logos4" style="position:relative;float:left;">	
							<div class="col-md-3" id="logo" style="position:relative; float:left"><a href="handle/BDPI/1059"><img class="img-responsive" src="image/logosusp/icmc.jpg" title="Instituto de Ciências Matemáticas e de Computação - ICMC"></a></div>
							<div class="col-md-3" id="logo" style="position:relative; float:left"><a href="handle/BDPI/1320"><img class="img-responsive" src="image/logosusp/iee.jpg" title="Instituto de Eletrotécnica e Energia - IEE"></a></div>
							<div class="col-md-3" id="logo" style="position:relative; float:left"><a href="handle/BDPI/1350"><img class="img-responsive" src="image/logosusp/ieb.jpg" title="Instituto de Estudos Brasileiros - IEB"></a></div>
							<div class="col-md-3" id="logo" style="position:relative; float:left"><a href="handle/BDPI/1116"><img class="img-responsive" src="image/logosusp/ifsc.jpg" title="Instituto de Física de São Carlos - IFSC"></a></div>
						</div>	
						<div id="logos4" style="position:relative;float:left;">	
							<div class="col-md-3" id="logo" style="position:relative; float:left"><a href="handle/BDPI/1080"><img class="img-responsive" src="image/logosusp/if.jpg" title="Instituto de Física - IF"></a></div>
							<div class="col-md-3" id="logo" style="position:relative; float:left"><a href="handle/BDPI/1132"><img class="img-responsive" src="image/logosusp/igc.jpg" title="Instituto de Geociências - IGc"></a></div>
							<div class="col-md-3" id="logo" style="position:relative; float:left"><a href="handle/BDPI/1148"><img class="img-responsive" src="image/logosusp/ime.jpg" title="Instituto de Matemática e Estatística - IME"></a></div>
							<div class="col-md-3" id="logo" style="position:relative; float:left"><a href="handle/BDPI/32490"><img class="img-responsive" src="image/logosusp/imt.jpg" title="Instituto de Medicina Tropical de São Paulo - IMT"></a></div>
						</div>	
						<div id="logos4" style="position:relative;float:left;">	
							<div class="col-md-3" id="logo" style="position:relative; float:left"><a href="handle/BDPI/1190"><img class="img-responsive" src="image/logosusp/ip.jpg" title="Instituto de Psicologia - IP"></a></div>
							<div class="col-md-3" id="logo" style="position:relative; float:left"><a href="handle/BDPI/1232"><img class="img-responsive" src="image/logosusp/iqsc.jpg" title="Instituto de Química de São Carlos - IQSC"></a></div>
							<div class="col-md-3" id="logo" style="position:relative; float:left"><a href="handle/BDPI/1216"><img class="img-responsive" src="image/logosusp/iq.jpg" title="Instituto de Química - IQ"></a></div>
							<div class="col-md-3" id="logo" style="position:relative; float:left"><a href="handle/BDPI/16894"><img class="img-responsive" src="image/logosusp/iri.jpg" title="Instituto de Relações Internacionais - IRI"></a></div>
						</div>	
						<div id="logos4" style="position:relative;float:left;">	
							<div class="col-md-3" id="logo" style="position:relative; float:left"><a href="handle/BDPI/1174"><img class="img-responsive" src="image/logosusp/io.jpg" title="Instituto Oceanográfico - IO"></a></div>
							<div class="col-md-3" id="logo" style="position:relative; float:left"><a href="handle/BDPI/1355"><img class="img-responsive" src="image/logosusp/mae.jpg" title="Museu de Arqueologia e Etnologia - MAE"></a></div>
							<div class="col-md-3" id="logo" style="position:relative; float:left"><a href="handle/BDPI/1335"><img class="img-responsive" src="image/logosusp/mac.jpg" title="Museu de Arte Contemporânea - MAC"></a></div>
							<div class="col-md-3" id="logo" style="position:relative; float:left"><a href="handle/BDPI/1345"><img class="img-responsive" src="image/logosusp/mz.jpg" title="Museu de Zoologia - MZ"></a></div>
						</div>	
						<div id="logos4" style="position:relative;float:left;">	
							<div class="col-md-3" id="logo" style="position:relative; float:left"><a href="handle/BDPI/1340"><img class="img-responsive" src="image/logosusp/mp.jpg" title="Museu Paulista - MP"></a></div>
							<div class="col-md-3" id="logo" style="position:relative; float:left"><a href="handle/BDPI/1370"><img class="img-responsive" src="image/logosusp/sibi.jpg" title="Sistema Integrado de Bibliotecas - SIBi"></a></div>
							<div class="col-md-3" id="logo" style="position:relative; float:left"><a href="handle/BDPI/1080"><img class="img-responsive" src="image/logosusp/if.jpg" title="Instituto de Física - IF"></a></div>
							<div class="col-md-3" id="logo" style="position:relative; float:left"><a href="handle/BDPI/1132"><img class="img-responsive" src="image/logosusp/igc.jpg" title="Instituto de Geociências - IGc"></a></div>
						</div>
					</div>
				</div>
			   </div>
			</div>
		<div class="row">
        <div class="col-md-8" style="position:relative; float:left;">
            <%
                if (submissions != null && submissions.count() > 0) {
            %>
            <div class="panel" style="padding:10px;margin-right:10px;border-bottom-style:solid;border-bottom-width:2px;border-bottom-color:  #fcb421;border-top-style:solid;border-top-width:2px;border-top-color:  #fcb421;    background: linear-gradient(#f5f5f5, #f5f5f5, #f5f5f5);">
                <div class="panel-heading">
                    <h4><fmt:message key="jsp.collection-home.recentsub"/>
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
                    </h4>
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
                                <a class="authority author" href="/browse?type=author&authority=<%=displayAuthors[acount][1]%>"><%=StringUtils.abbreviate(displayAuthors[acount][0], 1000)%></a> <img src="<%=request.getContextPath()%>/image/ehUSP.png">
                                <% } else { %>
                                  <%=StringUtils.abbreviate(displayAuthors[acount][0], 1000)%>
                                <% } %>
                            <% }%><%=etal%></p>
                        <p><%= StringUtils.abbreviate(displayAbstract, 500)%></p>
                    </div>
				
                </div>
                <%
                        first = false;
                    }
                %>
				

            </div>
			<center style="color: #fcb421"><div style="position:relative; top:-30px;width:23px; background-color:white;height:23px; border-width:2px;border-style:solid;border-color:#fcb421"><span id="show">&#9660;</span>
			<span id="hide">&#9650;</span></center>
            <%
                }
            %>

        </div>

			<br><br>
		<div class="col-md-4" style="position:relative; float:left;">
            <div class="panel text-justify" style="padding:10px;position:relative; float:left;border-bottom-style:solid;border-bottom-width:2px;border-bottom-color: #64c4d2;border-top-style:solid;border-top-width:2px;border-top-color: #64c4d2;background: linear-gradient(#f5f5f5, #f5f5f5, #f5f5f5); ">
                <div class="panel-heading">
                    <h4><fmt:message key="jsp.collection-home.latestnews"/></h3>
                </div>
                <div class="media padding15">
                    <a class="pull-left" href="#">
                        <span class="glyphicon glyphicon-list-alt icon"></span>
                    </a>
                    <div class="media-body">
                        <h4 class="media-heading">Media heading</h4>
                        Cras sit amet nibh libero, in gravida nulla. Nulla vel metus scelerisque ante sollicitudin commodo. Cras sit amet nibh libero, in gravida nulla. Nulla vel metus scelerisque ante sollicitudin commodo.<br/><br/><a class="btn btn-primary" href="#" role="button">Leia mais...</a>
                    </div>
                </div>
                <div class="media padding15">
                    <a class="pull-left" href="#">
                        <span class="glyphicon glyphicon-list-alt icon"></span>
                    </a>
                    <div class="media-body">
                        <h4 class="media-heading">Media heading</h4>
                        Cras sit amet nibh libero, in gravida nulla. Nulla vel metus scelerisque ante sollicitudin commodo. Cras purus odio, vestibulum in vulputate at, tempus viverra turpis.<br/><br/><a class="btn btn-primary" href="#" role="button">Leia mais...</a>
                    </div>
                </div>
                <div class="media padding15">
                    <a class="pull-left" href="#">
                        <span class="glyphicon glyphicon-list-alt icon"></span>
                    </a>
                    <div class="media-body">
                        <h4 class="media-heading">Media heading</h4>
                        Cras sit amet nibh libero, in gravida nulla. Nulla vel metus scelerisque ante sollicitudin commodo. Cras purus odio, vestibulum in vulputate at, tempus viverra turpis.<br/><br/><a class="btn btn-primary" href="#" role="button">Leia mais...</a>
                    </div>
                </div>
            </div>
            <div class="panel">
                <div class="panel-body pull-center">
                    <div class="addthis_toolbox addthis_default_style addthis_32x32_style" style="width:350px;height:70px">
                        <a class="addthis_button_facebook_like" fb:like:layout="box_count" fb:like:action="recommend"></a>
                        <a class="addthis_button_tweet" tw:count="vertical"></a>
                        <a class="addthis_button_google_plusone" g:plusone:size="tall"></a>
                        <a class="addthis_button_linkedin_counter" li:counter="top"></a>
                        <a class="addthis_button_compact"></a>
                    </div>
                    <script async="async" defer="true" type="text/javascript" src="//s7.addthis.com/js/300/addthis_widget.js#pubid=ra-4f9b00617c1df207" >
                        & #160;
                    </script>
                </div>
            </div>
        </div>
    </div>
<div style="width:900px;height:309px;margin-left:auto; margin-right:auto;"><center>
        <div class="col-lg-4" id="notasdorodape">
            <span class="glyphicon glyphicon-floppy-open iconbg"></span>
            <h4 style="color:#0e94ab;font-weight: bold;">Como depositar</h4>
            <h4><small><p>Donec sed odio dui. Etiam porta sem malesuada magna mollis euismod. Nullam id dolor id nibh ultricies vehicula ut id elit. Morbi leo risus, porta ac consectetur ac, vestibulum at eros. Praesent commodo cursus magna.</p></small></h4>
            <p><a class="btn btn-primary pull-right" href="#" role="button" style="position:relative;left:-60px">Saiba mais »</a></p>
            </br></br>
        </div>
        <!-- /.col-lg-4 -->
        <div class="col-lg-4" id="notasdorodape">
            <span class="glyphicon glyphicon-comment iconbg"></span>
            <h4 style="color:#0e94ab;font-weight: bold;">Como citar</h4>
            <h4 style="line-height:300%; letter-spacing:0px;"><small><p style="text-align:justufy">Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Cras mattis consectetur purus sit amet fermentum. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh.</p></small>
            </h4>
			<p><a class="btn btn-primary pull-right" href="#" role="button" style="position:relative;left:-60px">Saiba mais »</a>
            </p>
            </br></br>
        </div>
        <!-- /.col-lg-4 -->
        <div class="col-lg-4" id="notasdorodape">
            <span class="glyphicon glyphicon-pencil iconbg"></span>
            <h4 style="color:#0e94ab;font-weight: bold;">BDPI em números</h4>
<h4><small>
			<dl class="dl-horizontal" style="width:300px; margin-left: auto; margin-right: auto;position:relative; left:-55px;">
                <dt>Unidades</dt>
                <dd>42</dd>
                <dt>Departamentos</dt>
                <dd>127</dd>
                <dt>Registros</dt>
                <dd>38000</dd>
                <dt>Texto completo</dt>
                <dd>38000</dd>
            </dl>
</small></h4>
        </div>
		</center>
    </div>

</dspace:layout>

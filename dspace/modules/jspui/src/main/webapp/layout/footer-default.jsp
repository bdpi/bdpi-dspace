<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Footer for home page
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ page import="java.net.URLEncoder" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>

<%
    String sidebar = (String) request.getAttribute("dspace.layout.sidebar");
%>

<%-- Right-hand side bar if appropriate --%>
<%
    if (sidebar != null) {
%>

</div>
	<div class="col-md-3"> 
		<%= sidebar%>
	</div>
</div>       
<%
    }
%>


<%-- Page footer --%>

<div class="row">
    <div class="col-md-12">
        <footer>
			</br></br>
			<div class="footer-hold">
			    <h6 class="footer-links">
					<div class="cineca">&nbsp;&nbsp;<fmt:message key="jsp.layout.footer-default.theme-by"/> &nbsp;&nbsp;</div>
					<a href="http://www.cineca.it"> 
						<div class="cinecaLogo">
							<img class="cinecaImg" src="<%= request.getContextPath()%>/image/logo-cineca-small.png" alt="Imagem do logo CINECA" />
						</div>
					</a>
					<div id="footer_feedback" class="pull-right">
					
						<a href="#creditos-ancora" id="creditos-link" class="footer-link"><fmt:message key="usp.menu.creditos"/></a>&nbsp;|&nbsp;
						<a target="_blank" href="<%= request.getContextPath()%>/feedback" class="footer-link"><fmt:message key="jsp.layout.footer-default.feedback"/> <span class="glyphicon glyphicon-new-window"></span></a>&nbsp;|&nbsp;
						<a href="#map-ancora" class="footer-link" id="map-link"><fmt:message key="usp.menu.map"/></a>&nbsp;|&nbsp;
						<a href="#" class="footer-link">Voltar ao in&iacute;cio</a>
						</br></br>
						<a href="#openaccesspolicy-ancora" class="footer-link" id="openaccesspolicy-link"><fmt:message key="usp.menu.openaccesspolicy"/></a>&nbsp;|&nbsp;
						<a href="#privacypolicy-ancora" class="footer-link" id="privacypolicy-link"><fmt:message key="usp.menu.privacypolicy"/></a>&nbsp;|&nbsp;
						<a href="#rights-ancora" class="footer-link" id="rights-link"><fmt:message key="usp.menu.rights"/></a>&nbsp;|&nbsp;
						<a href="#faq-ancora" class="footer-link" id="faq-link"><fmt:message key="usp.menu.faq"/></a>
						</br></br></br>
			
						<div id="dspacecreditos"><fmt:message key="jsp.layout.footer-default.text" /></div>
					</div>
				</h6>
            </div>
	    <div>
			<!-- Go to www.addthis.com/dashboard to customize your tools -->
			<div class="addthis_custom_sharing"></div>
	    </div>
	</footer>

	</br></br></br></br>
	<h4>
		<address class="text-center"><div>
			Departamento Técnico do Sistema Integrado de Bibliotecas da USP</br>
			Rua da Biblioteca, s/n - Complexo Brasiliana - 05508-050 - Cidade Universitária, São Paulo, SP - Brasil</br>
			<a href="https://goo.gl/maps/yVAwY" target="blank"><span class="glyphicon glyphicon-map-marker"></span> <fmt:message key="usp.maps"/></a></br></br>
			<span class="glyphicon glyphicon-phone-alt"></span> (0xx11) 3091-1546 &nbsp;&nbsp;<span class="glyphicon glyphicon-envelope"  /><span class="adress-mail"> atendimento@sibi.usp.br</span>
		</br></div>
			</address>
		<div class="col-md-12" style="padding:15px">

<!-- Modal Mapa do Site -->
    <div id="map-hold" class="footer-modal">
        <div>
            <a name="map-ancora"></a>
		
			<%@ include file="../help/map_en.html"%>
        </div>
    </div>

<!-- Modal Creditos -->
    <div id="creditos-hold" class="footer-modal">
        <div>
            <a name="creditos-ancora"></a>
			<%@ include file="../help/creditos_en.html"%>
        </div>
    </div>
	
<!-- Modal Política de Acesso Aberto -->
 <div id="openaccesspolicy-hold" class="footer-modal">
    <div>
            <a name="openaccesspolicy-ancora"></a>
			<%@ include file="../help/openaccesspolicy_en.html"%>
    </div>
 </div>
 
 <!-- Modal Política de Privacidade -->
 <div id="privacypolicy-hold" class="footer-modal">
    <div id="privacypolicy-content">
            <a name="privacypolicy-ancora"></a>
			<fmt:message key="page.privacypolicy"/>
    </div>
 </div>
 
 <!-- Modal Direitos Autorais -->
 <div id="rights-hold" class="footer-modal">
    <div>
            <a name="rights-ancora"></a>
			<%@ include file="../help/rights_en.html"%>
    </div>
 </div>

 <!-- Modal Direitos Autorais -->
 <div id="faq-hold" class="footer-modal">
    <div>
            <a name="rights-ancora"></a>
			<%@ include file="../help/faq_en.html"%>
    </div>
 </div> 
	
		</div>
	
		 		</br></br>
	</h4>
 </div>
</div>
</div>
 <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
<script>
function abrirmodal(pagina){

	var x = $( window ).height();
	$(pagina).show().css({
		 "position": "fixed",
		  "top": "0",
		  "left": "0",

		  "margin-left":"5%",
		  "margin-right":"5%",
		  "padding":"10px",
		  "width": "90%",

		  "height": x + "px",

		  "z-index": "10",

		  "background-color":"white",
		  "opacity":"0.9",

		  "overflow-x":"hidden",
		  "overflow-y": "scroll",
		});
}
	
$(document).ready(function(){
	$(".close").click(function(){$('div.footer-modal').hide();});
	$("[data-dismiss=modal]").click(function(){$('div.footer-modal').hide();});




$('div.footer-modal').hide();
$('a.footer-link').css({"cursor":"pointer"});

$('a#faq-link').click( function(){abrirmodal( $('div#faq-hold') )} );
$('a#openaccesspolicy-link').click( function(){abrirmodal( $('div#openaccesspolicy-hold') )} );
$('a#rights-link').click( function(){abrirmodal( $('div#rights-hold') )} );
$('a#privacypolicy-link').click( function(){abrirmodal(  $('div#privacypolicy-hold') )} );
$('a#map-link').click( function(){abrirmodal( $('div#map-hold') )} );
$('a#creditos-link').click( function(){abrirmodal( $('div#creditos-hold') )} );

});

$(window).click(function (event) {
if(event.target.class!='footer-modal'){
$('.footer-modal').hide();
}
});
</script>



</main>


</body>
</html>
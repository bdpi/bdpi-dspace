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
					
						<a data-toggle="modal" data-target="#creditos" class="footer-link"><fmt:message key="usp.menu.creditos"/></a>&nbsp;|&nbsp;
						<a target="_blank" href="<%= request.getContextPath()%>/feedback" class="footer-link"><fmt:message key="jsp.layout.footer-default.feedback"/></a>&nbsp;|&nbsp;
						<a data-toggle="modal" data-target="#map" class="footer-link"><fmt:message key="usp.menu.map"/></a>&nbsp;|&nbsp;
						<a href="#" class="footer-link">Voltar ao in&iacute;cio</a>
						</br></br>
						<a data-toggle="modal" data-target="#openAccessPolicy" class="footer-link"><fmt:message key="usp.menu.openaccesspolicy"/></a>&nbsp;|&nbsp;
						<a data-toggle="modal" data-target="#politicaDePrivacidade" class="footer-link"><fmt:message key="usp.menu.privacypolicy"/></a>&nbsp;|&nbsp;
						<a data-toggle="modal" data-target="#direitosAutorais" class="footer-link"><fmt:message key="usp.menu.rights"/></a>&nbsp;|&nbsp;
						<a data-toggle="modal" data-target="#faq" class="footer-link"><fmt:message key="usp.menu.faq"/></a>
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
		</br></div><div class="col-md-12" style="padding:15px">
		
		</div>
		</address>
		

<!-- Botões de compartilhamento antigos

<div class="addthis_toolbox addthis_default_style addthis_32x32_style" style="width:350px;height:70px;">
                        <a class="addthis_button_facebook_like" fb:like:layout="box_count" fb:like:action="recommend"></a>
                        <a class="addthis_button_tweet" tw:count="vertical"></a>
                        <a class="addthis_button_google_plusone" g:plusone:size="tall"></a>
                        <a class="addthis_button_linkedin_counter" li:counter="top"></a>
                        <a class="addthis_button_compact"></a>
                    </div>
                    <script async="async" defer="true" type="text/javascript" src="//s7.addthis.com/js/300/addthis_widget.js#pubid=ra-4f9b00617c1df207" >
                        & #160;
                    </script>
	 &nbsp;&nbsp;
-->

		</br></br>
	</h4>
 </div>
</div>
</div>
</main>

<!-- PARA MUDAR O NOME DOS TIPOS DE ITENS-->
<script src="//code.jquery.com/jquery-1.10.2.js"></script>
<script>
//var article = $( "li.list-group-item a" ).first().text();
//if(article=='article'){
//$( "li.list-group-item a" ).first().html('Artigos'); // <------- COLOCAR MENSAGEM TRADUZÍVEL
//}
//
//var book = $( "li.list-group-item" ).first().next().find('a').text();
//if(book=='book'){
//$( "li.list-group-item" ).first().next().find('a').html('Livros'); // <------- COLOCAR MENSAGEM TRADUZÍVEL
//}

//var bookPart = $( "li.list-group-item" ).first().next().next().find('a').text();
//if(bookPart=='bookPart'){
//$( "li.list-group-item" ).first().next().next().find('a').html('Capítulos de livros'); // <------- COLOCAR MENSAGEM TRADUZÍVEL
//}

//var conferenceObject = $( "li.list-group-item" ).first().next().next().next().find('a').text();
//if(conferenceObject=='conferenceObject'){
//$( "li.list-group-item" ).first().next().next().next().find('a').html('Algo que substitua conferenceObject'); // <------- COLOCAR MENSAGEM TRADUZÍVEL
//}

//var editorial = $( "li.list-group-item" ).first().next().next().next().next().find('a').text();
//if(editorial=='editorial'){
//$( "li.list-group-item" ).first().next().next().next().next().find('a').html('Algo que substitua editorial'); // <------- COLOCAR MENSAGEM TRADUZÍVEL
//}

//var lecture = $( "li.list-group-item" ).first().next().next().next().next().next().find('a').text();
//if(lecture=='lecture'){
//$( "li.list-group-item" ).first().next().next().next().next().next().find('a').html('Algo que substitua lecture'); // <------- COLOCAR MENSAGEM TRADUZÍVEL
//}

//var other = $( "li.list-group-item" ).first().next().next().next().next().next().next().find('a').text();
//if(other=='other'){
//$( "li.list-group-item" ).first().next().next().next().next().next().next().find('a').html('Outros'); // <------- COLOCAR MENSAGEM TRADUZÍVEL
//}
</script>

</body>
</html>
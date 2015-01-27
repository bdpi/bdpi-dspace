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
        <footer class="navbar navbar-inverse" style="background-color:transparent; margin-top:50px;">
		<br><br>
            <div id="designedby" style="background-color:white; height:60px;position:relative; float:left; width:100%; border-top-style:solid;border-top-width:2px;border-top-color:#FF9900;border-bottom-style:solid;border-bottom-width:2px;border-bottom-color:#FF9900;">
                <h6 style="color:#FF8700; font-weight:bold; position:relative;top:-5px">
				
				<div style="float:left; position:relative;top:12px; color:#FF8700"><strong>&nbsp;&nbsp;<fmt:message key="jsp.layout.footer-default.theme-by"/> &nbsp;&nbsp;</strong></div>
				
				<a href="http://www.cineca.it"> 
				
				<div style="background-color:#FF9900;position:relative;width:45px;height:48px;float:left; padding:5px;border-radius: 5px; top:-6px">
				
				<img    style="width:35px;"
						src="<%= request.getContextPath()%>/image/logo-cineca-small.png"
                        alt="Logo CINECA" />
				
				</div>
				
				</a>
				<div id="footer_feedback" class="pull-right" style="position:relative; top:-12px">
				
				<a data-toggle="modal" data-target="#creditos" style="cursor:pointer;color:#FF8700"><fmt:message key="usp.menu.creditos"/></a>&nbsp;|&nbsp;
                    <a target="_blank" href="<%= request.getContextPath()%>/feedback" style="cursor:pointer;color:#FF8700"><fmt:message key="jsp.layout.footer-default.feedback"/></a>&nbsp;|&nbsp;
                    <a data-toggle="modal" data-target="#map" style="cursor:pointer;color:#FF8700"><fmt:message key="usp.menu.map"/></a>&nbsp;|&nbsp;
                    <a href="#" style="cursor:pointer;color:#FF8700">Voltar ao in&iacute;cio</a>
		    <br><br>
		    <a data-toggle="modal" data-target="#openAccessPolicy" style="cursor:pointer;color:#FF8700"><fmt:message key="usp.menu.openaccesspolicy"/></a>&nbsp;|&nbsp;
                <a data-toggle="modal" data-target="#politicaDePrivacidade" style="cursor:pointer;color:#FF8700"><fmt:message key="usp.menu.privacypolicy"/></a>&nbsp;|&nbsp;
                <a data-toggle="modal" data-target="#direitosAutorais" style="cursor:pointer;color:#FF8700"><fmt:message key="usp.menu.rights"/></a>&nbsp;|&nbsp;
				<a href="help/map.html" style="cursor:pointer;color:#FF8700"><fmt:message key="usp.menu.faq"/></a>
                <br><br><br>
		
		<div id="dspacecreditos" style="cursor:pointer;color:#FF8700"><fmt:message key="jsp.layout.footer-default.text"  /></div>
				</div>
				</h6>	
            </div>
	    				

	    <div>
	    
	    
		 
		 
<!-- Go to www.addthis.com/dashboard to customize your tools -->
<div class="addthis_custom_sharing"></div>


	    
	    </div>
		</footer>
		<br><br><br><br>
<h4>
		<address class="text-center">
Departamento Técnico do Sistema Integrado de Bibliotecas da USP<br>
Rua da Biblioteca, s/n - Complexo Brasiliana - 05508-050 - Cidade Universitária, São Paulo, SP - Brasil<br>
<span class="glyphicon glyphicon-phone-alt"></span> (0xx11) 3091-1546 &nbsp;&nbsp;&nbsp;&nbsp;<span class="glyphicon glyphicon-envelope" /><span style="position:relative; right:8px; top:-2px"> atendimento@sibi.usp.br</span>
</address> <br>

<!-- Botões de compartilhamento 

<div class="addthis_toolbox addthis_default_style addthis_32x32_style" style="width:350px;height:70px; backgrund-color:red">
                        <a class="addthis_button_facebook_like" fb:like:layout="box_count" fb:like:action="recommend"></a>
                        <a class="addthis_button_tweet" tw:count="vertical"></a>
                        <a class="addthis_button_google_plusone" g:plusone:size="tall"></a>
                        <a class="addthis_button_linkedin_counter" li:counter="top"></a>
                        <a class="addthis_button_compact"></a>
                    </div>
                    <script async="async" defer="true" type="text/javascript" src="//s7.addthis.com/js/300/addthis_widget.js#pubid=ra-4f9b00617c1df207" >
                        & #160;
                    </script> -->
	 &nbsp;&nbsp;

<br><br>
</h4>
    </div>

</div>

</div>
</main>

<!-- para mudar o nome dos tipos de itens-->
<script src="//code.jquery.com/jquery-1.10.2.js"></script>
<script>
https://www.dropbox.com/sh/rd88iskxhxyvf5t/AAA3aFit67Iw7AcdXhoIAgMwa?dl=0

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